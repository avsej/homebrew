require 'formula'

class Couchbase < Formula
  homepage 'http://couchbase.com'
  url 'http://builds.hq.northscale.net/latestbuilds/couchbase-server_src-2.0.0dp4r-722.tar.gz'
  md5 'b76e7ba8fdabe4d6e96c06ebf008361d'

  depends_on 'libevent'
  depends_on 'erlang'
  depends_on 'spidermonkey'
  depends_on 'icu4c'
  depends_on 'snappy'

  def patches
    DATA
  end

  def install
    ENV['DESTDIR'] = prefix
    system "make"
  end
end

__END__
diff --git a/Makefile b/Makefile
index 9157575..b80cfe9 100755
--- a/Makefile
+++ b/Makefile
@@ -9,7 +9,6 @@ COMPONENTS := bucket_engine \
 	libmemcached \
 	membase-cli \
 	memcached \
-	memcachetest \
 	moxi \
 	couchdb \
 	couchbase-examples \
diff --git a/couchdb/configure b/couchdb/configure
index b4ff26a..cdc6beb 100755
--- a/couchdb/configure
+++ b/couchdb/configure
@@ -16067,7 +16067,47 @@ if test "x$ac_cv_lib_js32_JS_NewContext" = x""yes; then :
   JS_LIB_BASE=js32
 else

-                as_fn_error "Could not find the js library.
+                { $as_echo "$as_me:${as_lineno-$LINENO}: checking for JS_NewContext in -lmozjs185" >&5
+$as_echo_n "checking for JS_NewContext in -lmozjs185... " >&6; }
+if test "${ac_cv_lib_mozjs185_JS_NewContext+set}" = set; then :
+  $as_echo_n "(cached) " >&6
+else
+  ac_check_lib_save_LIBS=$LIBS
+LIBS="-lmozjs185  $LIBS"
+cat confdefs.h - <<_ACEOF >conftest.$ac_ext
+/* end confdefs.h.  */
+
+/* Override any GCC internal prototype to avoid an error.
+   Use char because int might match the return type of a GCC
+   builtin and then its argument prototype would still apply.  */
+#ifdef __cplusplus
+extern "C"
+#endif
+char JS_NewContext ();
+int
+main ()
+{
+return JS_NewContext ();
+  ;
+  return 0;
+}
+_ACEOF
+if ac_fn_cxx_try_link "$LINENO"; then :
+  ac_cv_lib_mozjs185_JS_NewContext=yes
+else
+  ac_cv_lib_mozjs185_JS_NewContext=no
+fi
+rm -f core conftest.err conftest.$ac_objext \
+    conftest$ac_exeext conftest.$ac_ext
+LIBS=$ac_check_lib_save_LIBS
+fi
+{ $as_echo "$as_me:${as_lineno-$LINENO}: result: $ac_cv_lib_mozjs185_JS_NewContext" >&5
+$as_echo "$ac_cv_lib_mozjs185_JS_NewContext" >&6; }
+if test "x$ac_cv_lib_mozjs185_JS_NewContext" = x""yes; then :
+  JS_LIB_BASE=mozjs185
+else
+
+                    as_fn_error "Could not find the js library.

 Is the Mozilla SpiderMonkey library installed?" "$LINENO" 5
 fi
@@ -16078,6 +16118,8 @@ fi

 fi

+fi
+



diff --git a/couchdb/configure.ac b/couchdb/configure.ac
index f78ad42..937425b 100644
--- a/couchdb/configure.ac
+++ b/couchdb/configure.ac
@@ -202,9 +202,10 @@ AC_CHECK_LIB([mozjs], [JS_NewContext], [JS_LIB_BASE=mozjs], [
     AC_CHECK_LIB([js], [JS_NewContext], [JS_LIB_BASE=js], [
         AC_CHECK_LIB([js3250], [JS_NewContext], [JS_LIB_BASE=js3250], [
             AC_CHECK_LIB([js32], [JS_NewContext], [JS_LIB_BASE=js32], [
-                AC_MSG_ERROR([Could not find the js library.
+                AC_CHECK_LIB([mozjs185], [JS_NewContext], [JS_LIB_BASE=mozjs185], [
+                    AC_MSG_ERROR([Could not find the js library.

-Is the Mozilla SpiderMonkey library installed?])])])])])
+Is the Mozilla SpiderMonkey library installed?])])])])])])

 AC_SUBST(JS_LIB_BASE)

diff --git a/ep-engine/tapconnmap.hh b/ep-engine/tapconnmap.hh
index a88d670..de4f22e 100644
--- a/ep-engine/tapconnmap.hh
+++ b/ep-engine/tapconnmap.hh
@@ -10,6 +10,7 @@
 #include "queueditem.hh"
 #include "locks.hh"
 #include "syncobject.hh"
+#include "tapconnection.hh"

 // Forward declaration
 class TapConnection;
