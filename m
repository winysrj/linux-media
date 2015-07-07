Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgate.leissner.se ([212.3.1.210]:56164 "EHLO
	mailgate.leissner.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbbGGPdL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jul 2015 11:33:11 -0400
Date: Tue, 7 Jul 2015 17:33:01 +0200 (SST)
From: Peter Fassberg <pf@leissner.se>
To: Patrick Boettcher <patrick.boettcher@posteo.de>,
	Andy Furniss <adf.lists@gmail.com>
cc: linux-media@vger.kernel.org
Subject: Re: PCTV Triplestick and Raspberry Pi B+
In-Reply-To: <20150705184449.0017f114@lappi3.parrot.biz>
Message-ID: <alpine.BSF.2.20.1507071722280.72900@nic-i.leissner.se>
References: <alpine.BSF.2.20.1507041303560.12057@nic-i.leissner.se> <20150705184449.0017f114@lappi3.parrot.biz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 5 Jul 2015, Patrick Boettcher wrote:

> Your Intel platform is 64bit. I don't know the TripleStick nor the SI or
> the EM28xx-driver but _maybe_ there is a problem with it on 32-bit
> platforms. A long shot, I know, but you'll never know.

That was a very good point.

I installed the 32-bit version of the same OS (Debian 8, kernel 3.16.0, i386) and the result was a bit suprising.

In 32-bit I couldn't even scan a DVT-T transponder!  dvbv5-scan did Lock, but it didn't find any PSI PIDs.  So there is for sure a problem with 32-bit platforms.  And the DVT-T2 transponders didn't work either.

Maybe the Raspberry problem can be a Endianess problem?



On Mon, 6 Jul 2015, Andy Furniss wrote:

> Clutching at straws now, but maybe it's possible that the Pi is electrically more noisy then the intel.
> 
> The USB lead on the 292e doesn't have a ferrite core - maybe if you have an extension lead that does you could try adding that.

That was actually also a good point.  I installed a 50 cm extension but no difference. :(


Can anyone suggest a DVB-T2 USB stick that works on the Raspberry Pi B+?



// Peter
