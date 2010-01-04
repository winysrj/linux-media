Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:55516 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab0ADQtT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jan 2010 11:49:19 -0500
Received: by fxm25 with SMTP id 25so8887566fxm.21
        for <linux-media@vger.kernel.org>; Mon, 04 Jan 2010 08:49:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B3D244D.3030703@redhat.com>
References: <4B32CF33.3030201@redhat.com> <4B342CEE.8020205@redhat.com>
	 <alpine.LRH.2.00.0912251219090.30046@pub4.ifh.de>
	 <4B3D244D.3030703@redhat.com>
Date: Mon, 4 Jan 2010 20:49:16 +0400
Message-ID: <1a297b361001040849j1d9b2514y9437746e14665ed8@mail.gmail.com>
Subject: Re: [RFC] dvb-apps ported for ISDB-T
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Patrick Boettcher <pboettcher@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 1, 2010 at 2:23 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Patrick Boettcher wrote:
>> Hi Mauro,
>>
>> On Fri, 25 Dec 2009, Mauro Carvalho Chehab wrote:
>>
>>> Em 24-12-2009 00:17, Mauro Carvalho Chehab escreveu:
>>>> I wrote several patches those days in order to allow dvb-apps to
>>>> properly
>>>> parse ISDB-T channel.conf.
>>>>
>>>> On ISDB-T, there are several new parameters, so the parsing is more
>>>> complex
>>>> than all the other currently supported video standards.
>>>>
>>>> I've added the changes at:
>>>>
>>>> http://linuxtv.org/hg/~mchehab/dvb-apps-isdbt/
>>>>
>>>> I've merged there Patrick's dvb-apps-isdbt tree.
>>>>
>>>> While there, I fixed a few bugs I noticed on the parser and converted it
>>>> to work with the DVB API v5 headers that are bundled together with
>>>> dvb-apps.
>>>> This helps to avoid adding lots of extra #if DVB_ABI_VERSION tests.
>>>> The ones
>>>> there can now be removed.
>>>>
>>>> TODO:
>>>> =====
>>>>
>>>> The new ISDB-T parameters are parsed, but I haven't add yet a code to
>>>> make
>>>> them to be used;
>>>>
>>>> There are 3 optional parameters with ISDB-T, related to 1seg/3seg: the
>>>> segment parameters. Currently, the parser will fail if those
>>>> parameters are found.
>>>>
>>>> gnutv is still reporting ISDB-T as "DVB-T".
>>>>
>>>
>>> I've just fixed the issues on the TODO list. The DVB v5 code is now
>>> working fine
>>> for ISDB-T.
>>>
>>> Pending stuff (patches are welcome):
>>>     - Implement v5 calls for other video standards;
>>>     - Remove the duplicated DVBv5 code on /util/scan/scan.c (the code
>>> for calling
>>> DVBv5 is now at /lib/libdvbapi/v5api.c);
>>>     - Test/use the functions to retrieve values via DVBv5 API. The
>>> function is
>>> already there, but I haven't tested.
>>>
>>> With the DVBv5 API implementation, zap is now working properly with
>>> ISDB-T.
>>> gnutv also works (although some outputs - like decoder - may need some
>>> changes, in
>>> order to work with mpeg4/AAC video/audio codecs).
>>
>> Very good job!
>>
>> Have you had a look here on this one
>>
>> http://www.mail-archive.com/vdr@linuxtv.org/msg11125.html
>>
>> ?
>>
>> I had this on my list because I wanted to spent some time on DVB-S2
>> myself and it seemed to be a good step to merge it (back) into dvb-apps.
>> Though I haven't yet looked at it in detail.
>>
>> I will check your changes soon, but after the holidays.
>>
>> So, now you should have some quiet time for yourself! ;-)
>
> Ok, I've added a version 2 of the isdbt-aware dvb-apps scan tools.
>
> Basically, this version:
>        - checks if v5 API is available on a driver. If not, it falls back to
>          v3 API;
>        - v5api.c is now fully internal to libdvbfe. For library clients, it
> is fully transparent if it is using v5 or v3 calls;
>        - scan now uses libdvbfe, instead of directly implementing the
> ioctls for v3 and v5. The code were simplified by the removal of lots of if's
> for v5 API;
>        - scan now supports a few parameters present on DVB-S2, but there
> are still a few missing bits to fully support DVB-S2;
>        - as my previous tree, dvb-apps has a copy of the dvb headers, since
> the headers are stable enough to work with older drivers and since the API
> version check is done by an ioctl call;
>        - it addresses the pertinent issues that Manu pointed.


It still remains the same, however.

I had a quick look at it again:

- dvb-apps/libs stopped using a separate copy of the kernel headers;
ie  kernel headers are expected to be at the default system locations,
ie the kernel headers package. Because you added it in again, a test
app szap2 had to be disabled for compilation. Changesets: 1332, 1334,
1348, 1357

- the library is falling on an expected operation for V5. This can
fail if the API is V3 or something else. It should check the header
version and if it is known to be greater than V3, then only it should
issue the new V5 ioctl to test for version. This frees from an
unnecessary test in the case of the V3 API. Changeset 1336

- Please do not apply partial features. Either apply it, or don't.
Changeset 1341

- ATSC Cable is not DVB-C, even though it has some similiarities.
Let's not get things mixed up. Changeset 1344

- Let the application send the number of properties, not the library
to do memory allocation and deallocation. I mentioned about this one
in my previous reply to your post. fill_sys_v5_params() -->
count_props()
Changeset: 1350, 1359, 1360
sizeof applies to a data structure, not the pointer, Changeset 1360

- maintain Backward compatibility with V3. Changeset 1351


> Yet, this version is not properly tested, but, as I intend to be on vacations
> next week, I wanted to post what I have, even without all tests, to avoid the
> risk of someone to be working on DVB-S2 or other improvements to do a similar
> work.


- Memory management needs string.h

v5api.c:512: warning: implicit declaration of function ‘memset’
v5api.c:512: warning: incompatible implicit declaration of built-in
function ‘memset
v5api.c:567: warning: incompatible implicit declaration of built-in
function ‘memset’


Maybe, it would simplify things, if I would pull in the changes till
where it looks mostly right, the others which you could possibly
rework. Or maybe you would like me to apply things as a whole
together. But I guess things would be simpler in the former case.


Regards,
Manu
