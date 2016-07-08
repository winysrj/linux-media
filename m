Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41435 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368AbcGHNEF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:05 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 36/54] doc-rst: parse-headers: fix multiline typedef handler
Date: Fri,  8 Jul 2016 10:03:28 -0300
Message-Id: <4ff916a0c901559d4913bfdb2e5f676c9856b969.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The typedef handler should do two things to be generic:
  1) parse typedef enums;
  2) accept both possible syntaxes:
	 typedef struct foo { .. } foo_t;
	 typedef struct { .. } foo_t;

Unfortunately, this is needed to parse some legacy DVB
files, like dvb/audio.h.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/sphinx/parse-headers.pl | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/sphinx/parse-headers.pl b/Documentation/sphinx/parse-headers.pl
index b657cadb53ae..b703f1a7f432 100755
--- a/Documentation/sphinx/parse-headers.pl
+++ b/Documentation/sphinx/parse-headers.pl
@@ -109,10 +109,11 @@ close IN;
 # Handle multi-line typedefs
 #
 
-my @matches = $data =~ m/typedef\s+struct\s+\S+\s*\{[^\}]+\}\s*(\S+)\s*\;/g;
+my @matches = ($data =~ m/typedef\s+struct\s+\S+?\s*\{[^\}]+\}\s*(\S+)\s*\;/g,
+	       $data =~ m/typedef\s+enum\s+\S+?\s*\{[^\}]+\}\s*(\S+)\s*\;/g,);
 foreach my $m (@matches) {
-		my $s = $1;
-		my $n = $1;
+		my $s = $m;
+		my $n = $m;
 		$n =~ tr/A-Z/a-z/;
 		$n =~ tr/_/-/;
 
-- 
2.7.4

