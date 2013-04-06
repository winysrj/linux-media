Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3146 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932864Ab3DFL0L (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Apr 2013 07:26:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 7/7] ivtv: add g_chip_info support.
Date: Sat,  6 Apr 2013 13:25:52 +0200
Message-Id: <1365247552-26795-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365247552-26795-1-git-send-email-hverkuil@xs4all.nl>
References: <1365247552-26795-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/ivtv/ivtv-ioctl.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index 9cbbce0..f9162aa 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -762,6 +762,24 @@ static int ivtv_s_register(struct file *file, void *fh, const struct v4l2_dbg_re
 	ivtv_call_all(itv, core, s_register, reg);
 	return 0;
 }
+
+static int ivtv_g_chip_info(struct file *file, void *fh, struct v4l2_dbg_chip_info *chip)
+{
+	struct ivtv *itv = fh2id(fh)->itv;
+
+	if (chip->match.addr || chip->range > (itv->has_cx23415 ? 1 : 0))
+		return -EINVAL;
+	if (chip->range == 0) {
+		strlcpy(chip->range_name, "cx23416", sizeof(chip->range_name));
+		chip->range_start = IVTV_REG_OFFSET;
+		chip->range_size = IVTV_REG_SIZE;
+	} else {
+		strlcpy(chip->range_name, "cx23415", sizeof(chip->range_name));
+		chip->range_start = IVTV_DECODER_OFFSET;
+		chip->range_size = IVTV_DECODER_SIZE;
+	}
+	return 0;
+}
 #endif
 
 static int ivtv_querycap(struct file *file, void *fh, struct v4l2_capability *vcap)
@@ -1916,6 +1934,7 @@ static const struct v4l2_ioctl_ops ivtv_ioctl_ops = {
 	.vidioc_g_sliced_vbi_cap 	    = ivtv_g_sliced_vbi_cap,
 	.vidioc_g_chip_ident 		    = ivtv_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
+	.vidioc_g_chip_info		    = ivtv_g_chip_info,
 	.vidioc_g_register 		    = ivtv_g_register,
 	.vidioc_s_register 		    = ivtv_s_register,
 #endif
-- 
1.7.10.4

