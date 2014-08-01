Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f44.google.com ([209.85.216.44]:40584 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaHADkh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jul 2014 23:40:37 -0400
Received: by mail-qa0-f44.google.com with SMTP id f12so3362237qad.31
        for <linux-media@vger.kernel.org>; Thu, 31 Jul 2014 20:40:36 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 1 Aug 2014 03:40:36 +0000
Message-ID: <CAEJHKkV+DztXiJtPc41m=f1vJG26AoWGd+dinCQhJ77bVY=D0Q@mail.gmail.com>
Subject: tvtuner pixelview B1000
From: basteon <basteon@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hello.

I have pixelview B1000 card and this card won't work with assigned
modules cx8800, cx8802.

May be I'm use wrong modules or cardid prefix:
1554:4952, board: PixelView [card=3...

# /usr/bin/tvtime-scanner
Reading configuration from /etc/tvtime/tvtime.xml
Scanning using TV standard NTSC.
Scanning from  44.00 MHz to 958.00 MHz.
MHz:  - No signal

===============================
01:06.0 Multimedia video controller: Conexant Systems, Inc.
CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)
	Subsystem: PROLINK Microsystems Corp Device 4952
	Flags: bus master, medium devsel, latency 32, IRQ 10
	Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2
	Kernel modules: cx8800

01:06.1 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3
PCI Video and Audio Decoder [Audio Port] (rev 05)
	Subsystem: PROLINK Microsystems Corp Device 4952
	Flags: bus master, medium devsel, latency 32, IRQ 10
	Memory at fc000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [4c] Power Management version 2
	Kernel modules: cx88-alsa

01:06.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3
PCI Video and Audio Decoder [MPEG Port] (rev 05)
	Subsystem: PROLINK Microsystems Corp Device 4952
	Flags: bus master, medium devsel, latency 32, IRQ 10
	Memory at fb000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [4c] Power Management version 2
	Kernel modules: cx8802

===============================
[18334.495349] Linux video capture interface: v2.00
[18334.603004] IR NEC protocol handler initialized
[18334.614074] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.8 loaded
[18334.618258] cx88[0]: subsystem: 1554:4952, board: PixelView
[card=3,autodetected], frontend(s): 0
[18334.618263] cx88[0]: TV tuner type 5, Radio tuner type -1
[18334.628915] IR RC5(x) protocol handler initialized
[18334.660809] IR RC6 protocol handler initialized
[18334.687047] IR JVC protocol handler initialized
[18334.714899] IR Sony protocol handler initialized
[18334.754031] lirc_dev: IR Remote Control driver registered, major 252
[18334.764669] IR LIRC bridge handler initialized
[18334.850358] cx88[0]/2: cx2388x 8802 Driver Manager
[18343.108212] cx88/0: cx2388x v4l2 driver version 0.0.8 loaded
[18343.108317] cx8800 0000:01:06.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[18343.112467] cx88[0]: subsystem: 1554:4952, board: PixelView
[card=3,autodetected], frontend(s): 0
[18343.112473] cx88[0]: TV tuner type 5, Radio tuner type -1
[18343.312410] cx88[0]/0: found at 0000:01:06.0, rev: 5, irq: 20,
latency: 32, mmio: 0xfd000000
[18343.316831] cx88[0]/0: registered device video0 [v4l2]
[18343.326623] cx88[0]/0: registered device vbi0
[18343.333136] cx88[0]/0: registered device radio0
