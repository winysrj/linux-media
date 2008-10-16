Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9G6agYc001410
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 02:36:44 -0400
Received: from smtp2-g19.free.fr (smtp2-g19.free.fr [212.27.42.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9G6ZL2T027219
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 02:35:21 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <uskqyqg58.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0810160041250.8535@axis700.grange>
	<aec7e5c30810151921v53ab947aq8e1dd6c6ee834eaa@mail.gmail.com>
	<Pine.LNX.4.64.0810160814190.3892@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Thu, 16 Oct 2008 08:35:19 +0200
In-Reply-To: <Pine.LNX.4.64.0810160814190.3892@axis700.grange> (Guennadi
	Liakhovetski's message of "Thu\,
	16 Oct 2008 08\:24\:40 +0200 \(CEST\)")
Message-ID: <8763ntf3o8.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: V4L <video4linux-list@redhat.com>
Subject: Re: [PATCH] Add ov772x driver
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

> Hm, so, to test your camera you have to modify your source and rebuild 
> your kernel... And same again to switch back to normal operation. Does not 
> sound very convenient to me. OTOH, making it a module parameter makes it 
> much easier. In fact, maybe it would be a good idea to add a new 
> camera-class control for this mode. Yet another possibility is to enable 
> debug register-access in the driver and use that to manually set the test 
> mode from user-space. A new v4l-control seems best to me, not sure what 
> others will say about this. As you probably know, many other cameras also 
> have this "test pattern" mode, some even several of them. So, this becomes 
> a control with a parameter then.

Personnaly I'm rather inclined for the debug registers solutions.

When developping a camera driver, the test pattern alone is not enough. You have
to tweak the registers, see if the specification is correct, then understand the
specification, and then change your driver code. My experience tells me you
never understand correctly are camera setup from the first time.

So IMHO the registers are enough here.

> Then a new control or raw register access would be a better way, I think.
So do I.

Cheers.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
