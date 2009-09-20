Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42426 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbZITJC4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Sep 2009 05:02:56 -0400
Date: Sun, 20 Sep 2009 06:02:18 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: David Liontooth <lionteeth@cogweb.net>
Cc: hermann pitton <hermann-pitton@arcor.de>,
	linux-media@vger.kernel.org
Subject: Re: Audio drop on saa7134
Message-ID: <20090920060218.51971a45@pedra.chehab.org>
In-Reply-To: <4AB5E6AC.1090505@cogweb.net>
References: <4AAEFEC9.3080405@cogweb.net>
	<20090915000841.56c24dd6@pedra.chehab.org>
	<4AAF11EC.3040800@cogweb.net>
	<1252988501.3250.62.camel@pc07.localdom.local>
	<4AAF232F.9060204@cogweb.net>
	<1252993000.3250.97.camel@pc07.localdom.local>
	<4AAF2F1B.2050206@cogweb.net>
	<4AB5E6AC.1090505@cogweb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 20 Sep 2009 01:24:12 -0700
David Liontooth <lionteeth@cogweb.net> escreveu:

> Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 0x000000
> Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 0xbbbbbb

This means mute. With this, audio will stop.

> Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 0x000000
> Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 0xbbbb10

This means unmute.

It seems that the auto-mute code is doing some bad things for you. What happens
if you disable automute? This is a control that you can access via v4l2ctl or
on your userspace application.

Are you using the last version of the driver? I'm not seeing some debug log messages
that should be there...



Cheers,
Mauro
