Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <mstuff@read.org.nz>) id 1QG67F-00058i-LE
	for linux-dvb@linuxtv.org; Sat, 30 Apr 2011 11:05:32 +0200
Received: from mail-vw0-f54.google.com ([209.85.212.54])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-2) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1QG67E-0005wK-IK; Sat, 30 Apr 2011 11:05:29 +0200
Received: by vws18 with SMTP id 18so4542164vws.41
	for <linux-dvb@linuxtv.org>; Sat, 30 Apr 2011 02:05:25 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 30 Apr 2011 21:05:24 +1200
Message-ID: <BANLkTikXWx-E_rOyEb47S1TFfh3KBd0oNw@mail.gmail.com>
From: Morgan Read <mstuff@read.org.nz>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Optus D1 tuning?
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

Hello list

I've been trying to connect to the Optus D1 satellite from NZ, and I'm
tearing my hair out.

There is no config file dvb-apps/dvb-s so I've constructed the following from:
http://www.lyngsat.com/optusd1.html

# Optus D1 satellite 160E
# freq pol sr fec

### Freeview: DVB-S, Prime TV, Shine TV, C4, TV 3, Four, Stratos,
Parliament TV, Cue TV, Te Reo, TV 3 +1
S 12456000 H 22500000 3/4
### Freeview: DVB-S, Maori TV, TVNZ TV One Auckland, TVNZ TV 2, TVNZ7,
TVNZ U, TVNZ TV One Hamilton, TVNZ TV One Wellington, TVNZ TV One
Christchurch
S 12483000 H 22500000 3/4

### DVB-S2, Channel Nine, GEM, Go!
S 12398000 V 11909000 2/3
### SBS Tasmania: DVB-S, SBS One Tasmania, SBS Two Tasmania, SBS One
Tasmania HD, SBS Radio Tasmania AM, SBS Radio Tasmania FM
S 12648000 V 12600000 5/6

### Sky New Zealand: DVB-S2 Videoguard
S 12267000 H 22500000 2/3
S 12331000 H 22500000 2/3
S 12358000 H 22500000 2/3
### Sky	New Zealand: DVB-S Videoguard
S 12394000 H 22500000 3/4
S 12421000 H 22500000 3/4
### Sky New Zealand: DVB-S Videoguard, Radio New Zealand National,
Radio New Zealand Concert, Niu FM, Tahu FM
S 12519000 H 22500000 3/4
### Sky New Zealand: DVB-S Videoguard, Calvary Chapel Radio New Zealand
S 12546000 H 22500000 3/4
### Sky New Zealand: DVB-S Videoguard, The Edge FM
S 12581000 H 22500000 3/4
### Sky New Zealand: DVB-S Videoguard, Maori TV
S 12608000 H 22500000 3/4
### Sky New Zealand: DVB-S Videoguard
S 12644000 H 22500000 3/4
### Sky New Zealand: DVB-S Videoguard, TVNZ TV One, TVNZ TV 2, Trackside
S 12671000 H 22500000 3/4
### Sky New Zealand: DVB-S Videoguard
S 12707000 H 22500000 3/4
S 12734000 H 22500000 3/4

It's heavily annotated with channel info, but if it could be included
in dvb-apps/dvb-s I'm sure it could put somebody else out of the
misery I've been suffering.

If I run w_scan to search for channels it times out, but if I use
dvbtune and scandvb I get some (but not all) channels discovered.  See
below.  I feel like I'm flailing about in a dark pit, if anybody could
help me out it would be much appreciated!

Many thanks,
Morgan.

[vortexbox.lan ~]# w_scan -fs -s S160E0 -x
w_scan version 20110206 (compiled for DVB API 5.2)
using settings for 160.0 east Optus D1
frontend_type DVB-S, channellist 49
output format initial tuning data
Info: using DVB adapter auto detection.
	/dev/dvb/adapter0/frontend0 -> DVB-S "Conexant CX24123/CX24109": good :-)
Using DVB-S frontend (adapter /dev/dvb/adapter0/frontend0)
-_-_-_-_ Getting frontend capabilities-_-_-_-_
Using DVB API 5.2
frontend Conexant CX24123/CX24109 supports
INVERSION_AUTO
DVB-S
using LNB "UNIVERSAL"
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
12331: skipped (no driver support)
12358: skipped (no driver support)
(time: 00:00)
(time: 00:03)
...
(time: 01:16)
(time: 01:19)

ERROR: Sorry - i couldn't get any working frequency/transponder
 Nothing to scan!!
[vortexbox.lan ~]# dvbtune -f 1183000 -s 22500 -p h -m
Using DVB card "Conexant CX24123/CX24109"
tuning DVB-S to L-Band:0, Pol:H Srate=22500000, 22kHz=off
ERROR setting tone
: Invalid argument
polling....
Getting frontend event
Overflow error, trying again (status = -1, errno = 75)FE_STATUS:
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
SNR: 57884
FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI FE_HAS_SYNC
FE READ UNCORRECTED BLOCKS: : Operation not supported
Signal=61952, Verror=0, SNR=57609dB, BlockErrors=0, (S|L|C|V|SY|)
FE READ UNCORRECTED BLOCKS: : Operation not supported
Signal=61952, Verror=0, SNR=57473dB, BlockErrors=0, (S|L|C|V|SY|)
FE READ UNCORRECTED BLOCKS: : Operation not supported
Signal=61952, Verror=0, SNR=57835dB, BlockErrors=0, (S|L|C|V|SY|)
FE READ UNCORRECTED BLOCKS: : Operation not supported
Signal=61952, Verror=0, SNR=57681dB, BlockErrors=0, (S|L|C|V|SY|)
^C
[vortexbox.lan ~]# dvbtune -f 1183000 -s 22500 -p h -m 2>/dev/null &
[1] 17061
[vortexbox.lan ~]# scandvb -c -U
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
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
Maori TV                 (0x0401) 01: PCR == V   V 0x0202 A 0x028c
TV ONE                   (0x040b) 01: PCR == V   V 0x0203 A 0x028d
0x0297 (ita) TT 0x0243
TV2                      (0x040c) 01: PCR == V   V 0x0204 A 0x028e
  TT 0x0244
TVNZ 7                   (0x040e) 01: PCR == V   V 0x0206 A 0x0290
  TT 0x0246
U                        (0x0770) 01: PCR == V   V 0x0200 A 0x028a
  TT 0x0245
TV ONE                   (0x0774) 01: PCR == V   V 0x0207 A 0x0291
  TT 0x0243
TV ONE                   (0x0775) 01: PCR == V   V 0x0201 A 0x028b
  TT 0x0243
TV ONE                   (0x0776) 01: PCR == V   V 0x0205 A 0x028f
  TT 0x0243
TS 22 IEPG DATA SERVICE  (0x233e) 83:
[000-fffe]               (0xfffe) 00: PCR 0x1fff
Done.
[vortexbox.lan ~]# fg
dvbtune -f 1183000 -s 22500 -p h -m 2> /dev/null
^C
[vortexbox.lan ~]#

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
