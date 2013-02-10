Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1158 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab3BJMuY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 07:50:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 15/19] bttv: use centralized std and implement g_std.
Date: Sun, 10 Feb 2013 13:50:10 +0100
Message-Id: <1ce067007cbb96ff13f7d9f9dd0a05f9b8548626.1360500224.git.hans.verkuil@cisco.com>
In-Reply-To: <1360500614-15122-1-git-send-email-hverkuil@xs4all.nl>
References: <1360500614-15122-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <7737b9a5554e0487bf83dd3d51cae2d8f76603ab.1360500224.git.hans.verkuil@cisco.com>
References: <7737b9a5554e0487bf83dd3d51cae2d8f76603ab.1360500224.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The 'current_norm' field cannot be used if multiple device nodes (video and
vbi in this case) set the same std.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c |   13 ++++++++++++-
 drivers/media/pci/bt8xx/bttvp.h       |    1 +
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 559c1d9..98b8fd2 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -1716,6 +1716,7 @@ static int bttv_s_std(struct file *file, void *priv, v4l2_std_id *id)
 		goto err;
 	}
 
+	btv->std = *id;
 	set_tvnorm(btv, i);
 
 err:
@@ -1723,6 +1724,15 @@ err:
 	return err;
 }
 
+static int bttv_g_std(struct file *file, void *priv, v4l2_std_id *id)
+{
+	struct bttv_fh *fh  = priv;
+	struct bttv *btv = fh->btv;
+
+	*id = btv->std;
+	return 0;
+}
+
 static int bttv_querystd(struct file *file, void *f, v4l2_std_id *id)
 {
 	struct bttv_fh *fh = f;
@@ -3147,6 +3157,7 @@ static const struct v4l2_ioctl_ops bttv_ioctl_ops = {
 	.vidioc_qbuf                    = bttv_qbuf,
 	.vidioc_dqbuf                   = bttv_dqbuf,
 	.vidioc_s_std                   = bttv_s_std,
+	.vidioc_g_std                   = bttv_g_std,
 	.vidioc_enum_input              = bttv_enum_input,
 	.vidioc_g_input                 = bttv_g_input,
 	.vidioc_s_input                 = bttv_s_input,
@@ -3177,7 +3188,6 @@ static struct video_device bttv_video_template = {
 	.fops         = &bttv_fops,
 	.ioctl_ops    = &bttv_ioctl_ops,
 	.tvnorms      = BTTV_NORMS,
-	.current_norm = V4L2_STD_PAL,
 };
 
 /* ----------------------------------------------------------------------- */
@@ -4173,6 +4183,7 @@ static int bttv_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
 		bttv_set_frequency(btv, &init_freq);
 		btv->radio_freq = 90500 * 16; /* 90.5Mhz default */
 	}
+	btv->std = V4L2_STD_PAL;
 	init_irqreg(btv);
 	v4l2_ctrl_handler_setup(hdl);
 
diff --git a/drivers/media/pci/bt8xx/bttvp.h b/drivers/media/pci/bt8xx/bttvp.h
index 12cc4eb..86d67bb 100644
--- a/drivers/media/pci/bt8xx/bttvp.h
+++ b/drivers/media/pci/bt8xx/bttvp.h
@@ -424,6 +424,7 @@ struct bttv {
 	unsigned int mute;
 	unsigned long tv_freq;
 	unsigned int tvnorm;
+	v4l2_std_id std;
 	int hue, contrast, bright, saturation;
 	struct v4l2_framebuffer fbuf;
 	unsigned int field_count;
-- 
1.7.10.4

