Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57272 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab0IJHTI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Sep 2010 03:19:08 -0400
Received: by wyf22 with SMTP id 22so2447525wyf.19
        for <linux-media@vger.kernel.org>; Fri, 10 Sep 2010 00:19:07 -0700 (PDT)
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	"linux-media\@vger.kernel.org" <linux-media@vger.kernel.org>,
	eduardo.valentin@nokia.com,
	ext Eino-Ville Talvala <talvala@stanford.edu>
Subject: Re: [PATCH] Illuminators and status LED controls
References: <y1el0c4vecj8x6uk04ypatvd.1284039765001@email.android.com>
	<275b6fc10404e9bda012060f49cdf2f3.squirrel@webmail.xs4all.nl>
	<1284079784.4438.192.camel@morgan.silverblock.net>
Date: Fri, 10 Sep 2010 09:19:00 +0200
In-Reply-To: <1284079784.4438.192.camel@morgan.silverblock.net> (Andy Walls's
	message of "Thu, 09 Sep 2010 20:49:44 -0400")
Message-ID: <87r5h2awwr.fsf@macbook.be.48ers.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

>>>>> "Andy" == Andy Walls <awalls@md.metrocast.net> writes:

Hi,

 Andy> Given choices I made when I patched up gspca/cpia1.c for my
 Andy> prototype LED API usage, I got these associations

 Andy> By exposed LED name:

 Andy> 	/sys/class/leds/video0:white:illuminator0

Indeed. But didn't we just decide that illuminators were an integral
part of the video handling (similar to gain control), and only use the
LED API for status LEDs that don't directly interfere with the video
data?

 Andy> The LED API has some shortcomings/annoyances:

 Andy> - The method a driver provides to set the LED brightness cannot sleep,
 Andy> so a workqueue is needed to simply turn a hardware light on and off for
 Andy> USB devices.

 Andy> - The Documentation is not very good for end-users or kernel developers
 Andy> on using the LED API. 

No? I agree that the documentation is pretty minimalistic, but ok - It's
not that complicated.

 Andy> - For an LED trigger not to override a user's desire to inhibit an LED,
 Andy> the user needs to know to cancel all the triggers on an LED before
 Andy> setting the LEDs brightness to 0.

Only a single trigger can be active at a time for a given LED.

 Andy> Again, that happens to be the only real compelling use case I see for
 Andy> using the LED API.  However, I doubt many users will try to take
 Andy> advantage of it, and I suspect even less will succeed in getting it
 Andy> configured right.  Good documentation could go a long way in correcting
 Andy> that.

That and using the LED for something else (perhaps with another trigger
like I eplained earlier with wlan/hdd activity).

 Andy> If a user configures multiple LED triggers on an LED, those triggers
 Andy> will compete with each other.  The net result is the most recent event
 Andy> from the driver, any LED triggers wins, or user manipulation of sysfs
 Andy> brightness.

Only a single trigger can be active at a time for a given LED.

 Andy> With indicators that's annoying, but not a failure.  With illuminators,
 Andy> that is a failure.

Again, I don't think we should use the LED API for something as integral
to the video signal as illuminators.

-- 
Bye, Peter Korsgaard
