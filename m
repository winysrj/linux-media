Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f54.google.com ([209.85.216.54]:62896 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaFPTEp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 15:04:45 -0400
Received: by mail-qa0-f54.google.com with SMTP id v10so8040616qac.27
        for <linux-media@vger.kernel.org>; Mon, 16 Jun 2014 12:04:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140616155909.20acc269.m.chehab@samsung.com>
References: <1402762571-6316-1-git-send-email-m.chehab@samsung.com>
	<1402762571-6316-2-git-send-email-m.chehab@samsung.com>
	<539E9F25.7030504@ladisch.de>
	<20140616112110.3f509262.m.chehab@samsung.com>
	<539F017C.90408@gmail.com>
	<20140616132428.78edf63c.m.chehab@samsung.com>
	<539F2652.8030201@gmail.com>
	<20140616155909.20acc269.m.chehab@samsung.com>
Date: Mon, 16 Jun 2014 15:04:44 -0400
Message-ID: <CAGoCfiyFu++gpBkz3EZF5zGnD8pdqS-XROh2UWEfzgBnxk2kaA@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH 1/3] sound: Add a quirk to enforce period_bytes
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: "Alexander E. Patrakov" <patrakov@gmail.com>,
	Clemens Ladisch <clemens@ladisch.de>,
	Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> The official TV playback application, found on the CD with drivers,
>> captures samples from the card into its buffer, and plays from the other
>> end of the buffer concurrently. If there are, on average for a few
>> seconds, too few samples in the buffer, it means that they are consumed
>> faster than they arrive, and so the SAA chip is told to produce them a
>> bit faster. If they accumulate too much, the SAA chip is told to produce
>> them slower. That's it.
>
> Ok. Well, xc5000 (with does the audio sampling) doesn't have it, AFAIKT.
>
>> >
>> > The xc5000 tuner used on this TV device doesn't provide any mechanism
>> > to control audio PLL. It just sends the audio samples to au0828 via a
>> > I2S bus. All the audio control is done by the USB bridge at au0828,
>> > and that is pretty much limited. The only control that au0828 accepts
>> > is the control of the URB buffers (e. g., number of URB packets and
>> > URB size).

It's probably worth noting that Mauro's explanation here is incorrect
- the xc5000 does *not* put out I2S.  It outputs an SIF which is fed
to the au8522.  The au8522 has the audio decoder, and it's responsible
for putting out I2S to the au0828.

Hence the xc5000's PLL would have no role here.

In fact, you should see the exact same behavior on the A/V input,
since the au8522 is responsible for the I2S clock which drives the
cs5503 (the 5503 is in slave mode).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
