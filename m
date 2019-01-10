Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1D79C43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 12:43:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72F8C214C6
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 12:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbfAJMnt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 07:43:49 -0500
Received: from mga07.intel.com ([134.134.136.100]:43983 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727623AbfAJMnt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 07:43:49 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2019 04:43:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,461,1539673200"; 
   d="scan'208";a="113669148"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga007.fm.intel.com with ESMTP; 10 Jan 2019 04:43:47 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 26673204FB;
        Thu, 10 Jan 2019 14:43:46 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1ghZg8-0005pD-29; Thu, 10 Jan 2019 14:43:20 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, Thierry Reding <treding@nvidia.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 1/1] v4l: ioctl: Validate num_planes before using it
Date:   Thu, 10 Jan 2019 14:43:19 +0200
Message-Id: <20190110124319.22230-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The for loop to reset the memory of the plane reserved fields runs over
num_planes provided by the user without validating it. Ensure num_planes
is no more than VIDEO_MAX_PLANES before the loop.

Fixes: 4e1e0eb0e074 ("media: v4l2-ioctl: Zero v4l2_plane_pix_format reserved fields")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Hi folks,

This patch goes on top of Thierry's patch "media: v4l2-ioctl: Clear only
per-plane reserved fields".

 drivers/media/v4l2-core/v4l2-ioctl.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 392f1228af7b5..9e68a608ac6d3 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1551,6 +1551,8 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!ops->vidioc_s_fmt_vid_cap_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
+		if (p->fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
+			break;
 		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
 			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i], bytesperline);
 		return ops->vidioc_s_fmt_vid_cap_mplane(file, fh, arg);
@@ -1581,6 +1583,8 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!ops->vidioc_s_fmt_vid_out_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
+		if (p->fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
+			break;
 		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
 			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i], bytesperline);
 		return ops->vidioc_s_fmt_vid_out_mplane(file, fh, arg);
@@ -1648,6 +1652,8 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!ops->vidioc_try_fmt_vid_cap_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
+		if (p->fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
+			break;
 		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
 			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i], bytesperline);
 		return ops->vidioc_try_fmt_vid_cap_mplane(file, fh, arg);
@@ -1678,6 +1684,8 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!ops->vidioc_try_fmt_vid_out_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
+		if (p->fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
+			break;
 		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
 			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i], bytesperline);
 		return ops->vidioc_try_fmt_vid_out_mplane(file, fh, arg);
-- 
2.11.0

