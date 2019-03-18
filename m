Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1A3AC43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 15:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B20E20872
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 15:26:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pdvSrBKI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbfCRP0A (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 11:26:00 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36248 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbfCRP0A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 11:26:00 -0400
Received: by mail-pg1-f194.google.com with SMTP id r124so11639261pgr.3
        for <linux-media@vger.kernel.org>; Mon, 18 Mar 2019 08:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=z0Tvs6/ezWzMbw6Z0XCvAZw0L/JWERgRa+Xex2mn81A=;
        b=pdvSrBKImTq20ACxHkqUCQEI8dueks3O0aU/gvsfsEOHbtZTAIzY6BMRUu4MukmZCL
         lqlL8ZywdFpyG/BaKdtmC/xoMUTEueu02aNToc9N+sdoa3vV73DvxNfh3VJu3icZ5NBs
         tG/qTR3I/RDUR8lVmcanHzSTgzIkj/K5ijUOsWqV0lkY03c2LKPZFYUghmZjLtDamSBa
         4wRydJLtabbqbx7CrTZ9gEKvz4L0qXVj1wmIoBc4M1M3QpCkhdyis97IGK1IcY6rjnBT
         KdtDrZ5eX0buxSI89M4ZY6ukHQ6Y0erycBkX7Ot3YooWDy4pljw5wZtJq9LRo/0LcdgY
         LbDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=z0Tvs6/ezWzMbw6Z0XCvAZw0L/JWERgRa+Xex2mn81A=;
        b=KwXVDqIdSHcuPXIaNEIhVKy6ErS54DYKI5WMtVa44Huwmm6+MCitynml+E4hwcYLwU
         Vm+/LS2KWR3X6PKfzq9b4bDl2ZbnGruuTOSgxYBZjBq7O9u5WpsEwz0PkH7CSI3ualkw
         ZnsZ1M88lRnxkSqwJT+TVMhf4P8rOSpqZhgTRCLIqOIn6sT3hHvtXT5WQtMG04CN00uV
         e5xcKf0Jvd7QsbPX/NQua/TIatsYMMij/zmajndB2r5PjuXRpWdEg+EpgnmaJw1RAHUR
         COSNslNaKKSAsh1Uc4kW0BbkPxxBh8XA1k7WzRSPt6oqliulDiFUC5ApV2uwGoxiGl9p
         p+pA==
X-Gm-Message-State: APjAAAW6zcTpY5GfqfEjj7iMWOogD0pq5aeb/y8muwv4RNMzBeNZmWCQ
        yJvxM4hYeMkg8YDpojc8aASp03oQ
X-Google-Smtp-Source: APXvYqz9a2IwDAb8jFl1XILGavDjmOmNNhuveXJVpADteRgQheNqLArp0D93+Em8zKg92WF6aw7WXg==
X-Received: by 2002:a63:2b03:: with SMTP id r3mr17536129pgr.1.1552922759525;
        Mon, 18 Mar 2019 08:25:59 -0700 (PDT)
Received: from localhost.localdomain ([240f:34:212d:1:1b24:991b:df50:ea3f])
        by smtp.gmail.com with ESMTPSA id h9sm20779868pgk.22.2019.03.18.08.25.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 18 Mar 2019 08:25:58 -0700 (PDT)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Wenyou Yang <wenyou.yang@microchip.com>,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH] media: ov7740: enable to get exposure control in autoexposure mode
Date:   Tue, 19 Mar 2019 00:25:43 +0900
Message-Id: <1552922743-5155-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The exposure control is clustered with the autoexposure control and
flagged as volatile, but the g_volatile_ctrl() doesn't handle
V4L2_CID_EXPOSURE_AUTO.  So, the value of the exposure control can't be
read in autoexposure mode.

This enables to get the exposure control in autoexposure mode by making
ov7740_get_volatile_ctrl() deal with V4L2_CID_EXPOSURE_AUTO.

This also sets the exposure control as volatile by specifying the
argument to v4l2_ctrl_auto_cluster() instead of manually flagging it.

Cc: Wenyou Yang <wenyou.yang@microchip.com>
Cc: Eugen Hristev <eugen.hristev@microchip.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov7740.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/ov7740.c b/drivers/media/i2c/ov7740.c
index dfece91..54e80a6 100644
--- a/drivers/media/i2c/ov7740.c
+++ b/drivers/media/i2c/ov7740.c
@@ -448,6 +448,27 @@ static int ov7740_get_gain(struct ov7740 *ov7740, struct v4l2_ctrl *ctrl)
 	return 0;
 }
 
+static int ov7740_get_exp(struct ov7740 *ov7740, struct v4l2_ctrl *ctrl)
+{
+	struct regmap *regmap = ov7740->regmap;
+	unsigned int value0, value1;
+	int ret;
+
+	if (ctrl->val == V4L2_EXPOSURE_MANUAL)
+		return 0;
+
+	ret = regmap_read(regmap, REG_AEC, &value0);
+	if (ret)
+		return ret;
+	ret = regmap_read(regmap, REG_HAEC, &value1);
+	if (ret)
+		return ret;
+
+	ov7740->exposure->val = (value1 << 8) | (value0 & 0xff);
+
+	return 0;
+}
+
 static int ov7740_set_exp(struct regmap *regmap, int value)
 {
 	int ret;
@@ -494,6 +515,9 @@ static int ov7740_get_volatile_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_AUTOGAIN:
 		ret = ov7740_get_gain(ov7740, ctrl);
 		break;
+	case V4L2_CID_EXPOSURE_AUTO:
+		ret = ov7740_get_exp(ov7740, ctrl);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -991,8 +1015,6 @@ static int ov7740_init_controls(struct ov7740 *ov7740)
 
 	ov7740->exposure = v4l2_ctrl_new_std(ctrl_hdlr, &ov7740_ctrl_ops,
 					   V4L2_CID_EXPOSURE, 0, 65535, 1, 500);
-	if (ov7740->exposure)
-		ov7740->exposure->flags |= V4L2_CTRL_FLAG_VOLATILE;
 
 	ov7740->auto_exposure = v4l2_ctrl_new_std_menu(ctrl_hdlr,
 					&ov7740_ctrl_ops,
@@ -1003,7 +1025,7 @@ static int ov7740_init_controls(struct ov7740 *ov7740)
 	v4l2_ctrl_auto_cluster(3, &ov7740->auto_wb, 0, false);
 	v4l2_ctrl_auto_cluster(2, &ov7740->auto_gain, 0, true);
 	v4l2_ctrl_auto_cluster(2, &ov7740->auto_exposure,
-			       V4L2_EXPOSURE_MANUAL, false);
+			       V4L2_EXPOSURE_MANUAL, true);
 	v4l2_ctrl_cluster(2, &ov7740->hflip);
 
 	if (ctrl_hdlr->error) {
-- 
2.7.4

