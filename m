Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:43461 "EHLO butterbrot.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752291AbeBEVgy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 16:36:54 -0500
Date: Mon, 5 Feb 2018 22:36:53 +0100 (CET)
From: Florian Echtler <floe@butterbrot.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org,
        modin@yuri.at
Subject: Re: [PATCH 4/5] add V4L2 control functions
In-Reply-To: <4835be2b-238c-bb27-e9e5-98642ae76733@xs4all.nl>
Message-ID: <alpine.DEB.2.10.1802052234090.18874@butterbrot>
References: <1517840981-12280-1-git-send-email-floe@butterbrot.org> <1517840981-12280-5-git-send-email-floe@butterbrot.org> <4835be2b-238c-bb27-e9e5-98642ae76733@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

On Mon, 5 Feb 2018, Hans Verkuil wrote:
> On 02/05/2018 03:29 PM, Florian Echtler wrote:
>> +
>> +static int sur40_vidioc_queryctrl(struct file *file, void *fh,
>> +			       struct v4l2_queryctrl *qc)
>
> Sorry, but this is very wrong. Use the control framework instead. See
> https://hverkuil.home.xs4all.nl/spec/kapi/v4l2-controls.html and pretty much all
> media drivers (with the exception of uvc). See for example this driver:
> drivers/media/pci/tw68/tw68-video.c (randomly chosen).
>
> It actually makes life a lot easier for you as you don't have to perform any
> range checks and all control ioctls are automatically supported for you.

thanks for the quick reply, I wasn't aware of that framework at all :-) 
Will certainly use it.

What's the earliest kernel version this is supported on, in case we want 
to backport this for our standalone module, too?

Best regards, Florian
-- 
"_Nothing_ brightens up my morning. Coffee simply provides a shade of
grey just above the pitch-black of the infinite depths of the _abyss_."
