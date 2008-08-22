Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jackden@gmail.com>) id 1KWTWV-0003vD-1m
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 12:05:40 +0200
Received: by ti-out-0910.google.com with SMTP id w7so289509tib.13
	for <linux-dvb@linuxtv.org>; Fri, 22 Aug 2008 03:05:32 -0700 (PDT)
Message-ID: <ede8a03f0808220305x4e989aa7q15d4f5400b6cc518@mail.gmail.com>
Date: Fri, 22 Aug 2008 18:05:32 +0800
From: jackden <jackden@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and analog
	TV/FM capture card
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

I have Compro VideoMate E650.
VideoMate E650 hybrid PCI-Express DVB-T and analog TV/FM capture card.
But it can't correct run. I use Ubuntu 8.04. vga card is ATI Radeon HD2600 Pro.

lspci -vvnn
02:00.0 Multimedia video controller [0400]: Conexant Unknown device
[14f1:8852] (rev 02)
	Subsystem: Compro Technology, Inc. Unknown device [185b:e800]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at fdc00000 (64-bit, non-prefetchable) [size=2M]
	Capabilities: <access denied>

dmesg
[   40.804089] cx23885 driver version 0.0.1 loaded
[   40.804156] ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [APC2] ->
GSI 17 (level, low) -> IRQ 20
[   40.804179] CORE cx23885[0]: subsystem: 185b:e800, board: DViCO
FusionHDTV5 Express [card=4,insmod option]
[   41.372335] uvcvideo: disagrees about version of symbol v4l_compat_ioctl32
[   41.372341] uvcvideo: Unknown symbol v4l_compat_ioctl32
[   41.372612] uvcvideo: disagrees about version of symbol video_devdata
[   41.372614] uvcvideo: Unknown symbol video_devdata
[   41.372906] uvcvideo: disagrees about version of symbol
video_unregister_device
[   41.372908] uvcvideo: Unknown symbol video_unregister_device
[   41.372997] uvcvideo: disagrees about version of symbol video_device_alloc
[   41.372999] uvcvideo: Unknown symbol video_device_alloc
[   41.373061] uvcvideo: disagrees about version of symbol video_register_device
[   41.373063] uvcvideo: Unknown symbol video_register_device
[   41.373222] uvcvideo: disagrees about version of symbol video_usercopy
[   41.373224] uvcvideo: Unknown symbol video_usercopy
[   41.373249] uvcvideo: disagrees about version of symbol video_device_release
[   41.373251] uvcvideo: Unknown symbol video_device_release
[   41.437139] cx23885[0]: i2c bus 0 registered
[   41.437166] cx23885[0]: i2c bus 1 registered
[   41.437189] cx23885[0]: i2c bus 2 registered
[   41.462891] usbcore: registered new interface driver snd-usb-audio
[   41.551818] cx23885[0]: cx23885 based dvb card
[   41.704254] tuner-simple 2-0061: creating new instance
[   41.704259] tuner-simple 2-0061: type set to 64 (LG TDVS-H06xF)
[   41.704263] DVB: registering new adapter (cx23885[0])
[   41.704266] DVB: registering frontend 0 (LG Electronics LGDT3303
VSB/QAM Frontend)...
[   41.704464] cx23885_dev_checkrevision() Hardware revision = 0xb0
[   41.704470] cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 20,
latency: 0, mmio: 0xfdc00000

ps.sorry, my english is very poor.

----=Jackden in Google=----
--=Jackden@Gmail.com=--

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
