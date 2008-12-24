Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBOHb6xG021962
	for <video4linux-list@redhat.com>; Wed, 24 Dec 2008 12:37:07 -0500
Received: from smtp5-g19.free.fr (smtp5-g19.free.fr [212.27.42.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBOHaqcc003990
	for <video4linux-list@redhat.com>; Wed, 24 Dec 2008 12:36:52 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <1228166159-18164-1-git-send-email-robert.jarzmik@free.fr>
	<87iqpi4qb0.fsf@free.fr>
	<Pine.LNX.4.64.0812171921420.8733@axis700.grange>
	<Pine.LNX.4.64.0812200104090.9649@axis700.grange>
	<87wsdplc29.fsf@free.fr>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Wed, 24 Dec 2008 18:36:51 +0100
In-Reply-To: <87wsdplc29.fsf@free.fr> (Robert Jarzmik's message of "Wed\,
	24 Dec 2008 18\:26\:06 +0100")
Message-ID: <87r63xlbkc.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: soc-camera: current stack
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

Robert Jarzmik <robert.jarzmik@free.fr> writes:

> I made some tests of your patches against mainline tree (2.6.28-rc4 actually),
> on pxa271 + mt9m111.
>
> I'm not sure whether the problem is not on my setup, I hadn't touched it for
> days. I know after opening the video device, I setup a camera register before
> taking the picture (to set up the test pattern and automate my non-regression
> tests).

OK, I found. Was on my side, my kernel and my modules were not in sync (the
CONFIG_VIDEO_ADV_DEBUG was in modules, not in kernel).

So you should know the whole serie is working fine on my setup :)))

Cheers.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
