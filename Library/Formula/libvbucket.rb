require 'formula'

class Libvbucket < Formula
  url 'https://github.com/downloads/avsej/libvbucket/libvbucket-1.8.1r_3_g708c728.tar.gz'
  homepage 'https://github.com/membase/libvbucket'
  md5 '48d8aa644b055d1adea6ac9f6c6b8c7c'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--without-docs"
    system "make install"
  end

  def test
    test_json = '{"hashAlgorithm":"CRC","numReplicas":2,"serverList":["server1:11211","server2:11210","server3:11211"],"vBucketMap":[[0,1,2],[1,2,0],[2,1,-1],[1,2,0]]}'
    expected = <<OUT
key: hello master: server1:11211 vBucketId: 0 couchApiBase: (null) replicas: server2:11210 server3:11211
key: world master: server2:11210 vBucketId: 3 couchApiBase: (null) replicas: server3:11211 server1:11211
OUT
    `echo '#{test_json}' | #{bin}/vbuckettool - hello world` == expected
  end
end
