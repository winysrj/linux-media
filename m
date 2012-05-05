Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285Ab2EEHjL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 May 2012 03:39:11 -0400
Message-ID: <4FA4DA05.5030001@redhat.com>
Date: Sat, 05 May 2012 09:43:01 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 1/7] gspca: allow subdrivers to use the control
 framework.
References: <1335625796-9429-1-git-send-email-hverkuil@xs4all.nl> <ea7e986dc0fa18da12c22048e9187e9933191d3d.1335625085.git.hans.verkuil@cisco.com>
In-Reply-To: <ea7e986dc0fa18da12c22048e9187e9933191d3d.1335625085.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm slowly working my way though this series today (both review, as well
as some tweaks and testing).

More comments inline...

On 04/28/2012 05:09 PM, Hans Verkuil wrote:
> From: Hans Verkuil<hans.verkuil@cisco.com>
>
> Make the necessary changes to allow subdrivers to use the control framework.
> This does not add control event support, that needs more work.
>
> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>
> ---
>   drivers/media/video/gspca/gspca.c |   13 +++++++++----
>   1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
> index ca5a2b1..56dff10 100644
> --- a/drivers/media/video/gspca/gspca.c
> +++ b/drivers/media/video/gspca/gspca.c
> @@ -38,6 +38,7 @@
>   #include<linux/uaccess.h>
>   #include<linux/ktime.h>
>   #include<media/v4l2-ioctl.h>
> +#include<media/v4l2-ctrls.h>
>
>   #include "gspca.h"
>
> @@ -1006,6 +1007,8 @@ static void gspca_set_default_mode(struct gspca_dev *gspca_dev)
>
>   	/* set the current control values to their default values
>   	 * which may have changed in sd_init() */
> +	/* does nothing if ctrl_handler == NULL */
> +	v4l2_ctrl_handler_setup(gspca_dev->vdev.ctrl_handler);
>   	ctrl = gspca_dev->cam.ctrls;
>   	if (ctrl != NULL) {
>   		for (i = 0;
> @@ -1323,6 +1326,7 @@ static void gspca_release(struct video_device *vfd)
>   	PDEBUG(D_PROBE, "%s released",
>   		video_device_node_name(&gspca_dev->vdev));
>
> +	v4l2_ctrl_handler_free(gspca_dev->vdev.ctrl_handler);
>   	kfree(gspca_dev->usb_buf);
>   	kfree(gspca_dev);
>   }
> @@ -2347,6 +2351,10 @@ int gspca_dev_probe2(struct usb_interface *intf,
>   	gspca_dev->sd_desc = sd_desc;
>   	gspca_dev->nbufread = 2;
>   	gspca_dev->empty_packet = -1;	/* don't check the empty packets */
> +	gspca_dev->vdev = gspca_template;
> +	gspca_dev->vdev.parent =&intf->dev;
> +	gspca_dev->module = module;
> +	gspca_dev->present = 1;
>
>   	/* configure the subdriver and initialize the USB device */
>   	ret = sd_desc->config(gspca_dev, id);

You also need to move the initialization of the mutexes here, as the
v4l2_ctrl_handler_setup will call s_ctrl on all the controls, and s_ctrl
should take the usb_lock (see my review of the next patch in this series),
I'll make this change myself and merge it into your patch.

> @@ -2368,10 +2376,6 @@ int gspca_dev_probe2(struct usb_interface *intf,
>   	init_waitqueue_head(&gspca_dev->wq);
>
>   	/* init video stuff */
> -	memcpy(&gspca_dev->vdev,&gspca_template, sizeof gspca_template);
> -	gspca_dev->vdev.parent =&intf->dev;
> -	gspca_dev->module = module;
> -	gspca_dev->present = 1;
>   	ret = video_register_device(&gspca_dev->vdev,
>   				  VFL_TYPE_GRABBER,
>   				  -1);
> @@ -2391,6 +2395,7 @@ out:
>   	if (gspca_dev->input_dev)
>   		input_unregister_device(gspca_dev->input_dev);
>   #endif
> +	v4l2_ctrl_handler_free(gspca_dev->vdev.ctrl_handler);
>   	kfree(gspca_dev->usb_buf);
>   	kfree(gspca_dev);
>   	return ret;

Otherwise looks good, I've added it to my local tree (with the
described change), and will include it in my next pullreq.

Regards,

Hans
