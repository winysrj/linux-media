Return-path: <linux-media-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:2445 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbZBQRZm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 12:25:42 -0500
Received: by fk-out-0910.google.com with SMTP id f33so1409140fkf.5
        for <linux-media@vger.kernel.org>; Tue, 17 Feb 2009 09:25:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <59052.79.136.92.202.1234853938.squirrel@webmail.bahnhof.se>
References: <59052.79.136.92.202.1234853938.squirrel@webmail.bahnhof.se>
Date: Tue, 17 Feb 2009 18:25:38 +0100
Message-ID: <854d46170902170925x6a1c8d3x6d953d1d9472a81b@mail.gmail.com>
Subject: Re: Tevii S650 DVB-S2 diseqc problem
From: Faruk A <fa@elwak.com>
To: svankan@bahnhof.se
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 17, 2009 at 7:58 AM,  <svankan@bahnhof.se> wrote:
>>Hi!
>>
>>I don't have any diseqc problem with this card.
>>Tested with vdr 1.7.0, scan-s2, szap-s2 (myTeVii and ProgDVB)
>>ArchLinux 32-bit, kernel26 2.6.28.4
>
> Thank you for the answer Frank!
>
> Can you please provide an example when you use scan-s2? I have a dual boot
> for Windows and as far as I remember there were some problems with diseqc
> in dvbviewer also. My dish is 25 meters away from the computer but signal
> is very good.
>
> /Svankan

Windows softwares are like that with new cards but they usually get
supported when the card becomes
popular. My dish is even farther that yours, i live in six floor
apartment building with over 100 apartments we all
share four dishes so every apartment is satellite ready.

One thing that i hate about this card is scanning for channels, i
think it doesn't support AUTO scanning
for initial transponders.
For that we have to use scan-s2 with -X option and you need
transponder files from
http://joshyfun.peque.org/transponders/kaffeine.html
before you start scanning edit you transponder files and remove
transponders that you don't need, stuff like feeds, beams that you
can't receive
because it takes allot of time. Every transponders that wont lock it
scan as dvb-s and then it will rescan as dvb-s2.

scan-s2 -a 1 -s 3 -t 1 -p -X ../ini/astra > test.conf
-a 1= adaptern 1
-s 3 = diseqc input 4 (Astra 19E)
-t 1 = Service TV only
-p   = for vdr output format: dump provider name
-X  = Disable AUTOs for initial transponders (esp. for hardware which
        not support it). Instead try each value of any free parameters.
Log:
initial transponder DVB-S2 12090000 V 27500000 3/4 20 8PSK
initial transponder DVB-S  12110000 H 27500000 3/4 35 QPSK
initial transponder DVB-S2 12110000 H 27500000 3/4 35 QPSK
initial transponder DVB-S2 12110000 H 27500000 3/4 35 8PSK
initial transponder DVB-S2 12110000 H 27500000 3/4 25 QPSK
...
----------------------------------> Using DVB-S
>>> tune to: 10744:hC56M2O35S0:S0.0W:22000:
DVB-S IF freq is 994000
>>> parse_section, section number 0 out of 0...!
0x041B 0x7031: pmt_pid 0x0000 ARD -- EinsExtra (running)
0x041B 0x7032: pmt_pid 0x0000 ARD -- EinsFestival (running)
0x041B 0x7033: pmt_pid 0x0000 ARD -- EinsPlus (running)
0x041B 0x7034: pmt_pid 0x0000 ARD -- arte (running)
0x041B 0x7035: pmt_pid 0x0000 ARD -- Phoenix (running)
0x041B 0x7036: pmt_pid 0x0000 ARD -- Test-R (running)
>>> parse_section, section number 0 out of 0...!
service_id = 0x0
service_id = 0x7031
pmt_pid = 0x64
service_id = 0x7032
pmt_pid = 0xC8
service_id = 0x7033
pmt_pid = 0x12C
service_id = 0x7034
pmt_pid = 0x190
service_id = 0x7035
pmt_pid = 0x1F4
service_id = 0x7036
pmt_pid = 0x258
>>> parse_section, section number 0 out of 0...!
  VIDEO     : PID 0x012D
  AUDIO     : PID 0x012E
  TELETEXT  : PID 0x0130
  OTHER     : PID 0x0172 TYPE 0x05
  OTHER     : PID 0x0173 TYPE 0x0B
  OTHER     : PID 0x0818 TYPE 0x0B
>>> parse_section, section number 0 out of 0...!
  VIDEO     : PID 0x00C9
  AUDIO     : PID 0x00CA
  TELETEXT  : PID 0x00CC
  OTHER     : PID 0x010E TYPE 0x05
  OTHER     : PID 0x0818 TYPE 0x0B
>>> parse_section, section number 0 out of 0...!
  VIDEO     : PID 0x0065
  AUDIO     : PID 0x0066
  OTHER     : PID 0x00AA TYPE 0x05
  OTHER     : PID 0x00AB TYPE 0x0B
  OTHER     : PID 0x00AC TYPE 0x05
  OTHER     : PID 0x00AD TYPE 0x0B
  OTHER     : PID 0x00B0 TYPE 0x0C
  OTHER     : PID 0x0818 TYPE 0x0B
>>> parse_section, section number 0 out of 0...!
  VIDEO     : PID 0x01F5
  AUDIO     : PID 0x01F6
  TELETEXT  : PID 0x01F8
  OTHER     : PID 0x0816 TYPE 0x05
  OTHER     : PID 0x0818 TYPE 0x0B
>>> parse_section, section number 0 out of 0...!
  VIDEO     : PID 0x0191
  AUDIO     : PID 0x0192
  AUDIO     : PID 0x0193
  TELETEXT  : PID 0x0194
  OTHER     : PID 0x0816 TYPE 0x05
  OTHER     : PID 0x0818 TYPE 0x0B
>>> parse_section, section number 0 out of 0...!
  VIDEO     : PID 0x0191
  AUDIO     : PID 0x0192
^CERROR: interrupted by SIGINT, dumping partial result...
dumping lists (6 services)
Done.
..........................................
cat test.conf

ARD - EinsExtra;ARD:10744:hC56M2O35S0:S0.0W:22000:101:102=ger:0:0:28721:1:1051:0
ARD - EinsFestival;ARD:10744:hC56M2O35S0:S0.0W:22000:201:202=ger:204:0:28722:1:1051:0
ARD - EinsPlus;ARD:10744:hC56M2O35S0:S0.0W:22000:301:302=ger:304:0:28723:1:1051:0
ARD - arte;ARD:10744:hC56M2O35S0:S0.0W:22000:401:402=ger,403=fra:404:0:28724:1:1051:0
ARD - Phoenix;ARD:10744:hC56M2O35S0:S0.0W:22000:501:502=ger:504:0:28725:1:1051:0
ARD - Test-R;ARD:10744:hC56M2O35S0:S0.0W:22000:401:402=ger:0:0:28726:1:1051:0
