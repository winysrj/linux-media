Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47175 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758940Ab2D0TBX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 15:01:23 -0400
Received: by eekc41 with SMTP id c41so285101eek.19
        for <linux-media@vger.kernel.org>; Fri, 27 Apr 2012 12:01:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F95CE59.1020005@redhat.com>
References: <1327228731.2540.3.camel@tvbox>
	<4F2185A1.2000402@redhat.com>
	<201204152353103757288@gmail.com>
	<201204201601166255937@gmail.com>
	<4F9130BB.8060107@iki.fi>
	<201204211045557968605@gmail.com>
	<4F958640.9010404@iki.fi>
	<CAF0Ff2nNP6WRUWcs7PqVRxhXHCmUFqqswL4757WijFaKT5P5-w@mail.gmail.com>
	<4F95CE59.1020005@redhat.com>
Date: Fri, 27 Apr 2012 22:01:22 +0300
Message-ID: <CAF0Ff2m_6fM1QV+Jic7viHXQ7edTe8ZwigjjhdtFwMfhCszuKQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] m88ds3103, montage dvb-s/s2 demodulator driver
From: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>,
	"nibble.max" <nibble.max@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro, your reasoning makes sense to me. so, let's split them and at
least settle this part of the discussion - i will do as far as my
spare time allows, as well make sure there are no some problems
introduced after the split.

also, in one email i've just sent in answer to Antti there is enough
argument why such split, i.e. tuner-pass-through-mode is subject to
discussion about CX24116 and TDA10071 drivers too. currently, majority
of DVB-S2 demodulator drivers in the kernel are married to particular
tuners and there is no split.

On Tue, Apr 24, 2012 at 12:49 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 23-04-2012 19:51, Konstantin Dimitrov escreveu:
>> Antti, i already commented about ds3103 drivers months ago:
>
>> also, why Montage tuner code should be spitted from the demodulator
>> code? is there any evidence that any Montage tuner (ts2020 or ts2022)
>> can work with 3rd party demodulator different than ds3000 or ds3103?
>
> This has nothing to do with Montage devices, but with the way we write
> those drivers in Kernel.
>
> There are _several_ examples where the driver for a single silicon were
> turned into more than one driver. The biggest examples are the SoC chips,
> that are transformed into a large series of drivers.
>
> Another example is the cx88 driver: due to technical reasons, it was splitted
> into 4 drivers, one for each different PCI ID exported by it.
>
> The cx2341x driver is also an interesting example: while it used to be for a
> separate chip, the cx2341x functions are now part of IP blocks on newer
> Conexant chipsets. Those single chips require two drivers to work (cx2341x
> and the associated media PCI bridge driver).
>
> Looking into tuners, there are the tda18271 family of devices, with are
> supported by several drivers: tda827x, tda8290 and tda18271-fe, depending
> on how the actual device is mounted. Eventually, the actual tuner may
> also have a tda9887 inside it.
>
> So, there's nothing wrong on splitting it on separate drivers. In a matter of
> fact, we strongly prefer to have tuners separate from demods. Having them
> together can only be justified technically, if there are really strong reasons
> why they should be at the same driver.
>
> I probably missed this at my review for ds3000 (that's why it ended by being
> merged), but, on the review I did on it (accidentally due to m88ds3103 patchset
> review), it is clear that the tuner has actually a different I2C address (0x60)
> than the demod, and it is indeed a separate device. Sorry for slipping into it.
>
> Anyway, now that this is noticed, tuner and demod drivers should be split,
> especially since there are some patches floating around to add support for ds3103.
>
> As I said before, the right thing to do is:
>
>        1) split ds3000 from ts2020 at the existing driver;
>        2) add support for the newer chips (ds3103/ts2022) to the ds3000 and ds3103
>           drivers.
>        3) test if the patches adding support for the newer chips didn't break the
>           support for existing hardware.
>
> My proposal is that tasks (1) and (3) should be handled by you. As Max wants to
> add support for some devices based on ds3103/ts2022, IMO, he can do the patches
> for (2) in a way that they would be acceptable by you, as the driver maintainer
> for ds3000/ts2020, testing with their devices.
>
> Regards,
> Mauro
