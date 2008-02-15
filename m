Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1FKEFus007437
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 15:14:15 -0500
Received: from mail2.sea5.speakeasy.net (mail2.sea5.speakeasy.net
	[69.17.117.4])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1FKDiLx020643
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 15:13:45 -0500
Date: Fri, 15 Feb 2008 12:13:38 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: David Brownell <david-b@pacbell.net>
In-Reply-To: <200802151102.51947.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.58.0802151211280.31468@shell4.speakeasy.net>
References: <Pine.LNX.4.64.0802151511540.16741@axis700.grange>
	<Pine.LNX.4.58.0802151036020.31468@shell4.speakeasy.net>
	<200802151102.51947.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH soc-camera] Replace NO_GPIO with gpio_is_valid()
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

On Fri, 15 Feb 2008, David Brownell wrote:
> On Friday 15 February 2008, Trent Piepho wrote:
> > 	that hoping that -EINVAL happens to be invalid on every
> > platform.
>
> Negative numbers have always been guaranteed to be invalid GPIO numbers.
> That's been part of the interface spec from day one.

Ahh, and so it has been:
	GPIOs are identified by unsigned integers in the range 0..MAX_INT.
	That reserves "negative" numbers for other purposes like marking
	signals as "not available on this board", or indicating faults.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
