Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C607C282D7
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 14:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6ABA620882
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 14:52:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfA3Oww (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 09:52:52 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:39479 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725828AbfA3Owv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 09:52:51 -0500
Received: from [IPv6:2001:420:44c1:2579:1135:9e59:3a9c:d4ef] ([IPv6:2001:420:44c1:2579:1135:9e59:3a9c:d4ef])
        by smtp-cloud8.xs4all.net with ESMTPA
        id orEJgxzVcNR5yorEOgL9l4; Wed, 30 Jan 2019 15:52:49 +0100
Subject: Re: [PATCH v2] v4l2-ctl: add function vidcap_get_and_update_fmt
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190130144229.41942-1-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <996e7dab-d3e9-c0f6-f45d-0ee50d7c3e0f@xs4all.nl>
Date:   Wed, 30 Jan 2019 15:52:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190130144229.41942-1-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfIvxwWxHDJIaPIVIi5TjGqIGWoOZJhG4VfgPt10gCbm/42RTIUwWNN6NoA3xsMDLdZrtV0+Y9WhfHInLuUvfBwKJBLSqtVTj3/l4wz6PSDPxACEkJlYw
 /un4Fc5uQfNzIfmFEd2IXBk3CiQwv2K2YFwWRFXtI/FSe7jPB3N67BzoIPeGppv1paXKsy8dm+A1Vd3Lw13Ur9q74mZ/RNl8DVIYdR09XXE0coAmVgTwXJ5/
 Y/zBZKez7s/IRbWjA3PvIwqHBurgPWG3aaM1yhkhpTyLRdDhHEjkR8H18zPGLwps5J1Ks7QJfJD7uaHZWqInOx4AvTnZ3EIE9LE1eVuO9UcvaDHPrwv507rD
 t/1mrZBp
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/30/19 3:42 PM, Dafna Hirschfeld wrote:
> add a function vidcap_get_and_update_fmt to set
> the format from cmd params. Use it in capture_setup.
> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
> Changes from v1:
> change the order of vidcap_get_and_update_fmt and vidcap_set
> 
> utils/v4l2-ctl/v4l2-ctl-streaming.cpp |  13 +++
>  utils/v4l2-ctl/v4l2-ctl-vidcap.cpp    | 134 ++++++++++++++------------
>  utils/v4l2-ctl/v4l2-ctl.h             |   1 +
>  3 files changed, 88 insertions(+), 60 deletions(-)
> 
> diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> index d6c3f6a9..2f66e052 100644
> --- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> @@ -1902,17 +1902,30 @@ static int capture_setup(cv4l_fd &fd, cv4l_queue &in, cv4l_fd *exp_fd)
>  		return -1;
>  	}
>  
> +	if (options[OptSetVideoFormat]) {
> +		cv4l_fmt fmt;
> +
> +		if (vidcap_get_and_update_fmt(fd, fmt)) {
> +			fprintf(stderr, "%s: vidcap_get_and_update_fmt error\n",
> +				__func__);
> +			return -1;
> +		}
> +		fd.s_fmt(fmt, in.g_type());
> +	}
> +

I think you need to move the get_cap_compose_rect() down to this line.

s_fmt might change the compose rectangle (at least in theory), so set the
format first, then get the compose rectangle.

Regards,

	Hans

