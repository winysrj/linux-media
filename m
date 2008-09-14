Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1Kesn8-0001TY-Jo
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 16:41:36 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K76007YNWSBAA40@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sun, 14 Sep 2008 10:41:00 -0400 (EDT)
Date: Sun, 14 Sep 2008 10:40:59 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20080914123631.73900@gmx.net>
To: Hans Werner <HWerner4@gmx.de>
Message-id: <48CD227B.2060503@linuxtv.org>
MIME-version: 1.0
References: <48CA0355.6080903@linuxtv.org>
	<alpine.LRH.1.10.0809121112350.29931@pub3.ifh.de>
	<48CC1C3C.6020701@linuxtv.org> <20080914123631.73900@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] S2API - Status  - Thu Sep 11th
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

Hans Werner wrote:
>> Patrick Boettcher wrote:
>>> Hi Steve,
>>>
>>> On Fri, 12 Sep 2008, Steven Toth wrote:
>>>> Patrick, I haven't looked at your 1.7MHz bandwidth suggestion - I'm
>> open
>>>> to ideas on how you think we should do this. Take a look at todays
>>>> linux/dvb/frontend.h and see if these updates help, or whether you need
>>>> more changes.
>>> I attached a patch which adds a DTV_BANDWIDTH_HZ command. That's all. I 
>>> would like to have the option to pass any bandwidth I want to the
>> frontend.
>> ...
>>
>>> Sorry for not integrating this into the frontend_cache yet. But I'm 
>>> really out of time (at work and even at home, working on cx24120) and I 
>>> will not be able to supply the DiBcom ISDB-T demod-driver (which would 
>>> use all that) right now.
>> Great, thanks, I Merged with minor cleanup of comments.
>>
>> We should discuss the ISDB specifics at plumbers. The LAYER commands are 
>> not currently implemented and it would be good to understand atleast two 
>> different demodulators so we can abstract their controls into an API - 
>> and avoid any device specifics.
>>
>> Changes to tune.c (v0.0.6) on steventoth.net/linux/s2
>>
>> - Steve
> 
> The examples in tune 0.0.6 have two extra zeros :
> 
> it should be
> { .cmd = DTV_BANDWIDTH_HZ,    .u.data = 8000000 },
> not
> { .cmd = DTV_BANDWIDTH_HZ,    .u.data = 800000000 },
> 
> After applying the multifrontend patch I have signal lock working with HVR4000 and 
> S2API on all three delivery systems:
> DVB-T (tune -f 1 option)
> and
> DVB-S/S2 (tune -f 0 option)
> 
> The legacy API works too for DVB-T and DVB-S. Darron has a cx24116 patch which
> I needed to apply.

Thanks for highlighting this.

Fixed in v0.0.7, available on steventoth.net/linux/s2

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
