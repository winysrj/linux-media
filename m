Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:58549 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbZL2Jic (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2009 04:38:32 -0500
Received: by iwn1 with SMTP id 1so7770492iwn.33
        for <linux-media@vger.kernel.org>; Tue, 29 Dec 2009 01:38:31 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 29 Dec 2009 17:38:30 +0800
Message-ID: <8cd7f1780912290138q1a58d3a5xa444a9cdcd577cfd@mail.gmail.com>
Subject: MANTIS / STB0899 / STB6100 card ( Twinhan VP-1041): problems locking
	to transponder
From: Leszek Koltunski <leszek@koltunski.pl>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello linux dvb gurus,

I've got the following setup:

1. current Mythbuntu 9.10 ( kernel 2.6.31-16-generic-pae )
2. current v4l-dvb drivers ( freshly checked out from
http://linuxtv.org/hg/v4l-dvb ;
I've also tried with Liplianin drivers from
http://mercurial.intuxication.org/hg/s2-liplianin  with the same
effect )
3. a TwinHan VP-1041 DVB-S2 card.

My signal comes from ASIASAT-5 satellite. You can see all the stuff
this satellite provides in

http://www.tvro.com.tw/SATELLITE/100.5/100.5d.asp

( the page is in Chinese, but you can see it has - among others - two
transponders which I am going to talk about , one is at

4000H  freq 1150 sr 28125  fec 3/4

and another on

3960H freq 1190 sr 27500 fec 3/4

**************************************************************************************************

Now, I want to stream a whole transponder via UDP. So I try with a first one:

$ dvbstream -c 1 -f 1150000 -s 28125 -udp -i 224.224.224.1 -r 1234 8192
dvbstream v0.6 - (C) Dave Chapman 2001-2004
Released under the GPL.
Latest version available from http://www.linuxstb.org/
Tuning to 1150000 Hz
Using DVB card "STB0899 Multistandard", freq=1150000
tuning DVB-S to Freq: 1150000, Pol: Srate=28125000, 22kHz tone=off, LNB: 0
Setting only tone ON and voltage 18V
DISEQC SETTING SUCCEDED
Getting frontend status
Event:  Frequency: 1150000
        SymbolRate: 28125000
        FEC_inner:  9

Bit error rate: 0
Signal strength: 65336
SNR: 93
FE_STATUS: FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI FE_HAS_SYNC
dvbstream will stop after -1 seconds (71582788 minutes)
Using 224.224.224.1:1234:2
version=2
Streaming 1 stream


and the transponder correctly appears in 224.224.224.1:1234, 100% success rate.

************************************************************************************************

Now I want to do the same with the other transponder, so I try:

$ dvbstream -c 1 -f 1190000 -s 27500 -udp -i 224.224.224.1 -r 1234 8192
dvbstream v0.6 - (C) Dave Chapman 2001-2004
Released under the GPL.
Latest version available from http://www.linuxstb.org/
Tuning to 1190000 Hz
Using DVB card "STB0899 Multistandard", freq=1190000
tuning DVB-S to Freq: 1190000, Pol: Srate=27500000, 22kHz tone=off, LNB: 0
Setting only tone ON and voltage 18V
DISEQC SETTING SUCCEDED
Getting frontend status
Not able to lock to the signal on the given frequency
dvbstream will stop after -1 seconds (71582788 minutes)
Using 224.224.224.1:1234:2
version=2
Streaming 1 stream

... and it always says 'Not able to lock to the signal on the given
frequency' , and even though it says 'Streaming 1 stream' , nothing
appears in the network.

************************************************************************************************

Now , some more info:

1. I've connected a satellite set-top-box to the signal and the STB
can tune to and watch channels from both transponders with no problems
at all.
That IMHO proves that the signal is all right and the problem lies in
the drivers, or maybe in dvbstream. ( or hopefully between the chair
and the keyboard )

2. I can ONLY tune to the 'freq 1150 / sr 28125' transponder. All
others fail.  But with that one I have no problems at all, I tunes
100% of the time; I got it to stream for 4 days straight with no
problems.

3. You can see that both transponders are C-BAND , H polarization, so
theoretically, AFAIK, if I can tune to the '1150' transponder, I
should be able to tune to the '1190' one with no magic at all, am I
wrong here?

Could anyone shed some light on this?

best,

Leszek
