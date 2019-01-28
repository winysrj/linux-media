Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F14C282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 09:17:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0B8920844
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 09:17:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfA1JRr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 04:17:47 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:47419 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726611AbfA1JRr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 04:17:47 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id o32yglbk4BDyIo332gnIRU; Mon, 28 Jan 2019 10:17:44 +0100
Subject: Re: [v4l-utils PATCH v2 5/5] v4l2-ctl: Add --stream-pixformat option
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190121185651.6229-1-dafna3@gmail.com>
 <20190121185651.6229-6-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <48cd642a-5118-e8ce-4076-f5fa46b7f113@xs4all.nl>
Date:   Mon, 28 Jan 2019 10:17:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190121185651.6229-6-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfMZJOvA5AtRsIaXrhrqOyWgZkzP0hcXTbh6MwW2n3kikp/B8kRb0xBlldZh5JKX+Y9vP2Rg9bhZoXOkWZ81sM+/jRUTfxTD2odfzc/vsxXwwwHMFVTpt
 HuRbgyZQ3odZntVwWv0iI/3XvDPlOO+hKKERHVuL6W1PO9Bfw84H+68ekMlCKGZuJd5Z3SruHdoNCTre4F9y+HZ0Sd9TcTBtWmcSFIjX659OxNPJ8wAAsQU5
 KX/xbdh0UcI3KBO2PJVLEw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Dafna,

On 1/21/19 7:56 PM, Dafna Hirschfeld wrote:
> This option sets the capture pixelformat in the
> capture setup sequence.
> If the format is not supported decoding will stop.
> If the option is not given then the default is to set
> the first supported format.

I'm not convinced about this patch. Is there any reason why you can't
reuse the -v option for this?

What I would expect to happen is this:

If a decoder is detected, then -v doesn't set the current capture format
upfront (as happens now), instead it is done when the decoder sends the SOURCE_CHANGE
event. Otherwise it works the same: it takes the current format and updates
the user-specified fields.

That avoids having to add a new option (we have way too many already).

Regards,

	Hans

> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
>  utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 37 +++++++++++++++++++++++++
>  utils/v4l2-ctl/v4l2-ctl.cpp           | 39 ++++++++++++++++++---------
>  utils/v4l2-ctl/v4l2-ctl.h             |  2 ++
>  3 files changed, 65 insertions(+), 13 deletions(-)
> 
> diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> index 8d034b85..3e0a449c 100644
> --- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> @@ -78,6 +78,7 @@ static unsigned int composed_width;
>  static unsigned int composed_height;
>  static bool support_cap_compose;
>  static bool support_out_crop;
> +static unsigned int cap_pixelformat;
>  static bool in_source_change_event;
>  
>  #define TS_WINDOW 241
> @@ -272,6 +273,10 @@ void streaming_usage(void)
>  	       "  --stream-from <file>\n"
>  	       "                     stream from this file. The default is to generate a pattern.\n"
>  	       "                     If <file> is '-', then the data is read from stdin.\n"
> +	       "  --stream-pixformat <pixformat>\n"
> +	       "                     set the video pixelformat."
> +	       "                     <pixelformat> is either the format index as reported by\n"
> +	       "                     --list-formats-out, or the fourcc value as a string.\n"
>  	       "  --stream-from-hdr <file> stream from this file. Same as --stream-from, but each\n"
>  	       "                     frame is prefixed by a header. Use for compressed data.\n"
>  	       "  --stream-from-host <hostname[:port]>\n"
> @@ -606,8 +611,16 @@ void streaming_cmd(int ch, char *optarg)
>  {
>  	unsigned i;
>  	int speed;
> +	int r;
>  
>  	switch (ch) {
> +	case OptStreamPixformat:
> +		r = parse_pixelfmt(optarg, cap_pixelformat);
> +		if (r) {
> +			streaming_usage();
> +			exit(1);
> +		}
> +		break;
>  	case OptStreamCount:
>  		stream_count = strtoul(optarg, 0L, 0);
>  		break;
> @@ -1853,6 +1866,9 @@ enum stream_type {
>  
>  static int capture_setup(cv4l_fd &fd, cv4l_queue &in)
>  {
> +	v4l2_fmtdesc fmt_desc;
> +	cv4l_fmt fmt;
> +
>  	if (fd.streamoff(in.g_type())) {
>  		fprintf(stderr, "%s: fd.streamoff error\n", __func__);
>  		return -1;
> @@ -1865,6 +1881,27 @@ static int capture_setup(cv4l_fd &fd, cv4l_queue &in)
>  		return -1;
>  	}
>  
> +	if (cap_pixelformat) {
> +		if (fd.enum_fmt(fmt_desc, true, 0, in.g_type())) {
> +			fprintf(stderr, "%s: fd.enum_fmt error\n", __func__);
> +			return -1;
> +		}
> +
> +		do {
> +			if (cap_pixelformat == fmt_desc.pixelformat)
> +				break;
> +		} while (!fd.enum_fmt(fmt_desc));
> +
> +		if (cap_pixelformat != fmt_desc.pixelformat) {
> +			fprintf(stderr, "%s: format from user not supported\n", __func__);
> +			return -1;
> +		}
> +
> +		fd.g_fmt(fmt, in.g_type());
> +		fmt.s_pixelformat(cap_pixelformat);
> +		fd.s_fmt(fmt, in.g_type());
> +	}
> +
>  	if (in.reqbufs(&fd, reqbufs_count_cap)) {
>  		fprintf(stderr, "%s: in.reqbufs %u error\n", __func__,
>  			reqbufs_count_cap);
> diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
> index 1783979d..2cbf519e 100644
> --- a/utils/v4l2-ctl/v4l2-ctl.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl.cpp
> @@ -238,6 +238,7 @@ static struct option long_options[] = {
>  	{"list-buffers-sdr", no_argument, 0, OptListBuffersSdr},
>  	{"list-buffers-sdr-out", no_argument, 0, OptListBuffersSdrOut},
>  	{"list-buffers-meta", no_argument, 0, OptListBuffersMeta},
> +	{"stream-pixformat", required_argument, 0, OptStreamPixformat},
>  	{"stream-count", required_argument, 0, OptStreamCount},
>  	{"stream-skip", required_argument, 0, OptStreamSkip},
>  	{"stream-loop", no_argument, 0, OptStreamLoop},
> @@ -722,6 +723,30 @@ __u32 parse_quantization(const char *s)
>  	return V4L2_QUANTIZATION_DEFAULT;
>  }
>  
> +int parse_pixelfmt(char *value,  __u32 &pixelformat)
> +{
> +	int fmts = 0;
> +	bool be_pixfmt;
> +
> +	if(!value)
> +		return -EINVAL;
> +
> +	be_pixfmt = strlen(value) == 7 && !memcmp(value + 4, "-BE", 3);
> +	if (be_pixfmt)
> +		value[4] = 0;
> +	if (strlen(value) == 4) {
> +		pixelformat =
> +			v4l2_fourcc(value[0], value[1],
> +					value[2], value[3]);
> +		if (be_pixfmt)
> +			pixelformat |= 1 << 31;
> +	} else {
> +		pixelformat = strtol(value, 0L, 0);
> +	}
> +	fmts |= FmtPixelFormat;
> +	return 0;
> +}
> +
>  int parse_fmt(char *optarg, __u32 &width, __u32 &height, __u32 &pixelformat,
>  	      __u32 &field, __u32 &colorspace, __u32 &xfer_func, __u32 &ycbcr,
>  	      __u32 &quantization, __u32 &flags, __u32 *bytesperline)
> @@ -729,7 +754,6 @@ int parse_fmt(char *optarg, __u32 &width, __u32 &height, __u32 &pixelformat,
>  	char *value, *subs;
>  	int fmts = 0;
>  	unsigned bpl_index = 0;
> -	bool be_pixfmt;
>  
>  	field = V4L2_FIELD_ANY;
>  	flags = 0;
> @@ -760,18 +784,7 @@ int parse_fmt(char *optarg, __u32 &width, __u32 &height, __u32 &pixelformat,
>  			fmts |= FmtHeight;
>  			break;
>  		case 2:
> -			be_pixfmt = strlen(value) == 7 && !memcmp(value + 4, "-BE", 3);
> -			if (be_pixfmt)
> -				value[4] = 0;
> -			if (strlen(value) == 4) {
> -				pixelformat =
> -					v4l2_fourcc(value[0], value[1],
> -							value[2], value[3]);
> -				if (be_pixfmt)
> -					pixelformat |= 1 << 31;
> -			} else {
> -				pixelformat = strtol(value, 0L, 0);
> -			}
> +			parse_pixelfmt(value, pixelformat);
>  			fmts |= FmtPixelFormat;
>  			break;
>  		case 3:
> diff --git a/utils/v4l2-ctl/v4l2-ctl.h b/utils/v4l2-ctl/v4l2-ctl.h
> index 5a52a0a4..8eee5351 100644
> --- a/utils/v4l2-ctl/v4l2-ctl.h
> +++ b/utils/v4l2-ctl/v4l2-ctl.h
> @@ -205,6 +205,7 @@ enum Option {
>  	OptListBuffersSdr,
>  	OptListBuffersSdrOut,
>  	OptListBuffersMeta,
> +	OptStreamPixformat,
>  	OptStreamCount,
>  	OptStreamSkip,
>  	OptStreamLoop,
> @@ -299,6 +300,7 @@ __u32 parse_xfer_func(const char *s);
>  __u32 parse_ycbcr(const char *s);
>  __u32 parse_hsv(const char *s);
>  __u32 parse_quantization(const char *s);
> +int parse_pixelfmt(char *value,  __u32 &pixelformat);
>  int parse_fmt(char *optarg, __u32 &width, __u32 &height, __u32 &pixelformat,
>  	      __u32 &field, __u32 &colorspace, __u32 &xfer, __u32 &ycbcr,
>  	      __u32 &quantization, __u32 &flags, __u32 *bytesperline);
> 

