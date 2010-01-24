Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.195]:58879 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446Ab0AXUHo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2010 15:07:44 -0500
Message-ID: <4B5CA887.3060606@vorgon.com>
Date: Sun, 24 Jan 2010 13:07:35 -0700
From: "Timothy D. Lenz" <tlenz@vorgon.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Lost remote after kernel/v4l update cx23885 chipset
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After updating from kernel 2.6.26.8 to 2.6.32.2 and from v4l of 
05/19/2009 to 01/18/2010 I lost remote function with Dvico FusionHDTV7 
Dual Express. The driver is loading, but not creating an IR device. Went 
over it with awalls on IRC. The log is at: http://pastebin.com/m4b02ff0c


I noticed that in the kern.log there where 2 different ways ir-kbd-i2c 
showed up. ir-kbd-i2c no longer shows up when loading drivers.

Jan 17 14:59:32 LLLx64-32 kernel: input: i2c IR (FusionHDTV) as 
/devices/virtual/input/input5
Jan 17 14:59:32 LLLx64-32 kernel: ir-kbd-i2c: i2c IR (FusionHDTV) 
detected at i2c-2/2-006b/ir0 [cx23885[0]]
------------------
Jan 18 17:23:27 LLLx64-32 kernel: input: i2c IR (FusionHDTV) as 
/devices/virtual/input/input5
Jan 18 17:23:27 LLLx64-32 kernel: Creating IR device irrcv0
Jan 18 17:23:27 LLLx64-32 kernel: ir-kbd-i2c: i2c IR (FusionHDTV) 
detected at i2c-1/1-006b/ir0 [cx23885[0]]

Jan 18 18:28:50 LLLx64-32 kernel: input: i2c IR (FusionHDTV) as 
/devices/virtual/input/input5
Jan 18 18:28:50 LLLx64-32 kernel: ir-kbd-i2c: i2c IR (FusionHDTV) 
detected at i2c-2/2-006b/ir0 [cx23885[0]]

------------------
A driver load that worked:

Jan 17 11:22:35 LLLx64-32 kernel: Linux video capture interface: v2.00
Jan 17 11:22:35 LLLx64-32 kernel: cx23885 driver version 0.0.2 loaded
Jan 17 11:22:35 LLLx64-32 kernel: ACPI: PCI Interrupt 0000:02:00.0[A] -> 
Link [APC7] -> GSI 16 (level, low) -> IRQ 16
Jan 17 11:22:35 LLLx64-32 kernel: CORE cx23885[0]: subsystem: 18ac:d618, 
board: DViCO FusionHDTV7 Dual Express [card=10,autodetected]
Jan 17 11:22:35 LLLx64-32 kernel: cx23885_dvb_register() allocating 1 
frontend(s)
Jan 17 11:22:35 LLLx64-32 kernel: cx23885[0]: cx23885 based dvb card
Jan 17 11:22:35 LLLx64-32 kernel: xc5000 2-0064: creating new instance
Jan 17 11:22:35 LLLx64-32 kernel: xc5000: Successfully identified at 
address 0x64
Jan 17 11:22:35 LLLx64-32 kernel: xc5000: Firmware has not been loaded 
previously
Jan 17 11:22:35 LLLx64-32 kernel: DVB: registering new adapter (cx23885[0])
Jan 17 11:22:35 LLLx64-32 kernel: DVB: registering adapter 0 frontend 0 
(Samsung S5H1411 QAM/8VSB Frontend)...
Jan 17 11:22:35 LLLx64-32 kernel: cx23885_dvb_register() allocating 1 
frontend(s)
Jan 17 11:22:35 LLLx64-32 kernel: cx23885[0]: cx23885 based dvb card
Jan 17 11:22:35 LLLx64-32 kernel: xc5000 3-0064: creating new instance
Jan 17 11:22:35 LLLx64-32 kernel: xc5000: Successfully identified at 
address 0x64
Jan 17 11:22:35 LLLx64-32 kernel: xc5000: Firmware has not been loaded 
previously
Jan 17 11:22:35 LLLx64-32 kernel: DVB: registering new adapter (cx23885[0])
Jan 17 11:22:35 LLLx64-32 kernel: DVB: registering adapter 1 frontend 0 
(Samsung S5H1411 QAM/8VSB Frontend)...
Jan 17 11:22:35 LLLx64-32 kernel: cx23885_dev_checkrevision() Hardware 
revision = 0xb0
Jan 17 11:22:35 LLLx64-32 kernel: cx23885[0]/0: found at 0000:02:00.0, 
rev: 2, irq: 16, latency: 0, mmio: 0xfdc00000
Jan 17 11:22:35 LLLx64-32 kernel: PCI: Setting latency timer of device 
0000:02:00.0 to 64
Jan 17 11:22:35 LLLx64-32 kernel: input: i2c IR (FusionHDTV) as 
/devices/virtual/input/input8
Jan 17 11:22:35 LLLx64-32 kernel: ir-kbd-i2c: i2c IR (FusionHDTV) 
detected at i2c-2/2-006b/ir0 [cx23885[0]]
Jan 17 11:22:36 LLLx64-32 kernel: xc5000: waiting for firmware upload 
(dvb-fe-xc5000-1.6.114.fw)...
Jan 17 11:22:36 LLLx64-32 kernel: firmware: requesting 
dvb-fe-xc5000-1.6.114.fw
Jan 17 11:22:36 LLLx64-32 kernel: xc5000: firmware read 12401 bytes.
Jan 17 11:22:36 LLLx64-32 kernel: xc5000: firmware uploading...
Jan 17 11:22:37 LLLx64-32 kernel: xc5000: firmware upload complete...
Jan 17 11:22:37 LLLx64-32 kernel: xc5000: waiting for firmware upload 
(dvb-fe-xc5000-1.6.114.fw)...
Jan 17 11:22:37 LLLx64-32 kernel: firmware: requesting 
dvb-fe-xc5000-1.6.114.fw
Jan 17 11:22:37 LLLx64-32 kernel: xc5000: firmware read 12401 bytes.
Jan 17 11:22:37 LLLx64-32 kernel: xc5000: firmware uploading...
Jan 17 11:22:39 LLLx64-32 kernel: xc5000: firmware upload complete...
------------------