>  	if (in.reqbufs(&fd, reqbufs_count_cap)) {
>  		fprintf(stderr, "%s: in.reqbufs %u error\n", __func__,
>  			reqbufs_count_cap);
>  		return -1;
>  	}
> +
>  	if (exp_fd && in.export_bufs(exp_fd, exp_fd->g_type()))
>  		return -1;
>  	if (in.obtain_bufs(&fd) || in.queue_all(&fd)) {
>  		fprintf(stderr, "%s: in.obtain_bufs error\n", __func__);
>  		return -1;
>  	}
> +
>  	if (fd.streamon(in.g_type())) {
>  		fprintf(stderr, "%s: fd.streamon error\n", __func__);
>  		return -1;
> diff --git a/utils/v4l2-ctl/v4l2-ctl-vidcap.cpp b/utils/v4l2-ctl/v4l2-ctl-vidcap.cpp
> index dc17a868..1e32fd2a 100644
> --- a/utils/v4l2-ctl/v4l2-ctl-vidcap.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl-vidcap.cpp
> @@ -153,74 +153,88 @@ void vidcap_cmd(int ch, char *optarg)
>  	}
>  }
>  
> -void vidcap_set(cv4l_fd &_fd)
> +int vidcap_get_and_update_fmt(cv4l_fd &_fd, struct v4l2_format &vfmt)
>  {
>  	int fd = _fd.g_fd();
>  	int ret;
>  
> -	if (options[OptSetVideoFormat] || options[OptTryVideoFormat]) {
> -		struct v4l2_format vfmt;
> +	memset(&vfmt, 0, sizeof(vfmt));
> +	vfmt.fmt.pix.priv = priv_magic;
> +	vfmt.type = vidcap_buftype;
>  
> -		memset(&vfmt, 0, sizeof(vfmt));
> -		vfmt.fmt.pix.priv = priv_magic;
> -		vfmt.type = vidcap_buftype;
> +	ret = doioctl(fd, VIDIOC_G_FMT, &vfmt);
> +	if (ret)
> +		return ret;
>  
> -		if (doioctl(fd, VIDIOC_G_FMT, &vfmt) == 0) {
> -			if (is_multiplanar) {
> -				if (set_fmts & FmtWidth)
> -					vfmt.fmt.pix_mp.width = width;
> -				if (set_fmts & FmtHeight)
> -					vfmt.fmt.pix_mp.height = height;
> -				if (set_fmts & FmtPixelFormat) {
> -					vfmt.fmt.pix_mp.pixelformat = pixfmt;
> -					if (vfmt.fmt.pix_mp.pixelformat < 256) {
> -						vfmt.fmt.pix_mp.pixelformat =
> -							find_pixel_format(fd, vfmt.fmt.pix_mp.pixelformat,
> -									false, true);
> -					}
> -				}
> -				if (set_fmts & FmtField)
> -					vfmt.fmt.pix_mp.field = field;
> -				if (set_fmts & FmtFlags)
> -					vfmt.fmt.pix_mp.flags = flags;
> -				if (set_fmts & FmtBytesPerLine) {
> -					for (unsigned i = 0; i < VIDEO_MAX_PLANES; i++)
> -						vfmt.fmt.pix_mp.plane_fmt[i].bytesperline =
> -							bytesperline[i];
> -				} else {
> -					/* G_FMT might return bytesperline values > width,
> -					 * reset them to 0 to force the driver to update them
> -					 * to the closest value for the new width. */
> -					for (unsigned i = 0; i < vfmt.fmt.pix_mp.num_planes; i++)
> -						vfmt.fmt.pix_mp.plane_fmt[i].bytesperline = 0;
> -				}
> -			} else {
> -				if (set_fmts & FmtWidth)
> -					vfmt.fmt.pix.width = width;
> -				if (set_fmts & FmtHeight)
> -					vfmt.fmt.pix.height = height;
> -				if (set_fmts & FmtPixelFormat) {
> -					vfmt.fmt.pix.pixelformat = pixfmt;
> -					if (vfmt.fmt.pix.pixelformat < 256) {
> -						vfmt.fmt.pix.pixelformat =
> -							find_pixel_format(fd, vfmt.fmt.pix.pixelformat,
> -									false, false);
> -					}
> -				}
> -				if (set_fmts & FmtField)
> -					vfmt.fmt.pix.field = field;
> -				if (set_fmts & FmtFlags)
> -					vfmt.fmt.pix.flags = flags;
> -				if (set_fmts & FmtBytesPerLine) {
> -					vfmt.fmt.pix.bytesperline = bytesperline[0];
> -				} else {
> -					/* G_FMT might return a bytesperline value > width,
> -					 * reset this to 0 to force the driver to update it
> -					 * to the closest value for the new width. */
> -					vfmt.fmt.pix.bytesperline = 0;
> -				}
> +	if (is_multiplanar) {
> +		if (set_fmts & FmtWidth)
> +			vfmt.fmt.pix_mp.width = width;
> +		if (set_fmts & FmtHeight)
> +			vfmt.fmt.pix_mp.height = height;
> +		if (set_fmts & FmtPixelFormat) {
> +			vfmt.fmt.pix_mp.pixelformat = pixfmt;
> +			if (vfmt.fmt.pix_mp.pixelformat < 256) {
> +				vfmt.fmt.pix_mp.pixelformat =
> +					find_pixel_format(fd, vfmt.fmt.pix_mp.pixelformat,
> +							  false, true);
> +			}
> +		}
> +		if (set_fmts & FmtField)
> +			vfmt.fmt.pix_mp.field = field;
> +		if (set_fmts & FmtFlags)
> +			vfmt.fmt.pix_mp.flags = flags;
> +		if (set_fmts & FmtBytesPerLine) {
> +			for (unsigned i = 0; i < VIDEO_MAX_PLANES; i++)
> +				vfmt.fmt.pix_mp.plane_fmt[i].bytesperline =
> +					bytesperline[i];
> +		} else {
> +			/*
> +			 * G_FMT might return bytesperline values > width,
> +			 * reset them to 0 to force the driver to update them
> +			 * to the closest value for the new width.
> +			 */
> +			for (unsigned i = 0; i < vfmt.fmt.pix_mp.num_planes; i++)
> +				vfmt.fmt.pix_mp.plane_fmt[i].bytesperline = 0;
> +		}
> +	} else {
> +		if (set_fmts & FmtWidth)
> +			vfmt.fmt.pix.width = width;
> +		if (set_fmts & FmtHeight)
> +			vfmt.fmt.pix.height = height;
> +		if (set_fmts & FmtPixelFormat) {
> +			vfmt.fmt.pix.pixelformat = pixfmt;
> +			if (vfmt.fmt.pix.pixelformat < 256) {
> +				vfmt.fmt.pix.pixelformat =
> +					find_pixel_format(fd, vfmt.fmt.pix.pixelformat,
> +							  false, false);
>  			}
> +		}
> +		if (set_fmts & FmtField)
> +			vfmt.fmt.pix.field = field;
> +		if (set_fmts & FmtFlags)
> +			vfmt.fmt.pix.flags = flags;
> +		if (set_fmts & FmtBytesPerLine) {
> +			vfmt.fmt.pix.bytesperline = bytesperline[0];
> +		} else {
> +			/*
> +			 * G_FMT might return a bytesperline value > width,
> +			 * reset this to 0 to force the driver to update it
> +			 * to the closest value for the new width.
> +			 */
> +			vfmt.fmt.pix.bytesperline = 0;
> +		}
> +	}
> +	return 0;
> +}
> +
> +void vidcap_set(cv4l_fd &_fd)
> +{
> +	if (options[OptSetVideoFormat] || options[OptTryVideoFormat]) {
> +		int fd = _fd.g_fd();
> +		int ret;
> +		struct v4l2_format vfmt;
>  
> +		if (vidcap_get_and_update_fmt(_fd, vfmt) == 0) {
>  			if (options[OptSetVideoFormat])
>  				ret = doioctl(fd, VIDIOC_S_FMT, &vfmt);
>  			else
> diff --git a/utils/v4l2-ctl/v4l2-ctl.h b/utils/v4l2-ctl/v4l2-ctl.h
> index dcc39b51..739dc5a9 100644
> --- a/utils/v4l2-ctl/v4l2-ctl.h
> +++ b/utils/v4l2-ctl/v4l2-ctl.h
> @@ -348,6 +348,7 @@ void stds_list(cv4l_fd &fd);
>  // v4l2-ctl-vidcap.cpp
>  void vidcap_usage(void);
>  void vidcap_cmd(int ch, char *optarg);
> +int vidcap_get_and_update_fmt(cv4l_fd &_fd, struct v4l2_format &vfmt);
>  void vidcap_set(cv4l_fd &fd);
>  void vidcap_get(cv4l_fd &fd);
>  void vidcap_list(cv4l_fd &fd);
> 

