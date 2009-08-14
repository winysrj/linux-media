Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:34262 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754863AbZHNH4d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2009 03:56:33 -0400
Date: Fri, 14 Aug 2009 09:56:21 +0200 (CEST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Paul Menzel <paulepanter@users.sourceforge.net>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: dib0700 diversity support
In-Reply-To: <1250177934.6590.120.camel@mattotaupa.wohnung.familie-menzel.net>
Message-ID: <alpine.LRH.1.10.0908140947560.14872@pub3.ifh.de>
References: <1250177934.6590.120.camel@mattotaupa.wohnung.familie-menzel.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Paul,

On Thu, 13 Aug 2009, Paul Menzel wrote:
> I traded an unsupported Terratec Cinergy HTC USB XS HD with a TerraTec
> Cinergy DT USB XS Diversity [1].
>
> As written in [1] it has a bad reception.
>
> It uses the dib0700 driver and the DiB0700 seems to support a diversity
> feature which supposedly improves the signal quality by combining both
> tuner(?).

Diversity is actually meant for mobile reception. Meaning the receiver is 
changing the position regarding the transmitter. Depending of the moving 
direction relatively to the transmitter the Doppler effect can destroy a 
part of the signal over time. It turned out diversity can compensate that 
effect using multiple antennas in different positions/polarisations.

Diversity can also improve the situation in fixed reception environments, 
but the improvement is not high (compared to how it can be mobile 
reception).

The cut things short, what is stated on the wiki is unfortunately correct, 
the sensitivity of the used tuner is not very good; but this is due to an
outdated-driver.

I have an update for the dib0070-tuner-driver ready, which hopefully 
improves reception quality for low-sensitivity channels.

I'll post a request for testing soon.

--

Patrick Boettcher - Kernel Labs
http://www.kernellabs.com/
