Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48600 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146AbZFJO0I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 10:26:08 -0400
Date: Wed, 10 Jun 2009 11:26:04 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: linux-media@vger.kernel.org,
	Patrick Boettcher <patrick.boettcher@desy.de>,
	Uwe Bugla <uwe.bugla@gmx.de>
Subject: Re: [PATCH] flexcop-pci: add suspend/resume support
Message-ID: <20090610112604.287629a9@pedra.chehab.org>
In-Reply-To: <200905262109.29180.zzam@gentoo.org>
References: <200905262109.29180.zzam@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 26 May 2009 21:09:28 +0200
Matthias Schwarzott <zzam@gentoo.org> escreveu:

> Hi Patrick! Hi list!
> 
> This patch adds suspend/resume support to flexcop-pci driver.
> 
> I could only test this patch with the bare card, but without having a DVB-S 
> signal. I checked it with and without running szap (obviously getting no 
> lock).
> It works fine here with suspend-to-disk on a tuxonice kernel.
> 
> Setting of hw-filter in resume is done the same way as the watchdog does it: 
> Just looping over fc->demux.feed_list and running flexcop_pid_feed_control.
> Where I am unsure is the order at resume. For now hw filters get started 
> first, then dma is re-started.
> 
> Do I need to give special care to irq handling?

It would be important to have a test with real signals to see if the patch is
really working, and see if it will still work if you suspend while streaming.

Also, you missed your SOB.



Cheers,
Mauro
