Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2855 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab3DKSHr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 14:07:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Tzu-Jung Lee" <roylee17@gmail.com>
Subject: Re: [PATCH] v4l2-ctl: add is_compressed_format() helper
Date: Thu, 11 Apr 2013 20:07:29 +0200
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com,
	k.debski@samsung.com, "Tzu-Jung Lee" <tjlee@ambarella.com>
References: <1365695281-21227-1-git-send-email-tjlee@ambarella.com> <1365699247-32351-1-git-send-email-tjlee@ambarella.com>
In-Reply-To: <1365699247-32351-1-git-send-email-tjlee@ambarella.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304112007.29965.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu April 11 2013 18:54:07 Tzu-Jung Lee wrote:
> It is used to:
> 
>   bypass precalculate_bars() for OUTPUT device
>   that takes encoded bitstreams.
> 
>   handle the last chunk of input file that has
>   non-buffer-aligned size.
> 
> Signed-off-by: Tzu-Jung Lee <tjlee@ambarella.com>
> ---
>  utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 101 +++++++++++++++++++++++++++-------
>  1 file changed, 82 insertions(+), 19 deletions(-)
> 
> diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> index 9e361af..2bcf950 100644
> --- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> @@ -115,6 +115,29 @@ static const flag_def tc_flags_def[] = {
>  	{ 0, NULL }
>  };
>  
> +static bool is_compressed_format(__u32 pixfmt)
> +{
> +	switch (pixfmt) {
> +	case V4L2_PIX_FMT_MJPEG:
> +	case V4L2_PIX_FMT_JPEG:
> +	case V4L2_PIX_FMT_DV:
> +	case V4L2_PIX_FMT_MPEG:
> +	case V4L2_PIX_FMT_H264:
> +	case V4L2_PIX_FMT_H264_NO_SC:
> +	case V4L2_PIX_FMT_H263:
> +	case V4L2_PIX_FMT_MPEG1:
> +	case V4L2_PIX_FMT_MPEG2:
> +	case V4L2_PIX_FMT_MPEG4:
> +	case V4L2_PIX_FMT_XVID:
> +	case V4L2_PIX_FMT_VC1_ANNEX_G:

You should use VIDIOC_ENUM_FMT: that sets a 'COMPRESSED' flag for compressed
formats. You can never keep a list like the above up to date, so using ENUM_FMT
is a much more generic solution.

I will review the rest of the code tomorrow, but this jumped out to me, and
you probably didn't know this flag existed :-)

Regards,

	Hans
