Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-relay1.leicester.gov.uk ([212.50.184.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <John.Chajecki@leicester.gov.uk>) id 1KSuZT-00031k-HL
	for linux-dvb@linuxtv.org; Tue, 12 Aug 2008 16:10:00 +0200
Message-Id: <48A1A78A0200005F00018038@vs-internet.council.leicester.gov.uk>
Date: Tue, 12 Aug 2008 15:08:58 +0100
From: "John Chajecki" <John.Chajecki@leicester.gov.uk>
To: <linux-dvb@linuxtv.org>
Mime-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Saa7134 with Avermedia M1155 hybrid card on Ubuntu 8.04
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

Hi, I'm trying to get an Avermedia M1155 Hybrid Aalogue/DVB tuner card to work with my Ubuntu Linux 8.04 (hardy) installation on a Sony VGX-TP1E media centre PC. In dmesg the card is identified as a Philips saa1733/1735:

  
[17205.851529] saa7130/34: v4l2 driver version 0.2.14 loaded
[17205.851785] saa7133[0]: found at 0000:04:05.0, rev: 209, irq: 20, latency: 32
, mmio: 0xf0207800
[17205.851830] saa7133[0]: subsystem: 1461:e836, board: UNKNOWN/GENERIC [card=0,
insmod option]
[17205.851845] saa7133[0]: board init: gpio is effffff
[17206.006586] saa7133[0]: i2c eeprom 00: 61 14 36 e8 00 00 00 00 00 00 00 00 00
 00 00 00
[17206.006611] saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff ff ff ff
 ff ff ff
[17206.006629] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 03 08 ff 00 00 ff
 ff ff ff
etc

However the board is shown as GENERIC, board=0. lsmod shows this:

Module                  Size  Used by
tuner                  28872  0
saa7134               147924  0
ir_common              42244  1 saa7134
compat_ioctl32          2304  1 saa7134
videobuf_dma_sg        14980  1 saa7134
videobuf_core          19716  2 saa7134,videobuf_dma_sg
tveeprom               13444  1 saa7134
mt352                   7684  0
videodev               36864  2 tuner,saa7134
v4l1_compat            15748  1 videodev
v4l2_common            12672  2 tuner,saa7134
i2c_core               24832  5 tuner,saa7134,tveeprom,mt352,v4l2_common


I've had a look at the supported board list at http://gentoo-wiki.com/HARDWARE_saa7134#i2c_Scan but my card does not seem to be present.

The saa1734 driver is loading, but there is no /dev/dvb or /dev//v4l directory.

Is this card not supported yet, or does it need to be manually loaded with the appropriate parameters?

I am quite willing to help with development and testing.



_
John Chajecki
Senior Infrastructure Engineer
Information Division
Resources Department
Leicester City Council

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
