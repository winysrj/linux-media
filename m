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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC353C43387
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 17:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D41A21A4B
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 17:13:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XAisk9EJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391052AbeLVRNT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 22 Dec 2018 12:13:19 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46533 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390366AbeLVRNS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Dec 2018 12:13:18 -0500
Received: by mail-pl1-f196.google.com with SMTP id t13so3895704ply.13;
        Sat, 22 Dec 2018 09:13:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=M508DNEaTyNabCB264x7Rm92Rdo9Qj5xwPAxAsM9r5I=;
        b=XAisk9EJXD+1z5AF+rCXyN/pfh9+SDZOnZXZcUdLlEGul1SvJHtWcNSYKh5Zwa49he
         rVsb6dylmWdIsb2FJ3zfBZ15JmOGKzqVcoGYrRTistUfpWyF/0MUcrCAuBnxminsTJ7a
         sfn6/yGw0/NC2K2POVF+jv73ckeMXa1z3EGyG4qDTIp7X9xfT8QoQeQ5upCew6ymbRBU
         j2iZYlVEhGourmVMz2ROW4aR7GpIVgbj5MT79YFXLf7no0o0MOzQDFUCXwC/UiDPGkfl
         irX/cmeQgcsKiymgvJinF/QBqBL8KoF97e9FgOlXgAZEOel2HgxAovsqYyn0zJ3dH/AW
         qwTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=M508DNEaTyNabCB264x7Rm92Rdo9Qj5xwPAxAsM9r5I=;
        b=V7hqaBWsaBg6/dDbAHXX3fBDHKA6iC7hD9dtAQZh2VIyQb6PVyBX+vbNUDmry1GVfy
         nEg3fn25UkNQJ5uJVPq2VHynUJBYA1oZAJO2/Y3m69ab4d9oNCZRG0VUoCtjil0+i6xk
         +GWjf5DE3UWBrdzv32JxU6mzHBQuYBGAKa2zXBkTFK66eAcqK9zPtJCScXuVjjID964F
         swW2QAv6OwOfnpW3hvRqe9cLuTS4dAsguFqzHkC8PZqRCWHv646pulSz7C/Zn2fq3kQu
         8IQFZtFtLYTmaLqkKs9vZulyuAz1IrsVEw/xqh/H6E3b1LchwLEyUU5KUZpJyJYmOdVA
         RVnA==
X-Gm-Message-State: AJcUukeU3YE2rVLZctmOcQwBzqkvOrWekFpjuVGQLxTUji0boFkruM5X
        W1MSzBSx31wDilfCbo8bt9JEbt2tPRA=
X-Google-Smtp-Source: ALg8bN7RhR0oZnd9mZpiLoncHpUUSfp/3cfVCDdEHqlIVBMFVcUBRzaPJXDR9A0+nXS5SCaG8o5Bqw==
X-Received: by 2002:a17:902:ba8b:: with SMTP id k11mr7064552pls.177.1545498797380;
        Sat, 22 Dec 2018 09:13:17 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:966:8499:7122:52f6])
        by smtp.gmail.com with ESMTPSA id w11sm33322025pgk.16.2018.12.22.09.13.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 22 Dec 2018 09:13:16 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 05/12] media: mt9m001: introduce multi_reg_write()
Date:   Sun, 23 Dec 2018 02:12:47 +0900
Message-Id: <1545498774-11754-6-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
References: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Introduce multi_reg_write() to write multiple registers to the device and
use it where possible.

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/mt9m001.c | 88 +++++++++++++++++++++++++++++----------------
 1 file changed, 57 insertions(+), 31 deletions(-)

diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
index 2d800ca..c0180fdc 100644
--- a/drivers/media/i2c/mt9m001.c
+++ b/drivers/media/i2c/mt9m001.c
@@ -47,6 +47,8 @@
 #define MT9M001_MIN_HEIGHT		32
 #define MT9M001_COLUMN_SKIP		20
 #define MT9M001_ROW_SKIP		12
