Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 241B8C43612
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 15:56:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E74992086D
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 15:56:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="I4lXJ3Od"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbfARP40 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 10:56:26 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43595 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727580AbfARP4Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 10:56:25 -0500
Received: by mail-wr1-f67.google.com with SMTP id r10so15609556wrs.10
        for <linux-media@vger.kernel.org>; Fri, 18 Jan 2019 07:56:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=IlhRlfE+Zj+QzMvvfaa9gaqWOjCT6FCHLtgklD5DeaI=;
        b=I4lXJ3OdiEBZv8daCMy3wONl/mhjKPP2EWdUYYZQz1UGTSV+vyV5H3mt1SK16cVUDe
         Ruzbk1DO1SQTLEikNjpVwFXBxNQ+vE7wxwkPOsxc7UYHvQ3UGL63IaIXJyLGH9uR2hGy
         wALyH3Gdj4ZJHVBvnNj6IrauZz5hZMJtAL1Ms=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=IlhRlfE+Zj+QzMvvfaa9gaqWOjCT6FCHLtgklD5DeaI=;
        b=nwy18lwIlgu5FhgYpjuadsJRAdyrOgHSGsHnqVzPwV3XSumM25grExmKuERmtyjqnC
         5ROZMvm4Rwbjuv5TcRq7AAtyC9tuXOI0VhPMWl1KOFf1XrjlNAJwrdKEmVFojInDhoDZ
         dF/LfViCS95Uw1tV/TpuTOqF+0Z9tgdQ1Pti7nlnDmP5ibyD9u1tY/0CkhjvPF9HGmEi
         3+fv7dMH/+hRNGatXkeojIN1cKMsuPTe87+Fr7qRgr1b20JbPSZLzDIWTcjtKV1133rJ
         xnt/XS5luqToY1sTemf4CamPrYR58r6Rg1wj4rzoqTGTdj/gMKA0saokIqJ2g1hSRPm+
         iiAQ==
X-Gm-Message-State: AJcUukfkclhtYo3w1fXNcR6BS8YjGjWskNnF+r2HKzTpermRdzbfc8OP
        oIToLTCgvjNcjgf9W7JiaYSFqqew5eI=
X-Google-Smtp-Source: ALg8bN4Etx2pQQP57EWD/UzyF3+z8U1tpKr6qhKJcm1pHlWdKstHNLI3zfhJF3TnbmyrAZyo4nxLYQ==
X-Received: by 2002:a5d:4586:: with SMTP id p6mr16606884wrq.69.1547826983364;
        Fri, 18 Jan 2019 07:56:23 -0800 (PST)
Received: from localhost.localdomain ([37.157.136.206])
        by smtp.gmail.com with ESMTPSA id p12sm45656324wmi.5.2019.01.18.07.56.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Jan 2019 07:56:22 -0800 (PST)
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
To:     linux-media@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH] venus: enc: fix enum_frameintervals
Date:   Fri, 18 Jan 2019 17:56:06 +0200
Message-Id: <20190118155606.21798-1-stanimir.varbanov@linaro.org>
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
 drivers/media/platform/qcom/venus/venc.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 32cff294582f..8c939af0a1f6 100644
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
@@ -664,9 +666,14 @@ static int venc_set_properties(struct venus_inst *inst)
 	if (ret)
 		return ret;
 
+	framerate = inst->timeperframe.denominator * FRAMERATE_FACTOR;
+	framerate = DIV_ROUND_UP(framerate, inst->timeperframe.numerator);
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

