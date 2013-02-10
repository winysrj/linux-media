Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3234 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab3BJMuW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 07:50:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 05/19] bttv: disable g/s_tuner and g/s_freq when no tuner present, fix return codes.
Date: Sun, 10 Feb 2013 13:50:00 +0100
Message-Id: <26df9aec1aa88f2d77d8434a97530f809e22bd93.1360500224.git.hans.verkuil@cisco.com>
In-Reply-To: <1360500614-15122-1-git-send-email-hverkuil@xs4all.nl>
References: <1360500614-15122-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <7737b9a5554e0487bf83dd3d51cae2d8f76603ab.1360500224.git.hans.verkuil@cisco.com>
References: <7737b9a5554e0487bf83dd3d51cae2d8f76603ab.1360500224.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

If no tuner is present, then disable the tuner and frequency ioctls.
We can remove a number of checks from those ioctls testing for the presence
of a tuner.

Also remove some tuner type checks (now done by the core) and fix an
error return when the prio check fails.

Finally some 'unlikely' statements are removed since those only make sense
in tightly often executed loops, otherwise they just clutter up the code.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c |   44 ++++++++++++---------------------
 1 file changed, 16 insertions(+), 28 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index a02c031..228b7c1 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -1984,25 +1984,17 @@ static int bttv_s_tuner(struct file *file, void *priv,
 	struct bttv *btv = fh->btv;
 	int err;
 
-	if (unlikely(0 != t->index))
+	if (t->index)
 		return -EINVAL;
 
-	if (unlikely(btv->tuner_type == TUNER_ABSENT)) {
-		err = -EINVAL;
-		goto err;
-	}
-
 	err = v4l2_prio_check(&btv->prio, fh->prio);
-	if (unlikely(err))
-		goto err;
+	if (err)
+		return err;
 
 	bttv_call_all(btv, tuner, s_tuner, t);
 
 	if (btv->audio_mode_gpio)
 		btv->audio_mode_gpio(btv, t, 1);
-
-err:
-
 	return 0;
 }
 
@@ -2012,9 +2004,10 @@ static int bttv_g_frequency(struct file *file, void *priv,
 	struct bttv_fh *fh  = priv;
 	struct bttv *btv = fh->btv;
 
-	f->type = btv->radio_user ? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
-	f->frequency = btv->freq;
+	if (f->tuner)
+		return -EINVAL;
 
+	f->frequency = btv->freq;
 	return 0;
 }
 
@@ -2025,24 +2018,17 @@ static int bttv_s_frequency(struct file *file, void *priv,
 	struct bttv *btv = fh->btv;
 	int err;
 
-	if (unlikely(f->tuner != 0))
+	if (f->tuner)
 		return -EINVAL;
 
 	err = v4l2_prio_check(&btv->prio, fh->prio);
-	if (unlikely(err))
-		goto err;
+	if (err)
+		return err;
 
-	if (unlikely(f->type != (btv->radio_user
-		? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV))) {
-		err = -EINVAL;
-		goto err;
-	}
 	btv->freq = f->frequency;
 	bttv_call_all(btv, tuner, s_frequency, f);
 	if (btv->has_matchbox && btv->radio_user)
 		tea5757_set_freq(btv, btv->freq);
-err:
-
 	return 0;
 }
 
@@ -2983,8 +2969,6 @@ static int bttv_g_tuner(struct file *file, void *priv,
 	struct bttv_fh *fh = priv;
 	struct bttv *btv = fh->btv;
 
-	if (btv->tuner_type == TUNER_ABSENT)
-		return -EINVAL;
 	if (0 != t->index)
 		return -EINVAL;
 
@@ -3467,8 +3451,6 @@ static int radio_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 	struct bttv_fh *fh = priv;
 	struct bttv *btv = fh->btv;
 
-	if (btv->tuner_type == TUNER_ABSENT)
-		return -EINVAL;
 	if (0 != t->index)
 		return -EINVAL;
 	strcpy(t->name, "Radio");
@@ -4112,7 +4094,7 @@ static irqreturn_t bttv_irq(int irq, void *dev_id)
 
 
 /* ----------------------------------------------------------------------- */
-/* initialitation                                                          */
+/* initialization                                                          */
 
 static struct video_device *vdev_init(struct bttv *btv,
 				      const struct video_device *template,
@@ -4131,6 +4113,12 @@ static struct video_device *vdev_init(struct bttv *btv,
 	snprintf(vfd->name, sizeof(vfd->name), "BT%d%s %s (%s)",
 		 btv->id, (btv->id==848 && btv->revision==0x12) ? "A" : "",
 		 type_name, bttv_tvcards[btv->c.type].name);
+	if (btv->tuner_type == TUNER_ABSENT) {
+		v4l2_disable_ioctl(vfd, VIDIOC_G_FREQUENCY);
+		v4l2_disable_ioctl(vfd, VIDIOC_S_FREQUENCY);
+		v4l2_disable_ioctl(vfd, VIDIOC_G_TUNER);
+		v4l2_disable_ioctl(vfd, VIDIOC_S_TUNER);
+	}
 	return vfd;
 }
 
-- 
1.7.10.4

