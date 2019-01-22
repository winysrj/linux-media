Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B23BAC282C4
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 10:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8179F20844
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 10:53:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ui1d49Ds"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbfAVKxi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 05:53:38 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34647 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727505AbfAVKxi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 05:53:38 -0500
Received: by mail-wm1-f67.google.com with SMTP id y185so8262378wmd.1
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2019 02:53:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=NnQIyDGoOvvLQyT3SOkwKzSCHWkztHfCr+VWK1pMgUM=;
        b=Ui1d49Dsvt6j1/x9JbmxE7/pRmDOuhot9VgNrZ6fTCdIrwi3Bvl8TU7fZjMTl0fVob
         LkqqoivCQ/kUk5U7t3z1urLA5twFbzmbMgJ1PKrRNfezCr4SgBPNXb043xTsFU5tPSKe
         8z0NcKhGlnclhzTJXNhhsC4IDTOv2NXUj8M80=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NnQIyDGoOvvLQyT3SOkwKzSCHWkztHfCr+VWK1pMgUM=;
        b=EZG3SHrir7jc+C5Y4JqbfTXOu+jKaNdjE87z+gVDdjqvR9db8wcH/dODUT2rs4FVbv
         NF7hEjO7Dvm5lnGJojkCKRDVOYWlkrqtPc0PRUGI+AQMHimU1Ac57QaVuOia/oY7kyw+
         QymuFW2iKap3b1LJ63bp0VJcmnq9OTY/3VvjL3HW+IYKSCzESjk0fqwZdN84hrew3PKa
         3Ljbv1Gai7DzLjFF4V46urOm7hwsF3Mh4lS31Iwmw3RhUg/H1NLhguGtkAMG3EcKV0lI
         UUo3AtrNP1aK4yjQKhiZndmjVKGFmxHB+Fpo3uyoR0CyDgtH9WmVr5zaXfhbUgjzFaSx
         BpdQ==
X-Gm-Message-State: AJcUukcBcugUOQuwWaVx633AnYnbbSwSYkqfATLBZ1dBWR9qtFrRhBNf
        0Tw7v3v7HB4tR9ssjYd2Ipf1qxMsgOE=
X-Google-Smtp-Source: ALg8bN7dvonm0PH7Vc4asoeSvp0QkrgFfxJUnADkO8FK56Hf7mS+vAPIYdmZPLZehzS0CGLDZZjlOw==
X-Received: by 2002:a1c:1a8a:: with SMTP id a132mr3273922wma.109.1548154416363;
        Tue, 22 Jan 2019 02:53:36 -0800 (PST)
Received: from localhost.localdomain ([37.157.136.206])
        by smtp.gmail.com with ESMTPSA id b18sm74256820wrr.43.2019.01.22.02.53.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Jan 2019 02:53:35 -0800 (PST)
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v2] venus: enc: fix enum_frameintervals
Date:   Tue, 22 Jan 2019 12:53:22 +0200
Message-Id: <20190122105322.22096-1-stanimir.varbanov@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This ixes an issue when setting the encoder framerate because of
missing precision. Now the frameinterval type is changed to
TYPE_CONTINUOUS and step = 1. Also the math is changed when
framerate property is called - the firmware side expects that
the framerate one is 1 << 16 units.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
v2: replace DIV_ROUND_UP with do_div and make roundup manually

 drivers/media/platform/qcom/venus/venc.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 32cff294582f..99c94b155b46 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -31,6 +31,7 @@
 #include "venc.h"
 
 #define NUM_B_FRAMES_MAX	4
+#define FRAMERATE_FACTOR	(1 << 16)
 
 /*
  * Three resons to keep MPLANE formats (despite that the number of planes
@@ -581,7 +582,7 @@ static int venc_enum_frameintervals(struct file *file, void *fh,
 	struct venus_inst *inst = to_inst(file);
 	const struct venus_format *fmt;
 
-	fival->type = V4L2_FRMIVAL_TYPE_STEPWISE;
+	fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
 
 	fmt = find_format(inst, fival->pixel_format,
 			  V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
@@ -604,12 +605,12 @@ static int venc_enum_frameintervals(struct file *file, void *fh,
 	    fival->height < frame_height_min(inst))
 		return -EINVAL;
 
-	fival->stepwise.min.numerator = 1;
+	fival->stepwise.min.numerator = FRAMERATE_FACTOR;
 	fival->stepwise.min.denominator = frate_max(inst);
-	fival->stepwise.max.numerator = 1;
+	fival->stepwise.max.numerator = FRAMERATE_FACTOR;
 	fival->stepwise.max.denominator = frate_min(inst);
 	fival->stepwise.step.numerator = 1;
-	fival->stepwise.step.denominator = frate_max(inst);
+	fival->stepwise.step.denominator = 1;
 
 	return 0;
 }
@@ -654,6 +655,7 @@ static int venc_set_properties(struct venus_inst *inst)
 	struct hfi_quantization quant;
 	struct hfi_quantization_range quant_range;
 	u32 ptype, rate_control, bitrate, profile = 0, level = 0;
+	u64 framerate;
 	int ret;
 
 	ret = venus_helper_set_work_mode(inst, VIDC_WORK_MODE_2);
@@ -664,9 +666,16 @@ static int venc_set_properties(struct venus_inst *inst)
 	if (ret)
 		return ret;
 
+	framerate = inst->timeperframe.denominator * FRAMERATE_FACTOR;
+	/* next line is to round up */
+	framerate += inst->timeperframe.numerator - 1;
+	do_div(framerate, inst->timeperframe.numerator);
+
 	ptype = HFI_PROPERTY_CONFIG_FRAME_RATE;
 	frate.buffer_type = HFI_BUFFER_OUTPUT;
-	frate.framerate = inst->fps * (1 << 16);
+	frate.framerate = framerate;
+	if (frate.framerate > frate_max(inst))
+		frate.framerate = frate_max(inst);
 
 	ret = hfi_session_set_property(inst, ptype, &frate);
 	if (ret)
-- 
2.17.1

