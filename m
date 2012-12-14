Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:46037 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab2LNX0t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 18:26:49 -0500
Received: by mail-qa0-f46.google.com with SMTP id r4so1221523qaq.19
        for <linux-media@vger.kernel.org>; Fri, 14 Dec 2012 15:26:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50CBB01B.2050700@iki.fi>
References: <50B51F7E.2030008@sfr.fr>
	<50CB61A6.7060308@sfr.fr>
	<50CB67F4.3090802@iki.fi>
	<50CBA8BE.8020205@sfr.fr>
	<50CBB01B.2050700@iki.fi>
Date: Fri, 14 Dec 2012 18:26:48 -0500
Message-ID: <CAGoCfiznjVr0Km_gPV6bMsXUZXQJYLptTEFGTXcO5ZipBVd8nQ@mail.gmail.com>
Subject: Re: [PATCH] [media] ngene: fix dvb_pll_attach failure
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Patrice Chotard <patrice.chotard@sfr.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	=?ISO-8859-1?B?RnLpZOlyaWM=?= <frederic.mantegazza@gbiloba.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 14, 2012 at 6:02 PM, Antti Palosaari <crope@iki.fi> wrote:

> That one is better solution...
>
> but it is clearly DRXD driver bug - it should offer working I2C gate control
> after attach() :-( I looked quickly DRXD driver and there is clearly some
> other places to enhance too. But I suspect there is no maintainer, nor
> interest from anyone to start fix things properly, so only reasonable way is
> to add that hack to get it working...
>
> Honestly, I hate this kind of hacks :/ That makes our live hard on long run.
> It goes slowly more and more hard to make any core changes as regressions
> will happen due to this kind of hacks.
>
> So send new patch which put demod chip sleeping after tuner attach. Or even
> better, find out what is minimal set of commands needed do execute during
> attach in order to offer working I2C gate (I suspect firmware load is
> needed).

Opening the gate at the end of the attach callback should be a trivial
exercise.  Should just be a call to drxd_config_i2c(fe, enable) at the
end of drxd_attach().

Devin

--
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
