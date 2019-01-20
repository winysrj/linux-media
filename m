Return-Path: <SRS0=HRs9=P4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 248E6C2666E
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 19:13:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA3FC2084F
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 19:13:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eXxgAXt5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727586AbfATTNj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 20 Jan 2019 14:13:39 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37357 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727415AbfATTNj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Jan 2019 14:13:39 -0500
Received: by mail-pl1-f196.google.com with SMTP id b5so8696945plr.4;
        Sun, 20 Jan 2019 11:13:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=e2HOUbGNN/v/dW8bjHRJUsT8BYGPYXxk3FU2EXZ7FCI=;
        b=eXxgAXt5nD5btFz97FB/AxCg4gs8Esl3yRHuNB/O9LdnyEYTTLi8nogkUOYLKT/tSv
         gQyIQ7wns3ULiF41O4WQxAfJ9ysK5LeFygq9oBxLYFyPlnGXde8+9M+7RB9cAvgHSJgk
         YJn4HCuOTrlNk3f3kAJW9Ixc3KhKNsRwucoQfg+rb7GNfQPDGzMKRjByj9cNE/yY1vs6
         jii23yaD/M7lnTSXPQRJEN9NA+VwodQajJzrUrf4szOMwwNcq4zOeyxwPBXdwLBnPsR0
         /juZssM+8fUCrnR46E4Mc/jE/8wGGMGCy/sYxBGcvx9Rgf5zKWPz+1RVUXQ8nxOIKit8
         j9Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=e2HOUbGNN/v/dW8bjHRJUsT8BYGPYXxk3FU2EXZ7FCI=;
        b=JLXZZPO2gH2x2AvnJs+VHRanv3ft6vEuZgwvLhkZAmHRchtyVt3j7xY7WjjyaiqhH+
         Mjmqy7IV0b86AXgHA3NT43yx2/tMJ9QPFMZyG7j7Lkyamc4Ds2Xt/SmLaISWCe3QWuQ3
         XneBKfg7CDZzFf/iKXiqnr1Fma/MbxSsHSvtQibLtnQl5Y3VSQWvTTSaxGc0Y0bTmMDz
         AQIEMgnhWAW1RJeSKSU3FEiNOMYE1hLr9PiJMW8EXHAgP+Let1FCA/UcOKv3zaRO2GDH
         z9SrHyRxdUS6zW7tAWQDNni020SQW4DxJxJbYy9PJullDToYtJrtDhK5I8J2aKv5kxNY
         gbpQ==
X-Gm-Message-State: AJcUukey9GWJe/LMklPgmzacl184J9W41fZU+vuzCI3P7/o7g8Kxr6kB
        Q0NndGAj1QdwbQKesTGSyV5INHuiHDM=
X-Google-Smtp-Source: ALg8bN4NJN+IFYPvsoIIYZtEvTJEXEpC8jY1WAEwJsnsZlc8XchRHDxgmWUo86HJNh4IkNlBTNkH2w==
X-Received: by 2002:a17:902:ac1:: with SMTP id 59mr26980010plp.36.1548011618112;
        Sun, 20 Jan 2019 11:13:38 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id 125sm14173055pfd.124.2019.01.20.11.13.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Jan 2019 11:13:37 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] media: imx: Validate frame intervals before setting
Date:   Sun, 20 Jan 2019 11:13:31 -0800
Message-Id: <20190120191331.9723-1-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

In the .s_frame_interval() subdev op, don't accept or set a
frame interval with a zero numerator or denominator. This fixes
a v4l2-compliance failure:

fail: v4l2-test-formats.cpp(1146):
cap->timeperframe.numerator == 0 || cap->timeperframe.denominator == 0
test VIDIOC_G/S_PARM: FAIL

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
 drivers/staging/media/imx/imx-ic-prp.c      | 9 +++++++--
 drivers/staging/media/imx/imx-ic-prpencvf.c | 9 +++++++--
 drivers/staging/media/imx/imx-media-csi.c   | 5 ++++-
 drivers/staging/media/imx/imx-media-vdic.c  | 5 ++++-
 4 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/imx/imx-ic-prp.c b/drivers/staging/media/imx/imx-ic-prp.c
index 98923fc844ce..a2bb5c702d74 100644
--- a/drivers/staging/media/imx/imx-ic-prp.c
+++ b/drivers/staging/media/imx/imx-ic-prp.c
@@ -422,9 +422,14 @@ static int prp_s_frame_interval(struct v4l2_subdev *sd,
 	if (fi->pad >= PRP_NUM_PADS)
 		return -EINVAL;
 
-	/* No limits on frame interval */
 	mutex_lock(&priv->lock);
-	priv->frame_interval = fi->interval;
+
+	/* No limits on valid frame intervals */
+	if (fi->interval.numerator == 0 || fi->interval.denominator == 0)
+		fi->interval = priv->frame_interval;
+	else
+		priv->frame_interval = fi->interval;
+
 	mutex_unlock(&priv->lock);
 
 	return 0;
diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
index 33ada6612fee..d35591e9933b 100644
--- a/drivers/staging/media/imx/imx-ic-prpencvf.c
+++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
@@ -1215,9 +1215,14 @@ static int prp_s_frame_interval(struct v4l2_subdev *sd,
 	if (fi->pad >= PRPENCVF_NUM_PADS)
 		return -EINVAL;
 
-	/* No limits on frame interval */
 	mutex_lock(&priv->lock);
-	priv->frame_interval = fi->interval;
+
+	/* No limits on valid frame intervals */
+	if (fi->interval.numerator == 0 || fi->interval.denominator == 0)
+		fi->interval = priv->frame_interval;
+	else
+		priv->frame_interval = fi->interval;
+
 	mutex_unlock(&priv->lock);
 
 	return 0;
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 555aa45e02e3..81f78a928048 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -905,7 +905,10 @@ static int csi_s_frame_interval(struct v4l2_subdev *sd,
 
 	switch (fi->pad) {
 	case CSI_SINK_PAD:
-		/* No limits on input frame interval */
+		/* No limits on valid input frame intervals */
+		if (fi->interval.numerator == 0 ||
+		    fi->interval.denominator == 0)
+			fi->interval = *input_fi;
 		/* Reset output intervals and frame skipping ratio to 1:1 */
 		priv->frame_interval[CSI_SRC_PAD_IDMAC] = fi->interval;
 		priv->frame_interval[CSI_SRC_PAD_DIRECT] = fi->interval;
diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
index 4a890714193e..62e09a53d171 100644
--- a/drivers/staging/media/imx/imx-media-vdic.c
+++ b/drivers/staging/media/imx/imx-media-vdic.c
@@ -818,7 +818,10 @@ static int vdic_s_frame_interval(struct v4l2_subdev *sd,
 	switch (fi->pad) {
 	case VDIC_SINK_PAD_DIRECT:
 	case VDIC_SINK_PAD_IDMAC:
-		/* No limits on input frame interval */
+		/* No limits on valid input frame intervals */
+		if (fi->interval.numerator == 0 ||
+		    fi->interval.denominator == 0)
+			fi->interval = priv->frame_interval[fi->pad];
 		/* Reset output interval */
 		*output_fi = fi->interval;
 		if (priv->csi_direct)
-- 
2.17.1

