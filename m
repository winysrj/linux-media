Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:4223 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab0DQKKa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Apr 2010 06:10:30 -0400
Received: by fg-out-1718.google.com with SMTP id d23so787840fga.1
        for <linux-media@vger.kernel.org>; Sat, 17 Apr 2010 03:10:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BC96A12.2040007@cogweb.net>
References: <4BC8F087.3050805@cogweb.net>
	 <u2g829197381004161714z2f0b827eu824a3bcb17d2aa17@mail.gmail.com>
	 <g2w846899811004162344ib3c9223ek8bcef2df83e7f23b@mail.gmail.com>
	 <4BC96A12.2040007@cogweb.net>
Date: Sat, 17 Apr 2010 12:10:27 +0200
Message-ID: <i2g846899811004170310s6f0a26fejace49a3886240bca@mail.gmail.com>
Subject: Re: zvbi-atsc-cc device node conflict
From: HoP <jpetrous@gmail.com>
To: David Liontooth <lionteeth@cogweb.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2010/4/17 David Liontooth <lionteeth@cogweb.net>:
> HoP wrote:
>>
>> 2010/4/17 Devin Heitmueller <dheitmueller@kernellabs.com>:
>>
>>>
>>> On Fri, Apr 16, 2010 at 7:19 PM, David Liontooth <lionteeth@cogweb.net>
>>> wrote:
>>>
>>>>
>>>> I'm using a HVR-1850 in digital mode and get good picture and sound
>>>> using
>>>>
>>>>  mplayer -autosync 30 -cache 2048 dvb://KCAL-DT
>>>>
>>>> Closed captioning works flawlessly with this command:
>>>>
>>>> zvbi-atsc-cc -C test-cc.txt KCAL-DT
>>>>
>>>> However, if I try to run both at the same time, I get a device node
>>>> conflict:
>>>>
>>>>  zvbi-atsc-cc: Cannot open '/dev/dvb/adapter0/frontend0': Device or
>>>> resource
>>>> busy.
>>>>
>>>> How do I get video and closed captioning at the same time?
>>>>
>>>
>>> To my knowledge, you cannot run two userland apps streaming from the
>>> frontend at the same time.  Generally, when people need to do this
>>> sort of thing they write a userland daemon that multiplexes.
>>> Alternatively, you can cat the frontend to disk and then have both
>>> mplayer and your cc parser reading the resulting file.
>>>
>>>
>>
>> Usually there is some way, for ex. command line option,
>> how to say to "second" app that frondend is already locked.
>> Then second app simply skips tuning at all.
>>
>> Rest processing is made using demux and dvr devices,
>> so there is not reason why 2 apps should tune in same
>> time.
>>
>> /Honza
>>
>
> Thanks! I'm trying to create separate recordings of the video/audio file on
> the one hand and the closed captioning on the other.
>
> In one console, I issue
>
>  azap -r KOCE-HD
>
> In a second, I issue
>
>  cat /dev/dvb/adapter0/dvr0 > test-cat3.mpeg
>
> I cannot at the same time run this in a third:
>
>  zvbi-atsc-cc -C test-cc.txt KOCE-HD
>
> because of resource conflict.
>
> Using cat works, but how do I get closed captioning from the resulting mpeg
> file?
>

Very dump way is simply feed zvbi with resulting test-cat3.mpeg.
If this page is correct: http://www.digipedia.pl/man/doc/view/zvbi-atsc-cc.1/
using -t command line option you can get CC by issuing something like
"cat test-cat3.mpeg > zvbi-atsc-cc -ts -C test-cc.txt"

Of course I'm assuming that CC pid is included in recording.
But dunno if azap is demuxing pids others then A/V.

/Honza
