Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:34806 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab0ANPqL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 10:46:11 -0500
Received: by fxm25 with SMTP id 25so177781fxm.21
        for <linux-media@vger.kernel.org>; Thu, 14 Jan 2010 07:46:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B4F39BB.2060605@motama.com>
References: <4B4F39BB.2060605@motama.com>
Date: Thu, 14 Jan 2010 10:46:09 -0500
Message-ID: <829197381001140746g56c5ccf7mc7f6a631cb16e15d@mail.gmail.com>
Subject: Re: Order of dvb devices
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andreas Besse <besse@motama.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 14, 2010 at 10:35 AM, Andreas Besse <besse@motama.com> wrote:
> if a system contains multiple DVB cards of the same type, how is the
> order of devices determined by the driver/kernel?
>
> I use 2 Technotrend S2-3200 cards in a system and observerd that if I
> load the driver driver budget_ci manually as follows:
>
> modprobe budget_ci adapter_nr=0,1
>
> the device with the lower pci ID 0000:08:00.0 is assigned to adapter0 and the device with the higher pci ID 0000:08:01.0
> is assigned to adapter1:
>
>
> udevinfo -a -p $(udevinfo -q path -n /dev/dvb/adapter0/frontend0)
> [...]
>  looking at parent device '/devices/pci0000:00/0000:00:1e.0/0000:08:00.0':
>    KERNELS=="0000:08:00.0"
>    SUBSYSTEMS=="pci"
>
>
> udevinfo -a -p $(udevinfo -q path -n /dev/dvb/adapter1/frontend0)
> [...]
>  looking at parent device '/devices/pci0000:00/0000:00:1e.0/0000:08:01.0':
>    KERNELS=="0000:08:01.0"
>    SUBSYSTEMS=="pci"
>
>
> Is it true for all DVB drives that the device with the lower PCI id gets the lower adapter name?

No, you cannot really make this assumption.  In fact, there are users
who see behavior where uses have two of the same card and the cards
get flipped around randomly just by rebooting.  The ordering is based
on the timing of the device driver loading, so it is not
deterministic.

I believe you can use udev rules though to force a particular driver
to get a specific adapter number (although admittedly I do not know
the specifics of how it is done, and am not confident it *can* be done
if both cards are the same vendor/model).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
