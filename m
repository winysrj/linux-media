Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-he1eur01on0115.outbound.protection.outlook.com ([104.47.0.115]:13136
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752527AbeFOEjz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 00:39:55 -0400
Subject: Re: [RFC PATCH v2] media: i2c: add SCCB helpers
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        linux-i2c@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1528817686-7067-1-git-send-email-akinobu.mita@gmail.com>
 <843b1253-67ec-883f-9683-134528320791@axentia.se>
 <be2c81ed-c37a-c178-0c8e-7029474ff316@axentia.se>
 <20180614154139.eu7fznytzf4rkt4g@ninjato>
From: Peter Rosin <peda@axentia.se>
Message-ID: <55f65c0d-662d-bd6a-67eb-84796fa5fa1b@axentia.se>
Date: Fri, 15 Jun 2018 06:39:45 +0200
MIME-Version: 1.0
In-Reply-To: <20180614154139.eu7fznytzf4rkt4g@ninjato>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-06-14 17:41, Wolfram Sang wrote:
> 
>> So, maybe the easier thing to do is change i2c_lock_adapter to only
>> lock the segment, and then have the callers beneath drivers/i2c/
>> (plus the above mlx90614 driver) that really want to lock the root
>> adapter instead of the segment adapter call a new function named
>> i2c_lock_root (or something like that). Admittedly, that will be
>> a few more trivial changes, but all but one will be under the I2C
>> umbrella and thus require less interaction.
>>
>> Wolfram, what do you think?
> 
> It sounds tempting, yet I am concerned about regressions. From that
> point of view, it is safer to introduce i2c_lock_segment() and convert the
> users which would benefit from that. How many drivers would be affected?

Right, there is also the aspect that changing a function like this
might surprise people. Maybe i2c_lock_adapter should be killed and
all callers changed to one of i2c_lock_segment and i2c_lock_root?
It's not that much churn...

Current callers (I didn't hunt the very latest sources, nor -next)
of i2c_lock_adapter are:

drivers/i2c/i2c-core-slave.c
	Locks the adapter during (un)registration of the slave. Should
	keep locking the root adapter.

drivers/i2c/busses/i2c-brcmstb.c
	Locks the adapter during suspend/resume. Should keep locking
	the root adapter.

drivers/i2c/busses/i2c-davinci.c
	Locks the adapter if/when the CPU frequency changes. Should
	keep locking the root adapter.

drivers/i2c/busses/i2c-gpio.c
	Locks the adapter while twiddling the lines from debugfs. Should
	keep locking the root adapter.

drivers/i2c/busses/i2c-s3c2410.c
	Locks the adapter if/when the CPU frequency changes.Should keep
	locking the root adapter.

drivers/i2c/busses/i2c-sprd.c
	Locks the adapter during suspend/resume. Should keep locking
	the root adapter.

drivers/i2c/busses/i2c-tegra.c
	Locks the adapter during suspend/resume. Should keep locking
	the root adapter.

drivers/i2c/muxes/i2c-mux-pca9541.c
	Locks the adapter during probe to make I2C transfers. Should
 	only need to lock the segment.

drivers/iio/temperature/mlx90614.c
	Mentioned previously up-thread, suspend/resume apparently does
	nasty things with the bus. Should probably keep locking the root
	adapter.

drivers/char/tpm/tpm_i2c_infineon.c
	Does a bunch of __i2c_transfer calls inside the locked regions
	(and some sleeping). Should only need to lock the segment.

drivers/input/touchscreen/rohm_bu21023.c
	Does a couple of __i2c_transfer calls inside the locked region.
	Should only need to lock the segment.

drivers/media/dvb-frontends/af9013.c
	Does a one or two __i2c_transfer calls inside the locked regions.
	Should only need to lock the segment.

drivers/media/dvb-frontends/drxk_hard.c
	This one is a bit hairy. It does all sorts of things inside the
	locked region. And it is a bit hard to say if the root adapter
	really needs to be locked.

drivers/media/dvb-frontends/rtl2830.c
	Does regmap accesses inside the locked regions, with the regmap
	ops overridden to use __i2c_transfer. Should only need to lock
	the segment.

drivers/media/dvb-frontends/tda1004x.c
	Does a bunch of __i2c_transfer calls inside the locked region.
	Should only need to lock the segment.

drivers/media/tuners/tda18271-common.c
	Seems to opens a gate in conjunction with locking the adapter.
	So, I'm a bit uncertain what will happen on the other side of
	that gate if there is any stray thing happening on the I2C
	bus.

drivers/mfd/88pm860x-i2c.c
	Does a bunch of adap->algo->master_xfer calls inside the locked
	regions. Should only need to lock the segment (and should probably
	be using __i2c_transfer).

So, drxk_hard.c and tda18271-common.c are a bit uncertain. However, since
these drivers do make calls to __i2c_transfer from inside their locked
regions, both drivers will deadlock if the chips sit downstream from a
mux-locked I2C mux. And if they don't, locking the segment and the
adapter are equivalent. So, the risk of regressions are nil AFAICT. Famous
last words...

Cheers,
Peter
