Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:40095 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbaAUJ2v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jan 2014 04:28:51 -0500
Received: by mail-wg0-f47.google.com with SMTP id m15so7658135wgh.2
        for <linux-media@vger.kernel.org>; Tue, 21 Jan 2014 01:28:50 -0800 (PST)
Received: from [192.168.254.97] (host86-168-174-189.range86-168.btcentralplus.com. [86.168.174.189])
        by mx.google.com with ESMTPSA id 12sm6599717wjm.10.2014.01.21.01.28.49
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 21 Jan 2014 01:28:49 -0800 (PST)
Subject: Re: Conexant PCI-8604PW 4 channel BNC Video capture card (bttv)
References: <52DD977E.3000907@googlemail.com> <1c25db0a-f11f-4bc0-b544-692140799b2a@email.android.com>
From: Robert Longbottom <rongblor@googlemail.com>
Content-Type: text/plain;
	charset=us-ascii
In-Reply-To: <1c25db0a-f11f-4bc0-b544-692140799b2a@email.android.com>
Message-Id: <7D00B0B1-8873-4CB2-903F-8B98749C75FF@googlemail.com>
Date: Tue, 21 Jan 2014 09:27:38 +0000
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (1.0)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 20 Jan 2014, at 10:55 PM, Andy Walls <awalls@md.metrocast.net> wrote:

