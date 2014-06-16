Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:16201 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbaFPPFv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 11:05:51 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N7900HD2OLQOX40@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 16 Jun 2014 11:05:50 -0400 (EDT)
Date: Mon, 16 Jun 2014 12:05:44 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>,
	alsa-devel@alsa-project.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [alsa-devel] [PATCH 1/3] sound: Add a quirk to enforce period_bytes
Message-id: <20140616120544.10ef75f4.m.chehab@samsung.com>
In-reply-to: <CAGoCfiw3du9rXFvDfsUYLu4Ru6mbdWa+LtAyYupXosM0n-71NA@mail.gmail.com>
References: <1402762571-6316-1-git-send-email-m.chehab@samsung.com>
 <1402762571-6316-2-git-send-email-m.chehab@samsung.com>
 <539E9F25.7030504@ladisch.de>
 <CAGoCfiw3du9rXFvDfsUYLu4Ru6mbdWa+LtAyYupXosM0n-71NA@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 16 Jun 2014 09:22:08 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> > This looks like a workaround for a userspace bug that would affect all
> > USB audio devices.  What period/buffer sizes are xawtv/tvtime trying to
> > use?
> 
> I have similar concerns, although I don't know what the right solution
> is.  For example, the last time Mauro tweaked the latency in tvtime,
> it broke support for all cx231xx devices (note that tvtime and xawtv
> share essentially the same ALSA code):
> 
> http://git.linuxtv.org/cgit.cgi/tvtime.git/commit/?id=3d58ba563bfcc350c180b59a94cec746ccad6ebe
> 
> It seems like there is definitely something wrong with the
> latency/period selection in both applications, but we need some
> insight from people who are better familiar with the ALSA subsystem
> for advice on the "right" way to do low latency audio capture (i.e.
> properly negotiating minimal latency in a way that works with all
> devices).

Well, I suspect that the issue is at Kernel level.

Let's see the au0828 case:
	48 kHz, 2 bytes/sample, 2 channels, 256 maxpacksize, 1 ms URB
interval (bInterval = 1).

In this case, there is 192 bytes per 1ms period.	

Let's assume that the period was set to 3456, with corresponds to
a latency of 18 ms.

In this case, as NUM_URBS = 12, it means that the transfer buffer
will be set to its maximum value of 3072 bytes per URB pack (12 * 256),
and the URB transfer_callback will be called on every 16 ms.

So, what happens is:

	- after 16 ms, the first 3072 bytes arrive. The next
	  packet will take another 16ms to arrive;
	- after 2 ms, underrun, as the period_size was not
	  filled yet.

The thing is that any latency that between 16 ms and 32 ms
are invalid, as the URB settings won't support it.

Regards,
Mauro
