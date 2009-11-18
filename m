Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4257 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbZKRHB5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 02:01:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: v4l: Use the video_drvdata function in drivers
Date: Wed, 18 Nov 2009 08:01:48 +0100
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com> <1258504731-8430-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1258504731-8430-8-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911180801.48950.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 18 November 2009 01:38:48 Laurent Pinchart wrote:
> Fix all device drivers to use the video_drvdata function instead of
> maintaining a local list of minor to private data mappings. Call
> video_set_drvdata to register the driver private pointer when not
> already done.
> 
> Where applicable, the local list of mappings is completely removed when
> it becomes unused.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Very nice cleanup!

But you need to check the lock_kernel calls carefully, I think one is now
unbalanced:

> Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx88/cx88-video.c
> ===================================================================
> --- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx88/cx88-video.c
> +++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx88/cx88-video.c
> @@ -76,10 +76,6 @@ MODULE_PARM_DESC(vid_limit,"capture memo
>  #define dprintk(level,fmt, arg...)	if (video_debug >= level) \
>  	printk(KERN_DEBUG "%s/0: " fmt, core->name , ## arg)
>  
> -/* ------------------------------------------------------------------ */
> -
> -static LIST_HEAD(cx8800_devlist);
> -
>  /* ------------------------------------------------------------------- */
>  /* static data                                                         */
>  
> @@ -980,31 +976,23 @@ static int get_ressource(struct cx8800_f
>  static int video_open(struct file *file)
>  {
>  	int minor = video_devdata(file)->minor;
> -	struct cx8800_dev *h,*dev = NULL;
> +	struct video_device *vdev = video_devdata(file);
> +	struct cx8800_dev *dev = video_drvdata(file);
>  	struct cx88_core *core;
>  	struct cx8800_fh *fh;
>  	enum v4l2_buf_type type = 0;
>  	int radio = 0;
>  
> -	lock_kernel();

Lock is removed.

> -	list_for_each_entry(h, &cx8800_devlist, devlist) {
> -		if (h->video_dev->minor == minor) {
> -			dev  = h;
> -			type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> -		}
> -		if (h->vbi_dev->minor == minor) {
> -			dev  = h;
> -			type = V4L2_BUF_TYPE_VBI_CAPTURE;
> -		}
> -		if (h->radio_dev &&
> -		    h->radio_dev->minor == minor) {
> -			radio = 1;
> -			dev   = h;
> -		}
> -	}
> -	if (NULL == dev) {
> -		unlock_kernel();
> -		return -ENODEV;
> +	switch (vdev->vfl_type) {
> +	case VFL_TYPE_GRABBER:
> +		type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +		break;
> +	case VFL_TYPE_VBI:
> +		type = V4L2_BUF_TYPE_VBI_CAPTURE;
> +		break;
> +	case VFL_TYPE_RADIO:
> +		radio = 1;
> +		break;
>  	}

But not added here. And I assume there is an unlock at the end of this
function as well.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
