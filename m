Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41281 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbcGHND7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:03:59 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 08/54] doc-rst: customize RTD theme, captions & inline literal
Date: Fri,  8 Jul 2016 10:03:00 -0300
Message-Id: <4eb40f14dc984f1e58d7727c5761e1ef40700953.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

The layout of (table) captions in the RTD theme is a bit ugly and the
bordered, red colored of inline literals is a bit to gaudy. The
requirements has been discussed in the ML [1].

captions:

  - captions should have 100% (not 85%) font size
  - hide the permalink symbol as long as link is not hovered

inline literal:

  - drop the borderbox and red color

[1] http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/101099

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/sphinx-static/theme_overrides.css | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/Documentation/sphinx-static/theme_overrides.css b/Documentation/sphinx-static/theme_overrides.css
index ea06799214fd..c97d8428302d 100644
--- a/Documentation/sphinx-static/theme_overrides.css
+++ b/Documentation/sphinx-static/theme_overrides.css
@@ -25,4 +25,29 @@
     .wy-table-responsive { overflow: auto; }
     .rst-content table.docutils caption { text-align: left; font-size: 100%; }
 
+    /* captions:
+     *
+     *   - captions should have 100% (not 85%) font size
+     *   - hide the permalink symbol as long as link is not hovered
+     */
+
+    caption, .wy-table caption, .rst-content table.field-list caption {
+        font-size: 100%;
+    }
+    caption a.headerlink { opacity: 0; }
+    caption a.headerlink:hover { opacity: 1; }
+
+    /* inline literal: drop the borderbox and red color */
+
+    code, .rst-content tt, .rst-content code {
+        color: inherit;
+        border: none;
+        background: inherit;
+        font-size: 85%;
+    }
+
+    .rst-content tt.literal,.rst-content tt.literal,.rst-content code.literal {
+        color: inherit;
+    }
+
 }
-- 
2.7.4

