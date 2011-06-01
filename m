Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:28448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754431Ab1FANla (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jun 2011 09:41:30 -0400
Message-ID: <4DE64181.6050007@redhat.com>
Date: Wed, 01 Jun 2011 10:41:21 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [GIT PATCHES FOR 2.6.41] Add bitmask controls
References: <201105231315.29328.hverkuil@xs4all.nl>    <4DE636C5.7040604@redhat.com> <ef656b6325ca0b3c65337f7480f834f0.squirrel@webmail.xs4all.nl>
In-Reply-To: <ef656b6325ca0b3c65337f7480f834f0.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 01-06-2011 10:27, Hans Verkuil escreveu:
>> Hi Hans,
>>
>> Em 23-05-2011 08:15, Hans Verkuil escreveu:
>>> Hi Mauro,
>>>
>>> These patches for 2.6.41 add support for bitmask controls, needed for
>>> the
>>> upcoming Flash API and HDMI API.
>>
>> DocBook changes need do a s/2.6.41/3.1/.
> 
> Of course, I saw your DocBook changes going today.

Btw, you may need to adjust your daily scripts, as the patches changed
the place where the V4L API is placed.

>> That's said, I'm not sure if it is a good idea to add bitmask type,
>> instead of
>> just using a set of boolean controls.
> 
> There are currently two use cases: Sakari's flash controller needs to
> report errors which are a bitmask of possible error conditions. It is way
> overkill to split that up in separate boolean controls, especially since
> apps will also want to get an event whenever such an error is raised.

Hmm... returning errors via V4L2 controls don't seem to be a good implementation.
I need to review his RFC to better understand his idea.

> The other is in HDMI receivers where there can be multiple ports that do
> EDID handling, but only one can stream. You need a way to tell which ports
> received an EDID for example. Again, you can make multiple boolean
> controls like HDMI_PORT0_EDID_REC, PORT1, PORT2, PORT3, etc. but that is a
> waste of code and time.

Ok, this seems to be a good example.

>> One of the issues with bitmasks is
>> the
>> endness type: LE, BE or machine endianness. The specs don't mention how
>> this
>> is supposed to work.
> 
> Good point. It's machine endianness, but that definitely has to be
> documented. I'll do that.

OK, thanks!

>> Also, I'd like to see a patch like that submitting with a driver or
>> feature
>> that needs it. Before you ask: no, vivi doesn't count ;)
> 
> Sakari will hopefully be the first 'real' user for this for a flash driver.

Thanks,
Mauro
