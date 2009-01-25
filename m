Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:35329 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750775AbZAYSjz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2009 13:39:55 -0500
Subject: [cx18] cx18-0: Could not start the CPU
From: Florian =?ISO-8859-1?Q?Sch=FCller?= <schuellerf@gmx.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Sun, 25 Jan 2009 19:39:48 +0100
Message-Id: <1232908788.6712.7.camel@flosmio>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!
can anyone help me?
my CX23418 does not seem to work...

I'm running a 64bit Ubuntu 8.10 on a Toshiba Qosmio Laptop

$ uname -a
Linux flosmio 2.6.27-9-generic #1 SMP Thu Nov 20 22:15:32 UTC 2008
x86_64 GNU/Linux

$ lspci -v
[...]
06:09.0 Multimedia video controller: Conexant Systems, Inc. CX23418
Single-Chip MPEG-2 Encoder with Integrated Analog Video/Broadcast Audio
Decoder
	Subsystem: Toshiba America Info Systems Device 0110
	Flags: bus master, medium devsel, latency 64, IRQ 19
	Memory at f4000000 (32-bit, non-prefetchable) [size=64M]
	Capabilities: <access denied>
	Kernel driver in use: cx18
	Kernel modules: cx18
[...]

Compilation of the newest cx18 (I hopfully did it right) gives:

$ dmesg -c
[ 5806.014965] Linux video capture interface: v2.00
[ 5806.059165] cx18:  Start initialization, version 1.0.4
[ 5806.059320] cx18-0: Initializing card #0
[ 5806.059323] cx18-0: Autodetected Toshiba Qosmio DVB-T/Analog card
[ 5806.064575] cx18-0: cx23418 revision 01010000 (B)
[ 5806.234577] cx18-0: Experimenters and photos needed for device to
work well.
[ 5806.234579] 	To help, mail the ivtv-devel list (www.ivtvdriver.org).
[ 5806.454154] Chip ID is not zero. It is not a TEA5767
[ 5806.454285] tuner 4-0060: chip found @ 0xc0 (cx18 i2c driver #0-1)
[ 5806.489651] xc2028 4-0060: creating new instance
[ 5806.489675] xc2028 4-0060: type set to XCeive xc2028/xc3028 tuner
[ 5806.489682] firmware: requesting v4l-cx23418-dig.fw
[ 5806.782200] cx18-0: loaded v4l-cx23418-dig.fw firmware (16382 bytes)
[ 5806.784097] cx18-0: Registered device video0 for encoder MPEG (64 x
32 kB)
[ 5806.789135] cx18-0: Registered device video32 for encoder YUV (16 x
128 kB)
[ 5806.791530] cx18-0: Registered device vbi0 for encoder VBI (60 x
17328 bytes)
[ 5806.793783] cx18-0: Registered device video24 for encoder PCM audio
(256 x 4 kB)
[ 5806.793808] cx18-0: Initialized card #0: Toshiba Qosmio DVB-T/Analog
[ 5806.795499] cx18:  End initialization
[ 5806.797103] firmware: requesting v4l-cx23418-cpu.fw
[ 5807.184500] cx18-0: loaded v4l-cx23418-cpu.fw firmware (174716 bytes)
[ 5807.256793] firmware: requesting v4l-cx23418-apu.fw
[ 5807.583799] cx18-0: loaded v4l-cx23418-apu.fw firmware V00120000
(141200 bytes)
[ 5808.401187] cx18-0: Could not start the CPU
[ 5808.401220] cx18-0: Retry loading firmware
[ 5808.405122] firmware: requesting v4l-cx23418-cpu.fw
[ 5808.794060] cx18-0: loaded v4l-cx23418-cpu.fw firmware (174716 bytes)
[ 5808.866513] firmware: requesting v4l-cx23418-apu.fw
[ 5809.174511] cx18-0: loaded v4l-cx23418-apu.fw firmware V00120000
(141200 bytes)
[ 5809.977264] cx18-0: Could not start the CPU
[ 5809.977295] cx18-0: Failed to initialize on minor 0
[ 5809.985454] cx18-0: Failed to initialize on minor 1
[ 5809.993718] cx18-0: Failed to initialize on minor 2
[ 5810.001484] cx18-0: Failed to initialize on minor 3



Regards
Flo

