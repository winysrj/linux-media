Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nA4JvvfF020518
	for <video4linux-list@redhat.com>; Wed, 4 Nov 2009 14:57:57 -0500
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nA4Jvetg021653
	for <video4linux-list@redhat.com>; Wed, 4 Nov 2009 14:57:45 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <3d7d5c150911021621g72461dao1e66a654b574af5f@mail.gmail.com>
	<Pine.LNX.4.64.0911032250060.5059@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Wed, 04 Nov 2009 20:57:33 +0100
In-Reply-To: <Pine.LNX.4.64.0911032250060.5059@axis700.grange> (Guennadi
	Liakhovetski's message of "Tue\,
	3 Nov 2009 23\:02\:04 +0100 \(CET\)")
Message-ID: <877hu6m5aq.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> I came across the same problem when working on the rj54n1cb0c driver. 
> What's even more exciting with that sensor, is that it has separate 
> frame-size settings for preview (video) and still capture.

It seems this behaviour is generic across several sensors. As far as I know, the
mt9m111 has 2 modes : low power low resolution, and high power high resolution,
and both are programmable apart (in terms of resolution, zoom, etc ...)

What this makes me think is that a sensor could provide several "contexts" of
use, as :
 - full resolution still image context
 - low resolution still image context
 - full resolution video context
 - low resolution video context

Then, a new/existing v4l2 call would switch the context (perhaps based on buffer
type ?) of the sensor.

Well, that's just some junk I've been thinking over lately.

Cheers.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