And what it does now:
Jan 23 17:10:47 LLLx64-32 kernel: Linux video capture interface: v2.00
Jan 23 17:10:47 LLLx64-32 kernel: cx23885 driver version 0.0.2 loaded
Jan 23 17:10:47 LLLx64-32 kernel: cx23885 0000:02:00.0: PCI INT A -> 
Link[APC7] -> GSI 16 (level, low) -> IRQ 16
Jan 23 17:10:47 LLLx64-32 kernel: CORE cx23885[0]: subsystem: 18ac:d618, 
board: DViCO FusionHDTV7 Dual Express [card=10,autodetected]
Jan 23 17:10:47 LLLx64-32 kernel: cx23885_dvb_register() allocating 1 
frontend(s)
Jan 23 17:10:47 LLLx64-32 kernel: cx23885[0]: cx23885 based dvb card
Jan 23 17:10:47 LLLx64-32 kernel: xc5000 1-0064: creating new instance
Jan 23 17:10:47 LLLx64-32 kernel: xc5000: Successfully identified at 
address 0x64
Jan 23 17:10:47 LLLx64-32 kernel: xc5000: Firmware has not been loaded 
previously
Jan 23 17:10:47 LLLx64-32 kernel: DVB: registering new adapter (cx23885[0])
Jan 23 17:10:47 LLLx64-32 kernel: DVB: registering adapter 0 frontend 0 
(Samsung S5H1411 QAM/8VSB Frontend)...
Jan 23 17:10:47 LLLx64-32 kernel: cx23885_dvb_register() allocating 1 
frontend(s)
Jan 23 17:10:47 LLLx64-32 kernel: cx23885[0]: cx23885 based dvb card
Jan 23 17:10:47 LLLx64-32 kernel: xc5000 2-0064: creating new instance
Jan 23 17:10:47 LLLx64-32 kernel: xc5000: Successfully identified at 
address 0x64
Jan 23 17:10:47 LLLx64-32 kernel: xc5000: Firmware has not been loaded 
previously
Jan 23 17:10:47 LLLx64-32 kernel: DVB: registering new adapter (cx23885[0])
Jan 23 17:10:47 LLLx64-32 kernel: DVB: registering adapter 1 frontend 0 
(Samsung S5H1411 QAM/8VSB Frontend)...
Jan 23 17:10:47 LLLx64-32 kernel: cx23885_dev_checkrevision() Hardware 
revision = 0xb0
Jan 23 17:10:47 LLLx64-32 kernel: cx23885[0]/0: found at 0000:02:00.0, 
rev: 2, irq: 16, latency: 0, mmio: 0xfdc00000
Jan 23 17:10:47 LLLx64-32 kernel: cx23885 0000:02:00.0: setting latency 
timer to 64
Jan 23 17:10:47 LLLx64-32 kernel: IRQ 16/cx23885[0]: IRQF_DISABLED is 
not guaranteed on shared IRQs

I put a zip of some logs at: http://24.255.17.209:2400/vdr-logs/logs.zip
