Return-Path: <SRS0=sYKt=QJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03574C282D7
	for <linux-media@archiver.kernel.org>; Sat,  2 Feb 2019 09:39:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B98A92083B
	for <linux-media@archiver.kernel.org>; Sat,  2 Feb 2019 09:39:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbfBBJjI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 2 Feb 2019 04:39:08 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:53814 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725857AbfBBJjI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Feb 2019 04:39:08 -0500
Received: from [IPv6:2001:67c:1810:f051:a2c6:c81d:4091:548b] ([IPv6:2001:67c:1810:f051:a2c6:c81d:4091:548b])
        by smtp-cloud8.xs4all.net with ESMTPA
        id prlLgfIowNR5yprlQgaCvZ; Sat, 02 Feb 2019 10:39:06 +0100
Subject: Re: [v4l-utils PATCH v3 1/1] v4l2-ctl: Add support for META_OUTPUT
 buffer type
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc:     rajmohan.mani@intel.com, yong.zhi@intel.com
References: <20190201135152.27782-1-sakari.ailus@linux.intel.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5c11be8d-e841-3a4a-bf3f-14936cb22ddd@xs4all.nl>
Date:   Sat, 2 Feb 2019 10:38:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190201135152.27782-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfJTZZPnOmrcXqNWPFVd/STde719qnn+RgR2aVBkIqfeRhArDQ8a+PSaKStajMRwZpJ4bWJaIOoR+gffBYgQTRU2nrVTdwodf4FlW+8ln/DYmVYik9wvS
 +bbhIzz+YehLG/TWbqys8JQ/DDOVvHfCdzAtAVIWPh6GtscoFkjRfdseiLv3lrjEjB6PfhtkdLgBzmzJCWIbDuxrRbn/rhvGo5XnA94clTMuUUc36Wl98/ZV
 kDpmSVAeK9iy5IqwQ+fEqqxaCpCiC2nOkb7CLasWEKUYpgQ8bYhC0osBh+ZsnGpzZwTXAIBwao9EmtNkDBTKjsQllrTEq2fVxIrwh/BkXTYr59S0wZKidKAl
 TkGDVoc6nlg7izy5R6jl7ErSDR3Inm1BGhrU5ggT01SZ2c33Gp0=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 02/01/2019 02:51 PM, Sakari Ailus wrote:
> Add support for META_OUTPUT buffer type to v4l2-ctl.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Hi Hans, others,
> 
> I've reworked the patch to match with the way SDR is implemented: the
> options for setting the format work independently of the node type.
> 
> I like this better than the previous one; there is much less redundant
> code now.
> 
>  utils/v4l2-ctl/v4l2-ctl-meta.cpp | 97 ++++++++++++++++++++++++++--------------
>  utils/v4l2-ctl/v4l2-ctl.cpp      |  7 +++
>  utils/v4l2-ctl/v4l2-ctl.h        |  5 +++
>  3 files changed, 76 insertions(+), 33 deletions(-)
> 
> diff --git a/utils/v4l2-ctl/v4l2-ctl-meta.cpp b/utils/v4l2-ctl/v4l2-ctl-meta.cpp

<snip>

> +void __meta_get(cv4l_fd &fd, __32 type)

__32???

This clearly hasn't even been compile tested.

I also saw a pile of compiler warnings elsewhere after applying this patch.

I'm not sure what happened, perhaps an old version of the patch was accidentally
posted, but I'll wait for a v4.

Regards,

	Hans

