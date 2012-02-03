Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail81.extendcp.co.uk ([79.170.40.81]:43007 "EHLO
	mail81.extendcp.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756877Ab2BCRM5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2012 12:12:57 -0500
Received: from 188-222-111-86.zone13.bethere.co.uk ([188.222.111.86] helo=junior)
	by mail81.extendcp.com with esmtpa (Exim 4.77)
	id 1RtMgx-0007rJ-DB
	for linux-media@vger.kernel.org; Fri, 03 Feb 2012 17:12:55 +0000
Date: Fri, 3 Feb 2012 17:12:50 +0000
From: Tony Houghton <h@realh.co.uk>
To: linux-media@vger.kernel.org
Subject: TBS 6920 remote
Message-ID: <20120203171250.52278c25@junior>
Reply-To: linux-media@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've got a TBS 6920 PCI-E DVB-S2 card, which explicitly claims Linux
compatibility on the box. It works as a satellite receiver, but I get no
response from the remote control (trying to read /dev/input/event5). I
think this is its entry in /proc/bus/input/devices:

I: Bus=0019 Vendor=0000 Product=0006 Version=0000
N: Name="Video Bus"
P: Phys=LNXVIDEO/video/input0
S: Sysfs=/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:12/LNXVIDEO:00/input/input5
U: Uniq=
H: Handlers=kbd event5 
B: PROP=0
B: EV=3
B: KEY=3e000b00000000 0 0 0

And lspci -v:

03:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI Video and Audio Decoder (rev 02)
	Subsystem: Device 6920:8888
	Flags: bus master, fast devsel, latency 0, IRQ 19
	Memory at fea00000 (64-bit, non-prefetchable) [size=2M]
	Capabilities: [40] Express Endpoint, MSI 00
	Capabilities: [80] Power Management version 2
	Capabilities: [90] Vital Product Data
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [200] Virtual Channel
	Kernel driver in use: cx23885


Is there an extra module I need to load to make it work, or is any work
being done on this if it isn't supported yet? Is there anything I can do
to help? I'm an experienced C programmer, but not a kernel hacker.
