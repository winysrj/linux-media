Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <david@istwok.net>) id 1KP7vC-0001S1-5P
	for linux-dvb@linuxtv.org; Sat, 02 Aug 2008 05:36:47 +0200
Received: from opus ([76.184.165.27]) by cdptpa-omta02.mail.rr.com with ESMTP
	id <20080802033607.XFHK15817.cdptpa-omta02.mail.rr.com@opus>
	for <linux-dvb@linuxtv.org>; Sat, 2 Aug 2008 03:36:07 +0000
Date: Fri, 1 Aug 2008 22:36:02 -0500
From: David Engel <david@istwok.net>
To: linux-dvb@linuxtv.org
Message-ID: <20080802033602.GA13245@opus.istwok.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
Subject: [linux-dvb] Possible tuner problem in current Hg
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Are there any known tuner problems in current Mercurial, particularly
with the saa7134 driver and/or the 2.6.25.x kernel?

I'm trying to use Janne Grunau's driver for the Hauppauge HD-PVR in a
system which also has a KWorld ATSC 115.  The HD-PVR driver works as
expected with it's many known issues but the ATSC 115 doesn't work
with Janne's driver.  Mplayer reports an inability to lock onto a
signal after 30 seconds when trying to use the ATSC 115.

To rule out any HD-PVR specific changes, I tried main-line v4l-dvb
drivers myself and got the same results on the ATSC 115 as with
Janne's version.  Most recently, I just tried the 2.6.25.14 kernel
with the following v4l-dvb tip revision.

    changeset:   8582:cbfa05ad2711
    tag:         tip
    user:        Mauro Carvalho Chehab <mchehab@infradead.org>
    date:        Fri Aug 01 08:23:41 2008 -0300
    summary:     set mts_firmware for em2882 based Pinnacle Hybrid Pro

I'm attaching a couple of short log snippets from when the saa7134-dvb
and required modules are loaded.  kern.log.good is from using the
stock v4l drivers from the 2.6.25.14 kernel and kern.log.bad is from
using the current v4l-dvb drivers in Mercurial.  The only differences
are the "tuner-simple" lines in the bad version.

Any help in solving this problem with the ATSC 115 is greatly
appreciated as it's a big inconvenience to keep switching driver
versions when changing between capture devices.  I can provide more
detailed logs or run additional tests as requested.

David
-- 
David Engel
david@istwok.net

--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="kern.log.good"

Aug  1 21:24:41 opus kernel: Linux video capture interface: v2.00
Aug  1 21:24:41 opus kernel: saa7130/34: v4l2 driver version 0.2.14 loaded
Aug  1 21:24:41 opus kernel: saa7133[0]: found at 0000:01:08.0, rev: 209, irq: 16, latency: 255, mmio: 0xfdeff000
Aug  1 21:24:41 opus kernel: saa7133[0]: subsystem: 17de:7352, board: Kworld ATSC110/115 [card=90,autodetected]
Aug  1 21:24:41 opus kernel: saa7133[0]: board init: gpio is 100
Aug  1 21:24:41 opus kernel: saa7133[0]: i2c eeprom 00: de 17 52 73 ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:24:41 opus kernel: saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:24:41 opus kernel: saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:24:41 opus kernel: saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:24:41 opus kernel: saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:24:41 opus kernel: saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:24:41 opus kernel: saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:24:41 opus kernel: saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:24:41 opus kernel: saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:24:41 opus kernel: saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:24:41 opus kernel: saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:24:41 opus kernel: saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:24:41 opus kernel: saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:24:41 opus kernel: saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:24:41 opus kernel: saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:24:41 opus kernel: saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:24:41 opus kernel: saa7133[0]: registered device video2 [v4l2]
Aug  1 21:24:41 opus kernel: saa7133[0]: registered device vbi2
Aug  1 21:24:41 opus kernel: nxt200x: NXT2004 Detected
Aug  1 21:24:41 opus kernel: DVB: registering new adapter (saa7133[0])
Aug  1 21:24:41 opus kernel: DVB: registering frontend 0 (Nextwave NXT200X VSB/QAM frontend)...
Aug  1 21:24:41 opus kernel: nxt2004: Waiting for firmware upload (dvb-fe-nxt2004.fw)...
Aug  1 21:24:41 opus kernel: nxt2004: Waiting for firmware upload(2)...
Aug  1 21:24:42 opus kernel: nxt2004: Firmware upload complete
Aug  1 21:24:42 opus kernel: nxt200x: Timeout waiting for nxt2004 to init.

--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="kern.log.bad"

Aug  1 21:29:38 opus kernel: Linux video capture interface: v2.00
Aug  1 21:29:38 opus kernel: saa7130/34: v4l2 driver version 0.2.14 loaded
Aug  1 21:29:38 opus kernel: saa7133[0]: found at 0000:01:08.0, rev: 209, irq: 16, latency: 255, mmio: 0xfdeff000
Aug  1 21:29:38 opus kernel: saa7133[0]: subsystem: 17de:7352, board: Kworld ATSC110/115 [card=90,autodetected]
Aug  1 21:29:38 opus kernel: saa7133[0]: board init: gpio is 100
Aug  1 21:29:39 opus kernel: saa7133[0]: i2c eeprom 00: de 17 52 73 ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:29:39 opus kernel: saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:29:39 opus kernel: saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:29:39 opus kernel: saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:29:39 opus kernel: saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:29:39 opus kernel: saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:29:39 opus kernel: saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:29:39 opus kernel: saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:29:39 opus kernel: saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:29:39 opus kernel: saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:29:39 opus kernel: saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:29:39 opus kernel: saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:29:39 opus kernel: saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:29:39 opus kernel: saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:29:39 opus kernel: saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:29:39 opus kernel: saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Aug  1 21:29:39 opus kernel: saa7133[0]: registered device video2 [v4l2]
Aug  1 21:29:39 opus kernel: saa7133[0]: registered device vbi2
Aug  1 21:29:39 opus kernel: nxt200x: NXT2004 Detected
Aug  1 21:29:39 opus kernel: tuner-simple 2-0061: creating new instance
Aug  1 21:29:39 opus kernel: tuner-simple 2-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual in)
Aug  1 21:29:39 opus kernel: DVB: registering new adapter (saa7133[0])
Aug  1 21:29:39 opus kernel: DVB: registering frontend 0 (Nextwave NXT200X VSB/QAM frontend)...
Aug  1 21:29:39 opus kernel: nxt2004: Waiting for firmware upload (dvb-fe-nxt2004.fw)...
Aug  1 21:29:39 opus kernel: nxt2004: Waiting for firmware upload(2)...
Aug  1 21:29:40 opus kernel: nxt2004: Firmware upload complete
Aug  1 21:29:40 opus kernel: nxt200x: Timeout waiting for nxt2004 to init.

--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--sdtB3X0nJg68CQEu--
