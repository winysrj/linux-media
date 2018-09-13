Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:49890 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726886AbeIMQzM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 12:55:12 -0400
Subject: Re: Number of planes from fourcc code
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        linux-media@vger.kernel.org
References: <2ec0725b-f6cb-6afe-a836-4709fe7f363c@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ce7562ef-d165-aa13-b288-b88ce8367361@xs4all.nl>
Date: Thu, 13 Sep 2018 13:46:01 +0200
MIME-Version: 1.0
In-Reply-To: <2ec0725b-f6cb-6afe-a836-4709fe7f363c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/13/18 13:29, Oleksandr Andrushchenko wrote:
> Hi, all!
> 
> Is there a way in V4L2 to get number of planes from fourcc code
> 
> or specifically I need number of planes for a given pixel format
> 
> expressed as V4L2_PIX_FMT_* value.

Sadly not. It's part of the documentation for the formats, but there
is no naming scheme through which you can deduce this or even helper
functions for it.

I think the main reason why this never happened is that drivers tend to
have custom code for this anyway.

I have proposed in the past that some of this information is exposed
via VIDIOC_ENUM_FMT, but it never got traction.

> I know that DRM has such a helper [1], but I am not quite sure
> 
> if I can call it with V4L2_PIX_FMT_* as argument to get what I need.
> 
> I am a bit confused here because there are different definitions
> 
> for DRM [2] and V4L2 [3].

I know. Each subsystem has traditionally been assigning fourccs independently.
In all fairness, this seems to be the case for fourccs throughout the whole
industry.

Regards,

	Hans

> 
> Thank you,
> 
> Oleksandr
> 
> [1] 
> https://elixir.bootlin.com/linux/v4.19-rc3/source/drivers/gpu/drm/drm_fourcc.c#L199
> 
> [2] 
> https://elixir.bootlin.com/linux/v4.19-rc3/source/include/uapi/drm/drm_fourcc.h
> 
> [3] 
> https://elixir.bootlin.com/linux/v4.19-rc3/source/include/uapi/linux/videodev2.h
> 
