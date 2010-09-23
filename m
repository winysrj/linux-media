Return-path: <mchehab@pedra>
Received: from atp1.ttn.ru ([93.178.99.230]:42066 "EHLO mail.globall.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab0IWJET (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Sep 2010 05:04:19 -0400
Received: from mail.globall.ru (localhost [127.0.0.1])
	by mail.globall.ru (Postfix) with ESMTP id 36D1DC3D3E
	for <linux-media@vger.kernel.org>; Thu, 23 Sep 2010 12:53:59 +0400 (MSD)
Received: from [192.168.0.208] (bob.globall.ru [192.168.0.208])
	by mail.globall.ru (Postfix) with ESMTP id EF4AAC3D3E
	for <linux-media@vger.kernel.org>; Thu, 23 Sep 2010 12:53:58 +0400 (MSD)
Message-ID: <4C9B15A6.9060001@globall.ru>
Date: Thu, 23 Sep 2010 12:53:58 +0400
From: Vladimir Monchenko <bob@globall.ru>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] dm1105 scan but won't tune? (anyone have one of these
 working?)
References: <25861669.1285195582100.JavaMail.ngmail@webmail18.arcor-online.net> <1537BE75D4274CAF8A375A44B7F1B2E2@telstraclear.tclad>
In-Reply-To: <1537BE75D4274CAF8A375A44B7F1B2E2@telstraclear.tclad>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Simon Baxter пишет:
> Hi. I've got a new dm1105 dvb-s card which I can't get to work. I can
> scan and get transponders etc, but can't tune or get a front end lock.
>
> I see there's been some work on this - does anyone have one of these
> dvb-s cards working?
>
> I've just pulled the latest from
> http://mercurial.intuxication.org/hg/s2-liplianin
>
> I can scan and get info:
> ./scan dvb-s/OptusB1-NZ -l 11300 -x 0
> scanning dvb-s/OptusB1-NZ
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> initial transponder 12456000 H 22500000 9
>>>> tune to: 12456:h:0:22500
> DVB-S IF freq is 1156000
> <snip>
> 0x0000 0x0781: pmt_pid 0x010b TV Works -- C4 (running)
> <snip>
> C4:12456:h:0:22500:513:651:1921
>
> But I can't get a lock on szap:
> ./szap -c channels-conf/dvb-s/OptusD1E160 C4
> reading channels from file 'channels-conf/dvb-s/OptusD1E160'
> zapping to 2 'C4':
> sat 0, frequency = 12456 MHz H, symbolrate 22500000, vpid = 0x0201,
> apid = 0x028b sid = 0x0781
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> status 03 | signal 9ae2 | snr 7170 | ber 0000ff07 | unc fffffffe |
> status 03 | signal 9c2a | snr 719a | ber 0000ff05 | unc fffffffe |
> status 03 | signal 9b07 | snr 71d9 | ber 0000ff05 | unc fffffffe |
> status 03 | signal 9ace | snr 7200 | ber 0000ff05 | unc fffffffe |
>
> Or in VDR -
> Sep 23 13:49:45 localhost vdr: [2105] frontend 0/0 timed out while
> tuning to channel 1, tp 112456
> Sep 23 13:50:06 localhost vdr: [2105] frontend 0/0 timed out while
> tuning to channel 16, tp 112483
> Sep 23 13:50:26 localhost vdr: [2105] frontend 0/0 timed out while
> tuning to channel 1, tp 112456
>
>
> Although dvbtune says:
> ./dvbtune -f 1245600 -s 22500 -p h -m -tone 0 -x
> Using DVB card "ST STV0299 DVB-S"
> tuning DVB-S to L-Band:3, Pol:H Srate=22500000, 22kHz=off
> polling....
> Getting frontend event
> FE_STATUS:
> polling....
> Getting frontend event
> FE_STATUS: FE_HAS_SIGNAL FE_HAS_CARRIER
> polling....
> Getting frontend event
> FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI
> FE_HAS_SYNC
> Event: Frequency: 10995803
> SymbolRate: 22500000
> FEC_inner: 3
>
> Bit error rate: 65285
> Signal strength: 53063
> SNR: 48522
> FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI
> FE_HAS_SYNC
> <?xml version="1.0" encoding="iso-8859-1"?>
> <satellite>
> <descriptor tag="0x01"
> data="4b59204469676974616c20536174656c6c697465205456f3ae000100a9f042413303eb0103ed0103f10103f401040201041101043801043d01044501044c02046002046102046202232983238d8a23f18426ad"
> text="KY.Digital.Satellite.TV.......BA3...................8.....E..L.....a..b............"
> />
> Nothing to read from fd_nit
> Scanning 12407000V 30000000
> Using DVB card "ST STV0299 DVB-S"
> tuning DVB-S to L-Band:774218352, Pol:V Srate=30000000, 22kHz=off
> polling....
> Getting frontend event
> FE_STATUS:
> polling....
> Getting frontend event
> FE_STATUS: FE_HAS_SIGNAL FE_HAS_CARRIER
> polling....
> polling....
>
>
> Any suggestions?
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

Hi,

Please, try set parameter card=<number> at dm1105 module loading.

Best reagrds,
Vladimir Monchenko.
