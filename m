Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:44299 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbZBBCPr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Feb 2009 21:15:47 -0500
Received: by rv-out-0506.google.com with SMTP id k40so1266279rvb.1
        for <linux-media@vger.kernel.org>; Sun, 01 Feb 2009 18:15:46 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 2 Feb 2009 12:45:46 +1030
Message-ID: <ae5231870902011815r55647fa6v59e9cf1b5cce6bdc@mail.gmail.com>
Subject: kernel-2.6.28 probs
From: Robert Golding <robert.golding@gmail.com>
To: DVB4Linux <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I have been trying to get my box's dvb card working in kernel 2.6.28
and have had only failures so far.

It all works quite well in 2.6.27, just doesn't seem to want lock onto
channels when using updated kernel.  I have tried 2.6.28 with the
inbuilt drivers as well as the latest hg drivers which I use for the
2.6.27 kernel.

My card is the LeadTek WinFast PxDVR3200-H

Here is the relevent dmesg section (ignore the gspa, thats for my cam)
---->
cx23885 driver version 0.0.1 loaded
ACPI: PCI Interrupt Link [APC5] enabled at IRQ 16
cx23885 0000:02:00.0: PCI INT A -> Link[APC5] -> GSI 16 (level, low) -> IRQ 16
CORE cx23885[0]: subsystem: 107d:6681, board: Leadtek Winfast
PxDVR3200 H [card=12,insmod option]
i2c-adapter i2c-2: adapter [cx23885[0]] registered
i2c-dev: adapter [cx23885[0]] registered as minor 2
i2c-adapter i2c-3: adapter [cx23885[0]] registered
i2c-dev: adapter [cx23885[0]] registered as minor 3
i2c-adapter i2c-4: adapter [cx23885[0]] registered
i2c-dev: adapter [cx23885[0]] registered as minor 4
i2c-adapter i2c-2: master_xfer[0] W, addr=0x50, len=1
i2c-adapter i2c-2: master_xfer[0] R, addr=0x50, len=256
firewire_core: created device fw0: GUID 001a4d5600e248b0, S400
i2c-core: driver [cx25840'] registered
i2c-adapter i2c-2: found normal entry for adapter 2, addr 0x44
i2c-adapter i2c-2: master_xfer[0] W, addr=0x44, len=0
i2c-adapter i2c-3: found normal entry for adapter 3, addr 0x44
i2c-adapter i2c-3: master_xfer[0] W, addr=0x44, len=0
i2c-adapter i2c-4: found normal entry for adapter 4, addr 0x44
i2c-adapter i2c-4: master_xfer[0] W, addr=0x44, len=0
i2c-adapter i2c-4: master_xfer[0] W, addr=0x44, len=2
i2c-adapter i2c-4: master_xfer[0] R, addr=0x44, len=1
i2c-adapter i2c-4: master_xfer[0] W, addr=0x44, len=2
i2c-adapter i2c-4: master_xfer[0] R, addr=0x44, len=1
cx25840' 4-0044: cx25  0-21 found @ 0x88 (cx23885[0])
i2c-adapter i2c-4: master_xfer[0] W, addr=0x44, len=2
i2c-adapter i2c-4: master_xfer[0] R, addr=0x44, len=1
i2c-adapter i2c-4: master_xfer[0] W, addr=0x44, len=3
i2c-adapter i2c-4: master_xfer[0] W, addr=0x44, len=3
i2c-adapter i2c-4: client [cx25840'] registered with bus id 4-0044
i2c-core: driver [cx25840] registered
cx23885_dvb_register() allocating 1 frontend(s)
cx23885[0]: cx23885 based dvb card
spca561 2-10:1.0: usb_probe_interface
spca561 2-10:1.0: usb_probe_interface - got id
gspca: probing 046d:092f
gspca: probe ok
usbcore: registered new interface driver spca561
spca561: registered
nvidia: module license 'NVIDIA' taints kernel.
ACPI: PCI Interrupt Link [APC6] enabled at IRQ 16
nvidia 0000:03:00.0: PCI INT A -> Link[APC6] -> GSI 16 (level, low) -> IRQ 16
nvidia 0000:03:00.0: setting latency timer to 64
NVRM: loading NVIDIA UNIX x86 Kernel Module  180.27  Tue Jan 27
12:16:07 PST 2009
i2c-adapter i2c-2: master_xfer[0] W, addr=0x0f, len=1
i2c-adapter i2c-2: master_xfer[1] R, addr=0x0f, len=1
xc2028 3-0061: creating new instance
xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
DVB: registering new adapter (cx23885[0])
DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
cx23885_dev_checkrevision() Hardware revision = 0xb0
cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 16, latency: 0,
mmio: 0xee000000
cx23885 0000:02:00.0: setting latency timer to 64
---->


-- 
Regards,	Robert

..... Some people can tell what time it is by looking at the sun, but
I have never been able to make out the numbers.
---
Errata: Spelling mistakes are not intentional, however, I don't use
spell checkers because it's too easy to allow the spell checker to
make the decisions and use words that are out of context for that
being written, i.e. their/there, your/you're, threw/through and even
accept/except, not to mention foreign (I'm Australian) English
spelling, i.e. colour/color, socks/sox, etc,.
