Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:38797 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbbBQMVq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 07:21:46 -0500
MIME-Version: 1.0
In-Reply-To: <54E32E11.9060004@xs4all.nl>
References: <1424170934-18619-1-git-send-email-ricardo.ribalda@gmail.com> <54E32E11.9060004@xs4all.nl>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 17 Feb 2015 13:21:24 +0100
Message-ID: <CAPybu_3EJo0imtPoM3WJbjn2nNjf=D3WnJmmdpLQ3_qzo5oXvA@mail.gmail.com>
Subject: Re: [PATCH] media/v4l2-ctrls: Always run s_ctrl on volatile ctrls
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Antti Palosaari <crope@iki.fi>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans

On Tue, Feb 17, 2015 at 1:03 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Should be done after the 'ctrl == NULL' check.

Good catch. Fixed on v2

>
>>
>>               if (ctrl == NULL)
>>                       continue;
>>
>
> There is one more change that has to be made: setting a volatile control
> should never generate a V4L2_EVENT_CTRL_CH_VALUE event since that makes
> no sense. The way to prevent that is to ensure that ctrl->has_changed is
> always false for volatile controls. The new_to_cur function looks at that
> field to decide whether to send an event.
>
> The documentation should also be updated: that of V4L2_CTRL_FLAG_VOLATILE
> (in VIDIOC_QUERYCTRL), and of V4L2_EVENT_CTRL_CH_VALUE.

I can do this also if you want. It has been a while without
contributing to media :)

Regards!

>
> Regards,
>
>         Hans



-- 
Ricardo Ribalda
