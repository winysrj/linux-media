Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:55434 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755250Ab2EEME5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2012 08:04:57 -0400
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 1/4] si470x: Clean up, introduce the control framework.
Date: Sat, 5 May 2012 14:04:51 +0200
Cc: linux-media@vger.kernel.org,
	Joonyoung Shim <jy0922.shim@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1336138232-17528-1-git-send-email-hverkuil@xs4all.nl> <e9c50530e84fcff80f9928f679eb1d02ba8c349d.1336137768.git.hans.verkuil@cisco.com>
In-Reply-To: <e9c50530e84fcff80f9928f679eb1d02ba8c349d.1336137768.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205051404.51689.tobias.lorenz@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

thanks for the improvements. Looks good to me.

Acked-by: Tobias Lorenz <tobias.lorenz@gmx.net>

Bye,
Toby

Am Freitag, 4. Mai 2012, 15:30:29 schrieb Hans Verkuil:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This cleans up the code and si470x now uses the proper v4l2 frameworks
> and passes most of the v4l2-compliance tests.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/radio/si470x/radio-si470x-common.c |  193
> +++------------------- drivers/media/radio/si470x/radio-si470x-i2c.c    | 
>  65 ++------
>  drivers/media/radio/si470x/radio-si470x-usb.c    |  146 +++++++---------
>  drivers/media/radio/si470x/radio-si470x.h        |   14 +-
>  4 files changed, 105 insertions(+), 313 deletions(-)
> 
> diff --git a/drivers/media/radio/si470x/radio-si470x-common.c
> b/drivers/media/radio/si470x/radio-si470x-common.c index 0e740c9..de9475f
> 100644
> --- a/drivers/media/radio/si470x/radio-si470x-common.c
> +++ b/drivers/media/radio/si470x/radio-si470x-common.c
> @@ -196,9 +196,9 @@ static int si470x_set_chan(struct si470x_device *radio,
> unsigned short chan) }
> 
>  	if ((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0)
> -		dev_warn(&radio->videodev->dev, "tune does not complete\n");
> +		dev_warn(&radio->videodev.dev, "tune does not complete\n");
>  	if (timed_out)
> -		dev_warn(&radio->videodev->dev,
> +		dev_warn(&radio->videodev.dev,
>  			"tune timed out after %u ms\n", tune_timeout);
> 
>  stop:
> @@ -344,12 +344,12 @@ static int si470x_set_seek(struct si470x_device
> *radio, }
> 
>  	if ((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0)
> -		dev_warn(&radio->videodev->dev, "seek does not complete\n");
> +		dev_warn(&radio->videodev.dev, "seek does not complete\n");
>  	if (radio->registers[STATUSRSSI] & STATUSRSSI_SF)
> -		dev_warn(&radio->videodev->dev,
> +		dev_warn(&radio->videodev.dev,
>  			"seek failed / band limit reached\n");
>  	if (timed_out)
> -		dev_warn(&radio->videodev->dev,
> +		dev_warn(&radio->videodev.dev,
>  			"seek timed out after %u ms\n", seek_timeout);
> 
>  stop:
> @@ -463,7 +463,6 @@ static ssize_t si470x_fops_read(struct file *file, char
> __user *buf, unsigned int block_count = 0;
> 
>  	/* switch on rds reception */
> -	mutex_lock(&radio->lock);
>  	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
>  		si470x_rds_on(radio);
> 
> @@ -505,7 +504,6 @@ static ssize_t si470x_fops_read(struct file *file, char
> __user *buf, }
> 
>  done:
> -	mutex_unlock(&radio->lock);
>  	return retval;
>  }
> 
> @@ -521,10 +519,8 @@ static unsigned int si470x_fops_poll(struct file
> *file,
> 
>  	/* switch on rds reception */
> 
> -	mutex_lock(&radio->lock);
>  	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
>  		si470x_rds_on(radio);
> -	mutex_unlock(&radio->lock);
> 
>  	poll_wait(file, &radio->read_queue, pts);
> 
> @@ -553,134 +549,27 @@ static const struct v4l2_file_operations si470x_fops
> = { * Video4Linux Interface
>  
> **************************************************************************
> /
> 
> -/*
> - * si470x_vidioc_queryctrl - enumerate control items
> - */
> -static int si470x_vidioc_queryctrl(struct file *file, void *priv,
> -		struct v4l2_queryctrl *qc)
> -{
> -	struct si470x_device *radio = video_drvdata(file);
> -	int retval = -EINVAL;
> -
> -	/* abort if qc->id is below V4L2_CID_BASE */
> -	if (qc->id < V4L2_CID_BASE)
> -		goto done;
> -
> -	/* search video control */
> -	switch (qc->id) {
> -	case V4L2_CID_AUDIO_VOLUME:
> -		return v4l2_ctrl_query_fill(qc, 0, 15, 1, 15);
> -	case V4L2_CID_AUDIO_MUTE:
> -		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 1);
> -	}
> 
> -	/* disable unsupported base controls */
> -	/* to satisfy kradio and such apps */
> -	if ((retval == -EINVAL) && (qc->id < V4L2_CID_LASTP1)) {
> -		qc->flags = V4L2_CTRL_FLAG_DISABLED;
> -		retval = 0;
> -	}
> -
> -done:
> -	if (retval < 0)
> -		dev_warn(&radio->videodev->dev,
> -			"query controls failed with %d\n", retval);
> -	return retval;
> -}
> -
> -
> -/*
> - * si470x_vidioc_g_ctrl - get the value of a control
> - */
> -static int si470x_vidioc_g_ctrl(struct file *file, void *priv,
> -		struct v4l2_control *ctrl)
> +static int si470x_s_ctrl(struct v4l2_ctrl *ctrl)
>  {
> -	struct si470x_device *radio = video_drvdata(file);
> -	int retval = 0;
> -
> -	mutex_lock(&radio->lock);
> -	/* safety checks */
> -	retval = si470x_disconnect_check(radio);
> -	if (retval)
> -		goto done;
> -
> -	switch (ctrl->id) {
> -	case V4L2_CID_AUDIO_VOLUME:
> -		ctrl->value = radio->registers[SYSCONFIG2] &
> -				SYSCONFIG2_VOLUME;
> -		break;
> -	case V4L2_CID_AUDIO_MUTE:
> -		ctrl->value = ((radio->registers[POWERCFG] &
> -				POWERCFG_DMUTE) == 0) ? 1 : 0;
> -		break;
> -	default:
> -		retval = -EINVAL;
> -	}
> -
> -done:
> -	if (retval < 0)
> -		dev_warn(&radio->videodev->dev,
> -			"get control failed with %d\n", retval);
> -
> -	mutex_unlock(&radio->lock);
> -	return retval;
> -}
> -
> -
> -/*
> - * si470x_vidioc_s_ctrl - set the value of a control
> - */
> -static int si470x_vidioc_s_ctrl(struct file *file, void *priv,
> -		struct v4l2_control *ctrl)
> -{
> -	struct si470x_device *radio = video_drvdata(file);
> -	int retval = 0;
> -
> -	mutex_lock(&radio->lock);
> -	/* safety checks */
> -	retval = si470x_disconnect_check(radio);
> -	if (retval)
> -		goto done;
> +	struct si470x_device *radio =
> +		container_of(ctrl->handler, struct si470x_device, hdl);
> 
>  	switch (ctrl->id) {
>  	case V4L2_CID_AUDIO_VOLUME:
>  		radio->registers[SYSCONFIG2] &= ~SYSCONFIG2_VOLUME;
> -		radio->registers[SYSCONFIG2] |= ctrl->value;
> -		retval = si470x_set_register(radio, SYSCONFIG2);
> -		break;
> +		radio->registers[SYSCONFIG2] |= ctrl->val;
> +		return si470x_set_register(radio, SYSCONFIG2);
>  	case V4L2_CID_AUDIO_MUTE:
> -		if (ctrl->value == 1)
> +		if (ctrl->val)
>  			radio->registers[POWERCFG] &= ~POWERCFG_DMUTE;
>  		else
>  			radio->registers[POWERCFG] |= POWERCFG_DMUTE;
> -		retval = si470x_set_register(radio, POWERCFG);
> +		return si470x_set_register(radio, POWERCFG);
>  		break;
>  	default:
> -		retval = -EINVAL;
> +		return -EINVAL;
>  	}
> -
> -done:
> -	if (retval < 0)
> -		dev_warn(&radio->videodev->dev,
> -			"set control failed with %d\n", retval);
> -	mutex_unlock(&radio->lock);
> -	return retval;
> -}
> -
> -
> -/*
> - * si470x_vidioc_g_audio - get audio attributes
> - */
> -static int si470x_vidioc_g_audio(struct file *file, void *priv,
> -		struct v4l2_audio *audio)
> -{
> -	/* driver constants */
> -	audio->index = 0;
> -	strcpy(audio->name, "Radio");
> -	audio->capability = V4L2_AUDCAP_STEREO;
> -	audio->mode = 0;
> -
> -	return 0;
>  }
> 
> 
> @@ -693,12 +582,6 @@ static int si470x_vidioc_g_tuner(struct file *file,
> void *priv, struct si470x_device *radio = video_drvdata(file);
>  	int retval = 0;
> 
> -	mutex_lock(&radio->lock);
> -	/* safety checks */
> -	retval = si470x_disconnect_check(radio);
> -	if (retval)
> -		goto done;
> -
>  	if (tuner->index != 0) {
>  		retval = -EINVAL;
>  		goto done;
> @@ -737,7 +620,7 @@ static int si470x_vidioc_g_tuner(struct file *file,
> void *priv, if ((radio->registers[STATUSRSSI] & STATUSRSSI_ST) == 0)
>  		tuner->rxsubchans = V4L2_TUNER_SUB_MONO;
>  	else
> -		tuner->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
> +		tuner->rxsubchans = V4L2_TUNER_SUB_STEREO;
>  	/* If there is a reliable method of detecting an RDS channel,
>  	   then this code should check for that before setting this
>  	   RDS subchannel. */
> @@ -761,9 +644,8 @@ static int si470x_vidioc_g_tuner(struct file *file,
> void *priv,
> 
>  done:
>  	if (retval < 0)
> -		dev_warn(&radio->videodev->dev,
> +		dev_warn(&radio->videodev.dev,
>  			"get tuner failed with %d\n", retval);
> -	mutex_unlock(&radio->lock);
>  	return retval;
>  }
> 
> @@ -777,12 +659,6 @@ static int si470x_vidioc_s_tuner(struct file *file,
> void *priv, struct si470x_device *radio = video_drvdata(file);
>  	int retval = 0;
> 
> -	mutex_lock(&radio->lock);
> -	/* safety checks */
> -	retval = si470x_disconnect_check(radio);
> -	if (retval)
> -		goto done;
> -
>  	if (tuner->index != 0)
>  		goto done;
> 
> @@ -802,9 +678,8 @@ static int si470x_vidioc_s_tuner(struct file *file,
> void *priv,
> 
>  done:
>  	if (retval < 0)
> -		dev_warn(&radio->videodev->dev,
> +		dev_warn(&radio->videodev.dev,
>  			"set tuner failed with %d\n", retval);
> -	mutex_unlock(&radio->lock);
>  	return retval;
>  }
> 
> @@ -818,12 +693,6 @@ static int si470x_vidioc_g_frequency(struct file
> *file, void *priv, struct si470x_device *radio = video_drvdata(file);
>  	int retval = 0;
> 
> -	/* safety checks */
> -	mutex_lock(&radio->lock);
> -	retval = si470x_disconnect_check(radio);
> -	if (retval)
> -		goto done;
> -
>  	if (freq->tuner != 0) {
>  		retval = -EINVAL;
>  		goto done;
> @@ -834,9 +703,8 @@ static int si470x_vidioc_g_frequency(struct file *file,
> void *priv,
> 
>  done:
>  	if (retval < 0)
> -		dev_warn(&radio->videodev->dev,
> +		dev_warn(&radio->videodev.dev,
>  			"get frequency failed with %d\n", retval);
> -	mutex_unlock(&radio->lock);
>  	return retval;
>  }
> 
> @@ -850,12 +718,6 @@ static int si470x_vidioc_s_frequency(struct file
> *file, void *priv, struct si470x_device *radio = video_drvdata(file);
>  	int retval = 0;
> 
> -	mutex_lock(&radio->lock);
> -	/* safety checks */
> -	retval = si470x_disconnect_check(radio);
> -	if (retval)
> -		goto done;
> -
>  	if (freq->tuner != 0) {
>  		retval = -EINVAL;
>  		goto done;
> @@ -865,9 +727,8 @@ static int si470x_vidioc_s_frequency(struct file *file,
> void *priv,
> 
>  done:
>  	if (retval < 0)
> -		dev_warn(&radio->videodev->dev,
> +		dev_warn(&radio->videodev.dev,
>  			"set frequency failed with %d\n", retval);
> -	mutex_unlock(&radio->lock);
>  	return retval;
>  }
> 
> @@ -881,12 +742,6 @@ static int si470x_vidioc_s_hw_freq_seek(struct file
> *file, void *priv, struct si470x_device *radio = video_drvdata(file);
>  	int retval = 0;
> 
> -	mutex_lock(&radio->lock);
> -	/* safety checks */
> -	retval = si470x_disconnect_check(radio);
> -	if (retval)
> -		goto done;
> -
>  	if (seek->tuner != 0) {
>  		retval = -EINVAL;
>  		goto done;
> @@ -896,22 +751,20 @@ static int si470x_vidioc_s_hw_freq_seek(struct file
> *file, void *priv,
> 
>  done:
>  	if (retval < 0)
> -		dev_warn(&radio->videodev->dev,
> +		dev_warn(&radio->videodev.dev,
>  			"set hardware frequency seek failed with %d\n", retval);
> -	mutex_unlock(&radio->lock);
>  	return retval;
>  }
> 
> +const struct v4l2_ctrl_ops si470x_ctrl_ops = {
> +	.s_ctrl = si470x_s_ctrl,
> +};
> 
>  /*
>   * si470x_ioctl_ops - video device ioctl operations
>   */
>  static const struct v4l2_ioctl_ops si470x_ioctl_ops = {
>  	.vidioc_querycap	= si470x_vidioc_querycap,
> -	.vidioc_queryctrl	= si470x_vidioc_queryctrl,
> -	.vidioc_g_ctrl		= si470x_vidioc_g_ctrl,
> -	.vidioc_s_ctrl		= si470x_vidioc_s_ctrl,
> -	.vidioc_g_audio		= si470x_vidioc_g_audio,
>  	.vidioc_g_tuner		= si470x_vidioc_g_tuner,
>  	.vidioc_s_tuner		= si470x_vidioc_s_tuner,
>  	.vidioc_g_frequency	= si470x_vidioc_g_frequency,
> @@ -926,6 +779,6 @@ static const struct v4l2_ioctl_ops si470x_ioctl_ops = {
>  struct video_device si470x_viddev_template = {
>  	.fops			= &si470x_fops,
>  	.name			= DRIVER_NAME,
> -	.release		= video_device_release,
> +	.release		= video_device_release_empty,
>  	.ioctl_ops		= &si470x_ioctl_ops,
>  };
> diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c
> b/drivers/media/radio/si470x/radio-si470x-i2c.c index 9b546a5..a80044c
> 100644
> --- a/drivers/media/radio/si470x/radio-si470x-i2c.c
> +++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
> @@ -162,20 +162,6 @@ static int si470x_get_all_registers(struct
> si470x_device *radio)
> 
> 
>  /*************************************************************************
> * - * General Driver Functions - DISCONNECT_CHECK
> -
> **************************************************************************
> / -
> -/*
> - * si470x_disconnect_check - check whether radio disconnects
> - */
> -int si470x_disconnect_check(struct si470x_device *radio)
> -{
> -	return 0;
> -}
> -
> -
> -
> -/*************************************************************************
> * * File Operations Interface
>  
> **************************************************************************
> /
> 
> @@ -185,12 +171,12 @@ int si470x_disconnect_check(struct si470x_device
> *radio) int si470x_fops_open(struct file *file)
>  {
>  	struct si470x_device *radio = video_drvdata(file);
> -	int retval = 0;
> +	int retval = v4l2_fh_open(file);
> 
> -	mutex_lock(&radio->lock);
> -	radio->users++;
> +	if (retval)
> +		return retval;
> 
> -	if (radio->users == 1) {
> +	if (v4l2_fh_is_singular_file(file)) {
>  		/* start radio */
>  		retval = si470x_start(radio);
>  		if (retval < 0)
> @@ -205,7 +191,8 @@ int si470x_fops_open(struct file *file)
>  	}
> 
>  done:
> -	mutex_unlock(&radio->lock);
> +	if (retval)
> +		v4l2_fh_release(file);
>  	return retval;
>  }
> 
> @@ -216,21 +203,12 @@ done:
>  int si470x_fops_release(struct file *file)
>  {
>  	struct si470x_device *radio = video_drvdata(file);
> -	int retval = 0;
> -
> -	/* safety check */
> -	if (!radio)
> -		return -ENODEV;
> 
> -	mutex_lock(&radio->lock);
> -	radio->users--;
> -	if (radio->users == 0)
> +	if (v4l2_fh_is_singular_file(file))
>  		/* stop radio */
> -		retval = si470x_stop(radio);
> +		si470x_stop(radio);
> 
> -	mutex_unlock(&radio->lock);
> -
> -	return retval;
> +	return v4l2_fh_release(file);
>  }
> 
> 
> @@ -371,32 +349,25 @@ static int __devinit si470x_i2c_probe(struct
> i2c_client *client, goto err_initial;
>  	}
> 
> -	radio->users = 0;
>  	radio->client = client;
>  	mutex_init(&radio->lock);
> 
> -	/* video device allocation and initialization */
> -	radio->videodev = video_device_alloc();
> -	if (!radio->videodev) {
> -		retval = -ENOMEM;
> -		goto err_radio;
> -	}
> -	memcpy(radio->videodev, &si470x_viddev_template,
> -			sizeof(si470x_viddev_template));
> -	video_set_drvdata(radio->videodev, radio);
> +	/* video device initialization */
> +	radio->videodev = si470x_viddev_template;
> +	video_set_drvdata(&radio->videodev, radio);
> 
>  	/* power up : need 110ms */
>  	radio->registers[POWERCFG] = POWERCFG_ENABLE;
>  	if (si470x_set_register(radio, POWERCFG) < 0) {
>  		retval = -EIO;
> -		goto err_video;
> +		goto err_radio;
>  	}
>  	msleep(110);
> 
>  	/* get device and chip versions */
>  	if (si470x_get_all_registers(radio) < 0) {
>  		retval = -EIO;
> -		goto err_video;
> +		goto err_radio;
>  	}
>  	dev_info(&client->dev, "DeviceID=0x%4.4hx ChipID=0x%4.4hx\n",
>  			radio->registers[DEVICEID], radio->registers[CHIPID]);
> @@ -427,7 +398,7 @@ static int __devinit si470x_i2c_probe(struct i2c_client
> *client, radio->buffer = kmalloc(radio->buf_size, GFP_KERNEL);
>  	if (!radio->buffer) {
>  		retval = -EIO;
> -		goto err_video;
> +		goto err_radio;
>  	}
> 
>  	/* rds buffer configuration */
> @@ -447,7 +418,7 @@ static int __devinit si470x_i2c_probe(struct i2c_client
> *client, }
> 
>  	/* register video device */
> -	retval = video_register_device(radio->videodev, VFL_TYPE_RADIO,
> +	retval = video_register_device(&radio->videodev, VFL_TYPE_RADIO,
>  			radio_nr);
>  	if (retval) {
>  		dev_warn(&client->dev, "Could not register video device\n");
> @@ -460,8 +431,6 @@ err_all:
>  	free_irq(client->irq, radio);
>  err_rds:
>  	kfree(radio->buffer);
> -err_video:
> -	video_device_release(radio->videodev);
>  err_radio:
>  	kfree(radio);
>  err_initial:
> @@ -477,7 +446,7 @@ static __devexit int si470x_i2c_remove(struct
> i2c_client *client) struct si470x_device *radio =
> i2c_get_clientdata(client);
> 
>  	free_irq(client->irq, radio);
> -	video_unregister_device(radio->videodev);
> +	video_unregister_device(&radio->videodev);
>  	kfree(radio);
> 
>  	return 0;
> diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c
> b/drivers/media/radio/si470x/radio-si470x-usb.c index b7debb6..f133c3d
> 100644
> --- a/drivers/media/radio/si470x/radio-si470x-usb.c
> +++ b/drivers/media/radio/si470x/radio-si470x-usb.c
> @@ -367,23 +367,6 @@ static int si470x_get_scratch_page_versions(struct
> si470x_device *radio)
> 
> 
>  /*************************************************************************
> * - * General Driver Functions - DISCONNECT_CHECK
> -
> **************************************************************************
> / -
> -/*
> - * si470x_disconnect_check - check whether radio disconnects
> - */
> -int si470x_disconnect_check(struct si470x_device *radio)
> -{
> -	if (radio->disconnected)
> -		return -EIO;
> -	else
> -		return 0;
> -}
> -
> -
> -
> -/*************************************************************************
> * * RDS Driver Functions
>  
> **************************************************************************
> /
> 
> @@ -414,9 +397,6 @@ static void si470x_int_in_callback(struct urb *urb)
>  		}
>  	}
> 
> -	/* safety checks */
> -	if (radio->disconnected)
> -		return;
>  	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
>  		goto resubmit;
> 
> @@ -512,19 +492,16 @@ resubmit:
>  int si470x_fops_open(struct file *file)
>  {
>  	struct si470x_device *radio = video_drvdata(file);
> -	int retval;
> +	int retval = v4l2_fh_open(file);
> 
> -	mutex_lock(&radio->lock);
> -	radio->users++;
> +	if (retval)
> +		return retval;
> 
>  	retval = usb_autopm_get_interface(radio->intf);
> -	if (retval < 0) {
> -		radio->users--;
> -		retval = -EIO;
> +	if (retval < 0)
>  		goto done;
> -	}
> 
> -	if (radio->users == 1) {
> +	if (v4l2_fh_is_singular_file(file)) {
>  		/* start radio */
>  		retval = si470x_start(radio);
>  		if (retval < 0) {
> @@ -555,7 +532,8 @@ int si470x_fops_open(struct file *file)
>  	}
> 
>  done:
> -	mutex_unlock(&radio->lock);
> +	if (retval)
> +		v4l2_fh_release(file);
>  	return retval;
>  }
> 
> @@ -566,45 +544,36 @@ done:
>  int si470x_fops_release(struct file *file)
>  {
>  	struct si470x_device *radio = video_drvdata(file);
> -	int retval = 0;
> 
> -	/* safety check */
> -	if (!radio) {
> -		retval = -ENODEV;
> -		goto done;
> -	}
> -
> -	mutex_lock(&radio->lock);
> -	radio->users--;
> -	if (radio->users == 0) {
> +	if (v4l2_fh_is_singular_file(file)) {
>  		/* shutdown interrupt handler */
>  		if (radio->int_in_running) {
>  			radio->int_in_running = 0;
> -		if (radio->int_in_urb)
> -			usb_kill_urb(radio->int_in_urb);
> -		}
> -
> -		if (radio->disconnected) {
> -			video_unregister_device(radio->videodev);
> -			kfree(radio->int_in_buffer);
> -			kfree(radio->buffer);
> -			mutex_unlock(&radio->lock);
> -			kfree(radio);
> -			goto done;
> +			if (radio->int_in_urb)
> +				usb_kill_urb(radio->int_in_urb);
>  		}
> 
>  		/* cancel read processes */
>  		wake_up_interruptible(&radio->read_queue);
> 
>  		/* stop radio */
> -		retval = si470x_stop(radio);
> +		si470x_stop(radio);
>  		usb_autopm_put_interface(radio->intf);
>  	}
> -	mutex_unlock(&radio->lock);
> -done:
> -	return retval;
> +	return v4l2_fh_release(file);
>  }
> 
> +static void si470x_usb_release(struct video_device *vdev)
> +{
> +	struct si470x_device *radio = video_get_drvdata(vdev);
> +
> +	usb_free_urb(radio->int_in_urb);
> +	v4l2_ctrl_handler_free(&radio->hdl);
> +	v4l2_device_unregister(&radio->v4l2_dev);
> +	kfree(radio->int_in_buffer);
> +	kfree(radio->buffer);
> +	kfree(radio);
> +}
> 
> 
>  /*************************************************************************
> * @@ -623,9 +592,9 @@ int si470x_vidioc_querycap(struct file *file, void
> *priv, strlcpy(capability->card, DRIVER_CARD, sizeof(capability->card));
> usb_make_path(radio->usbdev, capability->bus_info,
>  			sizeof(capability->bus_info));
> -	capability->capabilities = V4L2_CAP_HW_FREQ_SEEK |
> +	capability->device_caps = V4L2_CAP_HW_FREQ_SEEK |
>  		V4L2_CAP_TUNER | V4L2_CAP_RADIO | V4L2_CAP_RDS_CAPTURE;
> -
> +	capability->capabilities = capability->device_caps |
> V4L2_CAP_DEVICE_CAPS; return 0;
>  }
> 
> @@ -653,8 +622,6 @@ static int si470x_usb_driver_probe(struct usb_interface
> *intf, retval = -ENOMEM;
>  		goto err_initial;
>  	}
> -	radio->users = 0;
> -	radio->disconnected = 0;
>  	radio->usbdev = interface_to_usbdev(intf);
>  	radio->intf = intf;
>  	mutex_init(&radio->lock);
> @@ -691,20 +658,34 @@ static int si470x_usb_driver_probe(struct
> usb_interface *intf, goto err_intbuffer;
>  	}
> 
> -	/* video device allocation and initialization */
> -	radio->videodev = video_device_alloc();
> -	if (!radio->videodev) {
> -		retval = -ENOMEM;
> +	retval = v4l2_device_register(&intf->dev, &radio->v4l2_dev);
> +	if (retval < 0) {
> +		dev_err(&intf->dev, "couldn't register v4l2_device\n");
>  		goto err_urb;
>  	}
> -	memcpy(radio->videodev, &si470x_viddev_template,
> -			sizeof(si470x_viddev_template));
> -	video_set_drvdata(radio->videodev, radio);
> +
> +	v4l2_ctrl_handler_init(&radio->hdl, 2);
> +	v4l2_ctrl_new_std(&radio->hdl, &si470x_ctrl_ops,
> +			  V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
> +	v4l2_ctrl_new_std(&radio->hdl, &si470x_ctrl_ops,
> +			  V4L2_CID_AUDIO_VOLUME, 0, 15, 1, 15);
> +	if (radio->hdl.error) {
> +		retval = radio->hdl.error;
> +		dev_err(&intf->dev, "couldn't register control\n");
> +		goto err_dev;
> +	}
> +	radio->videodev = si470x_viddev_template;
> +	radio->videodev.ctrl_handler = &radio->hdl;
> +	radio->videodev.lock = &radio->lock;
> +	radio->videodev.v4l2_dev = &radio->v4l2_dev;
> +	radio->videodev.release = si470x_usb_release;
> +	set_bit(V4L2_FL_USE_FH_PRIO, &radio->videodev.flags);
> +	video_set_drvdata(&radio->videodev, radio);
> 
>  	/* get device and chip versions */
>  	if (si470x_get_all_registers(radio) < 0) {
>  		retval = -EIO;
> -		goto err_video;
> +		goto err_ctrl;
>  	}
>  	dev_info(&intf->dev, "DeviceID=0x%4.4hx ChipID=0x%4.4hx\n",
>  			radio->registers[DEVICEID], radio->registers[CHIPID]);
> @@ -721,7 +702,7 @@ static int si470x_usb_driver_probe(struct usb_interface
> *intf, /* get software and hardware versions */
>  	if (si470x_get_scratch_page_versions(radio) < 0) {
>  		retval = -EIO;
> -		goto err_video;
> +		goto err_ctrl;
>  	}
>  	dev_info(&intf->dev, "software version %d, hardware version %d\n",
>  			radio->software_version, radio->hardware_version);
> @@ -764,28 +745,30 @@ static int si470x_usb_driver_probe(struct
> usb_interface *intf, radio->buffer = kmalloc(radio->buf_size, GFP_KERNEL);
>  	if (!radio->buffer) {
>  		retval = -EIO;
> -		goto err_video;
> +		goto err_ctrl;
>  	}
> 
>  	/* rds buffer configuration */
>  	radio->wr_index = 0;
>  	radio->rd_index = 0;
>  	init_waitqueue_head(&radio->read_queue);
> +	usb_set_intfdata(intf, radio);
> 
>  	/* register video device */
> -	retval = video_register_device(radio->videodev, VFL_TYPE_RADIO,
> +	retval = video_register_device(&radio->videodev, VFL_TYPE_RADIO,
>  			radio_nr);
>  	if (retval) {
>  		dev_warn(&intf->dev, "Could not register video device\n");
>  		goto err_all;
>  	}
> -	usb_set_intfdata(intf, radio);
> 
>  	return 0;
>  err_all:
>  	kfree(radio->buffer);
> -err_video:
> -	video_device_release(radio->videodev);
> +err_ctrl:
> +	v4l2_ctrl_handler_free(&radio->hdl);
> +err_dev:
> +	v4l2_device_unregister(&radio->v4l2_dev);
>  err_urb:
>  	usb_free_urb(radio->int_in_urb);
>  err_intbuffer:
> @@ -828,23 +811,10 @@ static void si470x_usb_driver_disconnect(struct
> usb_interface *intf) struct si470x_device *radio = usb_get_intfdata(intf);
> 
>  	mutex_lock(&radio->lock);
> -	radio->disconnected = 1;
> +	v4l2_device_disconnect(&radio->v4l2_dev);
> +	video_unregister_device(&radio->videodev);
>  	usb_set_intfdata(intf, NULL);
> -	if (radio->users == 0) {
> -		/* set led to disconnect state */
> -		si470x_set_led_state(radio, BLINK_ORANGE_LED);
> -
> -		/* Free data structures. */
> -		usb_free_urb(radio->int_in_urb);
> -
> -		kfree(radio->int_in_buffer);
> -		video_unregister_device(radio->videodev);
> -		kfree(radio->buffer);
> -		mutex_unlock(&radio->lock);
> -		kfree(radio);
> -	} else {
> -		mutex_unlock(&radio->lock);
> -	}
> +	mutex_unlock(&radio->lock);
>  }
> 
> 
> diff --git a/drivers/media/radio/si470x/radio-si470x.h
> b/drivers/media/radio/si470x/radio-si470x.h index f300a55..4921cab 100644
> --- a/drivers/media/radio/si470x/radio-si470x.h
> +++ b/drivers/media/radio/si470x/radio-si470x.h
> @@ -36,6 +36,9 @@
>  #include <linux/mutex.h>
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-ioctl.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-device.h>
>  #include <asm/unaligned.h>
> 
> 
> @@ -141,10 +144,9 @@
>   * si470x_device - private data
>   */
>  struct si470x_device {
> -	struct video_device *videodev;
> -
> -	/* driver management */
> -	unsigned int users;
> +	struct v4l2_device v4l2_dev;
> +	struct video_device videodev;
> +	struct v4l2_ctrl_handler hdl;
> 
>  	/* Silabs internal registers (0..15) */
>  	unsigned short registers[RADIO_REGISTER_NUM];
> @@ -174,9 +176,6 @@ struct si470x_device {
>  	/* scratch page */
>  	unsigned char software_version;
>  	unsigned char hardware_version;
> -
> -	/* driver management */
> -	unsigned char disconnected;
>  #endif
> 
>  #if defined(CONFIG_I2C_SI470X) || defined(CONFIG_I2C_SI470X_MODULE)
> @@ -213,6 +212,7 @@ struct si470x_device {
>   * Common Functions
>  
> **************************************************************************
> / extern struct video_device si470x_viddev_template;
> +extern const struct v4l2_ctrl_ops si470x_ctrl_ops;
>  int si470x_get_register(struct si470x_device *radio, int regnr);
>  int si470x_set_register(struct si470x_device *radio, int regnr);
>  int si470x_disconnect_check(struct si470x_device *radio);

