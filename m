Return-path: <linux-media-owner@vger.kernel.org>
Received: from lapsus.org ([91.121.59.153]:50339 "EHLO lapsus.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755159Ab1IMQNc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 12:13:32 -0400
Received: from [IPv6:2a01:e35:8a35:39e0:5ab0:35ff:fef6:9c0] (unknown [IPv6:2a01:e35:8a35:39e0:5ab0:35ff:fef6:9c0])
	by lapsus.org (Postfix) with ESMTPSA id 9A97BEC0AB
	for <linux-media@vger.kernel.org>; Tue, 13 Sep 2011 16:08:04 +0000 (UTC)
From: Eric Petit <eric@lapsus.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: ngene/cxd2099 occasional timeouts/errors
Date: Tue, 13 Sep 2011 18:08:03 +0200
Message-Id: <09560277-E300-4B9F-99D1-58BECBF38B51@lapsus.org>
To: linux-media@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1084)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I am trying to run Mystique SaTiX-S2 CI Dual cards to fetch and decrypt a number of channels 24/7. I got it to work with the ngene/cxd2099 drivers (passing the stream through the sec0 device etc), but one remaining issue is that the driver occasionally reports a command timeout followed by more errors from the CI:

Sep  6 08:46:48 s102-34 kernel: [1636918.174974] slot_shutdown
Sep  6 08:46:50 s102-34 kernel: [1636920.481706] dvb_ca adapter 2: DVB CAM detected and initialised successfully
  (Running fine...)
Sep 10 09:20:41 s102-34 kernel: [1984551.380033] ngene: Command timeout cmd=03 prev=04
Sep 10 09:20:41 s102-34 kernel: [1984551.384675] host_to_ngene (c000): 03 04 80 01 01 00 00 00
Sep 10 09:20:41 s102-34 kernel: [1984551.389345] ngene_to_host (c100): 00 00 00 00 00 00 00 00
Sep 10 09:20:41 s102-34 kernel: [1984551.393900] dev->hosttongene (f3025000): 03 04 80 01 01 00 00 00
Sep 10 09:20:41 s102-34 kernel: [1984551.398551] dev->ngenetohost (f3025100): 00 00 00 00 00 00 00 00
Sep 10 09:20:41 s102-34 kernel: [1984551.403176] error in i2c_read
Sep 10 09:20:41 s102-34 kernel: [1984551.407999] Failed to write to I2C!
Sep 10 09:20:41 s102-34 kernel: [1984551.412801] Failed to write to I2C!
Sep 10 09:20:41 s102-34 kernel: [1984551.417474] Failed to write to I2C!
Sep 10 09:20:41 s102-34 kernel: [1984551.422085] Failed to write to I2C!
Sep 10 09:20:41 s102-34 kernel: [1984551.426605] Failed to write to I2C!
Sep 10 09:20:41 s102-34 kernel: [1984551.512361] Failed to write to I2C register 00@40!
Sep 10 09:20:41 s102-34 kernel: [1984551.516719] Failed to write to I2C register 00@40!
Sep 10 09:20:41 s102-34 kernel: [1984551.520784] DR
Sep 10 09:20:41 s102-34 kernel: [1984551.520789] WC
Sep 10 09:20:41 s102-34 kernel: [1984551.521108] Failed to write to I2C register 00@40!
Sep 10 09:20:41 s102-34 kernel: [1984551.525402] Failed to write to I2C register 00@40!
Sep 10 09:20:41 s102-34 kernel: [1984551.529326] NO CAM
Sep 10 09:20:41 s102-34 kernel: [1984551.529652] Failed to write to I2C register 00@40!
Sep 10 09:20:41 s102-34 kernel: [1984551.533528] slot_shutdown
Sep 10 09:20:41 s102-34 kernel: [1984551.533853] Failed to write to I2C register 00@40!
Sep 10 09:20:41 s102-34 kernel: [1984551.538034] Failed to write to I2C register 00@40!
Sep 10 09:20:41 s102-34 kernel: [1984551.542166] Failed to write to I2C register 00@40!

>From the moment that happens, I can't do anything with the card: all ioctls fail even after re-opening the adapter or after reloading the drivers. Only a reboot can bring it back to a good state.

This condition is not so frequent, I've seen it happen maybe 5 times running a dozen cards for a week. Has anyone experienced it? Is this something the driver would be able to recover from?

Versions details below,

Thanks,

-- 
Eric




Kernel:
    linux-image-3.0.0-1-686-pae Debian package (32-bit)

Modules built from v4l-dvb:
    cxd2099
    dvb_core
    lnbp21
    ngene
    stv090x
    stv6110x

Dmesg output from loading the drivers:
    slot_shutdown
    ngene 0000:03:00.0: PCI INT A disabled
    WARNING: You are using an experimental version of the media stack.
    	As the driver is backported to an older kernel, it doesn't offer
    	enough quality for its usage in production.
    	Use it with care.
    Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
    	3d589db03f09c1ace6f71849085595f1f114cd3c [media] v4l: mt9v032: Fix Bayer pattern
    	fcbd986d61c726d64db940b27d4f3604a6cbecb0 [media] V4L: mt9m111: rewrite set_pixfmt
    	4e817223d7f4cf8b740037be4a1ca1578850e8c9 [media] V4L: mt9m111: fix missing return value check mt9m111_reg_clear
    nGene PCIE bridge driver, Copyright (C) 2005-2007 Micronas
    ngene 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
    ngene: Found Mystique SaTiX-S2 Dual (v2)
    ngene 0000:03:00.0: setting latency timer to 64
    ngene: Device version 1
    ngene: Loading firmware file ngene_18.fw.
    ngene 0000:03:00.0: irq 68 for MSI/MSI-X
    Attached CXD2099AR at 40
    LNBx2x attached on addr=a
    stv6110x_attach: Attaching STV6110x
    DVB: registering new adapter (nGene)
    DVB: registering adapter 0 frontend 0 (STV090x Multistandard)...
    LNBx2x attached on addr=8
    stv6110x_attach: Attaching STV6110x
    DVB: registering new adapter (nGene)
    DVB: registering adapter 1 frontend 0 (STV090x Multistandard)...
    No demod found on chan 2
    No demod found on chan 3
    DVB: registering new adapter (nGene)

>From lspci:
    03:00.0 Multimedia video controller [0400]: Micronas Semiconductor Holding AG Device [18c3:0720] (rev 01)
        Subsystem: Micronas Semiconductor Holding AG Device [18c3:db02]
        Flags: bus master, fast devsel, latency 0, IRQ 68
        Memory at b8910000 (32-bit, non-prefetchable) [size=64K]
        Memory at b8900000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: [40] Power Management version 2
        Capabilities: [48] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Capabilities: [58] Express Endpoint, MSI 00
        Capabilities: [100] Device Serial Number 00-00-00-00-00-00-00-00
        Capabilities: [400] Virtual Channel
        Kernel driver in use: ngene

