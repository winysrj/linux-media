Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KhvgJ-0006GO-Fn
	for linux-dvb@linuxtv.org; Tue, 23 Sep 2008 02:23:29 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K7M00GG7H1JSG30@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Mon, 22 Sep 2008 20:22:32 -0400 (EDT)
Date: Mon, 22 Sep 2008 20:22:31 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <007d01c91d0a$beb8cb70$3c2a6250$@net>
To: James Evans <jrevans1@earthlink.net>
Message-id: <48D836C7.7060901@linuxtv.org>
MIME-version: 1.0
References: <002001c91c65$939d8b60$bad8a220$@net>
	<48D71852.5090705@linuxtv.org> <002701c91c6b$6d310fa0$47932ee0$@net>
	<48D726C9.3030605@linuxtv.org> <007d01c91d0a$beb8cb70$3c2a6250$@net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVICO FusionHDTV5 Express Support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

James Evans wrote:
>> James Evans wrote:
>>> Thank you for such a quick response.
>>>
>>>> Debug looks OK. If you have another board where you know for certain
>>>> that tuning a specific 8VSB frequency works, then tuning this same
>>>> frequency with the LG should probably work reliably.
>>> The installed Airstar HD5000 cards both have an LG tuner and can tune perfectly fine.
>> OK, pick a single frequency and focus on always tuning that for the time
>> being with the Express card.
> 
> HD5000 Results:
> % /usr/bin/azap -a 1 -r -c ~/.azap/channels.conf "KTTV DT" 
> using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
> tuning to 779028615 Hz
> video pid 0x0031, audio pid 0x0034
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 | 
> status 1e | signal c6ce | snr 1b2e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1e | signal e4e6 | snr 1f4b | ber 00000000 | unc 0000003d | FE_HAS_LOCK
> status 1e | signal e1b8 | snr 1edc | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1e | signal e86e | snr 1fc7 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1e | signal e86e | snr 1fc7 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1e | signal daef | snr 1dee | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> ^C
> 
> FusionHDTV5 Results:
> % /usr/bin/azap -a 0 -r -c ~/.azap/channels.conf "KTTV DT" 
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> tuning to 779028615 Hz
> video pid 0x0031, audio pid 0x0034
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 | 
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 | 
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 | 
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 | 
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 | 
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 | 
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 | 
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 | 
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 | 
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 | 
> ^C
> 
>>>> In terms of the tuner-to-demod, are you confident that the I/F is set
>>>> correctly? (And inversion for that matter?)
>>> I am not sure I understand the above question.  How would I go about setting up the interface for
>> the tuner-to-demod?
>>
>> /me checks the code and thinks it should be working fine.
>>
>> Specifically, please list here the frequencies that lock reliably for
>> you on 8VSB with other boards. I've seen issues in the past (mainly due
>> to driver issues) where channels tables work reliably for one tuner but
>> not for another.
> 
> Here is the working table that the HD5000 boards are using.
> 
> KFLA-LD:183028615:8VSB:4128:4129:1
> HCCN:183028615:8VSB:4130:4131:2
> CVTV:183028615:8VSB:4640:4641:3
> WSTV:183028615:8VSB:80:89:4
> KTBN-DT 1:527028615:8VSB:49:52:3
> KTBN-DT 2:527028615:8VSB:65:68:4
> KTBN-DT 3:527028615:8VSB:81:84:5
> KTBN-DT 4:527028615:8VSB:97:100:6
> KTBN-DT 5:527028615:8VSB:113:116:7
> TeleFutura:563028615:8VSB:49:52:3
> KTLA-DT:575028615:8VSB:49:52:3
> KDOC-HD:581028615:8VSB:49:52:1
> KDOCSD1:581028615:8VSB:65:68:2
> [0004]:581028615:8VSB:81:84:4
> KDOCSD2:581028615:8VSB:81:84:3
> Univision:599028615:8VSB:49:52:3
> NBC-4LA:605028615:8VSB:49:52:3
> WX-Plus:605028615:8VSB:65:68:4
> NewsRaw:605028615:8VSB:81:84:5
> ION:617028615:8VSB:49:52:3
> KPXN qubo:617028615:8VSB:65:68:4
> IONLife:617028615:8VSB:81:84:5
> Worship:617028615:8VSB:97:100:6
> KVEA-HD:623028615:8VSB:49:52:3
> KVEA-SD:623028615:8VSB:65:68:4
> KLCS-DT:635028615:8VSB:49:52:2
> KLCS-DT:635028615:8VSB:65:68:3
> KLCS-DT:635028615:8VSB:81:84:4
> KLCS-DT:635028615:8VSB:97:100:5
> [0006]:635028615:8VSB:113:116:6
> KWHY-HD:641028615:8VSB:49:52:3
> KWHY-SD:641028615:8VSB:65:68:4
> KCAL-DT:647028615:8VSB:49:52:1
> KAZA-DT:671028615:8VSB:49:52:3
> KAZA-TV:671028615:8VSB:0:0:65535
> KOCE-HD:677028615:8VSB:49:52:3
> KOCE-OC:677028615:8VSB:65:68:4
> KOCE-SD:677028615:8VSB:81:84:5
> Daystar:677028615:8VSB:97:100:6
> KOCE-TV:677028615:8VSB:0:0:65535
> KJLA-DT:683028615:8VSB:49:52:3
> KXLA-DT:683028615:8VSB:65:68:4
> KVMD-DT:683028615:8VSB:81:84:5
> LATV:683028615:8VSB:97:100:6
> KXLA-DT:695028615:8VSB:49:52:3
> KVMD-DT:695028615:8VSB:65:68:4
> KABC-DT:707028615:8VSB:49:52:1
> KABC-SD:707028615:8VSB:65:68:2
> KABC-WN:707028615:8VSB:81:84:3
> KCET-HD:743028615:8VSB:49:52:1
> KCET-OC:743028615:8VSB:97:100:2
> KCET-Vm:743028615:8VSB:81:84:3
> KCET-W:743028615:8VSB:65:68:4
> [0009]:743028615:8VSB:0:0:9
> [000a]:743028615:8VSB:0:0:10
> KCBS-DT:749028615:8VSB:49:52:1
> LA18.1:755028615:8VSB:49:52:1
> LA18.8:755028615:8VSB:161:164:8
> LA18.5:755028615:8VSB:113:116:5
> LA18.7:755028615:8VSB:145:148:7
> LA18.3:755028615:8VSB:81:84:3
> LA18.6:755028615:8VSB:129:132:6
> LA18:755028615:8VSB:0:0:65535
> KTTV DT:779028615:8VSB:49:52:3
> KCOP DT:785028615:8VSB:49:52:3
> KRCA-DT:797028615:8VSB:49:52:1
> KRCA-DT:797028615:8VSB:65:68:2
> 
> Thanks again for the help!
> --James Evans
> 

Add this:

test:779000000:8VSB:49:52:3

And try azap -r test

Better?

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
