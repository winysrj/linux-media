Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99506C282C4
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 08:19:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6682B20861
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 08:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727342AbfAVITt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 03:19:49 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:52181 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727253AbfAVITs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 03:19:48 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id lrHagkoYIBDyIlrHegSql5; Tue, 22 Jan 2019 09:19:46 +0100
Subject: Re: [v4l-utils PATCH 4/4] v4l2-ctl: Add support for META_OUTPUT
 buffer type
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc:     rajmohan.mani@intel.com, yong.zhi@intel.com
References: <20190114141308.29329-1-sakari.ailus@linux.intel.com>
 <20190114141308.29329-5-sakari.ailus@linux.intel.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4bb84871-1871-74a0-1093-8e460db46634@xs4all.nl>
Date:   Tue, 22 Jan 2019 09:19:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20190114141308.29329-5-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfEPN8sVWAUG0U3CSnerJnvH4+1uXqVa3ZwXbX+7TrkM3X6naQQDkVUvozJWY3zv/P0874eICQMLLPo40WRTtL1EpF1vmMN5t5vt1EfMMpM9TZ/f1YYLs
 72fesnoad7yDePrGtDxWSRCqT/Q/ydR5FzJXUdcobfX8scWyc7z+mInuz0Q++JBvvnYSZywJmjKR34xtyPbW6tB2tW553iTT0AkOSs/sRgr38AlDM7bewZ7G
 mfxdEoHg/2FQl1x7BKumItkcIX4/e9i+wLvbYeBe/wr1OyNGTBNDFIbDtM5TV1Eh
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

Can you check if this patch is needed at all? The latest v4l2-ctl should work
for both meta capture and output, i.e. all meta options (v4l2-ctl --help-meta)
just look up the buffer type of the video device and use that to list/set/get/try
the formats.

Regards,

	Hans

