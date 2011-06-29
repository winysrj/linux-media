Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2134 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab1F2KG6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 06:06:58 -0400
Message-ID: <3a51f8dd0eaf0a5f8e3a86c1500648d3.squirrel@webmail.xs4all.nl>
In-Reply-To: <201106291157.02631.laurent.pinchart@ideasonboard.com>
References: <201106281718.07158.hverkuil@xs4all.nl>
    <201106291157.02631.laurent.pinchart@ideasonboard.com>
Date: Wed, 29 Jun 2011 12:06:57 +0200
Subject: Re: [RFC PATCH] Add support for V4L2_EVENT_SUB_FL_NO_FEEDBACK
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: "linux-media" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> Hi Hans,
>
> On Tuesday 28 June 2011 17:18:07 Hans Verkuil wrote:
>> Originally no control events would go to the filehandle that called the
>> VIDIOC_S_CTRL/VIDIOC_S_EXT_CTRLS ioctls. This was to prevent a feedback
>> loop.
>>
>> This is now only done if the new V4L2_EVENT_SUB_FL_NO_FEEDBACK flag is
>> set.
>
> What about doing it the other way around ? Most applications won't want
> that
> feedback, you could disable it by default.

I thought about that, but that's harder to explain since that flag would
then suppress an exception to the normal handling of event.

It's easier to say: events are sent to everyone, but if you set this flag,
then we make this exception.

I suspect that most applications do not need to set this flag anyway, only
applications like qv4l2 that create a control panel need it.

Regards,

       Hans

