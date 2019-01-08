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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D9EC43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 14:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72F4820883
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 14:52:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DRBKEt4G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbfAHOwr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 09:52:47 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43430 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728453AbfAHOwr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 09:52:47 -0500
Received: by mail-pf1-f195.google.com with SMTP id w73so2029985pfk.10;
        Tue, 08 Jan 2019 06:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=krPUU6Jax3C9tnqQTpQYlqQiipvuleWJ89SiJXQrvQA=;
        b=DRBKEt4GQuQbWzETVMqIcaL7hCFzDHEXpEXM2maONiCgYQZjxlLl+sidrfGDd/QDWj
         0nbnEznkVRSx3qhJuEEuK3X6cvtPws41d/KxnF2JcznudYvvU4d/wa9klmDA4J6S7Mm3
         F2lcLAPh4Ciczkwk+LHAuPf6sr5FptF3gnWFmB+ptzDZHXsuEiwWIhz9R69drXF65g88
         n5s7ce1wEC7RFUxrc4+HNAMPTST+62A2PlOqVDjlQM9BDTSyuyO3BpmGehznbnrGpRDm
         3eWoK6CYtTfg8I+xxD2fyJVz2vyJvUsPybRbI/yseJ15mjDQOEAFZ3rEuHdD4RB7fSlq
         6Icg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=krPUU6Jax3C9tnqQTpQYlqQiipvuleWJ89SiJXQrvQA=;
        b=P6ruhx3GwVSbR33XoYyc1YugWwAnv8Bzuo+Yfuu5+Ek8fvSW3aFxD2Y2QBEX5bdf0D
         Xmq9jNcssainXMEuZX2iZh67bE+LS+Q6NtgT+vM84WCJU1vwTfmzad+22Tp4+P9Il5AF
         h64RccEoKfU1KIl4HOu6SGvn0YmHfkSKgfji8MwucnFS3UChb24EGklruAOz34nL4Pi5
         oFLuWSJsTAUvMbH5pM9XYRDVTDS/uvuhoaSCh6Z9OhA4Tlo5SKR4lowWHISyyyfLhXn8
         YM6A2k1fr6//pdNCYn5zW4MuJN3tjJNcAd9rlXr2FlupPAEfj/rqKa+o52UZMcEuefN5
         3bzQ==
X-Gm-Message-State: AJcUukfRdDaovzDP7hNPG74mV85CXs+eNLeSQ5E2kai9738VycgPabTN
        TsieIoozXTx/mOr5gN/J4u4itgSc
X-Google-Smtp-Source: ALg8bN5XmJimiLZ6eS5U08x4UHbEcfkglze/TJ0MpsZVQdQZMSfHdnSR5AJdiHO+U3YUlpd3hKePRw==
X-Received: by 2002:a63:d208:: with SMTP id a8mr1758817pgg.77.1546959165999;
        Tue, 08 Jan 2019 06:52:45 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:5cb2:2bb:ff67:c70d])
        by smtp.gmail.com with ESMTPSA id n78sm53546990pfk.19.2019.01.08.06.52.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 08 Jan 2019 06:52:45 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 13/13] media: mt9m001: set all mbus format field when G_FMT and S_FMT ioctls
Date:   Tue,  8 Jan 2019 23:51:50 +0900
Message-Id: <1546959110-19445-14-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1546959110-19445-1-git-send-email-akinobu.mita@gmail.com>
References: <1546959110-19445-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This driver doesn't set all members of mbus format field when the
VIDIOC_SUBDEV_{S,G}_FMT ioctls are called.

This is detected by v4l2-compliance.

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* No changes from v1

 drivers/media/i2c/mt9m001.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
index f97ab48..61e5e6f 100644
--- a/drivers/media/i2c/mt9m001.c
+++ b/drivers/media/i2c/mt9m001.c
@@ -340,6 +340,9 @@ static int mt9m001_get_fmt(struct v4l2_subdev *sd,
 	mf->code	= mt9m001->fmt->code;
 	mf->colorspace	= mt9m001->fmt->colorspace;
 	mf->field	= V4L2_FIELD_NONE;
+	mf->ycbcr_enc	= V4L2_YCBCR_ENC_DEFAULT;
+	mf->quantization = V4L2_QUANTIZATION_DEFAULT;
+	mf->xfer_func	= V4L2_XFER_FUNC_DEFAULT;
 
 	return 0;
 }
@@ -400,6 +403,10 @@ static int mt9m001_set_fmt(struct v4l2_subdev *sd,
 	}
 
 	mf->colorspace	= fmt->colorspace;
+	mf->field	= V4L2_FIELD_NONE;
+	mf->ycbcr_enc	= V4L2_YCBCR_ENC_DEFAULT;
+	mf->quantization = V4L2_QUANTIZATION_DEFAULT;
+	mf->xfer_func	= V4L2_XFER_FUNC_DEFAULT;
 
 	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
 		return mt9m001_s_fmt(sd, fmt, mf);
-- 
2.7.4

