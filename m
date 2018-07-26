Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f65.google.com ([209.85.167.65]:46688 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731741AbeG0AHd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Jul 2018 20:07:33 -0400
Received: by mail-lf1-f65.google.com with SMTP id l16-v6so2279758lfc.13
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2018 15:48:37 -0700 (PDT)
Date: Fri, 27 Jul 2018 00:48:34 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] v4l2-ctl: add support for SUBDEV_{G_STD,S_STD,QUERYSTD}
Message-ID: <20180726224834.GA14328@bigcity.dyn.berto.se>
References: <20180726212756.13289-1-niklas.soderlund@ragnatech.se>
 <f121bdcf-0d6e-4526-ab27-bd3ac9901e4d@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f121bdcf-0d6e-4526-ab27-bd3ac9901e4d@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 2018-07-26 23:31:01 +0200, Hans Verkuil wrote:
> On 26/07/18 23:27, Niklas Söderlund wrote:
> > From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > 
> > Add four new options: --list-subdev-standards, --get-subdev-standard,
> > --set-subdev-standard and --get-subdev-detected-standard.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  utils/v4l2-ctl/v4l2-ctl-subdev.cpp | 158 +++++++++++++++++++++++++++++
> >  utils/v4l2-ctl/v4l2-ctl.cpp        |   4 +
> >  utils/v4l2-ctl/v4l2-ctl.h          |   4 +
> >  3 files changed, 166 insertions(+)
> 
> Is this needed? These ioctls are identical to the already existing STD ioctls, so you
> can use the existing v4l2-ctl options (v4l2-ctl --help-stds).

v4l2 never stops amazing me (in good and bad ways), in this case good.
You are correct this is not needed the existing std options solves the 
problem I'm trying to solve. I still need to figure out how it works but 
this patch is not needed :-) Thanks for educating me.

