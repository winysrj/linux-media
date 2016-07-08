Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41354 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245AbcGHNEC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:02 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 44/54] doc-rst: parse-headers: don't do substituition references
Date: Fri,  8 Jul 2016 10:03:36 -0300
Message-Id: <153234c47c8b260ed92a56e9f7d6c91eb6785aa8.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add one extra escape character to avoid those warnings:
	Documentation/linux_tv/videodev2.h.rst:6: WARNING: Inline substitution_reference start-string without end-string.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/sphinx/parse-headers.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/sphinx/parse-headers.pl b/Documentation/sphinx/parse-headers.pl
index 16ea28b0d2e1..0a3703bef5eb 100755
--- a/Documentation/sphinx/parse-headers.pl
+++ b/Documentation/sphinx/parse-headers.pl
@@ -220,7 +220,7 @@ $data =~ s/\n\s+\n/\n\n/g;
 #
 # Add escape codes for special characters
 #
-$data =~ s,([\_\`\*\<\>\&\\\\:\/]),\\$1,g;
+$data =~ s,([\_\`\*\<\>\&\\\\:\/\|]),\\$1,g;
 
 $data =~ s,DEPRECATED,**DEPRECATED**,g;
 
-- 
2.7.4

