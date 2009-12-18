Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:41842 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbZLRNZ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2009 08:25:29 -0500
Received: by ewy19 with SMTP id 19so1476193ewy.21
        for <linux-media@vger.kernel.org>; Fri, 18 Dec 2009 05:25:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B275CA2.406@tripleplay-services.com>
References: <4B269F1A.30107@onid.orst.edu>
	 <4B275CA2.406@tripleplay-services.com>
Date: Fri, 18 Dec 2009 08:25:25 -0500
Message-ID: <83bcf6340912180525h1bbaf229j9b2c81ffacb8fe76@mail.gmail.com>
Subject: Re: scan/scan-s2 doesn't tune, but dvbtune does?
From: Steven Toth <stoth@kernellabs.com>
To: Lou Otway <louis.otway@tripleplay-services.com>
Cc: Michael Akey <akeym@onid.orst.edu>,
	Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 15, 2009 at 4:53 AM, Lou Otway
<louis.otway@tripleplay-services.com> wrote:
>
>
> Michael Akey wrote:
>>
>> I can't get the scan/scan-s2 utilities to lock any transponders (DVB-S).
>>  My test satellite is AMC1 103W, the Pentagon Channel tp. This is probably
>> some simple user error on my part, but I can't figure it out.  I have a
>> Corotor II with polarity changed via serial command to an external IRD.
>>  C/Ku is switched by 22KHz tone, voltage is always 18V.  Ku is with tone
>> off, C with tone on.  Speaking of which, is there a way to manually set the
>> tone from the arguments on the scan utilities?
>>
>> Here's what I've tried and the results:
>>
>> $ ./scan-s2 -a 0 -v -o zap -l 10750 INIT
>> API major 5, minor 0
>> scanning INIT
>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>> initial transponder DVB-S  12100000 H 20000000 AUTO AUTO AUTO
>> initial transponder DVB-S2 12100000 H 20000000 AUTO AUTO AUTO
>> ----------------------------------> Using DVB-S
>> >>> tune to: 12100:h:0:20000
>> DVB-S IF freq is 1350000
>> >>> tuning status == 0x03
>> >>> tuning status == 0x01
>> >>> tuning status == 0x03
>> >>> tuning status == 0x01
>> >>> tuning status == 0x03
>> >>> tuning status == 0x00
>> >>> tuning status == 0x01
>> >>> tuning status == 0x03
>> >>> tuning status == 0x00
>> >>> tuning status == 0x00
>> WARNING: >>> tuning failed!!!
>> >>> tune to: 12100:h:0:20000 (tuning failed)
>> DVB-S IF freq is 1350000
>> >>> tuning status == 0x03
>> >>> tuning status == 0x01
>> >>> tuning status == 0x00
>> >>> tuning status == 0x00
>> ...snip...
>>
>> Same thing happens if I use just 'scan' and not 'scan-s2.'
>>
>> If I use dvbtune, it works though..
>>
>> $ dvbtune -f 1350000 -p H -s 20000 -c 0 -tone 0 -m
>> Using DVB card "Conexant CX24116/CX24118"
>> tuning DVB-S to L-Band:0, Pol:H Srate=20000000, 22kHz=off
>> polling....
>> Getting frontend event
>> FE_STATUS:
>> polling....
>> Getting frontend event
>> FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI
>> FE_HAS_SYNC
>> Bit error rate: 0
>> Signal strength: 51648
>> SNR: 26215
>> FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI
>> FE_HAS_SYNC
>> Signal=51648, Verror=0, SNR=26215dB, BlockErrors=0, (S|L|C|V|SY|)
>> Signal=51776, Verror=0, SNR=26624dB, BlockErrors=0, (S|L|C|V|SY|)
>>
>> The tuning file 'INIT' contains only the following line:
>> S 12100000 H 20000000 AUTO
>>
>> I'm using v4l-dvb drivers from the main repo as of about a week ago.  I am
>> running kernel 2.6.32 on Debian testing.  Any help is appreciated ..and
>> hopefully it's just a simple flub on my part!
>>
>> --Mike
>
> Try using a non-auto FEC and rolloff.
>
> Some devices won't accept auto for these parameters.

Michael,

The silicon in question doesn't do automatic FEC detection. Be sure to
specify which FEC you need for the sat. If in doubt, walk through them
all manually. Pilot auto detect is done in s/w was was added a long
time ago.

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
