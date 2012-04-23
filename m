Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60560 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344Ab2DWVEu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 17:04:50 -0400
Message-ID: <4F95C3ED.8060209@iki.fi>
Date: Tue, 24 Apr 2012 00:04:45 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
CC: "nibble.max" <nibble.max@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/6] m88ds3103, montage dvb-s/s2 demodulator driver
References: <1327228731.2540.3.camel@tvbox> <4F2185A1.2000402@redhat.com> <201204152353103757288@gmail.com> <201204201601166255937@gmail.com> <4F9130BB.8060107@iki.fi> <201204211045557968605@gmail.com> <4F958640.9010404@iki.fi> <CAF0Ff2nNP6WRUWcs7PqVRxhXHCmUFqqswL4757WijFaKT5P5-w@mail.gmail.com>
In-Reply-To: <CAF0Ff2nNP6WRUWcs7PqVRxhXHCmUFqqswL4757WijFaKT5P5-w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Konstantin,

Good to heard you and finally got your reply to thread.

On 23.04.2012 22:51, Konstantin Dimitrov wrote:
> Antti, i already commented about ds3103 drivers months ago:
>
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg41135.html
>
> and from my point of view nothing have changed - ds3103 chip is almost
> the same as ds3000 and the driver i made for ds3000 from scratch is
> what was used ds3103 drivers to be created. so, what you actually is
> suggesting - my driver to be removed from the kernel and driver that
> was made based on my hard work to be included and that driver author
> even refuses to acknowledge my work?!  such practices are really good
> for the open-source community, don't you think? also, we already have
> one case for example, where to satisfy someone's interests two drivers
> for the same demodulators (STV090x family of chips) were accepted in
> the kernel - i doubt anyone actually can tell why there are 2 drivers
> for STV090x in the kernel and instead the community to support the
> driver for STV090x that was made with more open-source ideas in mind,
> i.e. the one that can work with any STV090x design and which relies
> less on code copyrighted by ST - anyway, those details about STV090x
> drivers are off-topic here, but i'm still giving them as example,
> because the fact is that already once such mess was created having
> multiple drivers for the same generation of chips in the kernel and
> apparently those practices will continue if someone don't raise those
> questions out loud.
>
> also, why Montage tuner code should be spitted from the demodulator
> code? is there any evidence that any Montage tuner (ts2020 or ts2022)
> can work with 3rd party demodulator different than ds3000 or ds3103?

I don't know what is situation of these Montage chips and what are 
possible combinations. *But* there is many existing cases from the DVB-T 
I am aware. Things are done wrongly and all is implemented as a one big 
blob. After that new device is arrived and we cannot support it since 
existing drivers are not split. And it is not single case...

It may happen or it may not happen. You never known. But still it is 
nice to split drivers correctly to avoid such problems that could be 
possible in some day. And I don't even know how much those tuners and 
demods differs - I only saw that patch and it looked there was some 
differences, even so much that two tuner drivers could be good choice.

> are there such designs in real-life, e.g. either Montage demodulator
> with 3rd party tuner or actually more importantly for what you're
> suggesting Montage tuner (ts2020 or ts2022) with third party
> demodulator? it's more or less the same case as with cx24116 (and
> tda10071) demodulator, where the tuner (cx24118a) is controlled by the
> firmware and thus it's solely part of the demodulator driver, even
> that it's possible to control the cx24118a tuner that is used with
> cx24116 (and tda10071) designs directly bypassing the firmware. so,
> why we don't change in that way the cx24116 (and tda10071) drivers
> too?

CX24116 and TDA10071 (I made TDA10071) are somehow different as tuner is 
driven by demodulator firmware. There is no tuner that needs to be 
driven by driver at least for now. There is also some DVB-T devices that 
has demod and tuner which are both controlled by USB -interface firmware 
and thus no chipset driver needed - only some stuff that implements 
frontend. But for the Montage demod/tuner there is clearly both chips 
driven by the driver.

> i just don't see what's the motivation behind what you're suggesting,
> because ds3103 is almost the same as ds3000 from driver point of view
> and one driver code can be used for both and Montage tuners in
> question can work only with those demodulators (or at least are used
> in practice only with them). so, if there are any evidences that's not
> true then OK let's split them, but if not then what's the point of
> that?

I want to split those correctly as it looked splitting could clear 
driver. Also what I suspect those problems Max had were coming from the 
fact it was not split and it makes driver complex when Max added new 
tuner and demod versions.

And my opinion is still it should be split and as a original driver 
author you are correct person to split it :) But you did not replied so 
I proposed Max should do it in order to go ahead.

And I apologize I proposed removing your driver, I know having own 
driver is something like own baby. But also having own baby it means you 
should care it also.

And what goes the original conflict you linked I am not going to 
comment. I still hope you can say what should be done and review the 
code in order to get support that new demod/tuner combo.

I just want things to done correctly. One driver per one entity. Just 
keep it simple and clean to extend later.

So let it be short, is my interpretation correct if I say you want all 
these 4 chips (ds3000/ds3103/ts2020/ts2022) to be driven by single driver?

regards
Antti
-- 
http://palosaari.fi/
