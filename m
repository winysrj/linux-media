Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43799 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932253AbbGCLFH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jul 2015 07:05:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1ZAymH-0005jy-30
	for linux-media@vger.kernel.org; Fri, 03 Jul 2015 13:05:05 +0200
Received: from nat.piap.pl ([195.187.100.13])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 03 Jul 2015 13:05:05 +0200
Received: from khalasa by nat.piap.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 03 Jul 2015 13:05:05 +0200
To: linux-media@vger.kernel.org
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
Subject: Re: Subjective maturity of tw6869, cx25821, bluecherry/softlogic drivers
Date: Fri, 03 Jul 2015 12:46:15 +0200
Message-ID: <m3vbe1plhk.fsf@t19.piap.pl>
References: <1435871672466752997@telcodata.us>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Nathaniel Bezanson <myself@telcodata.us> writes:

> I found the intersil/techwell TW6869 chip on a very affordable card,
> and there's a nice looking driver here:
> https://github.com/igorizyumin/tw6869/

It didn't work for me. Probably because it uses large coherent
allocations (which aren't possible on ARM, and shouldn't be used
on any hardware). Other problems (not sure if in this very driver, or
another of its clones): not using DMA SG, using CPU to copy frame data
in DQBUF (or somewhere), apparent support for nonexistent hardware
features (tuners?).

This reminds me to post my own driver for these cards, a bit smaller and
lacking some features (like scaling and cropping) but working and using
SG DMA.

> Only trouble is there only
> seems to be the one card using it

There are at least Sensoray (8-port, a bit improved chip) and Commell
(4-port, based on older TW6864) cards.

These chips aren't ideal - but they work.
For example, in DMA SG mode, they can't produce a single continuous
interlaced frame in memory - they can only make two separate fields.
A limitation of their DMA engine, since in non-SG mode they can make
(pseudo)-progressive frames.

Also, they can't do YUV420 - they only do things like YUV422 and
RGB565/555 (well they can do YUV420 with custom encoding in a mode with
reduced vertical resolution - with field dropping or in field mode,
where each field is a different picture encoded with YUV420).


I'm using SOLO6110-based cards, too. They work. There are apparently
certain problems, but I wasn't able to reproduce them. My use is limited
to 4-channel operation, though (the chip can do up to 5 full D1 H.264
streams, but there are 16-channel versions which can do 16 simultaneous
H.264s with a reduced resolution and/or with frame dropping - I suspect
the latter could be the problem).

SOLO6110 doesn't produce a valid interlaced H.264 stream (with field
encoding) - only a (pseudo) progressive stream (frame mode). This is
actually what TW686x lacks :-)

Also, TW686x are (mini) PCIe while SOLO6110 (and earlier SOLO6010 which
produces MPEG4 part 2 instead of H.264) are (mini) PCI.
TW686x don't have hardware H.264 encoder (though I'm told certain
TW586x do have).
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland

