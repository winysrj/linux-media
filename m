Return-path: <mchehab@pedra>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4491 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab1E3MxY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 May 2011 08:53:24 -0400
Message-ID: <bf5dd516b42805e8cb5ca0d66a4ed138.squirrel@webmail.xs4all.nl>
In-Reply-To: <4DE38872.9090501@section5.ch>
References: <4DE244F4.90203@section5.ch>
    <201105300932.59570.hverkuil@xs4all.nl> <4DE365A8.9050508@section5.ch>
    <322765c00a668d7915214de27d3debe7.squirrel@webmail.xs4all.nl>
    <4DE38872.9090501@section5.ch>
Date: Mon, 30 May 2011 14:53:17 +0200
Subject: Re: v4l2 device property framework in userspace
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Martin Strubel" <hackfin@section5.ch>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> Hi Hans,
>
>>
>> Can you give examples of the sort of things that are in those registers?
>> Is that XML file available somewhere? Are there public datasheets?
>>
>
> If you mean the sensor datasheets, many of them are buried behind NDAs,
> but people are writing opensourced headers too...let's leave this to the
> lawyers.
>
> Here's an example: http://section5.ch/downloads/mt9d111.xml
> The XSLT sheets to generate code from it are found in the netpp
> distribution, see http://www.section5.ch/netpp. You might have to read
> some of the documentation to get to the actual clues.

The XML is basically just a dump of all the sensor registers, right?

So you are not talking about 'properties', but about reading/setting
registers directly. That's something that we do not support (or even want
to support) except for debugging (see the VIDIOC_DBG_G/S_REGISTER ioctls
which require root access).

>> BTW, you should need just a single control handler that just looks up
>> all
>> the relevant information in a table.
>
> Right. It might be not too much work to write an appropriate XSLT for
> that. In fact, the netpp TOKENs (see it as a handle or proxy for a
> property) are 32 bit values, so they could be used to hold ioctl request
> codes. However, there are some enumeration/mapping (TOKEN -> Property)
> issues to be sorted out.
> In the standard implementation, a TOKEN is merely a mangled index, and
> we generate a table with elements like:
>
> 	{ "Enable" /* id250673 */,  DC_BOOL,
> 		F_RW,
> 		DC_VAR, { .varp_bool = &g_context.hist_enable },
> 		0 /* no children */ },
>
> So coding efforts could again be kept at a minimum (apart from the
> horror of writing an XSLT), but you'd fill some bytes with the above
> table data. For the kernel, the property names (the string) should be
> probably stripped and turned into ioctl request codes (?).
>
> For some utopia, it would be darn cool (for lazy people) if device
> vendors provided register information in XML and the kernel would just
> access them via generated property tables.

But this is not a driver. This is just a mapping of symbols to registers.
You are just moving the actual driver intelligence to userspace, making it
very hard to reuse. It's a no-go I'm afraid.

>> If V4L2 drivers want to go into the kernel, then it is highly unlikely
>> we
>> want to allow uio drivers. Such drivers cannot be reused. A typical
>> sensor
>> can be used by many vendors and products. By ensuring that access to the
>> sensor is standardized you ensure that anyone can use that sensor and
>> that
>> fixes/improvements to that sensor will benefit everyone.
>>
>> You don't have that with uio, and that's the reason we don't want it
>> (other reasons are possible abuse of uio allowing closed source drivers
>> being build on top of it).
>>
>
> Right. I'm aware that there's some discussion about pro/cons of uio, but
> I won't blame people for doing closed source drivers. Also, to bring
> back the above NDA topic, some vendors might be getting annoyed at
> source code containing their 'protected' register information. But let's
> keep this off topic for now.
>
> Anyhow, with the framework we use I don't see many problems in terms of
> reusability, because we generate most of the stuff.

As mentioned a list of registers does not make a driver. Someone has to do
the actual programming.

> So you would be free
> to put all sensor properties into a kernel module as well (provided,
> that the XML files are 'free'). But for our embedded stuff (or rapid
> prototyping), I'd still want to see "userspace", also for the reason to
> quickly add a new sensor device or property without the need to
> recompile the kernel
> This is BTW a big issue for some embedded linux device vendors.
> So my question is still up, if there's room for userspace handlers for
> kernel events (ioctl requests). Our current hack is, to read events from
> a char device and push them through netpp.

Well, no. The policy is to have kernel drivers and not userspace drivers.

It's not just technical reasons, but also social reasons: suppose you have
userspace drivers, who is going to maintain all those drivers? Ensure that
they remain in sync, that new features can be added, etc.? That whole
infrastructure already exists if you use kernel drivers.

Userspace drivers may be great in the short term and from the point of
view of a single company/user, but it's a lot less attractive in the long
term.

Anyway, using subdevices and judicious use of controls it really shouldn't
be that hard to create a kernel driver.

Regards,

        Hans

