Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43780 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941742AbcIHMES (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 02/47] docs-rst: parse-headers.pl: make debug a command line option
Date: Thu,  8 Sep 2016 09:03:24 -0300
Message-Id: <3319e6af28550dd76a7e9c725e0d13b842343048.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a parser for the --debug option, in order to allow
seeing what the parser is doing.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/sphinx/parse-headers.pl | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/Documentation/sphinx/parse-headers.pl b/Documentation/sphinx/parse-headers.pl
index 74089b0da798..531c710fc73f 100755
--- a/Documentation/sphinx/parse-headers.pl
+++ b/Documentation/sphinx/parse-headers.pl
@@ -2,12 +2,18 @@
 use strict;
 use Text::Tabs;
 
-# Uncomment if debug is needed
-#use Data::Dumper;
-
-# change to 1 to generate some debug prints
 my $debug = 0;
 
+while ($ARGV[0] =~ m/^-(.*)/) {
+	my $cmd = shift @ARGV;
+	if ($cmd eq "--debug") {
+		require Data::Dumper;
+		$debug = 1;
+		next;
+	}
+	die "argument $cmd unknown";
+}
+
 if (scalar @ARGV < 2 || scalar @ARGV > 3) {
 	die "Usage:\n\t$0 <file in> <file out> [<exceptions file>]\n";
 }
-- 
2.7.4


