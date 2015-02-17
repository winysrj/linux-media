Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:41499 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752944AbbBQMYL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 07:24:11 -0500
Message-ID: <54E332C5.6080503@xs4all.nl>
Date: Tue, 17 Feb 2015 13:23:33 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Antti Palosaari <crope@iki.fi>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media/v4l2-ctrls: Always run s_ctrl on volatile ctrls
References: <1424170934-18619-1-git-send-email-ricardo.ribalda@gmail.com> <54E32E11.9060004@xs4all.nl> <CAPybu_3EJo0imtPoM3WJbjn2nNjf=D3WnJmmdpLQ3_qzo5oXvA@mail.gmail.com>
In-Reply-To: <CAPybu_3EJo0imtPoM3WJbjn2nNjf=D3WnJmmdpLQ3_qzo5oXvA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/17/15 13:21, Ricardo Ribalda Delgado wrote:
> Hello Hans
> 
> On Tue, Feb 17, 2015 at 1:03 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Should be done after the 'ctrl == NULL' check.
> 
> Good catch. Fixed on v2
> 
>>
>>>
>>>               if (ctrl == NULL)
>>>                       continue;
>>>
>>
>> There is one more change that has to be made: setting a volatile control
>> should never generate a V4L2_EVENT_CTRL_CH_VALUE event since that makes
>> no sense. The way to prevent that is to ensure that ctrl->has_changed is
>> always false for volatile controls. The new_to_cur function looks at that
>> field to decide whether to send an event.
>>
>> The documentation should also be updated: that of V4L2_CTRL_FLAG_VOLATILE
>> (in VIDIOC_QUERYCTRL), and of V4L2_EVENT_CTRL_CH_VALUE.
> 
> I can do this also if you want. It has been a while without
> contributing to media :)

Yes, please. I can't accept the patch without these other changes anyway :-)

Regards,

	Hans
