Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:18920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421Ab0IPA7H (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 20:59:07 -0400
Date: Wed, 15 Sep 2010 21:56:37 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4/8] V4L/DVB: bttv: fix driver lock and remove explicit
 calls to BKL
Message-ID: <20100915215637.3b98ed56@pedra>
In-Reply-To: <cover.1284597566.git.mchehab@redhat.com>
References: <cover.1284597566.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index fcafe2f..5f5cd4a 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -1859,21 +1859,25 @@ static int bttv_s_std(struct file *file, void *priv, v4l2_std_id *id)
 	unsigned int i;
 	int err;
 
+	mutex_lock(&btv->lock);
 	err = v4l2_prio_check(&btv->prio, fh->prio);
-	if (0 != err)
-		return err;
+	if (err)
+		goto err;
 
 	for (i = 0; i < BTTV_TVNORMS; i++)
 		if (*id & bttv_tvnorms[i].v4l2_id)
 			break;
-	if (i == BTTV_TVNORMS)
-		return -EINVAL;
+	if (i == BTTV_TVNORMS) {
+		err = -EINVAL;
+		goto err;
+	}
 
-	mutex_lock(&btv->lock);
 	set_tvnorm(btv, i);
+
+err:
 	mutex_unlock(&btv->lock);
 
-	return 0;
+	return err;
 }
 
 static int bttv_querystd(struct file *file, void *f, v4l2_std_id *id)
@@ -1893,10 +1897,13 @@ static int bttv_enum_input(struct file *file, void *priv,
 {
 	struct bttv_fh *fh = priv;
 	struct bttv *btv = fh->btv;
-	int n;
+	int rc = 0;
 
-	if (i->index >= bttv_tvcards[btv->c.type].video_inputs)
-		return -EINVAL;
+	mutex_lock(&btv->lock);
+	if (i->index >= bttv_tvcards[btv->c.type].video_inputs) {
+		rc = -EINVAL;
+		goto err;
+	}
 
 	i->type     = V4L2_INPUT_TYPE_CAMERA;
 	i->audioset = 1;
@@ -1919,10 +1926,12 @@ static int bttv_enum_input(struct file *file, void *priv,
 			i->status |= V4L2_IN_ST_NO_H_LOCK;
 	}
 
-	for (n = 0; n < BTTV_TVNORMS; n++)
-		i->std |= bttv_tvnorms[n].v4l2_id;
+	i->std = BTTV_NORMS;
 
-	return 0;
+err:
+	mutex_unlock(&btv->lock);
+
+	return rc;
 }
 
 static int bttv_g_input(struct file *file, void *priv, unsigned int *i)
@@ -1930,7 +1939,10 @@ static int bttv_g_input(struct file *file, void *priv, unsigned int *i)
 	struct bttv_fh *fh = priv;
 	struct bttv *btv = fh->btv;
 
+	mutex_lock(&btv->lock);
 	*i = btv->input;
+	mutex_unlock(&btv->lock);
+
 	return 0;
 }
 
@@ -1941,15 +1953,19 @@ static int bttv_s_input(struct file *file, void *priv, unsigned int i)
 
 	int err;
 
-	err = v4l2_prio_check(&btv->prio, fh->prio);
-	if (0 != err)
-		return err;
-
-	if (i > bttv_tvcards[btv->c.type].video_inputs)
-		return -EINVAL;
-
 	mutex_lock(&btv->lock);
+	err = v4l2_prio_check(&btv->prio, fh->prio);
+	if (unlikely(err))
+		goto err;
+
+	if (i > bttv_tvcards[btv->c.type].video_inputs) {
+		err = -EINVAL;
+		goto err;
+	}
+
 	set_input(btv, i, btv->tvnorm);
+
+err:
 	mutex_unlock(&btv->lock);
 	return 0;
 }
