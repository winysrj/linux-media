Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41378 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277AbcGHNED (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:03 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 42/54] doc-rst: parse-headers: better handle comments at the source code
Date: Fri,  8 Jul 2016 10:03:34 -0300
Message-Id: <034e6c8e72afe0106e7ad3c19941053072b6a994.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We should not let comments to mangle with the symbols
parsing. Unfortunately, videodev2.h has lots of those
in the middle of enums and structs. So, we need to improve
our parser to discard them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/sphinx/parse-headers.pl | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/Documentation/sphinx/parse-headers.pl b/Documentation/sphinx/parse-headers.pl
index b703f1a7f432..fc18eac1552c 100755
--- a/Documentation/sphinx/parse-headers.pl
+++ b/Documentation/sphinx/parse-headers.pl
@@ -27,13 +27,24 @@ my %structs;
 #
 
 my $is_enum = 0;
+my $is_comment = 0;
 open IN, $file_in or die "Can't open $file_in";
 while (<IN>) {
-	my $ln = $_;
-	$ln =~ s,/\*.*\*/,,;
-
 	$data .= $_;
 
+	my $ln = $_;
+	if (!$is_comment) {
+		$ln =~ s,/\*.*(\*/),,g;
+
+		$is_comment = 1 if ($ln =~ s,/\*.*,,);
+	} else {
+		if ($ln =~ s,^(.*\*/),,) {
+			$is_comment = 0;
+		} else {
+			next;
+		}
+	}
+
 	if ($is_enum && $ln =~ m/^\s*([_\w][\w\d_]+)\s*[\,=]?/) {
 		my $s = $1;
 		my $n = $1;
-- 
2.7.4

