Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3835 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbaBJJLo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 04:11:44 -0500
Message-ID: <52F897A4.9010505@xs4all.nl>
Date: Mon, 10 Feb 2014 10:11:00 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH 4/5] v4l2-ctl: add support for SDR FMT
References: <1391925954-25975-1-git-send-email-crope@iki.fi> <1391925954-25975-5-git-send-email-crope@iki.fi>
In-Reply-To: <1391925954-25975-5-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/09/2014 07:05 AM, Antti Palosaari wrote:
> Add support for FMT IOCTL operations used for SDR receivers.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  utils/v4l2-ctl/Makefile.am         |   2 +-
>  utils/v4l2-ctl/v4l2-ctl-common.cpp |   1 +
>  utils/v4l2-ctl/v4l2-ctl-sdr.cpp    | 104 +++++++++++++++++++++++++++++++++++++
>  utils/v4l2-ctl/v4l2-ctl.cpp        |  22 ++++++++
>  utils/v4l2-ctl/v4l2-ctl.h          |  12 +++++
>  5 files changed, 140 insertions(+), 1 deletion(-)
>  create mode 100644 utils/v4l2-ctl/v4l2-ctl-sdr.cpp
> 
> diff --git a/utils/v4l2-ctl/Makefile.am b/utils/v4l2-ctl/Makefile.am
> index b5744e7..becaa15 100644
> --- a/utils/v4l2-ctl/Makefile.am
> +++ b/utils/v4l2-ctl/Makefile.am
> @@ -8,5 +8,5 @@ ivtv_ctl_LDFLAGS = -lm
>  v4l2_ctl_SOURCES = v4l2-ctl.cpp v4l2-ctl.h v4l2-ctl-common.cpp v4l2-ctl-tuner.cpp \
>  	v4l2-ctl-io.cpp v4l2-ctl-stds.cpp v4l2-ctl-vidcap.cpp v4l2-ctl-vidout.cpp \
>  	v4l2-ctl-overlay.cpp v4l2-ctl-vbi.cpp v4l2-ctl-selection.cpp v4l2-ctl-misc.cpp \
> -	v4l2-ctl-streaming.cpp v4l2-ctl-test-patterns.cpp
> +	v4l2-ctl-streaming.cpp v4l2-ctl-test-patterns.cpp v4l2-ctl-sdr.cpp
>  v4l2_ctl_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la
> diff --git a/utils/v4l2-ctl/v4l2-ctl-common.cpp b/utils/v4l2-ctl/v4l2-ctl-common.cpp
> index fe570b0..37099cd 100644
> --- a/utils/v4l2-ctl/v4l2-ctl-common.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl-common.cpp
> @@ -64,6 +64,7 @@ void common_usage(void)
>  	       "  --help-io          input/output options\n"
>  	       "  --help-misc        miscellaneous options\n"
>  	       "  --help-overlay     overlay format options\n"
> +	       "  --help-sdr         SDR format options\n"
>  	       "  --help-selection   crop/selection options\n"
>  	       "  --help-stds        standards and other video timings options\n"
>  	       "  --help-streaming   streaming options\n"
> diff --git a/utils/v4l2-ctl/v4l2-ctl-sdr.cpp b/utils/v4l2-ctl/v4l2-ctl-sdr.cpp
> new file mode 100644
> index 0000000..9c9a6c4
> --- /dev/null
> +++ b/utils/v4l2-ctl/v4l2-ctl-sdr.cpp
> @@ -0,0 +1,104 @@
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
> +#include <config.h>
> +
> +#include <linux/videodev2.h>
> +#include <libv4l2.h>
> +#include <string>
> +
> +#include "v4l2-ctl.h"
> +
> +static struct v4l2_format vfmt;	/* set_format/get_format */
> +
> +void sdr_usage(void)
> +{
> +	printf("\nSDR Formats options:\n"
> +	       "  --list-formats-sdr display supported SDR formats [VIDIOC_ENUM_FMT]\n"
> +	       "  --get-fmt-sdr      query the SDR capture format [VIDIOC_G_FMT]\n"
> +	       "  --set-fmt-sdr=<f>  set the SDR capture format [VIDIOC_S_FMT]\n"
> +	       "                     parameter is either the format index as reported by\n"
> +	       "                     --list-formats-sdr, or the fourcc value as a string\n"
> +	       "  --try-fmt-sdr=<f>  try the SDR capture format [VIDIOC_TRY_FMT]\n"
> +	       "                     parameter is either the format index as reported by\n"
> +	       "                     --list-formats-sdr, or the fourcc value as a string\n"
> +	       );
> +}
> +
> +void sdr_cmd(int ch, char *optarg)
> +{
> +	switch (ch) {
> +	case OptSetSdrFormat:
> +	case OptTrySdrFormat:
> +		if (strlen(optarg) == 0) {
> +			sdr_usage();
> +			exit(1);
> +		} else if (strlen(optarg) == 4) {
> +			vfmt.fmt.sdr.pixelformat = v4l2_fourcc(optarg[0],
> +					optarg[1], optarg[2], optarg[3]);
> +		} else {
> +			vfmt.fmt.sdr.pixelformat = strtol(optarg, 0L, 0);
> +		}
> +		break;
> +	}
> +}
> +
> +void sdr_set(int fd)
> +{
> +	int ret;
> +
> +	if (options[OptSetSdrFormat] || options[OptTrySdrFormat]) {
> +		struct v4l2_format in_vfmt;
> +
> +		in_vfmt.type = V4L2_BUF_TYPE_SDR_CAPTURE;
> +		in_vfmt.fmt.sdr.pixelformat = vfmt.fmt.sdr.pixelformat;
> +
> +		if (in_vfmt.fmt.sdr.pixelformat < 256) {
> +			struct v4l2_fmtdesc fmt;
> +
> +			fmt.index = in_vfmt.fmt.sdr.pixelformat;
> +			fmt.type = V4L2_BUF_TYPE_SDR_CAPTURE;
> +
> +			if (doioctl(fd, VIDIOC_ENUM_FMT, &fmt))
> +				fmt.pixelformat = 0;
> +
> +			in_vfmt.fmt.sdr.pixelformat = fmt.pixelformat;
> +		}
> +
> +		if (options[OptSetSdrFormat])
> +			ret = doioctl(fd, VIDIOC_S_FMT, &in_vfmt);
> +		else
> +			ret = doioctl(fd, VIDIOC_TRY_FMT, &in_vfmt);
> +		if (ret == 0 && (verbose || options[OptTrySdrFormat]))
> +			printfmt(in_vfmt);
> +	}
> +}
> +
> +void sdr_get(int fd)
> +{
> +	if (options[OptGetSdrFormat]) {
> +		vfmt.type = V4L2_BUF_TYPE_SDR_CAPTURE;
> +		if (doioctl(fd, VIDIOC_G_FMT, &vfmt) == 0)
> +			printfmt(vfmt);
> +	}
> +}
> +
> +void sdr_list(int fd)
> +{
> +	if (options[OptListSdrFormats]) {
> +		printf("ioctl: VIDIOC_ENUM_FMT\n");
> +		print_video_formats(fd, V4L2_BUF_TYPE_SDR_CAPTURE);
> +	}
> +}
> diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
> index c64c2fe..855613c 100644
> --- a/utils/v4l2-ctl/v4l2-ctl.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl.cpp
> @@ -85,6 +85,7 @@ static struct option long_options[] = {
>  	{"help-vidout", no_argument, 0, OptHelpVidOut},
>  	{"help-overlay", no_argument, 0, OptHelpOverlay},
>  	{"help-vbi", no_argument, 0, OptHelpVbi},
> +	{"help-sdr", no_argument, 0, OptHelpSdr},
>  	{"help-selection", no_argument, 0, OptHelpSelection},
>  	{"help-misc", no_argument, 0, OptHelpMisc},
>  	{"help-streaming", no_argument, 0, OptHelpStreaming},
> @@ -111,6 +112,7 @@ static struct option long_options[] = {
>  	{"list-framesizes", required_argument, 0, OptListFrameSizes},
>  	{"list-frameintervals", required_argument, 0, OptListFrameIntervals},
>  	{"list-formats-overlay", no_argument, 0, OptListOverlayFormats},
> +	{"list-formats-sdr", no_argument, 0, OptListSdrFormats},
>  	{"list-formats-out", no_argument, 0, OptListOutFormats},
>  	{"list-formats-out-mplane", no_argument, 0, OptListOutMplaneFormats},
>  	{"get-standard", no_argument, 0, OptGetStandard},
> @@ -145,6 +147,9 @@ static struct option long_options[] = {
>  	{"try-fmt-sliced-vbi-out", required_argument, 0, OptTrySlicedVbiOutFormat},
>  	{"get-fmt-vbi", no_argument, 0, OptGetVbiFormat},
>  	{"get-fmt-vbi-out", no_argument, 0, OptGetVbiOutFormat},
> +	{"get-fmt-sdr", no_argument, 0, OptGetSdrFormat},
> +	{"set-fmt-sdr", required_argument, 0, OptSetSdrFormat},
> +	{"try-fmt-sdr", required_argument, 0, OptTrySdrFormat},
>  	{"get-sliced-vbi-cap", no_argument, 0, OptGetSlicedVbiCap},
>  	{"get-sliced-vbi-out-cap", no_argument, 0, OptGetSlicedVbiOutCap},
>  	{"get-fbuf", no_argument, 0, OptGetFBuf},
> @@ -217,6 +222,7 @@ static void usage_all(void)
>         vidout_usage();
>         overlay_usage();
>         vbi_usage();
> +       sdr_usage();
>         selection_usage();
>         misc_usage();
>         streaming_usage();
> @@ -285,6 +291,8 @@ std::string buftype2s(int type)
>  		return "Sliced VBI Output";
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
>  		return "Video Output Overlay";
> +	case V4L2_BUF_TYPE_SDR_CAPTURE:
> +		return "SDR Capture";
>  	default:
>  		return "Unknown (" + num2s(type) + ")";
>  	}
> @@ -458,6 +466,9 @@ void printfmt(const struct v4l2_format &vfmt)
>  		}
>  		printf("\tI/O Size       : %u\n", vfmt.fmt.sliced.io_size);
>  		break;
> +	case V4L2_BUF_TYPE_SDR_CAPTURE:
> +		printf("\tSample Format   : %s\n", fcc2s(vfmt.fmt.sdr.pixelformat).c_str());
> +		break;
>  	}
>  }
>  
> @@ -519,6 +530,8 @@ static std::string cap2s(unsigned cap)
>  		s += "\t\tSliced VBI Capture\n";
>  	if (cap & V4L2_CAP_SLICED_VBI_OUTPUT)
>  		s += "\t\tSliced VBI Output\n";
> +	if (cap & V4L2_CAP_SDR_CAPTURE)
> +		s += "\t\tSDR Capture\n";
>  	if (cap & V4L2_CAP_RDS_CAPTURE)
>  		s += "\t\tRDS Capture\n";
>  	if (cap & V4L2_CAP_RDS_OUTPUT)
> @@ -736,6 +749,7 @@ __u32 find_pixel_format(int fd, unsigned index, bool output, bool mplane)
>  	else
>  		fmt.type = mplane ?  V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE :
>  			V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +
>  	if (doioctl(fd, VIDIOC_ENUM_FMT, &fmt))
>  		return 0;
>  	return fmt.pixelformat;
> @@ -807,6 +821,9 @@ int main(int argc, char **argv)
>  		case OptHelpVbi:
>  			vbi_usage();
>  			return 0;
> +		case OptHelpSdr:
> +			sdr_usage();
> +			return 0;
>  		case OptHelpSelection:
>  			selection_usage();
>  			return 0;
> @@ -860,6 +877,7 @@ int main(int argc, char **argv)
>  			vidout_cmd(ch, optarg);
>  			overlay_cmd(ch, optarg);
>  			vbi_cmd(ch, optarg);
> +			sdr_cmd(ch, optarg);
>  			selection_cmd(ch, optarg);
>  			misc_cmd(ch, optarg);
>  			streaming_cmd(ch, optarg);
> @@ -921,6 +939,7 @@ int main(int argc, char **argv)
>  		options[OptGetVbiOutFormat] = 1;
>  		options[OptGetSlicedVbiFormat] = 1;
>  		options[OptGetSlicedVbiOutFormat] = 1;
> +		options[OptGetSdrFormat] = 1;
>  		options[OptGetFBuf] = 1;
>  		options[OptGetCropCap] = 1;
>  		options[OptGetOutputCropCap] = 1;
> @@ -964,6 +983,7 @@ int main(int argc, char **argv)
>  	vidout_set(fd);
>  	overlay_set(fd);
>  	vbi_set(fd);
> +	sdr_set(fd);
>  	selection_set(fd);
>  	streaming_set(fd);
>  	misc_set(fd);
> @@ -978,6 +998,7 @@ int main(int argc, char **argv)
>  	vidout_get(fd);
>  	overlay_get(fd);
>  	vbi_get(fd);
> +	sdr_get(fd);
>  	selection_get(fd);
>  	misc_get(fd);
>  
> @@ -990,6 +1011,7 @@ int main(int argc, char **argv)
>  	vidout_list(fd);
>  	overlay_list(fd);
>  	vbi_list(fd);
> +	sdr_list(fd);
>  	streaming_list(fd);
>  
>  	if (options[OptWaitForEvent]) {
> diff --git a/utils/v4l2-ctl/v4l2-ctl.h b/utils/v4l2-ctl/v4l2-ctl.h
> index 03c45b7..108198d 100644
> --- a/utils/v4l2-ctl/v4l2-ctl.h
> +++ b/utils/v4l2-ctl/v4l2-ctl.h
> @@ -44,6 +44,7 @@ enum Option {
>  	OptGetOutputOverlayFormat,
>  	OptGetVbiFormat,
>  	OptGetVbiOutFormat,
> +	OptGetSdrFormat,
>  	OptGetVideoOutFormat,
>  	OptGetVideoOutMplaneFormat,
>  	OptSetSlicedVbiOutFormat,
> @@ -51,6 +52,7 @@ enum Option {
>  	OptSetOverlayFormat,
>  	//OptSetVbiFormat, TODO
>  	//OptSetVbiOutFormat, TODO
> +	OptSetSdrFormat,
>  	OptSetVideoOutFormat,
>  	OptSetVideoOutMplaneFormat,
>  	OptTryVideoOutFormat,
> @@ -63,6 +65,7 @@ enum Option {
>  	OptTryOverlayFormat,
>  	//OptTryVbiFormat, TODO
>  	//OptTryVbiOutFormat, TODO
> +	OptTrySdrFormat,
>  	OptAll,
>  	OptListStandards,
>  	OptListFormats,
> @@ -72,6 +75,7 @@ enum Option {
>  	OptListFrameSizes,
>  	OptListFrameIntervals,
>  	OptListOverlayFormats,
> +	OptListSdrFormats,
>  	OptListOutFormats,
>  	OptListOutMplaneFormats,
>  	OptLogStatus,
> @@ -153,6 +157,7 @@ enum Option {
>  	OptHelpVidOut,
>  	OptHelpOverlay,
>  	OptHelpVbi,
> +	OptHelpSdr,
>  	OptHelpSelection,
>  	OptHelpMisc,
>  	OptHelpStreaming,
> @@ -257,6 +262,13 @@ void vbi_set(int fd);
>  void vbi_get(int fd);
>  void vbi_list(int fd);
>  
> +// v4l2-ctl-sdr.cpp
> +void sdr_usage(void);
> +void sdr_cmd(int ch, char *optarg);
> +void sdr_set(int fd);
> +void sdr_get(int fd);
> +void sdr_list(int fd);
> +
>  // v4l2-ctl-selection.cpp
>  void selection_usage(void);
>  void selection_cmd(int ch, char *optarg);
> 

