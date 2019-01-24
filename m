Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D00C282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 08:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF98021872
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 08:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbfAXIoU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 03:44:20 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:56358 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725986AbfAXIoU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 03:44:20 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id macPgVxe8NR5ymacSgotz9; Thu, 24 Jan 2019 09:44:16 +0100
Subject: Re: [yavta PATCH v2 1/1] v4l2-ctl: Add support for META_OUTPUT buffer
 type
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc:     rajmohan.mani@intel.com, yong.zhi@intel.com
References: <20190122120526.32112-1-sakari.ailus@linux.intel.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <00a7a90a-1f56-1fa3-c565-5f5b18539ea8@xs4all.nl>
Date:   Thu, 24 Jan 2019 09:44:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190122120526.32112-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfD+cNaV0W6qutTMvMPLYMlkbtgthV1MeIjY3r+0mIJ28V3/pfWNFP+izQh01cr3WOr8j6abrW10Ve09HFwecQxV8236MAxbC7S9cjFW26pSKIFhXJVvf
 QuAOGWIkHSiwevpgwSqsJ24s2lde2EAbtAQUKk1F/h/IqCJbse42labAkuhnjk8SEtOvvhy68PI3taOB5yfpDFeoZVqrzIfYxHPeR4XHjgwwHmMWHJu1i6Ze
 yDZ7tjf352GoF8GrFVqmJ7Bd0maHLVZkq40PJSYY6bH16AzLNQPxaDWfODqz8wDZ
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Note: the subject it wrong, it's v4l-utils, not yavta.

