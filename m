Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab2EFPZ4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 May 2012 11:25:56 -0400
Message-ID: <4FA69803.20605@redhat.com>
Date: Sun, 06 May 2012 17:25:55 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 13/17] gspca: switch to V4L2 core locking, except
 for the buffer queuing ioctls.
References: <1336307311-10227-1-git-send-email-hverkuil@xs4all.nl> <4e0d537b1e1baf060981580d93f400a92ecfe427.1336305565.git.hans.verkuil@cisco.com>
In-Reply-To: <4e0d537b1e1baf060981580d93f400a92ecfe427.1336305565.git.hans.verkuil@cisco.com>
Content-Type: multipart/mixed;
 boundary="------------020905030508020907000003"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020905030508020907000003
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Hans,

The entire series looks great, I do have a few remarks wrt this
patch, which I have fixed in my own tree (new version attached,
note untested sofar).

On 05/06/2012 02:28 PM, Hans Verkuil wrote:
> From: Hans Verkuil<hans.verkuil@cisco.com>
>
> Due to latency concerns the VIDIOC_QBUF, DQBUF and QUERYBUF do not use the
> core lock, instead they rely only on queue_lock.
>
> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>
> ---
>   drivers/media/video/gspca/gspca.c |  203 ++++++++-----------------------------
>   1 file changed, 41 insertions(+), 162 deletions(-)
>
> diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
> index f840bed..edca4f3 100644
> --- a/drivers/media/video/gspca/gspca.c
> +++ b/drivers/media/video/gspca/gspca.c
> @@ -850,14 +850,6 @@ static int gspca_init_transfer(struct gspca_dev *gspca_dev)
>   	struct ep_tb_s ep_tb[MAX_ALT];
>   	int n, ret, xfer, alt, alt_idx;
>
> -	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
> -		return -ERESTARTSYS;
> -
> -	if (!gspca_dev->present) {
> -		ret = -ENODEV;
> -		goto unlock;
> -	}
> -
>   	/* reset the streaming variables */
>   	gspca_dev->image = NULL;
>   	gspca_dev->image_len = 0;

You're removing a lot of checks for gspca_dev->present, relying on the
video_is_registered checks in v4l2-dev instead I assume, this is a good
idea, *but* it requires a small hack in disconnect to close a race.

Currently the end of gspca_disconnect looks like this:

         gspca_dev->dev = NULL;
         v4l2_device_disconnect(&gspca_dev->v4l2_dev);
         mutex_unlock(&gspca_dev->usb_lock);

         usb_set_intfdata(intf, NULL);

         /* release the device */
         /* (this will call gspca_release() immediately or on last close) */
         video_unregister_device(&gspca_dev->vdev);
}

Notice that usb_lock is unlocked before video_unregister_device gets called,
which means that any ioctl or other fops waiting for usb_lock can run
before video_unregister_device runs, and thus before they are protected
against being called on an disconnected device by the
video_is_registered checks in v4l2-dev.

Unfortunately simply moving the unlock down won't work, because if there
are no open file handles referencing the device, then the memory
referenced by gspca_dev will be free-ed after the video_unregister_device
call.

So I've changed disconnect to the following in my version, to allow the
present check removal you've did, as I quite like being able to
remove all those present checks :)   :

         /* The USB-interface device is freed at exit of this function */
         gspca_dev->dev = NULL;
         v4l2_device_disconnect(&gspca_dev->v4l2_dev);

         /* Ensure gspca_dev sticks around for the usb_lock unlock! */
         get_device(&gspca_dev->vdev.dev);
         video_unregister_device(&gspca_dev->vdev);
         mutex_unlock(&gspca_dev->usb_lock);
         /* (this will call gspca_release() immediately or on last close) */
         put_device(&gspca_dev->vdev.dev);

         usb_set_intfdata(intf, NULL);
}


<snip chunks on which I've no comments>

