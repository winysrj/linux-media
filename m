Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3492 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757426Ab3BFP4x (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 10:56:53 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 14/17] bttv: fix priority handling.
Date: Wed,  6 Feb 2013 16:56:32 +0100
Message-Id: <23b488d195a537cf9e795966c771394e4bf1a99c.1360165855.git.hans.verkuil@cisco.com>
In-Reply-To: <1360166195-18010-1-git-send-email-hverkuil@xs4all.nl>
References: <1360166195-18010-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <c5d83e654c3cfd166ee832f83458c19904851980.1360165855.git.hans.verkuil@cisco.com>
References: <c5d83e654c3cfd166ee832f83458c19904851980.1360165855.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Replace the - incorrect - manual priority handling with the core priority
implementation.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c |   61 ++++-----------------------------
 drivers/media/pci/bt8xx/bttvp.h       |    6 ----
 2 files changed, 6 insertions(+), 61 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 96aa2c9..559c1d9 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -1706,11 +1706,7 @@ static int bttv_s_std(struct file *file, void *priv, v4l2_std_id *id)
 	struct bttv_fh *fh  = priv;
 	struct bttv *btv = fh->btv;
 	unsigned int i;
-	int err;
-
-	err = v4l2_prio_check(&btv->prio, fh->prio);
-	if (err)
-		goto err;
+	int err = 0;
 
 	for (i = 0; i < BTTV_TVNORMS; i++)
 		if (*id & bttv_tvnorms[i].v4l2_id)
