Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1805 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228AbaJ2KBt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Oct 2014 06:01:49 -0400
Message-ID: <5450BAF4.6050008@xs4all.nl>
Date: Wed, 29 Oct 2014 11:01:24 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Divneil Wadhawan <divneil.wadhawan@st.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] vb2: replace VIDEO_MAX_FRAME with VB2_MAX_FRAME
References: <5437932A.7000706@xs4all.nl>	<20141028162647.43c1946a@recife.lan>	<54509744.7090005@xs4all.nl>	<20141029062952.05e47989@recife.lan>	<5450AC8C.4090603@xs4all.nl> <20141029071312.08aef860@recife.lan>
In-Reply-To: <20141029071312.08aef860@recife.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/29/14 10:13, Mauro Carvalho Chehab wrote:
> Em Wed, 29 Oct 2014 09:59:56 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 10/29/14 09:29, Mauro Carvalho Chehab wrote:
>>> Em Wed, 29 Oct 2014 08:29:08 +0100
>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>
>>>> On 10/28/2014 07:26 PM, Mauro Carvalho Chehab wrote:
>>>>> Em Fri, 10 Oct 2014 10:04:58 +0200
>>>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>>>
>>>>>> (This patch is from Divneil except for the vivid changes which I added. He had
>>>>>> difficulties posting the patch without the mailer mangling it, so I'm reposting
>>>>>> it for him)
>>>>>>
>>>>>> - vb2 drivers to rely on VB2_MAX_FRAME.
>>>>>>
>>>>>> - VB2_MAX_FRAME bumps the value to 64 from current 32
>>>>>
>>>>> Hmm... what's the point of announcing a maximum of 32 buffers to userspace,
>>>>> but using internally 64?
>>>>
>>>> Where do we announce 32 buffers?
>>>
>>> VIDEO_MAX_FRAME is defined at videodev2.h:
>>>
>>> include/uapi/linux/videodev2.h:#define VIDEO_MAX_FRAME               32
>>>
>>> So, it is part of userspace API. Yeah, I know, it sucks, but apps
>>> may be using it to limit the max number of buffers.
>>
>> So? Userspace is free to ask for 32 buffers, and it will get 32 buffers if
>> memory allows. vb2 won't be returning more than 32, so I don't see how things
>> can break.
> 
> Well, VIDEO_MAX_FRAME has nothing to do with the max VB1 support. It is
> the maximum number of buffers supported by V4L2. Properly-written apps
> will never request more than 32 buffers, because we're telling them that
> this is not supported.
> 
> So, it makes no sense to change internally to 64, but keeping announcing
> that the maximum is 32. We're just wasting memory inside the Kernel with
> no reason.

Hmm, so you think VIDEO_MAX_FRAME should just be updated to 64?

I am a bit afraid that that might break applications (especially if there
are any that use bits in a 32-bit unsigned variable). Should userspace
know about this at all? I think that the maximum number of frames is
driver dependent, and in fact one of the future vb2 improvements would be
to stop hardcoding this and leave the maximum up to the driver.

Basically I would like to deprecate VIDEO_MAX_FRAME.

Regards,

	Hans
