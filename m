Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC349C43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 08:47:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89C802087E
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 08:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbfCAIrb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 03:47:31 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:35678 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725978AbfCAIra (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Mar 2019 03:47:30 -0500
Received: from [IPv6:2001:983:e9a7:1:28f6:efa6:3b03:d09a] ([IPv6:2001:983:e9a7:1:28f6:efa6:3b03:d09a])
        by smtp-cloud7.xs4all.net with ESMTPA
        id zdpHgLId3LMwIzdpIgh8IV; Fri, 01 Mar 2019 09:47:28 +0100
Subject: Re: [v4l-utils PATCH v5 2/3] v4l2-ctl: Add functions and variables to
 support fwht stateless decoder
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190227070757.25092-1-dafna3@gmail.com>
 <20190227070757.25092-3-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <7e43f6ac-7dca-7042-5827-39b0e0434292@xs4all.nl>
Date:   Fri, 1 Mar 2019 09:47:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190227070757.25092-3-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfFvib8Im7UBqepLJVOHJ5s8h9tFESE1G0RdmFLDhnamtKeDm+Wa2YjeaWuadA3jLq81mSzclV49byDILtY4l6Q3uJaHZ66D3LyQTxdnPvhobDVlNfGvK
 Hqe4K0gaphfVnnQpllowHPaRUQN/iP1feTrgA4VNu2Otyy4Dljyr2VN/7KonOW6F9nNOph2HTVqyurat9yu/WHh9c/Asi2PUK9Ace7EQiouEwR/gtQ2xkO7C
 csu8+mWBSED6LrSSaDc2FvjuwjN4baYouYtk4WlKxH6GGf59qAbJAhzwzPkY5/JpV/lmztUb9SmFXm9eILs9WxmnYjN8s8cN5oOKX6DYnFE=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/27/19 8:07 AM, Dafna Hirschfeld wrote:
> Add the variable 'last_fwht_bf_ts' and the array 'fwht_reqs' to
> allow the fwht stateless decoder to maintain the requests.
> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
>  utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 129 ++++++++++++++++++++++++++
>  1 file changed, 129 insertions(+)
> 
> diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> index adfa6796..dd0eeef6 100644
> --- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> @@ -17,9 +17,12 @@
>  #include <sys/mman.h>
>  #include <dirent.h>
>  #include <math.h>
> +#include <linux/media.h>
>  
>  #include "v4l2-ctl.h"
>  #include "v4l-stream.h"
> +#include <media-info.h>
> +#include <fwht-ctrls.h>
>  
>  extern "C" {
>  #include "v4l2-tpg.h"
> @@ -80,6 +83,16 @@ static bool support_cap_compose;
>  static bool support_out_crop;
>  static bool in_source_change_event;
>  
> +static __u64 last_fwht_bf_ts;
> +
> +struct request_fwht {
> +	int fd;
> +	__u64 ts;
> +	struct v4l2_ctrl_fwht_params params;
> +};
> +
> +static request_fwht fwht_reqs[VIDEO_MAX_FRAME];
> +
>  #define TS_WINDOW 241
>  #define FILE_HDR_ID			v4l2_fourcc('V', 'h', 'd', 'r')
>  
> @@ -420,6 +433,12 @@ static int get_out_crop_rect(cv4l_fd &fd)
>  	return 0;
>  }
>  
> +static __u64 get_ns_timestamp(cv4l_buffer &buf)
> +{
> +	const struct timeval tv = buf.g_timestamp();
> +	return v4l2_timeval_to_ns(&tv);
> +}
> +
>  static void set_time_stamp(cv4l_buffer &buf)
>  {
>  	if ((buf.g_flags() & V4L2_BUF_FLAG_TIMESTAMP_MASK) != V4L2_BUF_FLAG_TIMESTAMP_COPY)
> @@ -749,6 +768,116 @@ void streaming_cmd(int ch, char *optarg)
>  	}
>  }
>  
> +/*
> + * Assume that the fwht stream is valid and that each
> + * frame starts right after the previous one.
> + */
> +static void read_fwht_frame(cv4l_fmt &fmt, unsigned char *buf,
> +			    FILE *fpointer, unsigned &sz,
> +			    unsigned &len)
> +{
> +	struct fwht_cframe_hdr *h = (struct fwht_cframe_hdr *)buf;
> +
> +	len = sizeof(struct fwht_cframe_hdr);
> +	sz = fread(buf, 1, sizeof(struct fwht_cframe_hdr), fpointer);
> +	if (sz < sizeof(struct fwht_cframe_hdr))
> +		return;
> +
> +	len += ntohl(h->size);
> +	sz += fread(buf + sz, 1, ntohl(h->size), fpointer);
> +}
> +
> +static void set_fwht_stateless_params(struct v4l2_ctrl_fwht_params &fwht_params,
> +				      const struct fwht_cframe_hdr *hdr,
> +				      __u64 last_bf_ts)
> +{
> +	fwht_params.backward_ref_ts = last_bf_ts;
> +	fwht_params.version = ntohl(hdr->version);
> +	fwht_params.width = ntohl(hdr->width);
> +	fwht_params.height = ntohl(hdr->height);
> +	fwht_params.flags = ntohl(hdr->flags);
> +	fwht_params.colorspace = ntohl(hdr->colorspace);
> +	fwht_params.xfer_func = ntohl(hdr->xfer_func);
> +	fwht_params.ycbcr_enc = ntohl(hdr->ycbcr_enc);
> +	fwht_params.quantization = ntohl(hdr->quantization);
> +
> +	if (!last_bf_ts)
> +		fwht_params.flags |= FWHT_FL_I_FRAME;

This is to force an I frame if there are no previous reference frames,
right? The video won't look good until the next real I frame, but at
least it will display something.

This could use a comment since it is not obvious what happens.

For a utility like v4l2-ctl it is probably not a bad idea to do it like
this since this will ensure that you at least get some video output.

Regards,

	Hans

> +}
> +
> +static int alloc_fwht_req(int media_fd, unsigned index)
> +{
> +	int rc = 0;
> +
> +	rc = ioctl(media_fd, MEDIA_IOC_REQUEST_ALLOC, &fwht_reqs[index]);
> +	if (rc < 0) {
> +		fprintf(stderr, "Unable to allocate media request: %s\n",
> +			strerror(errno));
> +		return rc;
> +	}
> +
> +	return 0;
> +}
> +
> +static void set_fwht_req_by_idx(unsigned idx, struct fwht_cframe_hdr *hdr,
> +				__u64 last_bf_ts, __u64 ts)
> +{
> +	struct v4l2_ctrl_fwht_params fwht_params;
> +
> +	set_fwht_stateless_params(fwht_params, hdr, last_bf_ts);
> +
> +	fwht_reqs[idx].ts = ts;
> +	fwht_reqs[idx].params = fwht_params;
> +}
> +
> +static int get_fwht_req_by_ts(__u64 ts)
> +{
> +	for (int idx = 0; idx < VIDEO_MAX_FRAME; idx++) {
> +		if (fwht_reqs[idx].ts == ts)
> +			return idx;
> +	}
> +	return -1;
> +}
> +
> +static bool set_fwht_req_by_fd(struct fwht_cframe_hdr *hdr,
> +			       int req_fd, __u64 last_bf_ts, __u64 ts)
> +{
> +	struct v4l2_ctrl_fwht_params fwht_params;
> +
> +	set_fwht_stateless_params(fwht_params, hdr, last_bf_ts);
> +
> +	for (int idx = 0; idx < VIDEO_MAX_FRAME; idx++) {
> +		if (fwht_reqs[idx].fd == req_fd) {
> +			fwht_reqs[idx].ts = ts;
> +			fwht_reqs[idx].params = fwht_params;
> +			return true;
> +		}
> +	}
> +	return false;
> +}
> +
> +static int set_fwht_ext_ctrl(cv4l_fd &fd, struct fwht_cframe_hdr *hdr,
> +			     __u64 last_bf_ts, int req_fd)
> +{
> +	v4l2_ext_controls controls;
> +	struct v4l2_ext_control control;
> +	struct v4l2_ctrl_fwht_params fwht_params;
> +
> +	memset(&control, 0, sizeof(control));
> +	memset(&controls, 0, sizeof(controls));
> +
> +	set_fwht_stateless_params(fwht_params, hdr, last_bf_ts);
> +
> +	control.id = V4L2_CID_MPEG_VIDEO_FWHT_PARAMS;
> +	control.ptr = &fwht_params;
> +	control.size = sizeof(fwht_params);
> +	controls.which = V4L2_CTRL_WHICH_REQUEST_VAL;
> +	controls.request_fd = req_fd;
> +	controls.controls = &control;
> +	controls.count = 1;
> +	return fd.s_ext_ctrls(controls);
> +}
> +
>  static void read_write_padded_frame(cv4l_fmt &fmt, unsigned char *buf,
>  				    FILE *fpointer, unsigned &sz,
>  				    unsigned &len, bool is_read)
> 

