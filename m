Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:44606 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbbBQL3W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 06:29:22 -0500
MIME-Version: 1.0
In-Reply-To: <54E32358.8010303@cisco.com>
References: <1424170934-18619-1-git-send-email-ricardo.ribalda@gmail.com> <54E32358.8010303@cisco.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 17 Feb 2015 12:29:00 +0100
Message-ID: <CAPybu_2123XLneiCHmz8F-xe=-ettbfQJh2X89x4tefCCjztnA@mail.gmail.com>
Subject: Re: [PATCH] media/v4l2-ctrls: Always run s_ctrl on volatile ctrls
To: Hans Verkuil <hansverk@cisco.com>
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

I need to figure out how can you  reply that fast. Thanks a lot!

On Tue, Feb 17, 2015 at 12:17 PM, Hans Verkuil <hansverk@cisco.com> wrote:
>> I have a control that tells the user when there has been a external trigger
>> overrun. (Trigger while processing old image). This is a volatile control.
>
> Does the application just read the control to check whether the trigger happened?
> Or is the control perhaps changed by an interrupt handler?

The control exposes a bit on the trigger system. The application polls
it at its own rate.
I could convince the hardware engineer to make an inq on that event,
but right now the
hw does not support it.

>
>> The user writes 0 to the control, to ack the error condition, and clear the
>> hardware flag.
>
> Would it be an idea to automatically ack the error condition when reading the
> control?

There might be two applications running at the same time.

ie: APP1 calibrates the camera, while APP2 gets images.
APP1 will ack the error and APP2 will never notice, when is APP2 the
one that cares abot the error.


>
> Or, alternatively, have a separate button control to clear the condition.
>

Of course this is an option, but I think this is not very clean.

>> I know I am abusing a bit the API for this :P, but I also believe that the
>> semantic here is a bit confusing.
>
> The reason for that is that I have yet to see a convincing argument for
> allowing s_ctrl for a volatile control.

This kind of error flags could be a nice candidate for this control.

Right now we can create a volatile control with s_ctrl, the api allows
it, so I think it is either
not allowing that or adding this patch.

 Both are perfectly fine :), but allowing s_ctrl and volatile and then
now running s_ctrl always
seems a bit weird to me.

Thanks!



-- 
Ricardo Ribalda
