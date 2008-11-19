Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAJMcihM017165
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 17:38:44 -0500
Received: from smtp6-g19.free.fr (smtp6-g19.free.fr [212.27.42.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAJMcWqX029774
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 17:38:32 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <Pine.LNX.4.64.0811181945410.8628@axis700.grange>
	<Pine.LNX.4.64.0811182006230.8628@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Wed, 19 Nov 2008 21:47:28 +0100
In-Reply-To: <Pine.LNX.4.64.0811182006230.8628@axis700.grange> (Guennadi
	Liakhovetski's message of "Tue\,
	18 Nov 2008 20\:25\:48 +0100 \(CET\)")
Message-ID: <873ahn8mu7.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Allocate and fill a list of formats, supported by this specific 
> camera-host combination. Use it for format enumeration. Take care to stay 
> backwards-compatible.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

So, the translation api is dead, long live user_format :)

I'm a bit disappointed, as the things I pointed out are missing :
 - host format and sensor format association for debug purpose
   (think about sensor developpers)
 - current format : we never know what will be done through the host by its
 pointer (I'm not thinking about end user, I'm still thinking about soc_camera
 point of view).

But anyway, that's life. My review of patch 2 will follow, this one looks fine
(though not tested yet).

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
