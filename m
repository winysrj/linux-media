Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:63191 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751918AbdJDL6c (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 07:58:32 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH v3 06/17] docs: kernel-doc.rst: add documentation about man pages
Date: Wed,  4 Oct 2017 08:48:44 -0300
Message-Id: <ee5069e449c701e8b19ef6d30d0bab4aa757089e.1507116877.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507116877.git.mchehab@s-opensource.com>
References: <cover.1507116877.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507116877.git.mchehab@s-opensource.com>
References: <cover.1507116877.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kernel-doc-nano-HOWTO.txt has a chapter about man pages
production. While we don't have a working  "make manpages"
target, add it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/doc-guide/kernel-doc.rst | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/Documentation/doc-guide/kernel-doc.rst b/Documentation/doc-guide/kernel-doc.rst
index 0923c8bd5769..96012f9e314d 100644
--- a/Documentation/doc-guide/kernel-doc.rst
+++ b/Documentation/doc-guide/kernel-doc.rst
@@ -452,3 +452,37 @@ file.
 
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
2.13.6
