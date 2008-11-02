Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA2LFoqx025461
	for <video4linux-list@redhat.com>; Sun, 2 Nov 2008 16:15:50 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mA2LFSXu014762
	for <video4linux-list@redhat.com>; Sun, 2 Nov 2008 16:15:28 -0500
Date: Sun, 2 Nov 2008 22:15:29 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <87mygkof3j.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0811022048430.14486@axis700.grange>
References: <20081029232544.661b8f17.ospite@studenti.unina.it>
	<87mygkof3j.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] mt9m111: Fix YUYV format for pxa-camera
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

On Fri, 31 Oct 2008, Robert Jarzmik wrote:

> Antonio Ospite <ospite@studenti.unina.it> writes:
> 
> > Use 16 bit depth for YUYV so the pxa-camera image buffer has the correct size,
> > see the formula:
> >
> > 	*size = icd->width * icd->height *
> > 		((icd->current_fmt->depth + 7) >> 3);
> >
> > in drivers/media/video/pxa_camera.c: pxa_videobuf_setup().
> >
> > Don't swap Cb and Cr components, to respect PXA Quick Capture Interface
> > data format.
> >
> > Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
> Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>
> 
> As a side note, I wonder how you found the right swap :
>  - I based the code on Intel PXA Developer Manual, table 27-19 (page 1127)
>  - and on MT9M111 specification sheet, table 3 (page 14)
> My guess is that the PXA manual is wrong somehow ...
> 
> Anyway, I'm happy with the patch. Guennadi, could you add this patch to your
> queue please ?

Hm, I am not all that happy about it. The first part is ok - it is indeed 
a 16-bit format. But the second part doesn't seem right. Before you were 
using the non-swapped camera configuration unconditionally. Now you swap 
it - also unconditionally. Whereas under different conditions we need 
different byte order. Here we arrive again at pixel-format negotiation 
between the host and the camera...

Looking in the PXA270 datasheet, I would say, that it supports

V4L2_PIX_FMT_UYVY (Table 27-21, remember pxa270 is little-endian only)
and
V4L2_PIX_FMT_YUV422P (Table 27-20)

Whereas in the driver the former of the two modes is called

V4L2_PIX_FMT_YUYV

... This, I think, is a mistake.

Next, let's see how data is transferred over the 8-bit data bus. The 
PXA270 is expecting the data in the order

UYVY.... (Table 27-19)

MT9M111 can either send UYVY or YUYV depending on the value of bit 1 in 
Output Format Control register(s). Now we know, that 
OUTPUT_FORMAT_CTRL2[1] = 1 matches PXA270 format (UYUV), hence 
OUTPUT_FORMAT_CTRL2[1] = 0 means YUYV, which might be necessary for other 
camera hosts.

So, we have: PXA270 supports V4L2_PIX_FMT_UYVY on input and can convert it 
to either V4L2_PIX_FMT_UYVY or V4L2_PIX_FMT_YUV422P on output.

MT9M111 supports V4L2_PIX_FMT_UYVY and V4L2_PIX_FMT_YUYV (as well as 
V4L2_PIX_FMT_VYUY and V4L2_PIX_FMT_YVYU) on output. Now, PXA270 driver 
should accept user requests for UYVY and YUV422P and request UYUV from the 
camera.

I think, we could just add another format entry to mt9m111 with 
V4L2_PIX_FMT_UYVY and set OUTPUT_FORMAT_CTRL2[1] if _that_ format is 
requested, as opposed to V4L2_PIX_FMT_YUYV. This way mt9m111's behaviour 
will not change, and will even become correct:-) And in pxa driver we 
should check for V4L2_PIX_FMT_UYVY and _not_ V4L2_PIX_FMT_YUYV. And, of 
course, mt9m111 users will have to switch to use V4L2_PIX_FMT_UYVY in 
their user-space applications. Does this sound acceptable?

In the longer run we should do something along the lines:

1. merge .try_bus_param() into .try_fmt_cap() camera host methods - they 
are called only at one place one after another.

2. add a data format table list similar to the one in struct 
soc_camera_device (or identical) to struct soc_camera_host.

3. soc_camera.c should use the list from struct soc_camera_host in calls 
to format_by_fourcc().

4. camera host drivers then decide based upon user request which format to 
request from the camera in calls to .try_fmt_cap() and .set_fmt_cap() 
methods from struct soc_camera_ops.

Only when I'll be able to do this... Comments welcome.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
