Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:60524 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189AbZBIWPO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Feb 2009 17:15:14 -0500
Subject: Re: [linux-dvb] mt352 no more working after suspend to disk
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
In-Reply-To: <200902091233.26086.Nicola.Sabbi@poste.it>
References: <200902091233.26086.Nicola.Sabbi@poste.it>
Content-Type: text/plain
Date: Mon, 09 Feb 2009 23:16:01 +0100
Message-Id: <1234217761.2790.15.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nico,

Am Montag, den 09.02.2009, 12:33 +0100 schrieb Nico Sabbi:
> Hi,
> if I suspend to disk and next resume I have to manually remove and 
> reload my mt352 driver, otherwise it complains of a lot of i2c 
> errors.
> 
> My kernel is suse's 2.6.27.
> 
> Is this problem fixed in recent kernels or in hg?
> 
> Thanks,
> 	Nico
> 

don't know on what driver you report it, but since I know you also have
saa7134 driver devices, nobody claimed so far that dvb is suspend/resume
safe.

I recently reported that people have to stay aware after resume, that
even without using any dvb app actually during suspend, analog needs to
be re-initialized first after that to get the tda10046 in a proper state
for DVB-T again, at least on hybrid devices. Unshared DVB-S tuners and
demods do stand this already. (medion 8800quad, CTX948, Asus 3in1)

You can suspend to RAM on analog for example with a running tvtime and
resume, but dma sound on saa7134-alsa is also not handled yet. Analog
sound works.

That is the status as far I have it.

Cheers,
Hermann




