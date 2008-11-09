Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA9BECEg005338
	for <video4linux-list@redhat.com>; Sun, 9 Nov 2008 06:14:12 -0500
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA9BDxHt021691
	for <video4linux-list@redhat.com>; Sun, 9 Nov 2008 06:13:59 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <Pine.LNX.4.64.0811081917070.8956@axis700.grange>
	<87tzahwwr1.fsf@free.fr>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sun, 09 Nov 2008 12:13:57 +0100
In-Reply-To: <87tzahwwr1.fsf@free.fr> (Robert Jarzmik's message of "Sun\,
	09 Nov 2008 01\:47\:46 +0100")
Message-ID: <87y6ztxibu.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 3/3] soc-camera: let camera host drivers decide upon
	pixel format
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


Guennadi,

I thought a bit about pixel format negociation.

The thing that came to my mind is that it is not the sensor that can tell all
the pixel formats available, it's the camera host. That means that icd->formats
should be filled in by the host, not the sensor.

What I would see is a generic call in soc_camera (or a structure), called by
each sensor to declare the pixel formats it handles. This call (or structure)
will be used by camera host driver to fill in icd->formats, deduced from what
the sensors offers, and the host possible translations.

Tell me you opinion about it please.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
