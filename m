Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B805C282DB
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 09:24:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05257214DA
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 09:24:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbfAUJYt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 04:24:49 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:34535 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726775AbfAUJYt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 04:24:49 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id lVowgVuvWBDyIlVp0gNmdc; Mon, 21 Jan 2019 10:24:47 +0100
Subject: Re: [v4l-utils PATCH 2/6] v4l2-ctl: Add function get_codec_type
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190120111520.114305-1-dafna3@gmail.com>
 <20190120111520.114305-3-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <da9558f1-1b53-e0a2-671a-b74b07d118ec@xs4all.nl>
Date:   Mon, 21 Jan 2019 10:24:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20190120111520.114305-3-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfBBTtGSR3DdKyj2eDmgxBkMNS2sI3CngoFkPJ6bVxYsjcLPD5bJONSXx9+MnJOLRMnxbOsadmlhwJc/g88sH/Yq8KP7efaZTKqIB9JebT2sXPYdEc9Xc
 VwPsd6SpO8159uTwYMvK83ILnhEhOztWV75tE1nj7NrkAV7YOBTcjn/0U8leFQ2Jg/u4vzGXJa7xe/ROS2XcvDVv1o0HZJFfXqh6IbegOaHR5A5+wgnEilK3
 rvegcKAQ+bqF8kMV72q6Iw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 01/20/2019 12:15 PM, Dafna Hirschfeld wrote:
> Add function get_codec_type that returns the type
> of codec NOT_CODEC/ENCODER/DEOCDER.
> Move the functions get_cap_compose/crop_rect
> to the start of the file.
> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
>  utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 126 ++++++++++++++++++--------
>  1 file changed, 88 insertions(+), 38 deletions(-)
> 
> diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> index 8a98b6bd..3e81fdfc 100644
> --- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> @@ -82,6 +82,12 @@ static bool support_out_crop;
>  #define TS_WINDOW 241
>  #define FILE_HDR_ID			v4l2_fourcc('V', 'h', 'd', 'r')
>  
> +enum codec_type {
> +	NOT_CODEC,
> +	ENCODER,
> +	DECODER
> +};
> +
>  class fps_timestamps {
>  private:
>  	unsigned idx;
> @@ -334,6 +340,88 @@ void streaming_usage(void)
>  	       	V4L_STREAM_PORT);
>  }
>  
> +static int get_codec_type(cv4l_fd &fd, enum codec_type &codec_type)

Just have this function return enum codec_type, no need for it to return -1.
If it encounters any errors then it is not a codec.

Regards,

	Hans

> +{
> +	struct v4l2_fmtdesc fmt_desc;
> +	int num_cap_fmts = 0;
> +	int num_compressed_cap_fmts = 0;
> +	int num_out_fmts = 0;
> +	int num_compressed_out_fmts = 0;
> +
> +	codec_type = NOT_CODEC;
> +	if (!fd.has_vid_m2m())
> +		return 0;
> +
> +	if (fd.enum_fmt(fmt_desc, true, 0, V4L2_BUF_TYPE_VIDEO_CAPTURE))
> +		return -1;
> +
> +	do {
> +		if (fmt_desc.flags & V4L2_FMT_FLAG_COMPRESSED)
> +			num_compressed_cap_fmts++;
> +		num_cap_fmts++;
> +	} while (!fd.enum_fmt(fmt_desc));
> +
> +
> +	if (fd.enum_fmt(fmt_desc, true, 0, V4L2_BUF_TYPE_VIDEO_OUTPUT))
> +		return -1;
> +
> +	do {
> +		if (fmt_desc.flags & V4L2_FMT_FLAG_COMPRESSED)
> +			num_compressed_out_fmts++;
> +		num_out_fmts++;
> +	} while (!fd.enum_fmt(fmt_desc));
> +
> +	if (num_compressed_out_fmts == 0 && num_compressed_cap_fmts == num_cap_fmts) {
> +		codec_type = ENCODER;
> +		return 0;
> +	}
> +
> +	if (num_compressed_cap_fmts == 0 && num_compressed_out_fmts == num_out_fmts) {
> +		codec_type = DECODER;
> +		return 0;
> +	}
> +
> +	return 0;
> +}
> +
> +static int get_cap_compose_rect(cv4l_fd &fd)
> +{
> +	v4l2_selection sel;
> +
> +	memset(&sel, 0, sizeof(sel));
> +	sel.type = vidcap_buftype;
> +	sel.target = V4L2_SEL_TGT_COMPOSE;
> +
> +	if (fd.g_selection(sel) == 0) {
> +		support_cap_compose = true;
> +		composed_width = sel.r.width;
> +		composed_height = sel.r.height;
> +		return 0;
> +	}
> +
> +	support_cap_compose = false;
> +	return 0;
> +}
> +
> +static int get_out_crop_rect(cv4l_fd &fd)
> +{
> +	v4l2_selection sel;
> +
> +	memset(&sel, 0, sizeof(sel));
> +	sel.type = vidout_buftype;
> +	sel.target = V4L2_SEL_TGT_CROP;
> +
> +	if (fd.g_selection(sel) == 0) {
> +		support_out_crop = true;
> +		cropped_width = sel.r.width;
> +		cropped_height = sel.r.height;
> +		return 0;
> +	}
> +
> +	support_out_crop = false;
> +	return 0;
> +}
> +
>  static void set_time_stamp(cv4l_buffer &buf)
>  {
>  	if ((buf.g_flags() & V4L2_BUF_FLAG_TIMESTAMP_MASK) != V4L2_BUF_FLAG_TIMESTAMP_COPY)
> @@ -2109,44 +2197,6 @@ done:
>  		fclose(file[OUT]);
>  }
>  
> -static int get_cap_compose_rect(cv4l_fd &fd)
> -{
> -	v4l2_selection sel;
> -
> -	memset(&sel, 0, sizeof(sel));
> -	sel.type = vidcap_buftype;
> -	sel.target = V4L2_SEL_TGT_COMPOSE;
> -
> -	if (fd.g_selection(sel) == 0) {
> -		support_cap_compose = true;
> -		composed_width = sel.r.width;
> -		composed_height = sel.r.height;
> -		return 0;
> -	}
> -
> -	support_cap_compose = false;
> -	return 0;
> -}
> -
> -static int get_out_crop_rect(cv4l_fd &fd)
> -{
> -	v4l2_selection sel;
> -
> -	memset(&sel, 0, sizeof(sel));
> -	sel.type = vidout_buftype;
> -	sel.target = V4L2_SEL_TGT_CROP;
> -
> -	if (fd.g_selection(sel) == 0) {
> -		support_out_crop = true;
> -		cropped_width = sel.r.width;
> -		cropped_height = sel.r.height;
> -		return 0;
> -	}
> -
> -	support_out_crop = false;
> -	return 0;
> -}
> -
>  void streaming_set(cv4l_fd &fd, cv4l_fd &out_fd)
>  {
>  	cv4l_disable_trace dt(fd);
> 

