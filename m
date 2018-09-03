Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:46683 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725947AbeIDBdR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Sep 2018 21:33:17 -0400
From: rens <rensg@xs4all.nl>
Subject: dvbv5-scan --- report bugs to Mauro Carvalho Chehab
 <m.chehab@samsung.com>
To: linux-media@vger.kernel.org
Message-ID: <4df2dd7f-b61f-870a-aff2-531dcf6e8b81@xs4all.nl>
Date: Mon, 3 Sep 2018 23:11:15 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi.

I think I ran into a bug, but.......

I have a 3 way lnb setup, with a TBS HD capable satellite tuner.

I am in Netherlands, Europe, and therefore I can receive Astra2 channels
( mainly UK based channels)

with the old dvbscan, I can tune and record from stations on frequency
10714 :

FIlm4 and More4 +1 , they are both free to air.

With the dvbv5-scan, (and consequently also kaffeine ) I am not able to
scan,  tune to or record from these channels.

My scan file looks like this:

_____________________________

=>cat x6
S 10714000 H 22000000 5/6

__________________________________________________

#dvbv5-scan -V
dvbv5-scan version 1.8.0

=>dvbv5-scan -S 2  -w -1 -I CHANNEL -l UNIVERSAL  x6
Using LNBf UNIVERSAL
        Europe
        10800 to 11800 MHz and 11600 to 12700 MHz
        Dual LO, IF = lowband 9750 MHz, highband 10600 MHz
ERROR    command BANDWIDTH_HZ (5) not found during retrieve
Cannot calc frequency shift. Either bandwidth/symbol-rate is unavailable
(yet).
Scanning frequency #1 10714000
RF     (0x01) Signal= -37.00dBm
4.4.114-42-vanilla:vmhost1:/root
_____________________________________________________


with the same x6 file and using dvbscan :

I do get the stations on that frequency. Any suggestion if I am doing
something wrong / what is going on here ??


# rpm -qf `which dvbscan `
dvb-1.1.1_20150120-3.2.x86_64

_____________________________________________________

# dvbscan  -s 2   -l UNIVERSAL   x6
scanning x6
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 10714000 H 22000000 5
>>> tune to: 10714:h:2:22000
DVB-S IF freq is 964000
0x0000 0x23fb: pmt_pid 0x0100 BSkyB -- Channel 4 (running)
0x0000 0x23fc: pmt_pid 0x0101 BSkyB -- Channel 4 (running)
0x0000 0x23fd: pmt_pid 0x0102 BSkyB -- Channel 4 (running)
0x0000 0x23fe: pmt_pid 0x0103 BSkyB -- Channel 4 (running)
0x0000 0x2400: pmt_pid 0x0105 BSkyB -- Channel 4 (running)
0x0000 0x2404: pmt_pid 0x010a BSkyB -- Film4 (running)
0x0000 0x240e: pmt_pid 0x0108 BSkyB -- More4+1 (running)
0x0000 0x240f: pmt_pid 0x010b BSkyB -- More4 (running, scrambled)
0x0000 0x2419: pmt_pid 0x0107 BSkyB -- E4 (running)
0x0000 0x241d: pmt_pid 0x010d BSkyB -- Channel 4+1 (running, scrambled)
0x0000 0x2422: pmt_pid 0x0109 BSkyB -- E4+1 (running, scrambled)
0x0000 0x2441: pmt_pid 0x0106 BSkyB -- c4 l (running)
Network Name 'ASTRA'

__________________________________________________

-- 

Met vriendelijke groet / Best regards,
Rens
