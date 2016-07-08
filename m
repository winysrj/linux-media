Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41285 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbcGHND7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:03:59 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 07/54] doc-rst: customize RTD theme, table & full width
Date: Fri,  8 Jul 2016 10:02:59 -0300
Message-Id: <9abaf979abb2845b2292d96401986b4845c51b9d.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

The default table layout of the RTD theme does not fit for vast tables,
like the ones we have in the linux_tv project. This has been discussed
on the ML [1].

The RTD theme is a two column layout, with a navigation column on the
left and a content column on the right:

content column

 RTD theme's default is 800px as max width for the content, but we have
 tables with tons of columns, which need the full width of the
 view-port (BTW: *full width* is what DocBook's HTML is).

table

   - sequences of whitespace should collapse into a single whitespace.
   - make the overflow auto (scrollbar if needed)
   - align caption "left" ("center" is unsuitable on vast tables)

[1] http://article.gmane.org/gmane.linux.kernel/2216509

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/sphinx-static/theme_overrides.css | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/Documentation/sphinx-static/theme_overrides.css b/Documentation/sphinx-static/theme_overrides.css
index 4d670dbf7ffa..ea06799214fd 100644
--- a/Documentation/sphinx-static/theme_overrides.css
+++ b/Documentation/sphinx-static/theme_overrides.css
@@ -1,9 +1,28 @@
 /* -*- coding: utf-8; mode: css -*-
  *
- * Sphinx HTML theme customization
+ * Sphinx HTML theme customization: read the doc
  *
  */
 
 @media screen {
 
+    /* content column
+     *
+     * RTD theme's default is 800px as max width for the content, but we have
+     * tables with tons of columns, which need the full width of the view-port.
+     */
+
+    .wy-nav-content{max-width: none; }
+
+    /* table:
+     *
+     *   - Sequences of whitespace should collapse into a single whitespace.
+     *   - make the overflow auto (scrollbar if needed)
+     *   - align caption "left" ("center" is unsuitable on vast tables)
+     */
+
+    .wy-table-responsive table td { white-space: normal; }
+    .wy-table-responsive { overflow: auto; }
+    .rst-content table.docutils caption { text-align: left; font-size: 100%; }
+
 }
-- 
2.7.4

