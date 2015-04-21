Return-Path: <ricardo.ribalda@gmail.com>
MIME-version: 1.0
In-reply-to: <1532862.VB4B3JqLyH@avalon>
References: <1426858247-25746-1-git-send-email-ricardo.ribalda@gmail.com>
 <1532862.VB4B3JqLyH@avalon>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 21 Apr 2015 23:32:18 +0200
Message-id: <CAPybu_3WsYyRxcn0mxG=h3tOVXmxOT8Hm5Md07jE3mbF88HsWg@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] media/v4l2-ctrls: volatiles should not generate
 CH_VALUE
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Arun Kumar K <arun.kk@samsung.com>,
 Sylwester Nawrocki <s.nawrocki@samsung.com>, Antti Palosaari <crope@iki.fi>,
 linux-media <linux-media@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>,
 Sakari Ailus <sakari.ailus@linux.intel.com>
Content-type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>

Hello Laurent

On Tue, Apr 21, 2015 at 7:44 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Ricardo,
>
> Thank you for the patch, and sorry for the late review (so late that the patch
> has already been merged).

No worries.

>
> On Friday 20 March 2015 14:30:46 Ricardo Ribalda Delgado wrote:
>> Volatile controls should not generate CH_VALUE events.
>
> What's the rationale for that ? I would actually expect the value change
> events to be more useful for volatile controls than non-volatile controls.
> Volatile controls can have their value changed by the hardware without
> software intervention, and it makes sense to me to report that to userspace.

Imagine a temperature register on the sensor. It is changing
constantly, resolution 10 milidegrees:

Do you want to get an event for every change? Who will poll the
temperature? The driver? The hardware will irq the driver....?

So I guess the less wrong solution is not throwing the ch_value event.

This is just my two cents, probably Hans has a much better global view :)

Regards.
