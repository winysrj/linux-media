Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:34676 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbbHSNYz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2015 09:24:55 -0400
Received: by lbbtg9 with SMTP id tg9so3150802lbb.1
        for <linux-media@vger.kernel.org>; Wed, 19 Aug 2015 06:24:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPybu_1ZJN4VS59-Hgq2BnU58O7R7g7kGJCqqWM=e99JJA5P=Q@mail.gmail.com>
References: <1434127598-11719-1-git-send-email-ricardo.ribalda@gmail.com>
 <1434127598-11719-3-git-send-email-ricardo.ribalda@gmail.com>
 <55ACF994.3010101@xs4all.nl> <CAPybu_2a+z6ZVY=-ZXE6Usmoe0nsLjUzw3AE5=K9vQ6OCDgKaw@mail.gmail.com>
 <55AD063A.1030705@xs4all.nl> <CAPybu_1ZJN4VS59-Hgq2BnU58O7R7g7kGJCqqWM=e99JJA5P=Q@mail.gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 19 Aug 2015 15:24:33 +0200
Message-ID: <CAPybu_3boPr+GecGA_BKJcWQU+QLPxhSmjpYp+JPhFsRXHZNEw@mail.gmail.com>
Subject: Re: [RFC v3 02/19] media/v4l2-core: add new ioctl VIDIOC_G_DEF_EXT_CTRLS
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ping?

On Mon, Aug 10, 2015 at 2:04 PM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:
> Hello Hans, Sakari and Laurent:
>
> I am back from holidays :). Shall I prepare a new patchset with the
> suggestion from Hans?
>
> Thanks!
>
> On Mon, Jul 20, 2015 at 4:31 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 07/20/2015 03:52 PM, Ricardo Ribalda Delgado wrote:
>>> Hello
>>>
>>> I have no preference over the two implementations, but I see an issue
>>> with this suggestion.
>>>
>>>
>>> What happens to out out tree drivers, or drivers that don't support
>>> this functionality?
>>>
>>> With the ioctl, the user receives a -ENOTTY. So he knows there is
>>> something wrong with the driver.
>>>
>>> With this class, the driver might interpret this a simple G_VAL and
>>> return he current value with no way for the user to know what is going
>>> on.
>>
>> Drivers that implement the current API correctly will return an error
>> if V4L2_CTRL_WHICH_DEF_VAL was specified. Such drivers will interpret
>> the value as a control class, and no control classes in that range exist.
>> See also class_check() in v4l2-ctrls.c.
>>
>> The exception here is uvc which doesn't have this class check and it will
>> just return the current value :-(
>>
>> I don't see a way around this, unfortunately.
>>
>> Out-of-tree drivers that use the control framework are fine, and I don't
>> really care about drivers (out-of-tree or otherwise) that do not use the
>> control framework.
>>
>>> Regarding the new implementation.... I can make some code next week,
>>> this week I am 120% busy :)
>>
>> Wait until there is a decision first :-)
>>
>> It's not a lot of work, I think.
>>
>> Regards,
>>
>>         Hans
>>
>>> What do you think?
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>
>
>
> --
> Ricardo Ribalda



-- 
Ricardo Ribalda
