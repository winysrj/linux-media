Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:64838 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758109AbZKKSMX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 13:12:23 -0500
Received: by gxk26 with SMTP id 26so1272320gxk.1
        for <linux-media@vger.kernel.org>; Wed, 11 Nov 2009 10:12:28 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 11 Nov 2009 19:12:26 +0100
Message-ID: <f19975e80911111012v444f85b7t108b70539a428792@mail.gmail.com>
Subject: problems receiving channels with technotrend S-3200
From: Stefan <chouffe1@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Howdy,

I'v problems with receiving dvb-s channels especially all the bbc
channels on freesat (Astra 28.2) .
The card is working fine for all the dutch channels (canaal digitaal)
and in windows i have no problem receiving bbc hd

But as soon as i tune in to for example bbchd or bbc1 i do get a lock
but no data.

# dvbstream -f 10847000 -p v -s 22000 -v 5500 -a 5501 -o > bbchd.mpg
dvbstream v0.6 - (C) Dave Chapman 2001-2004
Released under the GPL.
Latest version available from http://www.linuxstb.org/
Tuning to 10847000 Hz
Using DVB card "STB0899 Multistandard", freq=10847000
tuning DVB-S to Freq: 1097000, Pol:V Srate=22000000, 22kHz tone=off, LNB: 0
Setting only tone OFF and voltage 13V
DISEQC SETTING SUCCEDED
Getting frontend status
Event:  Frequency: 10847000
       SymbolRate: 22000000
       FEC_inner:  9

Bit error rate: 0
Signal strength: 396
SNR: 134
FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI FE_HAS_SYNC
dvbstream will stop after -1 seconds (71582788 minutes)
Output to stdout
Streaming 2 streams
^CCaught signal 2 - closing cleanly.

but the file remains empty

-rw-r--r--  1 root   root           0 2009-11-11 18:17 bbchd.mpg


When i try to record bvn (a fta channel)

# dvbstream -f 12574000 -p h -s 22000 -v 515 -a 96 -o > bvn.mpg
dvbstream v0.6 - (C) Dave Chapman 2001-2004
Released under the GPL.
Latest version available from http://www.linuxstb.org/
Tuning to 12574000 Hz
Using DVB card "STB0899 Multistandard", freq=12574000
tuning DVB-S to Freq: 1974000, Pol:H Srate=22000000, 22kHz tone=off, LNB: 0
Setting only tone ON and voltage 18V
DISEQC SETTING SUCCEDED
Getting frontend status
Event:  Frequency: 12574000
       SymbolRate: 22000000
       FEC_inner:  9

Bit error rate: 0
Signal strength: 226
SNR: 125
FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI FE_HAS_SYNC
dvbstream will stop after -1 seconds (71582788 minutes)
Output to stdout
Streaming 2 streams

-rw-r--r--  1 root   root    10409560 2009-11-11 19:01 bvn.mpg


[    9.920926] saa7146: register extension 'budget_ci dvb'.
[    9.921032] budget_ci dvb 0000:03:06.0: PCI INT A -> GSI 21
(level,low) -> IRQ 21
[    9.921108] DVB: registering new adapter (TT-Budget S2-3200 PCI)
[    9.981192] input: Budget-CI dvb ir receiver saa7146 (0)
as/devices/pci0000:00/0000:00:14.4/0000:03:06.0/input/input5
[   10.883169] DVB: registering adapter 0 frontend 0 (STB0899 Multistandard)...
[   20.031267] dvb_ca adaptor 0: PC card did not respond :(
[   28.201492] dvb_ca adapter 0: DVB CAM detected and initialised successfully

running on
2.6.31-14-generic #48-Ubuntu SMP x86_64 with latest (10-11-2009) v4l dvb drivers
