Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:62557 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758890AbZDBSvQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Apr 2009 14:51:16 -0400
Received: from abadon.pezed.lan ([76.177.10.171])
          by cdptpa-omta04.mail.rr.com with ESMTP
          id <20090402185113.PJRF28081.cdptpa-omta04.mail.rr.com@abadon.pezed.lan>
          for <linux-media@vger.kernel.org>; Thu, 2 Apr 2009 18:51:13 +0000
From: Mark Stocker <mark@ale8.org>
To: linux-media@vger.kernel.org
Subject: Re: Wintv-1250 - EEPROM decoding - V4L DVB
Date: Thu, 2 Apr 2009 14:51:11 -0400
References: <49CFC642.3030408@videotron.ca> <49D2A608.2070400@videotron.ca> <49D4CF18.3060807@linuxtv.org>
In-Reply-To: <49D4CF18.3060807@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904021451.11746.mark@ale8.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have rev E1D9.  Below is my dmesg output after applying the same change as Michel had shown.


[  466.833952] cx23885 driver version 0.0.1 loaded
[  466.833979] cx23885 0000:03:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[  466.833981] cx23885[0]/0: cx23885_dev_setup() Memory configured for PCIe bridge type 885
[  466.833982] cx23885[0]/0: cx23885_init_tsport(portno=2)
[  466.834054] CORE cx23885[0]: subsystem: 0070:7911, board: Hauppauge WinTV-HVR1250 [card=3,autodetected]
[  466.834055] cx23885[0]/0: cx23885_pci_quirks()
[  466.834057] cx23885[0]/0: cx23885_dev_setup() tuner_type = 0x0 tuner_addr = 0x0
[  466.834059] cx23885[0]/0: cx23885_dev_setup() radio_type = 0x0 radio_addr = 0x0
[  466.834059] cx23885[0]/0: cx23885_reset()
[  466.934080] cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [VID A]
[  466.934091] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch2]
[  466.934092] cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [TS1 B]
[  466.934106] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch4]
[  466.934107] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch5]
[  466.934108] cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [TS2 C]
[  466.934122] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch7]
[  466.934123] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch8]
[  466.934125] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch9]
[  466.961642] tveeprom 1-0050: Hauppauge model 79001, rev E1D9, serial# 3450857
[  466.961645] tveeprom 1-0050: MAC address is 00-0D-FE-34-A7-E9
[  466.961646] tveeprom 1-0050: tuner model is Microtune MT2131 (idx 139, type 4)
[  466.961648] tveeprom 1-0050: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)
[  466.961649] tveeprom 1-0050: audio processor is CX23885 (idx 39)
[  466.961650] tveeprom 1-0050: decoder processor is CX23885 (idx 33)
[  466.961651] tveeprom 1-0050: has no radio, has IR receiver, has no IR transmitter
[  466.961652] cx23885[0]: hauppauge eeprom: model=79001
[  466.961654] cx23885_dvb_register() allocating 1 frontend(s)
[  466.962728] cx23885[0]: cx23885 based dvb card
[  466.991727] MT2131: successfully identified at address 0x61
[  466.991730] DVB: registering new adapter (cx23885[0])
[  466.991732] DVB: registering adapter 0 frontend -1601531515 (Samsung S5H1409 QAM/8VSB Frontend)...
[  466.992748] cx23885_dev_checkrevision() Hardware revision = 0xc0
[  466.992754] cx23885[0]/0: found at 0000:03:00.0, rev: 3, irq: 19, latency: 0, mmio: 0xea000000
[  466.992761] cx23885 0000:03:00.0: setting latency timer to 64

On Thursday April 02 2009 10:43:36 am Steven Toth wrote:
> Michel Dansereau wrote:
> > Steve,
> >    Point taken about dropping the mailing list.
> >    Thanks!
> > Michel
>
> Thanks, one last question.
>
> Look a the white Hauppauge label on the HVR-1250 tuner, its should say
> something like Rev NNNN.
>
> What is your rev?
>
> - Steve
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


