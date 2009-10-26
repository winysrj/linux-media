Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52628 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbZJZSDq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2009 14:03:46 -0400
Message-ID: <4AE5E481.8010805@iki.fi>
Date: Mon, 26 Oct 2009 20:03:45 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx DVB modeswitching change: call for testers
References: <829197380910132052w155116ecrcea808abe87a57a6@mail.gmail.com>	 <4AE497B5.8050801@iki.fi>	 <829197380910260836o4b17a65ex8c46d1db8d6d3027@mail.gmail.com>	 <4AE5C7F9.6000502@iki.fi> <829197380910260909m42ed776bt56754b882d7ac426@mail.gmail.com>
In-Reply-To: <829197380910260909m42ed776bt56754b882d7ac426@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040009080307050708030402"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040009080307050708030402
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 10/26/2009 06:09 PM, Devin Heitmueller wrote:
> On Mon, Oct 26, 2009 at 12:02 PM, Antti Palosaari<crope@iki.fi>  wrote:
>> Is there any way to speed up Empia to handle streams bigger than ~45
>> Mbit/sec?
>
> Can you add a debug line that dumps out the values of register 0x01
> and register 0x5d and then send me the values?

Here you are.

Antti
-- 
http://palosaari.fi/

--------------040009080307050708030402
Content-Type: text/plain;
 name="anysee_qam256.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="anysee_qam256.txt"

[crope@localhost linuxtv]$ czap -a 0 -r "LIV"
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
110 LIV:290000000:INVERSION_AUTO:6875000:FEC_AUTO:QAM_256:451:452:8
110 LIV: f 290000000, s 6875000, i 2, fec 9, qam 5, v 0x1c3, a 0x1c4
status 00 | signal 8181 | snr bfbf | ber 000fffff | unc 00000199 | 
status 1f | signal 0c0c | snr efef | ber 000fffff | unc 0000062c | FE_HAS_LOCK
status 1f | signal 0c0c | snr efef | ber 0000000f | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0c0c | snr efef | ber 00000020 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0c0c | snr eeee | ber 00000014 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0c0c | snr f0f0 | ber 0000001e | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0c0c | snr efef | ber 0000001b | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0c0c | snr efef | ber 00000008 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0c0c | snr ecec | ber 00000016 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0c0c | snr efef | ber 00000014 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0c0c | snr eeee | ber 00000014 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0c0c | snr f0f0 | ber 00000012 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0c0c | snr f0f0 | ber 0000000a | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0c0c | snr f0f0 | ber 00000021 | unc 00000001 | FE_HAS_LOCK
^C
[crope@localhost linuxtv]$ 

-PID--FREQ-----BANDWIDTH-BANDWIDTH-
0000     5 p/s     0 kb/s     8 kbit
0001     9 p/s     1 kb/s    14 kbit
0010     8 p/s     1 kb/s    13 kbit
0011     0 p/s     0 kb/s     1 kbit
0012   141 p/s    25 kb/s   213 kbit
0020    48 p/s     8 kb/s    73 kbit
012d     9 p/s     1 kb/s    14 kbit
0191 10198 p/s  1872 kb/s 15338 kbit
0192   174 p/s    31 kb/s   262 kbit
01c2     9 p/s     1 kb/s    14 kbit
01c3  4428 p/s   812 kb/s  6659 kbit
01c4   261 p/s    47 kb/s   393 kbit
0202 10604 p/s  1946 kb/s 15949 kbit
020a     9 p/s     1 kb/s    14 kbit
0240    99 p/s    18 kb/s   150 kbit
025d     1 p/s     0 kb/s     2 kbit
025e     1 p/s     0 kb/s     2 kbit
025f     1 p/s     0 kb/s     2 kbit
0260     1 p/s     0 kb/s     2 kbit
0289   266 p/s    48 kb/s   400 kbit
17f2     9 p/s     1 kb/s    14 kbit
1ffe    25 p/s     4 kb/s    38 kbit
1fff  7400 p/s  1358 kb/s 11129 kbit
2000 33724 p/s  6191 kb/s 50721 kbit
-PID--FREQ-----BANDWIDTH-BANDWIDTH-
^C
[crope@localhost linuxtv]$ 


--------------040009080307050708030402
Content-Type: text/plain;
 name="em28xx_qam256.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="em28xx_qam256.txt"

