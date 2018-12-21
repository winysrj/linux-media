Return-Path: <SRS0=g7QC=O6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB957C43387
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 01:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7F1B218E0
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 01:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545355181;
	bh=Xh3KpJCTdqxj3scIi4cEDHdR1UqNfPBIZHB31JVxXzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=B3mGVsZ5y8/1E8EhinvRzF3uSHMgWjpkxwEMdoOtjBKvTt6nEyeUUkkD7Q/l+D+Rh
	 Vnl/DoKU/vCELMJhfxBVe1UpCJjtOrK0tqnS5VCsxuThyLLRuUBI6sPHxeSTA8DTpr
	 hTAt3XDKavZNjnbLgzYLoIZMxElsx3CAXLm6o+dg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388791AbeLUBS3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 20 Dec 2018 20:18:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:37434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388729AbeLUBS1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Dec 2018 20:18:27 -0500
Received: from mail.kernel.org (unknown [185.216.33.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE51E218E0;
        Fri, 21 Dec 2018 01:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545355107;
        bh=Xh3KpJCTdqxj3scIi4cEDHdR1UqNfPBIZHB31JVxXzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rcScYlhoQHhPJ7ctOPkew6qst/ED3apy3BMLa+PVddFC5bIOSGtZTLXRxSFkhg8lv
         2laA9vKTDhdw7axM9tZrJKnzJGnbDgqLfZvv2Y4EnUB+wEuYKUCRaEVIgzhq2+fEE7
         7/x9Qc0aLWjd8w2NfJPn5TXl4ldHPWs7mo+8P8OU=
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
Subject: [PATCH 08/14] media: wl128x-radio: use device managed memory allocation
Date:   Fri, 21 Dec 2018 02:17:46 +0100
Message-Id: <20181221011752.25627-9-sre@kernel.org>
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

This simplifies memory allocation and removes a few useless
errors in case of -ENOMEM errors.

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
---
 drivers/media/radio/wl128x/fmdrv_common.c | 41 +++++++----------------
 1 file changed, 13 insertions(+), 28 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index 9526613adf91..3f189d093eeb 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -1614,55 +1614,40 @@ int fmc_release(struct fmdev *fmdev)
 	return ret;
 }
 
-static int wl128x_fm_probe(struct platform_device *dev)
+static int wl128x_fm_probe(struct platform_device *pdev)
 {
-	struct fmdev *fmdev = NULL;
-	int ret = -ENOMEM;
-
-	fmdbg("FM driver\n");
+	struct fmdev *fmdev;
+	int ret;
 
 	/* Allocate memory for FM driver context and RX RDS buffer. */
-	fmdev = kzalloc(sizeof(struct fmdev), GFP_KERNEL);
-	if (NULL == fmdev) {
-		fmerr("Can't allocate operation structure memory\n");
-		return ret;
-	}
+	fmdev = devm_kzalloc(&pdev->dev, sizeof(*fmdev), GFP_KERNEL);
+	if (!fmdev)
+		return -ENOMEM;
+	platform_set_drvdata(pdev, fmdev);
+
 	fmdev->rx.rds.buf_size = default_rds_buf * FM_RDS_BLK_SIZE;
-	fmdev->rx.rds.buff = kzalloc(fmdev->rx.rds.buf_size, GFP_KERNEL);
-	if (NULL == fmdev->rx.rds.buff) {
-		fmerr("Can't allocate rds ring buffer\n");
-		goto rel_dev;
-	}
+	fmdev->rx.rds.buff = devm_kzalloc(&pdev->dev, fmdev->rx.rds.buf_size, GFP_KERNEL);
+	if (!fmdev->rx.rds.buff)
+		return -ENOMEM;
 
 	/* Ask FM V4L module to register video device. */
 	ret = fm_v4l2_init_video_device(fmdev, radio_nr);
 	if (ret < 0)
-		goto rel_rdsbuf;
+		return ret;
 
 	fmdev->irq_info.handlers = int_handler_table;
 	fmdev->curr_fmmode = FM_MODE_OFF;
 	fmdev->tx_data.pwr_lvl = FM_PWR_LVL_DEF;
 	fmdev->tx_data.preemph = FM_TX_PREEMPH_50US;
 	return ret;
-
-rel_rdsbuf:
-	kfree(fmdev->rx.rds.buff);
-rel_dev:
-	kfree(fmdev);
-
-	return ret;
 }
 
-static int wl128x_fm_remove(struct platform_device *dev)
+static int wl128x_fm_remove(struct platform_device *pdev)
 {
 	struct fmdev *fmdev = platform_get_drvdata(pdev);
 
 	/* Ask FM V4L module to unregister video device */
 	fm_v4l2_deinit_video_device(fmdev);
-	if (fmdev != NULL) {
-		kfree(fmdev->rx.rds.buff);
-		kfree(fmdev);
-	}
 
 	return 0;
 }
-- 
2.19.2

