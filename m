Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:13673 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaIFDLg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Sep 2014 23:11:36 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBG003AJM7BHJ70@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 05 Sep 2014 23:11:35 -0400 (EDT)
Date: Sat, 06 Sep 2014 00:11:30 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Akihiro TSUKADA <tskd08@gmail.com>, linux-media@vger.kernel.org,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: Re: DVB clock source (Re: [PATCH v2 4/5] tc90522: add driver for
 Toshiba TC90522 quad demodulator)
Message-id: <20140906001130.4802b1c3.m.chehab@samsung.com>
In-reply-to: <540A78CC.9030703@iki.fi>
References: <1409153356-1887-1-git-send-email-tskd08@gmail.com>
 <1409153356-1887-5-git-send-email-tskd08@gmail.com>
 <5402F91E.7000508@gentoo.org> <540323F0.90809@gmail.com>
 <54037BFE.60606@iki.fi> <5404423A.3020307@gmail.com> <540A6B27.2010704@iki.fi>
 <20140905232758.36946673.m.chehab@samsung.com> <540A78CC.9030703@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 06 Sep 2014 06:00:28 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> On 09/06/2014 05:27 AM, Mauro Carvalho Chehab wrote:
> > Em Sat, 06 Sep 2014 05:02:15 +0300
> > Antti Palosaari <crope@iki.fi> escreveu:
> 
> >> Lets mention that I am not even now fully happy to solution, even it
> >> somehow now works. Proper solution is implement clock source and clock
> >> client. Then register client to that source. And when client needs a
> >> clock (or power) it makes call to enable clock.
> >
> > Well, we need to discuss more about that, because you need to convince
> > me first about that ;)
> >
> > We had already some discussions about that related to V4L2 I2C devices.
> > The consensus we've reached is that it makes sense to use the clock
> > framework only for the cases where the bridge driver doesn't know anything
> > about the clock to be used by a given device, e. g. in the case where this
> > data comes from the Device Tree (embedded systems).
> >
> > In the case where the bridge is the ownership of the information that will
> > be used by a given device model (clock, serial/parallel mode, etc), then
> > a series of data information should be passed by a call from the bridge driver
> > to the device at setup time, and doing it in an atomic way is the best
> > way to go.
> 
> For AF9033/IT9133 demod + tuner I resolved it like that:
> https://patchwork.linuxtv.org/patch/25772/
> https://patchwork.linuxtv.org/patch/25774/
> 
> It is demod which provides clock for tuner. It is very common situation 
> nowadays, one or more clocks are shared. And clock sharing is routed via 
> chips so that there is clock gates you have enable/disable for power 
> management reasons.
> 
> Currently we just enable clocks always. Clock output is put on when 
> driver is attached and it is never disabled after that, leaving power 
> management partly broken.
> 
> Lets take a example, dual tuner case:
> tuner#0 gets clock from Xtal
> tuner#1 gets clock from #tuner0
> 
> All possible use cases are:
> 1) #tuner0 off & #tuner1 off
> 2) #tuner0 on & #tuner1 off
> 3) #tuner1 off & #tuner1 on
> 4) #tuner1 on & #tuner1 on
> 
> you will need, as per aforementioned use case:
> 1) #tuner0 clock out off & #tuner1 clock out off
> 2) #tuner0 clock out off & #tuner1 clock out off
> 3) #tuner0 clock out on & #tuner1 clock out off
> 4) #tuner0 clock out on & #tuner1 clock out off
> 
> Implementing that currently is simply impossible. But if you use clock 
> framework (or what ever its name is) I think it is possible to implement 
> that properly. When tuner#1 driver needs a clock, it calls "get clock" 
> and that call is routed to #tuner0 which enables clock.
> 
> And that was not even the most complicated case, as many times clock is 
> routed to demod and USB bridge too.
> 
> Quite same situation is for power on/off gpios (which should likely 
> implemented as a regulator). Also there is many times reset gpio (for PM 
> chip is powered off by switching power totally off *or* chip is put to 
> reset using GPIO)

Ok, in the above scenario, I agree that using the clock framework
makes sense, but, on devices where the clock is independent
(e. g. each chip has its on XTAL), I'm yet to see a scenario where
using the clock framework will simplify the code or bring some extra
benefit.

Regards,
Mauro
