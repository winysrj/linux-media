Return-path: <linux-media-owner@vger.kernel.org>
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:47951 "EHLO
	QMTA02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750703AbZHQHHZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Aug 2009 03:07:25 -0400
Received: from www-data by cyberseth.cyberseth.com with local (Exim 4.69)
	(envelope-from <seth@cyberseth.com>)
	id 1McwJQ-0003Zf-9l
	for linux-media@vger.kernel.org; Mon, 17 Aug 2009 00:07:24 -0700
Message-ID: <35375.76.104.173.166.1250492844.squirrel@www.cyberseth.com>
Date: Mon, 17 Aug 2009 00:07:24 -0700 (PDT)
Subject: Hauppauge 2250 - second tuner is only half working
From: seth@cyberseth.com
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

     I've run into a problem with my capture card and wanted to solicit
ideas on how to further pinpoint the problem and/or hopefully correct
it.  At the risk of being to presumptious/terse - my problem is the
second tuner on the card is unable to lock on any frequency between
609mhz and 693mhz (while the first tuner does just fine).

     I recently purchased a bunch of hardware and assembled a HTPC.  I'm
running a fairly vanilla mythbuntu on it.  I have only the one
capture card installed, and i'm using comcast cable for input.  Other
than a handful of various apt packages i've added, i've compiled from
source saa7164-dev branch (was on the -stable at one point),
lcdproc-0.5.2 w/ imonlcd-0.3.patch, lirc (trunk), scte65scan, and a
couple other tools.  Unfortunately for me, I ran across the problem
right after I did a big db merge on my mythtv's channel &
dtv_multiplex tables (I was joining schedules direct, scte65scan
results, and dvb-app scan results).  Naturally, i started
troubleshooting from that point under the assumption i screwed up the
tables.  I eventually worked my way down to where i'm stuck at now -
the second tuner mysteriously is unable to lock into some
frequencies.

     I ran full scans (us-Cable-Standard-center-frequencies-QAM256) on
both adapters - then sort -t : -k 2n -k 6n the output on both and
diffed and ended up with the 609 and 693mhz numbers from above - all
frequencies in that range are not tuneable for adapter1.  It
represents 109 tunable channels on adapter0 that just don't seem to
work on adapter1 (there are about 250 that do work on both adapters
properly).  I spot checked at least a dozen channels in both the
problem frequency range and in the good range (i used mythtv live tv
and azap w/ dvbtraffic).  dvbtraffic showed hundreds of lines of
small bandwidth channels on the problem frequency range on adapter1

(For brevity sake, i simplified my scan list down to two channels to make
it easier to test)

channels.conf contains:
KOMO:555000000:QAM_256:1984:1985:3
SYFY:669000000:QAM_256:2112:2113:7

seth@dh101:~/development/dvb-apps/dvb-apps_hg_co/util/szap$ ./azap -a 1 -c
channels.conf komo
using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
tuning to 555000000 Hz
video pid 0x07c0, audio pid 0x07c1
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 1f | signal 0186 | snr 0186 | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
status 1f | signal 0186 | snr 0186 | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
^C
seth@dh101:~/development/dvb-apps/dvb-apps_hg_co/util/szap$ ./azap -a 0 -c
channels.conf komo
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 555000000 Hz
video pid 0x07c0, audio pid 0x07c1
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 1f | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
status 1f | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
^C
seth@dh101:~/development/dvb-apps/dvb-apps_hg_co/util/szap$ ./azap -a 1 -c
channels.conf syfy
using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
tuning to 669000000 Hz
video pid 0x0840, audio pid 0x0841
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 | 	<<<<
I've let it sit for 5+ min without lock
^C
seth@dh101:~/development/dvb-apps/dvb-apps_hg_co/util/szap$ ./azap -a 0 -c
channels.conf syfy
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 669000000 Hz
video pid 0x0840, audio pid 0x0841
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 1f | signal 0190 | snr 0190 | ber 00000147 | unc 00000147 |
FE_HAS_LOCK
status 1f | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 |
FE_HAS_LOCK

dmesg output:
[74217.307056] saa7164 driver loaded
[74217.307106] saa7164 0000:03:00.0: PCI INT A -> Link[AE3A] -> GSI 16
(level, low) -> IRQ 16
[74217.307944] CORE saa7164[0]: subsystem: 0070:8891, board: Hauppauge
WinTV-HVR2250 [card=7,autodetected]
[74217.307950] saa7164[0]/0: found at 0000:03:00.0, rev: 129, irq: 16,
latency: 0, mmio: 0xe5000000
[74217.307957] saa7164 0000:03:00.0: setting latency timer to 64
[74217.308710] saa7164[0]: i2c bus 0 registered
[74217.308886] saa7164[0]: i2c bus 1 registered
[74217.309069] saa7164[0]: i2c bus 2 registered
[74217.343459] tveeprom 0-0000: Hauppauge model 88061, rev C3F2, serial#
6254250
[74217.343462] tveeprom 0-0000: MAC address is 00-0D-FE-5F-6E-AA
[74217.343464] tveeprom 0-0000: tuner model is NXP 18271C2_716x (idx 152,
type 4)
[74217.343466] tveeprom 0-0000: TV standards NTSC(M) ATSC/DVB Digital
(eeprom 0x88)
[74217.343468] tveeprom 0-0000: audio processor is SAA7164 (idx 43)
[74217.343470] tveeprom 0-0000: decoder processor is SAA7164 (idx 40)
[74217.343473] tveeprom 0-0000: has radio, has IR receiver, has no IR
transmitter
[74217.343475] saa7164[0]: Hauppauge eeprom: model=88061
[74217.645028] tda18271 1-0060: creating new instance
[74217.649054] TDA18271HD/C2 detected @ 1-0060
[74217.900894] DVB: registering new adapter (saa7164)
[74217.900898] DVB: registering adapter 0 frontend 0 (Samsung S5H1411
QAM/8VSB Frontend)...
[74218.197734] tda18271 2-0060: creating new instance
[74218.201853] TDA18271HD/C2 detected @ 2-0060
[74218.456641] DVB: registering new adapter (saa7164)
[74218.456645] DVB: registering adapter 1 frontend 0 (Samsung S5H1411
QAM/8VSB Frontend)...


I'd really appreciate any help or guidance on this problem as i'm fully
perplexed by it.

-Seth
