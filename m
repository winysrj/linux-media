Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46450 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489AbZGPPpN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2009 11:45:13 -0400
Date: Thu, 16 Jul 2009 12:45:06 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Lamarque Vieira Souza <lamarque@gmail.com>
Cc: Antoine Jacquet <royale@zerezo.com>, linux-media@vger.kernel.org,
	video4linux-list@redhat.com
Subject: Re: [PATCH] Implement V4L2_CAP_STREAMING for zr364xx driver
Message-ID: <20090716124506.26e7e6b0@pedra.chehab.org>
In-Reply-To: <200907152054.56581.lamarque@gmail.com>
References: <200907152054.56581.lamarque@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 15 Jul 2009 20:54:55 -0300
Lamarque Vieira Souza <lamarque@gmail.com> escreveu:

> This patch implements V4L2_CAP_STREAMING for the zr364xx driver, by
> converting the driver to use videobuf. This version is synced with v4l-dvb as 
> of 15/Jul/2009.
> 
> Tested with Creative PC-CAM 880.
> 
> It basically:
> . implements V4L2_CAP_STREAMING using videobuf;
> 
> . re-implements V4L2_CAP_READWRITE using videobuf;
> 
> . copies cam->udev->product to the card field of the v4l2_capability struct.
> That gives more information to the users about the webcam;
> 
> . moves the brightness setting code from before requesting a frame (in
> read_frame) to the vidioc_s_ctrl ioctl. This way the brightness code is
> executed only when the application requests a change in brightness and
> not before every frame read;
> 
> . comments part of zr364xx_vidioc_try_fmt_vid_cap that says that Skype + 
> libv4l do not work.
> 
> This patch fixes zr364xx for applications such as mplayer,
> Kopete+libv4l and Skype+libv4l can make use of the webcam that comes
> with zr364xx chip.
> 
> Signed-off-by: Lamarque V. Souza <lamarque@gmail.com>
> ---
> 
> diff -r c300798213a9 linux/drivers/media/video/zr364xx.c
> --- a/linux/drivers/media/video/zr364xx.c	Sun Jul 05 19:08:55 2009 -0300
> +++ b/linux/drivers/media/video/zr364xx.c	Wed Jul 15 20:50:34 2009 -0300
> @@ -1,5 +1,5 @@
>  /*
> - * Zoran 364xx based USB webcam module version 0.72
> + * Zoran 364xx based USB webcam module version 0.73
>   *
>   * Allows you to use your USB webcam with V4L2 applications
>   * This is still in heavy developpement !
> @@ -10,6 +10,8 @@
>   * Heavily inspired by usb-skeleton.c, vicam.c, cpia.c and spca50x.c drivers
>   * V4L2 version inspired by meye.c driver
>   *
> + * Some video buffer code by Lamarque based on s2255drv.c and vivi.c drivers.
> + *

Maybe the better example for it is em28xx-video, where we firstly used videobuf
on usb devices.

> +static void free_buffer(struct videobuf_queue *vq, struct zr364xx_buffer 
> *buf)
> +{
> +	DBG("%s\n", __func__);
> +
> +	/*Lamarque: is this really needed? Sometimes this blocks rmmod forever
> +	 * after running Skype on an AMD64 system. */
> +	/*videobuf_waiton(&buf->vb, 0, 0);*/

Answering to your note, take a look at em28xx-video implementation:

        /* We used to wait for the buffer to finish here, but this didn't work
           because, as we were keeping the state as VIDEOBUF_QUEUED,
           videobuf_queue_cancel marked it as finished for us.
           (Also, it could wedge forever if the hardware was misconfigured.)

           This should be safe; by the time we get here, the buffer isn't
           queued anymore. If we ever start marking the buffers as
           VIDEOBUF_ACTIVE, it won't be, though.
        */
        spin_lock_irqsave(&dev->slock, flags);
        if (dev->isoc_ctl.buf == buf)
                dev->isoc_ctl.buf = NULL;
        spin_unlock_irqrestore(&dev->slock, flags);

> +	if (pipe_info->state != 0) {
> +		if (usb_submit_urb(pipe_info->stream_urb, GFP_KERNEL))
> +			dev_err(&cam->udev->dev, "error submitting urb\n");
> +	} else {
> +		DBG("read pipe complete state 0\n");
> +	}

Hmm...  for the usb_submit_urb() call that happens during IRQ context (while
you're receiving stream), you need to use:
        urb->status = usb_submit_urb(pipe_info->stream_urb, GFP_ATOMIC);

otherwise, you may get the errors that Antoine is reporting



Cheers,
Mauro
