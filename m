Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f177.google.com ([209.85.208.177]:43573 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727720AbeIMQiL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 12:38:11 -0400
Received: by mail-lj1-f177.google.com with SMTP id m84-v6so4288070lje.10
        for <linux-media@vger.kernel.org>; Thu, 13 Sep 2018 04:29:08 -0700 (PDT)
To: linux-media@vger.kernel.org
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Subject: Number of planes from fourcc code
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2ec0725b-f6cb-6afe-a836-4709fe7f363c@gmail.com>
Date: Thu, 13 Sep 2018 14:29:04 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, all!

Is there a way in V4L2 to get number of planes from fourcc code

or specifically I need number of planes for a given pixel format

expressed as V4L2_PIX_FMT_* value.

I know that DRM has such a helper [1], but I am not quite sure

if I can call it with V4L2_PIX_FMT_* as argument to get what I need.

I am a bit confused here because there are different definitions

for DRM [2] and V4L2 [3].

Thank you,

Oleksandr

[1] 
https://elixir.bootlin.com/linux/v4.19-rc3/source/drivers/gpu/drm/drm_fourcc.c#L199

[2] 
https://elixir.bootlin.com/linux/v4.19-rc3/source/include/uapi/drm/drm_fourcc.h

[3] 
https://elixir.bootlin.com/linux/v4.19-rc3/source/include/uapi/linux/videodev2.h
