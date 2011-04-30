Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60679 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab1D3Jhw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Apr 2011 05:37:52 -0400
Received: by vws1 with SMTP id 1so3279610vws.19
        for <linux-media@vger.kernel.org>; Sat, 30 Apr 2011 02:37:51 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 30 Apr 2011 21:37:51 +1200
Message-ID: <BANLkTimi5Tz2ER=6y93SH3JFXqb-w=7A0g@mail.gmail.com>
Subject: OK szap is looking better, and I feel so close...
From: Morgan Read <mstuff@read.org.nz>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

OK, think I might be getting somewhere...

I've been able to have szap put out something sensible looking:

[user@vortexbox ~]$ dvbtune -f 1183000 -s 22500 -p h -m
Using DVB card "Conexant CX24123/CX24109"
tuning DVB-S to L-Band:0, Pol:H Srate=22500000, 22kHz=off
ERROR setting tone
: Invalid argument
polling....
Getting frontend event
FE_STATUS:
polling....
Getting frontend event
FE_STATUS: FE_HAS_SIGNAL
polling....
Getting frontend event
FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI FE_HAS_SYNC
Bit error rate: 0
Signal strength: 61952
SNR: 58030
FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI FE_HAS_SYNC
FE READ UNCORRECTED BLOCKS: : Operation not supported
Signal=61952, Verror=0, SNR=57861dB, BlockErrors=0, (S|L|C|V|SY|)
FE READ UNCORRECTED BLOCKS: : Operation not supported
Signal=61952, Verror=0, SNR=57426dB, BlockErrors=0, (S|L|C|V|SY|)
FE READ UNCORRECTED BLOCKS: : Operation not supported
Signal=61952, Verror=0, SNR=57853dB, BlockErrors=0, (S|L|C|V|SY|)
^C
[user@vortexbox ~]$ dvbtune -f 1183000 -s 22500 -p h -m 2>/dev/null &
[1] 27306
[user@vortexbox ~]$ scandvb -cva 0 -U -o zap
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
PAT
PMT 0x1100 for service 0xfffe
PMT 0x0056 for service 0x233e
PMT 0x010f for service 0x0776
PMT 0x0111 for service 0x0775
PMT 0x010c for service 0x0774
PMT 0x010b for service 0x0770
PMT 0x0110 for service 0x040e
PMT 0x010e for service 0x040c
PMT 0x010d for service 0x040b
PMT 0x010a for service 0x0401
SDT (actual TS)
0x0000 0x0775: pmt_pid 0x0111 Television New Zealand -- TV ONE (running)
0x0000 0x0401: pmt_pid 0x010a Maori Television Service -- Maori TV (running)
0x0000 0x040b: pmt_pid 0x010d Television New Zealand -- TV ONE (running)
0x0000 0x040c: pmt_pid 0x010e Television New Zealand -- TV2 (running)
0x0000 0x0776: pmt_pid 0x010f Television New Zealand -- TV ONE (running)
0x0000 0x040e: pmt_pid 0x0110 Television New Zealand -- TVNZ 7 (running)
0x0000 0x0774: pmt_pid 0x010c Television New Zealand Ltd. -- TV ONE (running)
0x0000 0x0770: pmt_pid 0x010b Television New Zealand -- U (running)
0x0000 0x233e: pmt_pid 0x0056 SKY -- TS 22 IEPG DATA SERVICE (running)
NIT (actual TS)
Network Name 'Freeview'
dumping lists (10 services)
Maori TV:12483:h:0:22500:514:652:1025
TV ONE:12483:h:0:22500:515:653:1035
TV2:12483:h:0:22500:516:654:1036
TVNZ 7:12483:h:0:22500:518:656:1038
U:12483:h:0:22500:512:650:1904
TV ONE:12483:h:0:22500:519:657:1908
TV ONE:12483:h:0:22500:513:651:1909
TV ONE:12483:h:0:22500:517:655:1910
TS 22 IEPG DATA SERVICE:12483:h:0:22500:0:0:9022
[000-fffe]:12483:h:0:22500:0:0:65534
Done.
[user@vortexbox ~]$ scandvb -cva 0 -U -o zap > channels.conf
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
PAT
PMT 0x1100 for service 0xfffe
PMT 0x0056 for service 0x233e
PMT 0x010f for service 0x0776
PMT 0x0111 for service 0x0775
PMT 0x010c for service 0x0774
PMT 0x010b for service 0x0770
PMT 0x0110 for service 0x040e
PMT 0x010e for service 0x040c
PMT 0x010d for service 0x040b
PMT 0x010a for service 0x0401
NIT (actual TS)
Network Name 'Freeview'
SDT (actual TS)
0x0000 0x0775: pmt_pid 0x0111 Television New Zealand -- TV ONE (running)
0x0000 0x0401: pmt_pid 0x010a Maori Television Service -- Maori TV (running)
0x0000 0x040b: pmt_pid 0x010d Television New Zealand -- TV ONE (running)
0x0000 0x040c: pmt_pid 0x010e Television New Zealand -- TV2 (running)
0x0000 0x0776: pmt_pid 0x010f Television New Zealand -- TV ONE (running)
0x0000 0x040e: pmt_pid 0x0110 Television New Zealand -- TVNZ 7 (running)
0x0000 0x0774: pmt_pid 0x010c Television New Zealand Ltd. -- TV ONE (running)
0x0000 0x0770: pmt_pid 0x010b Television New Zealand -- U (running)
0x0000 0x233e: pmt_pid 0x0056 SKY -- TS 22 IEPG DATA SERVICE (running)
dumping lists (10 services)
Done.
[user@vortexbox ~]$ cp channels.conf ~/.szap/channels.conf
[user@vortexbox ~]$ szap -r TV2
reading channels from file '/home/user/.szap/channels.conf'
zapping to 3 'TV2':
sat 0, frequency = 12483 MHz H, symbolrate 22500000, vpid = 0x0204,
apid = 0x028e
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
opening frontend failed: Device or resource busy
[user@vortexbox ~]$ fg
dvbtune -f 1183000 -s 22500 -p h -m 2> /dev/null
^C
[user@vortexbox ~]$ szap -r TV2
reading channels from file '/home/user/.szap/channels.conf'
zapping to 3 'TV2':
sat 0, frequency = 12483 MHz H, symbolrate 22500000, vpid = 0x0204,
apid = 0x028e
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 01 | signal fa00 | snr f772 | ber 00000000 | unc fffffffe |
status 01 | signal 0f00 | snr a344 | ber 00000000 | unc fffffffe |
status 01 | signal 0f00 | snr a423 | ber 00000000 | unc fffffffe |
... ... ...
^C
[user@vortexbox ~]$

And, while szap -r TV2 is running, on another console I should be able
to run mplayer?  So:
[user@vortexbox ~]$ mplayer -vo x11 /dev/dvb/adapter0/dvr0
MPlayer SVN-r33254-snapshot-4.5.1 (C) 2000-2011 MPlayer Team
162 audio & 360 video codecs
Can't open joystick device /dev/input/js0: No such file or directory
Can't init input joystick
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote control.

Playing /dev/dvb/adapter0/dvr0.


MPlayer interrupted by signal 2 in module: demux_open


MPlayer interrupted by signal 2 in module: demux_open
[user@vortexbox ~]$

But, nothing happens at Playing /dev/dvb/adapter0/dvr0. ...  Where
should I see what's playing?

Thanks for listening,
M
