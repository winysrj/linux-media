Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:55588 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752466AbeBEVkQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 16:40:16 -0500
Subject: Re: [PATCH 4/5] add V4L2 control functions
To: Florian Echtler <floe@butterbrot.org>
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org,
        modin@yuri.at
References: <1517840981-12280-1-git-send-email-floe@butterbrot.org>
 <1517840981-12280-5-git-send-email-floe@butterbrot.org>
 <4835be2b-238c-bb27-e9e5-98642ae76733@xs4all.nl>
 <alpine.DEB.2.10.1802052234090.18874@butterbrot>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a968db4a-bce8-423b-ccca-d9a613acec99@xs4all.nl>
Date: Mon, 5 Feb 2018 22:40:10 +0100
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1802052234090.18874@butterbrot>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/05/2018 10:36 PM, Florian Echtler wrote:
> Hello Hans,
> 
> On Mon, 5 Feb 2018, Hans Verkuil wrote:
>> On 02/05/2018 03:29 PM, Florian Echtler wrote:
>>> +
>>> +static int sur40_vidioc_queryctrl(struct file *file, void *fh,
>>> +			       struct v4l2_queryctrl *qc)
>>
>> Sorry, but this is very wrong. Use the control framework instead. See
>> https://hverkuil.home.xs4all.nl/spec/kapi/v4l2-controls.html and pretty much all
>> media drivers (with the exception of uvc). See for example this driver:
>> drivers/media/pci/tw68/tw68-video.c (randomly chosen).
>>
>> It actually makes life a lot easier for you as you don't have to perform any
>> range checks and all control ioctls are automatically supported for you.
> 
> thanks for the quick reply, I wasn't aware of that framework at all :-) 
> Will certainly use it.
> 
> What's the earliest kernel version this is supported on, in case we want 
> to backport this for our standalone module, too?

Initial commit was in August 2010, so it's been around for quite some time :-)

Regards,

	Hans
