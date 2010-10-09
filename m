Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:55583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756067Ab0JIS3q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Oct 2010 14:29:46 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o99ITjcS010923
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 9 Oct 2010 14:29:45 -0400
Received: from [10.3.225.136] (vpn-225-136.phx2.redhat.com [10.3.225.136])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id o99ITgMT031255
	for <linux-media@vger.kernel.org>; Sat, 9 Oct 2010 14:29:43 -0400
Message-ID: <4CB0B496.9050702@redhat.com>
Date: Sat, 09 Oct 2010 15:29:42 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L/DVB: cx231xx: use core-assisted lock
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Instead of doing its own lock, use core-assisted one. As a bonus, it will do the
proper unlock during queue wait events. This fixes a long-standing bug where
softwares like tvtime would hang if you try to use cx231xx-alsa.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx231xx/cx231xx-video.c b/drivers/media/video/cx231xx/cx231xx-video.c
index 38367ee..b13b69f 100644
--- a/drivers/media/video/cx231xx/cx231xx-video.c
+++ b/drivers/media/video/cx231xx/cx231xx-video.c
@@ -1019,8 +1019,6 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 	struct cx231xx_fh *fh = priv;
 	struct cx231xx *dev = fh->dev;
 
-	mutex_lock(&dev->lock);
-
 	f->fmt.pix.width = dev->width;
 	f->fmt.pix.height = dev->height;
 	f->fmt.pix.pixelformat = dev->format->fourcc;
@@ -1030,8 +1028,6 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 
 	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
 
-	mutex_unlock(&dev->lock);
-
 	return 0;
 }
 
@@ -1092,26 +1088,20 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	if (rc < 0)
 		return rc;
 
-	mutex_lock(&dev->lock);
-
 	vidioc_try_fmt_vid_cap(file, priv, f);
 
 	fmt = format_by_fourcc(f->fmt.pix.pixelformat);
-	if (!fmt) {
-		rc = -EINVAL;
-		goto out;
-	}
+	if (!fmt)
+		return -EINVAL;
 
 	if (videobuf_queue_is_busy(&fh->vb_vidq)) {
 		cx231xx_errdev("%s queue busy\n", __func__);
-		rc = -EBUSY;
-		goto out;
+		return -EBUSY;
 	}
 
 	if (dev->stream_on && !fh->stream_on) {
 		cx231xx_errdev("%s device in use by another fh\n", __func__);
-		rc = -EBUSY;
-		goto out;
+		return -EBUSY;
 	}
 
 	/* set new image size */
@@ -1123,8 +1113,6 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	call_all(dev, video, s_mbus_fmt, &mbus_fmt);
 	v4l2_fill_pix_format(&f->fmt.pix, &mbus_fmt);
 
-out:
-	mutex_unlock(&dev->lock);
 	return rc;
 }
 
@@ -1151,7 +1139,6 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
 
 	cx231xx_info("vidioc_s_std : 0x%x\n", (unsigned int)*norm);
 
-	mutex_lock(&dev->lock);
 	dev->norm = *norm;
 
 	/* Adjusts width/height, if needed */
@@ -1172,8 +1159,6 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
 	dev->width = f.fmt.pix.width;
 	dev->height = f.fmt.pix.height;
 
-	mutex_unlock(&dev->lock);
-
 	/* do mode control overrides */
 	cx231xx_do_mode_ctrl_overrides(dev);
 
@@ -1242,8 +1227,6 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 	if (0 == INPUT(i)->type)
 		return -EINVAL;
 
-	mutex_lock(&dev->lock);
-
 	video_mux(dev, i);
 
 	if (INPUT(i)->type == CX231XX_VMUX_TELEVISION ||
@@ -1254,7 +1237,6 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 		call_all(dev, core, s_std, dev->norm);
 	}
 
-	mutex_unlock(&dev->lock);
 	return 0;
 }
 
@@ -1330,9 +1312,7 @@ static int vidioc_queryctrl(struct file *file, void *priv,
 	}
 	*qc = cx231xx_ctls[i].v;
 
-	mutex_lock(&dev->lock);
 	call_all(dev, core, queryctrl, qc);
-	mutex_unlock(&dev->lock);
 
 	if (qc->type)
 		return 0;
@@ -1351,9 +1331,7 @@ static int vidioc_g_ctrl(struct file *file, void *priv,
 	if (rc < 0)
 		return rc;
 
-	mutex_lock(&dev->lock);
 	call_all(dev, core, g_ctrl, ctrl);
-	mutex_unlock(&dev->lock);
 	return rc;
 }
 
@@ -1368,9 +1346,7 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 	if (rc < 0)
 		return rc;
 
-	mutex_lock(&dev->lock);
 	call_all(dev, core, s_ctrl, ctrl);
-	mutex_unlock(&dev->lock);
 	return rc;
 }
 
@@ -1410,9 +1386,7 @@ static int vidioc_s_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 	if (0 != t->index)
 		return -EINVAL;
 #if 0
