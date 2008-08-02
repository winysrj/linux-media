Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m72KAU82019655
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 16:10:30 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m72K9wVn001650
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 16:09:58 -0400
Date: Sat, 2 Aug 2008 22:09:50 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <87hca34ra0.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0808022146090.27474@axis700.grange>
References: <87hca34ra0.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [RFC] soc_camera: endianness between camera and its host
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

On Sat, 2 Aug 2008, Robert Jarzmik wrote:

> Modern camera chips provide ways to invert their data output, as well in colors
> swap as in byte order. To be more precise, the one I know (mt9m111) enables :

To me these look like just different pixel formats:

>  - swapping Red and Blue in RGB formats

This is no longer RGB, but BGR, compare:

#define V4L2_PIX_FMT_BGR24   v4l2_fourcc('B', 'G', 'R', '3') /* 24  BGR-8-8-8     */
#define V4L2_PIX_FMT_RGB24   v4l2_fourcc('R', 'G', 'B', '3') /* 24  RGB-8-8-8     */

>  - swapping first and second byte in RGB formats

hm, no idea about this one

>  - swapping Cb and Cr in YUV formats

I couldn't find it among the defined formats in videodev2.h, but on 
http://www.fourcc.org/ they are defined as YVYU vs. YUYV.

>  - swapping chrominance and luminance in YUV formats

These seem to be these two:

#define V4L2_PIX_FMT_YUYV    v4l2_fourcc('Y', 'U', 'Y', 'V') /* 16  YUV 4:2:2     */
#define V4L2_PIX_FMT_UYVY    v4l2_fourcc('U', 'Y', 'V', 'Y') /* 16  YUV 4:2:2     */

So, I don't see at first any relation to host's endianness. You just 
define respective formats in cameras array of struct 
soc_camera_data_format.

> This swap is necessary to adapt the camera chip output to the capture
> interface. For example, pxa_camera on pxa27x CPUs expects RGB and YUV formats
> in a very specific order. This order is not the default one on mt9m111 chip, so
> the mt9m111 driver has to have a way to know how to order its output.
> 
> The question I have is where to put such information, so that board specific
> code (arch/arm/mach-pxa/xxx.c) can setup this for a dedicated camera chip ?
> 
> One easy way would be to put it in soc_camera_link, but is it the right place ?

Isn't using the existing pixel format negotiation procedure eough?

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