@@ -1793,11 +1789,6 @@ static int bttv_s_input(struct file *file, void *priv, unsigned int i)
 {
 	struct bttv_fh *fh  = priv;
 	struct bttv *btv = fh->btv;
-	int err;
-
-	err = v4l2_prio_check(&btv->prio, fh->prio);
-	if (err)
-		return err;
 
 	if (i >= bttv_tvcards[btv->c.type].video_inputs)
 		return -EINVAL;
@@ -1811,15 +1802,10 @@ static int bttv_s_tuner(struct file *file, void *priv,
 {
 	struct bttv_fh *fh  = priv;
 	struct bttv *btv = fh->btv;
-	int err;
 
 	if (t->index)
 		return -EINVAL;
 
-	err = v4l2_prio_check(&btv->prio, fh->prio);
-	if (err)
-		return err;
-
 	bttv_call_all(btv, tuner, s_tuner, t);
 
 	if (btv->audio_mode_gpio)
@@ -1862,14 +1848,10 @@ static int bttv_s_frequency(struct file *file, void *priv,
 {
 	struct bttv_fh *fh  = priv;
 	struct bttv *btv = fh->btv;
-	int err;
 
 	if (f->tuner)
 		return -EINVAL;
 
-	err = v4l2_prio_check(&btv->prio, fh->prio);
-	if (err)
-		return err;
 	bttv_set_frequency(btv, f);
 	return 0;
 }
@@ -2808,28 +2790,6 @@ static int bttv_g_tuner(struct file *file, void *priv,
 	return 0;
 }
 
-static int bttv_g_priority(struct file *file, void *f, enum v4l2_priority *p)
-{
-	struct bttv_fh *fh = f;
-	struct bttv *btv = fh->btv;
-
-	*p = v4l2_prio_max(&btv->prio);
-
-	return 0;
-}
-
-static int bttv_s_priority(struct file *file, void *f,
-					enum v4l2_priority prio)
-{
-	struct bttv_fh *fh = f;
-	struct bttv *btv = fh->btv;
-	int	rc;
-
-	rc = v4l2_prio_change(&btv->prio, &fh->prio, prio);
-
-	return rc;
-}
-
 static int bttv_cropcap(struct file *file, void *priv,
 				struct v4l2_cropcap *cap)
 {
@@ -2882,11 +2842,6 @@ static int bttv_s_crop(struct file *file, void *f, const struct v4l2_crop *crop)
 	/* Make sure tvnorm, vbi_end and the current cropping
 	   parameters remain consistent until we're done. Note
 	   read() may change vbi_end in check_alloc_btres_lock(). */
-	retval = v4l2_prio_check(&btv->prio, fh->prio);
-	if (0 != retval) {
-		return retval;
-	}
-
 	retval = -EBUSY;
 
 	if (locked_btres(fh->btv, VIDEO_RESOURCES)) {
@@ -3068,8 +3023,6 @@ static int bttv_open(struct file *file)
 	fh->type = type;
 	fh->ov.setup_ok = 0;
 
-	v4l2_prio_open(&btv->prio, &fh->prio);
-
 	videobuf_queue_sg_init(&fh->cap, &bttv_video_qops,
 			    &btv->c.pci->dev, &btv->s_lock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
@@ -3139,7 +3092,6 @@ static int bttv_release(struct file *file)
 
 	videobuf_mmap_free(&fh->cap);
 	videobuf_mmap_free(&fh->vbi);
-	v4l2_prio_close(&btv->prio, fh->prio);
 	file->private_data = NULL;
 
 	btv->users--;
@@ -3207,8 +3159,6 @@ static const struct v4l2_ioctl_ops bttv_ioctl_ops = {
 	.vidioc_g_fbuf                  = bttv_g_fbuf,
 	.vidioc_s_fbuf                  = bttv_s_fbuf,
 	.vidioc_overlay                 = bttv_overlay,
-	.vidioc_g_priority              = bttv_g_priority,
-	.vidioc_s_priority              = bttv_s_priority,
 	.vidioc_g_parm                  = bttv_g_parm,
 	.vidioc_g_frequency             = bttv_g_frequency,
 	.vidioc_s_frequency             = bttv_s_frequency,
@@ -3249,13 +3199,13 @@ static int radio_open(struct file *file)
 		return -ENOMEM;
 	file->private_data = fh;
 	*fh = btv->init;
-
-	v4l2_prio_open(&btv->prio, &fh->prio);
+	v4l2_fh_init(&fh->fh, vdev);
 
 	btv->radio_user++;
 
 	bttv_call_all(btv, tuner, s_radio);
 	audio_input(btv,TVAUDIO_INPUT_RADIO);
+	v4l2_fh_add(&fh->fh);
 
 	return 0;
 }
@@ -3266,8 +3216,9 @@ static int radio_release(struct file *file)
 	struct bttv *btv = fh->btv;
 	struct saa6588_command cmd;
 
-	v4l2_prio_close(&btv->prio, fh->prio);
 	file->private_data = NULL;
+	v4l2_fh_del(&fh->fh);
+	v4l2_fh_exit(&fh->fh);
 	kfree(fh);
 
 	btv->radio_user--;
@@ -3929,6 +3880,7 @@ static struct video_device *vdev_init(struct bttv *btv,
 	vfd->v4l2_dev = &btv->c.v4l2_dev;
 	vfd->release = video_device_release;
 	vfd->debug   = bttv_debug;
+	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
 	video_set_drvdata(vfd, btv);
 	snprintf(vfd->name, sizeof(vfd->name), "BT%d%s %s (%s)",
 		 btv->id, (btv->id==848 && btv->revision==0x12) ? "A" : "",
@@ -4067,7 +4019,6 @@ static int bttv_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
 	INIT_LIST_HEAD(&btv->c.subs);
 	INIT_LIST_HEAD(&btv->capture);
 	INIT_LIST_HEAD(&btv->vcapture);
-	v4l2_prio_init(&btv->prio);
 
 	init_timer(&btv->timeout);
 	btv->timeout.function = bttv_irq_timeout;
diff --git a/drivers/media/pci/bt8xx/bttvp.h b/drivers/media/pci/bt8xx/bttvp.h
index 288cfd8..12cc4eb 100644
--- a/drivers/media/pci/bt8xx/bttvp.h
+++ b/drivers/media/pci/bt8xx/bttvp.h
@@ -221,9 +221,6 @@ struct bttv_fh {
 
 	struct bttv              *btv;
 	int resources;
-#ifdef VIDIOC_G_PRIORITY
-	enum v4l2_priority       prio;
-#endif
 	enum v4l2_buf_type       type;
 
 	/* video capture */
@@ -420,9 +417,6 @@ struct bttv {
 	spinlock_t s_lock;
 	struct mutex lock;
 	int resources;
-#ifdef VIDIOC_G_PRIORITY
-	struct v4l2_prio_state prio;
-#endif
 
 	/* video state */
 	unsigned int input;
-- 
1.7.10.4

