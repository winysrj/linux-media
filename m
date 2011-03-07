Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33032 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab1CGKbb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2011 05:31:31 -0500
Received: by wwb22 with SMTP id 22so5001927wwb.1
        for <linux-media@vger.kernel.org>; Mon, 07 Mar 2011 02:31:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1299491520.2189.10.camel@ares>
References: <1299491520.2189.10.camel@ares>
Date: Mon, 7 Mar 2011 10:31:30 +0000
Message-ID: <AANLkTikawatHbobeRBGDyr61LmEhru2uZ4FtqZUtxwh5@mail.gmail.com>
Subject: Re: i2c_gate_ctrl question
From: adq <adq@lidskialf.net>
To: Steve Kerrison <steve@stevekerrison.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 7 March 2011 09:52, Steve Kerrison <steve@stevekerrison.com> wrote:
> Hi media men & women,
>
> I have a question regarding the cxd2820r I'm working on with a couple of
> other people.
>
> In my naivety I implemented i2c gate control for the device (to access
> the tuner behind it) as a separate i2c device that did the passthrough.
> Now that I realise this, it would make sense to use the gate_ctrl
> features.
>
> However, picking apart the USB data it looks as though the way the
> cxd2820r implements "gate control" isn't immediately compatible with the
> implementation seen in other devices.
>
> Example, and I2C send to the tuner at (addr << 1) of:
> { xx, xx, ..., xx}
>
> becomes a write to (demod_addr << 1) of :
> { 09, (addr << 1) | flags, xx, xx, ..., xx}
>
> And an i2c receive is implemented to a receive from the demod address,
> not from the tuner address.
>
> So, unless there are open and close gate commands that aren't apparent
> from the snoop, or there's something I've missed, all i2c transfers to
> the tuner have to be mangled - sorry I mean encapsulated - prior to
> sending. To my understanding this doesn't fit in with the gate_ctrl
> implementation for i2c.
>
> I haven't had time to examine all other gate control implementations in
> the media modules, so if anyone knows any good examples that might work
> in a similar way, I'd appreciate the tip-off. Otherwise, would there be
> any objections to my implementation of a dummy i2c device that does the
> encapsulation?

Yup, it sounds like the gate_ctrl code won't work in this case and
you'll need a seperate i2c bus.

An example is the cx24123 demod, which creates its own i2c tuner bus.
