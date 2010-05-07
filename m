Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailhost-r0-p2.netultra.net ([195.5.209.64]:50532 "EHLO
	smtp-delay1.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750821Ab0EGNtv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 May 2010 09:49:51 -0400
Received: from maiev.nerim.net (smtp-119-friday.nerim.net [62.4.16.119])
	by smtp-delay1.nerim.net (Postfix) with ESMTP id 2E9D9B418DF
	for <linux-media@vger.kernel.org>; Fri,  7 May 2010 15:49:48 +0200 (CEST)
Received: from logiways.com (mail.logiways.com [194.79.150.130])
	by maiev.nerim.net (Postfix) with ESMTP id D7446B8E18
	for <linux-media@vger.kernel.org>; Fri,  7 May 2010 15:49:26 +0200 (CEST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: cx88 pci_abort errors (Hauppauge WinTV Nova-HD-S2)
Date: Fri, 7 May 2010 15:49:04 +0200
Message-ID: <91E6C7608D34E145A3D9634F0ED7163E887E38@venus.logiways-france.fr>
In-Reply-To: <91E6C7608D34E145A3D9634F0ED7163E887DB7@venus.logiways-france.fr>
References: <91E6C7608D34E145A3D9634F0ED7163E81D787@venus.logiways-france.fr> <4BE31163.90505@whitelands.org.uk> <91E6C7608D34E145A3D9634F0ED7163E887DB7@venus.logiways-france.fr>
From: "Thierry LELEGARD" <tlelegard@logiways.com>
To: <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without knowing if this is appropriate or not, as a test, I replaced
the 3 occurrences of "IRQF_SHARED | IRQF_DISABLED" by simply "IRQF_SHARED"
in cx88 driver.

The number of pci_abort was considerably reduced but I still get some.

Again, this was just a try, not a patch proposal. And it seems not to
be a final solution, but it just changed the behavior a little bit.

Any other idea ?

-Thierry

> -----Message d'origine-----
> De : linux-media-owner@vger.kernel.org [mailto:linux-media-owner@vger.kernel.org] De la part de
> Thierry LELEGARD
> Envoyé : vendredi 7 mai 2010 11:38
> À : Paul Shepherd; linux-media@vger.kernel.org
> Objet : RE: cx88 pci_abort errors (Hauppauge WinTV Nova-HD-S2)
> 
> Hi,
> 
> The firmware version can be seen using dmesg the first time
> the tuner is actually used after power up. From dmesg:
> 
> cx24116_firmware_ondemand: Waiting for firmware upload (dvb-fe-cx24116.fw)...
> cx88-mpeg driver manager 0000:05:05.2: firmware: requesting dvb-fe-cx24116.fw
> cx24116_firmware_ondemand: Waiting for firmware upload(2)...
> cx24116_load_firmware: FW version 1.26.90.0
> cx24116_firmware_ondemand: Firmware upload complete
> 
> By removing or swapping cards on the PCI bus, I can see that
> the number of "cx88[0]: irq mpeg [0x80000] pci_abort" varies.
> From once every 10 seconds, at best, to once per second, at
> worst.
> 
> The following message can be interesting:
> IRQ 17/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> 
> After some googling, I saw messages mentioning that this kind
> of message can be the symptom of unexpected behaviors. Could
> this explain the pci_abort ?
> 
> Also, some messages suggest that a driver code should not
> request both IRQF_DISABLED and IRQF_SHARED. In the complete
> v4l-dvb source code, this combination is found only 20 times,
> in 12 drivers, including the cx88.
> 
> Could this be a problem in the driver ?
> 
> -Thierry
> 
> > -----Message d'origine-----
> > De : Paul Shepherd [mailto:paul@whitelands.org.uk]
> > Envoyé : jeudi 6 mai 2010 20:59
> > À : linux-media@vger.kernel.org
> > Cc : Thierry LELEGARD
> > Objet : Re: cx88 pci_abort errors (Hauppauge WinTV Nova-HD-S2)
> >
> >
> > On 06/05/2010 16:01, Thierry LELEGARD wrote:
> >
> > >
> > > I recently added a Hauppauge WinTV Nova-HD-S2 into a Linux system.
> > > I experience frequent packet loss and pci_abort errors.
> > >
> > > Each time my application detects packet loss (continuity errors
> > > actually), I get the following messages in dmesg:
> > >
> > > cx88[0]: irq mpeg  [0x80000] pci_abort*
> > > cx88[0]/2-mpeg: general errors: 0x00080000
> > >
> > > Such problems occur every few seconds.
> > >
> > > I use firmware file dvb-fe-cx24116.fw version 1.26.90.0.
> > >
> > > Since the IRQ was shared with the nVidia card and a Dektec modulator,
> > > I swapped some PCI boards. The IRQ is still shared but with another
> > > Tuner I do not use when using the S2 tuner. After swapping the PCI
> > > boards, the errors occur less frequently but still happen.
> > >
> > > Assuming that the pci_abort was due to an interrupted DMA transfer, I
> > > tried to increase the PCI latency timer of the device to 248 but this
> > > did not change anything (setpci -s 05:05 latency_timer=f8).
> > >
> > > I use the tuner with a custom application which reads the complete
> > > Transport stream. This application had worked for years using DVB-T
> > > and DVB-S tuners. I tried to reduce the application read buffer
> > > input size and it did not change anything at all.
> > >
> > > Note that my application still uses the V3 API, not the S2API. But,
> > > using DVB-S transponders, it works (except the pci_abort errors).
> > >
> > > I disabled the serial port, the parallel port and the PS/2 ports in the
> > > BIOS. It did not change anything either.
> > >
> > > Does anyone have an idea, please?
> > > Thanks a lot in advance for any help.
> > > -Thierry
> >
> > I have the board working in a Ubuntu 9.10 system, log below shows no pci
> > errors:
> >
> > > Apr 21 18:32:11 antec300 kernel: [   16.576416] cx88/2: cx2388x MPEG-TS Driver Manager version
> 0.0.7
> > loaded
> > > Apr 21 18:32:11 antec300 kernel: [   16.576711] cx88[0]: subsystem: 0070:6906, board: Hauppauge
> > WinTV-HVR4000(Lite) DVB-S/S2 [card=69,autodetected], frontend(s): 1
> > > Apr 21 18:32:11 antec300 kernel: [   16.576714] cx88[0]: TV tuner type -1, Radio tuner type -1
> > > Apr 21 18:32:11 antec300 kernel: [   16.583565] cx88/0: cx2388x v4l2 driver version 0.0.7 loaded
> > > Apr 21 18:32:11 antec300 kernel: [   16.586270] cx2388x alsa driver version 0.0.7 loaded
> > > Apr 21 18:32:11 antec300 kernel: [   16.605679] EXT4-fs (sda1): internal journal on sda1:8
> > > Apr 21 18:32:11 antec300 kernel: [   16.755834] EXT4-fs (sdc1): barriers enabled
> > > Apr 21 18:32:11 antec300 kernel: [   16.757791] kjournald2 starting: pid 956, dev sdc1:8, commit
> > interval 5 seconds
> > > Apr 21 18:32:11 antec300 kernel: [   16.763057] EXT4-fs (sdc1): internal journal on sdc1:8
> > > Apr 21 18:32:11 antec300 kernel: [   16.763061] EXT4-fs (sdc1): delayed allocation enabled
> > > Apr 21 18:32:11 antec300 kernel: [   16.763063] EXT4-fs: file extents enabled
> > > Apr 21 18:32:11 antec300 kernel: [   16.789147] EXT4-fs: mballoc enabled
> > > Apr 21 18:32:11 antec300 kernel: [   16.789163] EXT4-fs (sdc1): mounted filesystem with ordered
> data
> > mode
> > > Apr 21 18:32:11 antec300 kernel: [   16.795868] tveeprom 2-0050: Hauppauge model 69100, rev B4C3,
> > serial# 7084390
> > > Apr 21 18:32:11 antec300 kernel: [   16.795871] tveeprom 2-0050: MAC address is 00:0d:fe:6c:19:66
> > > Apr 21 18:32:11 antec300 kernel: [   16.795874] tveeprom 2-0050: tuner model is Conexant CX24118A
> > (idx 123, type 4)
> > > Apr 21 18:32:11 antec300 kernel: [   16.795876] tveeprom 2-0050: TV standards ATSC/DVB Digital
> > (eeprom 0x80)
> > > Apr 21 18:32:11 antec300 kernel: [   16.795878] tveeprom 2-0050: audio processor is None (idx 0)
> > > Apr 21 18:32:11 antec300 kernel: [   16.795880] tveeprom 2-0050: decoder processor is CX880 (idx
> 20)
> > > Apr 21 18:32:11 antec300 kernel: [   16.795882] tveeprom 2-0050: has no radio, has IR receiver,
> has
> > no IR transmitter
> > > Apr 21 18:32:11 antec300 kernel: [   16.795884] cx88[0]: hauppauge eeprom: model=69100
> > > Apr 21 18:32:11 antec300 kernel: [   16.798457] input: cx88 IR (Hauppauge WinTV-HVR400 as
> > /devices/pci0000:00/0000:00:1e.0/0000:06:02.2/input/input6
> > > Apr 21 18:32:11 antec300 kernel: [   16.798488] cx88[0]/2: cx2388x 8802 Driver Manager
> > > Apr 21 18:32:11 antec300 kernel: [   16.798500] cx88-mpeg driver manager 0000:06:02.2: PCI INT A -
> >
> > GSI 19 (level, low) -> IRQ 19
> > > Apr 21 18:32:11 antec300 kernel: [   16.798506] cx88[0]/2: found at 0000:06:02.2, rev: 5, irq: 19,
> > latency: 32, mmio: 0xf8000000
> > > Apr 21 18:32:11 antec300 kernel: [   16.798510] IRQ 19/cx88[0]: IRQF_DISABLED is not guaranteed on
> > shared IRQs
> > > Apr 21 18:32:11 antec300 kernel: [   16.799143] cx8800 0000:06:02.0: PCI INT A -> GSI 19 (level,
> > low) -> IRQ 19
> > > Apr 21 18:32:11 antec300 kernel: [   16.799151] cx88[0]/0: found at 0000:06:02.0, rev: 5, irq: 19,
> > latency: 32, mmio: 0xfa000000
> > > Apr 21 18:32:11 antec300 kernel: [   16.799158] IRQ 19/cx88[0]: IRQF_DISABLED is not guaranteed on
> > shared IRQs
> > > Apr 21 18:32:11 antec300 kernel: [   16.799193] cx88[0]/0: registered device video0 [v4l2]
> > > Apr 21 18:32:11 antec300 kernel: [   16.799210] cx88[0]/0: registered device vbi0
> > > Apr 21 18:32:11 antec300 kernel: [   16.802095] cx88_audio 0000:06:02.1: PCI INT A -> GSI 19
> (level,
> > low) -> IRQ 19
> > > Apr 21 18:32:11 antec300 kernel: [   16.802102] IRQ 19/cx88[0]: IRQF_DISABLED is not guaranteed on
> > shared IRQs
> > > Apr 21 18:32:11 antec300 kernel: [   16.802122] cx88[0]/1: CX88x/0: ALSA support for cx2388x
> boards
> > > Apr 21 18:32:11 antec300 kernel: [   17.166889] cx88/2: cx2388x dvb driver version 0.0.7 loaded
> > > Apr 21 18:32:11 antec300 kernel: [   17.166893] cx88/2: registering cx8802 driver, type: dvb
> access:
> > shared
> > > Apr 21 18:32:11 antec300 kernel: [   17.166897] cx88[0]/2: subsystem: 0070:6906, board: Hauppauge
> > WinTV-HVR4000(Lite) DVB-S/S2 [card=69]
> > > Apr 21 18:32:11 antec300 kernel: [   17.166902] cx88[0]/2: cx2388x based DVB/ATSC card
> > > Apr 21 18:32:11 antec300 kernel: [   17.166905] cx8802_alloc_frontends() allocating 1 frontend(s)
> >
> > Not sure which .fw file was loaded (it just worked).  If you would like
> > further info let me know.
> >
> > paul
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
