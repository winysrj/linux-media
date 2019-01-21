Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF198C282DB
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 09:51:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C89842085A
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 09:51:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbfAUJvB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 04:51:01 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:53922 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727977AbfAUJvA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 04:51:00 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id lWEJgWJAOBDyIlWEMgNzM8; Mon, 21 Jan 2019 10:50:58 +0100
Subject: Re: [v4l-utils PATCH 4/6] v4l2-ctl: Introduce capture_setup
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190120111520.114305-1-dafna3@gmail.com>
 <20190120111520.114305-5-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d25f573f-6611-d84b-fb36-df921f190b7e@xs4all.nl>
Date:   Mon, 21 Jan 2019 10:50:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20190120111520.114305-5-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfFur0rJoqcizrJpByN/1MwVanvEOuntjyJsRrPX2ESmNESsaEWkOTXDXzF4v4IWMW+Ogsk1V+KGQmEzrkkCY9ighV1fX9VrbRvkykx4Pog2bNofOJpOl
 L/MfvUOR2z5taT51szeUHNOPhGkEB8MxM7K+pXhiT+raLmz1tQ9qnqMyaQ37ND11AhnagVEf43jWkSEzeOGNo5JTwLYgdJbU9XLfXP7LZymuxKLUyuW1fJiJ
 fVy1UIKax1KnNjSjNUh7og==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 01/20/2019 12:15 PM, Dafna Hirschfeld wrote:
> Add function capture_setup that implements the
> capture setup sequence.
> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
>  utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 58 +++++++++++++++++++++++----
>  1 file changed, 50 insertions(+), 8 deletions(-)
> 
> diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> index fc204304..cd20dec7 100644
> --- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> @@ -1836,6 +1836,48 @@ enum stream_type {
>  	OUT,
>  };
>  
> +static int capture_setup(cv4l_fd &fd, cv4l_queue &in)
> +{
> +	struct v4l2_fmtdesc fmt_desc;
> +	cv4l_fmt fmt;
> +
> +	if (fd.streamoff(in.g_type())) {
> +		fprintf(stderr, "%s: fd.streamoff error\n", __func__);
> +		return -1;
> +	}
> +	get_cap_compose_rect(fd);
> +
> +	/* release any buffer allocated */
> +	if (in.reqbufs(&fd)) {
> +		fprintf(stderr, "%s: in.reqbufs 0 error\n", __func__);
> +		return -1;
> +	}
> +
> +	if (fd.enum_fmt(fmt_desc, true, 0, in.g_type())) {
> +		fprintf(stderr, "%s: fd.enum_fmt error\n", __func__);
> +		return -1;
> +	}
> +
> +	fd.g_fmt(fmt, in.g_type());
> +	fmt.s_pixelformat(fmt_desc.pixelformat);

This isn't what I would expect. First try to keep the current pixelformat,
and only if that doesn't work do you pick a new format from the available
formats.

In fact, I don't think you need to do anything here at all since the driver
will update the format if needed on a resolution change.

Regards,

	Hans

> +	fd.s_fmt(fmt, in.g_type());
> +
> +	if (in.reqbufs(&fd, reqbufs_count_cap)) {
> +		fprintf(stderr, "%s: in.reqbufs %u error\n", __func__,
> +			reqbufs_count_cap);
> +		return -1;
> +	}
> +	if (in.obtain_bufs(&fd) || in.queue_all(&fd)) {
> +		fprintf(stderr, "%s: in.obtain_bufs error\n", __func__);
> +		return -1;
> +	}
> +	if (fd.streamon(in.g_type())) {
> +		fprintf(stderr, "%s: fd.streamon error\n", __func__);
> +		return -1;
> +	}
> +	return 0;
> +}
> +
>  static void streaming_set_m2m(cv4l_fd &fd)
>  {
>  	int fd_flags = fcntl(fd.g_fd(), F_GETFL);
> @@ -1900,21 +1942,21 @@ static void streaming_set_m2m(cv4l_fd &fd)
>  		}
>  	}
>  
> -	if (in.reqbufs(&fd, reqbufs_count_cap) ||
> -	    out.reqbufs(&fd, reqbufs_count_out))
> +	if (out.reqbufs(&fd, reqbufs_count_out))
>  		goto done;
>  
> -	if (in.obtain_bufs(&fd) ||
> -	    in.queue_all(&fd) ||
> -	    do_setup_out_buffers(fd, out, file[OUT], true))
> +	if (do_setup_out_buffers(fd, out, file[OUT], true))
>  		goto done;
>  
> -	fps_ts[CAP].determine_field(fd.g_fd(), in.g_type());
> -	fps_ts[OUT].determine_field(fd.g_fd(), out.g_type());
> +	if (fd.streamon(out.g_type()))
> +		goto done;
>  
> -	if (fd.streamon(in.g_type()) || fd.streamon(out.g_type()))
> +	if (capture_setup(fd, in))
>  		goto done;
>  
> +	fps_ts[CAP].determine_field(fd.g_fd(), in.g_type());
> +	fps_ts[OUT].determine_field(fd.g_fd(), out.g_type());
> +
>  	while (stream_sleep == 0)
>  		sleep(100);
>  
> 

