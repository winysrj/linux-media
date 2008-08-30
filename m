Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay.chp.ru ([213.170.120.254] helo=ns.chp.ru)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1KZUFs-00009D-G0
	for linux-dvb@linuxtv.org; Sat, 30 Aug 2008 19:28:58 +0200
Received: from cherep2.ptl.ru (localhost.ptl.ru [127.0.0.1])
	by cherep.quantum.ru (Postfix) with SMTP id 80BD919E6392
	for <linux-dvb@linuxtv.org>; Sat, 30 Aug 2008 21:28:22 +0400 (MSD)
Received: from localhost.localdomain (hpool.chp.ptl.ru [213.170.123.250])
	by ns.chp.ru (Postfix) with ESMTP id 16E7919E631A
	for <linux-dvb@linuxtv.org>; Sat, 30 Aug 2008 21:28:21 +0400 (MSD)
Date: Sat, 30 Aug 2008 21:38:31 +0400
From: Goga777 <goga777@bk.ru>
To: linux-dvb@linuxtv.org
Message-ID: <20080830213831.7b8e2c42@bk.ru>
Mime-Version: 1.0
Subject: [linux-dvb] cat: /dev/dvb/adapter0/dvr0: Value too large for
	defined data type
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

Hi

I run the 

# ./szap2 -n1 -c19 -S0 -M2 -C34 -p
reading channels from file '19'
zapping to 1 'EinsFestival HD;ARD':
sat 0, frequency = 12422 MHz H, symbolrate 27500000, vpid = 0x0641, apid = 0x0642 sid = 0x6eec
Delivery system=DVB-S
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'

do_tune: API version=3, delivery system = 0
do_tune: Frequency = 1822000, Srate = 27500000
do_tune: Frequency = 1822000, Srate = 27500000


status 1f | signal f240 | snr 7ccd | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal f240 | snr 799a | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal f280 | snr 7800 | ber 00000000 | unc 00000000 | FE_HAS_LOCK


and try to see the pictures with ffplay

env LANG=C cat /dev/dvb/adapter0/dvr0 | ffplay - 

goga@goga:/usr/src/vdr-1.7.0$ env LANG=C cat /dev/dvb/adapter0/dvr0 | ffplay -
FFplay version SVN-r15050, Copyright (c) 2003-2008 Fabrice Bellard, et al.
  configuration: --arch=i686 --cpu=pentium4 --enable-pthreads --enable-shared --enable-gpl --enable-postproc --disable-stripping --enable-liba52 --enable-libvorbis
  libavutil     49.10. 0 / 49.10. 0
  libavcodec    51.70. 0 / 51.70. 0
  libavformat   52.21. 0 / 52.21. 0
  libavdevice   52. 1. 0 / 52. 1. 0
  built on Aug 30 2008 18:28:25, gcc: 4.3.1
[h264 @ 0x80aa760]B picture before any references, skipping
[h264 @ 0x80aa760]decode_slice_header error
[h264 @ 0x80aa760]no frame!
[h264 @ 0x80aa760]B picture before any references, skipping
[h264 @ 0x80aa760]decode_slice_header error
[h264 @ 0x80aa760]no frame!
[h264 @ 0x80aa760]non-existing PPS referenced
[h264 @ 0x80aa760]decode_slice_header error
[h264 @ 0x80aa760]no frame!
[h264 @ 0x80aa760]B picture before any references, skipping
[h264 @ 0x80aa760]decode_slice_header error
[h264 @ 0x80aa760]no frame!
[h264 @ 0x80aa760]B picture before any references, skipping
[h264 @ 0x80aa760]decode_slice_header error
[h264 @ 0x80aa760]no frame!
[h264 @ 0x80aa760]non-existing PPS referenced
[h264 @ 0x80aa760]decode_slice_header error
[h264 @ 0x80aa760]no frame!
[h264 @ 0x80aa760]B picture before any references, skipping
[h264 @ 0x80aa760]decode_slice_header error
[h264 @ 0x80aa760]no frame!
[h264 @ 0x80aa760]B picture before any references, skipping
[h264 @ 0x80aa760]decode_slice_header error
[h264 @ 0x80aa760]no frame!
[h264 @ 0x80aa760]non-existing PPS referenced
[h264 @ 0x80aa760]decode_slice_header error
[h264 @ 0x80aa760]no frame!
[h264 @ 0x80aa760]B picture before any references, skipping
[h264 @ 0x80aa760]decode_slice_header error
[h264 @ 0x80aa760]no frame!
[h264 @ 0x80aa760]B picture before any references, skipping
[h264 @ 0x80aa760]decode_slice_header error
[h264 @ 0x80aa760]no frame!
[h264 @ 0x80aa760]number of reference frames exceeds max (probably corrupt input), discarding one
[h264 @ 0x80aa760]number of reference frames exceeds max (probably corrupt input), discarding one
[h264 @ 0x80aa760]number of reference frames exceeds max (probably corrupt input), discarding one
[h264 @ 0x80aa760]number of reference frames exceeds max (probably corrupt input), discarding one
[h264 @ 0x80aa760]B picture before any references, skipping
[h264 @ 0x80aa760]decode_slice_header error
[h264 @ 0x80aa760]no frame!
[h264 @ 0x80aa760]B picture before any references, skipping
[h264 @ 0x80aa760]decode_slice_header error
[h264 @ 0x80aa760]no frame!
[h264 @ 0x80aa760]warning: first frame is no keyframe
[h264 @ 0x80aa760]number of reference frames exceeds max (probably corrupt input), discarding one
cat: /dev/dvb/adapter0/dvr0: Value too large for defined data type
[h264 @ 0x80aa760]error while decoding MB 14 23, bytestream (-4)
[h264 @ 0x80aa760]concealing 1795 DC, 1795 AC, 1795 MV errors

after that the pictures is freezing 

"cat: /dev/dvb/adapter0/dvr0: Value too large for defined data type"

is it possible to fix it ?


Goga






_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