> Robert Longbottom <rongblor@googlemail.com> wrote:
>> 
>> Hi,
>> 
>> I've just bought one of these cards which is based on the Conexant
>> Fusion 878A chip thinking it would just work under Linux being
>> bttv-based.  Unfortunately (for me) it's not and it is just picked up
>> as
>> a generic unknown card by the bttv driver.
>> 
>> Does anyone have one of these that is working, or have any pointers to
>> what I can try to make it work?  I've had a go manually specifying
>> card=
>> as a module option for a couple of the existing cards that also use the
>> Conexant Fusion chip but neither work (BTTV_BOARD_PICOLO_TETRA_CHIP and
>> BTTV_BOARD_GEOVISION_GV800S).
>> 
>> When I start up xawtv and switch to framegrabber mode I just get lots
>> of
>> errors in /var/log/messages saying:
>> 
>> Jan 20 21:09:13 quad kernel: [ 2732.616016] bttv: 0: timeout: drop=0
>> irq=2998/35891, risc=339d5000, bits: HSYNC
>> Jan 20 21:09:13 quad kernel: [ 2733.122014] bttv: 0: timeout: drop=0
>> irq=3028/35952, risc=339d5000, bits: HSYNC
>> Jan 20 21:09:14 quad kernel: [ 2733.625018] bttv: 0: timeout: drop=0
>> irq=3058/36015, risc=339d5000, bits: HSYNC
>> Jan 20 21:09:14 quad kernel: [ 2734.127014] bttv: 0: timeout: drop=0
>> irq=3088/36077, risc=339d5000, bits: HSYNC
>> Jan 20 21:09:15 quad kernel: [ 2734.628014] bttv: 0: timeout: drop=0
>> irq=3118/36140, risc=339d5000, bits: HSYNC
>> 
>> Any help appreciated.  More info about the card below.
>> Thanks,
>> Rob.
>> 
>> Chips on card:
>> 
>> 4x Conexant Fusion 878A
>> 1x PCI6140-AA33PC
>> 1x SMD IC with no markings at all
>> Couple of 74HCTnnn chips
>> 1x Atmel 520
>> 1x 35.46895M Crystal
>> 
>> Result of modprobe bttv:
>> 
>> Jan 20 20:07:07 quad kernel: [ 8490.076924] bttv: driver version 0.9.19
>> loaded
>> Jan 20 20:07:07 quad kernel: [ 8490.076930] bttv: using 8 buffers with
>> 2080k (520 pages) each for capture
>> Jan 20 20:07:07 quad kernel: [ 8490.076983] bttv: Bt8xx card found (0)
>> Jan 20 20:07:07 quad kernel: [ 8490.077001] bttv: 0: Bt878 (rev 17) at
>> 0000:02:0c.0, irq: 16, latency: 32, mmio: 0xd5000000
>> Jan 20 20:07:07 quad kernel: [ 8490.077033] bttv: 0: using:  ***
>> UNKNOWN/GENERIC ***  [card=0,autodetected]
>> Jan 20 20:07:07 quad kernel: [ 8490.109816] bttv: 0: tuner type unset
>> Jan 20 20:07:07 quad kernel: [ 8490.110099] bttv: 0: registered device
>> video0
>> Jan 20 20:07:07 quad kernel: [ 8490.110485] bttv: 0: registered device
>> vbi0
>> Jan 20 20:07:07 quad kernel: [ 8490.114206] bttv: Bt8xx card found (1)
>> Jan 20 20:07:07 quad kernel: [ 8490.114228] bttv: 1: Bt878 (rev 17) at
>> 0000:02:0d.0, irq: 17, latency: 32, mmio: 0xd5002000
>> Jan 20 20:07:07 quad kernel: [ 8490.114279] bttv: 1: using:  ***
>> UNKNOWN/GENERIC ***  [card=0,autodetected]
>> Jan 20 20:07:07 quad kernel: [ 8490.116288] tveeprom 5-0050: Huh, no
>> eeprom present (err=-6)?
>> Jan 20 20:07:07 quad kernel: [ 8490.116296] bttv: 1: tuner type unset
>> Jan 20 20:07:07 quad kernel: [ 8490.116393] bttv: 1: registered device
>> video1
>> Jan 20 20:07:07 quad kernel: [ 8490.116589] bttv: 1: registered device
>> vbi1
>> Jan 20 20:07:07 quad kernel: [ 8490.120104] bttv: Bt8xx card found (2)
>> Jan 20 20:07:07 quad kernel: [ 8490.120135] bttv: 2: Bt878 (rev 17) at
>> 0000:02:0e.0, irq: 18, latency: 32, mmio: 0xd5004000
>> Jan 20 20:07:07 quad kernel: [ 8490.120165] bttv: 2: using:  ***
>> UNKNOWN/GENERIC ***  [card=0,autodetected]
>> Jan 20 20:07:07 quad kernel: [ 8490.121031] tveeprom 6-0050: Huh, no
>> eeprom present (err=-6)?
>> Jan 20 20:07:07 quad kernel: [ 8490.121035] bttv: 2: tuner type unset
>> Jan 20 20:07:07 quad kernel: [ 8490.121090] bttv: 2: registered device
>> video2
>> Jan 20 20:07:07 quad kernel: [ 8490.121226] bttv: 2: registered device
>> vbi2
>> Jan 20 20:07:07 quad kernel: [ 8490.124682] bttv: Bt8xx card found (3)
>> Jan 20 20:07:07 quad kernel: [ 8490.124714] bttv: 3: Bt878 (rev 17) at
>> 0000:02:0f.0, irq: 19, latency: 32, mmio: 0xd5006000
>> Jan 20 20:07:07 quad kernel: [ 8490.124744] bttv: 3: using:  ***
>> UNKNOWN/GENERIC ***  [card=0,autodetected]
>> Jan 20 20:07:07 quad kernel: [ 8490.125739] tveeprom 7-0050: Huh, no
>> eeprom present (err=-6)?
>> Jan 20 20:07:07 quad kernel: [ 8490.125745] bttv: 3: tuner type unset
>> Jan 20 20:07:07 quad kernel: [ 8490.125842] bttv: 3: registered device
>> video3
>> Jan 20 20:07:07 quad kernel: [ 8490.126063] bttv: 3: registered device
>> vbi3
>> Jan 20 20:07:07 quad kernel: [ 8490.130127] bttv: Bt8xx card found (4)
>> Jan 20 20:07:07 quad kernel: [ 8490.130151] bttv: 4: Bt878 (rev 17) at
>> 0000:03:04.0, irq: 17, latency: 32, mmio: 0xd5100000
>> Jan 20 20:07:07 quad kernel: [ 8490.130182] bttv: 4: detected: IVC-200
>> [card=102], PCI subsystem ID is 0000:a155
>> Jan 20 20:07:07 quad kernel: [ 8490.130186] bttv: 4: using: IVC-200
>> [card=102,autodetected]
>> Jan 20 20:07:07 quad kernel: [ 8490.130283] bttv: 4: tuner absent
>> Jan 20 20:07:07 quad kernel: [ 8490.130473] bttv: 4: registered device
>> video4
>> Jan 20 20:07:07 quad kernel: [ 8490.130512] bttv: 4: registered device
>> vbi4
>> Jan 20 20:07:07 quad kernel: [ 8490.130534] bttv: 4: Setting PLL:
>> 28636363 => 35468950 (needs up to 100ms)
>> Jan 20 20:07:07 quad kernel: [ 8490.136550] bttv: 4: Setting PLL:
>> 28636363 => 35468950 (needs up to 100ms)
>> Jan 20 20:07:07 quad kernel: [ 8490.139121] bttv: 4: Setting PLL:
>> 28636363 => 35468950 (needs up to 100ms)
>> Jan 20 20:07:07 quad kernel: [ 8490.141017] bttv: PLL set ok
>> 
>> result of lspci; I have another 4 input bttv based capture card
>> installed in this machine that works (an IVC-200G), hence 8 bt878
>> chips:
>> 
>> 00:00.0 Host bridge: NVIDIA Corporation MCP73 Host Bridge (rev a2)
>> 00:00.1 RAM memory: NVIDIA Corporation nForce 630i memory controller
>> (rev a2)
>> 00:01.0 RAM memory: NVIDIA Corporation nForce 630i memory controller
>> (rev a1)
>> 00:01.1 RAM memory: NVIDIA Corporation nForce 630i memory controller
>> (rev a1)
>> 00:01.2 RAM memory: NVIDIA Corporation nForce 630i memory controller
>> (rev a1)
>> 00:01.3 RAM memory: NVIDIA Corporation nForce 630i memory controller
>> (rev a1)
>> 00:01.4 RAM memory: NVIDIA Corporation nForce 630i memory controller
>> (rev a1)
>> 00:01.5 RAM memory: NVIDIA Corporation nForce 630i memory controller
>> (rev a1)
>> 00:01.6 RAM memory: NVIDIA Corporation nForce 630i memory controller
>> (rev a1)
>> 00:02.0 RAM memory: NVIDIA Corporation nForce 630i memory controller
>> (rev a1)
>> 00:03.0 ISA bridge: NVIDIA Corporation MCP73 LPC Bridge (rev a2)
>> 00:03.1 SMBus: NVIDIA Corporation MCP73 SMBus (rev a1)
>> 00:03.2 RAM memory: NVIDIA Corporation MCP73 Memory Controller (rev a1)
>> 00:03.4 RAM memory: NVIDIA Corporation MCP73 Memory Controller (rev a1)
>> 00:04.0 USB controller: NVIDIA Corporation GeForce 7100/nForce 630i USB
>> (rev a1)
>> 00:04.1 USB controller: NVIDIA Corporation MCP73 [nForce 630i] USB 2.0
>> Controller (EHCI) (rev a1)
>> 00:08.0 IDE interface: NVIDIA Corporation MCP73 IDE (rev a1)
>> 00:09.0 Audio device: NVIDIA Corporation MCP73 High Definition Audio
>> (rev a1)
>> 00:0a.0 PCI bridge: NVIDIA Corporation MCP73 PCI Express bridge (rev
>> a1)
>> 00:0c.0 PCI bridge: NVIDIA Corporation MCP73 PCI Express bridge (rev
>> a1)
>> 00:0e.0 SATA controller: NVIDIA Corporation GeForce 7100/nForce 630i
>> SATA (rev a2)
>> 00:0f.0 Ethernet controller: NVIDIA Corporation MCP73 Ethernet (rev a2)
>> 00:10.0 VGA compatible controller: NVIDIA Corporation C73 [GeForce 7100
>> / nForce 630i] (rev a2)
>> 01:05.0 PCI bridge: Hint Corp HB6 Universal PCI-PCI bridge
>> (non-transparent mode) (rev 11)
>> 01:06.0 PCI bridge: Hint Corp HB6 Universal PCI-PCI bridge
>> (non-transparent mode) (rev 15)
>> 01:07.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23
>> IEEE-1394a-2000 Controller (PHY/Link)
>> 02:0c.0 Multimedia video controller: Brooktree Corporation Bt878 Video
>> Capture (rev 11)
>> 02:0c.1 Multimedia controller: Brooktree Corporation Bt878 Audio
>> Capture
>> (rev 11)
>> 02:0d.0 Multimedia video controller: Brooktree Corporation Bt878 Video
>> Capture (rev 11)
>> 02:0d.1 Multimedia controller: Brooktree Corporation Bt878 Audio
>> Capture
>> (rev 11)
>> 02:0e.0 Multimedia video controller: Brooktree Corporation Bt878 Video
>> Capture (rev 11)
>> 02:0e.1 Multimedia controller: Brooktree Corporation Bt878 Audio
>> Capture
>> (rev 11)
>> 02:0f.0 Multimedia video controller: Brooktree Corporation Bt878 Video
>> Capture (rev 11)
>> 02:0f.1 Multimedia controller: Brooktree Corporation Bt878 Audio
>> Capture
>> (rev 11)
>> 03:04.0 Multimedia video controller: Brooktree Corporation Bt878 Video
>> Capture (rev 11)
>> 03:04.1 Multimedia controller: Brooktree Corporation Bt878 Audio
>> Capture
>> (rev 11)
>> 03:05.0 Multimedia video controller: Brooktree Corporation Bt878 Video
>> Capture (rev 11)
>> 03:05.1 Multimedia controller: Brooktree Corporation Bt878 Audio
>> Capture
>> (rev 11)
>> 03:06.0 Multimedia video controller: Brooktree Corporation Bt878 Video
>> Capture (rev 11)
>> 03:06.1 Multimedia controller: Brooktree Corporation Bt878 Audio
>> Capture
>> (rev 11)
>> 03:07.0 Multimedia video controller: Brooktree Corporation Bt878 Video
>> Capture (rev 11)
>> 03:07.1 Multimedia controller: Brooktree Corporation Bt878 Audio
>> Capture
>> (rev 11)
>> 04:00.0 Multimedia video controller: Micronas Semiconductor Holding AG
>> nGene PCI-Express Multimedia Controller (rev 01)
>> 
>> 
>> 
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Maybe it's like one of these, which requires a line in modprobe.conf
> 
> http://linuxtv.org/wiki/index.php/Kodicom_4400R
> 
> R,
> Andy

Good idea. I had tried that driver I think, but I hadn't seen the bit about the master chip being second. Sadly no joy with my card. 

Thanks anyway,
Rob. 