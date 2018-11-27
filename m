Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56324 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729740AbeK0Tzo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 14:55:44 -0500
From: bingbu.cao@intel.com
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, tfiga@chromium.org,
        andy.yeh@intel.com, bingbu.cao@linux.intel.com,
        luca@lucaceresoli.net
Subject: [PATCH v2] media: unify some sony camera sensors pattern naming
Date: Tue, 27 Nov 2018 17:03:26 +0800
Message-Id: <1543309406-611-1-git-send-email-bingbu.cao@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Bingbu Cao <bingbu.cao@intel.com>

Some Sony camera sensors have same pattern
definitions, this patch unify the pattern naming
to make it more clear to the userspace.

Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
Reviewed-by: luca@lucaceresoli.net
---
 drivers/media/i2c/imx258.c | 6 +++---
 drivers/media/i2c/imx319.c | 8 ++++----
 drivers/media/i2c/imx355.c | 8 ++++----
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c
index 31a1e2294843..de399f69dc9b 100644
--- a/drivers/media/i2c/imx258.c
+++ b/drivers/media/i2c/imx258.c
@@ -504,10 +504,10 @@ struct imx258_mode {
 
 static const char * const imx258_test_pattern_menu[] = {
 	"Disabled",
-	"Color Bars",
 	"Solid Color",
-	"Grey Color Bars",
-	"PN9"
+	"Eight Vertical Color Bars",
+	"Color Bars With Fade to Grey",
+	"Pseudorandom Sequence (PN9)",
 };
 
 static const int imx258_test_pattern_val[] = {
diff --git a/drivers/media/i2c/imx319.c b/drivers/media/i2c/imx319.c
index acd988d2d7f1..c508887c4574 100644
--- a/drivers/media/i2c/imx319.c
+++ b/drivers/media/i2c/imx319.c
@@ -1648,10 +1648,10 @@ struct imx319 {
 
 static const char * const imx319_test_pattern_menu[] = {
 	"Disabled",
-	"Solid color",
-	"100% color bars",
-	"Fade to gray color bars",
-	"PN9"
+	"Solid Color",
+	"Eight Vertical Color Bars",
+	"Color Bars With Fade to Grey",
+	"Pseudorandom Sequence (PN9)",
 };
 
 /* supported link frequencies */
diff --git a/drivers/media/i2c/imx355.c b/drivers/media/i2c/imx355.c
index 9c9559dfd3dd..608947dc1a65 100644
--- a/drivers/media/i2c/imx355.c
+++ b/drivers/media/i2c/imx355.c
@@ -876,10 +876,10 @@ struct imx355 {
 
 static const char * const imx355_test_pattern_menu[] = {
 	"Disabled",
-	"Solid color",
-	"100% color bars",
-	"Fade to gray color bars",
-	"PN9"
+	"Solid Color",
+	"Eight Vertical Color Bars",
+	"Color Bars With Fade to Grey",
+	"Pseudorandom Sequence (PN9)",
 };
 
 /* supported link frequencies */
-- 
1.9.1
