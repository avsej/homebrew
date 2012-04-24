require 'formula'

class Libcouchbase < Formula
  homepage 'http://couchbase.com/develop/c/next'
  url 'http://packages.couchbase.com/clients/c/libcouchbase-1.1.0dp2.tar.gz'
  md5 '7acef20e71390511edccd542d1a85dbc'

  depends_on 'libevent'
  depends_on 'libvbucket'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-couchbasemock"
    system "make install"
  end

  def test
    system "#{bin}/cbc-version"
  end
end
