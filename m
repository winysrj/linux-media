Return-Path: <SRS0=qcaw=OS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8FA8C07E85
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 19:57:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A779D20672
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 19:57:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZxAgts7y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A779D20672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbeLIT5d (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 9 Dec 2018 14:57:33 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40169 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbeLIT5c (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Dec 2018 14:57:32 -0500
Received: by mail-pg1-f196.google.com with SMTP id z10so3957129pgp.7;
        Sun, 09 Dec 2018 11:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=RM2/K/OGtwbFYER7/1SEB+4txdlY9HYQXdZcDSGjfo8=;
        b=ZxAgts7y2uumGC+3zGZPRaQYjhhiW4JDouSIvvvx3xVRXSNzWD7I5BabsHOZwRM8zd
         U08rmdUZiWyLSd4Hbx+GFjSBA2Tr2aGXBuMITXjx515J3TQxqHhFCmV0GezeG77OYv+a
         25lDbAUWz/Gbv6whrejCXKeIUb28fr5t36Kco3JDvDZt9HAoIjANJVi/8X3gM2LGSXJJ
         gvg+fs9ROUdhnDzl5CyN0OU73o7rNJLo3xWi8bzu3UcbTEIcse7v4/YmOYCLk1WIcRee
         2nNO9wGrND2vw+wC1W+HxFjzApCDEyJHdPTkNkuUr91cOr1GMbo49SDljm8XM9z2QzQy
         gtMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RM2/K/OGtwbFYER7/1SEB+4txdlY9HYQXdZcDSGjfo8=;
        b=te0EfLj42C58y13aqgeohMiurzH2cMmNSUAhGr42JpnKNaSmZt+jTdMeyoL+ZARuIj
         G/z3O+5Kl6dMMuycvTvWCLxyT1RiPr4wojd0suRxJym/C27vtGIdovtmvKhMuA1S2oz2
         5nuZm6ZZ+nkISQrFHxXRAMNLVUS7cDelfZ7J4bBH+bVI8973OQfaUU9/oyjHq1UzzOu7
         tBwvyNsVWAoM3M2H3icfdd/R5YfL1UoYDkCFcDY1s0cl9ZvGoKUpXivLxku1BLQdCfIW
         ysvAMLslXUFl7beGUDVRQhfhNOsF+CD1kAn95hHMBUC15MP3+Z/oPYdO53eB+fOvi4uo
         9myw==
X-Gm-Message-State: AA+aEWZRlBDY+kIFWt0Pghr+tYoU30ksGuSgaAO4EP/5Bw6mYmCf2hUn
        K7gWSNHF82407ZvL0bXTPYaqQuDw
X-Google-Smtp-Source: AFSGD/XNv2UxnquK5WCBH1RKgDgKGfnyqxVnK9aik8KRqfXc84N0gsQZCo5TQxfinGWVa6t189azWQ==
X-Received: by 2002:a63:314c:: with SMTP id x73mr8623818pgx.323.1544385451316;
        Sun, 09 Dec 2018 11:57:31 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id v191sm19860096pgb.77.2018.12.09.11.57.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Dec 2018 11:57:30 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
X-Google-Original-From: Steve Longerbeam <steve_longerbeam@mentor.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] media: imx: queue subdev events to reachable video devices
Date:   Sun,  9 Dec 2018 11:57:22 -0800
Message-Id: <20181209195722.26858-1-steve_longerbeam@mentor.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Steve Longerbeam <slongerbeam@gmail.com>

Forward events from a sub-device to its list of reachable video
devices.

Note this will queue the event to a video device even if there is
no actual _enabled_ media path from the sub-device to the video device.
So a future improvement is to skip the video device if there is no enabled
path to it from the sub-device. The entity->pipe pointer can't be
used for this check because in imx-media a sub-device can be a
member to more than one streaming pipeline at a time.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
 drivers/staging/media/imx/imx-media-capture.c | 18 ++++++++++++++
 drivers/staging/media/imx/imx-media-dev.c     | 24 +++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
index b37e1186eb2f..4dfbe05d203e 100644
--- a/drivers/staging/media/imx/imx-media-capture.c
+++ b/drivers/staging/media/imx/imx-media-capture.c
@@ -335,6 +335,21 @@ static int capture_s_parm(struct file *file, void *fh,
 	return 0;
 }
 
+static int capture_subscribe_event(struct v4l2_fh *fh,
+				   const struct v4l2_event_subscription *sub)
+{
+	switch (sub->type) {
+	case V4L2_EVENT_IMX_FRAME_INTERVAL_ERROR:
+		return v4l2_event_subscribe(fh, sub, 0, NULL);
+	case V4L2_EVENT_SOURCE_CHANGE:
+		return v4l2_src_change_event_subscribe(fh, sub);
+	case V4L2_EVENT_CTRL:
+		return v4l2_ctrl_subscribe_event(fh, sub);
+	default:
+		return -EINVAL;
+	}
+}
+
 static const struct v4l2_ioctl_ops capture_ioctl_ops = {
 	.vidioc_querycap	= vidioc_querycap,
 
@@ -362,6 +377,9 @@ static const struct v4l2_ioctl_ops capture_ioctl_ops = {
 	.vidioc_expbuf		= vb2_ioctl_expbuf,
 	.vidioc_streamon	= vb2_ioctl_streamon,
 	.vidioc_streamoff	= vb2_ioctl_streamoff,
+
+	.vidioc_subscribe_event = capture_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 /*
diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index 4b344a4a3706..25e916562c66 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -442,6 +442,29 @@ static const struct media_device_ops imx_media_md_ops = {
 	.link_notify = imx_media_link_notify,
 };
 
+static void imx_media_notify(struct v4l2_subdev *sd,
+			     unsigned int notification,
+			     void *arg)
+{
+	struct media_entity *entity = &sd->entity;
+	int i;
+
+	if (notification != V4L2_DEVICE_NOTIFY_EVENT)
+		return;
+
+	for (i = 0; i < entity->num_pads; i++) {
+		struct media_pad *pad = &entity->pads[i];
+		struct imx_media_pad_vdev *pad_vdev;
+		struct list_head *pad_vdev_list;
+
+		pad_vdev_list = to_pad_vdev_list(sd, pad->index);
+		if (!pad_vdev_list)
+			continue;
+		list_for_each_entry(pad_vdev, pad_vdev_list, list)
+			v4l2_event_queue(pad_vdev->vdev->vfd, arg);
+	}
+}
+
 static int imx_media_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -462,6 +485,7 @@ static int imx_media_probe(struct platform_device *pdev)
 	mutex_init(&imxmd->mutex);
 
 	imxmd->v4l2_dev.mdev = &imxmd->md;
+	imxmd->v4l2_dev.notify = imx_media_notify;
 	strscpy(imxmd->v4l2_dev.name, "imx-media",
 		sizeof(imxmd->v4l2_dev.name));
 
-- 
2.17.1