> +{
> +	vfmt.type = type;
> +	if (doioctl(fd.g_fd(), VIDIOC_G_FMT, &vfmt) == 0)
> +		printfmt(fd.g_fd(), vfmt);
>  }
>  
>  void meta_get(cv4l_fd &fd)
>  {
> -	if (options[OptGetMetaFormat] && v4l_type_is_meta(fd.g_type())) {
> -		vfmt.type = fd.g_type();
> -		if (doioctl(fd.g_fd(), VIDIOC_G_FMT, &vfmt) == 0)
> -			printfmt(fd.g_fd(), vfmt);
> -	}
> +	if (options[OptGetMetaFormat])
> +		__meta_get(fd, V4L2_BUF_TYPE_META_CAPTURE);
> +	if (options[OptGetMetaOutFormat])
> +		__meta_get(fd, V4L2_BUF_TYPE_META_OUTPUT);
>  }
>  
>  void meta_list(cv4l_fd &fd)
>  {
> -	if (options[OptListMetaFormats] && v4l_type_is_meta(fd.g_type())) {
> +	if (options[OptListMetaFormats]) {
> +		printf("ioctl: VIDIOC_ENUM_FMT\n");
> +		print_video_formats(fd, V4L2_BUF_TYPE_META_CAPTURE);
> +	}
> +
> +	if (options[OptListMetaOutFormats]) {
>  		printf("ioctl: VIDIOC_ENUM_FMT\n");
> -		print_video_formats(fd, fd.g_type());
> +		print_video_formats(fd, V4L2_BUF_TYPE_META_OUTPUT);
>  	}
>  }
> diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
> index fc19798c06..e61f9d0f38 100644
> --- a/utils/v4l2-ctl/v4l2-ctl.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl.cpp
> @@ -123,6 +123,7 @@ static struct option long_options[] = {
>  	{"list-formats-out", no_argument, 0, OptListOutFormats},
>  	{"list-formats-out-ext", no_argument, 0, OptListOutFormatsExt},
>  	{"list-formats-meta", no_argument, 0, OptListMetaFormats},
> +	{"list-formats-meta-out", no_argument, 0, OptListMetaOutFormats},
>  	{"list-subdev-mbus-codes", optional_argument, 0, OptListSubDevMBusCodes},
>  	{"list-subdev-framesizes", required_argument, 0, OptListSubDevFrameSizes},
>  	{"list-subdev-frameintervals", required_argument, 0, OptListSubDevFrameIntervals},
> @@ -175,6 +176,9 @@ static struct option long_options[] = {
>  	{"get-fmt-meta", no_argument, 0, OptGetMetaFormat},
>  	{"set-fmt-meta", required_argument, 0, OptSetMetaFormat},
>  	{"try-fmt-meta", required_argument, 0, OptTryMetaFormat},
> +	{"get-fmt-meta-out", no_argument, 0, OptGetMetaOutFormat},
> +	{"set-fmt-meta-out", required_argument, 0, OptSetMetaOutFormat},
> +	{"try-fmt-meta-out", required_argument, 0, OptTryMetaOutFormat},
>  	{"get-subdev-fmt", optional_argument, 0, OptGetSubDevFormat},
>  	{"set-subdev-fmt", required_argument, 0, OptSetSubDevFormat},
>  	{"try-subdev-fmt", required_argument, 0, OptTrySubDevFormat},
> @@ -239,6 +243,7 @@ static struct option long_options[] = {
>  	{"list-buffers-sdr", no_argument, 0, OptListBuffersSdr},
>  	{"list-buffers-sdr-out", no_argument, 0, OptListBuffersSdrOut},
>  	{"list-buffers-meta", no_argument, 0, OptListBuffersMeta},
> +	{"list-buffers-meta-out", no_argument, 0, OptListBuffersMetaOut},
>  	{"stream-count", required_argument, 0, OptStreamCount},
>  	{"stream-skip", required_argument, 0, OptStreamSkip},
>  	{"stream-loop", no_argument, 0, OptStreamLoop},
> @@ -508,6 +513,7 @@ void printfmt(int fd, const struct v4l2_format &vfmt)
>  		printf("\tBuffer Size     : %u\n", vfmt.fmt.sdr.buffersize);
>  		break;
>  	case V4L2_BUF_TYPE_META_CAPTURE:
> +	case V4L2_BUF_TYPE_META_OUTPUT:
>  		printf("\tSample Format   : '%s'%s\n", fcc2s(vfmt.fmt.meta.dataformat).c_str(),
>  		       printfmtname(fd, vfmt.type, vfmt.fmt.meta.dataformat).c_str());
>  		printf("\tBuffer Size     : %u\n", vfmt.fmt.meta.buffersize);
> @@ -1275,6 +1281,7 @@ int main(int argc, char **argv)
>  		options[OptGetSdrFormat] = 1;
>  		options[OptGetSdrOutFormat] = 1;
>  		options[OptGetMetaFormat] = 1;
> +		options[OptGetMetaOutFormat] = 1;
>  		options[OptGetFBuf] = 1;
>  		options[OptGetCropCap] = 1;
>  		options[OptGetOutputCropCap] = 1;
> diff --git a/utils/v4l2-ctl/v4l2-ctl.h b/utils/v4l2-ctl/v4l2-ctl.h
> index 739dc5a9fe..a6bd020769 100644
> --- a/utils/v4l2-ctl/v4l2-ctl.h
> +++ b/utils/v4l2-ctl/v4l2-ctl.h
> @@ -90,6 +90,7 @@ enum Option {
>  	OptGetSdrFormat,
>  	OptGetSdrOutFormat,
>  	OptGetMetaFormat,
> +	OptGetMetaOutFormat,
>  	OptGetSubDevFormat,
>  	OptSetSlicedVbiOutFormat,
>  	OptSetOverlayFormat,
> @@ -98,6 +99,7 @@ enum Option {
>  	OptSetSdrFormat,
>  	OptSetSdrOutFormat,
>  	OptSetMetaFormat,
> +	OptSetMetaOutFormat,
>  	OptSetSubDevFormat,
>  	OptTryVideoOutFormat,
>  	OptTrySlicedVbiOutFormat,
> @@ -109,6 +111,7 @@ enum Option {
>  	OptTrySdrFormat,
>  	OptTrySdrOutFormat,
>  	OptTryMetaFormat,
> +	OptTryMetaOutFormat,
>  	OptTrySubDevFormat,
>  	OptAll,
>  	OptListStandards,
> @@ -123,6 +126,7 @@ enum Option {
>  	OptListOutFormats,
>  	OptListOutFormatsExt,
>  	OptListMetaFormats,
> +	OptListMetaOutFormats,
>  	OptListSubDevMBusCodes,
>  	OptListSubDevFrameSizes,
>  	OptListSubDevFrameIntervals,
> @@ -206,6 +210,7 @@ enum Option {
>  	OptListBuffersSdr,
>  	OptListBuffersSdrOut,
>  	OptListBuffersMeta,
> +	OptListBuffersMetaOut,
>  	OptStreamCount,
>  	OptStreamSkip,
>  	OptStreamLoop,
> 

