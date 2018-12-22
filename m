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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71A80C43387
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 17:13:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4551221A4B
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 17:13:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IT+8efTR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391071AbeLVRNa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 22 Dec 2018 12:13:30 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37613 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbeLVRN3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Dec 2018 12:13:29 -0500
Received: by mail-pf1-f194.google.com with SMTP id y126so4052332pfb.4;
        Sat, 22 Dec 2018 09:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hGeJuLzFaMjIyDChQ4XZrLSUPNQwQI4TAXwlnrFy2eE=;
        b=IT+8efTRPsmdBNgn5YqNL4NtHYrnX7NGi9acY2Ol0izkfJ/JCPa/MfZPmd7uDvsM56
         qLFWF8kPfOBA2qBQQTbBFqmvgxJQ5+ICl3LVfJqbQ5LeUR9GjkslCy8+ILx04w68vLux
         ldi1RwNMnxzn0NFBOVCNiz3gZX9IT3mCQioNMV4ywqlfL3TuIvTDXSrWY6FKjP9UBdRC
         c8el6DiQ24XaCyY5gD5+/owEFvTJJe8Y4LxRSLhQ3DnkM0BjC3BSUDqsYeFVaLIBQCH4
         j31F30nF/Wi1anWc0yWwZkXZZzE+ToBiVVOmv35u/NMNAuug8kWnC4yWbuh1UWMwPyjz
         oA3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hGeJuLzFaMjIyDChQ4XZrLSUPNQwQI4TAXwlnrFy2eE=;
        b=KrBfdL0Ej9bO+oiPFeg6V0MQSZpRt6/XtVvSdWk+skjj7QexJRPlR3ayNLekpIWnOo
         fslv/jKoDyBLa0Wj69+yOX4VmztszaZkE2fMSUuS/H5Np4rQ1PKIQ7hEeq4dqBZFvgpt
         S0qKJ6AnWBj+boiiCIx/05Ysr/QOg9rJVhqKAh/bhYNgGE437bWV+pkr6t8q7yr+GAng
         8N2+5tAgKObbSbvhZfXyBizkmya+iv8bMmnHVT4TRbslcqHmPyjgOy9Dlq5k3lBp0lbo
         wa7za3KLctYkP8piJnjjgTAHN6k1TyaDQnwboQdHOfkhurpNr4+jT2xgu+vDK45kGXTD
         7YLA==
X-Gm-Message-State: AJcUukfzDpgkPdJnFeWRc5yvKd/XV6wQh6tVJs01vtsAxklCnl4UNLzL
        DzJe5OMp5kb26N6Ap7l8lEoAHrwNr30=
X-Google-Smtp-Source: ALg8bN4a5gZoUiRrWBDbs8o8qpusSDki3JAqHRMw4c/c5JrA4Z1j4o9AxS6wXXe4Z+yPCReXd21USg==
X-Received: by 2002:a63:c141:: with SMTP id p1mr6752156pgi.424.1545498807830;
        Sat, 22 Dec 2018 09:13:27 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:966:8499:7122:52f6])
        by smtp.gmail.com with ESMTPSA id w11sm33322025pgk.16.2018.12.22.09.13.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 22 Dec 2018 09:13:27 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 10/12] media: mt9m001: support log_status ioctl and event interface
Date:   Sun, 23 Dec 2018 02:12:52 +0900
Message-Id: <1545498774-11754-11-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
References: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This adds log_status ioctl and event interface for mt9m001's v4l2 controls.

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/mt9m001.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
index b4deec3..a5b94d7 100644
--- a/drivers/media/i2c/mt9m001.c
+++ b/drivers/media/i2c/mt9m001.c
@@ -18,6 +18,7 @@
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-event.h>
 
 /*
  * mt9m001 i2c address 0x5d
@@ -628,6 +629,9 @@ static const struct v4l2_ctrl_ops mt9m001_ctrl_ops = {
 };
 
 static const struct v4l2_subdev_core_ops mt9m001_subdev_core_ops = {
+	.log_status = v4l2_ctrl_subdev_log_status,
+	.subscribe_event = v4l2_ctrl_subdev_subscribe_event,
+	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= mt9m001_g_register,
 	.s_register	= mt9m001_s_register,
@@ -716,7 +720,8 @@ static int mt9m001_probe(struct i2c_client *client,
 		return PTR_ERR(mt9m001->reset_gpio);
 
 	v4l2_i2c_subdev_init(&mt9m001->subdev, client, &mt9m001_subdev_ops);
-	mt9m001->subdev.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
+	mt9m001->subdev.flags = V4L2_SUBDEV_FL_HAS_DEVNODE |
+				V4L2_SUBDEV_FL_HAS_EVENTS;
 	v4l2_ctrl_handler_init(&mt9m001->hdl, 4);
 	v4l2_ctrl_new_std(&mt9m001->hdl, &mt9m001_ctrl_ops,
 			V4L2_CID_VFLIP, 0, 1, 1, 0);
-- 
2.7.4

