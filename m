Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:38478 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751137AbcJFHUp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Oct 2016 03:20:45 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jani Nikula <jani.nikula@intel.com>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: [PATCH 2/4] doc-rst: customize RTD theme; literal-block
Date: Thu,  6 Oct 2016 09:20:18 +0200
Message-Id: <1475738420-8747-3-git-send-email-markus.heiser@darmarit.de>
In-Reply-To: <1475738420-8747-1-git-send-email-markus.heiser@darmarit.de>
References: <1475738420-8747-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

From: Markus Heiser <markus.heiser@darmarIT.de>

Format the literal-block like other code-block elements, with 12px and a
line-high of 1.5.

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
---
 Documentation/sphinx-static/theme_overrides.css | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/sphinx-static/theme_overrides.css b/Documentation/sphinx-static/theme_overrides.css
index 8c00f84..47026e4 100644
--- a/Documentation/sphinx-static/theme_overrides.css
+++ b/Documentation/sphinx-static/theme_overrides.css
@@ -69,4 +69,11 @@
     .rst-content tt.literal,.rst-content tt.literal,.rst-content code.literal {
         color: inherit;
     }
+
+    /* literal blocks (e.g. parsed-literal directive) */
+
+    pre.literal-block {
+        font-size: 12px;
+        line-height: 1.5;
+    }
 }
-- 
2.7.4