@@ -1961,22 +1977,25 @@ static int bttv_s_tuner(struct file *file, void *priv,
 	struct bttv *btv = fh->btv;
 	int err;
 
-	err = v4l2_prio_check(&btv->prio, fh->prio);
-	if (0 != err)
-		return err;
-
-	if (btv->tuner_type == TUNER_ABSENT)
-		return -EINVAL;
-
-	if (0 != t->index)
+	if (unlikely(0 != t->index))
 		return -EINVAL;
 
 	mutex_lock(&btv->lock);
+	if (unlikely(btv->tuner_type == TUNER_ABSENT)) {
+		err = -EINVAL;
+		goto err;
+	}
+
+	err = v4l2_prio_check(&btv->prio, fh->prio);
+	if (unlikely(err))
+		goto err;
+
 	bttv_call_all(btv, tuner, s_tuner, t);
 
 	if (btv->audio_mode_gpio)
 		btv->audio_mode_gpio(btv, t, 1);
 
+err:
 	mutex_unlock(&btv->lock);
 
 	return 0;
@@ -1988,8 +2007,10 @@ static int bttv_g_frequency(struct file *file, void *priv,
 	struct bttv_fh *fh  = priv;
 	struct bttv *btv = fh->btv;
 
+	mutex_lock(&btv->lock);
 	f->type = btv->radio_user ? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 	f->frequency = btv->freq;
+	mutex_unlock(&btv->lock);
 
 	return 0;
 }
@@ -2001,21 +2022,26 @@ static int bttv_s_frequency(struct file *file, void *priv,
 	struct bttv *btv = fh->btv;
 	int err;
 
-	err = v4l2_prio_check(&btv->prio, fh->prio);
-	if (0 != err)
-		return err;
-
 	if (unlikely(f->tuner != 0))
 		return -EINVAL;
+
+	mutex_lock(&btv->lock);
+	err = v4l2_prio_check(&btv->prio, fh->prio);
+	if (unlikely(err))
+		goto err;
+
 	if (unlikely(f->type != (btv->radio_user
-		? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV)))
-		return -EINVAL;
-	mutex_lock(&btv->lock);
+		? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV))) {
+		err = -EINVAL;
+		goto err;
+	}
 	btv->freq = f->frequency;
 	bttv_call_all(btv, tuner, s_frequency, f);
 	if (btv->has_matchbox && btv->radio_user)
 		tea5757_set_freq(btv, btv->freq);
+err:
 	mutex_unlock(&btv->lock);
+
 	return 0;
 }
 
