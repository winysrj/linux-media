Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:37207 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932528AbbGGPfE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jul 2015 11:35:04 -0400
Date: Tue, 7 Jul 2015 17:35:00 +0200
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: Peter Fassberg <pf@leissner.se>
Cc: Andy Furniss <adf.lists@gmail.com>, linux-media@vger.kernel.org
Subject: Re: PCTV Triplestick and Raspberry Pi B+
Message-ID: <20150707173500.21041ab3@dibcom294.coe.adi.dibcom.com>
In-Reply-To: <alpine.BSF.2.20.1507071722280.72900@nic-i.leissner.se>
References: <alpine.BSF.2.20.1507041303560.12057@nic-i.leissner.se>
	<20150705184449.0017f114@lappi3.parrot.biz>
	<alpine.BSF.2.20.1507071722280.72900@nic-i.leissner.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 7 Jul 2015 17:33:01 +0200 (SST) Peter Fassberg <pf@leissner.se>
wrote:

> On Sun, 5 Jul 2015, Patrick Boettcher wrote:
> 
> > Your Intel platform is 64bit. I don't know the TripleStick nor the SI or
> > the EM28xx-driver but _maybe_ there is a problem with it on 32-bit
> > platforms. A long shot, I know, but you'll never know.
> 
> That was a very good point.
> 
> I installed the 32-bit version of the same OS (Debian 8, kernel 3.16.0, i386) and the result was a bit suprising.
> 
> In 32-bit I couldn't even scan a DVT-T transponder!  dvbv5-scan did Lock, but it didn't find any PSI PIDs.  So there is for sure a problem with 32-bit platforms.  And the DVT-T2 transponders didn't work either.
> 
> Maybe the Raspberry problem can be a Endianess problem?

No, rpi (arm) is little-endian as Intel.

Which drivers is your device using again? 

regards,
--
Patrick.

