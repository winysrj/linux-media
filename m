Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.oregonstate.edu ([128.193.15.36]:36329 "EHLO
	smtp2.oregonstate.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbZLNUe7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2009 15:34:59 -0500
Received: from localhost (localhost [127.0.0.1])
	by smtp2.oregonstate.edu (Postfix) with ESMTP id 112E43C0EB
	for <linux-media@vger.kernel.org>; Mon, 14 Dec 2009 12:23:46 -0800 (PST)
Received: from smtp2.oregonstate.edu ([127.0.0.1])
	by localhost (smtp.oregonstate.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FBudQZBsPn8F for <linux-media@vger.kernel.org>;
	Mon, 14 Dec 2009 12:23:45 -0800 (PST)
Received: from [10.192.126.45] (spike.nws.oregonstate.edu [10.192.126.45])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp2.oregonstate.edu (Postfix) with ESMTPSA id DE04E3C0F1
	for <linux-media@vger.kernel.org>; Mon, 14 Dec 2009 12:23:45 -0800 (PST)
Message-ID: <4B269F1A.30107@onid.orst.edu>
Date: Mon, 14 Dec 2009 12:24:58 -0800
From: Michael Akey <akeym@onid.orst.edu>
MIME-Version: 1.0
To: Linux Media <linux-media@vger.kernel.org>
Subject: scan/scan-s2 doesn't tune, but dvbtune does?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I can't get the scan/scan-s2 utilities to lock any transponders 
(DVB-S).  My test satellite is AMC1 103W, the Pentagon Channel tp. This 
is probably some simple user error on my part, but I can't figure it 
out.  I have a Corotor II with polarity changed via serial command to an 
external IRD.  C/Ku is switched by 22KHz tone, voltage is always 18V.  
Ku is with tone off, C with tone on.  Speaking of which, is there a way 
to manually set the tone from the arguments on the scan utilities?

Here's what I've tried and the results:

$ ./scan-s2 -a 0 -v -o zap -l 10750 INIT
API major 5, minor 0
scanning INIT
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder DVB-S  12100000 H 20000000 AUTO AUTO AUTO
initial transponder DVB-S2 12100000 H 20000000 AUTO AUTO AUTO
----------------------------------> Using DVB-S
 >>> tune to: 12100:h:0:20000
DVB-S IF freq is 1350000
 >>> tuning status == 0x03
 >>> tuning status == 0x01
 >>> tuning status == 0x03
 >>> tuning status == 0x01
 >>> tuning status == 0x03
 >>> tuning status == 0x00
 >>> tuning status == 0x01
 >>> tuning status == 0x03
 >>> tuning status == 0x00
 >>> tuning status == 0x00
WARNING: >>> tuning failed!!!
 >>> tune to: 12100:h:0:20000 (tuning failed)
DVB-S IF freq is 1350000
 >>> tuning status == 0x03
 >>> tuning status == 0x01
 >>> tuning status == 0x00
 >>> tuning status == 0x00
...snip...

Same thing happens if I use just 'scan' and not 'scan-s2.'

If I use dvbtune, it works though..

$ dvbtune -f 1350000 -p H -s 20000 -c 0 -tone 0 -m
Using DVB card "Conexant CX24116/CX24118"
tuning DVB-S to L-Band:0, Pol:H Srate=20000000, 22kHz=off
polling....
Getting frontend event
FE_STATUS:
polling....
Getting frontend event
FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI 
FE_HAS_SYNC
Bit error rate: 0
Signal strength: 51648
SNR: 26215
FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI 
FE_HAS_SYNC
Signal=51648, Verror=0, SNR=26215dB, BlockErrors=0, (S|L|C|V|SY|)
Signal=51776, Verror=0, SNR=26624dB, BlockErrors=0, (S|L|C|V|SY|)

The tuning file 'INIT' contains only the following line:
S 12100000 H 20000000 AUTO

I'm using v4l-dvb drivers from the main repo as of about a week ago.  I 
am running kernel 2.6.32 on Debian testing.  Any help is appreciated 
..and hopefully it's just a simple flub on my part!

--Mike


