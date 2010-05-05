Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2054 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986Ab0EEUaz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 May 2010 16:30:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: David Ellingsworth <david@identd.dyndns.org>
Subject: Re: [PATCH/RFC 1/7] dsbr100: implement proper locking
Date: Wed, 5 May 2010 22:32:01 +0200
Cc: linux-media@vger.kernel.org
References: <1273079130-21999-1-git-send-email-david@identd.dyndns.org> <1273079130-21999-2-git-send-email-david@identd.dyndns.org>
In-Reply-To: <1273079130-21999-2-git-send-email-david@identd.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201005052232.01980.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 05 May 2010 19:05:24 David Ellingsworth wrote:
> Signed-off-by: David Ellingsworth <david@identd.dyndns.org>

Does this actually fix bugs or does this just clean up the locking?

I ask because I am planning to make it easier to do locking for ioctl calls.
Basically there will be pre-hook and post-hook callbacks that are called before
and after an ioctl and where you can do the locking. I am waiting for a patch
series related to priority handling to go in first, then I will work on this
change.

So from my perspective I am OK with this if it fixes bugs, but if it is
just a clean up, then it might be better to wait until my new callbacks are in.

I won't block this, though. It's just FYI.

Regards,

	Hans

> ---
>  drivers/media/radio/dsbr100.c |   77 +++++++++++++++++-----------------------
>  1 files changed, 33 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/media/radio/dsbr100.c b/drivers/media/radio/dsbr100.c
> index ed9cd7a..673eda8 100644
> --- a/drivers/media/radio/dsbr100.c
> +++ b/drivers/media/radio/dsbr100.c
> @@ -182,7 +182,7 @@ static int dsbr100_start(struct dsbr100_device *radio)
>  	int retval;
>  	int request;
>  
> -	mutex_lock(&radio->lock);
> +	BUG_ON(!mutex_is_locked(&radio->lock));
>  
>  	retval = usb_control_msg(radio->usbdev,
>  		usb_rcvctrlpipe(radio->usbdev, 0),
> @@ -207,11 +207,9 @@ static int dsbr100_start(struct dsbr100_device *radio)
>  	}
>  
>  	radio->status = STARTED;
> -	mutex_unlock(&radio->lock);
>  	return (radio->transfer_buffer)[0];
>  
>  usb_control_msg_failed:
> -	mutex_unlock(&radio->lock);
>  	dev_err(&radio->usbdev->dev,
>  		"%s - usb_control_msg returned %i, request %i\n",
>  			__func__, retval, request);
> @@ -225,7 +223,7 @@ static int dsbr100_stop(struct dsbr100_device *radio)
>  	int retval;
>  	int request;
>  
> -	mutex_lock(&radio->lock);
> +	BUG_ON(!mutex_is_locked(&radio->lock));
>  
>  	retval = usb_control_msg(radio->usbdev,
>  		usb_rcvctrlpipe(radio->usbdev, 0),
> @@ -250,11 +248,9 @@ static int dsbr100_stop(struct dsbr100_device *radio)
>  	}
>  
>  	radio->status = STOPPED;
> -	mutex_unlock(&radio->lock);
>  	return (radio->transfer_buffer)[0];
>  
>  usb_control_msg_failed:
> -	mutex_unlock(&radio->lock);
>  	dev_err(&radio->usbdev->dev,
>  		"%s - usb_control_msg returned %i, request %i\n",
>  			__func__, retval, request);
> @@ -269,7 +265,7 @@ static int dsbr100_setfreq(struct dsbr100_device *radio)
>  	int request;
>  	int freq = (radio->curfreq / 16 * 80) / 1000 + 856;
>  
> -	mutex_lock(&radio->lock);
> +	BUG_ON(!mutex_is_locked(&radio->lock));
>  
>  	retval = usb_control_msg(radio->usbdev,
>  		usb_rcvctrlpipe(radio->usbdev, 0),
> @@ -306,12 +302,10 @@ static int dsbr100_setfreq(struct dsbr100_device *radio)
>  	}
>  
>  	radio->stereo = !((radio->transfer_buffer)[0] & 0x01);
> -	mutex_unlock(&radio->lock);
>  	return (radio->transfer_buffer)[0];
>  
>  usb_control_msg_failed:
>  	radio->stereo = -1;
> -	mutex_unlock(&radio->lock);
>  	dev_err(&radio->usbdev->dev,
>  		"%s - usb_control_msg returned %i, request %i\n",
>  			__func__, retval, request);
> @@ -324,7 +318,7 @@ static void dsbr100_getstat(struct dsbr100_device *radio)
>  {
>  	int retval;
>  
> -	mutex_lock(&radio->lock);
> +	BUG_ON(!mutex_is_locked(&radio->lock));
>  
>  	retval = usb_control_msg(radio->usbdev,
>  		usb_rcvctrlpipe(radio->usbdev, 0),
> @@ -340,8 +334,6 @@ static void dsbr100_getstat(struct dsbr100_device *radio)
>  	} else {
>  		radio->stereo = !(radio->transfer_buffer[0] & 0x01);
>  	}
> -
> -	mutex_unlock(&radio->lock);
>  }
>  
>  /* USB subsystem interface begins here */
> @@ -385,10 +377,6 @@ static int vidioc_g_tuner(struct file *file, void *priv,
>  {
>  	struct dsbr100_device *radio = video_drvdata(file);
>  
> -	/* safety check */
> -	if (radio->removed)
> -		return -EIO;
> -
>  	if (v->index > 0)
>  		return -EINVAL;
>  
> @@ -410,12 +398,6 @@ static int vidioc_g_tuner(struct file *file, void *priv,
>  static int vidioc_s_tuner(struct file *file, void *priv,
>  				struct v4l2_tuner *v)
>  {
> -	struct dsbr100_device *radio = video_drvdata(file);
> -
> -	/* safety check */
> -	if (radio->removed)
> -		return -EIO;
> -
>  	if (v->index > 0)
>  		return -EINVAL;
>  
> @@ -428,17 +410,12 @@ static int vidioc_s_frequency(struct file *file, void *priv,
>  	struct dsbr100_device *radio = video_drvdata(file);
>  	int retval;
>  
> -	/* safety check */
> -	if (radio->removed)
> -		return -EIO;
> -
> -	mutex_lock(&radio->lock);
>  	radio->curfreq = f->frequency;
> -	mutex_unlock(&radio->lock);
>  
>  	retval = dsbr100_setfreq(radio);
>  	if (retval < 0)
>  		dev_warn(&radio->usbdev->dev, "Set frequency failed\n");
> +
>  	return 0;
>  }
>  
> @@ -447,10 +424,6 @@ static int vidioc_g_frequency(struct file *file, void *priv,
>  {
>  	struct dsbr100_device *radio = video_drvdata(file);
>  
> -	/* safety check */
> -	if (radio->removed)
> -		return -EIO;
> -
>  	f->type = V4L2_TUNER_RADIO;
>  	f->frequency = radio->curfreq;
>  	return 0;
> @@ -472,10 +445,6 @@ static int vidioc_g_ctrl(struct file *file, void *priv,
>  {
>  	struct dsbr100_device *radio = video_drvdata(file);
>  
> -	/* safety check */
> -	if (radio->removed)
> -		return -EIO;
> -
>  	switch (ctrl->id) {
>  	case V4L2_CID_AUDIO_MUTE:
>  		ctrl->value = radio->status;
> @@ -490,10 +459,6 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
>  	struct dsbr100_device *radio = video_drvdata(file);
>  	int retval;
>  
> -	/* safety check */
> -	if (radio->removed)
> -		return -EIO;
> -
>  	switch (ctrl->id) {
>  	case V4L2_CID_AUDIO_MUTE:
>  		if (ctrl->value) {
> @@ -513,6 +478,7 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
>  		}
>  		return 0;
>  	}
> +
>  	return -EINVAL;
>  }
>  
> @@ -548,12 +514,34 @@ static int vidioc_s_audio(struct file *file, void *priv,
>  	return 0;
>  }
>  
> +static long usb_dsbr100_ioctl(struct file *file, unsigned int cmd,
> +				unsigned long arg)
> +{
> +	struct dsbr100_device *radio = video_drvdata(file);
> +	long retval = 0;
> +
> +	mutex_lock(&radio->lock);
> +
> +	if (radio->removed) {
> +		retval = -EIO;
> +		goto unlock;
> +	}
> +
> +	retval = video_ioctl2(file, cmd, arg);
> +
> +unlock:
> +	mutex_unlock(&radio->lock);
> +	return retval;
> +}
> +
>  /* Suspend device - stop device. */
>  static int usb_dsbr100_suspend(struct usb_interface *intf, pm_message_t message)
>  {
>  	struct dsbr100_device *radio = usb_get_intfdata(intf);
>  	int retval;
>  
> +	mutex_lock(&radio->lock);
> +
>  	if (radio->status == STARTED) {
>  		retval = dsbr100_stop(radio);
>  		if (retval < 0)
> @@ -564,12 +552,10 @@ static int usb_dsbr100_suspend(struct usb_interface *intf, pm_message_t message)
>  		 * we set status equal to STARTED.
>  		 * On resume we will check status and run radio if needed.
>  		 */
> -
> -		mutex_lock(&radio->lock);
>  		radio->status = STARTED;
> -		mutex_unlock(&radio->lock);
>  	}
>  
> +	mutex_unlock(&radio->lock);
>  	dev_info(&intf->dev, "going into suspend..\n");
>  
>  	return 0;
> @@ -581,12 +567,15 @@ static int usb_dsbr100_resume(struct usb_interface *intf)
>  	struct dsbr100_device *radio = usb_get_intfdata(intf);
>  	int retval;
>  
> +	mutex_lock(&radio->lock);
> +
>  	if (radio->status == STARTED) {
>  		retval = dsbr100_start(radio);
>  		if (retval < 0)
>  			dev_warn(&intf->dev, "dsbr100_start failed\n");
>  	}
>  
> +	mutex_unlock(&radio->lock);
>  	dev_info(&intf->dev, "coming out of suspend..\n");
>  
>  	return 0;
> @@ -605,7 +594,7 @@ static void usb_dsbr100_video_device_release(struct video_device *videodev)
>  /* File system interface */
>  static const struct v4l2_file_operations usb_dsbr100_fops = {
>  	.owner		= THIS_MODULE,
> -	.ioctl		= video_ioctl2,
> +	.unlocked_ioctl	= usb_dsbr100_ioctl,
>  };
>  
>  static const struct v4l2_ioctl_ops usb_dsbr100_ioctl_ops = {
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
