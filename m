Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:41067 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752317AbeBELie (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 06:38:34 -0500
Subject: Re: MEDIA_IOC_G_TOPOLOGY and pad indices
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <336b3d54-6c59-d6eb-8fd8-e0a9677c7f5f@xs4all.nl>
 <20180205085130.2b48dcd4@vento.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <09719881-31dc-b5c4-2fd4-5baed30806f8@xs4all.nl>
Date: Mon, 5 Feb 2018 12:38:29 +0100
MIME-Version: 1.0
In-Reply-To: <20180205085130.2b48dcd4@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/05/2018 12:15 PM, Mauro Carvalho Chehab wrote:
> Hi Hans,
> 
> Em Sun, 4 Feb 2018 14:06:42 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> Hi Mauro,
>>
>> I'm working on adding proper compliance tests for the MC but I think something
>> is missing in the G_TOPOLOGY ioctl w.r.t. pads.
>>
>> In several v4l-subdev ioctls you need to pass the pad. There the pad is an index
>> for the corresponding entity. I.e. an entity has 3 pads, so the pad argument is
>> [0-2].
>>
>> The G_TOPOLOGY ioctl returns a pad ID, which is > 0x01000000. I can't use that
>> in the v4l-subdev ioctls, so how do I translate that to a pad index in my application?
>>
>> It seems to be a missing feature in the API. I assume this information is available
>> in the core, so then I would add a field to struct media_v2_pad with the pad index
>> for the entity.
> 
> No, this was designed this way by purpose, back in 2015, when this was
> discussed at the first MC workshop. It was a consensus on that time that
> parameters like PAD index, PAD name, etc should be implemented via the
> properties API, as proposed by Sakari [1]. We also had a few discussions 
> about that on both IRC and ML.

I'll read up on this and reply to this later.

<snip>

>> Next time we add new public API features I want to see compliance tests before
>> accepting it. It's much too easy to overlook something, either in the design or
>> in a driver or in the documentation, so this is really, really needed IMHO.
> 
> We added a test tool for G_TOPOLOGY on that time.
> 
> I doubt that writing test/compliance tools in advance will solve all API
> gaps. The thing is that new features will take some time to be used on
> real apps. Some things are only visible when real apps start using the
> new API features.

This is no excuse whatsoever NOT to write compliance tests. Sure, they will
never find everything, but for sure they find a LOT! Especially all the
little stupid things that can make something unusable for certain use-cases.

And equally important, driver developers can use it to check that they didn't
forget anything.

A media-ctl/v4l2-ctl/whatever utility is no substitute for proper compliance
testing. The media API is complex because video is complex. It is impossible
to review code and catch all the little mistakes, but compliance tests can
go far in verifying driver code and also catching core code regressions.

I have yet to see a new driver that didn't fail at least one v4l2-compliance
test, and I very much doubt that existing subdev/media drivers would do any
different.

It would be very interesting if you would test it as well on DVB devices.
You should be able to run v4l2-compliance on the media device. There may
well be bugs in the tests for DVB devices. But that might also be caused
by incomplete documentation in the spec.

Regards,

	Hans
