Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:65062 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaLQGqB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Dec 2014 01:46:01 -0500
Received: by mail-oi0-f44.google.com with SMTP id e131so10715682oig.17
        for <linux-media@vger.kernel.org>; Tue, 16 Dec 2014 22:46:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1417686899-30149-1-git-send-email-hverkuil@xs4all.nl>
References: <1417686899-30149-1-git-send-email-hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 17 Dec 2014 12:15:30 +0530
Message-ID: <CA+V-a8uOMt3aszJXnjXmgHjZAEveAxR+7POz5grj_JAUVqRvqQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/8] Removing duplicate video/pad ops
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	laurent pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 4, 2014 at 3:24 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> This patch series attempts to remove some of the duplicate video/pad ops.
> The first two patches have been posted before. The only thing changed is
> that the subdevs no longer add checks for pad values != 0 as suggested.
>
> The third patch removes an unused subdev op. Somehow we must have missed
> that one.
>
> The fourth replaces v4l2_subdev_fh by v4l2_subdev_pad_config. No other
> changes other than that. This patch paves the way for bridge drivers to
> call pad ops that need v4l2_subdev_pad_config since bridge drivers do
> not have a v4l2_subdev_fh struct.
>
> The fifth patch is a small Kconfig cleanup.
>
> The sixth patch causes v4l2_device_register_subdev() to initialize a
> v4l2_subdev_pad_config array for use in bridge drivers. Bridge drivers
> can then use sd->pad_configs as argument to the pad ops. It's done
> behind the scenes, so this requires no driver changes.
>
> One disadvantage, though: bridge drivers that never call those pad ops
> since they expect that userspace will call them are now allocating memory
> for this when they will never need it.
>
> Should I add a V4L2_FL_DONT_CREATE_PAD_CONFIGS flag that such drivers
> can set, prohibiting allocating this memory?
>
> Is the code I use to initialize the pad_configs correct? Is it something
> that subdev_fh_init() in v4l2-subdev.c should do as well?
>
> The seventh patch removes the video enum_framesizes/intervals ops.
>
> The last patch removes the video g/s_crop and cropcap ops. This especially
> affects soc_camera. Note that I only tested if it compiles, I have not
> tried this on my soc_camera board. I will try to get my renesas board up
> and running with this kernel to test it but more help with this would
> be much appreciated.
>
FYI, I am on a holiday and out of reach of the hardware, will test it once I get
from holiday after Christmas.

Thanks,
--Prabhakar Lad
