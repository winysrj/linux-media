Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6EH9fVu002642
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 13:09:41 -0400
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.186])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6EH8W9W032428
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 13:08:42 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1529853nfc.21
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 10:08:32 -0700 (PDT)
Date: Mon, 14 Jul 2008 19:08:44 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: David Brownell <david-b@pacbell.net>
Message-ID: <20080714170844.GA622@ska.dandreoli.com>
References: <200807101914.10174.mb@bu3sch.de> <200807141558.29582.mb@bu3sch.de>
	<20080714152550.GA32470@ska.dandreoli.com>
	<200807140926.28592.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807140926.28592.david-b@pacbell.net>
Cc: video4linux-list@redhat.com, Michael Buesch <mb@bu3sch.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v3] Add bt8xxgpio driver
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

On Mon, Jul 14, 2008 at 09:26:28AM -0700, David Brownell wrote:
> > gpiolib does not allow holes in the number space of gpios. once you
> > set chip.ngpio, you get a contiguous slice.
> 
> Right ... the hardware has N gpios, that's what a gpio_chip packages.
>  
> > should the board have some of its gpio connected to something private,
> > they are not to be exported to gpiolib and to the user.
> 
> If some of those are connected to something "private", the driver
> that's using them should just request those GPIOs.  That will keep
> them from being requested by anything else.  Don't try to create a
> second mechanism duplicating the request/free allocation scheme.

hmm.. I had completely missed the point of your previous message. so
there is no space for hybrids like mine, gpiolib is an all-or-nothing
solution.

why a tvcard driver should use generic gpio to wrap its own registers
which already knows very well? it does not make sense to me. as I
intended it, to export available gpios (= not used for its inner
workings) to a generic layer, it really gives me some advantages.
i.e. I could user sysfs to immediately test things.

I am not criticizing the gpiolib design, it's only different from what
I initially imagined and does not completely fit my needs. probably I
should give up with gpiolib and use V4L2's controls, surely losing any
IRQ ability.

all I want from the tvcard's driver is "here is the video device, the dvb
device, the xyz device and there are also some GPIOs for your pleasure".
this does not sound like "there are 8 GPIOs but you can't use 3, 4 and
5". as a user, I do no care of GPIOs I cannot use.

I do not see gpiolib fit this at all without any glue.

thanks,
Domenico

-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
