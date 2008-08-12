Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.29])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sparkmaul@gmail.com>) id 1KSolp-00081l-4s
	for linux-dvb@linuxtv.org; Tue, 12 Aug 2008 09:58:23 +0200
Received: by yw-out-2324.google.com with SMTP id 3so670619ywj.41
	for <linux-dvb@linuxtv.org>; Tue, 12 Aug 2008 00:58:16 -0700 (PDT)
Message-ID: <8e5b27790808120058o52c4c6bcw21152364b2613c39@mail.gmail.com>
Date: Tue, 12 Aug 2008 00:58:16 -0700
From: "Paul Marks" <paul@pmarks.net>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] FusionHDTV5 IR not working.
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I have a DViCO FusionHDTV5 RT Gold, with an IR sensor that connects to
the back of the card.  The remote is a "Fusion Remote MCE".  The video
capture stuff works just fine, but I've had no such luck with the
remote.

According to this commit, it looks like my setup is supposed to work:
http://linuxtv.org/hg/v4l-dvb/rev/d16b5cd5a283

When I enabled debug output for ir_kb2_i2c, this line caught my eye:
ir-kbd-i2c: probe 0x6b @ cx88[0]: no

I also enabled i2c_scan in the cx88xx module, and saw this:

cx88[0]: i2c register ok
cx88[0]: i2c scan: found device @ 0x1c  [lgdt330x]
cx88[0]: i2c scan: found device @ 0x86  [tda9887/cx22702]
cx88[0]: i2c scan: found device @ 0xa0  [eeprom]
cx88[0]: i2c scan: found device @ 0xa2  [???]
cx88[0]: i2c scan: found device @ 0xa4  [???]
cx88[0]: i2c scan: found device @ 0xa6  [???]
cx88[0]: i2c scan: found device @ 0xa8  [???]
cx88[0]: i2c scan: found device @ 0xaa  [???]
cx88[0]: i2c scan: found device @ 0xac  [???]
cx88[0]: i2c scan: found device @ 0xae  [???]
cx88[0]: i2c scan: found device @ 0xc2  [tuner (analog/dvb)]
cx88[0]: i2c scan: found device @ 0xde  [???]

lspci -v says:

01:06.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video
and Audio Decoder (rev 05)
        Subsystem: DViCO Corporation FusionHDTV 5 Gold
        Flags: medium devsel, IRQ 18
        Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [44] Vital Product Data <?>
        Capabilities: [4c] Power Management version 2
        Kernel modules: cx8800

01:06.1 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and
Audio Decoder [Audio Port] (rev 05)
        Subsystem: DViCO Corporation Device d500
        Flags: bus master, medium devsel, latency 4, IRQ 7
        Memory at f9000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2

01:06.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and
Audio Decoder [MPEG Port] (rev 05)
        Subsystem: DViCO Corporation DViCO FusionHDTV5 Gold
        Flags: bus master, medium devsel, latency 64, IRQ 18
        Memory at f8000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2
        Kernel driver in use: cx88-mpeg driver manager
        Kernel modules: cx8802


Does anyone know how to hack up this driver to determine where the
remote is hiding?  Let me know if any further info is needed.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
