Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2SKsAGD024585
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 16:54:10 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2SKrwtY000302
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 16:53:58 -0400
Date: Fri, 28 Mar 2008 21:53:52 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: Brandon Philips <brandon@ifup.org>
In-Reply-To: <7876c2bc2446dc3e3630.1206699512@localhost>
Message-ID: <Pine.LNX.4.64.0803282114540.22651@axis700.grange>
References: <7876c2bc2446dc3e3630.1206699512@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
	Guennadi Liakhovetski <kernel@pengutronix.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1 of 9] soc_camera: Introduce a spinlock for use with
 videobuf
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Fri, 28 Mar 2008, Brandon Philips wrote:

> # HG changeset patch
> # User Brandon Philips <brandon@ifup.org>
> # Date 1206699276 25200
> # Node ID 7876c2bc2446dc3e3630e7a30a76f50874116cf1
> # Parent  1df4f66ca1fc98ccad4c8377484a56adaf23e49d
> soc_camera: Introduce a spinlock for use with videobuf
> 
> Videobuf will require all drivers to use a spinlock to protect the IRQ queue.
> Introduce this lock for the SOC/PXA drivers.
> 
> Signed-off-by: Brandon Philips <bphilips@suse.de>
> CC: Guennadi Liakhovetski <kernel@pengutronix.de>

I have a couple of questions to this one.

> diff --git a/linux/drivers/media/video/pxa_camera.c b/linux/drivers/media/video/pxa_camera.c
> --- a/linux/drivers/media/video/pxa_camera.c
> +++ b/linux/drivers/media/video/pxa_camera.c
> @@ -108,8 +108,6 @@ struct pxa_camera_dev {
>  	unsigned long		platform_mclk_10khz;
>  
>  	struct list_head	capture;
> -
> -	spinlock_t		lock;
>  
>  	struct pxa_buffer	*active;
>  };

You see, here the spinlock was per camera-bus, i.e., it would be common 
for all cameras on this bus and all open /dev/videoX instances and just 
one per IRQ "thread" (in case of shared IRQs). If you want to make it 
accessible globally, also in soc-camera core but preserve this locality, 
we could put it into "struct soc_camera_host".

> @@ -714,6 +714,7 @@ static int soc_camera_probe(struct devic
>  	if (ret >= 0) {
>  		const struct v4l2_queryctrl *qctrl;
>  
> +		spin_lock_init(&icd->irqlock);
>  		qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_GAIN);
>  		icd->gain = qctrl ? qctrl->default_value : (unsigned short)~0;
>  		qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_EXPOSURE);

Initialization - wouldn't it be enough to initialize it once on 
allocation? In your case if we really put it into struct 
soc_camera_device, in soc_camera_device_register(). Probe can be called 
multiple times for one device, e.g., if the bus gets unloaded and loaded 
again.

> diff --git a/linux/include/media/soc_camera.h b/linux/include/media/soc_camera.h
> --- a/linux/include/media/soc_camera.h
> +++ b/linux/include/media/soc_camera.h
> @@ -19,6 +19,7 @@ struct soc_camera_device {
>  	struct list_head list;
>  	struct device dev;
>  	struct device *control;
> +	spinlock_t irqlock;
>  	unsigned short width;		/* Current window */
>  	unsigned short height;		/* sizes */
>  	unsigned short x_min;		/* Camera capabilities */

Now to where to put it. I see at least three possibilities:

1. as you put it in struct soc_camera_device. This means one spinlock per 
camera device.

2. in struct soc_camera_file, then it would be one spinlock per open 
/dev/videoX instance and thus per struct videobuf_queue.

3. in struct soc_camera_host, then it is one per camera bus and per IRQ 
thread.

I am not quite sure what this spinlock is supposed to protect. If it is 
protecting the videobuf queue, then, maybe, variant (2) above is correct? 
And then just put initialization in soc_camera_open() right after the 
allocation of a struct soc_camera_file instance?

OTOH, at least the PXA270 hardware needs a more global protection - to 
protect the DMA channel setup. And this is hardware specific. We can just 
assume that (imaginary) systems with multiple camera busses will have an 
own DMA channel per bus and will allow their concurrent onfiguration... 
Maybe we should let the hardware host driver decide on spinlock locality 
and just use whatever it provides?

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
