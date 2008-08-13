Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7D9AjP7001792
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 05:10:45 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m7D9AXR0031881
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 05:10:34 -0400
Date: Wed, 13 Aug 2008 11:10:42 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <1218616667.48a29d5bcb7ea@imp.free.fr>
Message-ID: <Pine.LNX.4.64.0808131105020.3884@axis700.grange>
References: <87hca34ra0.fsf@free.fr>
	<Pine.LNX.4.64.0808022146090.27474@axis700.grange>
	<873alnt2bh.fsf@free.fr>
	<Pine.LNX.4.64.0808121612330.8089@axis700.grange>
	<1218616667.48a29d5bcb7ea@imp.free.fr>
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

On Wed, 13 Aug 2008, robert.jarzmik@free.fr wrote:

> Selon Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> 
> > So, when a user enumerates supported formats, we should report rgb 565
> > swapped, but not report rgb 565. If you connect a mt9m111 to another host,
> > maybe the non-swapped rgb 565 will be supported. So, mt9m111 should report
> > both. The problem currently is, soc-camera doesn't ask the host controller
> > whether it supports a specific pixel format. It only has a chance to fail
> > an attempted VIDIOC_S_FMT, which is a bit too late. So, would adding pixel
> > format negotiation with the camera host driver sufficiently fix the
> > problem for you? One of us could try to cook a patch then.
> 
> Yes, pixel format negotiation is the key, that's the clean solution.
> It will have impacts on existing camera drivers, like mt9m001, ..., and camera
> hosts, but you must already be aware of it and ready to pay the price :)

Yes, fortunately, there are not too many yet:-)

> Now, let's talk schedule. Until the end of the week, I'll be a bit busy. If I
> don't see a patch you submitted by then, I'll cook one up. I only need to know
> at which point you wish the format negociation should be performed, and on which
> ground.

Hm, I would just do this during format-enumeration... I'll try to sketch 
something maybe today.

> [RFC]
> Would that be something like :
>  - all begins which the binding of both a camera driver and host driver
>  - soc_camera asks host controller which format it provides
>  - soc_camera asks camera driver which format it supports
>  - soc_camera make a table of possible pixel formats (which would be the common
> subset of host and camera pixel formats)
>  - soc_camera uses that table for format enumeration
>  - soc_camera uses that table for preliminary check on VIDIOC_S_FMT

I think, we might manage to get it a bit simpler.

As for your mt9m111 patch - unfortunately, during my first quick review I 
missed a few more minor formatting issues, so, because it is kinda my 
fault, my plan is to apply your patch as it is, and then I can just post 
for your ack a clean-up patch. And then, as we get format negotiation in 
place, you can extend it with further supported formats. What do you 
think?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
