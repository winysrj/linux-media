Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41109 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab1HFPv4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Aug 2011 11:51:56 -0400
Received: by fxh19 with SMTP id 19so3808292fxh.19
        for <linux-media@vger.kernel.org>; Sat, 06 Aug 2011 08:51:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110806144444.GA11588@achter.swolter.sdf1.org>
References: <20110806144444.GA11588@achter.swolter.sdf1.org>
Date: Sat, 6 Aug 2011 11:51:48 -0400
Message-ID: <CAGoCfiw8R_RsYdHucMqRCXPndZGO7bG=0ogw9k9vpd-xYuPtAw@mail.gmail.com>
Subject: Re: Support for Hauppauge WinTV HVR-3300
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Steve Wolter <swolter@sdf.lonestar.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 6, 2011 at 10:44 AM, Steve Wolter <swolter@sdf.lonestar.org> wrote:
> Dear linux-media list,
>
> I have recently bought a Hauppauge WinTV HVR-3300 and am trying to make
> it run with Linux.
>
> Going by the output of lspci -v [1], I tried to go with the cx23885, which
> doesn't recognize the card:
>
> [24296.910574] cx23885 driver version 0.0.2 loaded
> [24296.910612] cx23885 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [24296.910620] cx23885[0]: Your board isn't known (yet) to the driver.
> [24296.910621] cx23885[0]: Try to pick one of the existing card configs via
> [24296.910623] cx23885[0]: card=<n> insmod option.  Updating to the latest
> [24296.910625] cx23885[0]: version might help as well.
> [...]
> [24296.911165] CORE cx23885[0]: subsystem: 0070:53f1, board: UNKNOWN/GENERIC [card=0,autodetected]
> [24297.037221] cx23885_dev_checkrevision() Hardware revision = 0xd0
> [24297.037228] cx23885[0]/0: found at 0000:01:00.0, rev: 4, irq: 16, latency: 0, mmio: 0xfe400000
> [24297.037236] cx23885 0000:01:00.0: setting latency timer to 64
> [24297.037304] cx23885 0000:01:00.0: irq 48 for MSI/MSI-X
>
> Seems like some work is necessary to do here, which I'd be willing to do.
> Can anyone suggest which might be the most similar card or what I should try
> to write a driver for this?

Hi Steve,

Like the 4400 and 5500, the 3300 uses both DVB-S and DVB-T demodulator
chips for which there is currently no driver.  Somebody would have to
write those drivers from
scratch in order for any of those products to be supported.

In other words, it's not a case of just needing to add a few lines of
code for another board profile.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
