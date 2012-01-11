require 'formula'

class Libcouchbase < Formula
  url 'https://github.com/downloads/avsej/libcouchbase/libcouchbase-0.3.0_80_geb7c70c.tar.gz'
  homepage 'https://github.com/couchbase/libcouchbase'
  md5 'de7e73d2fe553b07e6cfa91d42a43cc5'

  depends_on 'libvbucket'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--disable-couchbasemock",
      "--with-memcached-headers-url=https://raw.github.com/membase/memcached/engine/include/memcached"
    system "make install"
  end

  def test
    # check if it returns code is zero
    system "#{bin}/cbc-version"
  end
end
