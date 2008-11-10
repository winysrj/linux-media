Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAAJFTEx015530
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 14:15:29 -0500
Received: from smtp1-g19.free.fr (smtp1-g19.free.fr [212.27.42.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAAJFGfM017510
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 14:15:16 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <Pine.LNX.4.64.0811101323490.4248@axis700.grange>
	<Pine.LNX.4.64.0811101335170.4248@axis700.grange>
	<30353c3d0811101009u195fb42du346ff3e0fb559b19@mail.gmail.com>
	<Pine.LNX.4.64.0811101942340.8315@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Mon, 10 Nov 2008 20:15:14 +0100
In-Reply-To: <Pine.LNX.4.64.0811101942340.8315@axis700.grange> (Guennadi
	Liakhovetski's message of "Mon\,
	10 Nov 2008 19\:43\:44 +0100 \(CET\)")
Message-ID: <874p2f9yv1.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com, David Ellingsworth <david@identd.dyndns.org>
Subject: Re: [PATCH 5/5] pxa-camera: framework to handle camera-native and
	synthesized formats
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

> Indeed, a good idea, thanks, only I would do this like
>
> 	return !!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8);
You're using it 2 times, and with a if (!depth_supported()), that's overkill.
Wouldn't it be better for that function to return 0 for false, and "not 0" for
true ? That's what was done for gpio API (check gpio_get_value()) ...

I would definitely drop the purely boolean part, I don't think it brings
anything here (the function name is already very clear, isn't it ? :))

JM2P.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