@@ -2257,7 +2283,9 @@ verify_window_lock		(struct bttv_fh *               fh,
 	if (V4L2_FIELD_ANY == field) {
 		__s32 height2;
 
+		mutex_lock(&fh->btv->lock);
 		height2 = fh->btv->crop[!!fh->do_crop].rect.height >> 1;
+		mutex_unlock(&fh->btv->lock);
 		field = (win->w.height > height2)
 			? V4L2_FIELD_INTERLACED
 			: V4L2_FIELD_TOP;
@@ -2332,6 +2360,8 @@ static int setup_window_lock(struct bttv_fh *fh, struct bttv *btv,
 			return -EFAULT;
 		}
 	}
+
+	mutex_lock(&fh->cap.vb_lock);
 	/* clip against screen */
 	if (NULL != btv->fbuf.base)
 		n = btcx_screen_clips(btv->fbuf.fmt.width, btv->fbuf.fmt.height,
@@ -2354,7 +2384,6 @@ static int setup_window_lock(struct bttv_fh *fh, struct bttv *btv,
 		BUG();
 	}
 
-	mutex_lock(&fh->cap.vb_lock);
 	kfree(fh->ov.clips);
 	fh->ov.clips    = clips;
 	fh->ov.nclips   = n;
@@ -2362,6 +2391,14 @@ static int setup_window_lock(struct bttv_fh *fh, struct bttv *btv,
 	fh->ov.w        = win->w;
 	fh->ov.field    = win->field;
 	fh->ov.setup_ok = 1;
+
+	/*
+	 * FIXME: btv is protected by btv->lock mutex, while btv->init
+	 *	  is protected by fh->cap.vb_lock. This seems to open the
+	 *	  possibility for some race situations. Maybe the better would
+	 *	  be to unify those locks or to use another way to store the
+	 *	  init values that will be consumed by videobuf callbacks
+	 */
 	btv->init.ov.w.width   = win->w.width;
 	btv->init.ov.w.height  = win->w.height;
 	btv->init.ov.field     = win->field;
@@ -2490,7 +2527,9 @@ static int bttv_try_fmt_vid_cap(struct file *file, void *priv,
 	if (V4L2_FIELD_ANY == field) {
 		__s32 height2;
 
+		mutex_lock(&btv->lock);
 		height2 = btv->crop[!!fh->do_crop].rect.height >> 1;
+		mutex_unlock(&btv->lock);
 		field = (f->fmt.pix.height > height2)
 			? V4L2_FIELD_INTERLACED
 			: V4L2_FIELD_BOTTOM;
@@ -2651,11 +2690,15 @@ static int bttv_querycap(struct file *file, void  *priv,
 		V4L2_CAP_VBI_CAPTURE |
 		V4L2_CAP_READWRITE |
 		V4L2_CAP_STREAMING;
-	if (btv->has_saa6588)
-		cap->capabilities |= V4L2_CAP_RDS_CAPTURE;
 	if (no_overlay <= 0)
 		cap->capabilities |= V4L2_CAP_VIDEO_OVERLAY;
 
+	/*
+	 * No need to lock here: those vars are initialized during board
+	 * probe and remains untouched during the rest of the driver lifecycle
+	 */
+	if (btv->has_saa6588)
+		cap->capabilities |= V4L2_CAP_RDS_CAPTURE;
 	if (btv->tuner_type != TUNER_ABSENT)
 		cap->capabilities |= V4L2_CAP_TUNER;
 	return 0;
@@ -2730,16 +2773,22 @@ static int bttv_overlay(struct file *file, void *f, unsigned int on)
 	struct bttv_fh *fh = f;
 	struct bttv *btv = fh->btv;
 	struct bttv_buffer *new;
-	int retval;
+	int retval = 0;
 
 	if (on) {
+		mutex_lock(&fh->cap.vb_lock);
 		/* verify args */
-		if (NULL == btv->fbuf.base)
+		if (unlikely(!btv->fbuf.base)) {
+			mutex_unlock(&fh->cap.vb_lock);
 			return -EINVAL;
-		if (!fh->ov.setup_ok) {
+		}
+		if (unlikely(!fh->ov.setup_ok)) {
 			dprintk("bttv%d: overlay: !setup_ok\n", btv->c.nr);
-			return -EINVAL;
+			retval = -EINVAL;
 		}
+		if (retval)
+			return retval;
+		mutex_unlock(&fh->cap.vb_lock);
 	}
 
 	if (!check_alloc_btres_lock(btv, fh, RESOURCE_OVERLAY))
@@ -2907,6 +2956,7 @@ static int bttv_queryctrl(struct file *file, void *priv,
 	     c->id >= V4L2_CID_PRIVATE_LASTP1))
 		return -EINVAL;
 
+	mutex_lock(&btv->lock);
 	if (!btv->volume_gpio && (c->id == V4L2_CID_AUDIO_VOLUME))
 		*c = no_ctl;
 	else {
@@ -2914,6 +2964,7 @@ static int bttv_queryctrl(struct file *file, void *priv,
 
 		*c = (NULL != ctrl) ? *ctrl : no_ctl;
 	}
+	mutex_unlock(&btv->lock);
 
 	return 0;
 }
@@ -2924,8 +2975,11 @@ static int bttv_g_parm(struct file *file, void *f,
 	struct bttv_fh *fh = f;
 	struct bttv *btv = fh->btv;
 
+	mutex_lock(&btv->lock);
 	v4l2_video_std_frame_period(bttv_tvnorms[btv->tvnorm].v4l2_id,
 				    &parm->parm.capture.timeperframe);
+	mutex_unlock(&btv->lock);
+
 	return 0;
 }
 
@@ -2961,7 +3015,9 @@ static int bttv_g_priority(struct file *file, void *f, enum v4l2_priority *p)
 	struct bttv_fh *fh = f;
 	struct bttv *btv = fh->btv;
 
+	mutex_lock(&btv->lock);
 	*p = v4l2_prio_max(&btv->prio);
+	mutex_unlock(&btv->lock);
 
 	return 0;
 }
@@ -2971,8 +3027,13 @@ static int bttv_s_priority(struct file *file, void *f,
 {
 	struct bttv_fh *fh = f;
 	struct bttv *btv = fh->btv;
+	int	rc;
 
-	return v4l2_prio_change(&btv->prio, &fh->prio, prio);
+	mutex_lock(&btv->lock);
+	rc = v4l2_prio_change(&btv->prio, &fh->prio, prio);
+	mutex_unlock(&btv->lock);
+
+	return rc;
 }
 
 static int bttv_cropcap(struct file *file, void *priv,
@@ -2985,7 +3046,9 @@ static int bttv_cropcap(struct file *file, void *priv,
 	    cap->type != V4L2_BUF_TYPE_VIDEO_OVERLAY)
 		return -EINVAL;
 
+	mutex_lock(&btv->lock);
 	*cap = bttv_tvnorms[btv->tvnorm].cropcap;
+	mutex_unlock(&btv->lock);
 
 	return 0;
 }
@@ -3003,7 +3066,9 @@ static int bttv_g_crop(struct file *file, void *f, struct v4l2_crop *crop)
 	   inconsistent with fh->width or fh->height and apps
 	   do not expect a change here. */
 
+	mutex_lock(&btv->lock);
 	crop->c = btv->crop[!!fh->do_crop].rect;
+	mutex_unlock(&btv->lock);
 
 	return 0;
 }
@@ -3024,14 +3089,15 @@ static int bttv_s_crop(struct file *file, void *f, struct v4l2_crop *crop)
 	    crop->type != V4L2_BUF_TYPE_VIDEO_OVERLAY)
 		return -EINVAL;
 
-	retval = v4l2_prio_check(&btv->prio, fh->prio);
-	if (0 != retval)
-		return retval;
-
 	/* Make sure tvnorm, vbi_end and the current cropping
 	   parameters remain consistent until we're done. Note
 	   read() may change vbi_end in check_alloc_btres_lock(). */
 	mutex_lock(&btv->lock);
+	retval = v4l2_prio_check(&btv->prio, fh->prio);
+	if (0 != retval) {
+		mutex_unlock(&btv->lock);
+		return retval;
+	}
 
 	retval = -EBUSY;
 
@@ -3221,21 +3287,32 @@ static int bttv_open(struct file *file)
 		return -ENODEV;
 	}
 
-	lock_kernel();
-
 	dprintk(KERN_DEBUG "bttv%d: open called (type=%s)\n",
 		btv->c.nr,v4l2_type_names[type]);
 
 	/* allocate per filehandle data */
-	fh = kmalloc(sizeof(*fh),GFP_KERNEL);
-	if (NULL == fh) {
-		unlock_kernel();
+	fh = kmalloc(sizeof(*fh), GFP_KERNEL);
+	if (unlikely(!fh))
 		return -ENOMEM;
-	}
 	file->private_data = fh;
+
+	/*
+	 * btv is protected by btv->lock mutex, while btv->init and other
+	 * streaming vars are protected by fh->cap.vb_lock. We need to take
+	 * care of both locks to avoid troubles. However, vb_lock is used also
+	 * inside videobuf, without calling buf->lock. So, it is a very bad
+	 * idea to hold both locks at the same time.
+	 * Let's first copy btv->init at fh, holding cap.vb_lock, and then work
+	 * with the rest of init, holding btv->lock.
+	 */
+	mutex_lock(&fh->cap.vb_lock);
 	*fh = btv->init;
+	mutex_unlock(&fh->cap.vb_lock);
+
 	fh->type = type;
 	fh->ov.setup_ok = 0;
+
+	mutex_lock(&btv->lock);
 	v4l2_prio_open(&btv->prio, &fh->prio);
 
 	videobuf_queue_sg_init(&fh->cap, &bttv_video_qops,
@@ -3272,7 +3349,7 @@ static int bttv_open(struct file *file)
 	bttv_vbi_fmt_reset(&fh->vbi_fmt, btv->tvnorm);
 
 	bttv_field_count(btv);
-	unlock_kernel();
+	mutex_unlock(&btv->lock);
 	return 0;
 }
 
@@ -3281,6 +3358,7 @@ static int bttv_release(struct file *file)
 	struct bttv_fh *fh = file->private_data;
 	struct bttv *btv = fh->btv;
 
+	mutex_lock(&btv->lock);
 	/* turn off overlay */
 	if (check_btres(fh, RESOURCE_OVERLAY))
 		bttv_switch_overlay(btv,fh,NULL);
@@ -3305,8 +3383,15 @@ static int bttv_release(struct file *file)
 	}
 
 	/* free stuff */
+
+	/*
+	 * videobuf uses cap.vb_lock - we should avoid holding btv->lock,
+	 * otherwise we may have dead lock conditions
+	 */
+	mutex_unlock(&btv->lock);
 	videobuf_mmap_free(&fh->cap);
 	videobuf_mmap_free(&fh->vbi);
+	mutex_lock(&btv->lock);
 	v4l2_prio_close(&btv->prio, fh->prio);
 	file->private_data = NULL;
 	kfree(fh);
@@ -3316,6 +3401,7 @@ static int bttv_release(struct file *file)
 
 	if (!btv->users)
 		audio_mute(btv, 1);
+	mutex_unlock(&btv->lock);
 
 	return 0;
 }
@@ -3412,21 +3498,19 @@ static int radio_open(struct file *file)
 
 	dprintk("bttv: open dev=%s\n", video_device_node_name(vdev));
 
-	lock_kernel();
-
 	dprintk("bttv%d: open called (radio)\n",btv->c.nr);
 
 	/* allocate per filehandle data */
 	fh = kmalloc(sizeof(*fh), GFP_KERNEL);
-	if (NULL == fh) {
-		unlock_kernel();
+	if (unlikely(!fh))
 		return -ENOMEM;
-	}
 	file->private_data = fh;
+	mutex_lock(&fh->cap.vb_lock);
 	*fh = btv->init;
-	v4l2_prio_open(&btv->prio, &fh->prio);
+	mutex_unlock(&fh->cap.vb_lock);
 
 	mutex_lock(&btv->lock);
+	v4l2_prio_open(&btv->prio, &fh->prio);
 
 	btv->radio_user++;
 
@@ -3434,7 +3518,6 @@ static int radio_open(struct file *file)
 	audio_input(btv,TVAUDIO_INPUT_RADIO);
 
 	mutex_unlock(&btv->lock);
-	unlock_kernel();
 	return 0;
 }
 
@@ -3444,6 +3527,7 @@ static int radio_release(struct file *file)
 	struct bttv *btv = fh->btv;
 	struct rds_command cmd;
 
+	mutex_lock(&btv->lock);
 	v4l2_prio_close(&btv->prio, fh->prio);
 	file->private_data = NULL;
 	kfree(fh);
@@ -3451,6 +3535,7 @@ static int radio_release(struct file *file)
 	btv->radio_user--;
 
 	bttv_call_all(btv, core, ioctl, RDS_CMD_CLOSE, &cmd);
+	mutex_unlock(&btv->lock);
 
 	return 0;
 }
-- 
1.7.1


