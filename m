Return-Path: <SRS0=mDsK=O7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB21C43387
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 17:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B98C21A4B
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 17:13:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AHZ9uZMU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391067AbeLVRN2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 22 Dec 2018 12:13:28 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44974 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbeLVRN1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Dec 2018 12:13:27 -0500
Received: by mail-pg1-f195.google.com with SMTP id t13so3895258pgr.11;
        Sat, 22 Dec 2018 09:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sktwIPbqTZBgfFsDRT6a/Dd/ZTsQqnw8DaMIY5lyDO0=;
        b=AHZ9uZMUFjzestiO2Gj6ZPzNOD2eTVjWx6R4tTmruvqUVptmxTcoEDDG3XXQmSRiwg
         hINANCbKKh1+lKNz2iiAEwZQhtlvRFojVUh/8SyrVn7/r92VZR1kn/cChD1ny1umHr5q
         sf7ZuyG8V8WVm237DivdWbHtV05X907zmflXxRhjWenmKsBuJF4B54RbJDWcEllyvvQP
         Fz35NBy3WkzjjmePp2pEyxYggnhc3WJTZRmHnq40B93cWJIIbqt2Rx4cKH4Wewo4ldwY
         tcQO91p1nuEJZCg9RC5tPT/BdQb5L6WWShmfPH1D6wkcHQJesllOONvZD+qIzR0X+MbF
         kbyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sktwIPbqTZBgfFsDRT6a/Dd/ZTsQqnw8DaMIY5lyDO0=;
        b=WRUdimqlvpV3UkpX9sskmZZZYV4B34YFl0dqc1txO0QO2pI5QeaXB07HLT7UtnIOsH
         67Q6NsoSHjKk9B0+ziYzbTGmKoKWOIUSi9KnpN8SCmj/Z6t/W02POwuSNZ+vHi401DTq
         RaScNgVr8FeLzMUU6c6wVPBZdYuyp/Mc93llicjjDftjySRuu7P2Ut/z3UD9VrHP78F+
         i2uonmX3SVL3aY/fXZ1a2pVSACvoCLyhvIzcYNXLPWSES487MItukp4Pb2yjBxjh/ndv
         fsWYIII/aKMUrjAkD4y8ILp0ij4MJcqUqf6HW97aHa4/+x8SBP9r+K4tt7qLN5xo8YgN
         vB0A==
X-Gm-Message-State: AJcUukeClwkhSR+ltPfvzTOSdDfcYmoYUwqo9Z+X0tM4EOAQ+0qODM91
        +TT31/dy5cdNtbRIyHDYnExtqKU9/sw=
X-Google-Smtp-Source: ALg8bN5oiQGzmEOOSzn0bJMf8WvLv8BBhPGoAV/ueqpDmhE4/7ATVI59tIJXhEreOKvNMeOmTo9KNQ==
X-Received: by 2002:a63:5ec6:: with SMTP id s189mr6481464pgb.357.1545498805775;
        Sat, 22 Dec 2018 09:13:25 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:966:8499:7122:52f6])
        by smtp.gmail.com with ESMTPSA id w11sm33322025pgk.16.2018.12.22.09.13.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 22 Dec 2018 09:13:25 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 09/12] media: mt9m001: register to V4L2 asynchronous subdevice framework
Date:   Sun, 23 Dec 2018 02:12:51 +0900
Message-Id: <1545498774-11754-10-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
References: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Register a sub-device to the asynchronous subdevice framework, and also
create subdevice device node.

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/Kconfig   | 2 +-
 drivers/media/i2c/mt9m001.c | 9 ++++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 5e30ad3..a6d8416 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -845,7 +845,7 @@ config VIDEO_VS6624
 
 config VIDEO_MT9M001
 	tristate "mt9m001 support"
-	depends on I2C && VIDEO_V4L2
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
 	depends on MEDIA_CONTROLLER
 	help
diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
index e31fb7d..b4deec3 100644
--- a/drivers/media/i2c/mt9m001.c
+++ b/drivers/media/i2c/mt9m001.c
@@ -716,6 +716,7 @@ static int mt9m001_probe(struct i2c_client *client,
 		return PTR_ERR(mt9m001->reset_gpio);
 
 	v4l2_i2c_subdev_init(&mt9m001->subdev, client, &mt9m001_subdev_ops);
+	mt9m001->subdev.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
 	v4l2_ctrl_handler_init(&mt9m001->hdl, 4);
 	v4l2_ctrl_new_std(&mt9m001->hdl, &mt9m001_ctrl_ops,
 			V4L2_CID_VFLIP, 0, 1, 1, 0);
@@ -765,10 +766,16 @@ static int mt9m001_probe(struct i2c_client *client,
 	if (ret)
 		goto error_power_off;
 
+	ret = v4l2_async_register_subdev(&mt9m001->subdev);
+	if (ret)
+		goto error_entity_cleanup;
+
 	pm_runtime_put_sync(&client->dev);
 
 	return 0;
 
+error_entity_cleanup:
+	media_entity_cleanup(&mt9m001->subdev.entity);
 error_power_off:
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
@@ -785,9 +792,9 @@ static int mt9m001_remove(struct i2c_client *client)
 {
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
 
-	v4l2_device_unregister_subdev(&mt9m001->subdev);
 	pm_runtime_get_sync(&client->dev);
 
+	v4l2_async_unregister_subdev(&mt9m001->subdev);
 	media_entity_cleanup(&mt9m001->subdev.entity);
 
 	pm_runtime_disable(&client->dev);
-- 
2.7.4

