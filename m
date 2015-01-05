Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:37994 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbbAENGJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Jan 2015 08:06:09 -0500
Received: by mail-pd0-f175.google.com with SMTP id g10so28165807pdj.20
        for <linux-media@vger.kernel.org>; Mon, 05 Jan 2015 05:06:09 -0800 (PST)
Message-ID: <54AA8C3B.30504@gmail.com>
Date: Mon, 05 Jan 2015 22:06:03 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: linux-media@vger.kernel.org, Olli Salonen <olli.salonen@iki.fi>,
	James Harper <james.harper@ejbdigital.com.au>,
	Nibble Max <nibble.max@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: Re: [PATCH 2/5] mb86a20s: convert it to I2C binding model
References: <E1Y6nKe-0002Tz-1q@mail.kapsi.fi>
In-Reply-To: <E1Y6nKe-0002Tz-1q@mail.kapsi.fi>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

moikka,

On 2015年01月02日 06:30, Antti Palosaari wrote:
> I am on holiday trip now. But generally speaking I would like to separate all drivers from the interfaces. That means for example I2C tuner driver is just a I2C driver and nothing more - no relations to DVB nor V4L API. That is something I said many times earlier too, but for my taste drivers should be agnostics to APIs.

I can't yet fully understand what API agnostic driver means,
but if it is like the implementation of the current i2c tuner/demod drivers,
each adapter drivers must (re-)implement common codes like module loading/ref-counting
and demod/tuner drivers must implement dvb-core related initializations on their own.
In addition, they may take different ways in how the data like "fe", config data and
other device specific output parameters are passed around
between adapters and demod/tuners.

I thought it would be better to intergrate those common codes into dvb_core
to ease maintainance and let each driver concentrate on driver-specific things.

And don't the current i2c tuner drivers already depend on dvb_core practically
by implementing dvb_tuner_ops functions and
filling in their pointers into fe->ops.tuner_ops?

regards,
akihiro
