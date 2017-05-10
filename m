Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:58468 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751735AbdEJJ6P (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 May 2017 05:58:15 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: <zhaoxuegang@suntec.net>
Cc: linux-media <linux-media@vger.kernel.org>,
        "Ezequiel Garcia" <ezequiel@vanguardiasur.com.ar>
Subject: Re: [PCIE device driver: tw686x]   I have some problems with tw686x and I need help.
References: <590ADAB1.1040501@suntec.net>
Date: Wed, 10 May 2017 11:48:38 +0200
In-Reply-To: <590ADAB1.1040501@suntec.net> (zhaoxuegang@suntec.net's message
        of "Thu, 04 May 2017 15:39:31 +0800")
Message-ID: <m3h90thwjt.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Singh,

I've added linux-media as well as the current TW686x driver maintainer
to Cc: list. Perhaps they will be better prepared to help you, the
driver differs much from what it was when I originally wrote it.

<zhaoxuegang@suntec.net> writes:

> First, I download source code from website
> https://github.com/torvalds/linux/tree/master/drivers/media/pci/tw686x,
> build the driver in my project. when i start the machine the machine
> printk the log
> "[ 5.557782] tw6869: PCI 0000:01:00.0, IRQ 170, MMIO 0xc8000000 (memcpy mode)
> [ 5.565010] tw686x 0000:01:00.0: enabling device (0000 -> 0002)".
> from the log we can see that pcie-bus read the ID is 6869, but out
> chip is tw6865. this is not our main problem.

The truth is I don't have a real TW6865, I simply assumed its PCI ID
would be 0x6865 because it worked this way for TW6864 and TW6869.
Could you please do a "lspci -vvn" on the machine with this card and
send me (with CC: linux-media@vger.kernel.org) this command's output
(you may omit other devices, I'm only interested in the TW chip
information). Perhaps the invalid identification can be fixed.

Thanks.

> After we booted the machine. then we lunch out application to display
> video that we capture from tw6865. But there are a lot of log , such
> as
> "[ 24.671551] tw686x 0000:01:00.0: video10: unexpected p-b buffer!
> [ 24.671561] tw686x 0000:01:00.0: video11: unexpected p-b buffer!
> [ 24.671566] tw686x 0000:01:00.0: video12: unexpected p-b buffer!
> [ 24.671570] tw686x 0000:01:00.0: video13: unexpected p-b buffer!"
> and the log print always.
> those log means tw6865 always reset dma channel.
> sometimes we can see the right picture, but the video moves slowly, about 2 frame per 5 seconds.
> after a few minute, the linux kernel crashed. I post the crash log
> below.

Unfortunately there is no meaningful stack dump. Perhaps the crashes
will go away when the "unexpected p-b buffer" issue is fixed so I
wouldn't worry too much about the dumps at the moment.

> Sometimes, after I booted the machine, and lunched the application. To
> the begin, we can see a few frame displaying on screen. after a few
> seconds, the monitor are freezed. and I use "cat /proc/interrupts" to
> look up tw6865's interrput. and we find that there is no tw6865
> interrupt any more. after a few minutes, most probely the machine will
> crash and reboot(crash log is same with the before which I have
> posted).
> we use command "dmesg" to look up log. we found that there ever
> happend "tw686x 0000:01:00.0: video10: FIFO error" or "we found that
> there ever happend" frequently.

This could be caused by the invalid identification (and handling) of
the chip.

OTOH, the "memcpy" mode of this driver may be too slow on your machine
(ARM usually doesn't have hardware-coherent cache memory and certain
cache sync operations are apparently very slow). You may want to try the
DMA mode instead (modprobe tw686x dma_mode=contig or sg). Be aware that
the DMA modes aren't as flexible as memcpy mode, the frame formats are
more limited.

I don't have experience with any ARM64, though.

Also I think the current code will OOPS on any video initialization
error (which will most probably happen on ARM in contig mode because
ARM machines don't allow that much continuous allocation). At least this
can be easily fixed, I'll attach the patch.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
