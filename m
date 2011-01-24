Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44789 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab1AXP5E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 10:57:04 -0500
Received: by ewy5 with SMTP id 5so1908763ewy.19
        for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 07:57:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110124154935.GA51009@io.frii.com>
References: <20101207190753.GA21666@io.frii.com>
	<20110110021439.GA70495@io.frii.com>
	<AANLkTingFP9ajGckXXy2wScHHGxhz+KTyOBa-mE7SUs5@mail.gmail.com>
	<AANLkTi=59dytuN25H3DVRrPAB8GAcn6N88Ji_dkorsGB@mail.gmail.com>
	<AANLkTi=FFV8CWrBU-20huQRDysTPWGaen2mtP2sBQJef@mail.gmail.com>
	<20110119173946.GA64847@io.frii.com>
	<20110124154935.GA51009@io.frii.com>
Date: Mon, 24 Jan 2011 10:57:02 -0500
Message-ID: <AANLkTi=UecZQ1pzz+DGbcNKdY6qM3TZJ0+7xKSeXebsL@mail.gmail.com>
Subject: Re: DViCO FusionHDTV7 Dual Express I2C write failed
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mark Zimmerman <markzimm@frii.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Jan 24, 2011 at 10:49 AM, Mark Zimmerman <markzimm@frii.com> wrote:
> From looking at the code and a dump of the firmware file, the first
> i2c write would have a length of 3; so this error:
>
> xc5000: I2C write failed (len=3)
>
> tells me that there were probably no successful i2c transactions on
> this device. The i2c write call looks the same as that in other
> drivers, so I wonder if there is an initialization step that is now
> necessary but which is missing.
>
> Still hoping for suggestions...

My guess would be that somebody screwed up either the GPIO config int
the cx88 board profile, or the i2c gate, which is resulting in not
being able to reach the tuner at all.

Do you have an oscilloscope?  If so, I bet you will find that the
xc5000 pin is being held in reset.

I would probably take a hard look at the board profile in cx88-cards.c
as well as whether there have been any changes to the GPIO setup and
power management code.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