-	mutex_lock(&dev->lock);
 	call_all(dev, tuner, s_tuner, t);
-	mutex_unlock(&dev->lock);
 #endif
 	return 0;
 }
@@ -1423,14 +1397,11 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 	struct cx231xx_fh *fh = priv;
 	struct cx231xx *dev = fh->dev;
 
-	mutex_lock(&dev->lock);
 	f->type = fh->radio ? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 	f->frequency = dev->ctl_freq;
 
 	call_all(dev, tuner, g_frequency, f);
 
-	mutex_unlock(&dev->lock);
-
 	return 0;
 }
 
@@ -1461,13 +1432,9 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	/* set pre channel change settings in DIF first */
 	rc = cx231xx_tuner_pre_channel_change(dev);
 
-	mutex_lock(&dev->lock);
-
 	dev->ctl_freq = f->frequency;
 	call_all(dev, tuner, s_frequency, f);
 
-	mutex_unlock(&dev->lock);
-
 	/* set post channel change settings in DIF first */
 	rc = cx231xx_tuner_post_channel_change(dev);
 
@@ -1655,9 +1622,7 @@ static int vidioc_g_register(struct file *file, void *priv,
 			return -EINVAL;
 	}
 
-	mutex_lock(&dev->lock);
 	call_all(dev, core, g_register, reg);
-	mutex_unlock(&dev->lock);
 
 	return ret;
 }
@@ -1822,9 +1787,7 @@ static int vidioc_s_register(struct file *file, void *priv,
 		break;
 	}
 
-	mutex_lock(&dev->lock);
 	call_all(dev, core, s_register, reg);
-	mutex_unlock(&dev->lock);
 
 	return ret;
 }
@@ -1861,7 +1824,6 @@ static int vidioc_streamon(struct file *file, void *priv,
 	if (rc < 0)
 		return rc;
 
-	mutex_lock(&dev->lock);
 	rc = res_get(fh);
 
 	if (likely(rc >= 0))
@@ -1869,8 +1831,6 @@ static int vidioc_streamon(struct file *file, void *priv,
 
 	call_all(dev, video, s_stream, 1);
 
-	mutex_unlock(&dev->lock);
-
 	return rc;
 }
 
@@ -1891,15 +1851,11 @@ static int vidioc_streamoff(struct file *file, void *priv,
 	if (type != fh->type)
 		return -EINVAL;
 
-	mutex_lock(&dev->lock);
-
 	cx25840_call(dev, video, s_stream, 0);
 
 	videobuf_streamoff(&fh->vb_vidq);
 	res_free(fh);
 
-	mutex_unlock(&dev->lock);
-
 	return 0;
 }
 
@@ -1954,8 +1910,6 @@ static int vidioc_g_fmt_sliced_vbi_cap(struct file *file, void *priv,
 	if (rc < 0)
 		return rc;
 
-	mutex_lock(&dev->lock);
-
 	f->fmt.sliced.service_set = 0;
 
 	call_all(dev, vbi, g_sliced_fmt, &f->fmt.sliced);
@@ -1963,7 +1917,6 @@ static int vidioc_g_fmt_sliced_vbi_cap(struct file *file, void *priv,
 	if (f->fmt.sliced.service_set == 0)
 		rc = -EINVAL;
 
-	mutex_unlock(&dev->lock);
 	return rc;
 }
 
@@ -1978,9 +1931,7 @@ static int vidioc_try_set_sliced_vbi_cap(struct file *file, void *priv,
 	if (rc < 0)
 		return rc;
 
-	mutex_lock(&dev->lock);
 	call_all(dev, vbi, g_sliced_fmt, &f->fmt.sliced);
-	mutex_unlock(&dev->lock);
 
 	if (f->fmt.sliced.service_set == 0)
 		return -EINVAL;
@@ -2130,9 +2081,7 @@ static int radio_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 	strcpy(t->name, "Radio");
 	t->type = V4L2_TUNER_RADIO;
 
-	mutex_lock(&dev->lock);
 	call_all(dev, tuner, s_tuner, t);
-	mutex_unlock(&dev->lock);
 
 	return 0;
 }
@@ -2163,9 +2112,7 @@ static int radio_s_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 	if (0 != t->index)
 		return -EINVAL;
 
-	mutex_lock(&dev->lock);
 	call_all(dev, tuner, s_tuner, t);
-	mutex_unlock(&dev->lock);
 
 	return 0;
 }
@@ -2224,8 +2171,6 @@ static int cx231xx_v4l2_open(struct file *filp)
 		break;
 	}
 
-	mutex_lock(&dev->lock);
-
 	cx231xx_videodbg("open dev=%s type=%s users=%d\n",
 			 video_device_node_name(vdev), v4l2_type_names[fh_type],
 			 dev->users);
@@ -2235,7 +2180,6 @@ static int cx231xx_v4l2_open(struct file *filp)
 	if (errCode < 0) {
 		cx231xx_errdev
 		    ("Device locked on digital mode. Can't open analog\n");
-		mutex_unlock(&dev->lock);
 		return -EBUSY;
 	}
 #endif
