Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:38523 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750852AbeBDNQb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 4 Feb 2018 08:16:31 -0500
Subject: Re: MEDIA_IOC_G_TOPOLOGY and pad indices
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <336b3d54-6c59-d6eb-8fd8-e0a9677c7f5f@xs4all.nl>
 <2979437.fEFkWIelBg@avalon>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <7773f8ac-32b8-4199-4b4c-05657dd0bb37@xs4all.nl>
Date: Sun, 4 Feb 2018 14:16:26 +0100
MIME-Version: 1.0
In-Reply-To: <2979437.fEFkWIelBg@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/04/2018 02:13 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Sunday, 4 February 2018 15:06:42 EET Hans Verkuil wrote:
>> Hi Mauro,
>>
>> I'm working on adding proper compliance tests for the MC but I think
>> something is missing in the G_TOPOLOGY ioctl w.r.t. pads.
>>
>> In several v4l-subdev ioctls you need to pass the pad. There the pad is an
>> index for the corresponding entity. I.e. an entity has 3 pads, so the pad
>> argument is [0-2].
>>
>> The G_TOPOLOGY ioctl returns a pad ID, which is > 0x01000000. I can't use
>> that in the v4l-subdev ioctls, so how do I translate that to a pad index in
>> my application?
>>
>> It seems to be a missing feature in the API. I assume this information is
>> available in the core, so then I would add a field to struct media_v2_pad
>> with the pad index for the entity.
>>
>> Next time we add new public API features I want to see compliance tests
>> before accepting it. It's much too easy to overlook something, either in
>> the design or in a driver or in the documentation, so this is really,
>> really needed IMHO.
> 
> I agree with you, and would even like to go one step beyond by requiring an 
> implementation in a real use case, not just in a compliance or test tool.
> 
> On the topic of the G_TOPOLOGY API, it's pretty clear it was merged too 
> hastily. We could try to fix it, but given all the issues we haven't solved 
> yet, I believe a new version of the API would be better.
> 

It's actually not too bad as an API speaking as an end-user. It's simple and
efficient. But this pad issue is a real problem.

Regards,

	Hans