> @@ -1736,10 +1658,8 @@ static int vidioc_streamoff(struct file *file, void *priv,
>   	if (mutex_lock_interruptible(&gspca_dev->queue_lock))
>   		return -ERESTARTSYS;
>
> -	if (!gspca_dev->streaming) {
> -		ret = 0;
> -		goto out;
> -	}
> +	if (!gspca_dev->streaming)
> +		return 0;
>

BAD! queue_lock is held here, so you cannot just change this to a return!

>   	/* check the capture file */
>   	if (gspca_dev->capt_file != file) {

<snip chunks on which I've no comments>

> @@ -2009,11 +1883,9 @@ static int vidioc_dqbuf(struct file *file, void *priv,
>   	gspca_dev->fr_o = (i + 1) % GSPCA_MAX_FRAMES;
>
>   	if (gspca_dev->sd_desc->dq_callback) {
> -		mutex_lock(&gspca_dev->usb_lock);
>   		gspca_dev->usb_err = 0;
>   		if (gspca_dev->present)
>   			gspca_dev->sd_desc->dq_callback(gspca_dev);
> -		mutex_unlock(&gspca_dev->usb_lock);
>   	}
>
>   	frame->v4l2_buf.flags&= ~V4L2_BUF_FLAG_DONE;

You cannot remove the locking here, as dq_callback expects to be
called with the usb-lock locked.

Since usb-lock now is the device lock and thus gets locked before
the queue_lock, we cannot simply drop this chunk. Instead I've
moved the dq_callback to the end of vidioc_dqbuf, so after the
stream_lock has been released (there is no reason to have
the stream_lock hold when calling the dq_callback).

The dq_callback is used to do camera control adjustments which
need to be done after every X frames, and which cannot be done
from the isoc frame interrupts since they should not be done under
interrupt. When the drivers using dq_callback are converted to the
control framework, they will likely end up calling v4l2_ctrl_s_ctrl
from the dq_callback.

<snip chunks on which I've no comments>

Regards,

Hans


p.s.

I've yet to take a good look at the driver conversions other then
the zc3xx conversion.

--------------020905030508020907000003
Content-Type: text/x-patch;
 name="0013-gspca-switch-to-V4L2-core-locking-except-for-the-buf.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0013-gspca-switch-to-V4L2-core-locking-except-for-the-buf.pa";
 filename*1="tch"

>From 46738bfafe910180d89d53cbe30a9fb4bd234a09 Mon Sep 17 00:00:00 2001
From: Hans Verkuil <hans.verkuil@cisco.com>
Date: Sun, 6 May 2012 14:28:27 +0200
Subject: [PATCH 13/17] gspca: switch to V4L2 core locking, except for the
 buffer queuing ioctls.

Due to latency concerns the VIDIOC_QBUF, DQBUF and QUERYBUF do not use the
core lock, instead they rely only on queue_lock.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/gspca/gspca.c |  230 +++++++++----------------------------
 1 file changed, 56 insertions(+), 174 deletions(-)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index f840bed..be31233 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -850,14 +850,6 @@ static int gspca_init_transfer(struct gspca_dev *gspca_dev)
 	struct ep_tb_s ep_tb[MAX_ALT];
 	int n, ret, xfer, alt, alt_idx;
 
-	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
-		return -ERESTARTSYS;
-
-	if (!gspca_dev->present) {
-		ret = -ENODEV;
-		goto unlock;
-	}
-
 	/* reset the streaming variables */
 	gspca_dev->image = NULL;
 	gspca_dev->image_len = 0;
@@ -872,7 +864,7 @@ static int gspca_init_transfer(struct gspca_dev *gspca_dev)
 	if (gspca_dev->sd_desc->isoc_init) {
 		ret = gspca_dev->sd_desc->isoc_init(gspca_dev);
 		if (ret < 0)
-			goto unlock;
+			return ret;
 	}
 	xfer = gspca_dev->cam.bulk ? USB_ENDPOINT_XFER_BULK
 				   : USB_ENDPOINT_XFER_ISOC;
@@ -883,8 +875,7 @@ static int gspca_init_transfer(struct gspca_dev *gspca_dev)
 		ep = alt_xfer(&intf->altsetting[gspca_dev->alt], xfer);
 		if (ep == NULL) {
 			pr_err("bad altsetting %d\n", gspca_dev->alt);
-			ret = -EIO;
-			goto out;
+			return -EIO;
 		}
 		ep_tb[0].alt = gspca_dev->alt;
 		alt_idx = 1;
@@ -895,8 +886,7 @@ static int gspca_init_transfer(struct gspca_dev *gspca_dev)
 		alt_idx = build_isoc_ep_tb(gspca_dev, intf, ep_tb);
 		if (alt_idx <= 0) {
 			pr_err("no transfer endpoint found\n");
-			ret = -EIO;
-			goto unlock;
+			return -EIO;
 		}
 	}
 
@@ -991,8 +981,6 @@ retry:
 	}
 out:
 	gspca_input_create_urb(gspca_dev);
-unlock:
-	mutex_unlock(&gspca_dev->usb_lock);
 	return ret;
 }
 
