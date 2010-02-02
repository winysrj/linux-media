Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:37628 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046Ab0BBMX5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Feb 2010 07:23:57 -0500
Subject: Re: Lost remote after kernel/v4l update cx23885 chipset
From: Andy Walls <awalls@radix.net>
To: "Timothy D. Lenz" <tlenz@vorgon.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4B672587.6040406@vorgon.com>
References: <4B5CA887.3060606@vorgon.com>  <4B672587.6040406@vorgon.com>
Content-Type: text/plain
Date: Tue, 02 Feb 2010 07:23:28 -0500
Message-Id: <1265113408.3104.1.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-02-01 at 12:03 -0700, Timothy D. Lenz wrote:
> 
> On 1/24/2010 1:07 PM, Timothy D. Lenz wrote:
> > After updating from kernel 2.6.26.8 to 2.6.32.2 and from v4l of
> > 05/19/2009 to 01/18/2010 I lost remote function with Dvico FusionHDTV7
> > Dual Express. The driver is loading, but not creating an IR device. Went
> > over it with awalls on IRC. The log is at: http://pastebin.com/m4b02ff0c
> >
> >
> > I noticed that in the kern.log there where 2 different ways ir-kbd-i2c
> > showed up. ir-kbd-i2c no longer shows up when loading drivers.
> >
> > Jan 17 14:59:32 LLLx64-32 kernel: input: i2c IR (FusionHDTV) as
> > /devices/virtual/input/input5
> > Jan 17 14:59:32 LLLx64-32 kernel: ir-kbd-i2c: i2c IR (FusionHDTV)
> > detected at i2c-2/2-006b/ir0 [cx23885[0]]
> > ------------------
> > Jan 18 17:23:27 LLLx64-32 kernel: input: i2c IR (FusionHDTV) as
> > /devices/virtual/input/input5
> > Jan 18 17:23:27 LLLx64-32 kernel: Creating IR device irrcv0
> > Jan 18 17:23:27 LLLx64-32 kernel: ir-kbd-i2c: i2c IR (FusionHDTV)
> > detected at i2c-1/1-006b/ir0 [cx23885[0]]
> >
> > Jan 18 18:28:50 LLLx64-32 kernel: input: i2c IR (FusionHDTV) as
> > /devices/virtual/input/input5
> > Jan 18 18:28:50 LLLx64-32 kernel: ir-kbd-i2c: i2c IR (FusionHDTV)
> > detected at i2c-2/2-006b/ir0 [cx23885[0]]
> >
> > ------------------
> > A driver load that worked:
> >
> > Jan 17 11:22:35 LLLx64-32 kernel: Linux video capture interface: v2.00
> > Jan 17 11:22:35 LLLx64-32 kernel: cx23885 driver version 0.0.2 loaded
> > Jan 17 11:22:35 LLLx64-32 kernel: ACPI: PCI Interrupt 0000:02:00.0[A] ->
> > Link [APC7] -> GSI 16 (level, low) -> IRQ 16
> > Jan 17 11:22:35 LLLx64-32 kernel: CORE cx23885[0]: subsystem: 18ac:d618,
> > board: DViCO FusionHDTV7 Dual Express [card=10,autodetected]
> > Jan 17 11:22:35 LLLx64-32 kernel: cx23885_dvb_register() allocating 1
> > frontend(s)
> > Jan 17 11:22:35 LLLx64-32 kernel: cx23885[0]: cx23885 based dvb card
> > Jan 17 11:22:35 LLLx64-32 kernel: xc5000 2-0064: creating new instance
> > Jan 17 11:22:35 LLLx64-32 kernel: xc5000: Successfully identified at
> > address 0x64
> > Jan 17 11:22:35 LLLx64-32 kernel: xc5000: Firmware has not been loaded
> > previously
> > Jan 17 11:22:35 LLLx64-32 kernel: DVB: registering new adapter (cx23885[0])
> > Jan 17 11:22:35 LLLx64-32 kernel: DVB: registering adapter 0 frontend 0
> > (Samsung S5H1411 QAM/8VSB Frontend)...
> > Jan 17 11:22:35 LLLx64-32 kernel: cx23885_dvb_register() allocating 1
> > frontend(s)
> > Jan 17 11:22:35 LLLx64-32 kernel: cx23885[0]: cx23885 based dvb card
> > Jan 17 11:22:35 LLLx64-32 kernel: xc5000 3-0064: creating new instance
> > Jan 17 11:22:35 LLLx64-32 kernel: xc5000: Successfully identified at
> > address 0x64
> > Jan 17 11:22:35 LLLx64-32 kernel: xc5000: Firmware has not been loaded
> > previously
> > Jan 17 11:22:35 LLLx64-32 kernel: DVB: registering new adapter (cx23885[0])
> > Jan 17 11:22:35 LLLx64-32 kernel: DVB: registering adapter 1 frontend 0
> > (Samsung S5H1411 QAM/8VSB Frontend)...
> > Jan 17 11:22:35 LLLx64-32 kernel: cx23885_dev_checkrevision() Hardware
> > revision = 0xb0
> > Jan 17 11:22:35 LLLx64-32 kernel: cx23885[0]/0: found at 0000:02:00.0,
> > rev: 2, irq: 16, latency: 0, mmio: 0xfdc00000
> > Jan 17 11:22:35 LLLx64-32 kernel: PCI: Setting latency timer of device
> > 0000:02:00.0 to 64
> > Jan 17 11:22:35 LLLx64-32 kernel: input: i2c IR (FusionHDTV) as
> > /devices/virtual/input/input8
> > Jan 17 11:22:35 LLLx64-32 kernel: ir-kbd-i2c: i2c IR (FusionHDTV)
> > detected at i2c-2/2-006b/ir0 [cx23885[0]]
> > Jan 17 11:22:36 LLLx64-32 kernel: xc5000: waiting for firmware upload
> > (dvb-fe-xc5000-1.6.114.fw)...
> > Jan 17 11:22:36 LLLx64-32 kernel: firmware: requesting
> > dvb-fe-xc5000-1.6.114.fw
> > Jan 17 11:22:36 LLLx64-32 kernel: xc5000: firmware read 12401 bytes.
> > Jan 17 11:22:36 LLLx64-32 kernel: xc5000: firmware uploading...
> > Jan 17 11:22:37 LLLx64-32 kernel: xc5000: firmware upload complete...
> > Jan 17 11:22:37 LLLx64-32 kernel: xc5000: waiting for firmware upload
> > (dvb-fe-xc5000-1.6.114.fw)...
> > Jan 17 11:22:37 LLLx64-32 kernel: firmware: requesting
> > dvb-fe-xc5000-1.6.114.fw
> > Jan 17 11:22:37 LLLx64-32 kernel: xc5000: firmware read 12401 bytes.
> > Jan 17 11:22:37 LLLx64-32 kernel: xc5000: firmware uploading...
> > Jan 17 11:22:39 LLLx64-32 kernel: xc5000: firmware upload complete...
> > ------------------
> >
> > And what it does now:
> > Jan 23 17:10:47 LLLx64-32 kernel: Linux video capture interface: v2.00
> > Jan 23 17:10:47 LLLx64-32 kernel: cx23885 driver version 0.0.2 loaded
> > Jan 23 17:10:47 LLLx64-32 kernel: cx23885 0000:02:00.0: PCI INT A ->
> > Link[APC7] -> GSI 16 (level, low) -> IRQ 16
> > Jan 23 17:10:47 LLLx64-32 kernel: CORE cx23885[0]: subsystem: 18ac:d618,
> > board: DViCO FusionHDTV7 Dual Express [card=10,autodetected]
> > Jan 23 17:10:47 LLLx64-32 kernel: cx23885_dvb_register() allocating 1
> > frontend(s)
> > Jan 23 17:10:47 LLLx64-32 kernel: cx23885[0]: cx23885 based dvb card
> > Jan 23 17:10:47 LLLx64-32 kernel: xc5000 1-0064: creating new instance
> > Jan 23 17:10:47 LLLx64-32 kernel: xc5000: Successfully identified at
> > address 0x64
> > Jan 23 17:10:47 LLLx64-32 kernel: xc5000: Firmware has not been loaded
> > previously
> > Jan 23 17:10:47 LLLx64-32 kernel: DVB: registering new adapter (cx23885[0])
> > Jan 23 17:10:47 LLLx64-32 kernel: DVB: registering adapter 0 frontend 0
> > (Samsung S5H1411 QAM/8VSB Frontend)...
> > Jan 23 17:10:47 LLLx64-32 kernel: cx23885_dvb_register() allocating 1
> > frontend(s)
> > Jan 23 17:10:47 LLLx64-32 kernel: cx23885[0]: cx23885 based dvb card
> > Jan 23 17:10:47 LLLx64-32 kernel: xc5000 2-0064: creating new instance
> > Jan 23 17:10:47 LLLx64-32 kernel: xc5000: Successfully identified at
> > address 0x64
> > Jan 23 17:10:47 LLLx64-32 kernel: xc5000: Firmware has not been loaded
> > previously
> > Jan 23 17:10:47 LLLx64-32 kernel: DVB: registering new adapter (cx23885[0])
> > Jan 23 17:10:47 LLLx64-32 kernel: DVB: registering adapter 1 frontend 0
> > (Samsung S5H1411 QAM/8VSB Frontend)...
> > Jan 23 17:10:47 LLLx64-32 kernel: cx23885_dev_checkrevision() Hardware
> > revision = 0xb0
> > Jan 23 17:10:47 LLLx64-32 kernel: cx23885[0]/0: found at 0000:02:00.0,
> > rev: 2, irq: 16, latency: 0, mmio: 0xfdc00000
> > Jan 23 17:10:47 LLLx64-32 kernel: cx23885 0000:02:00.0: setting latency
> > timer to 64
> > Jan 23 17:10:47 LLLx64-32 kernel: IRQ 16/cx23885[0]: IRQF_DISABLED is
> > not guaranteed on shared IRQs
> >
> > I put a zip of some logs at: http://24.255.17.209:2400/vdr-logs/logs.zip
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at http://vger.kernel.org/majordomo-info.html
> >
> 
> Any progress on this one?

Nope.  Maybe around Friday I'll provide a patch with some printk()'s for
debugging as I don't have the hardware.  (Unless of course I'm shoveling
snow again...)

Regards,
Andy


> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

