Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44763 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754661AbZGIJDM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jul 2009 05:03:12 -0400
Message-ID: <4A55B2E3.9050604@redhat.com>
Date: Thu, 09 Jul 2009 11:05:39 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: RFC: howto handle driver changes which require libv4l > x.y ?
References: <4A53509D.8060503@redhat.com>	<62e5edd40907070655g75dbfc5dy3799d85a15ad4a6c@mail.gmail.com> <20090707113538.71ecd68e@pedra.chehab.org>
In-Reply-To: <20090707113538.71ecd68e@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/07/2009 04:35 PM, Mauro Carvalho Chehab wrote:
> Em Tue, 7 Jul 2009 15:55:59 +0200
> Erik Andrén<erik.andren@gmail.com>  escreveu:
>
>> 2009/7/7 Hans de Goede<hdegoede@redhat.com>:
>>> Hi All,
>>>
>>> So recently I've hit 2 issues where kernel side fixes need
>>> to go hand in hand with libv4l updates to not cause regressions.
>>>
>>> First lets discuss the 2 cases:
>>> 1) The pac207 driver currently limits the framerate (and thus
>>>    the minimum exposure time) because at higher framerate the
>>>    cam starts using a higher compression and we could not
>>>    decompress this. Thanks to Bertrik Sikken we can now handle
>>>    the higher decompression.
>>>
>>>    So no I really want to enable the higher framerates as those
>>>    are needed to make the cam work properly in full daylight.
>>>
>>>    But if I do this, things will regress for people with an
>>>    older libv4l, as that won't be able to decompress the frames
>>>
>>> 2) Several zc3xxx cams have a timing issue between the bridge and
>>>    the sensor (the windows drivers have the same issue) which
>>>    makes them do only 320x236 instead of 320x240. Currently
>>>    we report their resolution to userspace as 320x240, leading to
>>>    a bar of noise at the bottom of the screen.
>>>
>>>    The fix here obviously is to report the real effective resoltion
>>>    to userspace, but this will cause regressions for apps which blindly
>>>    assume 320x240 is available (such as skype). The latest libv4l will
>>>    make the apps happy again by giving them 320x240 by adding small
>>>    black borders.
>>>
>>>
>>> Now I see 2 solutions here:
>>>
>>> a) Just make the changes, seen from the kernel side these are most
>>>    certainly bugfixes. I tend towards this for case 2)
>>>
>>> b) Come up with an API to tell the libv4l version to the kernel and
>>>    make these changes in the drivers conditional on the libv4l version
>>>
>>>
>> Solution b) sounds messy and will probably lead to a lot of error
>> prone glue code in the kernel.
>> Fast-forward a couple of libv4l releases and you will have a nightmare
>> maintainability scenario.
>>
>> If people run an old libv4l with a new kernel and run into problem,
>> just tell them to upgrade their libv4l version.
>
> (b) seems a very bad hack, IMO. Between the two, I choose (a).
>

Ok,

So (a) it is then, I'll do a libv4l-0.6.0 release today. And put the changes
depend upon libv4l-0.6.0 in my tree then as time permits, they will then go
into 2.6.32 eventually which should put enough time between the libv4l release
and the kernel release for most people to have the newer libv4l.

Regards,

Hans
