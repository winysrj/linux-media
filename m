Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:38436 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753322Ab2DGSOK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Apr 2012 14:14:10 -0400
Message-ID: <4F8083E6.4040307@gmx.de>
Date: Sat, 07 Apr 2012 20:13:58 +0200
From: Hubert Fink <fink-hubert@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Need help to get Tevii S471 running
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello dear all,
i have buy a DVB-S2 card from Tevii S471 and i need help to get it 
running with
Debian Wheezy/Sid Kernel 3.2.0-2-686-pae.

The Tevii S471 was similar to the Tevii S470 but it has different LNB 
control.

The first thing I have to use the s2-liplianin drivers unfortunately I 
was not successful.
s2-liplianin:
 >cx23885: add TeVii s471 card.
 >From: Igor M. Liplianin <liplianin@me.by>
 >New TeVii s471 card is like s470 model,
 >but there is different LNB power control.

Next, I have made a git clone from media_build and change the files 
(cx23885-dvb.c, cx23885-cards.c, cx23885.h)
with code from s2-liplianin. See the diff output at the end of this message.
The compiling was now ready and i have installed the new driver.
It was loaded and the adapter0 was installed.

A scan with w_scan (w_scan -fs -s S19E2 -X > channels-sat1.conf) give me 
some errors like this:
(time: 00:11) diseqc_send_msg: FE_SET_VOLTAGE failed.
diseqc_send_msg: FE_SET_VOLTAGE failed.
But it found some but not all Channels it is a problem to switch the LNB.

A test was successful with Mplayer and a scanned channel (mplayer 
dvb://ZDF) unfortunately
the picture and sound output was disturbed.
After a restart and a new scan it found new channels but the card dont 
switch to the older channels.

Many Thanks for reading this message, hopefully
Hubert Fink

Some outputs and diffs:

ls -rl /dev/dvb/
insgesamt 0
drwxr-xr-x 2 root root 120 Apr  7 19:31 adapter0

dmesg output:
[   17.423214] cx23885 driver version 0.0.3 loaded
[   17.423246] cx23885 0000:05:00.0: PCI INT A -> GSI 48 (level, low) -> 
IRQ 48
[   17.423519] CORE cx23885[0]: subsystem: d471:9022, board: TeVii S471 
[card=35,autodetected]
[   17.549784] cx23885_dvb_register() allocating 1 frontend(s)
[   17.549788] cx23885[0]: cx23885 based dvb card
[   17.645414] DS3000 chip version: 0.192 attached.
[   17.645417] DVB: registering new adapter (cx23885[0])
[   17.645419] DVB: registering adapter 0 frontend 0 (Montage Technology 
DS3000/TS2020)...
[   17.672210] TeVii S471 MAC= 00:18:bd:5b:63:ad
[   17.672213] cx23885_dev_checkrevision() Hardware revision = 0xb0
[   17.672217] cx23885[0]/0: found at 0000:05:00.0, rev: 2, irq: 48, 
latency: 0, mmio: 0xfe400000
[   17.672222] cx23885 0000:05:00.0: setting latency timer to 64



diff ./cx23885-dvb.c ./cx23885-dvb.c.orig
491,494d490
< static int prof_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t 
voltage)
< {
<     struct cx23885_tsport *port = fe->dvb->priv;
<     struct cx23885_dev *dev = port->dev;
496,503d491
<     if (voltage == SEC_VOLTAGE_18)
<         cx_write(MC417_RWD, 0x00001e00);/* GPIO-13 high */
<     else if (voltage == SEC_VOLTAGE_13)
<         cx_write(MC417_RWD, 0x00001a00);/* GPIO-13 low */
<     else
<         cx_write(MC417_RWD, 0x00001800);/* GPIO-12 low */
<     return 0;
< }
985,994d972
<     case CX23885_BOARD_TEVII_S471:
<         i2c_bus = &dev->i2c_bus[1];
<
<         fe0->dvb.frontend = dvb_attach(ds3000_attach,
< &tevii_ds3000_config,
< &i2c_bus->i2c_adap);
<         if (fe0->dvb.frontend != NULL)
<             fe0->dvb.frontend->ops.set_voltage = f300_set_voltage;
<
<         break;
1270,1282d1247
<         memcpy(port->frontends.adapter.proposed_mac, eeprom + 0xa0, 6);
<         break;
<         }
<     case CX23885_BOARD_TEVII_S471: {
<         u8 eeprom[256]; /* 24C02 i2c eeprom */
<
<         if (port->nr != 1)
<             break;
<
<         /* Read entire EEPROM */
<         dev->i2c_bus[0].i2c_client.addr = 0xa0 >> 1;
<         tveeprom_read(&dev->i2c_bus[0].i2c_client, eeprom, 
sizeof(eeprom));
<         printk(KERN_INFO "TeVii S471 MAC= %pM\n", eeprom + 0xa0);

diff ./cx23885-cards.c ./cx23885-cards.c.orig:
500,504c500
<     },
<     [CX23885_BOARD_TEVII_S471] = {
<         .name        = "TeVii S471",
<         .portb        = CX23885_MPEG_DVB,
<     },
---
>      }
712,715d707
<     }, {
<         .subvendor = 0xd471,
<         .subdevice = 0x9022,
<         .card      = CX23885_BOARD_TEVII_S471,
1312,1322d1303
<     case CX23885_BOARD_TEVII_S471:
<         if (!enable_885_ir)
<             break;
<         dev->sd_ir = cx23885_find_hw(dev, CX23885_HW_AV_CORE);
<         if (dev->sd_ir == NULL) {
<             ret = -ENODEV;
<             break;
<         }
<         v4l2_subdev_call(dev->sd_cx25840, core, s_io_pin_config,
<                  ir_rx_pin_cfg_count, ir_rx_pin_cfg);
<         break;
1353d1333
<     case CX23885_BOARD_TEVII_S471:
1397d1376
<     case CX23885_BOARD_TEVII_S471:
1484d1462
<     case CX23885_BOARD_TEVII_S471:
1542d1519
<     case CX23885_BOARD_TEVII_S471:

diff ./cx23885.h ./cx23885.h.orig
92d91
< #define CX23885_BOARD_TEVII_S471               35

