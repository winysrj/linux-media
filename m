Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49450 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbcHPQZv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 12:25:51 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH 7/9] docs-rst: parse-heraders.pl: escape LaTeX characters
Date: Tue, 16 Aug 2016 13:25:41 -0300
Message-Id: <fe569e0786e3b2e2b4001c319312b53f2cad2402.1471364025.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471364025.git.mchehab@s-opensource.com>
References: <cover.1471364025.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471364025.git.mchehab@s-opensource.com>
References: <cover.1471364025.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Let's escape the LaTeX characters, to avoid troubles when
outputing them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/sphinx/parse-headers.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/sphinx/parse-headers.pl b/Documentation/sphinx/parse-headers.pl
index 34bd9e2630b0..74089b0da798 100755
--- a/Documentation/sphinx/parse-headers.pl
+++ b/Documentation/sphinx/parse-headers.pl
@@ -220,7 +220,7 @@ $data =~ s/\n\s+\n/\n\n/g;
 #
 # Add escape codes for special characters
 #
-$data =~ s,([\_\`\*\<\>\&\\\\:\/\|]),\\$1,g;
+$data =~ s,([\_\`\*\<\>\&\\\\:\/\|\%\$\#\{\}\~\^]),\\$1,g;
 
 $data =~ s,DEPRECATED,**DEPRECATED**,g;
 
-- 
2.7.4


