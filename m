Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:34038 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935203AbZKYXjO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 18:39:14 -0500
Subject: Re: Tuner drivers
From: hermann pitton <hermann-pitton@arcor.de>
To: rulet1@meta.ua
Cc: linux-media@vger.kernel.org
In-Reply-To: <43103.95.132.166.23.1259188983.metamail@webmail.meta.ua>
References: <1258314943.3276.3.camel@pc07.localdom.local>
	 <46842.95.132.81.101.1259175646.metamail@webmail.meta.ua>
	 <1259187084.3335.48.camel@pc07.localdom.local>
	 <43103.95.132.166.23.1259188983.metamail@webmail.meta.ua>
Content-Type: text/plain
Date: Thu, 26 Nov 2009 00:38:06 +0100
Message-Id: <1259192286.3335.64.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Donnerstag, den 26.11.2009, 00:43 +0200 schrieb rulet1@meta.ua:
> Well, I just can gin an information which is written on the chip of this
> Aver Super 007 Analog(Only+FM) tuner:
> 
> NXP
> SAA7131E103/G
> CH2130
> SF7227.1
> TSG07142

Well, that is good to know and makes some other speculations obsolete.

> 
> Maybe this will help in developing driver for this device,
> tvtime recieves signal much more worse then native AverMedia program for
> this tuner for Windows,

As said, the driver is known to be alright globally.

> and tvtime can scan channels for houres when AverMedia do it for seconds...
> But I also understand that AverMedia will never give source code or
> specifications of this device and other devices,
> so I don't see any reason for guesing how to write right code, but if you
> can, do it... I cannot -- I'm not a programmer.

We don't need any code from AverMedia or anyone else after seven years,
but of course all contributions are still welcome.

You have a single card not working in the Ukraine currently, this might
have political reasons, SECAM/DK NICAM is known to work in Russia and
elsewhere.

The huge delays in tvtime-scanner or xawtv scantv is a single experience
you report right now, nobody else. Please note that!

Such is likely caused by, that the driver tries to lock on something
unusual. You still don't provide any debug output, nor do you know on
which TV system and especially sound system you are currently.

Should I know better without any input?
(OK, i have a friend there, would take some time)

Maybe they changed to SECAM A2. Try saa7134 audio_ddep=0x08 then ;)

Cheers,
Hermann








