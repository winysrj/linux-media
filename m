Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbZLaWXP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Dec 2009 17:23:15 -0500
Message-ID: <4B3D244D.3030703@redhat.com>
Date: Thu, 31 Dec 2009 20:23:09 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] dvb-apps ported for ISDB-T
References: <4B32CF33.3030201@redhat.com> <4B342CEE.8020205@redhat.com> <alpine.LRH.2.00.0912251219090.30046@pub4.ifh.de>
In-Reply-To: <alpine.LRH.2.00.0912251219090.30046@pub4.ifh.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patrick Boettcher wrote:
> Hi Mauro,
> 
> On Fri, 25 Dec 2009, Mauro Carvalho Chehab wrote:
> 
>> Em 24-12-2009 00:17, Mauro Carvalho Chehab escreveu:
>>> I wrote several patches those days in order to allow dvb-apps to
>>> properly
>>> parse ISDB-T channel.conf.
>>>
>>> On ISDB-T, there are several new parameters, so the parsing is more
>>> complex
>>> than all the other currently supported video standards.
>>>
>>> I've added the changes at:
>>>
>>> http://linuxtv.org/hg/~mchehab/dvb-apps-isdbt/
>>>
>>> I've merged there Patrick's dvb-apps-isdbt tree.
>>>
>>> While there, I fixed a few bugs I noticed on the parser and converted it
>>> to work with the DVB API v5 headers that are bundled together with
>>> dvb-apps.
>>> This helps to avoid adding lots of extra #if DVB_ABI_VERSION tests.
>>> The ones
>>> there can now be removed.
>>>
>>> TODO:
>>> =====
>>>
>>> The new ISDB-T parameters are parsed, but I haven't add yet a code to
>>> make
>>> them to be used;
>>>
>>> There are 3 optional parameters with ISDB-T, related to 1seg/3seg: the
>>> segment parameters. Currently, the parser will fail if those
>>> parameters are found.
>>>
>>> gnutv is still reporting ISDB-T as "DVB-T".
>>>
>>
>> I've just fixed the issues on the TODO list. The DVB v5 code is now
>> working fine
>> for ISDB-T.
>>
>> Pending stuff (patches are welcome):
>>     - Implement v5 calls for other video standards;
>>     - Remove the duplicated DVBv5 code on /util/scan/scan.c (the code
>> for calling
>> DVBv5 is now at /lib/libdvbapi/v5api.c);
>>     - Test/use the functions to retrieve values via DVBv5 API. The
>> function is
>> already there, but I haven't tested.
>>
>> With the DVBv5 API implementation, zap is now working properly with
>> ISDB-T.
>> gnutv also works (although some outputs - like decoder - may need some
>> changes, in
>> order to work with mpeg4/AAC video/audio codecs).
> 
> Very good job!
> 
> Have you had a look here on this one
> 
> http://www.mail-archive.com/vdr@linuxtv.org/msg11125.html
> 
> ?
> 
> I had this on my list because I wanted to spent some time on DVB-S2
> myself and it seemed to be a good step to merge it (back) into dvb-apps.
> Though I haven't yet looked at it in detail.
> 
> I will check your changes soon, but after the holidays.
> 
> So, now you should have some quiet time for yourself! ;-)

Ok, I've added a version 2 of the isdbt-aware dvb-apps scan tools. 

Basically, this version:
	- checks if v5 API is available on a driver. If not, it falls back to 
	  v3 API;
	- v5api.c is now fully internal to libdvbfe. For library clients, it
is fully transparent if it is using v5 or v3 calls;
	- scan now uses libdvbfe, instead of directly implementing the
ioctls for v3 and v5. The code were simplified by the removal of lots of if's
for v5 API;
	- scan now supports a few parameters present on DVB-S2, but there
are still a few missing bits to fully support DVB-S2;
	- as my previous tree, dvb-apps has a copy of the dvb headers, since
the headers are stable enough to work with older drivers and since the API
version check is done by an ioctl call;
	- it addresses the pertinent issues that Manu pointed.

The big advantage of using libvbfe for scan is that we can remove all v5 
(and v3) calls from scan, having a cleaner code. Also, applications like kaffeine
that have their own scan codes can benefit on using libdvbfe.

Probably, it makes sense to move some code from scan to libdvbfe or to create
a libdvbscan, in order to easy the usage of the libdvb for applications that
want to have the scan code integrated.

I started to validate the delivery system descriptors against the EN 300 468
v 1.9.1, but I haven't finished yet. Due to that, a few new parameters were
added, making easier to add DVB-S2 support.

I intend later to finish the validation against ETSI for DVB standards and do
some review on ARIB and ABNT specs to be sure that it is able to get all 
parameters reported by the NIT tables for ISDB-T.

Yet, this version is not properly tested, but, as I intend to be on vacations
next week, I wanted to post what I have, even without all tests, to avoid the 
risk of someone to be working on DVB-S2 or other improvements to do a similar 
work.

So, the new tree is at:

http://linuxtv.org/hg/~mchehab/dvb-apps-isdbt2/

it was tested only with ISDB-T and may not work yet with other DTV standards.

Enjoy!

Happy New Year!
Mauro.
