Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65157 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab1ASRW2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 12:22:28 -0500
Received: by iyj18 with SMTP id 18so1052537iyj.19
        for <linux-media@vger.kernel.org>; Wed, 19 Jan 2011 09:22:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=59dytuN25H3DVRrPAB8GAcn6N88Ji_dkorsGB@mail.gmail.com>
References: <20101207190753.GA21666@io.frii.com>
	<20110110021439.GA70495@io.frii.com>
	<AANLkTingFP9ajGckXXy2wScHHGxhz+KTyOBa-mE7SUs5@mail.gmail.com>
	<AANLkTi=59dytuN25H3DVRrPAB8GAcn6N88Ji_dkorsGB@mail.gmail.com>
Date: Wed, 19 Jan 2011 09:22:28 -0800
Message-ID: <AANLkTi=FFV8CWrBU-20huQRDysTPWGaen2mtP2sBQJef@mail.gmail.com>
Subject: Re: DViCO FusionHDTV7 Dual Express I2C write failed
From: VDR User <user.vdr@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Mark Zimmerman <markzimm@frii.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Jan 19, 2011 at 8:13 AM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
>> Can someone please look into this and possibly provide a fix for the
>> bug?  I'm surprised it hasn't happened yet after all this time but
>> maybe it's been forgotten the bug existed.
>
> You shouldn't be too surprised.  In many cases device support for more
> obscure products comes not from the maintainer of the actual driver
> but rather from some random user who hacked in an additional board
> profile (in many cases, not doing it correctly but good enough so it
> "works for them").  In cases like that, the changes get committed, the
> original submitter disappears, and then when things break there is
> nobody with the appropriate knowledge and the hardware to debug the
> problem.

Good point.  My understanding is that this is a fairly common card so
I wouldn't think that would be the case.  At any rate, hopefully we'll
be able to narrow down the cause of the problem and get it fixed.

Thanks.
