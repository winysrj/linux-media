Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:59502 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759486AbcHEJUE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Aug 2016 05:20:04 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	linux-media@vger.kernel.org
Subject: [PATCH] doc-rst: customize RTD theme, drop padding of inline literal
Date: Fri,  5 Aug 2016 11:19:43 +0200
Message-Id: <1470388783-5200-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

Remove the distracting (left/right) padding of inline literals. (HTML
<code>). Requested and discussed in [1].

[1] http://www.spinics.net/lists/linux-media/msg103991.html

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
---
 Documentation/sphinx-static/theme_overrides.css | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/sphinx-static/theme_overrides.css b/Documentation/sphinx-static/theme_overrides.css
index 3a2ac4b..e88461c 100644
--- a/Documentation/sphinx-static/theme_overrides.css
+++ b/Documentation/sphinx-static/theme_overrides.css
@@ -42,11 +42,12 @@
     caption a.headerlink { opacity: 0; }
     caption a.headerlink:hover { opacity: 1; }
 
-    /* inline literal: drop the borderbox and red color */
+    /* inline literal: drop the borderbox, padding and red color */
 
     code, .rst-content tt, .rst-content code {
         color: inherit;
         border: none;
+        padding: unset;
         background: inherit;
         font-size: 85%;
     }
-- 
2.7.4

