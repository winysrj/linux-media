Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41476 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383AbcGHNEF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:05 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 35/54] doc-rst: parse-headers: better handle typedefs
Date: Fri,  8 Jul 2016 10:03:27 -0300
Message-Id: <6c4c7dadb4a1bb82d04d6c5096656f8fe63ba2a4.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When typedef is used on its multiline format, we need to
also parse enum and struct in the same line.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/sphinx/parse-headers.pl | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/sphinx/parse-headers.pl b/Documentation/sphinx/parse-headers.pl
index 5e366756084f..b657cadb53ae 100755
--- a/Documentation/sphinx/parse-headers.pl
+++ b/Documentation/sphinx/parse-headers.pl
@@ -76,7 +76,9 @@ while (<IN>) {
 		next;
 	}
 	if ($ln =~ m/^\s*enum\s+([_\w][\w\d_]+)\s+\{/
-	    || $ln =~ m/^\s*enum\s+([_\w][\w\d_]+)$/) {
+	    || $ln =~ m/^\s*enum\s+([_\w][\w\d_]+)$/
+	    || $ln =~ m/^\s*typedef\s*enum\s+([_\w][\w\d_]+)\s+\{/
+	    || $ln =~ m/^\s*typedef\s*enum\s+([_\w][\w\d_]+)$/) {
 		my $s = $1;
 		my $n = $1;
 		$n =~ tr/A-Z/a-z/;
@@ -88,7 +90,10 @@ while (<IN>) {
 		next;
 	}
 	if ($ln =~ m/^\s*struct\s+([_\w][\w\d_]+)\s+\{/
-	    || $ln =~ m/^\s*struct\s+([[_\w][\w\d_]+)$/) {
+	    || $ln =~ m/^\s*struct\s+([[_\w][\w\d_]+)$/
+	    || $ln =~ m/^\s*typedef\s*struct\s+([_\w][\w\d_]+)\s+\{/
+	    || $ln =~ m/^\s*typedef\s*struct\s+([[_\w][\w\d_]+)$/
+	    ) {
 		my $s = $1;
 		my $n = $1;
 		$n =~ tr/A-Z/a-z/;
-- 
2.7.4

