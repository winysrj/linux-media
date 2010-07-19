Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37887 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936202Ab0GSQJm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 12:09:42 -0400
Received: by fxm14 with SMTP id 14so2286141fxm.19
        for <linux-media@vger.kernel.org>; Mon, 19 Jul 2010 09:09:41 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 19 Jul 2010 18:09:40 +0200
Message-ID: <AANLkTikIJwr7TDC9OeymzffZ6dVGDEIJD7raqTeGT0m-@mail.gmail.com>
Subject: Twinhan DTV Ter-CI (3030 mantis)
From: Niklas Claesson <nicke.claesson@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

With a lot of help from Marko Ristola I finally made my tv-card
register correctly. I'm using the followin tree:
http://jusst.de/hg/mantis-v4l-dvb/ (14421:0e6ee2a233f0). With the
changes, that i have appended below, the frontend (zl10353) is
registered. However I don't see any channels when I scan with
kaffeine. I also tried the "scan"-utility from dvb-apps. What can I do
now?

niklas@niklas-desktop:~$ scan dvbtmp
scanning dvbtmp
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
ERROR: initial tuning failed
dumping lists (0 services)
Done.

At the same time the following occurs in syslog:

mantis_i2c_xfer (0): Messages:2
        Byte MODE:
        Byte <0> RXD=0x1f500c80  [0c]
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_write: Address=[0x0f] <W>[ 50 03 ]
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_write: Address=[0x0f] <W>[ 51 64 ]
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_write: Address=[0x0f] <W>[ 52 46 ]
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_write: Address=[0x0f] <W>[ 53 15 ]
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_write: Address=[0x0f] <W>[ 54 0f ]
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_write: Address=[0x0f] <W>[ 50 0c ]
mantis_i2c_xfer (0): Messages:1
        mantis_i2c_write: Address=[0x0f] <W>[ 51 44 ]

Successful probing in syslog:

Mantis 0000:05:02.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
DVB: registering new adapter (Mantis DVB adapter)
My demodulator id is 14
tda665x_attach: Attaching TDA665x (ENV57H12D5 (ET-50DT)) tuner
DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
Mantis 0000:05:02.0: PCI INT A disabled
found a VP-3030 PCI DVB-T device on (05:02.0),
Mantis 0000:05:02.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
    Mantis Rev 1 [1822:0024], irq: 23, latency: 64
    memory: 0x0, mmio: 0xfb904000
mantis_stream_control (0): Set stream to HIF
mantis_i2c_init (0): Initializing I2C ..
mantis_i2c_init (0): Disabling I2C interrupt
mantis_i2c_xfer (0): Messages:2
        mantis_i2c_write: Address=[0x50] <W>[ 08 ]
        mantis_i2c_read:  Address=[0x50] <R>[ 00 08 ca 1a 4d f6 ]
    MAC Address=[00:08:ca:1a:4d:f6]
mantis_dma_init (0): Mantis DMA init
mantis_alloc_buffers (0): DMA=0x33b00000 cpu=0xf3b00000 size=65536
mantis_alloc_buffers (0): RISC=0x33928000 cpu=0xf3928000 size=1000
mantis_calc_lines (0): Mantis RISC block bytes=[4096], line
bytes=[2048], line count=[32]
mantis_dvb_init (0): dvb_register_adapter
DVB: registering new adapter (Mantis DVB adapter)
mantis_dvb_init (0): dvb_dmx_init
mantis_dvb_init (0): dvb_dmxdev_init
mantis_frontend_power (0): Power ON
gpio_set_bits (0): Set Bit <12> to <1>
gpio_set_bits (0): GPIO Value <3000>
gpio_set_bits (0): Set Bit <12> to <1>
gpio_set_bits (0): GPIO Value <3000>
mantis_frontend_soft_reset (0): Frontend RESET
gpio_set_bits (0): Set Bit <13> to <0>
gpio_set_bits (0): GPIO Value <1000>
gpio_set_bits (0): Set Bit <13> to <0>
gpio_set_bits (0): GPIO Value <1000>
gpio_set_bits (0): Set Bit <13> to <1>
gpio_set_bits (0): GPIO Value <3000>
gpio_set_bits (0): Set Bit <13> to <1>
gpio_set_bits (0): GPIO Value <3000>
vp3030_frontend_init (0): Probing for 10353 (DVB-T)
mantis_i2c_xfer (0): Messages:2
        Byte MODE:
        Byte <0> RXD=0x1f7f1480  [14]
tda665x_attach: Attaching TDA665x (ENV57H12D5 (ET-50DT)) tuner
vp3030_frontend_init (0): Done!
DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
mantis_input_init (0): No RC codes available
mantis_uart_init (0): Initializing UART @ 9600bps parity:NONE
mantis_uart_init (0): UART succesfully initialized
mantis_uart_read (0): Reading ... <3f>
mantis_uart_work (0): UART BUF:0 <3f>


Changes to make it probe correctly:

diff -r 0e6ee2a233f0 linux/drivers/media/dvb/mantis/mantis_i2c.c
--- a/linux/drivers/media/dvb/mantis/mantis_i2c.c	Thu Feb 11 18:30:37 2010 +0400
+++ b/linux/drivers/media/dvb/mantis/mantis_i2c.c	Mon Jul 19 17:37:56 2010 +0200
@@ -158,6 +158,7 @@
 			mmwrite(txd, MANTIS_I2CDATA_CTL);
 			/* wait for xfer completion */
 			for (trials = 0; trials < TRIALS; trials++) {
+                                udelay(500);
 				stat = mmread(MANTIS_INT_STAT);
 				if (stat & MANTIS_INT_I2CDONE)
 					break;
diff -r 0e6ee2a233f0 linux/drivers/media/dvb/mantis/mantis_vp3030.c
--- a/linux/drivers/media/dvb/mantis/mantis_vp3030.c	Thu Feb 11
18:30:37 2010 +0400
+++ b/linux/drivers/media/dvb/mantis/mantis_vp3030.c	Mon Jul 19
17:37:56 2010 +0200
@@ -77,17 +77,12 @@
 static int vp3030_frontend_init(struct mantis_pci *mantis, struct
dvb_frontend *fe)
 {
 	struct i2c_adapter *adapter	= &mantis->adapter;
-	struct mantis_hwconfig *config	= mantis->hwconfig;
+
 	int err = 0;

-	gpio_set_bits(mantis, config->reset, 0);
-	msleep(100);
 	err = mantis_frontend_power(mantis, POWER_ON);
-	msleep(100);
-	gpio_set_bits(mantis, config->reset, 1);
-
 	if (err == 0) {
-		msleep(250);
+                mantis_frontend_soft_reset(mantis);
 		dprintk(MANTIS_ERROR, 1, "Probing for 10353 (DVB-T)");
 		fe = zl10353_attach(&mantis_vp3030_config, adapter);

Regards,
Niklas Claesson
