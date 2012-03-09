Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:54868 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab2CIMON (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Mar 2012 07:14:13 -0500
From: Vaibhav Hiremath <hvaibhav@ti.com>
To: <linux-media@vger.kernel.org>
CC: <mchehab@infradead.org>, <archit@ti.com>,
	<laurent.pinchart@ideasonboard.com>, <linux-omap@vger.kernel.org>,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH] omap_vout: Fix the build warning and section miss-match warning
Date: Fri, 9 Mar 2012 17:44:03 +0530
Message-ID: <1331295243-2191-1-git-send-email-hvaibhav@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch fixes below build warning and section miss-match warning 
from omap_vout driver -

Build warnings:
=============
drivers/media/video/omap/omap_vout.c: In function 'omapvid_setup_overlay':
drivers/media/video/omap/omap_vout.c:381:17: warning: 'mode' may be used
uninitialized in this function

Section Mis-Match warnings:
==========================
WARNING: drivers/media/video/omap/omap-vout.o(.data+0x0): Section mismatch in
reference from the variable
omap_vout_driver to the function .init.text:omap_vout_probe()
The variable omap_vout_driver references
the function __init omap_vout_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/omap/omap_vout.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index dffcf66..0fb0437 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -328,7 +328,7 @@ static int video_mode_to_dss_mode(struct omap_vout_device *vout)
 	struct omap_overlay *ovl;
 	struct omapvideo_info *ovid;
 	struct v4l2_pix_format *pix = &vout->pix;
-	enum omap_color_mode mode;
+	enum omap_color_mode mode = -EINVAL;

 	ovid = &vout->vid_info;
 	ovl = ovid->overlays[0];
@@ -2108,7 +2108,7 @@ static void omap_vout_cleanup_device(struct omap_vout_device *vout)
 	kfree(vout);
 }

-static int omap_vout_remove(struct platform_device *pdev)
+static int __devexit omap_vout_remove(struct platform_device *pdev)
 {
 	int k;
 	struct v4l2_device *v4l2_dev = platform_get_drvdata(pdev);
@@ -2129,7 +2129,7 @@ static int omap_vout_remove(struct platform_device *pdev)
 	return 0;
 }

-static int __init omap_vout_probe(struct platform_device *pdev)
+static int __devinit omap_vout_probe(struct platform_device *pdev)
 {
 	int ret = 0, i;
 	struct omap_overlay *ovl;
@@ -2241,9 +2241,10 @@ probe_err0:
 static struct platform_driver omap_vout_driver = {
 	.driver = {
 		.name = VOUT_NAME,
+		.owner = THIS_MODULE,
 	},
 	.probe = omap_vout_probe,
-	.remove = omap_vout_remove,
+	.remove = __devexit_p(omap_vout_remove),
 };

 static int __init omap_vout_init(void)
--
1.7.0.4

