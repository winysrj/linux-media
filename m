Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41366 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275AbcGHNED (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:03 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 43/54] doc-rst: parse-headers: add an option to ignore enum symbols
Date: Fri,  8 Jul 2016 10:03:35 -0300
Message-Id: <526b88483183efa68ad692c473c1a434f4d2314d.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At videodev2.h, we have hundreds of symbols that don't
currently have a reference yet. Let's ignore for how, while
we don't improve those cross-refs.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/sphinx/parse-headers.pl | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/sphinx/parse-headers.pl b/Documentation/sphinx/parse-headers.pl
index fc18eac1552c..16ea28b0d2e1 100755
--- a/Documentation/sphinx/parse-headers.pl
+++ b/Documentation/sphinx/parse-headers.pl
@@ -163,6 +163,10 @@ if ($file_exceptions) {
 			delete $structs{$1} if (exists($structs{$1}));
 			next;
 		}
+		if (m/^ignore\s+symbol\s+(\S+)/) {
+			delete $enum_symbols{$1} if (exists($enum_symbols{$1}));
+			next;
+		}
 
 		# Parsers to replace a symbol
 
-- 
2.7.4

