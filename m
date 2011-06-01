Return-path: <mchehab@pedra>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3162 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1FAN11 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2011 09:27:27 -0400
Message-ID: <ef656b6325ca0b3c65337f7480f834f0.squirrel@webmail.xs4all.nl>
In-Reply-To: <4DE636C5.7040604@redhat.com>
References: <201105231315.29328.hverkuil@xs4all.nl>
    <4DE636C5.7040604@redhat.com>
Date: Wed, 1 Jun 2011 15:27:20 +0200
Subject: Re: [GIT PATCHES FOR 2.6.41] Add bitmask controls
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
Cc: "linux-media" <linux-media@vger.kernel.org>,
	"Sakari Ailus" <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> Hi Hans,
>
> Em 23-05-2011 08:15, Hans Verkuil escreveu:
>> Hi Mauro,
>>
>> These patches for 2.6.41 add support for bitmask controls, needed for
>> the
>> upcoming Flash API and HDMI API.
>
> DocBook changes need do a s/2.6.41/3.1/.

Of course, I saw your DocBook changes going today.

> That's said, I'm not sure if it is a good idea to add bitmask type,
> instead of
> just using a set of boolean controls.

There are currently two use cases: Sakari's flash controller needs to
report errors which are a bitmask of possible error conditions. It is way
overkill to split that up in separate boolean controls, especially since
apps will also want to get an event whenever such an error is raised.

The other is in HDMI receivers where there can be multiple ports that do
EDID handling, but only one can stream. You need a way to tell which ports
received an EDID for example. Again, you can make multiple boolean
controls like HDMI_PORT0_EDID_REC, PORT1, PORT2, PORT3, etc. but that is a
waste of code and time.

> One of the issues with bitmasks is
> the
> endness type: LE, BE or machine endianness. The specs don't mention how
> this
> is supposed to work.

Good point. It's machine endianness, but that definitely has to be
documented. I'll do that.

> Also, I'd like to see a patch like that submitting with a driver or
> feature
> that needs it. Before you ask: no, vivi doesn't count ;)

Sakari will hopefully be the first 'real' user for this for a flash driver.

Regards,

        Hans

>
>> Sakari, can you give your ack as well?
>>
>> The patch is the same as the original one posted April 4, except for a
>> small
>> change in the control logging based on feedback from Laurent and the new
>> DocBook documentation.
>
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