@@ -2243,7 +2187,6 @@ static int cx231xx_v4l2_open(struct file *filp)
 	fh = kzalloc(sizeof(struct cx231xx_fh), GFP_KERNEL);
 	if (!fh) {
 		cx231xx_errdev("cx231xx-video.c: Out of memory?!\n");
-		mutex_unlock(&dev->lock);
 		return -ENOMEM;
 	}
 	fh->dev = dev;
@@ -2293,7 +2236,7 @@ static int cx231xx_v4l2_open(struct file *filp)
 					    NULL, &dev->video_mode.slock,
 					    fh->type, V4L2_FIELD_INTERLACED,
 					    sizeof(struct cx231xx_buffer),
-					    fh, NULL);
+					    fh, &dev->lock);
 	if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
 		/* Set the required alternate setting  VBI interface works in
 		   Bulk mode only */
@@ -2305,11 +2248,9 @@ static int cx231xx_v4l2_open(struct file *filp)
 					    NULL, &dev->vbi_mode.slock,
 					    fh->type, V4L2_FIELD_SEQ_TB,
 					    sizeof(struct cx231xx_buffer),
-					    fh, NULL);
+					    fh, &dev->lock);
 	}
 
-	mutex_unlock(&dev->lock);
-
 	return errCode;
 }
 
@@ -2366,7 +2307,6 @@ static int cx231xx_v4l2_close(struct file *filp)
 
 	cx231xx_videodbg("users=%d\n", dev->users);
 
-	mutex_lock(&dev->lock);
 	cx231xx_videodbg("users=%d\n", dev->users);
 	if (res_check(fh))
 		res_free(fh);
@@ -2384,12 +2324,10 @@ static int cx231xx_v4l2_close(struct file *filp)
 			if (dev->state & DEV_DISCONNECTED) {
 				if (atomic_read(&dev->devlist_count) > 0) {
 					cx231xx_release_resources(dev);
-					mutex_unlock(&dev->lock);
 					kfree(dev);
 					dev = NULL;
 					return 0;
 				}
-				mutex_unlock(&dev->lock);
 				return 0;
 			}
 
@@ -2405,7 +2343,6 @@ static int cx231xx_v4l2_close(struct file *filp)
 			kfree(fh);
 			dev->users--;
 			wake_up_interruptible_nr(&dev->open, 1);
-			mutex_unlock(&dev->lock);
 			return 0;
 		}
 
@@ -2417,7 +2354,6 @@ static int cx231xx_v4l2_close(struct file *filp)
 		   free the remaining resources */
 		if (dev->state & DEV_DISCONNECTED) {
 			cx231xx_release_resources(dev);
-			mutex_unlock(&dev->lock);
 			kfree(dev);
 			dev = NULL;
 			return 0;
@@ -2439,7 +2375,6 @@ static int cx231xx_v4l2_close(struct file *filp)
 	kfree(fh);
 	dev->users--;
 	wake_up_interruptible_nr(&dev->open, 1);
-	mutex_unlock(&dev->lock);
 	return 0;
 }
 
@@ -2461,9 +2396,7 @@ cx231xx_v4l2_read(struct file *filp, char __user *buf, size_t count,
 
 	if ((fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) ||
 	    (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE)) {
-		mutex_lock(&dev->lock);
 		rc = res_get(fh);
-		mutex_unlock(&dev->lock);
 
 		if (unlikely(rc < 0))
 			return rc;
@@ -2488,9 +2421,7 @@ static unsigned int cx231xx_v4l2_poll(struct file *filp, poll_table *wait)
 	if (rc < 0)
 		return rc;
 
-	mutex_lock(&dev->lock);
 	rc = res_get(fh);
-	mutex_unlock(&dev->lock);
 
 	if (unlikely(rc < 0))
 		return POLLERR;
@@ -2515,9 +2446,7 @@ static int cx231xx_v4l2_mmap(struct file *filp, struct vm_area_struct *vma)
 	if (rc < 0)
 		return rc;
 
-	mutex_lock(&dev->lock);
 	rc = res_get(fh);
-	mutex_unlock(&dev->lock);
 
 	if (unlikely(rc < 0))
 		return rc;
@@ -2539,7 +2468,7 @@ static const struct v4l2_file_operations cx231xx_v4l_fops = {
 	.read    = cx231xx_v4l2_read,
 	.poll    = cx231xx_v4l2_poll,
 	.mmap    = cx231xx_v4l2_mmap,
-	.ioctl   = video_ioctl2,
+	.unlocked_ioctl   = video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
@@ -2641,6 +2570,7 @@ static struct video_device *cx231xx_vdev_init(struct cx231xx *dev,
 	vfd->v4l2_dev = &dev->v4l2_dev;
 	vfd->release = video_device_release;
 	vfd->debug = video_debug;
+	vfd->lock = &dev->lock;
 
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s", dev->name, type_name);
 
-- 
1.7.1

