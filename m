Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com
	[10.5.110.13])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nA5KbmHO018764
	for <video4linux-list@redhat.com>; Thu, 5 Nov 2009 15:37:48 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id nA5KbkFJ011637
	for <video4linux-list@redhat.com>; Thu, 5 Nov 2009 15:37:47 -0500
Date: Thu, 5 Nov 2009 21:37:46 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <877hu6m5aq.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0911052104430.5620@axis700.grange>
References: <3d7d5c150911021621g72461dao1e66a654b574af5f@mail.gmail.com>
	<Pine.LNX.4.64.0911032250060.5059@axis700.grange>
	<877hu6m5aq.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: Capturing video and still images using one driver
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

On Wed, 4 Nov 2009, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > I came across the same problem when working on the rj54n1cb0c driver. 
> > What's even more exciting with that sensor, is that it has separate 
> > frame-size settings for preview (video) and still capture.
> 
> It seems this behaviour is generic across several sensors. As far as I know, the
> mt9m111 has 2 modes : low power low resolution, and high power high resolution,
> and both are programmable apart (in terms of resolution, zoom, etc ...)
> 
> What this makes me think is that a sensor could provide several "contexts" of
> use, as :
>  - full resolution still image context
>  - low resolution still image context
>  - full resolution video context
>  - low resolution video context

Why fixed resolutions? Just make it possible to issue S_FMT for video or 
for still imaging... That would work seamlessly with several inputs 
(S_INPUT, S_FMT...).

> Then, a new/existing v4l2 call would switch the context (perhaps based on buffer
> type ?) of the sensor.

...on a second thought, it doesn't seem that smart to me any more to tie 
the streaming vs. still mode distinction to a specific buffer type...

> Well, that's just some junk I've been thinking over lately.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
