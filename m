Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mALMGjNq007535
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 17:16:45 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mALMGWsw002675
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 17:16:33 -0500
Date: Fri, 21 Nov 2008 23:16:33 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <878wrcztqb.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0811212256160.8956@axis700.grange>
References: <Pine.LNX.4.64.0811181945410.8628@axis700.grange>
	<Pine.LNX.4.64.0811182010460.8628@axis700.grange>
	<87y6zf76aw.fsf@free.fr>
	<Pine.LNX.4.64.0811202055210.8290@axis700.grange>
	<8763mg28bf.fsf@free.fr>
	<Pine.LNX.4.64.0811212051360.8956@axis700.grange>
	<878wrcztqb.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 2/2 v3] pxa-camera: pixel format negotiation
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

On Fri, 21 Nov 2008, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> >> > Yes, I do not know how to pass a 16-bit format in a pass-through mode, and 
> >> > I don't have a test-case for it. Do you?
> >> BYR2 I think (12bit Bayer in 16bit words), and Bxxx (10bit Bayer in 16bit
> >> words).
> >> 
> >> And I can test the 10bit Bayer on 16bit words on mt9m111, and will do.
> >
> > Wait, don't understand. 10-bit Bayer should have depth = 10, so it will 
> > pass. 12-bit Bayer will have depth 12 and will not pass, and I do not know 
> > how we can accept it on PXA27x.
> I should have been clearer.
> 
> It's called 8+2 bypass Bayer. Here is the layout :
>  - first byte : <B9, B8, B7, B6, B5, B4, B3, B2>
>  - second byte : <0, 0, 0, 0, 0, 0, B1, B0>
>  => 2 bytes of 8 bits are sent over 8 bits of QIF interface
>  => gives a Bayer Code of <0, 0, 0, 0, 0, 0, B9 - B0>
> 
> I think it is documented in Micron MT9M111 datasheet, table 6, page 14.
> My understanding is that it has a buswidth=8, and depth=16. But I may be wrong,
> have a look with your trained eye and tell me please.

I think we shouldn't (and possibly cannot) process this data in 
pass-through mode on pxa270. In raw mode pxa270 expects each pixel to only 
occupy one pixel clock. And we use icd->width and icd->height to configure 
PXA registers in pxa_camera_set_bus_param(). Whereas in this case we would 
have to lie to the PXA and configure it with, for example, the double 
line-width. I think, this way it could work. Then your horizontal sync 
would stay valid. So, I think, we have three options with this format:

1. Refuse to support this configuration, as PXA doesn't support 2 pixel 
clocks per pixel in raw mode

2. Extend the API even further to allow for different geometries on the 
sensor and on the controller. This, in fact, will anyway be required once 
we support scaling on host...

3. Create a special translation entry for this mode and abuse some 16-bit 
preprocessed format, like, e.g., RGB565. I _think_ this would work too, 
because, in the end, PXA doesn't know what colour it should be:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
