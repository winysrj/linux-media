Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:49108 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755250Ab2EEMFn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2012 08:05:43 -0400
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 4/4] radio-si470x-usb: remove autosuspend, implement suspend/resume.
Date: Sat, 5 May 2012 14:05:38 +0200
Cc: linux-media@vger.kernel.org,
	Joonyoung Shim <jy0922.shim@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1336138232-17528-1-git-send-email-hverkuil@xs4all.nl> <342493035eca72981784eef475d96f53c5412957.1336137768.git.hans.verkuil@cisco.com>
In-Reply-To: <342493035eca72981784eef475d96f53c5412957.1336137768.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205051405.39046.tobias.lorenz@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

thanks for the improvements. Looks good to me.

Acked-by: Tobias Lorenz <tobias.lorenz@gmx.net>

Bye,
Toby

Am Freitag, 4. Mai 2012, 15:30:32 schrieb Hans Verkuil:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The radio-si470x-usb driver supported both autosuspend and it stopped the
> radio the moment the last user of the radio device closed it. However, that
> was very confusing since if you play the audio from the device (e.g.
> through arecord -D ... | aplay) then no sound would play unless you had
> the radio device open at the same time, even though there is no need to do
> anything with that node.
> 
> On the other hand, the actual suspend/resume functions didn't do anything,
> which would fail if you *did* have the radio node open at that time.
> 
> So:
> 
> - remove autosuspend (bad idea in general for USB radio devices)
> - move the start/stop out of the open/release functions into the
> resume/suspend functions.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/radio/si470x/radio-si470x-common.c |    1 -
>  drivers/media/radio/si470x/radio-si470x-usb.c    |  149
> ++++++++++------------ 2 files changed, 70 insertions(+), 80 deletions(-)
> 
> diff --git a/drivers/media/radio/si470x/radio-si470x-common.c
> b/drivers/media/radio/si470x/radio-si470x-common.c index b9a44d4..969cf49
> 100644
> --- a/drivers/media/radio/si470x/radio-si470x-common.c
> +++ b/drivers/media/radio/si470x/radio-si470x-common.c
> @@ -570,7 +570,6 @@ static int si470x_s_ctrl(struct v4l2_ctrl *ctrl)
>  		else
>  			radio->registers[POWERCFG] |= POWERCFG_DMUTE;
>  		return si470x_set_register(radio, POWERCFG);
> -		break;
>  	default:
>  		return -EINVAL;
>  	}
> diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c
> b/drivers/media/radio/si470x/radio-si470x-usb.c index f133c3d..e9f6387
> 100644
> --- a/drivers/media/radio/si470x/radio-si470x-usb.c
> +++ b/drivers/media/radio/si470x/radio-si470x-usb.c
> @@ -481,91 +481,20 @@ resubmit:
>  }
> 
> 
> -
> -/*************************************************************************
> * - * File Operations Interface
> -
> **************************************************************************
> / -
> -/*
> - * si470x_fops_open - file open
> - */
>  int si470x_fops_open(struct file *file)
>  {
> -	struct si470x_device *radio = video_drvdata(file);
> -	int retval = v4l2_fh_open(file);
> -
> -	if (retval)
> -		return retval;
> -
> -	retval = usb_autopm_get_interface(radio->intf);
> -	if (retval < 0)
> -		goto done;
> -
> -	if (v4l2_fh_is_singular_file(file)) {
> -		/* start radio */
> -		retval = si470x_start(radio);
> -		if (retval < 0) {
> -			usb_autopm_put_interface(radio->intf);
> -			goto done;
> -		}
> -
> -		/* initialize interrupt urb */
> -		usb_fill_int_urb(radio->int_in_urb, radio->usbdev,
> -			usb_rcvintpipe(radio->usbdev,
> -			radio->int_in_endpoint->bEndpointAddress),
> -			radio->int_in_buffer,
> -			le16_to_cpu(radio->int_in_endpoint->wMaxPacketSize),
> -			si470x_int_in_callback,
> -			radio,
> -			radio->int_in_endpoint->bInterval);
> -
> -		radio->int_in_running = 1;
> -		mb();
> -
> -		retval = usb_submit_urb(radio->int_in_urb, GFP_KERNEL);
> -		if (retval) {
> -			dev_info(&radio->intf->dev,
> -				 "submitting int urb failed (%d)\n", retval);
> -			radio->int_in_running = 0;
> -			usb_autopm_put_interface(radio->intf);
> -		}
> -	}
> -
> -done:
> -	if (retval)
> -		v4l2_fh_release(file);
> -	return retval;
> +	return v4l2_fh_open(file);
>  }
> 
> -
> -/*
> - * si470x_fops_release - file release
> - */
>  int si470x_fops_release(struct file *file)
>  {
> -	struct si470x_device *radio = video_drvdata(file);
> -
> -	if (v4l2_fh_is_singular_file(file)) {
> -		/* shutdown interrupt handler */
> -		if (radio->int_in_running) {
> -			radio->int_in_running = 0;
> -			if (radio->int_in_urb)
> -				usb_kill_urb(radio->int_in_urb);
> -		}
> -
> -		/* cancel read processes */
> -		wake_up_interruptible(&radio->read_queue);
> -
> -		/* stop radio */
> -		si470x_stop(radio);
> -		usb_autopm_put_interface(radio->intf);
> -	}
>  	return v4l2_fh_release(file);
>  }
> 
> -static void si470x_usb_release(struct video_device *vdev)
> +static void si470x_usb_release(struct v4l2_device *v4l2_dev)
>  {
> -	struct si470x_device *radio = video_get_drvdata(vdev);
> +	struct si470x_device *radio =
> +		container_of(v4l2_dev, struct si470x_device, v4l2_dev);
> 
>  	usb_free_urb(radio->int_in_urb);
>  	v4l2_ctrl_handler_free(&radio->hdl);
> @@ -599,6 +528,38 @@ int si470x_vidioc_querycap(struct file *file, void
> *priv, }
> 
> 
> +static int si470x_start_usb(struct si470x_device *radio)
> +{
> +	int retval;
> +
> +	/* start radio */
> +	retval = si470x_start(radio);
> +	if (retval < 0)
> +		return retval;
> +
> +	v4l2_ctrl_handler_setup(&radio->hdl);
> +
> +	/* initialize interrupt urb */
> +	usb_fill_int_urb(radio->int_in_urb, radio->usbdev,
> +			usb_rcvintpipe(radio->usbdev,
> +				radio->int_in_endpoint->bEndpointAddress),
> +			radio->int_in_buffer,
> +			le16_to_cpu(radio->int_in_endpoint->wMaxPacketSize),
> +			si470x_int_in_callback,
> +			radio,
> +			radio->int_in_endpoint->bInterval);
> +
> +	radio->int_in_running = 1;
> +	mb();
> +
> +	retval = usb_submit_urb(radio->int_in_urb, GFP_KERNEL);
> +	if (retval) {
> +		dev_info(&radio->intf->dev,
> +				"submitting int urb failed (%d)\n", retval);
> +		radio->int_in_running = 0;
> +	}
> +	return retval;
> +}
> 
>  /*************************************************************************
> * * USB Interface
> @@ -658,6 +619,7 @@ static int si470x_usb_driver_probe(struct usb_interface
> *intf, goto err_intbuffer;
>  	}
> 
> +	radio->v4l2_dev.release = si470x_usb_release;
>  	retval = v4l2_device_register(&intf->dev, &radio->v4l2_dev);
>  	if (retval < 0) {
>  		dev_err(&intf->dev, "couldn't register v4l2_device\n");
> @@ -678,7 +640,7 @@ static int si470x_usb_driver_probe(struct usb_interface
> *intf, radio->videodev.ctrl_handler = &radio->hdl;
>  	radio->videodev.lock = &radio->lock;
>  	radio->videodev.v4l2_dev = &radio->v4l2_dev;
> -	radio->videodev.release = si470x_usb_release;
> +	radio->videodev.release = video_device_release_empty;
>  	set_bit(V4L2_FL_USE_FH_PRIO, &radio->videodev.flags);
>  	video_set_drvdata(&radio->videodev, radio);
> 
> @@ -754,11 +716,16 @@ static int si470x_usb_driver_probe(struct
> usb_interface *intf, init_waitqueue_head(&radio->read_queue);
>  	usb_set_intfdata(intf, radio);
> 
> +	/* start radio */
> +	retval = si470x_start_usb(radio);
> +	if (retval < 0)
> +		goto err_all;
> +
>  	/* register video device */
>  	retval = video_register_device(&radio->videodev, VFL_TYPE_RADIO,
>  			radio_nr);
>  	if (retval) {
> -		dev_warn(&intf->dev, "Could not register video device\n");
> +		dev_err(&intf->dev, "Could not register video device\n");
>  		goto err_all;
>  	}
> 
> @@ -786,8 +753,22 @@ err_initial:
>  static int si470x_usb_driver_suspend(struct usb_interface *intf,
>  		pm_message_t message)
>  {
> +	struct si470x_device *radio = usb_get_intfdata(intf);
> +
>  	dev_info(&intf->dev, "suspending now...\n");
> 
> +	/* shutdown interrupt handler */
> +	if (radio->int_in_running) {
> +		radio->int_in_running = 0;
> +		if (radio->int_in_urb)
> +			usb_kill_urb(radio->int_in_urb);
> +	}
> +
> +	/* cancel read processes */
> +	wake_up_interruptible(&radio->read_queue);
> +
> +	/* stop radio */
> +	si470x_stop(radio);
>  	return 0;
>  }
> 
> @@ -797,9 +778,12 @@ static int si470x_usb_driver_suspend(struct
> usb_interface *intf, */
>  static int si470x_usb_driver_resume(struct usb_interface *intf)
>  {
> +	struct si470x_device *radio = usb_get_intfdata(intf);
> +
>  	dev_info(&intf->dev, "resuming now...\n");
> 
> -	return 0;
> +	/* start radio */
> +	return si470x_start_usb(radio);
>  }
> 
> 
> @@ -815,11 +799,18 @@ static void si470x_usb_driver_disconnect(struct
> usb_interface *intf) video_unregister_device(&radio->videodev);
>  	usb_set_intfdata(intf, NULL);
>  	mutex_unlock(&radio->lock);
> +	v4l2_device_put(&radio->v4l2_dev);
>  }
> 
> 
>  /*
>   * si470x_usb_driver - usb driver interface
> + *
> + * A note on suspend/resume: this driver had only empty suspend/resume
> + * functions, and when I tried to test suspend/resume it always
> disconnected + * instead of resuming (using my ADS InstantFM stick). So
> I've decided to + * remove these callbacks until someone else with better
> hardware can + * implement and test this.
>   */
>  static struct usb_driver si470x_usb_driver = {
>  	.name			= DRIVER_NAME,
> @@ -827,8 +818,8 @@ static struct usb_driver si470x_usb_driver = {
>  	.disconnect		= si470x_usb_driver_disconnect,
>  	.suspend		= si470x_usb_driver_suspend,
>  	.resume			= si470x_usb_driver_resume,
> +	.reset_resume		= si470x_usb_driver_resume,
>  	.id_table		= si470x_usb_driver_id_table,
> -	.supports_autosuspend	= 1,
>  };
> 
>  module_usb_driver(si470x_usb_driver);

