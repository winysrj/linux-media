Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-09.arcor-online.net ([151.189.21.49])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1KT0ld-0001Rh-Jk
	for linux-dvb@linuxtv.org; Tue, 12 Aug 2008 22:46:59 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: John Chajecki <John.Chajecki@leicester.gov.uk>
In-Reply-To: <48A1A78A0200005F00018038@vs-internet.council.leicester.gov.uk>
References: <48A1A78A0200005F00018038@vs-internet.council.leicester.gov.uk>
Date: Tue, 12 Aug 2008 22:39:22 +0200
Message-Id: <1218573562.14931.8.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Saa7134 with Avermedia M1155 hybrid card on
	Ubuntu	8.04
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

Hello,

Am Dienstag, den 12.08.2008, 15:08 +0100 schrieb John Chajecki:
> Hi, I'm trying to get an Avermedia M1155 Hybrid Aalogue/DVB tuner card to work with my Ubuntu Linux 8.04 (hardy) installation on a Sony VGX-TP1E media centre PC. In dmesg the card is identified as a Philips saa1733/1735:
> 
>   
> [17205.851529] saa7130/34: v4l2 driver version 0.2.14 loaded
> [17205.851785] saa7133[0]: found at 0000:04:05.0, rev: 209, irq: 20, latency: 32
> , mmio: 0xf0207800
> [17205.851830] saa7133[0]: subsystem: 1461:e836, board: UNKNOWN/GENERIC [card=0,
> insmod option]
> [17205.851845] saa7133[0]: board init: gpio is effffff
> [17206.006586] saa7133[0]: i2c eeprom 00: 61 14 36 e8 00 00 00 00 00 00 00 00 00
>  00 00 00
> [17206.006611] saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff ff ff ff
>  ff ff ff
> [17206.006629] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 03 08 ff 00 00 ff
>  ff ff ff
> etc

the etc can hold some information, better don't drop parts of the eeprom
dump.

> However the board is shown as GENERIC, board=0. lsmod shows this:
> 
> Module                  Size  Used by
> tuner                  28872  0
> saa7134               147924  0
> ir_common              42244  1 saa7134
> compat_ioctl32          2304  1 saa7134
> videobuf_dma_sg        14980  1 saa7134
> videobuf_core          19716  2 saa7134,videobuf_dma_sg
> tveeprom               13444  1 saa7134
> mt352                   7684  0
> videodev               36864  2 tuner,saa7134
> v4l1_compat            15748  1 videodev
> v4l2_common            12672  2 tuner,saa7134
> i2c_core               24832  5 tuner,saa7134,tveeprom,mt352,v4l2_common
> 
> 
> I've had a look at the supported board list at http://gentoo-wiki.com/HARDWARE_saa7134#i2c_Scan but my card does not seem to be present.
> 
> The saa1734 driver is loading, but there is no /dev/dvb or /dev//v4l directory.
> 
> Is this card not supported yet, or does it need to be manually loaded with the appropriate parameters?
> 
> I am quite willing to help with development and testing.

The card is not yet supported, but was seen previously on some Sony Vaio
stuff.

We have no reports for any details on it, but there is a slight chance
that it is very similar to card=138, the AVERMEDIA_M115.

There is no DVB-T support yet and you would need recent XCeive firmware
in /lib/firmware if my guessing is right.

Are you sure DVB-T for this one is announced at all?

Cheers,
Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