On 01/14/2019 03:13 PM, Sakari Ailus wrote:
> Add support for META_OUTPUT buffer type to v4l2-ctl.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  utils/v4l2-ctl/Makefile.am           |   3 +-
>  utils/v4l2-ctl/v4l2-ctl-common.cpp   |   3 +-
>  utils/v4l2-ctl/v4l2-ctl-meta-out.cpp | 106 +++++++++++++++++++++++++++++++++++
>  utils/v4l2-ctl/v4l2-ctl-meta.cpp     |  19 ++++---
>  utils/v4l2-ctl/v4l2-ctl.cpp          |  16 ++++++
>  utils/v4l2-ctl/v4l2-ctl.h            |  13 +++++
>  6 files changed, 150 insertions(+), 10 deletions(-)
>  create mode 100644 utils/v4l2-ctl/v4l2-ctl-meta-out.cpp
> 
> diff --git a/utils/v4l2-ctl/Makefile.am b/utils/v4l2-ctl/Makefile.am
> index f612e0eee4..2b99a95e41 100644
> --- a/utils/v4l2-ctl/Makefile.am
> +++ b/utils/v4l2-ctl/Makefile.am
> @@ -7,7 +7,8 @@ v4l2_ctl_SOURCES = v4l2-ctl.cpp v4l2-ctl.h v4l2-ctl-common.cpp v4l2-ctl-tuner.cp
>  	v4l2-ctl-overlay.cpp v4l2-ctl-vbi.cpp v4l2-ctl-selection.cpp v4l2-ctl-misc.cpp \
>  	v4l2-ctl-streaming.cpp v4l2-ctl-sdr.cpp v4l2-ctl-edid.cpp v4l2-ctl-modes.cpp \
>  	v4l2-ctl-subdev.cpp v4l2-tpg-colors.c v4l2-tpg-core.c v4l-stream.c v4l2-ctl-meta.cpp \
> -	media-info.cpp v4l2-info.cpp codec-fwht.c codec-v4l2-fwht.c
> +	v4l2-ctl-meta-out.cpp media-info.cpp v4l2-info.cpp codec-fwht.c \
> +	codec-v4l2-fwht.c
>  v4l2_ctl_CPPFLAGS = -I$(top_srcdir)/utils/common
>  
>  media-bus-format-names.h: ../../include/linux/media-bus-format.h
> diff --git a/utils/v4l2-ctl/v4l2-ctl-common.cpp b/utils/v4l2-ctl/v4l2-ctl-common.cpp
> index e2710335ec..ffe4627498 100644
> --- a/utils/v4l2-ctl/v4l2-ctl-common.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl-common.cpp
> @@ -70,7 +70,8 @@ void common_usage(void)
>  	       "  -h, --help         display this help message\n"
>  	       "  --help-all         all options\n"
>  	       "  --help-io          input/output options\n"
> -	       "  --help-meta        metadata format options\n"
> +	       "  --help-meta        metadata capture format options\n"
> +	       "  --help-meta-out    metadata output format options\n"
>  	       "  --help-misc        miscellaneous options\n"
>  	       "  --help-overlay     overlay format options\n"
>  	       "  --help-sdr         SDR format options\n"
> diff --git a/utils/v4l2-ctl/v4l2-ctl-meta-out.cpp b/utils/v4l2-ctl/v4l2-ctl-meta-out.cpp
> new file mode 100644
> index 0000000000..3ffeee0ee5
> --- /dev/null
> +++ b/utils/v4l2-ctl/v4l2-ctl-meta-out.cpp
> @@ -0,0 +1,106 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <unistd.h>
> +#include <stdlib.h>
> +#include <stdio.h>
> +#include <string.h>
> +#include <inttypes.h>
> +#include <getopt.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <fcntl.h>
> +#include <ctype.h>
> +#include <errno.h>
> +#include <sys/ioctl.h>
> +#include <sys/time.h>
> +#include <dirent.h>
> +#include <math.h>
> +
> +#include "v4l2-ctl.h"
> +
> +static struct v4l2_format vfmt;	/* set_format/get_format */
> +
> +void meta_out_usage(void)
> +{
> +	printf("\nMetadata Output Formats options:\n"
> +	       "  --list-formats-meta-out display supported metadata output formats [VIDIOC_ENUM_FMT]\n"
> +	       "  --get-fmt-meta-out      query the metadata output format [VIDIOC_G_FMT]\n"
> +	       "  --set-fmt-meta-out <f>  set the metadata output format [VIDIOC_S_FMT]\n"
> +	       "                          parameter is either the format index as reported by\n"
> +	       "                          --list-formats-meta-out, or the fourcc value as a string\n"
> +	       "  --try-fmt-meta-out <f>  try the metadata output format [VIDIOC_TRY_FMT]\n"
> +	       "                          parameter is either the format index as reported by\n"
> +	       "                          --list-formats-meta-out, or the fourcc value as a string\n"
> +	       );
> +}
> +
> +void meta_out_cmd(int ch, char *optarg)
> +{
> +	switch (ch) {
> +	case OptSetMetaOutFormat:
> +	case OptTryMetaOutFormat:
> +		if (strlen(optarg) == 0) {
> +			meta_out_usage();
> +			exit(1);
> +		} else if (strlen(optarg) == 4) {
> +			vfmt.fmt.meta.dataformat = v4l2_fourcc(optarg[0],
> +					optarg[1], optarg[2], optarg[3]);
> +		} else {
> +			vfmt.fmt.meta.dataformat = strtol(optarg, 0L, 0);
> +		}
> +		break;
> +	}
> +}
> +
> +void meta_out_set(cv4l_fd &_fd)
> +{
> +	int fd = _fd.g_fd();
> +	int ret;
> +
> +	if ((options[OptSetMetaOutFormat] || options[OptTryMetaOutFormat]) &&
> +	    v4l_type_is_meta(_fd.g_type()) &&
> +	    v4l_type_is_output(_fd.g_type())) {
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
> +	}
> +}
> +
> +void meta_out_get(cv4l_fd &fd)
> +{
> +	if (options[OptGetMetaOutFormat] && v4l_type_is_meta(fd.g_type()) &&
> +	    v4l_type_is_output(fd.g_type())) {
> +		vfmt.type = fd.g_type();
> +		if (doioctl(fd.g_fd(), VIDIOC_G_FMT, &vfmt) == 0)
> +			printfmt(fd.g_fd(), vfmt);
> +	}
> +}
> +
> +void meta_out_list(cv4l_fd &fd)
> +{
> +	if (options[OptListMetaOutFormats] && v4l_type_is_meta(fd.g_type()) &&
> +	    v4l_type_is_output(fd.g_type())) {
> +		printf("ioctl: VIDIOC_ENUM_FMT\n");
> +		print_video_formats(fd, fd.g_type());
> +	}
> +}
> diff --git a/utils/v4l2-ctl/v4l2-ctl-meta.cpp b/utils/v4l2-ctl/v4l2-ctl-meta.cpp
> index 37c91940a8..32060832f0 100644
> --- a/utils/v4l2-ctl/v4l2-ctl-meta.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl-meta.cpp
> @@ -20,13 +20,13 @@ static struct v4l2_format vfmt;	/* set_format/get_format */
>  
>  void meta_usage(void)
>  {
> -	printf("\nMetadata Formats options:\n"
> -	       "  --list-formats-meta display supported metadata formats [VIDIOC_ENUM_FMT]\n"
> -	       "  --get-fmt-meta      query the metadata format [VIDIOC_G_FMT]\n"
> -	       "  --set-fmt-meta <f>  set the metadata format [VIDIOC_S_FMT]\n"
> +	printf("\nMetadata Capture Formats options:\n"
> +	       "  --list-formats-meta display supported metadata capture formats [VIDIOC_ENUM_FMT]\n"
> +	       "  --get-fmt-meta      query the metadata capture format [VIDIOC_G_FMT]\n"
> +	       "  --set-fmt-meta <f>  set the metadata capture format [VIDIOC_S_FMT]\n"
>  	       "                     parameter is either the format index as reported by\n"
>  	       "                     --list-formats-meta, or the fourcc value as a string\n"
> -	       "  --try-fmt-meta <f>  try the metadata format [VIDIOC_TRY_FMT]\n"
> +	       "  --try-fmt-meta <f>  try the metadata capture format [VIDIOC_TRY_FMT]\n"
>  	       "                     parameter is either the format index as reported by\n"
>  	       "                     --list-formats-meta, or the fourcc value as a string\n"
>  	       );
> @@ -56,7 +56,8 @@ void meta_set(cv4l_fd &_fd)
>  	int ret;
>  
>  	if ((options[OptSetMetaFormat] || options[OptTryMetaFormat]) &&
> -	    v4l_type_is_meta(_fd.g_type())) {
> +	    v4l_type_is_meta(_fd.g_type()) &&
> +	    v4l_type_is_capture(_fd.g_type())) {
>  		struct v4l2_format in_vfmt;
>  
>  		in_vfmt.type = _fd.g_type();
> @@ -85,7 +86,8 @@ void meta_set(cv4l_fd &_fd)
>  
>  void meta_get(cv4l_fd &fd)
>  {
> -	if (options[OptGetMetaFormat] && v4l_type_is_meta(fd.g_type())) {
> +	if (options[OptGetMetaFormat] && v4l_type_is_meta(fd.g_type()) &&
> +	    v4l_type_is_capture(fd.g_type())) {
>  		vfmt.type = fd.g_type();
>  		if (doioctl(fd.g_fd(), VIDIOC_G_FMT, &vfmt) == 0)
>  			printfmt(fd.g_fd(), vfmt);
> @@ -94,7 +96,8 @@ void meta_get(cv4l_fd &fd)
>  
>  void meta_list(cv4l_fd &fd)
>  {
> -	if (options[OptListMetaFormats] && v4l_type_is_meta(fd.g_type())) {
> +	if (options[OptListMetaFormats] && v4l_type_is_meta(fd.g_type()) &&
> +	    v4l_type_is_capture(fd.g_type())) {
>  		printf("ioctl: VIDIOC_ENUM_FMT\n");
>  		print_video_formats(fd, fd.g_type());
>  	}
> diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
> index 1783979d76..81a66938b6 100644
> --- a/utils/v4l2-ctl/v4l2-ctl.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl.cpp
> @@ -88,6 +88,7 @@ static struct option long_options[] = {
>  	{"help-vbi", no_argument, 0, OptHelpVbi},
>  	{"help-sdr", no_argument, 0, OptHelpSdr},
>  	{"help-meta", no_argument, 0, OptHelpMeta},
> +	{"help-meta-out", no_argument, 0, OptHelpMetaOut},
>  	{"help-subdev", no_argument, 0, OptHelpSubDev},
>  	{"help-selection", no_argument, 0, OptHelpSelection},
>  	{"help-misc", no_argument, 0, OptHelpMisc},
> @@ -122,6 +123,7 @@ static struct option long_options[] = {
>  	{"list-formats-out", no_argument, 0, OptListOutFormats},
>  	{"list-formats-out-ext", no_argument, 0, OptListOutFormatsExt},
>  	{"list-formats-meta", no_argument, 0, OptListMetaFormats},
> +	{"list-formats-meta-out", no_argument, 0, OptListMetaOutFormats},
>  	{"list-subdev-mbus-codes", optional_argument, 0, OptListSubDevMBusCodes},
>  	{"list-subdev-framesizes", required_argument, 0, OptListSubDevFrameSizes},
>  	{"list-subdev-frameintervals", required_argument, 0, OptListSubDevFrameIntervals},
> @@ -174,6 +176,9 @@ static struct option long_options[] = {
>  	{"get-fmt-meta", no_argument, 0, OptGetMetaFormat},
>  	{"set-fmt-meta", required_argument, 0, OptSetMetaFormat},
>  	{"try-fmt-meta", required_argument, 0, OptTryMetaFormat},
> +	{"get-fmt-meta-out", no_argument, 0, OptGetMetaOutFormat},
> +	{"set-fmt-meta-out", required_argument, 0, OptSetMetaOutFormat},
> +	{"try-fmt-meta-out", required_argument, 0, OptTryMetaOutFormat},
>  	{"get-subdev-fmt", optional_argument, 0, OptGetSubDevFormat},
>  	{"set-subdev-fmt", required_argument, 0, OptSetSubDevFormat},
>  	{"try-subdev-fmt", required_argument, 0, OptTrySubDevFormat},
> @@ -238,6 +243,7 @@ static struct option long_options[] = {
>  	{"list-buffers-sdr", no_argument, 0, OptListBuffersSdr},
>  	{"list-buffers-sdr-out", no_argument, 0, OptListBuffersSdrOut},
>  	{"list-buffers-meta", no_argument, 0, OptListBuffersMeta},
> +	{"list-buffers-meta-out", no_argument, 0, OptListBuffersMetaOut},
>  	{"stream-count", required_argument, 0, OptStreamCount},
>  	{"stream-skip", required_argument, 0, OptStreamSkip},
>  	{"stream-loop", no_argument, 0, OptStreamLoop},
> @@ -290,6 +296,7 @@ static void usage_all(void)
>         vbi_usage();
>         sdr_usage();
>         meta_usage();
> +       meta_out_usage();
>         selection_usage();
>         misc_usage();
>         streaming_usage();
> @@ -507,6 +514,7 @@ void printfmt(int fd, const struct v4l2_format &vfmt)
>  		printf("\tBuffer Size     : %u\n", vfmt.fmt.sdr.buffersize);
>  		break;
>  	case V4L2_BUF_TYPE_META_CAPTURE:
> +	case V4L2_BUF_TYPE_META_OUTPUT:
>  		printf("\tSample Format   : '%s'%s\n", fcc2s(vfmt.fmt.meta.dataformat).c_str(),
>  		       printfmtname(fd, vfmt.type, vfmt.fmt.meta.dataformat).c_str());
>  		printf("\tBuffer Size     : %u\n", vfmt.fmt.meta.buffersize);
> @@ -1039,6 +1047,9 @@ int main(int argc, char **argv)
>  		case OptHelpMeta:
>  			meta_usage();
>  			return 0;
> +		case OptHelpMetaOut:
> +			meta_out_usage();
> +			return 0;
>  		case OptHelpSubDev:
>  			subdev_usage();
>  			return 0;
> @@ -1109,6 +1120,7 @@ int main(int argc, char **argv)
>  			vbi_cmd(ch, optarg);
>  			sdr_cmd(ch, optarg);
>  			meta_cmd(ch, optarg);
> +			meta_out_cmd(ch, optarg);
>  			subdev_cmd(ch, optarg);
>  			selection_cmd(ch, optarg);
>  			misc_cmd(ch, optarg);
> @@ -1247,6 +1259,7 @@ int main(int argc, char **argv)
>  		options[OptGetSdrFormat] = 1;
>  		options[OptGetSdrOutFormat] = 1;
>  		options[OptGetMetaFormat] = 1;
> +		options[OptGetMetaOutFormat] = 1;
>  		options[OptGetFBuf] = 1;
>  		options[OptGetCropCap] = 1;
>  		options[OptGetOutputCropCap] = 1;
> @@ -1282,6 +1295,7 @@ int main(int argc, char **argv)
>  	vbi_set(c_fd);
>  	sdr_set(c_fd);
>  	meta_set(c_fd);
> +	meta_out_set(c_fd);
>  	subdev_set(c_fd);
>  	selection_set(c_fd);
>  	misc_set(c_fd);
> @@ -1299,6 +1313,7 @@ int main(int argc, char **argv)
>  	vbi_get(c_fd);
>  	sdr_get(c_fd);
>  	meta_get(c_fd);
> +	meta_out_get(c_fd);
>  	subdev_get(c_fd);
>  	selection_get(c_fd);
>  	misc_get(c_fd);
> @@ -1315,6 +1330,7 @@ int main(int argc, char **argv)
>  	vbi_list(c_fd);
>  	sdr_list(c_fd);
>  	meta_list(c_fd);
> +	meta_out_list(c_fd);
>  	subdev_list(c_fd);
>  	streaming_list(c_fd, c_out_fd);
>  
> diff --git a/utils/v4l2-ctl/v4l2-ctl.h b/utils/v4l2-ctl/v4l2-ctl.h
> index 5a52a0a48f..da9615392e 100644
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
> @@ -249,6 +254,7 @@ enum Option {
>  	OptHelpVbi,
>  	OptHelpSdr,
>  	OptHelpMeta,
> +	OptHelpMetaOut,
>  	OptHelpSubDev,
>  	OptHelpSelection,
>  	OptHelpMisc,
> @@ -386,6 +392,13 @@ void meta_set(cv4l_fd &fd);
>  void meta_get(cv4l_fd &fd);
>  void meta_list(cv4l_fd &fd);
>  
> +// v4l2-ctl-meta-out.cpp
> +void meta_out_usage(void);
> +void meta_out_cmd(int ch, char *optarg);
> +void meta_out_set(cv4l_fd &fd);
> +void meta_out_get(cv4l_fd &fd);
> +void meta_out_list(cv4l_fd &fd);
> +
>  // v4l2-ctl-subdev.cpp
>  void subdev_usage(void);
>  void subdev_cmd(int ch, char *optarg);
> 

