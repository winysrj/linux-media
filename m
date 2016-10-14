Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33108 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932322AbcJNRHd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:07:33 -0400
Received: by mail-wm0-f68.google.com with SMTP id 191so625572wmr.0
        for <linux-media@vger.kernel.org>; Fri, 14 Oct 2016 10:06:51 -0700 (PDT)
Subject: Re: [PATCH 02/22] [media] v4l2-async: allow subdevices to add further
 subdevices to the notifier waiting list
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Sakari Ailus <sakari.ailus@iki.fi>
References: <20161007160107.5074-1-p.zabel@pengutronix.de>
 <20161007160107.5074-3-p.zabel@pengutronix.de>
 <20161007224321.GC9460@valkosipuli.retiisi.org.uk>
 <1476460116.11834.42.camel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@pengutronix.de
From: Ian Arkver <ian.arkver.dev@gmail.com>
Message-ID: <01c2f0df-6485-9427-c25f-69ac447653d8@gmail.com>
Date: Fri, 14 Oct 2016 18:06:48 +0100
MIME-Version: 1.0
In-Reply-To: <1476460116.11834.42.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 14/10/16 16:48, Philipp Zabel wrote:
> Am Samstag, den 08.10.2016, 01:43 +0300 schrieb Sakari Ailus:
> [...]
> [...]
>>> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
>>> index 8e2a236..e4e4b11 100644
>>> --- a/include/media/v4l2-async.h
>>> +++ b/include/media/v4l2-async.h
>>> @@ -114,6 +114,18 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>>>   				 struct v4l2_async_notifier *notifier);
>>>   
>>>   /**
>>> + * __v4l2_async_notifier_add_subdev - adds a subdevice to the notifier waitlist
>>> + *
>>> + * @v4l2_notifier: notifier the calling subdev is bound to
>> s/v4l2_//
> I'd be happy to, but why should the v4l2 prefix be removed?
>
> regards
> Philipp
I think Sakari is just pointing out that the comment doesn't match the 
function argument name.

Regards,
Ian