+#define MT9M001_DEFAULT_HBLANK		9
+#define MT9M001_DEFAULT_VBLANK		25
 
 /* MT9M001 has only one fixed colorspace per pixelcode */
 struct mt9m001_datafmt {
@@ -137,25 +139,65 @@ static int reg_clear(struct i2c_client *client, const u8 reg,
 	return reg_write(client, reg, ret & ~data);
 }
 
+struct mt9m001_reg {
+	u8 reg;
+	u16 data;
+};
+
+static int multi_reg_write(struct i2c_client *client,
+			   const struct mt9m001_reg *regs, int num)
+{
+	int i;
+
+	for (i = 0; i < num; i++) {
+		int ret = reg_write(client, regs[i].reg, regs[i].data);
+
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int mt9m001_init(struct i2c_client *client)
 {
-	int ret;
+	const struct mt9m001_reg init_regs[] = {
+		/*
+		 * Issue a soft reset. This returns all registers to their
+		 * default values.
+		 */
+		{ MT9M001_RESET, 1 },
+		{ MT9M001_RESET, 0 },
+		/* Disable chip, synchronous option update */
+		{ MT9M001_OUTPUT_CONTROL, 0 }
+	};
 
 	dev_dbg(&client->dev, "%s\n", __func__);
 
-	/*
-	 * We don't know, whether platform provides reset, issue a soft reset
-	 * too. This returns all registers to their default values.
-	 */
-	ret = reg_write(client, MT9M001_RESET, 1);
-	if (!ret)
-		ret = reg_write(client, MT9M001_RESET, 0);
+	return multi_reg_write(client, init_regs, ARRAY_SIZE(init_regs));
+}
 
-	/* Disable chip, synchronous option update */
-	if (!ret)
-		ret = reg_write(client, MT9M001_OUTPUT_CONTROL, 0);
+static int mt9m001_apply_selection(struct v4l2_subdev *sd,
+				    struct v4l2_rect *rect)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct mt9m001 *mt9m001 = to_mt9m001(client);
+	const struct mt9m001_reg regs[] = {
+		/* Blanking and start values - default... */
+		{ MT9M001_HORIZONTAL_BLANKING, MT9M001_DEFAULT_HBLANK },
+		{ MT9M001_VERTICAL_BLANKING, MT9M001_DEFAULT_VBLANK },
+		/*
+		 * The caller provides a supported format, as verified per
+		 * call to .set_fmt(FORMAT_TRY).
+		 */
+		{ MT9M001_COLUMN_START, rect->left },
+		{ MT9M001_ROW_START, rect->top },
+		{ MT9M001_WINDOW_WIDTH, rect->width - 1 },
+		{ MT9M001_WINDOW_HEIGHT,
+			rect->height + mt9m001->y_skip_top - 1 },
+	};
 
-	return ret;
+	return multi_reg_write(client, regs, ARRAY_SIZE(regs));
 }
 
 static int mt9m001_s_stream(struct v4l2_subdev *sd, int enable)
@@ -175,7 +217,6 @@ static int mt9m001_set_selection(struct v4l2_subdev *sd,
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
 	struct v4l2_rect rect = sel->r;
-	const u16 hblank = 9, vblank = 25;
 	int ret;
 
 	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE ||
@@ -199,26 +240,11 @@ static int mt9m001_set_selection(struct v4l2_subdev *sd,
 	soc_camera_limit_side(&rect.top, &rect.height,
 		     MT9M001_ROW_SKIP, MT9M001_MIN_HEIGHT, MT9M001_MAX_HEIGHT);
 
-	mt9m001->total_h = rect.height + mt9m001->y_skip_top + vblank;
+	mt9m001->total_h = rect.height + mt9m001->y_skip_top +
+			   MT9M001_DEFAULT_VBLANK;
 
-	/* Blanking and start values - default... */
-	ret = reg_write(client, MT9M001_HORIZONTAL_BLANKING, hblank);
-	if (!ret)
-		ret = reg_write(client, MT9M001_VERTICAL_BLANKING, vblank);
 
-	/*
-	 * The caller provides a supported format, as verified per
-	 * call to .set_fmt(FORMAT_TRY).
-	 */
-	if (!ret)
-		ret = reg_write(client, MT9M001_COLUMN_START, rect.left);
-	if (!ret)
-		ret = reg_write(client, MT9M001_ROW_START, rect.top);
-	if (!ret)
-		ret = reg_write(client, MT9M001_WINDOW_WIDTH, rect.width - 1);
-	if (!ret)
-		ret = reg_write(client, MT9M001_WINDOW_HEIGHT,
-				rect.height + mt9m001->y_skip_top - 1);
+	ret = mt9m001_apply_selection(sd, &rect);
 	if (!ret && v4l2_ctrl_g_ctrl(mt9m001->autoexposure) == V4L2_EXPOSURE_AUTO)
 		ret = reg_write(client, MT9M001_SHUTTER_WIDTH, mt9m001->total_h);
 
-- 
2.7.4

