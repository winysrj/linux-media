Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:51088 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbZKZAHU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 19:07:20 -0500
Received: by fg-out-1718.google.com with SMTP id 19so241241fgg.1
        for <linux-media@vger.kernel.org>; Wed, 25 Nov 2009 16:07:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200911260102.40881.laurent.pinchart@ideasonboard.com>
References: <200911181354.06529.laurent.pinchart@ideasonboard.com>
	 <829197380911251506g4af4d72v85c6dfb55cb88d0a@mail.gmail.com>
	 <200911260102.40881.laurent.pinchart@ideasonboard.com>
Date: Wed, 25 Nov 2009 19:07:25 -0500
Message-ID: <829197380911251607y5c9b4378y1c4f52b120c54698@mail.gmail.com>
Subject: Re: [PATCH/RFC v2] V4L core cleanups HG tree
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	mchehab@infradead.org, sakari.ailus@maxwell.research.nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 25, 2009 at 7:02 PM, Laurent Pinchart
> Thank you very much for the report. Could you please try with the following
> patch applied on top of the v4l-dvb-cleanup tree ?
>
> diff -r 98e3929a1a2d linux/drivers/media/video/au0828/au0828-video.c
> --- a/linux/drivers/media/video/au0828/au0828-video.c   Wed Nov 25 12:55:47 2009 +0100
> +++ b/linux/drivers/media/video/au0828/au0828-video.c   Thu Nov 26 01:02:15 2009 +0100
> @@ -697,10 +697,8 @@
>        dprintk(1, "au0828_release_resources called\n");
>        mutex_lock(&au0828_sysfs_lock);
>
> -       if (dev->vdev) {
> -               list_del(&dev->au0828list);
> +       if (dev->vdev)
>                video_unregister_device(dev->vdev);
> -       }
>        if (dev->vbi_dev)
>                video_unregister_device(dev->vbi_dev);
>
> @@ -1671,7 +1669,6 @@
>        if (retval != 0) {
>                dprintk(1, "unable to register video device (error = %d).\n",
>                        retval);
> -               list_del(&dev->au0828list);
>                video_device_release(dev->vdev);
>                return -ENODEV;
>        }
> @@ -1683,7 +1680,6 @@
>        if (retval != 0) {
>                dprintk(1, "unable to register vbi device (error = %d).\n",
>                        retval);
> -               list_del(&dev->au0828list);
>                video_device_release(dev->vbi_dev);
>                video_device_release(dev->vdev);
>                return -ENODEV;
> diff -r 98e3929a1a2d linux/drivers/media/video/au0828/au0828.h
> --- a/linux/drivers/media/video/au0828/au0828.h Wed Nov 25 12:55:47 2009 +0100
> +++ b/linux/drivers/media/video/au0828/au0828.h Thu Nov 26 01:02:15 2009 +0100
> @@ -192,7 +192,6 @@
>        struct au0828_dvb               dvb;
>
>        /* Analog */
> -       struct list_head au0828list;
>        struct v4l2_device v4l2_dev;
>        int users;
>        unsigned int stream_on:1;       /* Locks streams */

Trying it now....

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