Oct 26 19:51:13 localhost kernel: usbcore: deregistering interface driver em28xx
Oct 26 19:51:15 localhost kernel: usb 1-5: new high speed USB device using ehci_hcd and address 9
Oct 26 19:51:15 localhost kernel: usb 1-5: New USB device found, idVendor=eb1a, idProduct=2868
Oct 26 19:51:15 localhost kernel: usb 1-5: New USB device strings: Mfr=0, Product=1, SerialNumber=0
Oct 26 19:51:15 localhost kernel: usb 1-5: configuration #1 chosen from 1 choice
Oct 26 19:51:16 localhost kernel: Linux video capture interface: v2.00
Oct 26 19:51:16 localhost kernel: em28xx: New device @ 480 Mbps (eb1a:2868, interface 0, class 0)
Oct 26 19:51:16 localhost kernel: em28xx #0: chip ID is em2870
Oct 26 19:51:16 localhost kernel: em28xx_gpio_set: r01:0x13 r5d:0x0
Oct 26 19:51:16 localhost kernel: em28xx_gpio_set: r01:0x13 r5d:0x0
Oct 26 19:51:16 localhost kernel: em28xx_gpio_set: r01:0x13 r5d:0x0
Oct 26 19:51:16 localhost kernel: em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 68 28 c0 13 5c 00 6a 22 00 00
Oct 26 19:51:16 localhost kernel: em28xx #0: i2c eeprom 10: b8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Oct 26 19:51:16 localhost kernel: em28xx #0: i2c eeprom 20: b8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Oct 26 19:51:16 localhost kernel: em28xx #0: i2c eeprom 30: b8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Oct 26 19:51:16 localhost kernel: em28xx #0: i2c eeprom 40: b8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Oct 26 19:51:16 localhost kernel: em28xx #0: i2c eeprom 50: b8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Oct 26 19:51:16 localhost kernel: em28xx #0: i2c eeprom 60: b8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Oct 26 19:51:16 localhost kernel: em28xx #0: i2c eeprom 70: b8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Oct 26 19:51:16 localhost kernel: em28xx #0: i2c eeprom 80: b8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Oct 26 19:51:16 localhost kernel: em28xx #0: i2c eeprom 90: b8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Oct 26 19:51:16 localhost kernel: em28xx #0: i2c eeprom a0: b8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Oct 26 19:51:16 localhost kernel: em28xx #0: i2c eeprom b0: b8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Oct 26 19:51:16 localhost kernel: em28xx #0: i2c eeprom c0: b8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Oct 26 19:51:16 localhost kernel: em28xx #0: i2c eeprom d0: b8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Oct 26 19:51:16 localhost kernel: em28xx #0: i2c eeprom e0: b8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Oct 26 19:51:16 localhost kernel: em28xx #0: i2c eeprom f0: b8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Oct 26 19:51:16 localhost kernel: em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x63f653bd
Oct 26 19:51:16 localhost kernel: em28xx #0: EEPROM info:
Oct 26 19:51:16 localhost kernel: em28xx #0:	No audio on board.
Oct 26 19:51:16 localhost kernel: em28xx #0:	500mA max power
Oct 26 19:51:16 localhost kernel: em28xx #0:	Table at 0x00, strings=0x226a, 0x0000, 0x00b8
Oct 26 19:51:16 localhost kernel: em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=1)
Oct 26 19:51:16 localhost kernel: em28xx #0: Your board has no unique USB ID.
Oct 26 19:51:16 localhost kernel: em28xx #0: A hint were successfully done, based on eeprom hash.
Oct 26 19:51:16 localhost kernel: em28xx #0: This method is not 100% failproof.
Oct 26 19:51:16 localhost kernel: em28xx #0: If the board were missdetected, please email this log to:
Oct 26 19:51:16 localhost kernel: em28xx #0: 	V4L Mailing List  <linux-media@vger.kernel.org>
Oct 26 19:51:16 localhost kernel: em28xx #0: Board detected as Reddo DVB-C USB TV Box
Oct 26 19:51:16 localhost kernel: em28xx_gpio_set: r01:0x13 r5d:0x0
Oct 26 19:51:16 localhost kernel: em28xx_gpio_set: r01:0x13 r5d:0x0
Oct 26 19:51:16 localhost kernel: em28xx #0: v4l2 driver version 0.1.2
Oct 26 19:51:16 localhost kernel: em28xx #0 em28xx_set_alternate :minimum isoc packet size: 2888 (alt=6)
Oct 26 19:51:16 localhost kernel: em28xx #0 em28xx_set_alternate :setting alternate 6 with wMaxPacketSize=2892
Oct 26 19:51:16 localhost kernel: em28xx #0 em28xx_accumulator_set :em28xx Scale: (1,1)-(179,143)
Oct 26 19:51:16 localhost kernel: em28xx #0 em28xx_capture_area_set :em28xx Area Set: (180,144)
Oct 26 19:51:16 localhost kernel: em28xx #0: V4L2 video device registered as /dev/video0
Oct 26 19:51:16 localhost kernel: usbcore: registered new interface driver em28xx
Oct 26 19:51:16 localhost kernel: em28xx driver loaded
Oct 26 19:51:16 localhost kernel: em28xx_gpio_set: r01:0x13 r5d:0x0
Oct 26 19:51:16 localhost kernel: tuner-simple 2-0060: creating new instance
Oct 26 19:51:16 localhost kernel: tuner-simple 2-0060: type set to 82 (Philips CU1216L)
Oct 26 19:51:16 localhost kernel: DVB: registering new adapter (em28xx #0)
Oct 26 19:51:16 localhost kernel: DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-C)...
Oct 26 19:51:16 localhost kernel: em28xx_gpio_set: r01:0x13 r5d:0x0
Oct 26 19:51:16 localhost kernel: Successfully loaded em28xx-dvb
Oct 26 19:51:16 localhost kernel: Em28xx: Initialized (Em28xx dvb Extension) extension
Oct 26 19:51:16 localhost kernel: em28xx_gpio_set: r01:0x13 r5d:0x0
Oct 26 19:51:16 localhost kernel: em28xx #0 em28xx_accumulator_set :em28xx Scale: (1,1)-(179,143)
Oct 26 19:51:16 localhost kernel: em28xx #0 em28xx_capture_area_set :em28xx Area Set: (180,144)
Oct 26 19:51:16 localhost kernel: em28xx #0 em28xx_uninit_isoc :em28xx: called em28xx_uninit_isoc
Oct 26 19:51:16 localhost kernel: em28xx_gpio_set: r01:0x13 r5d:0x0


