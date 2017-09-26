Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55740
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S969483AbdIZR72 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 13:59:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 07/10] docs: kernel-doc.rst: add documentation about man pages
Date: Tue, 26 Sep 2017 14:59:17 -0300
Message-Id: <f5f708ba091ff23cad849779d66b1e3a7badb5c6.1506448061.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506448061.git.mchehab@s-opensource.com>
References: <cover.1506448061.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506448061.git.mchehab@s-opensource.com>
References: <cover.1506448061.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kernel-doc-nano-HOWTO.txt has a chapter about man pages
production. While we don't have a working  "make manpages"
target, add it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/doc-guide/kernel-doc.rst | 61 ++++++++++++++++++++++++++--------
 1 file changed, 47 insertions(+), 14 deletions(-)

diff --git a/Documentation/doc-guide/kernel-doc.rst b/Documentation/doc-guide/kernel-doc.rst
index 9777aa53e3dd..50473f0db345 100644
--- a/Documentation/doc-guide/kernel-doc.rst
+++ b/Documentation/doc-guide/kernel-doc.rst
@@ -377,7 +377,6 @@ cross-references.
 For further details, please refer to the `Sphinx C Domain`_ documentation.
 
 
-
 In-line member documentation comments
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
@@ -391,19 +390,19 @@ on a line of their own, like all other kernel-doc comments::
    * @foo: The Foo member.
    */
   struct foo {
-        int foo;
-        /**
-         * @bar: The Bar member.
-         */
-        int bar;
-        /**
-         * @baz: The Baz member.
-         *
-         * Here, the member description may contain several paragraphs.
-         */
-        int baz;
-        /** @foobar: Single line description. */
-        int foobar;
+	int foo;
+	/**
+	 * @bar: The Bar member.
+	 */
+	int bar;
+	/**
+	 * @baz: The Baz member.
+	 *
+	 * Here, the member description may contain several paragraphs.
+	 */
+	int baz;
+	/** @foobar: Single line description. */
+	int foobar;
   }
 
 
@@ -452,3 +451,37 @@ file.
 
 Data structures visible in kernel include files should also be documented using
 kernel-doc formatted comments.
+
+How to use kernel-doc to generate man pages
+-------------------------------------------
+
+If you just want to use kernel-doc to generate man pages you can do this
+from the Kernel git tree::
+
+  $ scripts/kernel-doc -man $(git grep -l '/\*\*' |grep -v Documentation/) | ./split-man.pl /tmp/man
+
+Using the small ``split-man.pl`` script below::
+
+
+  #!/usr/bin/perl
+
+  if ($#ARGV < 0) {
+     die "where do I put the results?\n";
+  }
+
+  mkdir $ARGV[0],0777;
+  $state = 0;
+  while (<STDIN>) {
+      if (/^\.TH \"[^\"]*\" 9 \"([^\"]*)\"/) {
+	if ($state == 1) { close OUT }
+	$state = 1;
+	$fn = "$ARGV[0]/$1.9";
+	print STDERR "Creating $fn\n";
+	open OUT, ">$fn" or die "can't open $fn: $!\n";
+	print OUT $_;
+      } elsif ($state != 0) {
+	print OUT $_;
+      }
+  }
+
+  close OUT;
-- 
2.13.5
