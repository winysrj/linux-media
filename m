Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:55327 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756602Ab3CFN6P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Mar 2013 08:58:15 -0500
Message-ID: <51374B6D.9010805@schinagl.nl>
Date: Wed, 06 Mar 2013 14:58:05 +0100
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Linux Media <linux-media@vger.kernel.org>
Subject: Re: TerraTec Cinergy T PCIe Dual not working
References: <20130306142713.6a68179a@endymion.delvare>
In-Reply-To: <20130306142713.6a68179a@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have the same card, and have not much problems. I have some reception 
issues, but I don't think it's to blame on the card (yet). I do use 
tvheadend however.

In anycase, can you use w_scan or dvb-scan?

On 06-03-13 14:27, Jean Delvare wrote:
> Hi all,
>
> I have a TerraTec Cinergy T PCIe Dual card and I can't get it to work.
> I had been using it several months ago, with some success, although the
> stability wasn't ideal. Then I moved it to another machine to check if
> it was any better on Windows (and indeed it was better.) Now I put it
> back in my system and I can't get it to work at all.
>
> I have the following relevant kernel log messages:
>
> [    0.362783] pci 0000:0b:00.0: [14f1:8852] type 00 class 0x040000
> [    0.362809] pci 0000:0b:00.0: reg 10: [mem 0xfbc00000-0xfbdfffff 64bit]
> [    0.362940] pci 0000:0b:00.0: supports D1 D2
> [    0.362942] pci 0000:0b:00.0: PME# supported from D0 D1 D2 D3hot
> [    0.362967] pci 0000:0b:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
> [    6.313259] cx23885 driver version 0.0.3 loaded
> [    6.313898] CORE cx23885[0]: subsystem: 153b:117e, board: TerraTec Cinergy T PCIe Dual [card=34,autodetected]
> [    6.498999] cx25840 11-0044: cx23885 A/V decoder found @ 0x88 (cx23885[0])
> [    7.114399] cx25840 11-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382 bytes)
> [    7.150641] cx23885_dvb_register() allocating 1 frontend(s)
> [    7.150704] cx23885[0]: cx23885 based dvb card
> [    7.178681] drxk: status = 0x639160d9
> [    7.180049] drxk: detected a drx-3916k, spin A3, xtal 20.250 MHz
> [    7.245259] DRXK driver version 0.9.4300
> [    7.268760] drxk: frontend initialized.
> [    7.961207] mt2063_attach: Attaching MT2063
> [    7.961271] DVB: registering new adapter (cx23885[0])
> [    7.961332] DVB: registering adapter 0 frontend 0 (DRXK DVB-T)...
> [    7.961877] cx23885_dvb_register() allocating 1 frontend(s)
> [    7.961881] cx23885[0]: cx23885 based dvb card
> [    7.974320] drxk: status = 0x639130d9
> [    7.975838] drxk: detected a drx-3913k, spin A3, xtal 20.250 MHz
> [    8.040888] DRXK driver version 0.9.4300
> [    8.064459] drxk: frontend initialized.
> [    8.064467] mt2063_attach: Attaching MT2063
> [    8.064475] DVB: registering new adapter (cx23885[0])
> [    8.064482] DVB: registering adapter 1 frontend 0 (DRXK DVB-C DVB-T)...
> [    8.065919] cx23885_dev_checkrevision() Hardware revision = 0xa5
> [    8.066004] cx23885[0]/0: found at 0000:0b:00.0, rev: 4, irq: 28, latency: 0, mmio: 0xfbc00000
> [   27.281490] mt2063: detected a mt2063 B3
> [   27.319390] mt2063: detected a mt2063 B3
>
> I don't see anything wrong here, all the components are apparently
> found and identified properly. However I can't get the card to actually
> work, neither in me-tv nor in VLC.
>
> Me-tv (version 1.3.6) tells me:
> 03/06/13 14:20:10: Device: 'DRXK DVB-T' (DVB-T) at "/dev/dvb/adapter0/frontend0"
> 03/06/13 14:20:11: Device: 'DRXK DVB-C DVB-T' (DVB-C) at "/dev/dvb/adapter1/frontend0"
> 03/06/13 14:20:11: Frontend::tune_to(490000000)
> 03/06/13 14:20:11: Waiting for signal lock ...
> And then "Failed to lock channel".
>
> VLC (version 2.0.5) tells me:
> main stream error: cannot pre fill buffer
>
> I tried with kernels 3.4.30, 3.5.7, 3.6.0, 3.6.11, 3.7.10 and 3.8.2, with
> exactly the same results.
>
> How would I debug this further?
>
> Thanks,

