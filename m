Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9THH3Q5006251
	for <video4linux-list@redhat.com>; Wed, 29 Oct 2008 13:17:03 -0400
Received: from smtp6-g19.free.fr (smtp6-g19.free.fr [212.27.42.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9THH1Bn032765
	for <video4linux-list@redhat.com>; Wed, 29 Oct 2008 13:17:02 -0400
To: Antonio Ospite <ospite@studenti.unina.it>
References: <20081029123446.540dcd2e.ospite@studenti.unina.it>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Wed, 29 Oct 2008 18:16:34 +0100
In-Reply-To: <20081029123446.540dcd2e.ospite@studenti.unina.it> (Antonio
	Ospite's message of "Wed\, 29 Oct 2008 12\:34\:46 +0100")
Message-ID: <874p2vs4nh.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH, RFC] mt9m111: Fix YUYV format for pxa-camera
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

Antonio Ospite <ospite@studenti.unina.it> writes:

> Hi,
>
> I'd like to discuss this change to mt9m111, but I am not sure if the
> first hunk of the following patch is a proper fix for the problem I had:
> when using YUYV the output buffer has to be WIDTH*HEIGHT*2,
> and not WIDTH*HEIGHT as it is now using 8bit YUYV format.
> Maybe the proper fix belongs to pxa-camera.c?

No, your patch is the correct way of doing it.  Please resubmit the same patch
with your signoff, and Guennadi CCed which will give me time to make 1 test for
security, and I'll add my Acked-by.

You can safely remove the "RFC" part, it is indeed a fix.

Cheers.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
