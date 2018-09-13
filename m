Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42565 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbeIMRJu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 13:09:50 -0400
Received: by mail-lf1-f67.google.com with SMTP id z11-v6so4536494lff.9
        for <linux-media@vger.kernel.org>; Thu, 13 Sep 2018 05:00:40 -0700 (PDT)
Subject: Re: Number of planes from fourcc code
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <2ec0725b-f6cb-6afe-a836-4709fe7f363c@gmail.com>
 <ce7562ef-d165-aa13-b288-b88ce8367361@xs4all.nl>
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <0a3d6661-cda6-1d2a-952a-84a269a5b5a9@gmail.com>
Date: Thu, 13 Sep 2018 15:00:37 +0300
MIME-Version: 1.0
In-Reply-To: <ce7562ef-d165-aa13-b288-b88ce8367361@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/13/2018 02:46 PM, Hans Verkuil wrote:
> On 09/13/18 13:29, Oleksandr Andrushchenko wrote:
>> Hi, all!
>>
>> Is there a way in V4L2 to get number of planes from fourcc code
>>
>> or specifically I need number of planes for a given pixel format
>>
>> expressed as V4L2_PIX_FMT_* value.
> Sadly not. It's part of the documentation for the formats, but there
> is no naming scheme through which you can deduce this or even helper
> functions for it.
Ok, then I'll probably try to explain what I want to do:
I am implementing a Xen frontend driver which implements
a para-virtual camera protocol [1] which can support
multiple pixel formats. Thus, the driver will support
both single and multi plane formats. For that I need to implement
both single and multi plane format enumerators:
     .vidioc_enum_fmt_vid_cap
     .vidioc_enum_fmt_vid_cap_mplane

and for .vidioc_enum_fmt_vid_cap I have to filter out of supported
pixel formats those which are multi-planar. So, I hoped I can
use some helper (like DRM provides) to get number of planes for
a given pixel format.

So, it seems that I'll have to code similar table as DRM does
for various V4L2 encoded pixel formats to get num_planes...
>
> I think the main reason why this never happened is that drivers tend to
> have custom code for this anyway.
>
> I have proposed in the past that some of this information is exposed
> via VIDIOC_ENUM_FMT, but it never got traction.
>
>> I know that DRM has such a helper [1], but I am not quite sure
>>
>> if I can call it with V4L2_PIX_FMT_* as argument to get what I need.
>>
>> I am a bit confused here because there are different definitions
>>
>> for DRM [2] and V4L2 [3].
> I know. Each subsystem has traditionally been assigning fourccs independently.
> In all fairness, this seems to be the case for fourccs throughout the whole
> industry.
>
> Regards,
>
> 	Hans
>
>> Thank you,
>>
>> Oleksandr
>>
>> [1]
>> https://elixir.bootlin.com/linux/v4.19-rc3/source/drivers/gpu/drm/drm_fourcc.c#L199
>>
>> [2]
>> https://elixir.bootlin.com/linux/v4.19-rc3/source/include/uapi/drm/drm_fourcc.h
>>
>> [3]
>> https://elixir.bootlin.com/linux/v4.19-rc3/source/include/uapi/linux/videodev2.h
>>
[1] https://patchwork.kernel.org/patch/10595259/
