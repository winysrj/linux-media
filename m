Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:42958 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbZLYLZd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Dec 2009 06:25:33 -0500
Date: Fri, 25 Dec 2009 12:25:14 +0100 (CET)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] dvb-apps ported for ISDB-T
In-Reply-To: <4B342CEE.8020205@redhat.com>
Message-ID: <alpine.LRH.2.00.0912251219090.30046@pub4.ifh.de>
References: <4B32CF33.3030201@redhat.com> <4B342CEE.8020205@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Fri, 25 Dec 2009, Mauro Carvalho Chehab wrote:

> Em 24-12-2009 00:17, Mauro Carvalho Chehab escreveu:
>> I wrote several patches those days in order to allow dvb-apps to properly
>> parse ISDB-T channel.conf.
>>
>> On ISDB-T, there are several new parameters, so the parsing is more complex
>> than all the other currently supported video standards.
>>
>> I've added the changes at:
>>
>> http://linuxtv.org/hg/~mchehab/dvb-apps-isdbt/
>>
>> I've merged there Patrick's dvb-apps-isdbt tree.
>>
>> While there, I fixed a few bugs I noticed on the parser and converted it
>> to work with the DVB API v5 headers that are bundled together with dvb-apps.
>> This helps to avoid adding lots of extra #if DVB_ABI_VERSION tests. The ones
>> there can now be removed.
>>
>> TODO:
>> =====
>>
>> The new ISDB-T parameters are parsed, but I haven't add yet a code to make
>> them to be used;
>>
>> There are 3 optional parameters with ISDB-T, related to 1seg/3seg: the
>> segment parameters. Currently, the parser will fail if those parameters are found.
>>
>> gnutv is still reporting ISDB-T as "DVB-T".
>>
>
> I've just fixed the issues on the TODO list. The DVB v5 code is now working fine
> for ISDB-T.
>
> Pending stuff (patches are welcome):
> 	- Implement v5 calls for other video standards;
> 	- Remove the duplicated DVBv5 code on /util/scan/scan.c (the code for calling
> DVBv5 is now at /lib/libdvbapi/v5api.c);
> 	- Test/use the functions to retrieve values via DVBv5 API. The function is
> already there, but I haven't tested.
>
> With the DVBv5 API implementation, zap is now working properly with ISDB-T.
> gnutv also works (although some outputs - like decoder - may need some changes, in
> order to work with mpeg4/AAC video/audio codecs).

Very good job!

Have you had a look here on this one

http://www.mail-archive.com/vdr@linuxtv.org/msg11125.html

?

I had this on my list because I wanted to spent some time on DVB-S2 myself 
and it seemed to be a good step to merge it (back) into dvb-apps. Though I 
haven't yet looked at it in detail.

I will check your changes soon, but after the holidays.

So, now you should have some quiet time for yourself! ;-)

regards,

--

Patrick Boettcher - Kernel Labs
http://www.kernellabs.com/