On 1/22/19 1:05 PM, Sakari Ailus wrote:
> Add support for META_OUTPUT buffer type to v4l2-ctl.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Hi Hans,
> 
> Here's an update for the meta output buffer type in v4l2-ctl.
> 
> Since v1:
> 
> - Merge help text for meta and meta out buffer types
> 
> - Unify implementation for meta format handling
> 
>  utils/v4l2-ctl/v4l2-ctl-meta.cpp | 71 ++++++++++++++++++++++++++++++++++++----
>  utils/v4l2-ctl/v4l2-ctl.cpp      |  7 ++++
>  utils/v4l2-ctl/v4l2-ctl.h        |  5 +++
>  3 files changed, 76 insertions(+), 7 deletions(-)
> 
> diff --git a/utils/v4l2-ctl/v4l2-ctl-meta.cpp b/utils/v4l2-ctl/v4l2-ctl-meta.cpp
> index 37c91940a8..f4aa434937 100644
> --- a/utils/v4l2-ctl/v4l2-ctl-meta.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl-meta.cpp
> @@ -21,14 +21,22 @@ static struct v4l2_format vfmt;	/* set_format/get_format */
>  void meta_usage(void)
>  {
>  	printf("\nMetadata Formats options:\n"
> -	       "  --list-formats-meta display supported metadata formats [VIDIOC_ENUM_FMT]\n"
> -	       "  --get-fmt-meta      query the metadata format [VIDIOC_G_FMT]\n"
> -	       "  --set-fmt-meta <f>  set the metadata format [VIDIOC_S_FMT]\n"
> +	       "  --list-formats-meta display supported metadata capture formats [VIDIOC_ENUM_FMT]\n"
> +	       "  --get-fmt-meta      query the metadata capture format [VIDIOC_G_FMT]\n"
> +	       "  --set-fmt-meta <f>  set the metadata capture format [VIDIOC_S_FMT]\n"
>  	       "                     parameter is either the format index as reported by\n"
>  	       "                     --list-formats-meta, or the fourcc value as a string\n"
> -	       "  --try-fmt-meta <f>  try the metadata format [VIDIOC_TRY_FMT]\n"
> +	       "  --try-fmt-meta <f>  try the metadata capture format [VIDIOC_TRY_FMT]\n"
>  	       "                     parameter is either the format index as reported by\n"
>  	       "                     --list-formats-meta, or the fourcc value as a string\n"
> +	       "  --list-formats-meta-out display supported metadata output formats [VIDIOC_ENUM_FMT]\n"
> +	       "  --get-fmt-meta-out      query the metadata output format [VIDIOC_G_FMT]\n"
> +	       "  --set-fmt-meta-out <f>  set the metadata output format [VIDIOC_S_FMT]\n"
> +	       "                          parameter is either the format index as reported by\n"
> +	       "                          --list-formats-meta-out, or the fourcc value as a string\n"
> +	       "  --try-fmt-meta-out <f>  try the metadata output format [VIDIOC_TRY_FMT]\n"
> +	       "                          parameter is either the format index as reported by\n"
> +	       "                          --list-formats-meta-out, or the fourcc value as a string\n"
>  	       );
>  }
>  
> @@ -37,6 +45,8 @@ void meta_cmd(int ch, char *optarg)
>  	switch (ch) {
>  	case OptSetMetaFormat:
>  	case OptTryMetaFormat:
> +	case OptSetMetaOutFormat:
> +	case OptTryMetaOutFormat:
>  		if (strlen(optarg) == 0) {
>  			meta_usage();
>  			exit(1);
> @@ -55,8 +65,38 @@ void meta_set(cv4l_fd &_fd)
>  	int fd = _fd.g_fd();
>  	int ret;
>  
> +	if (!v4l_type_is_meta(_fd.g_type()))
> +		return;
> +
>  	if ((options[OptSetMetaFormat] || options[OptTryMetaFormat]) &&
> -	    v4l_type_is_meta(_fd.g_type())) {
> +	    v4l_type_is_capture(_fd.g_type())) {
> +		struct v4l2_format in_vfmt;
> +
> +		in_vfmt.type = _fd.g_type();
> +		in_vfmt.fmt.meta.dataformat = vfmt.fmt.meta.dataformat;
> +
> +		if (in_vfmt.fmt.meta.dataformat < 256) {
> +			struct v4l2_fmtdesc fmt;
> +
> +			fmt.index = in_vfmt.fmt.meta.dataformat;
> +			fmt.type = in_vfmt.type;
> +
> +			if (doioctl(fd, VIDIOC_ENUM_FMT, &fmt))
> +				fmt.pixelformat = 0;
> +
> +			in_vfmt.fmt.meta.dataformat = fmt.pixelformat;
> +		}
> +
> +		if (options[OptSetMetaFormat])
> +			ret = doioctl(fd, VIDIOC_S_FMT, &in_vfmt);
> +		else
> +			ret = doioctl(fd, VIDIOC_TRY_FMT, &in_vfmt);
> +		if (ret == 0 && (verbose || options[OptTryMetaFormat]))
> +			printfmt(fd, in_vfmt);

This is exactly the same code for meta output. Why not just do:

  	if ((options[OptSetMetaFormat] || options[OptTryMetaFormat] ||
	     options[OptSetMetaOutFormat] || options[OptTryMetaOutFormat]) &&
	    v4l_type_is_meta(_fd.g_type())

You can add tests for capture/output if you like, but it is not really necessary.


> +	}
> +
> +	if ((options[OptSetMetaOutFormat] || options[OptTryMetaOutFormat]) &&
> +	    v4l_type_is_output(_fd.g_type())) {
>  		struct v4l2_format in_vfmt;
>  
>  		in_vfmt.type = _fd.g_type();
> @@ -85,7 +125,16 @@ void meta_set(cv4l_fd &_fd)
>  
>  void meta_get(cv4l_fd &fd)
>  {
> -	if (options[OptGetMetaFormat] && v4l_type_is_meta(fd.g_type())) {
> +	if (!v4l_type_is_meta(fd.g_type()))
> +		return;
> +
> +	if (options[OptGetMetaFormat] && v4l_type_is_capture(fd.g_type())) {
> +		vfmt.type = fd.g_type();
> +		if (doioctl(fd.g_fd(), VIDIOC_G_FMT, &vfmt) == 0)
> +			printfmt(fd.g_fd(), vfmt);
> +	}
> +
> +	if (options[OptGetMetaOutFormat] && v4l_type_is_output(fd.g_type())) {
>  		vfmt.type = fd.g_type();
>  		if (doioctl(fd.g_fd(), VIDIOC_G_FMT, &vfmt) == 0)
>  			printfmt(fd.g_fd(), vfmt);
> @@ -94,7 +143,15 @@ void meta_get(cv4l_fd &fd)
>  
>  void meta_list(cv4l_fd &fd)
>  {
> -	if (options[OptListMetaFormats] && v4l_type_is_meta(fd.g_type())) {
> +	if (!v4l_type_is_meta(fd.g_type()))
> +		return;
> +
> +	if (options[OptListMetaFormats] && v4l_type_is_capture(fd.g_type())) {
> +		printf("ioctl: VIDIOC_ENUM_FMT\n");
> +		print_video_formats(fd, fd.g_type());
> +	}
> +
> +	if (options[OptListMetaOutFormats] && v4l_type_is_output(fd.g_type())) {
>  		printf("ioctl: VIDIOC_ENUM_FMT\n");
>  		print_video_formats(fd, fd.g_type());
>  	}

Same for these two functions: the same code works for both meta capture and output.

To be honest, I would really like to completely rework the way v4l2-ctl handles this.
There are way too many options to list, get, set, try formats. But you really don't
need to specify the type (video, meta, sdr, vbi, etc) as that can be determined
automatically.

But let's get this done first, and then I'll take another look at this.

Regards,

	Hans


> diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
> index 1783979d76..ffac8716d0 100644
> --- a/utils/v4l2-ctl/v4l2-ctl.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl.cpp
> @@ -122,6 +122,7 @@ static struct option long_options[] = {
>  	{"list-formats-out", no_argument, 0, OptListOutFormats},
>  	{"list-formats-out-ext", no_argument, 0, OptListOutFormatsExt},
>  	{"list-formats-meta", no_argument, 0, OptListMetaFormats},
> +	{"list-formats-meta-out", no_argument, 0, OptListMetaOutFormats},
>  	{"list-subdev-mbus-codes", optional_argument, 0, OptListSubDevMBusCodes},
>  	{"list-subdev-framesizes", required_argument, 0, OptListSubDevFrameSizes},
>  	{"list-subdev-frameintervals", required_argument, 0, OptListSubDevFrameIntervals},
> @@ -174,6 +175,9 @@ static struct option long_options[] = {
>  	{"get-fmt-meta", no_argument, 0, OptGetMetaFormat},
>  	{"set-fmt-meta", required_argument, 0, OptSetMetaFormat},
>  	{"try-fmt-meta", required_argument, 0, OptTryMetaFormat},
> +	{"get-fmt-meta-out", no_argument, 0, OptGetMetaOutFormat},
> +	{"set-fmt-meta-out", required_argument, 0, OptSetMetaOutFormat},
> +	{"try-fmt-meta-out", required_argument, 0, OptTryMetaOutFormat},
>  	{"get-subdev-fmt", optional_argument, 0, OptGetSubDevFormat},
>  	{"set-subdev-fmt", required_argument, 0, OptSetSubDevFormat},
>  	{"try-subdev-fmt", required_argument, 0, OptTrySubDevFormat},
> @@ -238,6 +242,7 @@ static struct option long_options[] = {
>  	{"list-buffers-sdr", no_argument, 0, OptListBuffersSdr},
>  	{"list-buffers-sdr-out", no_argument, 0, OptListBuffersSdrOut},
>  	{"list-buffers-meta", no_argument, 0, OptListBuffersMeta},
> +	{"list-buffers-meta-out", no_argument, 0, OptListBuffersMetaOut},
>  	{"stream-count", required_argument, 0, OptStreamCount},
>  	{"stream-skip", required_argument, 0, OptStreamSkip},
>  	{"stream-loop", no_argument, 0, OptStreamLoop},
> @@ -507,6 +512,7 @@ void printfmt(int fd, const struct v4l2_format &vfmt)
>  		printf("\tBuffer Size     : %u\n", vfmt.fmt.sdr.buffersize);
>  		break;
>  	case V4L2_BUF_TYPE_META_CAPTURE:
> +	case V4L2_BUF_TYPE_META_OUTPUT:
>  		printf("\tSample Format   : '%s'%s\n", fcc2s(vfmt.fmt.meta.dataformat).c_str(),
>  		       printfmtname(fd, vfmt.type, vfmt.fmt.meta.dataformat).c_str());
>  		printf("\tBuffer Size     : %u\n", vfmt.fmt.meta.buffersize);
> @@ -1247,6 +1253,7 @@ int main(int argc, char **argv)
>  		options[OptGetSdrFormat] = 1;
>  		options[OptGetSdrOutFormat] = 1;
>  		options[OptGetMetaFormat] = 1;
> +		options[OptGetMetaOutFormat] = 1;
>  		options[OptGetFBuf] = 1;
>  		options[OptGetCropCap] = 1;
>  		options[OptGetOutputCropCap] = 1;
> diff --git a/utils/v4l2-ctl/v4l2-ctl.h b/utils/v4l2-ctl/v4l2-ctl.h
> index 5a52a0a48f..fc51cd1b97 100644
> --- a/utils/v4l2-ctl/v4l2-ctl.h
> +++ b/utils/v4l2-ctl/v4l2-ctl.h
> @@ -89,6 +89,7 @@ enum Option {
>  	OptGetSdrFormat,
>  	OptGetSdrOutFormat,
>  	OptGetMetaFormat,
> +	OptGetMetaOutFormat,
>  	OptGetSubDevFormat,
>  	OptSetSlicedVbiOutFormat,
>  	OptSetOverlayFormat,
> @@ -97,6 +98,7 @@ enum Option {
>  	OptSetSdrFormat,
>  	OptSetSdrOutFormat,
>  	OptSetMetaFormat,
> +	OptSetMetaOutFormat,
>  	OptSetSubDevFormat,
>  	OptTryVideoOutFormat,
>  	OptTrySlicedVbiOutFormat,
> @@ -108,6 +110,7 @@ enum Option {
>  	OptTrySdrFormat,
>  	OptTrySdrOutFormat,
>  	OptTryMetaFormat,
> +	OptTryMetaOutFormat,
>  	OptTrySubDevFormat,
>  	OptAll,
>  	OptListStandards,
> @@ -122,6 +125,7 @@ enum Option {
>  	OptListOutFormats,
>  	OptListOutFormatsExt,
>  	OptListMetaFormats,
> +	OptListMetaOutFormats,
>  	OptListSubDevMBusCodes,
>  	OptListSubDevFrameSizes,
>  	OptListSubDevFrameIntervals,
> @@ -205,6 +209,7 @@ enum Option {
>  	OptListBuffersSdr,
>  	OptListBuffersSdrOut,
>  	OptListBuffersMeta,
> +	OptListBuffersMetaOut,
>  	OptStreamCount,
>  	OptStreamSkip,
>  	OptStreamLoop,
> 

