Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpo.poczta.interia.pl ([217.74.65.207]:12424 "EHLO
	smtpo.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab2A2Qv6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Jan 2012 11:51:58 -0500
Date: Sun, 29 Jan 2012 17:31:16 +0100
From: =?UTF-8?b?UGF3ZcWC?= Drobek <vizjer@interia.pl>
Subject: need help with x3m dvb-t tuner on linux
To: linux-media@vger.kernel.org
In-Reply-To: <viyitbrrdsgzrnjmifkw@gisd>
References: <viyitbrrdsgzrnjmifkw@gisd>
Message-Id: <undrluogkfkokcvubohv@yfot>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi
I herbly please for assistance with x3m dvb-t tuner on linux. Let me know if this device has any chance to work on linux.
I followed http://linuxtv.org/wiki/index.php/X3m_digital_S.A_HPC2000 without success.
lspci output below 

pdmainframe pd # lspci 
00:00.0 RAM memory: nVidia Corporation MCP55 Memory Controller (rev a1)
00:01.0 ISA bridge: nVidia Corporation MCP55 LPC Bridge (rev a2)
00:01.1 SMBus: nVidia Corporation MCP55 SMBus (rev a2)
00:02.0 USB Controller: nVidia Corporation MCP55 USB Controller (rev a1)
00:02.1 USB Controller: nVidia Corporation MCP55 USB Controller (rev a2)
00:04.0 IDE interface: nVidia Corporation MCP55 IDE (rev a1)
00:05.0 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
00:05.1 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
00:06.0 PCI bridge: nVidia Corporation MCP55 PCI bridge (rev a2)
00:06.1 Audio device: nVidia Corporation MCP55 High Definition Audio (rev a2)
00:08.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a2)
00:0b.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a2)
00:0c.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a2)
00:0d.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a2)
00:0e.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a2)
00:0f.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a2)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
01:00.0 Multimedia video controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)
01:00.1 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder [Audio Port] (rev 05)
01:00.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] (rev 05)
06:00.0 PCI bridge: nVidia Corporation PCI express bridge for GTX 295 (rev a3)
07:00.0 PCI bridge: nVidia Corporation PCI express bridge for GTX 295 (rev a3)
07:02.0 PCI bridge: nVidia Corporation PCI express bridge for GTX 295 (rev a3)
08:00.0 3D controller: nVidia Corporation Device 05eb (rev a1)
09:00.0 VGA compatible controller: nVidia Corporation Device 05eb (rev a1)

dmesg | grep cx88 below

pdmainframe pd # dmesg | grep cx88
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.9 loaded
cx88/0: cx2388x v4l2 driver version 0.0.9 loaded
cx88[0]: subsystem: 14f1:8852, board: Leadtek WinFast DTV1800 Hybrid [card=81,insmod option], frontend(s): 1
cx88[0]: TV tuner type 71, Radio tuner type 71
cx88[0]: Asking xc2028/3028 to load firmware xc3028-v27.fw
input: cx88 IR (Leadtek WinFast DTV180 as /devices/pci0000:00/0000:00:06.0/0000:01:00.2/rc/rc1/input6
rc1: cx88 IR (Leadtek WinFast DTV180 as /devices/pci0000:00/0000:00:06.0/0000:01:00.2/rc/rc1
cx88[0]/2: cx2388x 8802 Driver Manager
cx88-mpeg driver manager 0000:01:00.2: PCI INT A -> Link[LNKA] -> GSI 19 (level, low) -> IRQ 19
cx88[0]/2: found at 0000:01:00.2, rev: 5, irq: 19, latency: 64, mmio: 0xf3000000
cx8800 0000:01:00.0: PCI INT A -> Link[LNKA] -> GSI 19 (level, low) -> IRQ 19
cx88[0]/0: found at 0000:01:00.0, rev: 5, irq: 19, latency: 64, mmio: 0xf5000000
cx88/2: cx2388x dvb driver version 0.0.9 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 14f1:8852, board: Leadtek WinFast DTV1800 Hybrid [card=81]
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/0: registered device radio0
cx88[0]/2: cx2388x based DVB/ATSC card
cx8802_alloc_frontends() allocating 1 frontend(s)
cx88_audio 0000:01:00.1: PCI INT A -> Link[LNKA] -> GSI 19 (level, low) -> IRQ 19
cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
cx88[0]/2: xc3028 attached
DVB: registering new adapter (cx88[0])

dmesg | grep xc2 below

xc2028 2-0061: i2c output error: rc = -5 (should be 4)
xc2028 2-0061: -5 returned from send
xc2028 2-0061: Error -22 while loading base firmware 

i tried a lot of firmwares (from debian, or other sources) - result is the same - stuck
