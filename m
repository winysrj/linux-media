Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60099 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676Ab3GRClS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 22:41:18 -0400
Received: by mail-we0-f174.google.com with SMTP id q58so2427612wes.19
        for <linux-media@vger.kernel.org>; Wed, 17 Jul 2013 19:41:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51E74FAF.2060709@iki.fi>
References: <1374111202-23288-1-git-send-email-ljalvs@gmail.com>
	<CAGoCfizDcOPKiCo54rsoZJyXU3m-_v8jE0aTagxTyjB3QZrZXg@mail.gmail.com>
	<51E74FAF.2060709@iki.fi>
Date: Wed, 17 Jul 2013 22:41:17 -0400
Message-ID: <CAGoCfizd+Ax3OfuHuxVMc17==SrTD3caidEph_CjN+2To29s0w@mail.gmail.com>
Subject: Re: [PATCH] cx23885: Fix interrupt storm that happens in some cards
 when IR is enabled.
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Luis Alves <ljalvs@gmail.com>, linux-media@vger.kernel.org,
	mchehab@infradead.org, awalls@md.metrocast.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 17, 2013 at 10:15 PM, Antti Palosaari <crope@iki.fi> wrote:
> hmm, I looked again the cx23885 driver.
>
> 0x4c == [0x98 >> 1] = "flatiron" == some internal block of the chip

Yeah, ok.  Pretty sure Flatiron is the codename for the ADC for the SIF.

> There is routine which dumps registers out, 0x00 - 0x23
> cx23885_flatiron_dump()
>
> There is also existing routine to write those Flatiron registers. So, that
> direct I2C access could be shorten to:
> cx23885_flatiron_write(dev, 0x1f, 0x80);
> cx23885_flatiron_write(dev, 0x23, 0x80);

Yeah, the internal register routines should be used to avoid confusion.

> Unfortunately these two register names are not defined. Something clock or
> interrupt related likely.

Strange.  The ADC output is usually tied directly to the Merlin.  I
wonder why it would ever generate interrupts.

No easy answers here.  WIll probably have to take a closer look at the
datasheet, or just ask Andy.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
