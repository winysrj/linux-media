Return-path: <linux-media-owner@vger.kernel.org>
Received: from web25804.mail.ukl.yahoo.com ([217.12.10.189]:45644 "HELO
	web25804.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1765531AbZEAWd2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 May 2009 18:33:28 -0400
Message-ID: <475610.5602.qm@web25804.mail.ukl.yahoo.com>
Date: Fri, 1 May 2009 22:26:47 +0000 (GMT)
From: m8hpw@yahoo.fr
Reply-To: m8hpw@yahoo.fr
Subject: dib3000 (dvb) driver bug with ubuntu 9.04 (2.6.28 kernel)?
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Hello,

Since a couple of years, I use a WinFast DTV Dongle (dib3000mc) on a ASUS (intel) laptop without any trouble. It works with ubuntu 8.04. The quality is perfect

I use now the same dongle on a recent laptop PC based on a GA-MA78GM-US2H mother board and the quality of the image is very bad and the soft (me-tv) rebuffer very often. It is unlikely a probleme of signal strength, because on the same antenna plug, the dvb works very well with the laptop, and very bad with the desktop computer. See below some informations about the dvb with the two configrations : laptop and the desktop computer.

I noticed that there are some differences between the loaded modules. i2c_core and usbcore are abscent with ubuntu 9.04. Is it normal? Morever if you carefully look at the dvbtraffic, it is lower for the LAPTOP for a same program. This is very repetive behaviour. It is not normal.

Does anyone have an idea of whats wrong with the LAPTOP configuration.

Thanks.

Julien R.


***********************************************
LAPTOP (GOOD image quality)

uname -a :
Linux portable 2.6.24-23-generic #1 SMP Wed Apr 1 21:47:28 UTC 2009 i686 GNU/Linux

lsusb:
Bus 005 Device 011: ID 0413:6026 Leadtek Research, Inc. WinFast DTV Dongle (warm state)


lsmod | grep dvb
dvb_usb_dibusb_mc       6400  0
dvb_usb_dibusb_common    10756  1 dvb_usb_dibusb_mc
dib3000mc              13960  2 dvb_usb_dibusb_common
dvb_usb                19852  2 dvb_usb_dibusb_mc,dvb_usb_dibusb_common
dvb_core               81404  1 dvb_usb
i2c_core               24832  4 mt2060,dib3000mc,dibx000_common,dvb_usb
usbcore               146412  5 dvb_usb_dibusb_mc,dvb_usb,ehci_hcd,uhci_hcd

tzap "ARTE"
status 1f | signal c058 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK

dvbtraffic
0000     9 p/s     1 kb/s    14 kbit
0010     5 p/s     0 kb/s     8 kbit
0011     0 p/s     0 kb/s     1 kbit
0012    12 p/s     2 kb/s    19 kbit
0015     1 p/s     0 kb/s     2 kbit
006e     9 p/s     1 kb/s    14 kbit
0078  1697 p/s   311 kb/s  2553 kbit
0082   132 p/s    24 kb/s   198 kbit
008c    32 p/s     5 kb/s    49 kbit
00d2     9 p/s     1 kb/s    14 kbit
00dc  2189 p/s   401 kb/s  3292 kbit
00e6   132 p/s    24 kb/s   198 kbit
00f0     3 p/s     0 kb/s     5 kbit
0136     9 p/s     1 kb/s    14 kbit
0140  1527 p/s   280 kb/s  2296 kbit
014a   131 p/s    24 kb/s   197 kbit
0154     1 p/s     0 kb/s     2 kbit
01fe     9 p/s     1 kb/s    14 kbit
0208  2104 p/s   386 kb/s  3164 kbit
0212   131 p/s    24 kb/s   197 kbit
0213   132 p/s    24 kb/s   198 kbit
021c     1 p/s     0 kb/s     2 kbit
021d     2 p/s     0 kb/s     4 kbit
021e     2 p/s     0 kb/s     4 kbit
0262     9 p/s     1 kb/s    14 kbit
026c  1688 p/s   309 kb/s  2539 kbit
0276   132 p/s    24 kb/s   198 kbit
0280     2 p/s     0 kb/s     4 kbit
0294    13 p/s     2 kb/s    20 kbit
02c6     9 p/s     1 kb/s    14 kbit
02d0  5437 p/s   998 kb/s  8178 kbit
02da   131 p/s    24 kb/s   197 kbit
03f2     9 p/s     1 kb/s    14 kbit
1fff   823 p/s   151 kb/s  1239 kbit
2000 16557 p/s  3039 kb/s 24901 kbit

************************************************
DESKTOP (very bad image)

system ubuntu jaunty
Linux xxx 2.6.28-11-generic #42-Ubuntu SMP Fri Apr 17 01:57:59
UTC 2009 i686 GNU/Linux
AMD
Mother board GA-MA78GM-US2H (USB controler : amd sb700)

lsusb
Bus 001 Device 006: ID 0413:6026 Leadtek Research, Inc. WinFast DTV Dongle (warm state)

lsmod |grep dvb
dvb_usb_dibusb_mc      13056  0
dvb_usb_dibusb_common    16772  1 dvb_usb_dibusb_mc
dib3000mc              20488  2 dvb_usb_dibusb_common
dvb_usb                24332  2 dvb_usb_dibusb_mc,dvb_usb_dibusb_common
dvb_core               92032  1 dvb_usb


tzap "ARTE"
tuning to 586167000 Hz
video pid 0x0208, audio pid 0x0212
status 1f | signal cbfc | snr 0000 | ber 001fffff | unc 00000013 | FE_HAS_LOCK
...

dvbtraffic
0000     9 p/s     1 kb/s    14 kbit
0012    10 p/s     1 kb/s    16 kbit
0015     1 p/s     0 kb/s     2 kbit
006e     9 p/s     1 kb/s    14 kbit
0078  1757 p/s   322 kb/s  2643 kbit
0082   127 p/s    23 kb/s   191 kbit
008c     3 p/s     0 kb/s     5 kbit
00d2     9 p/s     1 kb/s    14 kbit
00dc  1380 p/s   253 kb/s  2076 kbit
00e6   124 p/s    22 kb/s   187 kbit
00f0    42 p/s     7 kb/s    63 kbit
0136     9 p/s     1 kb/s    14 kbit
0140  2912 p/s   534 kb/s  4380 kbit
014a   124 p/s    22 kb/s   187 kbit
0154    13 p/s     2 kb/s    20 kbit
01fe     9 p/s     1 kb/s    14 kbit
0208  2641 p/s   484 kb/s  3973 kbit
0212   124 p/s    22 kb/s   187 kbit
0213   127 p/s    23 kb/s   191 kbit
021c     1 p/s     0 kb/s     2 kbit
021d     1 p/s     0 kb/s     2 kbit
021e     1 p/s     0 kb/s     2 kbit
0262     9 p/s     1 kb/s    14 kbit
026c  1509 p/s   277 kb/s  2270 kbit
0276   125 p/s    22 kb/s   188 kbit
0280     3 p/s     0 kb/s     5 kbit
0294    12 p/s     2 kb/s    19 kbit
02c6     9 p/s     1 kb/s    14 kbit
02d0  3913 p/s   718 kb/s  5886 kbit
02da   125 p/s    22 kb/s   188 kbit
03f2     9 p/s     1 kb/s    14 kbit
1fff   780 p/s   143 kb/s  1173 kbit
2000 15952 p/s  2928 kb/s 23992 kbit
-PID--FREQ-----BANDWIDTH-BANDWIDTH-





      
