Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1FIgkqu012410
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 13:42:46 -0500
Received: from mail4.sea5.speakeasy.net (mail4.sea5.speakeasy.net
	[69.17.117.6])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1FIgFeR029001
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 13:42:15 -0500
Date: Fri, 15 Feb 2008 10:42:10 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
In-Reply-To: <Pine.LNX.4.64.0802151511540.16741@axis700.grange>
Message-ID: <Pine.LNX.4.58.0802151036020.31468@shell4.speakeasy.net>
References: <Pine.LNX.4.64.0802151511540.16741@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: David Brownell <david-b@pacbell.net>,
	Linux and Kernel Video <video4linux-list@redhat.com>,
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

On Fri, 15 Feb 2008, Guennadi Liakhovetski wrote:
> Upon suggestion by David Brownell use a gpio_is_valid() predicate
> instead of an explicit NO_GPIO macro. The respective patch to
> include/asm-generic/gpio.h has been accepted upstream.
>
>  #else
> -	mt9m001->switch_gpio = NO_GPIO;
> +	mt9m001->switch_gpio = -EINVAL;
>  #endif

Is that part right?  I thought there would still be a NO_GPIO value for
when you wanted to set or return an invalid gpio number.  gpio_is_valid()
is a predicate so it doesn't help you create a gpio number that isn't valid
(other than something absurd like testing all unsigned ints for one that
fails), one still needs NO_GPIO or something like it.  Using NO_GPIO seems
like a better idea that hoping that -EINVAL happens to be invalid on every
platform.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