Oct 26 19:51:59 localhost kernel: em28xx_gpio_set: r01:0x13 r5d:0x0
Oct 26 19:52:00 localhost kernel: <<< 13
Oct 26 19:52:00 localhost kernel: em28xx #0 em28xx_isoc_dvb_max_packetsize :dvb max packet size=752
Oct 26 19:52:00 localhost kernel: em28xx #0 em28xx_init_isoc :em28xx: called em28xx_prepare_isoc
Oct 26 19:52:00 localhost kernel: em28xx #0 em28xx_uninit_isoc :em28xx: called em28xx_uninit_isoc
Oct 26 19:52:47 localhost kernel: em28xx_gpio_set: r01:0x13 r5d:0x0
Oct 26 19:52:47 localhost kernel: em28xx #0 em28xx_uninit_isoc :em28xx: called em28xx_uninit_isoc
Oct 26 19:52:59 localhost kernel: em28xx_gpio_set: r01:0x13 r5d:0x0
Oct 26 19:53:00 localhost kernel: <<< 13
Oct 26 19:53:00 localhost kernel: em28xx #0 em28xx_isoc_dvb_max_packetsize :dvb max packet size=752
Oct 26 19:53:00 localhost kernel: em28xx #0 em28xx_init_isoc :em28xx: called em28xx_prepare_isoc
Oct 26 19:53:00 localhost kernel: em28xx #0 em28xx_uninit_isoc :em28xx: called em28xx_uninit_isoc

Oct 26 19:53:18 localhost kernel: em28xx_gpio_set: r01:0x13 r5d:0x0
Oct 26 19:53:18 localhost kernel: em28xx #0 em28xx_uninit_isoc :em28xx: called em28xx_uninit_isoc
^C
[root@localhost em28xx-modeswitch]# hg diff
Not trusting file /home/crope/linuxtv/code/reddo_dvbc/em28xx-modeswitch/.hg/hgrc from untrusted user crope, group crope
Not trusting file /home/crope/linuxtv/code/reddo_dvbc/em28xx-modeswitch/.hg/hgrc from untrusted user crope, group crope
diff -r 6702a0527680 linux/drivers/media/video/em28xx/em28xx-core.c
--- a/linux/drivers/media/video/em28xx/em28xx-core.c	Tue Oct 13 23:44:09 2009 -0400
+++ b/linux/drivers/media/video/em28xx/em28xx-core.c	Mon Oct 26 19:53:37 2009 +0200
@@ -32,7 +32,7 @@
 
 /* #define ENABLE_DEBUG_ISOC_FRAMES */
 
