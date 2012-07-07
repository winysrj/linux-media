Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36749 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab2GGK2b (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jul 2012 06:28:31 -0400
Received: by obbuo13 with SMTP id uo13so16616539obb.19
        for <linux-media@vger.kernel.org>; Sat, 07 Jul 2012 03:28:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPHtXi1f=iVWPjx6xFw20xath+7fe-rHobaYHnMiS1OEaqKWKA@mail.gmail.com>
References: <CAPHtXi1nVStCzq+h1Kd_TWefNBTdBc18giWCwH3dBygsVgnqKw@mail.gmail.com>
 <CAPHtXi1f=iVWPjx6xFw20xath+7fe-rHobaYHnMiS1OEaqKWKA@mail.gmail.com>
From: Leyorus <leyorus@gmail.com>
Date: Sat, 7 Jul 2012 12:28:10 +0200
Message-ID: <CAPHtXi3tfnLK2cmfQf+7MoqLr32wu26Yw8uSKzDUc1yK9LhXBw@mail.gmail.com>
Subject: Re: TERRATEC Cinergy T PCIE dual remote control support ?
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No news for this problem ? Nobody has an idea to make the remote control work ?

Thanks in advance !


2012/6/17 Leyorus <leyorus@gmail.com>
>
> Hello everybody !
>
> First of all, i would like to thank you all for your wonderful work.
> Thanks to you, my new Terratec Cinergy T PCIE dual card is now
> receiving TV on my linux HTPC.
>
> The only remaining thing that is not working is the remote control (not at
> all).
> This remote control seems to be the same as a Cinergy HTC USB XS. It
> can be seen on image
> http://www.terratec.net/us/produits/photos/img/3923630_4ac1bb0a60.png
> So the mapping is probably the same as a Cinergy XS product.
>
> In fact, when the cx23885 module driver is loaded, no ir input is
> associated with the card nor created in /dev/input.
>
> Here is the output of dmesg when inserting the cx23885 module in the
> kernel :
>
> [ 9321.995048] cx23885 driver version 0.0.3 loaded
> [ 9321.999469] CORE cx23885[0]: subsystem: 153b:117e, board: TerraTec
> Cinergy T PCIe Dual [card=34,autodetected]
> [ 9322.130326] cx25840 5-0044: cx23885 A/V decoder found @ 0x88
> (cx23885[0])
> [ 9322.755350] cx25840 5-0044: loaded v4l-cx23885-avcore-01.fw
> firmware (16382 bytes)
> [ 9322.788281] cx23885_dvb_register() allocating 1 frontend(s)
> [ 9322.788285] cx23885[0]: cx23885 based dvb card
> [ 9322.803661] drxk: status = 0x639160d9
> [ 9322.803666] drxk: detected a drx-3916k, spin A3, xtal 20.250 MHz
> [ 9322.876517] DRXK driver version 0.9.4300
> [ 9322.900430] drxk: frontend initialized.
> [ 9322.900449] mt2063_attach: Attaching MT2063
> [ 9322.900451] DVB: registering new adapter (cx23885[0])
> [ 9322.900454] DVB: registering adapter 0 frontend 0 (DRXK DVB-T)...
> [ 9322.901581] cx23885_dvb_register() allocating 1 frontend(s)
> [ 9322.901586] cx23885[0]: cx23885 based dvb card
> [ 9322.916744] drxk: status = 0x639130d9
> [ 9322.916749] drxk: detected a drx-3913k, spin A3, xtal 20.250 MHz
> [ 9322.989590] DRXK driver version 0.9.4300
> [ 9323.013545] drxk: frontend initialized.
> [ 9323.013567] mt2063_attach: Attaching MT2063
> [ 9323.013570] DVB: registering new adapter (cx23885[0])
> [ 9323.013573] DVB: registering adapter 1 frontend 0 (DRXK DVB-C DVB-T)...
> [ 9323.013955] cx23885_dev_checkrevision() Hardware revision = 0xa5
> [ 9323.013961] cx23885[0]/0: found at 0000:02:00.0, rev: 4, irq: 16,
> latency: 0, mmio: 0xfd800000
>
> Any ideas on how to make the ir receiver recognized and work ?
