Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42107 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab2IVQZW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Sep 2012 12:25:22 -0400
Received: by bkcjk13 with SMTP id jk13so213531bkc.19
        for <linux-media@vger.kernel.org>; Sat, 22 Sep 2012 09:25:21 -0700 (PDT)
Message-ID: <505DE66B.1080303@gmail.com>
Date: Sat, 22 Sep 2012 18:25:15 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: s5p-tv/mixer_video.c weirdness
References: <201209211207.46679.hverkuil@xs4all.nl>
In-Reply-To: <201209211207.46679.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 09/21/2012 12:07 PM, Hans Verkuil wrote:
> Hi Marek, Sylwester,
> 
> I've been investigating how multiplanar is used in various drivers, and I
> came across this driver that is a bit weird.
> 
> querycap sets both single and multiple planar output caps:
> 
>          cap->capabilities = V4L2_CAP_STREAMING |
>                  V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
> 
> This suggests that both the single and multiplanar APIs are supported.

Thanks for spotting this. Somehow this driver wasn't fixed at the time
this issue was addressed in s5p-mfc and s5p-fimc drivers in commits:

8f401543e [media] s5p-fimc: Remove single-planar capability flags,
43defb118 [media] v4l: s5p-mfc: fix reported capabilities.

The reason why these drivers were setting the both capability type flags
was that original idea was to have multi/single-plane buffer related 
ioctls translated in the kernel. So the v4l2-core would be turning 
a multi-plane only driver into a single-plane capable as well. But the 
in kernel conversion code was stripped at last minute during merge for 
known reasons. Looks like the s5p-tv driver haven't been receiving 
enough love, probably because HDMI and TV-out support for these SoCs 
now happens mainly in DRM.

I'll make sure there is a patch queued for 3.7, correcting those 
capabilities and enum_fmt.

BTW, I couldn't find a justification of making multi-planar a property
of fourcc, rather than of the memory/buffer, which it really is. As in 
this RFC [1]. Inventing multi-planar fourccs always seemed not a best
idea to me..

> But mxr_ioctl_ops only implements these:
> 
>          /* format handling */
>          .vidioc_enum_fmt_vid_out = mxr_enum_fmt,
>          .vidioc_s_fmt_vid_out_mplane = mxr_s_fmt,
>          .vidioc_g_fmt_vid_out_mplane = mxr_g_fmt,
> 
> Mixing single planar enum_fmt with multiplanar s/g_fmt makes little sense.
> 
> I suspect everything should be multiplanar.

Yes, it should be all multi-planar right from the beginning.

> BTW, I recommend running v4l2-compliance over your s5p drivers. I saw several
> things it would fail on.

I have it queued on my todo list, I'll see if it can be done for v3.8.

--

Regards,
Sylwester

[1] http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/11212
