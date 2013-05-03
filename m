Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:64391 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab3ECV3h (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 May 2013 17:29:37 -0400
Received: by mail-qa0-f46.google.com with SMTP id g10so423562qah.19
        for <linux-media@vger.kernel.org>; Fri, 03 May 2013 14:29:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51841517.4030504@earthlink.net>
References: <51841517.4030504@earthlink.net>
Date: Fri, 3 May 2013 17:29:36 -0400
Message-ID: <CAGoCfiy5qWrqH1ptGc4LKvbN1w-TtsV+ogCr7qWX6zn9L=MaSQ@mail.gmail.com>
Subject: Re: Driver for KWorld UB435Q Version 3 (ATSC) USB id: 1b80:e34c
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: The Bit Pit <thebitpit@earthlink.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 3, 2013 at 3:50 PM, The Bit Pit <thebitpit@earthlink.net> wrote:
> I am Wilson Michaels, please let me introduce myself:
>
> Eight years ago I contributed a driver for the DViCO FusionHDTV 3 & 5
> PCI TV tuner cards (see lgdt330x.c).  The code is still in linux today.
>  One of my tuners is starting to fail so a purchased a KWorld UB435Q
> Version 3 (ATSC) from Newegg.  It's not supported so I started working
> on a driver. Is anyone else working on a driver for the  KWorld UB435Q V-3?
>
> I opened the case easily as it just snaps together with a plastic clip.
> It is not glued :-) I verified that it contains:
> EM2874B
> NXP TDA18272/M
> lgdt3305
>
> I git the latest media_build tree and added entries to make it recognize
> the KWorld USB id: 1b80:e34c.  The added code is like the KWorld UB435Q
> Version 2 code with lgdt3304 replaced by lgdt3305 and no .dvb_gpio or
> .tuner_gpio. It reports finding an em2874 chip using bulk transfer mode
> as expected.

No bulk support currently for em28xx dvb.  I never got around to it
because the only sticks I ever came across them that use them is that
particular KWorld model, and from everything I've heard it's a piece
of garbage (unreliable, prone to failure even under WIndows).

That said, a bulk endpoint driver isn't rocket science to add support for.  :-)

> There appears to be code in the em28xx driver to handle
> bulk transfer.  It does not recognize the lgdt3305.

The lgdt3305 is probably on the second i2c bus -- typical for em2874
based devices.  The tuner is probably gated behind the 3305.

It's also likely that the 3305 is being held in reset by default.
You'll probably need to tweak a GPIO to take it out of reset before it
will answer i2c.

> I discovered (brute force scan) that there are two i2c addresses 0x50
> and 0xd0. The lgdt3305 detection code is able to read something from
> either i2c address, but is is always 0.

One is probably the eeprom.

> Does the eeprom data below have anything to help writing a driver for
> the KWorld UB435Q?

Almost certainly not.

> I suspect some initialization needs to be done, but I don't know what to
> try.  Does anyone have any information about how the hardware is
> configured or information captured from the Windows driver?
>
> Does anyone know where I can get a copy of the programming spec for the
> lgdt3305?  The em2874 spec would be useful too.

I have them both, but under NDA (neither are publicly available).  You
probably don't need either though.  Aside from the bulk support, the
em2874 implementation is pretty complete.  Same goes for the 3305.

Devin

--
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
