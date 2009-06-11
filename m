Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:49696 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756702AbZFKINd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 04:13:33 -0400
Date: Thu, 11 Jun 2009 10:13:16 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Matthias Schwarzott <zzam@gentoo.org>
cc: linux-media@vger.kernel.org, Uwe Bugla <uwe.bugla@gmx.de>
Subject: Re: [PATCH] flexcop-pci: add suspend/resume support
In-Reply-To: <200905262109.29180.zzam@gentoo.org>
Message-ID: <alpine.LRH.1.10.0906111009420.18712@pub1.ifh.de>
References: <200905262109.29180.zzam@gentoo.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matthias,

On Tue, 26 May 2009, Matthias Schwarzott wrote:
> This patch adds suspend/resume support to flexcop-pci driver.
>
> I could only test this patch with the bare card, but without having a DVB-S
> signal. I checked it with and without running szap (obviously getting no
> lock).
> It works fine here with suspend-to-disk on a tuxonice kernel.

As I'm notoriously out of time I haven't yet checked the functionality 
with suspend though I'm looking forward to do so, because it would 
extremely nice to use suspend2disk for shutting down rather than shutdown.

> Setting of hw-filter in resume is done the same way as the watchdog does it:
> Just looping over fc->demux.feed_list and running flexcop_pid_feed_control.
> Where I am unsure is the order at resume. For now hw filters get started
> first, then dma is re-started.
>
> Do I need to give special care to irq handling?

Good question. I think starting the streaming the same way as it is done 
in normal operation would do the trick, but I'm not sure whether this is 
possible for suspend/resume. I need to try.

Thanks a lot for the patch, I will try to adapt it also for dvb-usb. Like 
that all dvb-usb-based device will become resumable in one shot :). But 
time will tell when. :/

Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
