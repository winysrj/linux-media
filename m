Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:39545 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbaLAJfh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 04:35:37 -0500
Message-id: <547C3664.9090806@samsung.com>
Date: Mon, 01 Dec 2014 10:35:32 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
	b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH/RFC v8 04/14] v4l2-async: change custom.match callback
 argument type
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
 <1417166286-27685-5-git-send-email-j.anaszewski@samsung.com>
 <5063831.7WQadZaPHh@avalon>
In-reply-to: <5063831.7WQadZaPHh@avalon>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 11/29/2014 05:38 PM, Laurent Pinchart wrote:
> Hi Jacek,
>
> Thank you for the patch.
>
> On Friday 28 November 2014 10:17:56 Jacek Anaszewski wrote:
>> It is useful to have an access to the async sub-device
>> being matched, not only to the related struct device.
>> Change match callback argument from struct device
>> to struct v4l2_subdev. It will allow e.g. for matching
>> a sub-device by its "name" property.
>
> In principle I agree. However, we will need to reimplement v4l2-async based on
> the component (drivers/base/component.c) framework at some point. As the
> component framework is based on struct device, will it still be possible to
> match on subdev name in that case ? If not, we might need to try to find
> another approach to the issue.

There were reservations raised [1] concerning the way of matching
by name, as the labels are not guaranteed to be globally unique across
Device Tree. I admit, this issue has to be solved in a different way.
Especially in view of prospective transition to using
drivers/base/component.c

I propose to add a new structure:

struct v4l2_asd_match{
	bool (*match)(struct v4l2_async_subdev *, void *);
	void *priv;
}

and a function:
v4l2_async_register_subdev_with_match(struct v4l2_subdev *sd, struct 
v4l2_asd_match*).

This way we could pass DT sub-node related to a sub-led in a priv
field of v4l2_asd_match upon registration.

This is similar approach as in case of drivers/base/component.c.

Best Regards,
Jacek Anaszewski

[1] http://www.spinics.net/lists/linux-leds/msg02532.html
