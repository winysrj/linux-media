Return-path: <mchehab@pedra>
Received: from cain.gsoft.com.au ([203.31.81.10]:54531 "EHLO cain.gsoft.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab1AIJZb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Jan 2011 04:25:31 -0500
From: "Daniel O'Connor" <darius@dons.net.au>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Date: Sun, 9 Jan 2011 19:55:08 +1030
Subject: Trouble with mythtv and media_build
To: linux-media@vger.kernel.org
Message-Id: <6662707F-771E-41A0-99A1-4C247A7E231B@dons.net.au>
Mime-Version: 1.0 (Apple Message framework v1082)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I installed media_build on a ubuntu 10.04 (kernel 2.6.32-26-generic) to see if I can get both channels working again, however now I find that mythtv drops out fairly regularly with "Video frame buffering failed too many times".

Also, the IR no longer works, the following is in dmesg:
[   20.032080] IR RC5(x) protocol handler initialized
[   20.034348] IR RC6 protocol handler initialized
[   20.036681] IR JVC protocol handler initialized
[   20.038843] IR Sony protocol handler initialized
[   20.041000] ir_lirc_codec: Unknown symbol lirc_dev_fop_poll
[   20.041110] ir_lirc_codec: Unknown symbol lirc_dev_fop_open
[   20.041195] ir_lirc_codec: disagrees about version of symbol lirc_get_pdata
[   20.041198] ir_lirc_codec: Unknown symbol lirc_get_pdata
[   20.041279] ir_lirc_codec: Unknown symbol lirc_dev_fop_close
[   20.041399] ir_lirc_codec: Unknown symbol lirc_dev_fop_read
[   20.041472] ir_lirc_codec: disagrees about version of symbol lirc_register_driver
[   20.041474] ir_lirc_codec: Unknown symbol lirc_register_driver
[   20.041650] ir_lirc_codec: Unknown symbol lirc_dev_fop_ioctl

And there is no /dev/input node.

I did some testing with mplayer and tzap and it seems to work OK though.

The hardware in question is: 
[   19.717981] cx23885 driver version 0.0.2 loaded
[   19.718025] cx23885 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   19.718068] CORE cx23885[0]: subsystem: 18ac:db78, board: DViCO FusionHDTV DVB-T Dual Express [card=11,autodetected]
[   19.724751] IR NEC protocol handler initialized
[   19.785216]   alloc irq_desc for 22 on node -1
[   19.785219]   alloc kstat_irqs on node -1
[   19.785226] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   19.785257] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   19.869906] usbcore: registered new interface driver imon
[   19.888867] cx23885_dvb_register() allocating 1 frontend(s)
[   19.888872] cx23885[0]: cx23885 based dvb card
[   19.908805] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input5
[   19.923266] xc2028 0-0061: creating new instance
[   19.923272] xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
[   19.923280] DVB: registering new adapter (cx23885[0])
[   19.923285] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
[   19.923910] cx23885_dvb_register() allocating 1 frontend(s)
[   19.923915] cx23885[0]: cx23885 based dvb card
[   19.924610] xc2028 1-0061: creating new instance
[   19.924613] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[   19.924617] DVB: registering new adapter (cx23885[0])
[   19.924622] DVB: registering adapter 1 frontend 0 (Zarlink ZL10353 DVB-T)...
[   19.925007] cx23885_dev_checkrevision() Hardware revision = 0xb0
[   19.925019] cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xf5000000
[   19.925026] cx23885 0000:02:00.0: setting latency timer to 64
[   19.925100]   alloc irq_desc for 30 on node -1
[   19.925103]   alloc kstat_irqs on node -1
[   19.925121] cx23885 0000:02:00.0: irq 30 for MSI/MSI-X

Any suggestions? I am going back to the vanilla kernel for now but I'm happy to test things :)

Thanks.

--
Daniel O'Connor software and network engineer
for Genesis Software - http://www.gsoft.com.au
"The nice thing about standards is that there
are so many of them to choose from."
  -- Andrew Tanenbaum
GPG Fingerprint - 5596 B766 97C0 0E94 4347 295E E593 DC20 7B3F CE8C






