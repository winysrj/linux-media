Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:24076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105Ab1AZLgL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jan 2011 06:36:11 -0500
Message-ID: <4D400727.3000205@redhat.com>
Date: Wed, 26 Jan 2011 09:36:07 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: What to do with videodev.h
References: <4D3FDAAC.2020303@redhat.com> <4D3FE453.6080307@redhat.com> <613f734c5a59a342c587769455e939af.squirrel@webmail.xs4all.nl>
In-Reply-To: <613f734c5a59a342c587769455e939af.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 26-01-2011 07:47, Hans Verkuil escreveu:
>> Hi Hans,
>>
>> Em 26-01-2011 06:26, Hans de Goede escreveu:
>>> Hi All,
>>>
>>> With v4l1 support going completely away, the question is
>>> raised what to do with linux/videodev.h .
>>>
>>> Since v4l1 apps can still use the old API through libv4l1,
>>> these apps will still need linux/videodev.h to compile.
>>>
>>> So I see 3 options:
>>> 1) Keep videodev.h in the kernel tree even after we've dropped
>>> the API support at the kernel level (seems like a bad idea to me)
>>
>> That's a bad idea.
>>
>>> 2) Copy videodev.h over to v4l-utils as is (under a different name)
>>> and modify the #include in libv4l1.h to include it under the
>>> new name
>>> 3) Copy the (needed) contents of videodev.h over to libv4l1.h
>>
>> I would do (3). This provides a clearer signal that V4L1-only apps need
>> to use libv4l1, or otherwise will stop working.
> 
> I agree with this.
> 
>> Of course, the better is to remove V4L1 support from those old apps.
>> There are a number of applications that support both API's. So, it
>> is time to remove V4L1 support from them.
> 
> So who is going to do that work? That's the problem...
> 
> But ensuring that they no longer compile is a good start :-)
> 
> Although most have a private copy of videodev.h as part of their sources.

The ones that don't have videodev.h will compile-break on distros. So distros
will need to do something to keep it working, or they'll just drop those
pre-historic beasts. It is the Evolution Theory working for software:
to adapt or to be extinguished ;)

The ones that are shipped with videodev.h and weren't converted to libv4l
might eventually stay there for a longer time, as people will only notice
when a bug will be reported. If we know what are those apps, then we can
add a blacklist at linuxtv and/or contact interested parties on fixing/removing
them.

We should touch the tools that we care of. Maybe Devin could change tvtime,
we should remove V4L1 driver from xawtv3/xawtv4.

Regards,
Mauro
