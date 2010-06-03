Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp107.rog.mail.re2.yahoo.com ([68.142.225.205]:41378 "HELO
	smtp107.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750777Ab0FCEWZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Jun 2010 00:22:25 -0400
Message-ID: <4C072DFE.7000409@rogers.com>
Date: Thu, 03 Jun 2010 00:22:22 -0400
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org
Subject: Re: DNTV Dual Hybrid (7164) PCIe
References: <370023.77962.qm@web113202.mail.gq1.yahoo.com> <4C06FBAD.60304@macquarie.com>
In-Reply-To: <4C06FBAD.60304@macquarie.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Martin Brown wrote:
> I'm trying to get a driver working for this card under Ubuntu Lucid
> (10.04).
>
> I believe the card is based on the SAA7164 so I'm trying the
> kernellabs driver.
>
> Results of modprobe saa7164 are:
>
> /etc/modprobe.d/options.conf contains:
> options saa7164 card=4
>
>
> kernel: [ 159.091047] saa7164 driver loaded
> kernel: [ 159.091102] saa7164 0000:04:00.0: PCI INT A -> GSI 18
> (level, low) -> IRQ 18
> kernel: [ 159.091974] CORE saa7164[0]: subsystem: 107d:6f2c, board:
> Hauppauge WinTV-HVR2200 [card=4,insmod option]
> kernel: [ 159.091980] saa7164[0]/0: found at 0000:04:00.0, rev: 129,
> irq: 18, latency: 0, mmio: 0x93000000
> kernel: [ 159.135163] tveeprom 0-0000: Encountered bad packet header
> [00]. Corrupt or not a Hauppauge eeprom.
> kernel: [ 159.135168] saa7164[0]: Hauppauge eeprom: model=0
>
> That's it. Nothing more. No /dev/dvb/adpator... created.
>
> When /etc/modprobe.conf has:
> options saa7164 card=5 I get:
>
> kernel: [ 547.123384] saa7164 driver loaded
> kernel: [ 547.123435] saa7164 0000:04:00.0: PCI INT A -> GSI 18
> (level, low) -> IRQ 18
> kernel: [ 547.123614] CORE saa7164[0]: subsystem: 107d:6f2c, board:
> Hauppauge WinTV-HVR2200 [card=5,insmod option]
> kernel: [ 547.123619] saa7164[0]/0: found at 0000:04:00.0, rev: 129,
> irq: 18, latency: 0, mmio: 0x93000000
> kernel: [ 547.160228] tveeprom 0-0000: Encountered bad packet header
> [ff]. Corrupt or not a Hauppauge eeprom.
> kernel: [ 547.160233] saa7164[0]: Hauppauge eeprom: model=0
> kernel: [ 547.207655] tda18271 1-0060: creating new instance
> kernel: [ 547.211800] TDA18271HD/C2 detected @ 1-0060
> kernel: [ 547.469221] DVB: registering new adapter (saa7164)
> kernel: [ 547.469226] DVB: registering adapter 2 frontend 0 (NXP
> TDA10048HN DVB-T)...
>
> But only one /dev/dvb/adaptor created instead of 2 and I suspect the
> tveeprom error is fatal.
>
> Does anyone have any suggestions?
>
> Thanks,
> Martin
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Read the topmost note of:

http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers

Is your device in any way related to those two iterations of the
Hauppauge HVR-2200 model?

(http://linuxtv.org/hg/v4l-dvb/file/304cfde05b3f/linux/Documentation/video4linux/CARDLIST.saa7164)


