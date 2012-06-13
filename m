Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:33060 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab2FMNzg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 09:55:36 -0400
Received: by ghrr11 with SMTP id r11so393047ghr.19
        for <linux-media@vger.kernel.org>; Wed, 13 Jun 2012 06:55:36 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 13 Jun 2012 15:55:36 +0200
Message-ID: <CAPz3gmnaPdm1V6GyPB8wPv5WCcg_pJ4HctsQiqROLanbLA=amA@mail.gmail.com>
Subject: Hauppauge WinTV Nova S Plus Composite IN
From: shacky <shacky83@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

I'm trying to record some video using the composite input of the
Hauppauge WinTV Nova S Plus, which is indicated as supported on
http://linuxtv.org/wiki/index.php/DVB-S_PCI_Cards.

I tried playing video from the input with VLC and mplayer, but I'm
getting a black screen.

I checked all cables and they work good, I checked viewing the output
with a regular TV and I can see the image.

I have the devide /dev/video0, as following in dmesg:
[    6.650431] cx88[0]/0: registered device video0 [v4l2]

This is the complete output:
[    6.550138] rc0: cx88 IR (Hauppauge Nova-S-Plus  as
/devices/pci0000:00/0000:00:04.0/0000:01:06.0/rc/rc0
[    6.550194] rc rc0: lirc_dev: driver ir-lirc-codec (cx88xx)
registered at minor = 0
[    6.550198] cx88[0]/0: found at 0000:01:06.0, rev: 5, irq: 19,
latency: 64, mmio: 0xdf000000
[    6.644067] wm8775 2-001b: chip found @ 0x36 (cx88[0])
[    6.650431] cx88[0]/0: registered device video0 [v4l2]
[    6.650448] cx88[0]/0: registered device vbi0
[    6.660015] cx88[0]/2: cx2388x 8802 Driver Manager
[    6.660025] cx88-mpeg driver manager 0000:01:06.2: PCI INT A ->
Link[LNKA] -> GSI 19 (level, low) -> IRQ 19
[    6.660031] cx88[0]/2: found at 0000:01:06.2, rev: 5, irq: 19,
latency: 64, mmio: 0xdd000000
[    6.660111] cx88_audio 0000:01:06.1: PCI INT A -> Link[LNKA] -> GSI
19 (level, low) -> IRQ 19
[    6.660129] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
[    6.811716] forcedeth 0000:00:07.0: irq 43 for MSI/MSI-X
[    6.911220] cx88/2: cx2388x dvb driver version 0.0.8 loaded
[    6.911222] cx88/2: registering cx8802 driver, type: dvb access: shared
[    6.911225] cx88[0]/2: subsystem: 0070:9202, board: Hauppauge
Nova-S-Plus DVB-S [card=37]
[    6.911227] cx88[0]/2: cx2388x based DVB/ATSC card
[    6.911228] cx8802_alloc_frontends() allocating 1 frontend(s)
[    7.062363] CX24123: detected CX24123
[    7.130058] [drm] nouveau 0000:00:0d.0: 1 available performance level(s)
[    7.130061] [drm] nouveau 0000:00:0d.0: 0: memory 0MHz core 425MHz
fanspeed 100%
[    7.130069] [drm] nouveau 0000:00:0d.0: c: memory 0MHz
[    7.130144] [TTM] Zone  kernel: Available graphics memory: 3967714 kiB.
[    7.130146] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[    7.130147] [TTM] Initializing pool allocator.
[    7.130155] [drm] nouveau 0000:00:0d.0: Detected 256MiB VRAM
[    7.133145] [drm] nouveau 0000:00:0d.0: 64 MiB GART (aperture)
[    7.133333] [drm] nouveau 0000:00:0d.0: unknown connector type: 0xff!!
[    7.134520] DVB: registering new adapter (cx88[0])
[    7.134524] DVB: registering adapter 0 frontend 0 (Conexant
CX24123/CX24109)...

Could you help me, please?

Thank you very much,
bye.
