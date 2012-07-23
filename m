Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2510 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2GWJDR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 05:03:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v1] v4l2-ctl: Add support for VIDIOC_G/S_SELECTION ioctls
Date: Mon, 23 Jul 2012 11:02:43 +0200
Cc: linux-media@vger.kernel.org
References: <1342989722-4321-1-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1342989722-4321-1-git-send-email-sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207231102.43300.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun July 22 2012 22:42:02 Sylwester Nawrocki wrote:
> This patch adds following commands for the selection API ioctls:
> 
> --get-selection, --set-selection,
> --get-selection-output, --set-selection-output.
> 
> All supported selection rectangles at a video node are now also
> displayed in case of --all command.

I've committed both patches. Thanks!

Regards,

	Hans

> 
> Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
> ---
>  utils/v4l2-ctl/v4l2-ctl.cpp |  239 +++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 239 insertions(+), 0 deletions(-)
> 
> diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
> index 1a6c4ae..c70e88c 100644
> --- a/utils/v4l2-ctl/v4l2-ctl.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl.cpp
> @@ -139,6 +139,10 @@ enum Option {
>  	OptSetOverlayCrop,
>  	OptGetOutputOverlayCrop,
>  	OptSetOutputOverlayCrop,
> +	OptGetSelection,
> +	OptSetSelection,
> +	OptGetOutputSelection,
> +	OptSetOutputSelection,
>  	OptGetAudioInput,
>  	OptSetAudioInput,
>  	OptGetAudioOutput,
> @@ -233,6 +237,13 @@ static const flag_def service_def[] = {
>  #define CropLeft		(1L<<2)
>  #define CropTop 		(1L<<3)
> 
> +/* selection specified */
> +#define SelectionWidth		(1L<<0)
> +#define SelectionHeight		(1L<<1)
> +#define SelectionLeft		(1L<<2)
> +#define SelectionTop 		(1L<<3)
> +#define SelectionFlags 		(1L<<4)
> +
>  static struct option long_options[] = {
>  	{"list-audio-inputs", no_argument, 0, OptListAudioInputs},
>  	{"list-audio-outputs", no_argument, 0, OptListAudioOutputs},
> @@ -322,6 +333,10 @@ static struct option long_options[] = {
>  	{"get-cropcap-output-overlay", no_argument, 0, OptGetOutputOverlayCropCap},
>  	{"get-crop-output-overlay", no_argument, 0, OptGetOutputOverlayCrop},
>  	{"set-crop-output-overlay", required_argument, 0, OptSetOutputOverlayCrop},
> +	{"get-selection", required_argument, 0, OptGetSelection},
> +	{"set-selection", required_argument, 0, OptSetSelection},
> +	{"get-selection-output", required_argument, 0, OptGetOutputSelection},
> +	{"set-selection-output", required_argument, 0, OptSetOutputSelection},
>  	{"get-jpeg-comp", no_argument, 0, OptGetJpegComp},
>  	{"set-jpeg-comp", required_argument, 0, OptSetJpegComp},
>  	{"get-modulator", no_argument, 0, OptGetModulator},
> @@ -631,6 +646,26 @@ static void usage_crop(void)
>  	       );
>  }
> 
> +static void usage_selection(void)
> +{
> +	printf("\nSelection options:\n"
> +	       "  --get-selection=target=<target>\n"
> +	       "                     query the video capture selection rectangle [VIDIOC_G_SELECTION]\n"
> +	       "                     See --set-selection command for the valid <target> values.\n"
> +	       "  --set-selection=target=<target>,flags=<flags>,top=<x>,left=<y>,width=<w>,height=<h>\n"
> +	       "                     set the video capture selection rectangle [VIDIOC_S_SELECTION]\n"
> +	       "                     target=crop|crop_bounds|crop_default|compose|compose_bounds|\n"
> +	       "                            compose_default|compose_padded\n"
> +	       "                     flags=le|ge\n"
> +	       "  --get-selection-output=target=<target>\n"
> +	       "                     query the video output selection rectangle [VIDIOC_G_SELECTION]\n"
> +	       "                     See --set-selection command for the valid <target> values.\n"
> +	       "  --set-selection-output=target=<target>,flags=<flags>,top=<x>,left=<y>,width=<w>,height=<h>\n"
> +	       "                     set the video output selection rectangle [VIDIOC_S_SELECTION]\n"
> +	       "                     See --set-selection command for the arguments.\n"
> +	       );
> +}
> +
>  static void usage_misc(void)
>  {
>  	printf("\nMiscellaneous options:\n"
> @@ -688,6 +723,7 @@ static void usage(void)
>  	usage_vidout();
>  	usage_overlay();
>  	usage_vbi();
> +	usage_selection();
>  	usage_crop();
>  	usage_misc();
>  }
> @@ -1267,6 +1303,35 @@ static void printcropcap(const struct v4l2_cropcap &cropcap)
>  	printf("\tPixel Aspect: %u/%u\n", cropcap.pixelaspect.numerator, cropcap.pixelaspect.denominator);
>  }
> 
> +static const flag_def selection_targets_def[] = {
> +	{ V4L2_SEL_TGT_CROP_ACTIVE, "crop" },
> +	{ V4L2_SEL_TGT_CROP_DEFAULT, "crop_default" },
> +	{ V4L2_SEL_TGT_CROP_BOUNDS, "crop_bounds" },
> +	{ V4L2_SEL_TGT_COMPOSE_ACTIVE, "compose" },
> +	{ V4L2_SEL_TGT_COMPOSE_DEFAULT, "compose_default" },
> +	{ V4L2_SEL_TGT_COMPOSE_BOUNDS, "compose_bounds" },
> +	{ V4L2_SEL_TGT_COMPOSE_PADDED, "compose_padded" },
> +	{ 0, NULL }
> +};
> +
> +static std::string seltarget2s(__u32 target)
> +{
> +	int i = 0;
> +
> +	while (selection_targets_def[i++].str != NULL) {
> +		if (selection_targets_def[i].flag == target)
> +			return selection_targets_def[i].str;
> +	}
> +	return "Unknown";
> +}
> +
> +static void print_selection(const struct v4l2_selection &sel)
> +{
> +	printf("Selection: %s, Left %d, Top %d, Width %d, Height %d\n",
> +			seltarget2s(sel.target).c_str(),
> +			sel.r.left, sel.r.top, sel.r.width, sel.r.height);
> +}
> +
>  static void printfmt(const struct v4l2_format &vfmt)
>  {
>  	const flag_def vbi_def[] = {
> @@ -2008,6 +2073,103 @@ static void parse_crop(char *optarg, unsigned int &set_crop, v4l2_rect &vcrop)
>  	}
>  }
> 
> +static void do_selection(int fd, unsigned int set_selection, struct v4l2_selection &vsel,
> +			 v4l2_buf_type type)
> +{
> +	struct v4l2_selection in_selection;
> +
> +	in_selection.type = type;
> +	in_selection.target = vsel.target;
> +
> +	if (doioctl(fd, VIDIOC_G_SELECTION, &in_selection) == 0) {
> +		if (set_selection & SelectionWidth)
> +			in_selection.r.width = vsel.r.width;
> +		if (set_selection & SelectionHeight)
> +			in_selection.r.height = vsel.r.height;
> +		if (set_selection & SelectionLeft)
> +			in_selection.r.left = vsel.r.left;
> +		if (set_selection & SelectionTop)
> +			in_selection.r.top = vsel.r.top;
> +		in_selection.flags = (set_selection & SelectionFlags) ? vsel.flags : 0;
> +		doioctl(fd, VIDIOC_S_SELECTION, &in_selection);
> +	}
> +}
> +
> +static int parse_selection_target(const char *s, unsigned int &target)
> +{
> +	if (!strcmp(s, "crop")) target = V4L2_SEL_TGT_CROP_ACTIVE;
> +	else if (!strcmp(s, "crop_default")) target = V4L2_SEL_TGT_CROP_DEFAULT;
> +	else if (!strcmp(s, "crop_bounds")) target = V4L2_SEL_TGT_CROP_BOUNDS;
> +	else if (!strcmp(s, "compose")) target = V4L2_SEL_TGT_COMPOSE_ACTIVE;
> +	else if (!strcmp(s, "compose_default")) target = V4L2_SEL_TGT_COMPOSE_DEFAULT;
> +	else if (!strcmp(s, "compose_bounds")) target = V4L2_SEL_TGT_COMPOSE_BOUNDS;
> +	else if (!strcmp(s, "compose_padded")) target = V4L2_SEL_TGT_COMPOSE_PADDED;
> +	else return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int parse_selection_flags(const char *s)
> +{
> +	if (!strcmp(s, "le")) return V4L2_SEL_FLAG_LE;
> +	if (!strcmp(s, "ge")) return V4L2_SEL_FLAG_GE;
> +	return 0;
> +}
> +
> +static int parse_selection(char *optarg, unsigned int &set_sel, v4l2_selection &vsel)
> +{
> +	char *value;
> +	char *subs = optarg;
> +
> +	while (*subs != '\0') {
> +		static const char *const subopts[] = {
> +			"target",
> +			"flags",
> +			"left",
> +			"top",
> +			"width",
> +			"height",
> +			NULL
> +		};
> +
> +		switch (parse_subopt(&subs, subopts, &value)) {
> +		case 0:
> +			if (parse_selection_target(value, vsel.target)) {
> +				fprintf(stderr, "Unknown selection target\n");
> +				usage_selection();
> +				exit(1);
> +			}
> +			break;
> +		case 1:
> +			vsel.flags = parse_selection_flags(value);
> +			set_sel |= SelectionFlags;
> +			break;
> +		case 2:
> +			vsel.r.left = strtol(value, 0L, 0);
> +			set_sel |= SelectionLeft;
> +			break;
> +		case 3:
> +			vsel.r.top = strtol(value, 0L, 0);
> +			set_sel |= SelectionTop;
> +			break;
> +		case 4:
> +			vsel.r.width = strtol(value, 0L, 0);
> +			set_sel |= SelectionWidth;
> +			break;
> +		case 5:
> +			vsel.r.height = strtol(value, 0L, 0);
> +			set_sel |= SelectionHeight;
> +			break;
> +		default:
> +			fprintf(stderr, "Unknown option\n");
> +			usage_selection();
> +			exit(1);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  static void parse_freq_seek(char *optarg, struct v4l2_hw_freq_seek &seek)
>  {
>  	char *value;
> @@ -2323,6 +2485,9 @@ int main(int argc, char **argv)
>  	unsigned int set_crop_out = 0;
>  	unsigned int set_crop_overlay = 0;
>  	unsigned int set_crop_out_overlay = 0;
> +	unsigned int set_selection = 0;
> +	unsigned int set_selection_out = 0;
> +	int get_sel_target = 0;
>  	unsigned int set_fbuf = 0;
>  	unsigned int set_overlay_fmt = 0;
>  	unsigned int set_overlay_fmt_out = 0;
> @@ -2353,6 +2518,8 @@ int main(int argc, char **argv)
>  	struct v4l2_rect vcrop_out; 	/* crop rect */
>  	struct v4l2_rect vcrop_overlay; 	/* crop rect */
>  	struct v4l2_rect vcrop_out_overlay; 	/* crop rect */
> +	struct v4l2_selection vselection; 	/* capture selection */
> +	struct v4l2_selection vselection_out;	/* output selection */
>  	struct v4l2_framebuffer fbuf;   /* fbuf */
>  	struct v4l2_jpegcompression jpegcomp; /* jpeg compression */
>  	struct v4l2_streamparm parm;	/* get/set parm */
> @@ -2409,6 +2576,8 @@ int main(int argc, char **argv)
>  	memset(&vcrop_out, 0, sizeof(vcrop_out));
>  	memset(&vcrop_overlay, 0, sizeof(vcrop_overlay));
>  	memset(&vcrop_out_overlay, 0, sizeof(vcrop_out_overlay));
> +	memset(&vselection, 0, sizeof(vselection));
> +	memset(&vselection_out, 0, sizeof(vselection_out));
>  	memset(&vf, 0, sizeof(vf));
>  	memset(&vs, 0, sizeof(vs));
>  	memset(&fbuf, 0, sizeof(fbuf));
> @@ -2694,6 +2863,25 @@ int main(int argc, char **argv)
>  		case OptSetOutputOverlayCrop:
>  			parse_crop(optarg, set_crop_out_overlay, vcrop_out_overlay);
>  			break;
> +		case OptSetSelection:
> +			parse_selection(optarg, set_selection, vselection);
> +			break;
> +		case OptSetOutputSelection:
> +			parse_selection(optarg, set_selection_out, vselection_out);
> +			break;
> +		case OptGetOutputSelection:
> +		case OptGetSelection: {
> +			struct v4l2_selection gsel;
> +			unsigned int get_sel;
> +
> +			if (parse_selection(optarg, get_sel, gsel)) {
> +				fprintf(stderr, "Unknown selection target\n");
> +				usage_selection();
> +				exit(1);
> +			}
> +			get_sel_target = gsel.target;
> +			break;
> +		}
>  		case OptSetInput:
>  			input = strtol(optarg, 0L, 0);
>  			break;
> @@ -3097,6 +3285,9 @@ int main(int argc, char **argv)
>  		options[OptGetDvTimings] = 1;
>  		options[OptGetDvTimingsCap] = 1;
>  		options[OptGetPriority] = 1;
> +		options[OptGetSelection] = 1;
> +		options[OptGetOutputSelection] = 1;
> +		get_sel_target = -1;
>  		options[OptSilent] = 1;
>  	}
> 
> @@ -3489,6 +3680,14 @@ int main(int argc, char **argv)
>  		do_crop(fd, set_crop_out_overlay, vcrop_out_overlay, V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY);
>  	}
> 
> +	if (options[OptSetSelection]) {
> +		do_selection(fd, set_selection, vselection, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +	}
> +
> +	if (options[OptSetOutputSelection]) {
> +		do_selection(fd, set_selection_out, vselection_out, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> +	}
> +
>  	if (options[OptSetCtrl] && !set_ctrls.empty()) {
>  		struct v4l2_ext_controls ctrls;
>  		class2ctrls_map class2ctrls;
> @@ -3720,6 +3919,46 @@ int main(int argc, char **argv)
>  			printcrop(crop);
>  	}
> 
> +	if (options[OptGetSelection]) {
> +		struct v4l2_selection sel;
> +		int t = 0;
> +
> +		memset(&sel, 0, sizeof(sel));
> +		sel.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +
> +		if (get_sel_target == -1) {
> +			while (selection_targets_def[t++].str != NULL) {
> +				sel.target = selection_targets_def[t].flag;
> +				if (doioctl(fd, VIDIOC_G_SELECTION, &sel) == 0)
> +					print_selection(sel);
> +			}
> +		} else {
> +			sel.target = get_sel_target;
> +			if (doioctl(fd, VIDIOC_G_SELECTION, &sel) == 0)
> +				print_selection(sel);
> +		}
> +	}
> +
> +	if (options[OptGetOutputSelection]) {
> +		struct v4l2_selection sel;
> +		int t = 0;
> +
> +		memset(&sel, 0, sizeof(sel));
> +		sel.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +
> +		if (get_sel_target == -1) {
> +			while (selection_targets_def[t++].str != NULL) {
> +				sel.target = selection_targets_def[t].flag;
> +				if (doioctl(fd, VIDIOC_G_SELECTION, &sel) == 0)
> +					print_selection(sel);
> +			}
> +		} else {
> +			sel.target = get_sel_target;
> +			if (doioctl(fd, VIDIOC_G_SELECTION, &sel) == 0)
> +				print_selection(sel);
> +		}
> +	}
> +
>  	if (options[OptGetInput]) {
>  		if (doioctl(fd, VIDIOC_G_INPUT, &input) == 0) {
>  			printf("Video input : %d", input);
> --
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
