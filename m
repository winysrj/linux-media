Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:48390 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752966AbZKONvr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2009 08:51:47 -0500
Subject: Re: Tuner drivers
From: hermann pitton <hermann-pitton@arcor.de>
To: rulet1@meta.ua
Cc: linux-media@vger.kernel.org
In-Reply-To: <53772.95.133.222.95.1258288950.metamail@webmail.meta.ua>
References: <1258073462.8348.35.camel@pc07.localdom.local>
	 <36685.95.133.109.178.1258107794.metamail@webmail.meta.ua>
	 <1258143870.3242.31.camel@pc07.localdom.local>
	 <53772.95.133.222.95.1258288950.metamail@webmail.meta.ua>
Content-Type: text/plain
Date: Sun, 15 Nov 2009 14:49:40 +0100
Message-Id: <1258292980.3235.14.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Sonntag, den 15.11.2009, 14:42 +0200 schrieb rulet1@meta.ua:
> How to do that?:
> 
> "You are forced to use saa7134-alsa dma sound"
> 

a problem is that I can't tell for sure which analog TV standard you
currently use in the Ukraine, either it is still SECAM DK or you changed
to some PAL already.

Try to get the details, also about the sound system.

If it is still SECAM DK, you need to force the option "secam=DK".

With "audio_debug=1" you can see if the drivers finds the pilots, the
first sound carrier and the second carrier and also the stereo system in
use. This counts also for PAL standards.

This way you can already see if the driver can lock on the audio
carriers in "dmesg" without hearing anything yet.

Then saa7134-alsa should provide TV sound on your card.
http://linuxtv.org/wiki/index.php/Saa7134-alsa

Cheers,
Hermann





