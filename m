Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:49857 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaIFC2F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Sep 2014 22:28:05 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBG004NRK6RM4A0@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 05 Sep 2014 22:28:03 -0400 (EDT)
Date: Fri, 05 Sep 2014 23:27:58 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Akihiro TSUKADA <tskd08@gmail.com>, linux-media@vger.kernel.org,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: Re: [PATCH v2 4/5] tc90522: add driver for Toshiba TC90522 quad
 demodulator
Message-id: <20140905232758.36946673.m.chehab@samsung.com>
In-reply-to: <540A6B27.2010704@iki.fi>
References: <1409153356-1887-1-git-send-email-tskd08@gmail.com>
 <1409153356-1887-5-git-send-email-tskd08@gmail.com>
 <5402F91E.7000508@gentoo.org> <540323F0.90809@gmail.com>
 <54037BFE.60606@iki.fi> <5404423A.3020307@gmail.com> <540A6B27.2010704@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 06 Sep 2014 05:02:15 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> On 09/01/2014 12:54 PM, Akihiro TSUKADA wrote:
> > Hi,
> >
> >> Also, I would like to see all new drivers (demod and tuner) implemented
> >> as a standard kernel I2C drivers (or any other bus). I have converted
> >> already quite many drivers, si2168, si2157, m88ds3103, m88ts2022,
> >> it913x, tda18212, ...
> >
> > I wrote the code in the old style using dvb_attach()
> > because (I felt) it is simpler than using i2c_new_device() by
> > introducing new i2c-related data structures,
> > registering to both dvb and i2c, without any new practical
> > features that i2c client provides.
> 
> Of course it is simpler to do old style as you could copy & paste older 
> drivers and so. However, for a long term we must get rid of all DVB 
> specific hacks and use common kernel solutions. The gap between common 
> kernel solutions and DVB proprietary is already too big, without any 
> good reason - just a laziness of developers to find out proper solutions 
> as adding hacks is easier.
> 
> I mentioned quite many reasons earlier and If you look that driver you 
> will see you use dev_foo() logging, that does not even work properly 
> unless you convert driver to some kernel binding model (I2C on that 
> case) (as I explained earlier).
> 
> There is also review issues. For more people do own tricks and hacks the 
> harder code is review and also maintain as you don't never know what 
> breaks when you do small change, which due to some trick used causes 
> some other error.
> 
> Here is one example I fixed recently:
> https://patchwork.linuxtv.org/patch/25776/

Yes, using the I2C binding way provides a better decoupling than using the
legacy way. The current dvb_attach() macros are hacks that were created
by the time where the I2C standard bind didn't work with DVB.

We need to move on.

> 
> Lets mention that I am not even now fully happy to solution, even it 
> somehow now works. Proper solution is implement clock source and clock 
> client. Then register client to that source. And when client needs a 
> clock (or power) it makes call to enable clock.

Well, we need to discuss more about that, because you need to convince
me first about that ;)

We had already some discussions about that related to V4L2 I2C devices.
The consensus we've reached is that it makes sense to use the clock
framework only for the cases where the bridge driver doesn't know anything
about the clock to be used by a given device, e. g. in the case where this
data comes from the Device Tree (embedded systems).

In the case where the bridge is the ownership of the information that will
be used by a given device model (clock, serial/parallel mode, etc), then
a series of data information should be passed by a call from the bridge driver
to the device at setup time, and doing it in an atomic way is the best
way to go.

Anyway, such discussions don't belong to this thread. For the PT3 and
tc90522 to be merged, the only pending stuff to be done is to use the
I2C binding.

Akihiro-san,

Please change the driver to use the I2C model as pointed by Antti.

Thank you!
Mauro

> > But if the use of dvb_attach() is (almost) deprecated and
> > i2c client driver is the standard/prefered way,
> > I'll convert my code.
> 
> regards
> Antti
> 
