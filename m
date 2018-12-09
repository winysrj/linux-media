Return-Path: <SRS0=qcaw=OS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE98EC07E85
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 05:20:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1C8B21104
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 05:20:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LJ8kN6U4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A1C8B21104
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbeLIFUu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 9 Dec 2018 00:20:50 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36900 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbeLIFUu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Dec 2018 00:20:50 -0500
Received: by mail-pf1-f195.google.com with SMTP id y126so3815977pfb.4
        for <linux-media@vger.kernel.org>; Sat, 08 Dec 2018 21:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=70DbESgLDPFe2SN/wMlNagvbRhufvVJ1zpuon0k3zRQ=;
        b=LJ8kN6U46vCZZOQ1fWrWWjrLQTfDoD/CC1w0CRiNr32iQF34iGbE/mJmefRo0Rx1qP
         62bOrCgO8Ykjuy4+UODoc32ot582o3g9c/XVEmH+myYQsS7WsJTnADiLDa5P6R4zja7a
         1EWASXEm/lGFpjhTPX+LXWLSB42EUIsN/rBIB7K/TBzdGmj4RqWZ5IJ5oP+N5xsQg2iY
         FyAfrItNhRl07eYLzj04GGnjwWfDmLvHECPUEchVFgEa3+y9AjQeK5/I44dL8ERMcgpq
         2JwIe4dRBynzfcWIWy5OQg0OM31h8PPk4ZJRjOqvmawZverA8PEJ3aJnsCpEHyUjGVWU
         Gzpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=70DbESgLDPFe2SN/wMlNagvbRhufvVJ1zpuon0k3zRQ=;
        b=OaBEt0TNd54KTaSStXE8FElkuSWMicHlUQSQvBHUHbr9v0sdRotpMY/EG581JHKSrB
         7cf8WEvw/JOU26TDhyCGefY19t1+DqO/C5paMKdXk/JtRVlUpV+6kZ5AqnyXZLo4Se+A
         qFs+iMqpwL36kTGg4cTorl/rI03C7gaU7vy+bJ9ThjZh/XO9PPki/gH4RRkGzeKRDIyu
         hwK+vzNXnrmT36NvMlvbPfXBzCP6bDCX2R52eMuVvYLPSqxmXNyFzjZTcrNkkl7o9Hyn
         8Brj6fOglPnL18QOFbcynPTni/1x0S78XClFvhLthSDnV4aeG3AjONR6akzSxCKGVME0
         pH3g==
X-Gm-Message-State: AA+aEWaCocUl7+oGsHvWh/jpkz8jUnl1doKl0LqXhgryU0HJvv3slZgj
        C8lBpaHysxTSb6dRMwUKI+166v9PKJY=
X-Google-Smtp-Source: AFSGD/WSlufX40RFujwqjCBprMk7vGQ0ahNZXk3mYQVnmnq5gG+/FIOyoLzKGTyP7BnWeUaviNOUaA==
X-Received: by 2002:a65:4b82:: with SMTP id t2mr6982116pgq.189.1544332849162;
        Sat, 08 Dec 2018 21:20:49 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:a17f:ba11:defa:e2d1])
        by smtp.gmail.com with ESMTPSA id v14sm14973270pgf.3.2018.12.08.21.20.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 08 Dec 2018 21:20:48 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 2/3] media: ov2640: make VIDIOC_SUBDEV_G_FMT ioctl work with V4L2_SUBDEV_FORMAT_TRY
Date:   Sun,  9 Dec 2018 14:20:32 +0900
Message-Id: <1544332833-10369-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1544332833-10369-1-git-send-email-akinobu.mita@gmail.com>
References: <1544332833-10369-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The VIDIOC_SUBDEV_G_FMT ioctl for this driver doesn't recognize
V4L2_SUBDEV_FORMAT_TRY and always works as if V4L2_SUBDEV_FORMAT_ACTIVE
is specified.

Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v2
- fix build error when CONFIG_VIDEO_V4L2_SUBDEV_API is not defined,
  reported by kbuild test robot.

 drivers/media/i2c/ov2640.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index a07e6f2..84b1b15 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -926,6 +926,15 @@ static int ov2640_get_fmt(struct v4l2_subdev *sd,
 	if (format->pad)
 		return -EINVAL;
 
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
+		mf = v4l2_subdev_get_try_format(sd, cfg, 0);
+		format->format = *mf;
+		return 0;
+#else
+		return -ENOTTY;
+#endif
+	}
 
 	mf->width	= priv->win->width;
 	mf->height	= priv->win->height;
@@ -992,6 +1001,27 @@ static int ov2640_set_fmt(struct v4l2_subdev *sd,
 	return ret;
 }
 
+static int ov2640_init_cfg(struct v4l2_subdev *sd,
+			   struct v4l2_subdev_pad_config *cfg)
+{
+#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct ov2640_priv *priv = to_ov2640(client);
+	struct v4l2_mbus_framefmt *try_fmt =
+		v4l2_subdev_get_try_format(sd, cfg, 0);
+
+	try_fmt->width = priv->win->width;
+	try_fmt->height = priv->win->height;
+	try_fmt->code = priv->cfmt_code;
+	try_fmt->colorspace = V4L2_COLORSPACE_SRGB;
+	try_fmt->field = V4L2_FIELD_NONE;
+	try_fmt->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
+	try_fmt->quantization = V4L2_QUANTIZATION_DEFAULT;
+	try_fmt->xfer_func = V4L2_XFER_FUNC_DEFAULT;
+#endif
+	return 0;
+}
+
 static int ov2640_enum_mbus_code(struct v4l2_subdev *sd,
 		struct v4l2_subdev_pad_config *cfg,
 		struct v4l2_subdev_mbus_code_enum *code)
@@ -1101,6 +1131,7 @@ static const struct v4l2_subdev_core_ops ov2640_subdev_core_ops = {
 };
 
 static const struct v4l2_subdev_pad_ops ov2640_subdev_pad_ops = {
+	.init_cfg	= ov2640_init_cfg,
 	.enum_mbus_code = ov2640_enum_mbus_code,
 	.get_selection	= ov2640_get_selection,
 	.get_fmt	= ov2640_get_fmt,
-- 
2.7.4

