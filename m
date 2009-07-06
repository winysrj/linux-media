Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:51460 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbZGGOQr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jul 2009 10:16:47 -0400
Received: by ewy26 with SMTP id 26so647298ewy.37
        for <linux-media@vger.kernel.org>; Tue, 07 Jul 2009 07:16:45 -0700 (PDT)
Subject: dvbnet on mantis vp1034 mb86a16
Mime-Version: 1.0 (Apple Message framework v1068)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
From: gmail <gahyoo@gmail.com>
Date: Mon, 6 Jul 2009 18:12:51 +0700
Content-Transfer-Encoding: 7bit
Message-Id: <999C1548-BA03-4A3F-8778-3265E8972009@gmail.com>
To: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have DVB-S card Mantis vp1034 mb86a16 and use Linux Ubuntu 8.10  
Kernel 2.6.27-7-generic

install module from http://jusst.de/hg/mantis/ not work  because i  
can't find /dev/dvb
but I install module from http://jusst.de/hg/mantis/archive/3c897a20ff8b.zip 
  is work and can find /dev/dvb

And I install dvb-apps from http://linuxtv.org/hg/dvb-apps

I use command :

= 
= 
========================================================================
# echo SOI_ASIA:4068:h:0:9253:0:0:0 > channels.conf

# szap -c channels.conf -r -l C-BAND -n 1
reading channels from file 'channels.conf'
zapping to 1 'SOI_ASIA':
sat 0, frequency = 4068 MHz H, symbolrate 9253000, vpid = 0x1fff, apid  
= 0x1fff sid = 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal ff79 | snr ff0a | ber 00000021 | unc 000000fe |
status 1f | signal ff78 | snr ff0c | ber 0000001d | unc 000000fe |  
FE_HAS_LOCK
status 1f | signal ff78 | snr ff0a | ber 00000023 | unc 000000fd |  
FE_HAS_LOCK
status 1f | signal ff78 | snr ff0a | ber 00000021 | unc 000000fd |  
FE_HAS_LOCK
status 1f | signal ff78 | snr ff0c | ber 00000022 | unc 000000fe |  
FE_HAS_LOCK
= 
= 
========================================================================
Then this frequency is Locked

I find PID
= 
= 
========================================================================
# dvbsnoop -s pidscan
dvbsnoop V1.4.50 -- http://dvbsnoop.sourceforge.net/

---------------------------------------------------------
Transponder PID-Scan...
---------------------------------------------------------
PID found: 1365 (0x0555)  [SECTION: DVB CA message section (EMM/ECM)]
PID found: 6283 (0x188b)  [unknown]
PID found: 8191 (0x1fff)  [stuffing]
= 
= 
========================================================================



I test dvbsnoop
= 
= 
========================================================================
# dvbsnoop 1365 -nph -s sec|more
dvbsnoop V1.4.50 -- http://dvbsnoop.sourceforge.net/

------------------------------------------------------------
SECT-Packet: 00000001   PID: 1365 (0x0555), Length: 408 (0x0198)
Time received: Tue 2009-07-07  21:03:40.451
------------------------------------------------------------
PID:  1365 (0x0555)

Guess table from table id...
CAMT-decoding....
Table_ID: 139 (0x8b)  [= DVB CA message section (EMM/ECM)]
section_syntax_indicator: 1 (0x01)
reserved_1: 0 (0x00)
reserved_2: 3 (0x03)
Section_length: 405 (0x0195)
CA_message_section_data:
       0000:  04 00 c1 00 00 01 00 33  33 fe ff e9 a4 e2 fe  
ff   .......33.......
       0010:  2a 1b 00 86 dd 60 00 00  00 01 54 11 7e 20 01 0d    
*....`....T.~ ..
       0020:  30 01 01 00 01 02 21 85  ff fe 1c 2f ec ff 38 00    
0.....!..../..8.
       0030:  20 20 01 0d 30 01 01 00  02 00 01 00 04 11 5c 11     .. 
0.........\.
       0040:  5c 01 54 f4 75 80 7c bd  18 27 42 08 54 3d 36 4a    
\.T.u.|..'B.T=6J
       0050:  d3 d5 55 d5 55 d5 55 d5  55 d5 55 d5 55 d5 55  
d5   ..U.U.U.U.U.U.U.
       0060:  55 d5 55 d5 55 55 55 d5  55 d5 55 d5 55 d5 55 d5    
U.U.UUU.U.U.U.U.
--More--
= 
= 
========================================================================

but when i create virtual network interface
= 
= 
========================================================================
# dvbnet -p 1365

DVB Network Interface Manager
Copyright (C) 2003, TV Files S.p.A

Status: device dvb0_0 for pid 1365 created successfully.

# ifconfig dvb0_0
dvb0_0    Link encap:Ethernet  HWaddr 00:00:00:00:00:00
           BROADCAST NOARP MULTICAST  MTU:4096  Metric:1
           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
           collisions:0 txqueuelen:1000
           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
           Base address:0x555
= 
= 
========================================================================

Not have Mac Address and MTU not eq 1500
= 
= 
========================================================================
# tcpdump -i dvb0_0
tcpdump: bind: Network is down

# ifconfig dvb0_0 hw ether 00:08:CA:1B:4B:87
# ifconfig dvb0_0 mtu 1500 up

# tcpdump -i dvb0_0
tcpdump: WARNING: dvb0_0: no IPv4 address assigned
tcpdump: verbose output suppressed, use -v or -vv for full protocol  
decode
listening on dvb0_0, link-type EN10MB (Ethernet), capture size 96 bytes
= 
= 
========================================================================


I waiting this and be incomplete
This problem I can't create virtual network interface  to work
Please help me
Thanks
