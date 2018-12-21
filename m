Return-Path: <SRS0=g7QC=O6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D574C43612
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 01:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B4FF218E0
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 01:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545355184;
	bh=+Bt4mMi8YqMYFjKJbypQUlvKkRIjSTGbKPlFNh58u9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=SdJm/Dvn3ZEsj36O9PwDbXs7SpY/FLrRdbbWj/69kt9VRhrSgDhAPanZAw8eo5yaU
	 EE7IgNZYByVM0VxQuKP/Z/h58mzzNiBXjJ8DMo0ClHPbV0lxznMxZxVGAIRrbY+XOO
	 zqVTgItX5S/BZUEidugGx0y1fIBUoo6LHCHhvC/Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388138AbeLUBTn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 20 Dec 2018 20:19:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:37378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388680AbeLUBSZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Dec 2018 20:18:25 -0500
Received: from mail.kernel.org (unknown [185.216.33.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2602521904;
        Fri, 21 Dec 2018 01:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545355104;
        bh=+Bt4mMi8YqMYFjKJbypQUlvKkRIjSTGbKPlFNh58u9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pt33fX5REvws5Bc9lx5yt6hqdH4nzdKepGUjObe12bqylEqjNhZAf/qvrGPYUF0nJ
         Wwy1WtcxecM6iV8/gQScWTuIQ0Y1IhI2wjVVlVRAkMg1b7oEqthamoypXmjSU/h/Jq
         jmIzhTt5cXPMMxql5TN19woePwUGklT0Sr67whYw=
From:   Sebastian Reichel <sre@kernel.org>
To:     Sebastian Reichel <sre@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Tony Lindgren <tony@atomide.com>
Cc:     Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@ucw.cz>, linux-bluetooth@vger.kernel.org,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 07/14] media: wl128x-radio: convert to platform device
Date:   Fri, 21 Dec 2018 02:17:45 +0100
Message-Id: <20181221011752.25627-8-sre@kernel.org>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181221011752.25627-1-sre@kernel.org>
References: <20181221011752.25627-1-sre@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Sebastian Reichel <sebastian.reichel@collabora.com>

This converts the wl128x FM radio module into a platform device.
It's a preparation for using it from hci_ll Bluetooth driver instead
of TI_ST.

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
---
 drivers/media/radio/wl128x/fmdrv_common.c | 30 ++++++++++++-----------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index f77acec0addf..9526613adf91 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -35,11 +35,10 @@
 #include "fmdrv_v4l2.h"
 #include "fmdrv_common.h"
 #include <linux/ti_wilink_st.h>
+#include <linux/platform_device.h>
 #include "fmdrv_rx.h"
 #include "fmdrv_tx.h"
 
-struct fmdev *global_fmdev;
-
 /* Region info */
 static struct region_info region_configs[] = {
 	/* Europe/US */
@@ -1615,23 +1614,19 @@ int fmc_release(struct fmdev *fmdev)
 	return ret;
 }
 
-/*
- * Module init function. Ask FM V4L module to register video device.
- * Allocate memory for FM driver context and RX RDS buffer.
- */
-static int __init fm_drv_init(void)
+static int wl128x_fm_probe(struct platform_device *dev)
 {
 	struct fmdev *fmdev = NULL;
 	int ret = -ENOMEM;
 
 	fmdbg("FM driver\n");
 
+	/* Allocate memory for FM driver context and RX RDS buffer. */
 	fmdev = kzalloc(sizeof(struct fmdev), GFP_KERNEL);
 	if (NULL == fmdev) {
 		fmerr("Can't allocate operation structure memory\n");
 		return ret;
 	}
-	global_fmdev = fmdev;
 	fmdev->rx.rds.buf_size = default_rds_buf * FM_RDS_BLK_SIZE;
 	fmdev->rx.rds.buff = kzalloc(fmdev->rx.rds.buf_size, GFP_KERNEL);
 	if (NULL == fmdev->rx.rds.buff) {
@@ -1639,6 +1634,7 @@ static int __init fm_drv_init(void)
 		goto rel_dev;
 	}
 
+	/* Ask FM V4L module to register video device. */
 	ret = fm_v4l2_init_video_device(fmdev, radio_nr);
 	if (ret < 0)
 		goto rel_rdsbuf;
@@ -1657,10 +1653,9 @@ static int __init fm_drv_init(void)
 	return ret;
 }
 
-/* Module exit function. Ask FM V4L module to unregister video device */
-static void __exit fm_drv_exit(void)
+static int wl128x_fm_remove(struct platform_device *dev)
 {
-	struct fmdev *fmdev = global_fmdev;
+	struct fmdev *fmdev = platform_get_drvdata(pdev);
 
 	/* Ask FM V4L module to unregister video device */
 	fm_v4l2_deinit_video_device(fmdev);
@@ -1668,12 +1663,19 @@ static void __exit fm_drv_exit(void)
 		kfree(fmdev->rx.rds.buff);
 		kfree(fmdev);
 	}
+
+	return 0;
 }
 
-module_init(fm_drv_init);
-module_exit(fm_drv_exit);
+static struct platform_driver wl128x_fm_drv = {
+	.driver	= {
+		.name	= "wl128x-fm",
+	},
+	.probe		= wl128x_fm_probe,
+	.remove		= wl128x_fm_remove,
+};
+module_platform_driver(wl128x_fm_drv);
 
-/* ------------- Module Info ------------- */
 MODULE_AUTHOR("Manjunatha Halli <manjunatha_halli@ti.com>");
 MODULE_DESCRIPTION("FM Driver for TI's Connectivity chip");
 MODULE_LICENSE("GPL");
-- 
2.19.2

