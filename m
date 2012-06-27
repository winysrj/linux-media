Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:32884 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941Ab2F0KOe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 06:14:34 -0400
Received: by obbuo13 with SMTP id uo13so1265681obb.19
        for <linux-media@vger.kernel.org>; Wed, 27 Jun 2012 03:14:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201206271155.17164.hverkuil@xs4all.nl>
References: <CAHG8p1DaJPWwSxmMqk6Jkx8JO8m69OuTYpwHvhsB54e8RAMRVA@mail.gmail.com>
	<201206271155.17164.hverkuil@xs4all.nl>
Date: Wed, 27 Jun 2012 18:14:34 +0800
Message-ID: <CAHG8p1CM6JNRn4o+Zt2sauMZ0kVCq9UY7U8MYajnZQXpoe=b1w@mail.gmail.com>
Subject: Re: About s_std_output
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/6/27 Hans Verkuil <hverkuil@xs4all.nl>:
> On Wed 27 June 2012 11:37:24 Scott Jiang wrote:
>> Hi Hans,
>>
>> I noticed there are two s_std ops in core and video for output. And
>> some drivers call video->s_std_out and then core->s_std in their S_STD
>> iotcl. Could anyone share me the story why we have
>> s_std_output/g_std_output/g_tvnorms_output ops in video instead of
>> making use of s_std/g_std in core?
>
> The core class is for common, often used ops. Setting the standard for
> capture devices is very common, so it is in core. Setting the standard
> for output devices is much less common (there aren't that many output
> devices in the kernel), so that stayed in the video class.
>
My question is why we can't reuse s_std/g_std for output device. We
use same VIDIOC_S_STD/VIDIOC_G_STD ioctl for both input and output.

> It is a bit arbitrary and I am not sure whether I would make the same
> choice now.
>
So I should ignore s_std/g_std  and use s_std_output/g_std_output in
encoder driver, right?

> There is no g_tvnorms_output, BTW.
>
It really exists.
struct v4l2_subdev_video_ops {
        int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32
output, u32 config);
        int (*s_crystal_freq)(struct v4l2_subdev *sd, u32 freq, u32 flags);
        int (*s_std_output)(struct v4l2_subdev *sd, v4l2_std_id std);
        int (*g_std_output)(struct v4l2_subdev *sd, v4l2_std_id *std);
        int (*querystd)(struct v4l2_subdev *sd, v4l2_std_id *std);
        int (*g_tvnorms_output)(struct v4l2_subdev *sd, v4l2_std_id *std);
