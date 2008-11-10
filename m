Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAAJ6lfr011038
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 14:06:47 -0500
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAAJ6aaN012918
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 14:06:37 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <20081107125919.ddf028a6.ospite@studenti.unina.it>
	<874p2jbegl.fsf@free.fr>
	<Pine.LNX.4.64.0811082119280.8956@axis700.grange>
	<20081109235940.4c009a68.ospite@studenti.unina.it>
	<Pine.LNX.4.64.0811101946200.8315@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Mon, 10 Nov 2008 20:06:34 +0100
In-Reply-To: <Pine.LNX.4.64.0811101946200.8315@axis700.grange> (Guennadi
	Liakhovetski's message of "Mon\,
	10 Nov 2008 19\:55\:53 +0100 \(CET\)")
Message-ID: <878wrr9z9h.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH,
	RFC] mt9m111: allow data to be received on pixelclock falling edge?
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

> I would prefer not to disregard camera flags. If we don't find a better 
> solution, I would introduce platform inverter flags, and, I think, we 
> better put them in camera platform data - not host platform data, to 
> provide a finer granularity. In the end, inverters can also be located on 
> camera boards, then you plug-in a different camera and, if your 
> inverter-flags were in host platform data, it doesn't work again.
I'm of the same opinion.

I was thinking of another case : imagine the host needs to be configured on
rising edge, and camera on falling edge. Your patch wouldn't cover that devious
case.

I can't think of a better solution than an inverter flag as well. As this would
be very board specific, let it go in something board code sets up.

That's how it's already done for inverted gpio Vbus sensing in the USB stack for
the pxa for example.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
