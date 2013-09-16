Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:56629 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab3IPWEP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Sep 2013 18:04:15 -0400
Received: by mail-wi0-f173.google.com with SMTP id hq15so4094174wib.12
        for <linux-media@vger.kernel.org>; Mon, 16 Sep 2013 15:04:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <52375871.8040004@sca-uk.com>
References: <5235CED8.3080804@sca-uk.com>
	<CAGoCfiyuvXAhBS=n=_3bZKnCSTZYMrHFJ73MfRnoiuW44Y=zKg@mail.gmail.com>
	<52363EA6.7060402@sca-uk.com>
	<CAGoCfix7r_bp7w-6HyXYz_XOZz-zFk_SLUzA6-Br6Z-LLsTy-g@mail.gmail.com>
	<52375871.8040004@sca-uk.com>
Date: Mon, 16 Sep 2013 18:04:14 -0400
Message-ID: <CAGoCfixmM5f3vWShZMMW13q6ZeijVPYDxY5qxqviPTodVy2kCQ@mail.gmail.com>
Subject: Re: Hauppauge ImpactVCB-e 01381 PCIe driver resolution.
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Steve Cookson <it@sca-uk.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

> What I really want is a fast, analogue RGBS 480i & 1080i capture card.

Raw HD capture is essentially non-existent under Linux.  We have a
couple of closed source drivers, none of which are cost effective for
non-commercial applications (we have drivers for a couple of Avermedia
HDMI/component capture cards).

> Maybe like the Epiphan VGA2USB LR (internal version), but it is sooo
> expensive.
>
> For 25% of the price I can get a Blackmagic Design Intensity Pro, but
> it only does YPbPr 1080i and the decklinksrc gstreamer module is a
> bit ropey.  Actually very ropey.  But it also accepts s-video.
>
> So then I fall back on the old tried and tested s-video stuff.  I have to
> accept 480i but I can still have a fast response.  Dazzle is about 100
> msecs but some others, like the old ImpactVCB pci card with
> 3 av ports and an s-video port, has worse quality video than the Dazzle
> and is slower.  I've tested another couple of PCI cards but they are all
> very slow and poor video quality.

The "slow" aspect is probably just a misconfiguration in the number of
buffers the V4L2 driver delivers.  All of the cards should support a
minimum of two buffers, which would put latency at 60ms.  Anything
greater is probably the application doing some prebuffering.

> The one I'd really like, at about $100 on Amazon, is the Startech
> VGA capture card, I could put a synch splitter/inverter in front of it, for
> say $25, to convert RGB3 1080i to VGA HD1080.  It runs like a dream
> with a fast response.  It's Linux compatible as far as I can see, that
> is to say lspci should say something if you plug it in, but there is no
> driver for it.

To be clear, the fact that it shows up in lspci is absolutely no
indicator of being Linux compatible.  It just means the device
conforms to the PCI standard and can thus the hardware can be
enumerated.

> The one I saw, which was not the Startech one but a
> similar one from Kato vision, was PCIe, with onboard h.264
> hardware compression and a direct memory access module.  It
> just screamed through that video signal.  I wasn't able to do any timer
> tests
> on it, but I would guess much faster than the dazzle.  Maybe 50 msecs
> latency.

Are you using the same application for capture in both cases?  They
really shouldn't behave any differently.

Raw video is essentially no latency since the card typically doesn't
have enough memory to do any buffering (unlike compressed video where
you can have latency of several seconds depending on the encoder
used).  Any latency you are seeing is either in the driver or the
application.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
