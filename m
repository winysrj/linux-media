Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:50115 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752393AbbCIVXL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 17:23:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 05/18] marvell-ccic: fill in colorspace
Date: Mon,  9 Mar 2015 22:22:10 +0100
Message-Id: <1425936143-5658-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
References: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The colorspace field wasn't filled in properly. This fixes a v4l2-compliance
failure.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 76357cf..7e54cef 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -188,6 +188,7 @@ static const struct v4l2_pix_format mcam_def_pix_format = {
 	.field		= V4L2_FIELD_NONE,
 	.bytesperline	= VGA_WIDTH*2,
 	.sizeimage	= VGA_WIDTH*VGA_HEIGHT*2,
+	.colorspace	= V4L2_COLORSPACE_SRGB,
 };
 
 static const u32 mcam_def_mbus_code = MEDIA_BUS_FMT_YUYV8_2X8;
@@ -1437,6 +1438,7 @@ static int mcam_vidioc_try_fmt_vid_cap(struct file *filp, void *priv,
 		break;
 	}
 	pix->sizeimage = pix->height * pix->bytesperline;
+	pix->colorspace = V4L2_COLORSPACE_SRGB;
 	return ret;
 }
 
-- 
2.1.4

