Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:37243 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058AbZLNMHT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2009 07:07:19 -0500
Received: by bwz27 with SMTP id 27so1918128bwz.21
        for <linux-media@vger.kernel.org>; Mon, 14 Dec 2009 04:07:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <211341.40316.qm@web23206.mail.ird.yahoo.com>
References: <211341.40316.qm@web23206.mail.ird.yahoo.com>
Date: Mon, 14 Dec 2009 13:07:17 +0100
Message-ID: <b42fca4d0912140407t3376959fhcc731b762979f37f@mail.gmail.com>
Subject: Re: no locking on dvb-s2 22000 2/3 8PSK transponder on Astra 19.2E
	with tt s2-3200
From: Oleg Roitburd <oroitburd@gmail.com>
To: Newsy Paper <newspaperman_germany@yahoo.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/12/9 Newsy Paper <newspaperman_germany@yahoo.com>:
> Hi,
>
> no matter if I use Igors or Manus driver, there's no lock on 11303 h 22000 2/3 8psk. Other users at vdr-portal report same problem.
>
> The strange thing is that all other transponders that use 22000 2/3 8psk do work but this transponder doesn't. It worked fine until december 3rd when uplink moved to Vienna. I think they changed a parameter like rolloff or inversion and the dvb-s2 part of stb6100 is buggy.

It works again. Very strange.

$ sudo ./scan-s2 -x -2 -O S19.2E ORF.ini
API major 5, minor 0
scanning ORF.ini
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder DVB-S2 11303000 H 22000000 2/3 35 8PSK
----------------------------------> Using DVB-S2
>>> tune to: 11303:hC23M5O35S1:S19.2E:22000:
DVB-S IF freq is 1553000
>>> parse_section, section number 0 out of 0...!
service_id = 0x0
service_id = 0x132F
pmt_pid = 0x6B
service_id = 0x1330
pmt_pid = 0x6C
service_id = 0x1331
pmt_pid = 0x6D
>>> parse_section, section number 0 out of 0...!
  VIDEO     : PID 0x0DFF
  AUDIO     : PID 0x0E00
  AUDIO     : PID 0x0E01
  AC3       : PID 0x0E03
  TELETEXT  : PID 0x0E04
>>> parse_section, section number 0 out of 0...!
  CA ID     : PID 0x0D05
  CA ID     : PID 0x1702
  CA ID     : PID 0x1833
  CA ID     : PID 0x0648
  CA ID     : PID 0x0D95
  CA ID     : PID 0x09C4
  VIDEO     : PID 0x0B68
  AUDIO     : PID 0x0B69
  AC3       : PID 0x0B6B
  AUDIO     : PID 0x0B6A
  TELETEXT  : PID 0x0B6D
>>> parse_section, section number 0 out of 0...!
  CA ID     : PID 0x0D05
  CA ID     : PID 0x1702
  CA ID     : PID 0x1833
  CA ID     : PID 0x0648
  CA ID     : PID 0x0D95
  CA ID     : PID 0x09C4
  VIDEO     : PID 0x0780
  AUDIO     : PID 0x0781
  AC3       : PID 0x0783
  AUDIO     : PID 0x0782
  TELETEXT  : PID 0x0785
>>> parse_section, section number 0 out of 0...!
0x03EF 0x132F: pmt_pid 0x006B ORF -- ORF1 HD (running, scrambled)
0x03EF 0x1330: pmt_pid 0x006C ORF -- ORF2 HD (running, scrambled)
0x03EF 0x1331: pmt_pid 0x006D ServusTV -- Servus TV HD (running)
>>> parse_section, section number 0 out of 0...!
dumping lists (3 services)
ORF1 HD;ORF:11303:hC23M5O35S1:S19.2E:22000:1920:1921=ger,1922=ENG;1923=ger:1925:D05,1702,1833,648,D95,9C4:4911:1:1007:0
ORF2 HD;ORF:11303:hC23M5O35S1:S19.2E:22000:2920:2921=ger,2922=ENG;2923=ger:2925:D05,1702,1833,648,D95,9C4:4912:1:1007:0
Servus TV HD;ServusTV:11303:hC23M5O35S1:S19.2E:22000:3583:3584=ger,3585=eng;3587=ger:3588:0:4913:1:1007:0

Regards

Oleg Roitburd