-static unsigned int core_debug;
+static unsigned int core_debug = -1;
 module_param(core_debug, int, 0644);
 MODULE_PARM_DESC(core_debug, "enable debug messages [core]");
 
@@ -41,7 +41,7 @@
 		printk(KERN_INFO "%s %s :"fmt, \
 			 dev->name, __func__ , ##arg); } while (0)
 
-static unsigned int reg_debug;
+static unsigned int reg_debug = -1;
 module_param(reg_debug, int, 0644);
 MODULE_PARM_DESC(reg_debug, "enable debug messages [URB reg]");
 
@@ -817,6 +817,12 @@
 int em28xx_gpio_set(struct em28xx *dev, struct em28xx_reg_seq *gpio)
 {
 	int rc = 0;
+	int r01, r5d;
+
+	r01 = em28xx_read_reg(dev, 0x01);
+	r5d = em28xx_read_reg(dev, 0x5d);
+	printk(KERN_INFO "%s: r01:0x%x r5d:0x%x\n", __func__, r01, r5d);
+//	printk(KERN_INFO "Em28xx: Initialized (%s) extension\n", ops->name);
 
 	if (!gpio)
 		return rc;
diff -r 6702a0527680 linux/drivers/media/video/em28xx/em28xx-dvb.c
--- a/linux/drivers/media/video/em28xx/em28xx-dvb.c	Tue Oct 13 23:44:09 2009 -0400
+++ b/linux/drivers/media/video/em28xx/em28xx-dvb.c	Mon Oct 26 19:53:37 2009 +0200
@@ -40,7 +40,7 @@
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
 MODULE_LICENSE("GPL");
 
-static unsigned int debug;
+static unsigned int debug = 1;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "enable debug messages [dvb]");
 
@@ -48,7 +48,7 @@
 
 #define dprintk(level, fmt, arg...) do {			\
 if (debug >= level) 						\
-	printk(KERN_DEBUG "%s/2-dvb: " fmt, dev->name, ## arg);	\
+	printk(KERN_INFO "%s/2-dvb: " fmt, dev->name, ## arg);	\
 } while (0)
 
 #define EM28XX_DVB_NUM_BUFS 5
[root@localhost em28xx-modeswitch]# 


-PID--FREQ-----BANDWIDTH-BANDWIDTH-
0000     7 p/s     1 kb/s    11 kbit
0001     6 p/s     1 kb/s    10 kbit
0010     8 p/s     1 kb/s    13 kbit
0011     0 p/s     0 kb/s     1 kbit
0012   122 p/s    22 kb/s   183 kbit
0020    60 p/s    11 kb/s    90 kbit
012d     7 p/s     1 kb/s    11 kbit
0191  9321 p/s  1711 kb/s 14019 kbit
0192   161 p/s    29 kb/s   243 kbit
01c2    11 p/s     2 kb/s    17 kbit
01c3  4055 p/s   744 kb/s  6099 kbit
01c4   230 p/s    42 kb/s   346 kbit
0202  9747 p/s  1789 kb/s 14659 kbit
020a    10 p/s     1 kb/s    16 kbit
022f     0 p/s     0 kb/s     1 kbit
0240    97 p/s    17 kb/s   146 kbit
025d     1 p/s     0 kb/s     2 kbit
025e     2 p/s     0 kb/s     4 kbit
025f     1 p/s     0 kb/s     2 kbit
0260     1 p/s     0 kb/s     2 kbit
0279     0 p/s     0 kb/s     1 kbit
0289   234 p/s    42 kb/s   352 kbit
0374     0 p/s     0 kb/s     1 kbit
0398     0 p/s     0 kb/s     1 kbit
0408     0 p/s     0 kb/s     1 kbit
0523     0 p/s     0 kb/s     1 kbit
0542     0 p/s     0 kb/s     1 kbit
056d     0 p/s     0 kb/s     1 kbit
0611     0 p/s     0 kb/s     1 kbit
0624     0 p/s     0 kb/s     1 kbit
070e     0 p/s     0 kb/s     1 kbit
07ab     0 p/s     0 kb/s     1 kbit
081b     0 p/s     0 kb/s     1 kbit
0873     0 p/s     0 kb/s     1 kbit
08b7     0 p/s     0 kb/s     1 kbit
09e3     0 p/s     0 kb/s     1 kbit
0a42     0 p/s     0 kb/s     1 kbit
0bf6     0 p/s     0 kb/s     1 kbit
0c4e     0 p/s     0 kb/s     1 kbit
0c98     0 p/s     0 kb/s     1 kbit
0e67     0 p/s     0 kb/s     1 kbit
0f52     0 p/s     0 kb/s     1 kbit
0fcd     0 p/s     0 kb/s     1 kbit
1017     0 p/s     0 kb/s     1 kbit
104c     0 p/s     0 kb/s     1 kbit
10ed     0 p/s     0 kb/s     1 kbit
1243     0 p/s     0 kb/s     1 kbit
128b     0 p/s     0 kb/s     1 kbit
12c2     0 p/s     0 kb/s     1 kbit
12d1     0 p/s     0 kb/s     1 kbit
138e     0 p/s     0 kb/s     1 kbit
13bf     0 p/s     0 kb/s     1 kbit
14b2     0 p/s     0 kb/s     1 kbit
15ad     0 p/s     0 kb/s     1 kbit
15d4     0 p/s     0 kb/s     1 kbit
16a8     0 p/s     0 kb/s     1 kbit
1750     0 p/s     0 kb/s     1 kbit
17f2     6 p/s     1 kb/s    10 kbit
183d     0 p/s     0 kb/s     1 kbit
1880     0 p/s     0 kb/s     1 kbit
18e7     0 p/s     0 kb/s     1 kbit
196f     0 p/s     0 kb/s     1 kbit
198a     0 p/s     0 kb/s     1 kbit
19fe     0 p/s     0 kb/s     1 kbit
1b8b     0 p/s     0 kb/s     1 kbit
1bd0     0 p/s     0 kb/s     1 kbit
1c9f     0 p/s     0 kb/s     1 kbit
1d19     0 p/s     0 kb/s     1 kbit
1e35     0 p/s     0 kb/s     1 kbit
1ffe    20 p/s     3 kb/s    31 kbit
1fff  6814 p/s  1251 kb/s 10248 kbit
2000 30984 p/s  5688 kb/s 46600 kbit
-PID--FREQ-----BANDWIDTH-BANDWIDTH-
^C
[crope@localhost linuxtv]$ 

[crope@localhost linuxtv]$ czap -a 0 -r "LIV"
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
110 LIV:290000000:INVERSION_AUTO:6875000:FEC_AUTO:QAM_256:451:452:8
110 LIV: f 290000000, s 6875000, i 2, fec 9, qam 5, v 0x1c3, a 0x1c4
status 03 | signal b4b4 | snr dbdb | ber 000fffff | unc 000000bd | 
status 1f | signal c3c3 | snr f3f3 | ber 000006c0 | unc 00000002 | FE_HAS_LOCK
status 1f | signal c3c3 | snr f2f2 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal c3c3 | snr f2f2 | ber 00000008 | unc 00000000 | FE_HAS_LOCK
status 1f | signal c3c3 | snr f2f2 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal c3c3 | snr f2f2 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal c3c3 | snr f3f3 | ber 00000002 | unc 00000000 | FE_HAS_LOCK
status 1f | signal c3c3 | snr f2f2 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal f9f9 | snr f6f6 | ber 00000000 | unc 00000393 | FE_HAS_LOCK
status 1f | signal c3c3 | snr f3f3 | ber 00000000 | unc 000005bd | FE_HAS_LOCK
status 1f | signal c3c3 | snr f2f2 | ber 00000000 | unc 000002d3 | FE_HAS_LOCK
status 1f | signal c3c3 | snr f3f3 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal c3c3 | snr f3f3 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal c3c3 | snr f3f3 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal c3c3 | snr f2f2 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal c3c3 | snr f2f2 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal c3c3 | snr f3f3 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal c3c3 | snr f3f3 | ber 00000001 | unc 00000000 | FE_HAS_LOCK
^C
[crope@localhost linuxtv]$ 


--------------040009080307050708030402--
