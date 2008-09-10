Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KdFab-0002Zs-MR
	for linux-dvb@linuxtv.org; Wed, 10 Sep 2008 04:37:55 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6Y001RNKM7YZB0@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Tue, 09 Sep 2008 22:37:19 -0400 (EDT)
Date: Tue, 09 Sep 2008 22:37:18 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48C73161.7090405@magma.ca>
To: Patrick Boisvenue <patrbois@magma.ca>
Message-id: <48C732DE.2030902@linuxtv.org>
MIME-version: 1.0
References: <48C659C5.8000902@magma.ca> <48C68DC5.1050400@linuxtv.org>
	<48C73161.7090405@magma.ca>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1500Q eeprom not being parsed correctly
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Patrick Boisvenue wrote:
> Steven Toth wrote:
>> Patrick Boisvenue wrote:
>>> I cannot get my new HVR-1500Q to work at all even though it's 
>>> recognized as such.  The best I was able to figure out was it does 
>>> not like the eeprom.  After enabling the debug mode on tveeprom, I 
>>> got the following when loading cx23885:
>>
>> ...
>>
>>> cx23885[0]: warning: unknown hauppauge model #0
>>> cx23885[0]: hauppauge eeprom: model=0
>>> cx23885[0]: cx23885 based dvb card
>>
>> ...
>>
>>> Did a hg pull -u http://linuxtv.org/hg/v4l-dvb earlier today so 
>>> running off recent codebase.
>>
>> Fixed it, see linuxtv.org/hg/~stoth/v4l-dvb.
>>
>> Pull the topmost patch and try again, please post your results back here.
>>
>> Thanks,
>>
>> Steve
>>
> 
> Getting better, the eeprom parsing seems to work (check dmesg output 
> below). However, doing a dvbscan still nets me no stations while doing a 
> scan in a WindowsXP laptop gets me the expected two (2) stations in my 
> area.
> 
> dmesg output with tveeprom debug=1 and cx23885 debug=5 after loading 
> cx23885 module:
> 
> cx23885 driver version 0.0.1 loaded
> ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 19 (level, low) -> IRQ 19
> cx23885[0]/0: cx23885_dev_setup() Memory configured for PCIe bridge type 
> 885
> cx23885[0]/0: cx23885_init_tsport(portno=2)
> CORE cx23885[0]: subsystem: 0070:7790, board: Hauppauge WinTV-HVR1500Q 
> [card=5,autodetected]
> cx23885[0]/0: cx23885_pci_quirks()
> cx23885[0]/0: cx23885_dev_setup() tuner_type = 0x0 tuner_addr = 0x0
> cx23885[0]/0: cx23885_dev_setup() radio_type = 0x0 radio_addr = 0x0
> cx23885[0]/0: cx23885_reset()
> cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [VID A]
> cx23885[0]/0: cx23885_sram_channel_setup() 0x000104c0 <- 0x00000040
> cx23885[0]/0: cx23885_sram_channel_setup() 0x000104d0 <- 0x00000b80
> cx23885[0]/0: cx23885_sram_channel_setup() 0x000104e0 <- 0x000016c0
> cx23885[0]/0: [bridge 885] sram setup VID A: bpl=2880 lines=3
> cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch2]
> cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [TS1 B]
> cx23885[0]/0: cx23885_sram_channel_setup() 0x00010580 <- 0x00005000
> cx23885[0]/0: cx23885_sram_channel_setup() 0x00010590 <- 0x000052f0
> cx23885[0]/0: cx23885_sram_channel_setup() 0x000105a0 <- 0x000055e0
> cx23885[0]/0: cx23885_sram_channel_setup() 0x000105b0 <- 0x000058d0
> cx23885[0]/0: cx23885_sram_channel_setup() 0x000105c0 <- 0x00005bc0
> cx23885[0]/0: [bridge 885] sram setup TS1 B: bpl=752 lines=5
> cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch4]
> cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch5]
> cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [TS2 C]
> cx23885[0]/0: cx23885_sram_channel_setup() 0x000105e0 <- 0x00006000
> cx23885[0]/0: cx23885_sram_channel_setup() 0x000105f0 <- 0x000062f0
> cx23885[0]/0: cx23885_sram_channel_setup() 0x00010600 <- 0x000065e0
> cx23885[0]/0: cx23885_sram_channel_setup() 0x00010610 <- 0x000068d0
> cx23885[0]/0: cx23885_sram_channel_setup() 0x00010620 <- 0x00006bc0
> cx23885[0]/0: [bridge 885] sram setup TS2 C: bpl=752 lines=5
> cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch7]
> cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch8]
> cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch9]
> cx23885[0]: i2c bus 0 registered
> cx23885[0]: i2c bus 1 registered
> cx23885[0]: i2c bus 2 registered
> tveeprom 1-0050: full 256-byte eeprom dump:
> tveeprom 1-0050: 00: 20 00 13 00 00 00 00 00 2c 00 05 00 70 00 90 77
> tveeprom 1-0050: 10: 50 03 05 00 04 80 00 08 0c 03 05 80 0e 01 00 00
> tveeprom 1-0050: 20: 78 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> tveeprom 1-0050: 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> tveeprom 1-0050: 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> tveeprom 1-0050: 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> tveeprom 1-0050: 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> tveeprom 1-0050: 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> tveeprom 1-0050: 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> tveeprom 1-0050: 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> tveeprom 1-0050: a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> tveeprom 1-0050: b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> tveeprom 1-0050: c0: 84 09 00 04 20 77 00 40 ec 66 25 f0 73 05 27 00
> tveeprom 1-0050: d0: 84 08 00 06 fb 2c 01 00 90 29 95 72 07 70 73 09
> tveeprom 1-0050: e0: 21 7f 73 0a 88 96 72 0b 13 72 10 01 72 11 ff 79
> tveeprom 1-0050: f0: dc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> tveeprom 1-0050: Tag [04] + 8 bytes: 20 77 00 40 ec 66 25 f0
> tveeprom 1-0050: Tag [05] + 2 bytes: 27 00
> tveeprom 1-0050: Tag [06] + 7 bytes: fb 2c 01 00 90 29 95
> tveeprom 1-0050: Tag [07] + 1 bytes: 70
> tveeprom 1-0050: Tag [09] + 2 bytes: 21 7f
> tveeprom 1-0050: Tag [0a] + 2 bytes: 88 96
> tveeprom 1-0050: Tag [0b] + 1 bytes: 13
> tveeprom 1-0050: Tag [10] + 1 bytes: 01
> tveeprom 1-0050: Not sure what to do with tag [10]
> tveeprom 1-0050: Tag [11] + 1 bytes: ff
> tveeprom 1-0050: Not sure what to do with tag [11]
> tveeprom 1-0050: Hauppauge model 77051, rev E2F0, serial# 2451180
> tveeprom 1-0050: MAC address is 00-0D-FE-25-66-EC
> tveeprom 1-0050: tuner model is Xceive XC5000 (idx 150, type 4)
> tveeprom 1-0050: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)
> tveeprom 1-0050: audio processor is CX23885 (idx 39)
> tveeprom 1-0050: decoder processor is CX23885 (idx 33)
> tveeprom 1-0050: has no radio
> cx23885[0]: hauppauge eeprom: model=77051
> cx23885[0]: cx23885 based dvb card
> xc5000: Successfully identified at address 0x61
> xc5000: Firmware has not been loaded previously
> DVB: registering new adapter (cx23885[0])
> DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
> cx23885_dev_checkrevision() Hardware revision = 0xb0
> cx23885[0]/0: found at 0000:05:00.0, rev: 2, irq: 19, latency: 0, mmio: 
> 0xd4000000
> PCI: Setting latency timer of device 0000:05:00.0 to 64
> 
> 
> When launching dvbscan I get the following in dmesg:
> 
> xc5000: waiting for firmware upload (dvb-fe-xc5000-1.1.fw)...
> firmware: requesting dvb-fe-xc5000-1.1.fw
> kobject_add_internal failed for i2c-2 with -EEXIST, don't try to 
> register things with the same name in the same directory.
> Pid: 8059, comm: kdvb-fe-0 Tainted: P          2.6.26-gentoo #11
> 
> Call Trace:
>  [<ffffffff8036abb5>] kobject_add_internal+0x13f/0x17e
>  [<ffffffff8036aff2>] kobject_add+0x74/0x7c
>  [<ffffffff80230b02>] printk+0x4e/0x56
>  [<ffffffff803eb84a>] device_add+0x9b/0x483
>  [<ffffffff8036a876>] kobject_init+0x41/0x69
>  [<ffffffff803f059d>] _request_firmware+0x169/0x324
>  [<ffffffffa00e9a7e>] :xc5000:xc_load_fw_and_init_tuner+0x64/0x293
>  [<ffffffff804a7222>] i2c_transfer+0x75/0x7f
>  [<ffffffffa00e53ad>] :s5h1409:s5h1409_writereg+0x51/0x83
>  [<ffffffffa00e9cea>] :xc5000:xc5000_init+0x3d/0x6f
>  [<ffffffffa0091b0c>] :dvb_core:dvb_frontend_init+0x49/0x63
>  [<ffffffffa0092e2c>] :dvb_core:dvb_frontend_thread+0x78/0x2f0
>  [<ffffffffa0092db4>] :dvb_core:dvb_frontend_thread+0x0/0x2f0
>  [<ffffffff80240eaf>] kthread+0x47/0x74
>  [<ffffffff8022bc41>] schedule_tail+0x27/0x5b
>  [<ffffffff8020be18>] child_rip+0xa/0x12
>  [<ffffffff80240e68>] kthread+0x0/0x74
>  [<ffffffff8020be0e>] child_rip+0x0/0x12
> 
> fw_register_device: device_register failed
> xc5000: Upload failed. (file not found?)
> xc5000: Unable to initialise tuner
> 
> 
> I have the firmware file located here:
> 
> # ls -l /lib/firmware/dvb-fe-xc5000-1.1.fw
> -rw-r--r-- 1 root root 12332 Aug 31 12:56 
> /lib/firmware/dvb-fe-xc5000-1.1.fw
> 
> If there is anything else I can provide (or try) to help debug, let me 
> know,
> ...Patrick

 > kobject_add_internal failed for i2c-2 with -EEXIST, don't try to
 > register things with the same name in the same directory.

Ooh, that's nasty problem, this is new - and looks like it's i2c related.

Why does this sound familiar? Anyone?

Just for the hell of it, copy the firmware to /lib/firmware/`uname -r` 
also, then re-run the test - it's unlikely to make any difference but it 
_is_ the scenario I always test under.

- Steve



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
