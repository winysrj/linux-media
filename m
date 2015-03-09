Return-Path: <ricardo.ribalda@gmail.com>
MIME-version: 1.0
In-reply-to: <1805679.hlRzVeq61B@avalon>
References: <1424185706-16711-1-git-send-email-ricardo.ribalda@gmail.com>
 <54EAED82.5040804@xs4all.nl> <1805679.hlRzVeq61B@avalon>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 09 Mar 2015 17:45:19 +0100
Message-id: <CAPybu_0TWnPS2cXjmRysht8JFZMn0rPHtxoAqXikn57A4jv73g@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] media/v4l2-ctrls: Always run s_ctrl on volatile
 ctrls
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Hans Verkuil <hans.verkuil@cisco.com>,
 Sylwester Nawrocki <s.nawrocki@samsung.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>, Antti Palosaari <crope@iki.fi>,
 linux-media <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>

Hello

Back from holidays and back to this issue. Sorry for the delay.

> I'm not sure about Ricardo's use case, is it the one we've discussed on #v4l ?
> If so, and if I recall correctly, the idea was to perform an action with a
> parameter, and didn't require volatility.

In my case, there is a trigger overflow bit. The user acks the trigger
overflow by writting any value to the control.

There is no parameter. In that sense it looks like a volatile read + a
button on a controll.

> Your proposal is interesting as well, but I'm not sure about the
> V4L2_CTRL_FLAG_ACTION name. Aren't all controls supposed to have an action of
> some sort ? That's nitpicking of course.

What about the name STATELESS_WRITE ? or perhaps VOLATILE_WRITE? I
dont care about the name :), but better have it solved before I write
the doc :P

>
> Also, should the action flag be automatically set for button controls ? Button
> controls would in a way become type-less controls with the action flag set,
> that's interesting. I suppose type-less controls without the action flag don't
> make sense.

I agree!


Best regards and thanks!

-- 
Ricardo Ribalda