> 
> Regards,
> 
> 	Hans
> 
> > 
> > diff --git a/utils/v4l2-ctl/v4l2-ctl-subdev.cpp b/utils/v4l2-ctl/v4l2-ctl-subdev.cpp
> > index c1d3e5ad46f763fb..d08c04e787810516 100644
> > --- a/utils/v4l2-ctl/v4l2-ctl-subdev.cpp
> > +++ b/utils/v4l2-ctl/v4l2-ctl-subdev.cpp
> > @@ -48,6 +48,7 @@ static struct v4l2_subdev_frame_size_enum frmsize;
> >  static struct v4l2_subdev_frame_interval_enum frmival;
> >  static __u32 set_fps_pad;
> >  static double set_fps;
> > +static v4l2_std_id standard;
> >  
> >  void subdev_usage(void)
> >  {
> > @@ -96,9 +97,88 @@ void subdev_usage(void)
> >  	       "                     flags=le|ge|keep-config\n"
> >  	       "  --set-subdev-fps pad=<pad>,fps=<fps> (for testing only, otherwise use media-ctl)\n"
> >  	       "                     set the frame rate [VIDIOC_SUBDEV_S_FRAME_INTERVAL]\n"
> > +	       "  --list-subdev-standards display supported video standards [VIDIOC_SUBDEV_ENUMSTD]\n"
> > +	       "  --get-subdev-standard\n"
> > +	       "                     query the video standard [VIDIOC_SUBDEV_G_STD]\n"
> > +	       "  --set-subdev-standard <num>\n"
> > +	       "                     set the video standard to <num> [VIDIOC_SUBDEV_S_STD]\n"
> > +	       "                     <num> a numerical v4l2_std value, or one of:\n"
> > +	       "                     pal or pal-X (X = B/G/H/N/Nc/I/D/K/M/60) (V4L2_STD_PAL)\n"
> > +	       "                     ntsc or ntsc-X (X = M/J/K) (V4L2_STD_NTSC)\n"
> > +	       "                     secam or secam-X (X = B/G/H/D/K/L/Lc) (V4L2_STD_SECAM)\n"
> > +	       "  --get-subdev-detected-standard\n"
> > +	       "                     display detected input video standard [VIDIOC_SUBDEV_QUERYSTD]\n"
> >  	       );
> >  }
> >  
> > +static v4l2_std_id parse_pal(const char *pal)
> > +{
> > +	if (pal[0] == '-') {
> > +		switch (tolower(pal[1])) {
> > +		case '6':
> > +			return V4L2_STD_PAL_60;
> > +		case 'b':
> > +		case 'g':
> > +			return V4L2_STD_PAL_BG;
> > +		case 'h':
> > +			return V4L2_STD_PAL_H;
> > +		case 'n':
> > +			if (tolower(pal[2]) == 'c')
> > +				return V4L2_STD_PAL_Nc;
> > +			return V4L2_STD_PAL_N;
> > +		case 'i':
> > +			return V4L2_STD_PAL_I;
> > +		case 'd':
> > +		case 'k':
> > +			return V4L2_STD_PAL_DK;
> > +		case 'm':
> > +			return V4L2_STD_PAL_M;
> > +		}
> > +	}
> > +	fprintf(stderr, "pal specifier not recognised\n");
> > +	subdev_usage();
> > +	exit(1);
> > +}
> > +
> > +static v4l2_std_id parse_secam(const char *secam)
> > +{
> > +	if (secam[0] == '-') {
> > +		switch (tolower(secam[1])) {
> > +		case 'b':
> > +		case 'g':
> > +		case 'h':
> > +			return V4L2_STD_SECAM_B | V4L2_STD_SECAM_G | V4L2_STD_SECAM_H;
> > +		case 'd':
> > +		case 'k':
> > +			return V4L2_STD_SECAM_DK;
> > +		case 'l':
> > +			if (tolower(secam[2]) == 'c')
> > +				return V4L2_STD_SECAM_LC;
> > +			return V4L2_STD_SECAM_L;
> > +		}
> > +	}
> > +	fprintf(stderr, "secam specifier not recognised\n");
> > +	subdev_usage();
> > +	exit(1);
> > +}
> > +
> > +static v4l2_std_id parse_ntsc(const char *ntsc)
> > +{
> > +	if (ntsc[0] == '-') {
> > +		switch (tolower(ntsc[1])) {
> > +		case 'm':
> > +			return V4L2_STD_NTSC_M;
> > +		case 'j':
> > +			return V4L2_STD_NTSC_M_JP;
> > +		case 'k':
> > +			return V4L2_STD_NTSC_M_KR;
> > +		}
> > +	}
> > +	fprintf(stderr, "ntsc specifier not recognised\n");
> > +	subdev_usage();
> > +	exit(1);
> > +}
> > +
> >  void subdev_cmd(int ch, char *optarg)
> >  {
> >  	char *value, *subs;
> > @@ -338,6 +418,33 @@ void subdev_cmd(int ch, char *optarg)
> >  			}
> >  		}
> >  		break;
> > +	case OptSetSubDevStandard:
> > +		if (!strncasecmp(optarg, "pal", 3)) {
> > +			if (optarg[3])
> > +				standard = parse_pal(optarg + 3);
> > +			else
> > +				standard = V4L2_STD_PAL;
> > +		}
> > +		else if (!strncasecmp(optarg, "ntsc", 4)) {
> > +			if (optarg[4])
> > +				standard = parse_ntsc(optarg + 4);
> > +			else
> > +				standard = V4L2_STD_NTSC;
> > +		}
> > +		else if (!strncasecmp(optarg, "secam", 5)) {
> > +			if (optarg[5])
> > +				standard = parse_secam(optarg + 5);
> > +			else
> > +				standard = V4L2_STD_SECAM;
> > +		}
> > +		else if (isdigit(optarg[0])) {
> > +			standard = strtol(optarg, 0L, 0) | (1ULL << 63);
> > +		} else {
> > +			fprintf(stderr, "Unknown standard '%s'\n", optarg);
> > +			subdev_usage();
> > +			exit(1);
> > +		}
> > +		break;
> >  	default:
> >  		break;
> >  	}
> > @@ -492,6 +599,19 @@ void subdev_set(int fd)
> >  					fival.interval.denominator, fival.interval.numerator);
> >  		}
> >  	}
> > +
> > +	if (options[OptSetSubDevStandard]) {
> > +		if (standard & (1ULL << 63)) {
> > +			struct v4l2_standard vs;
> > +
> > +			vs.index = standard & 0xffff;
> > +			if (test_ioctl(fd, VIDIOC_SUBDEV_ENUMSTD, &vs) >= 0) {
> > +				standard = vs.id;
> > +			}
> > +		}
> > +		if (doioctl(fd, VIDIOC_SUBDEV_S_STD, &standard) == 0)
> > +			printf("Standard set to %08llx\n", (unsigned long long)standard);
> > +	}
> >  }
> >  
> >  void subdev_get(int fd)
> > @@ -547,6 +667,20 @@ void subdev_get(int fd)
> >  					fival.interval.denominator, fival.interval.numerator);
> >  		}
> >  	}
> > +
> > +	if (options[OptGetSubDevStandard]) {
> > +		if (doioctl(fd, VIDIOC_SUBDEV_G_STD, &standard) == 0) {
> > +			printf("Video Standard = 0x%08llx\n", (unsigned long long)standard);
> > +			printf("\t%s\n", std2s(standard, "\n\t").c_str());
> > +		}
> > +	}
> > +
> > +	if (options[OptQuerySubDevStandard]) {
> > +		if (doioctl(fd, VIDIOC_SUBDEV_QUERYSTD, &standard) == 0) {
> > +			printf("Video Standard = 0x%08llx\n", (unsigned long long)standard);
> > +			printf("\t%s\n", std2s(standard, "\n\t").c_str());
> > +		}
> > +	}
> >  }
> >  
> >  static void print_mbus_code(__u32 code)
> > @@ -637,4 +771,28 @@ void subdev_list(int fd)
> >  			frmival.index++;
> >  		}
> >  	}
> > +
> > +	if (options[OptListSubDevStandards]) {
> > +		struct v4l2_standard vs;
> > +
> > +		printf("ioctl: VIDIOC_SUBDEV_ENUMSTD\n");
> > +		vs.index = 0;
> > +		while (test_ioctl(fd, VIDIOC_SUBDEV_ENUMSTD, &vs) >= 0) {
> > +			if (options[OptConcise]) {
> > +				printf("\t%2d: 0x%016llX %s\n", vs.index,
> > +						(unsigned long long)vs.id, vs.name);
> > +			} else {
> > +				if (vs.index)
> > +					printf("\n");
> > +				printf("\tIndex       : %d\n", vs.index);
> > +				printf("\tID          : 0x%016llX\n", (unsigned long long)vs.id);
> > +				printf("\tName        : %s\n", vs.name);
> > +				printf("\tFrame period: %d/%d\n",
> > +						vs.frameperiod.numerator,
> > +						vs.frameperiod.denominator);
> > +				printf("\tFrame lines : %d\n", vs.framelines);
> > +			}
> > +			vs.index++;
> > +		}
> > +	}
> >  }
> > diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
> > index 2a87c48f1dbee797..9b15c40c36393a96 100644
> > --- a/utils/v4l2-ctl/v4l2-ctl.cpp
> > +++ b/utils/v4l2-ctl/v4l2-ctl.cpp
> > @@ -271,6 +271,10 @@ static struct option long_options[] = {
> >  	{"stream-out-user", optional_argument, 0, OptStreamOutUser},
> >  	{"stream-out-dmabuf", no_argument, 0, OptStreamOutDmaBuf},
> >  	{"list-patterns", no_argument, 0, OptListPatterns},
> > +	{"list-subdev-standards", no_argument, 0, OptListSubDevStandards},
> > +	{"get-subdev-standard", no_argument, 0, OptGetSubDevStandard},
> > +	{"set-subdev-standard", required_argument, 0, OptSetSubDevStandard},
> > +	{"get-subdev-detected-standard", no_argument, 0, OptQuerySubDevStandard},
> >  	{0, 0, 0, 0}
> >  };
> >  
> > diff --git a/utils/v4l2-ctl/v4l2-ctl.h b/utils/v4l2-ctl/v4l2-ctl.h
> > index e510d778deb04984..d99fa74c1244023d 100644
> > --- a/utils/v4l2-ctl/v4l2-ctl.h
> > +++ b/utils/v4l2-ctl/v4l2-ctl.h
> > @@ -124,6 +124,10 @@ enum Option {
> >  	OptListSubDevMBusCodes,
> >  	OptListSubDevFrameSizes,
> >  	OptListSubDevFrameIntervals,
> > +	OptListSubDevStandards,
> > +	OptGetSubDevStandard,
> > +	OptSetSubDevStandard,
> > +	OptQuerySubDevStandard,
> >  	OptListOutFields,
> >  	OptClearClips,
> >  	OptClearBitmap,
> > 
> 

-- 
Regards,
Niklas Söderlund
