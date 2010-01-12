Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:41672 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab0ALApL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2010 19:45:11 -0500
Received: from smtp08.web.de (fmsmtp08.dlan.cinetic.de [172.20.5.216])
	by fmmailgate03.web.de (Postfix) with ESMTP id E2ACB13BE95BB
	for <linux-media@vger.kernel.org>; Tue, 12 Jan 2010 01:45:09 +0100 (CET)
Received: from [91.19.4.165] (helo=pluto.localnet)
	by smtp08.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #314)
	id 1NUUsf-0004Ac-00
	for linux-media@vger.kernel.org; Tue, 12 Jan 2010 01:45:09 +0100
From: Markus Heidelberg <markus.heidelberg@web.de>
To: linux-media@vger.kernel.org
Subject: system hangs when loading b2c2-flexcop-pci.ko
Date: Tue, 12 Jan 2010 01:45:38 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201001120145.38435.markus.heidelberg@web.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Steps to reproduce with dmesg output:

# echo "7 4 1 7" > /proc/sys/kernel/printk
# modprobe b2c2-flexcop
b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver chip loaded successfully
# insmod b2c2-flexcop-pci.ko debug=0x1f
flexcop-pci: will use the HW PID filter
flexcop-pci: card revision 2
b2c2_flexcop_pci 0000:04:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
new wr: 208: 00000000
new wr: 210: c259b2ff

Then it hangs and I have to reset the machine.
This seems to be the beginning of the communication with the Flexcop
chip. The commands are executed in flexcop_reset().


System:

DVB PCI card: TechniSat DIGITAL SkyStar 2 Rev. 2.8B with Chip FLEXCOP IIB
              Is there a difference between Rev. 2.8 and 2.8B? Only 2.8
              is referenced in the sources.
Mainboard: D945GCLF2 with Intel Atom 330
OS: Gentoo Linux 64-Bit
Kernel: Linus' git tree (after 2.6.33-rc3), but it didn't work at my
        first try, which is some time ago, with a Gentoo Kernel based on
        the stable 2.6.27.12.

# lspci -vnn
04:00.0 Network controller [0280]: Techsan Electronics Co Ltd B2C2 FlexCopII DVB chip / Technisat SkyStar2 DVB card [13d0:2103] (rev 02)
        Subsystem: Techsan Electronics Co Ltd B2C2 FlexCopII DVB chip / Technisat SkyStar2 DVB card [13d0:2103]
        Flags: bus master, slow devsel, latency 32, IRQ 10
        Memory at 50100000 (32-bit, non-prefetchable) [size=64K]
        I/O ports at 1000 [size=32]
        Kernel modules: b2c2-flexcop-pci


I hope someone has an idea or can give me a tip how to find the problem.

Markus
