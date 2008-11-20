Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAKJsU5u019854
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 14:54:30 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mAKJrPNe022800
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 14:53:25 -0500
Date: Thu, 20 Nov 2008 20:53:40 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <873ahn8mu7.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0811202041520.8290@axis700.grange>
References: <Pine.LNX.4.64.0811181945410.8628@axis700.grange>
	<Pine.LNX.4.64.0811182006230.8628@axis700.grange>
	<873ahn8mu7.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 1/2 v3] soc-camera: pixel format negotiation - core
 support
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

On Wed, 19 Nov 2008, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > Allocate and fill a list of formats, supported by this specific 
> > camera-host combination. Use it for format enumeration. Take care to stay 
> > backwards-compatible.
> >
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> So, the translation api is dead, long live user_format :)
> 
> I'm a bit disappointed, as the things I pointed out are missing :
>  - host format and sensor format association for debug purpose
>    (think about sensor developpers)

Yes, it is missing, and I explained why I wasn't so keen on adding two new 
structs to a central module and a bunch of code only for debugging, which 
you only need while developing new camera host drivers. And as I 
implemented in pxa-camera, this debugging can easily be done in host 
drivers as required.

>  - current format : we never know what will be done through the host by its
>  pointer (I'm not thinking about end user, I'm still thinking about soc_camera
>  point of view).

Sorry, I do not quite understand your concern here. Are you unhappy, that 
host drivers ae now expected to assign the current_fmt pointer? But this 
has also been the case with your patch-series. Please, elaborate.

> But anyway, that's life. My review of patch 2 will follow, this one looks fine
> (though not tested yet).

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
