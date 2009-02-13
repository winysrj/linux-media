Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f222.google.com ([209.85.217.222]:62354 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbZBMVOz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2009 16:14:55 -0500
Received: by gxk22 with SMTP id 22so1192105gxk.13
        for <linux-media@vger.kernel.org>; Fri, 13 Feb 2009 13:14:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <BAY102-W4373037E0F62A04672AC72CFB80@phx.gbl>
References: <BAY102-W4373037E0F62A04672AC72CFB80@phx.gbl>
Date: Fri, 13 Feb 2009 16:09:22 -0500
Message-ID: <412bdbff0902131309i169884bambd1ddb8adf9f90e5@mail.gmail.com>
Subject: =?windows-1256?Q?Re=3A_HVR=2D1500_tuner_seems_to_be_recognized=2C_but_wont_?=
	=?windows-1256?Q?turn_on=2E=FE?=
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Thomas Nicolai <nickotym@hotmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/2/13 Thomas Nicolai <nickotym@hotmail.com>:
>
> Third time is  the charm, had tried posting before, but was in HTML.  Hope it doesn't double post for anyone.
>
>
> I am hoping this problem has already been solved, but I couldn't find anything mentioned in the archives going back a while.
>
> I am running Kubuntu 8.10 with 2.6.27-11-generic on a Toshiba laptop with dual AMD 64 processors.
>
> I
> installed the drivers from the non-experimental ones at www.linuxtv.org
> using mercurial and that helped with some problems.  However, the tuner
> is now recognized, but can't seem to turn on when called for by MythTV
> or dvbscan.
>
>  Partial Results of dmesg follow:
>
> [ 2627.107174] firmware: requesting xc3028-v27.fw
> [ 2627.147757] xc2028 2-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
> [ 2627.347546] xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
> [ 2627.870877] xc2028 2-0061: i2c output error: rc = -5 (should be 4)
> [ 2627.870886] xc2028 2-0061: -5 returned from send
> [ 2627.870890] xc2028 2-0061: Error -22 while loading base firmware
> [ 2628.122478] xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
> [ 2628.645956] xc2028 2-0061: i2c output error: rc = -5 (should be 4)
> [ 2628.645962] xc2028 2-0061: -5 returned from send
> [ 2628.645965] xc2028 2-0061: Error -22 while loading base firmware
> [ 2629.845869] xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
> [ 2630.368229] xc2028 2-0061: i2c output error: rc = -5 (should be 4)
> [ 2630.368235] xc2028 2-0061: -5 returned from send
> [ 2630.368239] xc2028 2-0061: Error -22 while loading base firmware
> [ 2630.622469] xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
> [ 2631.144810] xc2028 2-0061: i2c output error: rc = -5 (should be 4)
> [ 2631.144818] xc2028 2-0061: -5 returned from send
> [ 2631.144820] xc2028 2-0061: Error -22 while loading base firmware
> [ 2632.150462] xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
> [ 2632.679257] xc2028 2-0061: i2c output error: rc = -5 (should be 4)
> [ 2632.679266] xc2028 2-0061: -5 returned from send
> [ 2632.679270] xc2028 2-0061: Error -22 while loading base firmware
> [ 2632.930465] xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
> [ 2634.086084] xc2028 2-0061: Loading firmware for type=D2633 DTV6 ATSC (10030), id 0000000000000000.
>
>
> lspci -vnn results (partial):
>
> 01:05.0
> VGA compatible controller [0300]: ATI Technologies Inc RS690M [Radeon
> X1200 Series]
> [1002:791f]
>        Subsystem: Toshiba America Info Systems Device [1179:ff00]
>        Flags: bus master, fast devsel, latency 64, IRQ 18
>        Memory at f0000000 (64-bit, prefetchable) [size=128M]
>        Memory at f8300000 (64-bit, non-prefetchable) [size=64K]
>        I/O ports at 9000 [size=256]
>        Memory at f8200000 (32-bit, non-prefetchable) [size=1M]
>        Capabilities:
>
> 0b:00.0
> Multimedia video controller [0400]: Conexant Systems, Inc. CX23885 PCI
> Video and Audio Decoder [14f1:8852] (rev
> 02)
>        Subsystem: Hauppauge computer works Inc. Device [0070:7717]
>        Flags: bus master, fast devsel, latency 0, IRQ 17
>        Memory at f8000000 (64-bit, non-prefetchable) [size=2M]
>        Capabilities:
>        Kernel driver in use: cx23885
>        Kernel modules: cx23885
>
> Please let me know what else might be needed to solve this.
>
> Saw a link that recommended using v4l-dvb-experimental  drivers but wasn't sure if that was wise.
>
>
> Thanks,
>
> Nick

That looks really suspicious.  Perhaps the xc3028 tuner is being put
to sleep and not being woken up properly.

Could you please post the full dmesg output showing the initialization
of the device?

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
