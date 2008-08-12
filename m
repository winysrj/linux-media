Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7CF08fd003798
	for <video4linux-list@redhat.com>; Tue, 12 Aug 2008 11:00:08 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m7CExWux011433
	for <video4linux-list@redhat.com>; Tue, 12 Aug 2008 10:59:32 -0400
Date: Tue, 12 Aug 2008 16:59:46 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <873alnt2bh.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0808121612330.8089@axis700.grange>
References: <87hca34ra0.fsf@free.fr>
	<Pine.LNX.4.64.0808022146090.27474@axis700.grange>
	<873alnt2bh.fsf@free.fr>
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

Sorry for a late reply. Looking at your mt9m111 patch, I realised we 
didn't finish this discussion:-)

On Sun, 3 Aug 2008, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > On Sat, 2 Aug 2008, Robert Jarzmik wrote:
> >
> >> Modern camera chips provide ways to invert their data output, as well in colors
> >> swap as in byte order. To be more precise, the one I know (mt9m111) enables :
> >
> > To me these look like just different pixel formats:
> Ah, they look like, but there aren't.
> 
> Let me explain the subtle part of it by an example on mio a701 phone :
>  - mt9m111 is connected to a pxa272 cpu through an 8bit bus
>  - when I select RGB565 as a pixel format, the pxa cpu expects the bits in a
>  very precise order :
>    - have a look at PXA Developper Manual, chapter 27.4.5.2.1, table 27-10. The
>    order the bytes are comming on the bus is important, because of the
>    "interpretation" the PXA does, to reorder and store them in memory.
>    => the chip must send the bytes in that order
>    - if you pay attention closely, you'll notice the pxa doesn't expect RGB but
>    inverted BGR.
>    - have a look at Micron MT9M111 specification, table 5, page 14. You'll see
>    what they consider as RGB565.

Ok, I looked at them, I really did:-) Still, doesn't the following 
describe the situation:

mt9m111 supported formats:
rgb 565				(as specified in mt9m111 manual)
rgb 565 swapped			(ditto swapped to match pxa270)
...

pxa270 supports formats
rgb 565 swapped			(pxa manual doesn't call it swapped)
...

So, when a user enumerates supported formats, we should report rgb 565 
swapped, but not report rgb 565. If you connect a mt9m111 to another host, 
maybe the non-swapped rgb 565 will be supported. So, mt9m111 should report 
both. The problem currently is, soc-camera doesn't ask the host controller 
whether it supports a specific pixel format. It only has a chance to fail 
an attempted VIDIOC_S_FMT, which is a bit too late. So, would adding pixel 
format negotiation with the camera host driver sufficiently fix the 
problem for you? One of us could try to cook a patch then.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
