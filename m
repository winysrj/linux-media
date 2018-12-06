Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 957CFC04EB8
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 19:46:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E2962054F
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 19:46:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E2962054F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=collabora.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbeLFTqu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 14:46:50 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:54918 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbeLFTqu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Dec 2018 14:46:50 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 8348A270D92
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Tomasz Figa <tfiga@chromium.org>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v3] v4l2-ioctl: Zero v4l2_plane_pix_format reserved fields
Date:   Thu,  6 Dec 2018 16:46:39 -0300
Message-Id: <20181206194639.13472-1-ezequiel@collabora.com>
X-Mailer: git-send-email 2.20.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Make the core set the reserved fields to zero in
vv4l2_pix_format_mplane.4l2_plane_pix_format,
for _MPLANE queue types.

Moving this to the core avoids having to do so in each
and every driver.

Suggested-by: Tomasz Figa <tfiga@chromium.org>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
--
v3:
  * s/int/unsigned int, suggested by Sakari

v2:
  * Drop unneeded clear in g_fmt.
    The sturct was already being cleared here.
  * Only zero plane_fmt reserved fields.
  * Use CLEAR_FIELD_MACRO.

 drivers/media/v4l2-core/v4l2-ioctl.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index e384142d2826..7e8e7915c041 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1512,6 +1512,7 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_format *p = arg;
 	struct video_device *vfd = video_devdata(file);
 	int ret = check_fmt(file, p->type);
+	unsigned int i;
 
 	if (ret)
 		return ret;
@@ -1536,6 +1537,8 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!ops->vidioc_s_fmt_vid_cap_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
+		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
+			CLEAR_AFTER_FIELD(p, fmt.pix_mp.plane_fmt[i].bytesperline);
 		return ops->vidioc_s_fmt_vid_cap_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 		if (unlikely(!ops->vidioc_s_fmt_vid_overlay))
@@ -1564,6 +1567,8 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!ops->vidioc_s_fmt_vid_out_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
+		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
+			CLEAR_AFTER_FIELD(p, fmt.pix_mp.plane_fmt[i].bytesperline);
 		return ops->vidioc_s_fmt_vid_out_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
 		if (unlikely(!ops->vidioc_s_fmt_vid_out_overlay))
@@ -1604,6 +1609,7 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 {
 	struct v4l2_format *p = arg;
 	int ret = check_fmt(file, p->type);
+	unsigned int i;
 
 	if (ret)
 		return ret;
@@ -1623,6 +1629,8 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!ops->vidioc_try_fmt_vid_cap_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
+		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
+			CLEAR_AFTER_FIELD(p, fmt.pix_mp.plane_fmt[i].bytesperline);
 		return ops->vidioc_try_fmt_vid_cap_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 		if (unlikely(!ops->vidioc_try_fmt_vid_overlay))
@@ -1651,6 +1659,8 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!ops->vidioc_try_fmt_vid_out_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
+		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
+			CLEAR_AFTER_FIELD(p, fmt.pix_mp.plane_fmt[i].bytesperline);
 		return ops->vidioc_try_fmt_vid_out_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
 		if (unlikely(!ops->vidioc_try_fmt_vid_out_overlay))
-- 
2.20.0.rc1

