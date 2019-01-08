Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F18C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 14:52:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43052206BB
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 14:52:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sjWC4Dnz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbfAHOwm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 09:52:42 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36435 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbfAHOwm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 09:52:42 -0500
Received: by mail-pg1-f195.google.com with SMTP id n2so1841828pgm.3;
        Tue, 08 Jan 2019 06:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xyy6mAy8WLdG81KW4F9xjs3/xe6sVsULwWFgQxb2ylw=;
        b=sjWC4DnzYUy9gBIwqh33/FAGvnw8rd8rSLZWYocYWBCbpQfJ8pB69FdCnfd32UO/KV
         wRYZ6KKL9TCjAbXmIt13Hsi256lWjC7LDZen8ADq6zJZd5MsepNfAFIKwP9u3tiOBt/d
         ZQfUDH2zqAmFbhwOL8ZCbw/aRvKe73u/LpopLWaUGuPKg5b61s0tH/k2d71cA0u70NBl
         yUOByobSbQNhZ++yqFZd1PwK8Svxj8c4s+v0LoCEvc4Tc74kYsJjUm10VT1mRQJ9hzFO
         BJwSWzvE06A2AEQSMPRU7nMx4gs6RM25z+66ODaWGqbFZnFQccBzAdutmZj0snK0wgCT
         r/9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xyy6mAy8WLdG81KW4F9xjs3/xe6sVsULwWFgQxb2ylw=;
        b=e3CiQeQXBsGz+P/wycZbaG5WLQlE9ml0cRfuyA43YxinG+aPGFC3tURiy5HBEaiTQ9
         vEp0zT9r8Drnc8/THVCJmqAmK3vsh6HPLFyi5fKRdbxjFGQOqPcjWCZvY8Ouyw8LEgbC
         H9xl3qpn+hPhLzjx3aDFq10mUVFRzRfN5F5dn80Z+1iPJS3Srv7uWJrjTnSDLczD0xlt
         7SUQ4UItlWt1IJwYjsyyriESEyURaE12GYO9dB2iJy95vl0U7n8dp7SMbVW328Iy0G9i
         ZDv9zgmgRwHRHMSJn6lt8I47dGpcbpKD8T422WaN7qjXLMfRpjXfaaXbTJ/I0t/fIk2Y
         Eyrg==
X-Gm-Message-State: AJcUukcEqpeCGRh5KRQ65avsNn5yV0/nm4+MO4L6SauxoDVmrtLqw34/
        wu+EAdWOIpYal55ZcsOPPyzGs0WW
X-Google-Smtp-Source: ALg8bN4ln+4Q4d021A01BYbaP5oe4hcIl3vUiCLiZXwMUum385b1v4CAMTujpNHke3PfcSCaJxoqPA==
X-Received: by 2002:a63:2d82:: with SMTP id t124mr1791570pgt.260.1546959161017;
        Tue, 08 Jan 2019 06:52:41 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:5cb2:2bb:ff67:c70d])
        by smtp.gmail.com with ESMTPSA id n78sm53546990pfk.19.2019.01.08.06.52.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 08 Jan 2019 06:52:40 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 11/13] media: mt9m001: support log_status ioctl and event interface
Date:   Tue,  8 Jan 2019 23:51:48 +0900
Message-Id: <1546959110-19445-12-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1546959110-19445-1-git-send-email-akinobu.mita@gmail.com>
References: <1546959110-19445-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This adds log_status ioctl and event interface for mt9m001's v4l2 controls.

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* No changes from v1

 drivers/media/i2c/mt9m001.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
index 5e93c7d..66a0928 100644
--- a/drivers/media/i2c/mt9m001.c
+++ b/drivers/media/i2c/mt9m001.c
@@ -17,6 +17,7 @@
 
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-subdev.h>
 
 /*
@@ -632,6 +633,9 @@ static const struct v4l2_ctrl_ops mt9m001_ctrl_ops = {
 };
 
 static const struct v4l2_subdev_core_ops mt9m001_subdev_core_ops = {
+	.log_status = v4l2_ctrl_subdev_log_status,
+	.subscribe_event = v4l2_ctrl_subdev_subscribe_event,
+	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= mt9m001_g_register,
 	.s_register	= mt9m001_s_register,
@@ -720,7 +724,8 @@ static int mt9m001_probe(struct i2c_client *client,
 		return PTR_ERR(mt9m001->reset_gpio);
 
 	v4l2_i2c_subdev_init(&mt9m001->subdev, client, &mt9m001_subdev_ops);
-	mt9m001->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	mt9m001->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE |
+				 V4L2_SUBDEV_FL_HAS_EVENTS;
 	v4l2_ctrl_handler_init(&mt9m001->hdl, 4);
 	v4l2_ctrl_new_std(&mt9m001->hdl, &mt9m001_ctrl_ops,
 			V4L2_CID_VFLIP, 0, 1, 1, 0);
-- 
2.7.4

