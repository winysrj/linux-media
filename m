Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:49939 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbZDXAnV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2009 20:43:21 -0400
Subject: Re: [PATCH] FM1216ME_MK3 some changes
From: Andy Walls <awalls@radix.net>
To: Dmitri Belimov <d.belimov@gmail.com>
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <20090423203618.4ac2bc6f@glory.loctelecom.ru>
References: <20090422174848.1be88f61@glory.loctelecom.ru>
	 <1240452534.3232.70.camel@palomino.walls.org>
	 <20090423203618.4ac2bc6f@glory.loctelecom.ru>
Content-Type: text/plain
Date: Thu, 23 Apr 2009 21:43:14 -0400
Message-Id: <1240537394.3231.37.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dmitri,

Thank you for you responses.

Just a few more comments...

On Thu, 2009-04-23 at 20:36 +1000, Dmitri Belimov wrote:
> Hi Andy
> 
> > Dmitri,
> > 
> > 
> > On Wed, 2009-04-22 at 17:48 +1000, Dmitri Belimov wrote:
> > > Hi All
> > > 
> > > 1. Change middle band. In the end of the middle band the
> > > sensitivity of receiver not good. If we switch to higher band,
> > > sensitivity more better. Hardware trick.
> > 

> Several years a go your customers write some messages about bad quality of TV
> if frequency of TV is the end of band. It can be low band or middle. Our
> hardware engeneer make some tests with hardware TV generator and our TV tuners.
> 
> If we set default frequency range for low and middle band, quality of TV signal 
> on 159MHz and 442 MHz is bad. When we make our changes with moving end of bands
> the quality of TV much better. And our system programmer for OS Windows use changed
> bands for drivers. Customers be happy.

OK.  A properly run experiment wins over theory every time. :)



> You can test it if in your placement available TV programm on 159MHz or 442MHz. This trick
> can be usefull for other tuners.

If you look at tveeprom.c, a number of other tuners are using that tuner
definition:

$ grep FM1216ME_MK3 tveeprom.c
	{ TUNER_PHILIPS_FM1216ME_MK3, 	"Philips FQ1216ME MK3"},
	{ TUNER_PHILIPS_FM1216ME_MK3, 	"Philips FM1216 ME MK3"},
	{ TUNER_PHILIPS_FM1216ME_MK3, 	"LG S001D MK3"},
	{ TUNER_PHILIPS_FM1216ME_MK3, 	"LG S701D MK3"},
	{ TUNER_PHILIPS_FM1216ME_MK3, 	"Philips FQ1216LME MK3"},
	{ TUNER_PHILIPS_FM1216ME_MK3, 	"TCL MFPE05 2"},
	{ TUNER_PHILIPS_FM1216ME_MK3, 	"TCL MPE05-2"},
	{ TUNER_PHILIPS_FM1216ME_MK3, 	"Philips FM1216ME MK5"},

If your change makes things bad for the other tuners, we'll probably
have to create an alternate entry for the other tuners instead of using
the FM1216ME_MK3 defintion.  I suspect most of them are clones of the
FM1216ME MK3 however, so it probably won't matter.

> > > 3. Set charge pump bit
> > 
> > This will improve the time to initially tune to a frequency, but will
> > likely add some noise as the PLL continues to maintain lock on the
> > signal.  If there is no way to turn off the CP after the lock bit is
> > set in the tuner, it's probably better to leave it off for lower
> > noise and just live with slower tuning.
> 
> We discuss with our windows system programmer about it. He sad that
> in analog TV mode noise from PLL don't give any problem.

I would be concerned about phase noise affecting the colors or any FM
sound carriers.  If the noise isn't noticably affecting colors to the
human eye (do color bars look OK?), or sound to the human ear, then OK.


>  But in digital TV mode
> noise from PLL decreased BER.

I thought the FM1216ME MK3 was an analog only tuner.  I guess I don't
know DVB-T or cable in Europe well enough.


> > Leaving the CP bit set should be especially noticable ad FM noise when
> > set to tune to FM radio stations.  From the FM1236ME_MK3 datasheet:
> > "It is recommended to set CP=0 in the FM mode at all times."
> > But the VHF low band control byte is also used when setting FM radio
> > (AFAICT with a quick look at the code.)
> 
> Yes. You are right. We can swith CP off in FM mode.

OK.  Thank you.

> With my best regards, Dmitry.


Regards,
Andy



