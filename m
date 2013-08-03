Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:62353 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab3HCQmc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Aug 2013 12:42:32 -0400
Received: by mail-bk0-f49.google.com with SMTP id r7so529865bkg.36
        for <linux-media@vger.kernel.org>; Sat, 03 Aug 2013 09:42:31 -0700 (PDT)
Message-ID: <51FD32F5.40200@googlemail.com>
Date: Sat, 03 Aug 2013 18:42:29 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 2/2] libv4lconvert: Support for RGB32 and BGR32 format
References: <1375483372-4354-1-git-send-email-ricardo.ribalda@gmail.com> <1375483372-4354-3-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1375483372-4354-3-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 8/3/13 12:42 AM, Ricardo Ribalda Delgado wrote:
> +	case V4L2_PIX_FMT_RGB32:
> +		switch (dest_pix_fmt) {
> +		case V4L2_PIX_FMT_RGB24:
> +			v4lconvert_rgb32_to_rgb24(src, dest, width, height, 0);
> +			break;
> +		case V4L2_PIX_FMT_BGR24:
> +			v4lconvert_rgb32_to_rgb24(src, dest, width, height, 1);
> +			break;
> +		case V4L2_PIX_FMT_YUV420:
> +			v4lconvert_rgb24_to_yuv420(src, dest, fmt, 0, 0, 4);
> +			break;
> +		case V4L2_PIX_FMT_YVU420:
> +			v4lconvert_rgb24_to_yuv420(src, dest, fmt, 0, 1, 4);
> +			break;
> +		}
> +		if (src_size < (width * height * 4)) {
> +			V4LCONVERT_ERR("short rgb32 data frame\n");
> +			errno = EPIPE;
> +			result = -1;
> +		}
> +		break;

I have not looked at the whole function but shouldn't this sanity check 
happen before the actual work? Also aren't you applying the condition 
here also for rgb24_to_xxx which should have only three bpp?

> +	case V4L2_PIX_FMT_BGR32:
> +		switch (dest_pix_fmt) {
> +		case V4L2_PIX_FMT_RGB24:
> +			v4lconvert_rgb32_to_rgb24(src, dest, width, height, 1);
> +			break;
> +		case V4L2_PIX_FMT_BGR24:
> +			v4lconvert_rgb32_to_rgb24(src, dest, width, height, 0);
> +			break;
> +		case V4L2_PIX_FMT_YUV420:
> +			v4lconvert_rgb24_to_yuv420(src, dest, fmt, 1, 0, 4);
> +			break;
> +		case V4L2_PIX_FMT_YVU420:
> +			v4lconvert_rgb24_to_yuv420(src, dest, fmt, 1, 1, 4);
> +			break;
> +		}
> +		if (src_size < (width * height * 4)) {
> +			V4LCONVERT_ERR("short bgr32 data frame\n");
> +			errno = EPIPE;
> +			result = -1;
> +		}
> +		break;

Same here. And also in the other patch.


