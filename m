Return-Path: <SRS0=qcaw=OS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0003BC07E85
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 05:20:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7C0020837
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 05:20:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U0m1/tUj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7C0020837
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbeLIFUw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 9 Dec 2018 00:20:52 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43430 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbeLIFUw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Dec 2018 00:20:52 -0500
Received: by mail-pf1-f195.google.com with SMTP id w73so3801184pfk.10
        for <linux-media@vger.kernel.org>; Sat, 08 Dec 2018 21:20:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Lsvy49nH5IXtq41XXl8DV28el6imeukEJl4FbYDY1Ck=;
        b=U0m1/tUjrvEUwqFoMYWT4qtnl8ZsCil13Fuyityv3ORXowUK+Udm3uwhdG8mMUUHN0
         VN3J3jLFOjKPHniB+36N0cvILunqt13+fKP6LPldXzfVt3XdT8u/O7FtC2HU3p/GNqtq
         Xifo/ar5UheCcy1Pi29wnGDf45chYYGZIhzxxCDj0r2lwNoMpe+P9NkoPIeFlmCiJmVT
         z3W/EU0wulJGttjvKx7NDVznHZG+bFxx3SaOLJ0GmstagiiQ7OmItAeDX2hKDLOkdYNG
         2otKJenXYw9zHVvWBU1IU7yEkgNiDfwXmeSiY0KHKZ/2LSu0RrxRBdzoQEZNO7jKamDL
         snOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Lsvy49nH5IXtq41XXl8DV28el6imeukEJl4FbYDY1Ck=;
        b=RjEBcvCVaa9P6kEszcbiDca90hVABoWiXi3NQlpIO7qmU0aRbLn39HbF6d0EwxBeLE
         qYPRqETo8q22v5N7XepGRf94viXzwNuKdnTggSAiyymOsQrEDMcw7PHOEGMsrVdDL1zx
         lqgY/7DlKMAYatr810uc1CzT78/0/saril3ZgZMgFagoHlwKOqXgjFLczIRlXEOK8xW7
         sucq+CctFLvhsa+mjeoxAtZkblLlwnO3uac1ItwjHIR6TxRtgmyCbl7pWBzeZonxBswh
         6qil1JZC6v5hAYDiEe0aqPMvp8OhKEChqYbOhgGR47MAfZg06r/CTUwJZDIh4RyQHKSl
         wg9Q==
X-Gm-Message-State: AA+aEWat8KOISJSUGLVkq7LVGb1D/LKC88IFg8YmMf1C4UesNVbAPG0P
        FrTtyIryA+GmBZ9T1d4CcXa49l2genQ=
X-Google-Smtp-Source: AFSGD/XXWZN6BKW4z/O+Y6KTdqkl+eEc8LvnZ572sqccQUVAcGPoVOdjGeTDWLe/snITf2rHrMEYbQ==
X-Received: by 2002:a63:4e41:: with SMTP id o1mr7121424pgl.282.1544332851170;
        Sat, 08 Dec 2018 21:20:51 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:a17f:ba11:defa:e2d1])
        by smtp.gmail.com with ESMTPSA id v14sm14973270pgf.3.2018.12.08.21.20.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 08 Dec 2018 21:20:50 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 3/3] media: ov2640: set all mbus format field when G_FMT and S_FMT ioctls
Date:   Sun,  9 Dec 2018 14:20:33 +0900
Message-Id: <1544332833-10369-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1544332833-10369-1-git-send-email-akinobu.mita@gmail.com>
References: <1544332833-10369-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This driver doesn't set all members of mbus format field when the
VIDIOC_SUBDEV_{S,G}_FMT ioctls are called.

This is detected by v4l2-compliance.

Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov2640.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index 84b1b15..09325da 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -941,6 +941,9 @@ static int ov2640_get_fmt(struct v4l2_subdev *sd,
 	mf->code	= priv->cfmt_code;
 	mf->colorspace	= V4L2_COLORSPACE_SRGB;
 	mf->field	= V4L2_FIELD_NONE;
+	mf->ycbcr_enc	= V4L2_YCBCR_ENC_DEFAULT;
+	mf->quantization = V4L2_QUANTIZATION_DEFAULT;
+	mf->xfer_func	= V4L2_XFER_FUNC_DEFAULT;
 
 	return 0;
 }
@@ -967,6 +970,9 @@ static int ov2640_set_fmt(struct v4l2_subdev *sd,
 
 	mf->field	= V4L2_FIELD_NONE;
 	mf->colorspace	= V4L2_COLORSPACE_SRGB;
+	mf->ycbcr_enc	= V4L2_YCBCR_ENC_DEFAULT;
+	mf->quantization = V4L2_QUANTIZATION_DEFAULT;
+	mf->xfer_func	= V4L2_XFER_FUNC_DEFAULT;
 
 	switch (mf->code) {
 	case MEDIA_BUS_FMT_RGB565_2X8_BE:
-- 
2.7.4

