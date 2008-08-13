Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7D8cCx8015232
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 04:38:12 -0400
Received: from wmproxy1-g27.free.fr (wmproxy1-g27.free.fr [212.27.42.91])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7D8c1ao014509
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 04:38:01 -0400
Message-ID: <1218616667.48a29d5bcb7ea@imp.free.fr>
Date: Wed, 13 Aug 2008 10:37:47 +0200
From: robert.jarzmik@free.fr
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <87hca34ra0.fsf@free.fr>
	<Pine.LNX.4.64.0808022146090.27474@axis700.grange>
	<873alnt2bh.fsf@free.fr>
	<Pine.LNX.4.64.0808121612330.8089@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0808121612330.8089@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
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

Selon Guennadi Liakhovetski <g.liakhovetski@gmx.de>:

> Sorry for a late reply. Looking at your mt9m111 patch, I realised we
> didn't finish this discussion:-)
No problem.

> Ok, I looked at them, I really did:-) Still, doesn't the following
> describe the situation:
>
> mt9m111 supported formats:
> rgb 565				(as specified in mt9m111 manual)
> rgb 565 swapped			(ditto swapped to match pxa270)
> ...
>
> pxa270 supports formats
> rgb 565 swapped			(pxa manual doesn't call it swapped)
> ...
Yes, that's exactly my point of view.

> So, when a user enumerates supported formats, we should report rgb 565
> swapped, but not report rgb 565. If you connect a mt9m111 to another host,
> maybe the non-swapped rgb 565 will be supported. So, mt9m111 should report
> both. The problem currently is, soc-camera doesn't ask the host controller
> whether it supports a specific pixel format. It only has a chance to fail
> an attempted VIDIOC_S_FMT, which is a bit too late. So, would adding pixel
> format negotiation with the camera host driver sufficiently fix the
> problem for you? One of us could try to cook a patch then.

Yes, pixel format negotiation is the key, that's the clean solution.
It will have impacts on existing camera drivers, like mt9m001, ..., and camera
hosts, but you must already be aware of it and ready to pay the price :)

Now, let's talk schedule. Until the end of the week, I'll be a bit busy. If I
don't see a patch you submitted by then, I'll cook one up. I only need to know
at which point you wish the format negociation should be performed, and on which
ground.

[RFC]
Would that be something like :
 - all begins which the binding of both a camera driver and host driver
 - soc_camera asks host controller which format it provides
 - soc_camera asks camera driver which format it supports
 - soc_camera make a table of possible pixel formats (which would be the common
subset of host and camera pixel formats)
 - soc_camera uses that table for format enumeration
 - soc_camera uses that table for preliminary check on VIDIOC_S_FMT

--
Robert

PS: I use an awfull web based mailer this morning, which I never use. Sorry if
it messes up linebreaks ...

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
