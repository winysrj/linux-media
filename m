Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41495 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab1FVKFU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 06:05:20 -0400
Received: by ywe9 with SMTP id 9so251690ywe.19
        for <linux-media@vger.kernel.org>; Wed, 22 Jun 2011 03:05:19 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 22 Jun 2011 12:05:19 +0200
Message-ID: <BANLkTi=73UGtcMTE5dUWSQEeyke8T-HB8Q@mail.gmail.com>
Subject: impossible to tune card, but I can watch TV :?
From: mutoid <mutoid@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

I have an Avermedia Super 007, installed in a headless Linux machine to
multicast some TV channels.

I use "mumudvb" and works fine, without problem. I can stream 4 TV channels
and 4 radios at once

But now I need to extract EPG data, using dbvtune and tv_grab_dvb

I tried 2 configurations:

* Kworld USB DVB-T + dvbtune + tv_grab_dvb = works fine

~# dvbtune -c 1 -f 770000
Using DVB card "Afatech AF9013 DVB-T"
tuning DVB-T (in United Kingdom) to 770000000 Hz
polling....
Getting frontend event
FE_STATUS:
polling....
Getting frontend event
FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI
FE_HAS_SYNC
Event:  Frequency: 780600000
        SymbolRate: 0
        FEC_inner:  2

Bit error rate: 0
Signal strength: 51993
SNR: 120
FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI
FE_HAS_SYNC


* Avermedia Super 007 + dvbtune = no working

~# dvbtune -c 0 -f 770000
Using DVB card "Philips TDA10046H DVB-T"
tuning DVB-T (in United Kingdom) to 770000000 Hz
polling....
Getting frontend event
FE_STATUS:
polling....
polling....
polling....
polling....

Why can I use dvbtune with one USB card but not with a PCI card?

Thanks.