@@ -1062,7 +1050,6 @@ static int gspca_get_mode(struct gspca_dev *gspca_dev,
 static int vidioc_g_register(struct file *file, void *priv,
 			struct v4l2_dbg_register *reg)
 {
-	int ret;
 	struct gspca_dev *gspca_dev = video_drvdata(file);
 
 	if (!gspca_dev->sd_desc->get_chip_ident)
@@ -1071,22 +1058,13 @@ static int vidioc_g_register(struct file *file, void *priv,
 	if (!gspca_dev->sd_desc->get_register)
 		return -ENOTTY;
 
-	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
-		return -ERESTARTSYS;
 	gspca_dev->usb_err = 0;
-	if (gspca_dev->present)
-		ret = gspca_dev->sd_desc->get_register(gspca_dev, reg);
-	else
-		ret = -ENODEV;
-	mutex_unlock(&gspca_dev->usb_lock);
-
-	return ret;
+	return gspca_dev->sd_desc->get_register(gspca_dev, reg);
 }
 
 static int vidioc_s_register(struct file *file, void *priv,
 			struct v4l2_dbg_register *reg)
 {
-	int ret;
 	struct gspca_dev *gspca_dev = video_drvdata(file);
 
 	if (!gspca_dev->sd_desc->get_chip_ident)
@@ -1095,38 +1073,21 @@ static int vidioc_s_register(struct file *file, void *priv,
 	if (!gspca_dev->sd_desc->set_register)
 		return -ENOTTY;
 
-	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
-		return -ERESTARTSYS;
 	gspca_dev->usb_err = 0;
-	if (gspca_dev->present)
-		ret = gspca_dev->sd_desc->set_register(gspca_dev, reg);
-	else
-		ret = -ENODEV;
-	mutex_unlock(&gspca_dev->usb_lock);
-
-	return ret;
+	return gspca_dev->sd_desc->set_register(gspca_dev, reg);
 }
 #endif
 
 static int vidioc_g_chip_ident(struct file *file, void *priv,
 			struct v4l2_dbg_chip_ident *chip)
 {
-	int ret;
 	struct gspca_dev *gspca_dev = video_drvdata(file);
 
 	if (!gspca_dev->sd_desc->get_chip_ident)
 		return -ENOTTY;
 
-	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
-		return -ERESTARTSYS;
 	gspca_dev->usb_err = 0;
-	if (gspca_dev->present)
-		ret = gspca_dev->sd_desc->get_chip_ident(gspca_dev, chip);
-	else
-		ret = -ENODEV;
-	mutex_unlock(&gspca_dev->usb_lock);
-
-	return ret;
+	return gspca_dev->sd_desc->get_chip_ident(gspca_dev, chip);
 }
 
 static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
@@ -1339,8 +1300,6 @@ static int dev_open(struct file *file)
 	struct gspca_dev *gspca_dev = video_drvdata(file);
 
 	PDEBUG(D_STREAM, "[%s] open", current->comm);
-	if (!gspca_dev->present)
-		return -ENODEV;
 
 	/* protect the subdriver against rmmod */
 	if (!try_module_get(gspca_dev->module))
@@ -1369,10 +1328,8 @@ static int dev_close(struct file *file)
 	/* if the file did the capture, free the streaming resources */
 	if (gspca_dev->capt_file == file) {
 		if (gspca_dev->streaming) {
-			mutex_lock(&gspca_dev->usb_lock);
 			gspca_dev->usb_err = 0;
 			gspca_stream_off(gspca_dev);
-			mutex_unlock(&gspca_dev->usb_lock);
 		}
 		frame_free(gspca_dev);
 	}
@@ -1388,15 +1345,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 			   struct v4l2_capability *cap)
 {
 	struct gspca_dev *gspca_dev = video_drvdata(file);
-	int ret;
 
-	/* protect the access to the usb device */
-	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
-		return -ERESTARTSYS;
-	if (!gspca_dev->present) {
-		ret = -ENODEV;
-		goto out;
-	}
 	strlcpy((char *) cap->driver, gspca_dev->sd_desc->name,
 			sizeof cap->driver);
 	if (gspca_dev->dev->product != NULL) {
@@ -1414,10 +1363,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 			  | V4L2_CAP_STREAMING
 			  | V4L2_CAP_READWRITE;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
-	ret = 0;
-out:
-	mutex_unlock(&gspca_dev->usb_lock);
-	return ret;
+	return 0;
 }
 
 static int get_ctrl(struct gspca_dev *gspca_dev,
@@ -1486,7 +1432,7 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 	struct gspca_dev *gspca_dev = video_drvdata(file);
 	const struct ctrl *ctrls;
 	struct gspca_ctrl *gspca_ctrl;
-	int idx, ret;
+	int idx;
 
 	idx = get_ctrl(gspca_dev, ctrl->id);
 	if (idx < 0)
@@ -1506,27 +1452,16 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 			return -ERANGE;
 	}
 	PDEBUG(D_CONF, "set ctrl [%08x] = %d", ctrl->id, ctrl->value);
-	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
-		return -ERESTARTSYS;
-	if (!gspca_dev->present) {
-		ret = -ENODEV;
-		goto out;
-	}
 	gspca_dev->usb_err = 0;
-	if (ctrls->set != NULL) {
-		ret = ctrls->set(gspca_dev, ctrl->value);
-		goto out;
-	}
+	if (ctrls->set != NULL)
+		return ctrls->set(gspca_dev, ctrl->value);
 	if (gspca_ctrl != NULL) {
 		gspca_ctrl->val = ctrl->value;
 		if (ctrls->set_control != NULL
 		 && gspca_dev->streaming)
 			ctrls->set_control(gspca_dev);
 	}
-	ret = gspca_dev->usb_err;
-out:
-	mutex_unlock(&gspca_dev->usb_lock);
-	return ret;
+	return gspca_dev->usb_err;
 }
 
 static int vidioc_g_ctrl(struct file *file, void *priv,
@@ -1534,30 +1469,19 @@ static int vidioc_g_ctrl(struct file *file, void *priv,
 {
 	struct gspca_dev *gspca_dev = video_drvdata(file);
 	const struct ctrl *ctrls;
-	int idx, ret;
+	int idx;
 
 	idx = get_ctrl(gspca_dev, ctrl->id);
 	if (idx < 0)
 		return -EINVAL;
 	ctrls = &gspca_dev->sd_desc->ctrls[idx];
 
-	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
-		return -ERESTARTSYS;
-	if (!gspca_dev->present) {
-		ret = -ENODEV;
-		goto out;
-	}
 	gspca_dev->usb_err = 0;
-	if (ctrls->get != NULL) {
-		ret = ctrls->get(gspca_dev, &ctrl->value);
-		goto out;
-	}
+	if (ctrls->get != NULL)
+		return ctrls->get(gspca_dev, &ctrl->value);
 	if (gspca_dev->cam.ctrls != NULL)
 		ctrl->value = gspca_dev->cam.ctrls[idx].val;
-	ret = 0;
-out:
-	mutex_unlock(&gspca_dev->usb_lock);
-	return ret;
+	return 0;
 }
 
 static int vidioc_querymenu(struct file *file, void *priv,
@@ -1640,10 +1564,8 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 	/* stop streaming */
 	streaming = gspca_dev->streaming;
 	if (streaming) {
-		mutex_lock(&gspca_dev->usb_lock);
 		gspca_dev->usb_err = 0;
 		gspca_stream_off(gspca_dev);
-		mutex_unlock(&gspca_dev->usb_lock);
 
 		/* Don't restart the stream when switching from read
 		 * to mmap mode */
@@ -1748,13 +1670,8 @@ static int vidioc_streamoff(struct file *file, void *priv,
 	}
 
 	/* stop streaming */
-	if (mutex_lock_interruptible(&gspca_dev->usb_lock)) {
-		ret = -ERESTARTSYS;
-		goto out;
-	}
 	gspca_dev->usb_err = 0;
 	gspca_stream_off(gspca_dev);
-	mutex_unlock(&gspca_dev->usb_lock);
 	/* In case another thread is waiting in dqbuf */
 	wake_up_interruptible(&gspca_dev->wq);
 
@@ -1772,63 +1689,36 @@ static int vidioc_g_jpegcomp(struct file *file, void *priv,
 			struct v4l2_jpegcompression *jpegcomp)
 {
 	struct gspca_dev *gspca_dev = video_drvdata(file);
-	int ret;
 
 	if (!gspca_dev->sd_desc->get_jcomp)
 		return -ENOTTY;
-	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
-		return -ERESTARTSYS;
 	gspca_dev->usb_err = 0;
-	if (gspca_dev->present)
-		ret = gspca_dev->sd_desc->get_jcomp(gspca_dev, jpegcomp);
-	else
-		ret = -ENODEV;
-	mutex_unlock(&gspca_dev->usb_lock);
-	return ret;
+	return gspca_dev->sd_desc->get_jcomp(gspca_dev, jpegcomp);
 }
 
 static int vidioc_s_jpegcomp(struct file *file, void *priv,
 			struct v4l2_jpegcompression *jpegcomp)
 {
 	struct gspca_dev *gspca_dev = video_drvdata(file);
-	int ret;
 
 	if (!gspca_dev->sd_desc->set_jcomp)
 		return -ENOTTY;
-	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
-		return -ERESTARTSYS;
 	gspca_dev->usb_err = 0;
-	if (gspca_dev->present)
-		ret = gspca_dev->sd_desc->set_jcomp(gspca_dev, jpegcomp);
-	else
-		ret = -ENODEV;
-	mutex_unlock(&gspca_dev->usb_lock);
-	return ret;
+	return gspca_dev->sd_desc->set_jcomp(gspca_dev, jpegcomp);
 }
 
 static int vidioc_g_parm(struct file *filp, void *priv,
 			struct v4l2_streamparm *parm)
 {
-	struct gspca_dev *gspca_dev = video_drvdata(file);
+	struct gspca_dev *gspca_dev = video_drvdata(filp);
 
 	parm->parm.capture.readbuffers = gspca_dev->nbufread;
 
 	if (gspca_dev->sd_desc->get_streamparm) {
-		int ret;
-
-		if (mutex_lock_interruptible(&gspca_dev->usb_lock))
-			return -ERESTARTSYS;
-		if (gspca_dev->present) {
-			gspca_dev->usb_err = 0;
-			gspca_dev->sd_desc->get_streamparm(gspca_dev, parm);
-			ret = gspca_dev->usb_err;
-		} else {
-			ret = -ENODEV;
-		}
-		mutex_unlock(&gspca_dev->usb_lock);
-		return ret;
+		gspca_dev->usb_err = 0;
+		gspca_dev->sd_desc->get_streamparm(gspca_dev, parm);
+		return gspca_dev->usb_err;
 	}
-
 	return 0;
 }
 
@@ -1845,19 +1735,9 @@ static int vidioc_s_parm(struct file *filp, void *priv,
 		gspca_dev->nbufread = n;
 
 	if (gspca_dev->sd_desc->set_streamparm) {
-		int ret;
-
-		if (mutex_lock_interruptible(&gspca_dev->usb_lock))
-			return -ERESTARTSYS;
-		if (gspca_dev->present) {
-			gspca_dev->usb_err = 0;
-			gspca_dev->sd_desc->set_streamparm(gspca_dev, parm);
-			ret = gspca_dev->usb_err;
-		} else {
-			ret = -ENODEV;
-		}
-		mutex_unlock(&gspca_dev->usb_lock);
-		return ret;
+		gspca_dev->usb_err = 0;
+		gspca_dev->sd_desc->set_streamparm(gspca_dev, parm);
+		return gspca_dev->usb_err;
 	}
 
 	return 0;
@@ -1877,10 +1757,6 @@ static int dev_mmap(struct file *file, struct vm_area_struct *vma)
 
 	if (mutex_lock_interruptible(&gspca_dev->queue_lock))
 		return -ERESTARTSYS;
-	if (!gspca_dev->present) {
-		ret = -ENODEV;
-		goto out;
-	}
 	if (gspca_dev->capt_file != file) {
 		ret = -EINVAL;
 		goto out;
@@ -2008,14 +1884,6 @@ static int vidioc_dqbuf(struct file *file, void *priv,
 
 	gspca_dev->fr_o = (i + 1) % GSPCA_MAX_FRAMES;
 
-	if (gspca_dev->sd_desc->dq_callback) {
-		mutex_lock(&gspca_dev->usb_lock);
-		gspca_dev->usb_err = 0;
-		if (gspca_dev->present)
-			gspca_dev->sd_desc->dq_callback(gspca_dev);
-		mutex_unlock(&gspca_dev->usb_lock);
-	}
-
 	frame->v4l2_buf.flags &= ~V4L2_BUF_FLAG_DONE;
 	memcpy(v4l2_buf, &frame->v4l2_buf, sizeof *v4l2_buf);
 	PDEBUG(D_FRAM, "dqbuf %d", j);
@@ -2032,6 +1900,15 @@ static int vidioc_dqbuf(struct file *file, void *priv,
 	}
 out:
 	mutex_unlock(&gspca_dev->queue_lock);
+
+	if (ret == 0 && gspca_dev->sd_desc->dq_callback) {
+		mutex_lock(&gspca_dev->usb_lock);
+		gspca_dev->usb_err = 0;
+		if (gspca_dev->present)
+			gspca_dev->sd_desc->dq_callback(gspca_dev);
+		mutex_unlock(&gspca_dev->usb_lock);
+	}
+
 	return ret;
 }
 
@@ -2177,8 +2054,6 @@ static ssize_t dev_read(struct file *file, char __user *data,
 	int n, ret, ret2;
 
 	PDEBUG(D_FRAM, "read (%zd)", count);
-	if (!gspca_dev->present)
-		return -ENODEV;
 	if (gspca_dev->memory == GSPCA_MEMORY_NO) { /* first time ? */
 		ret = read_alloc(gspca_dev, file);
 		if (ret != 0)
@@ -2366,6 +2241,7 @@ int gspca_dev_probe2(struct usb_interface *intf,
 	gspca_dev->present = 1;
 
 	mutex_init(&gspca_dev->usb_lock);
+	gspca_dev->vdev.lock = &gspca_dev->usb_lock;
 	mutex_init(&gspca_dev->queue_lock);
 	init_waitqueue_head(&gspca_dev->wq);
 
@@ -2388,6 +2264,14 @@ int gspca_dev_probe2(struct usb_interface *intf,
 	if (ret)
 		goto out;
 
+	/* These ioctls use just queue_lock and not usb_lock.
+	   This improves latency if the usb lock is taken for a
+	   long time, e.g. when changing a control value, and a
+	   new frame is ready to be dequeued. */
+	v4l2_dont_use_lock(&gspca_dev->vdev, VIDIOC_DQBUF);
+	v4l2_dont_use_lock(&gspca_dev->vdev, VIDIOC_QBUF);
+	v4l2_dont_use_lock(&gspca_dev->vdev, VIDIOC_QUERYBUF);
+
 	/* init video stuff */
 	ret = video_register_device(&gspca_dev->vdev,
 				  VFL_TYPE_GRABBER,
@@ -2455,11 +2339,11 @@ void gspca_disconnect(struct usb_interface *intf)
 
 	PDEBUG(D_PROBE, "%s disconnect",
 		video_device_node_name(&gspca_dev->vdev));
+
 	mutex_lock(&gspca_dev->usb_lock);
 
 	gspca_dev->present = 0;
 	wake_up_interruptible(&gspca_dev->wq);
-
 	destroy_urbs(gspca_dev);
 
 #if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
@@ -2471,18 +2355,18 @@ void gspca_disconnect(struct usb_interface *intf)
 	}
 #endif
 
-	/* the device is freed at exit of this function */
+	/* The USB-interface device is freed at exit of this function */
 	gspca_dev->dev = NULL;
 	v4l2_device_disconnect(&gspca_dev->v4l2_dev);
-	mutex_unlock(&gspca_dev->usb_lock);
-
-	usb_set_intfdata(intf, NULL);
 
-	/* release the device */
-	/* (this will call gspca_release() immediately or on last close) */
+	/* Ensure gspca_dev sticks around for the usb_lock unlock! */
+	get_device(&gspca_dev->vdev.dev);
 	video_unregister_device(&gspca_dev->vdev);
+	mutex_unlock(&gspca_dev->usb_lock);
+	/* (this will call gspca_release() immediately or on last close) */
+	put_device(&gspca_dev->vdev.dev);
 
-/*	PDEBUG(D_PROBE, "disconnect complete"); */
+	usb_set_intfdata(intf, NULL);
 }
 EXPORT_SYMBOL(gspca_disconnect);
 
@@ -2493,17 +2377,16 @@ int gspca_suspend(struct usb_interface *intf, pm_message_t message)
 
 	if (!gspca_dev->streaming)
 		return 0;
+	mutex_lock(&gspca_dev->usb_lock);
 	gspca_dev->frozen = 1;		/* avoid urb error messages */
 	if (gspca_dev->sd_desc->stopN)
 		gspca_dev->sd_desc->stopN(gspca_dev);
 	destroy_urbs(gspca_dev);
 	gspca_input_destroy_urb(gspca_dev);
 	gspca_set_alt0(gspca_dev);
-	if (gspca_dev->sd_desc->stop0) {
-		mutex_lock(&gspca_dev->usb_lock);
+	if (gspca_dev->sd_desc->stop0)
 		gspca_dev->sd_desc->stop0(gspca_dev);
-		mutex_unlock(&gspca_dev->usb_lock);
-	}
+	mutex_unlock(&gspca_dev->usb_lock);
 	return 0;
 }
 EXPORT_SYMBOL(gspca_suspend);
@@ -2513,15 +2396,14 @@ int gspca_resume(struct usb_interface *intf)
 	struct gspca_dev *gspca_dev = usb_get_intfdata(intf);
 	int ret = 0;
 
+	mutex_lock(&gspca_dev->usb_lock);
 	gspca_dev->frozen = 0;
 	gspca_dev->sd_desc->init(gspca_dev);
 	gspca_set_default_mode(gspca_dev);
 	gspca_input_create_urb(gspca_dev);
-	if (gspca_dev->streaming) {
-		mutex_lock(&gspca_dev->queue_lock);
+	if (gspca_dev->streaming)
 		ret = gspca_init_transfer(gspca_dev);
-		mutex_unlock(&gspca_dev->queue_lock);
-	}
+	mutex_unlock(&gspca_dev->usb_lock);
 	return ret;
 }
 EXPORT_SYMBOL(gspca_resume);
-- 
1.7.10


--------------020905030508020907000003--
