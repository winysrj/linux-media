Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:18253 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730474AbeGZWqu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Jul 2018 18:46:50 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH] v4l2-ctl: add support for SUBDEV_{G_STD,S_STD,QUERYSTD}
Date: Thu, 26 Jul 2018 23:27:56 +0200
Message-Id: <20180726212756.13289-1-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Add four new options: --list-subdev-standards, --get-subdev-standard,
--set-subdev-standard and --get-subdev-detected-standard.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 utils/v4l2-ctl/v4l2-ctl-subdev.cpp | 158 +++++++++++++++++++++++++++++
 utils/v4l2-ctl/v4l2-ctl.cpp        |   4 +
 utils/v4l2-ctl/v4l2-ctl.h          |   4 +
 3 files changed, 166 insertions(+)

diff --git a/utils/v4l2-ctl/v4l2-ctl-subdev.cpp b/utils/v4l2-ctl/v4l2-ctl-subdev.cpp
index c1d3e5ad46f763fb..d08c04e787810516 100644
--- a/utils/v4l2-ctl/v4l2-ctl-subdev.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-subdev.cpp
@@ -48,6 +48,7 @@ static struct v4l2_subdev_frame_size_enum frmsize;
 static struct v4l2_subdev_frame_interval_enum frmival;
 static __u32 set_fps_pad;
 static double set_fps;
+static v4l2_std_id standard;
 
 void subdev_usage(void)
 {
@@ -96,9 +97,88 @@ void subdev_usage(void)
 	       "                     flags=le|ge|keep-config\n"
 	       "  --set-subdev-fps pad=<pad>,fps=<fps> (for testing only, otherwise use media-ctl)\n"
 	       "                     set the frame rate [VIDIOC_SUBDEV_S_FRAME_INTERVAL]\n"
+	       "  --list-subdev-standards display supported video standards [VIDIOC_SUBDEV_ENUMSTD]\n"
+	       "  --get-subdev-standard\n"
+	       "                     query the video standard [VIDIOC_SUBDEV_G_STD]\n"
+	       "  --set-subdev-standard <num>\n"
+	       "                     set the video standard to <num> [VIDIOC_SUBDEV_S_STD]\n"
+	       "                     <num> a numerical v4l2_std value, or one of:\n"
+	       "                     pal or pal-X (X = B/G/H/N/Nc/I/D/K/M/60) (V4L2_STD_PAL)\n"
+	       "                     ntsc or ntsc-X (X = M/J/K) (V4L2_STD_NTSC)\n"
+	       "                     secam or secam-X (X = B/G/H/D/K/L/Lc) (V4L2_STD_SECAM)\n"
+	       "  --get-subdev-detected-standard\n"
+	       "                     display detected input video standard [VIDIOC_SUBDEV_QUERYSTD]\n"
 	       );
 }
 
+static v4l2_std_id parse_pal(const char *pal)
+{
+	if (pal[0] == '-') {
+		switch (tolower(pal[1])) {
+		case '6':
+			return V4L2_STD_PAL_60;
+		case 'b':
+		case 'g':
+			return V4L2_STD_PAL_BG;
+		case 'h':
+			return V4L2_STD_PAL_H;
+		case 'n':
+			if (tolower(pal[2]) == 'c')
+				return V4L2_STD_PAL_Nc;
+			return V4L2_STD_PAL_N;
+		case 'i':
+			return V4L2_STD_PAL_I;
+		case 'd':
+		case 'k':
+			return V4L2_STD_PAL_DK;
+		case 'm':
+			return V4L2_STD_PAL_M;
+		}
+	}
+	fprintf(stderr, "pal specifier not recognised\n");
+	subdev_usage();
+	exit(1);
+}
+
+static v4l2_std_id parse_secam(const char *secam)
+{
+	if (secam[0] == '-') {
+		switch (tolower(secam[1])) {
+		case 'b':
+		case 'g':
+		case 'h':
+			return V4L2_STD_SECAM_B | V4L2_STD_SECAM_G | V4L2_STD_SECAM_H;
+		case 'd':
+		case 'k':
+			return V4L2_STD_SECAM_DK;
+		case 'l':
+			if (tolower(secam[2]) == 'c')
+				return V4L2_STD_SECAM_LC;
+			return V4L2_STD_SECAM_L;
+		}
+	}
+	fprintf(stderr, "secam specifier not recognised\n");
+	subdev_usage();
+	exit(1);
+}
+
+static v4l2_std_id parse_ntsc(const char *ntsc)
+{
+	if (ntsc[0] == '-') {
+		switch (tolower(ntsc[1])) {
+		case 'm':
+			return V4L2_STD_NTSC_M;
+		case 'j':
+			return V4L2_STD_NTSC_M_JP;
+		case 'k':
+			return V4L2_STD_NTSC_M_KR;
+		}
+	}
+	fprintf(stderr, "ntsc specifier not recognised\n");
+	subdev_usage();
+	exit(1);
+}
+
 void subdev_cmd(int ch, char *optarg)
 {
 	char *value, *subs;
@@ -338,6 +418,33 @@ void subdev_cmd(int ch, char *optarg)
 			}
 		}
 		break;
+	case OptSetSubDevStandard:
+		if (!strncasecmp(optarg, "pal", 3)) {
+			if (optarg[3])
+				standard = parse_pal(optarg + 3);
+			else
+				standard = V4L2_STD_PAL;
+		}
+		else if (!strncasecmp(optarg, "ntsc", 4)) {
+			if (optarg[4])
+				standard = parse_ntsc(optarg + 4);
+			else
+				standard = V4L2_STD_NTSC;
+		}
+		else if (!strncasecmp(optarg, "secam", 5)) {
+			if (optarg[5])
+				standard = parse_secam(optarg + 5);
+			else
+				standard = V4L2_STD_SECAM;
+		}
+		else if (isdigit(optarg[0])) {
+			standard = strtol(optarg, 0L, 0) | (1ULL << 63);
+		} else {
+			fprintf(stderr, "Unknown standard '%s'\n", optarg);
+			subdev_usage();
+			exit(1);
+		}
+		break;
 	default:
 		break;
 	}
@@ -492,6 +599,19 @@ void subdev_set(int fd)
 					fival.interval.denominator, fival.interval.numerator);
 		}
 	}
+
+	if (options[OptSetSubDevStandard]) {
+		if (standard & (1ULL << 63)) {
+			struct v4l2_standard vs;
+
+			vs.index = standard & 0xffff;
+			if (test_ioctl(fd, VIDIOC_SUBDEV_ENUMSTD, &vs) >= 0) {
+				standard = vs.id;
+			}
+		}
+		if (doioctl(fd, VIDIOC_SUBDEV_S_STD, &standard) == 0)
+			printf("Standard set to %08llx\n", (unsigned long long)standard);
+	}
 }
 
 void subdev_get(int fd)
@@ -547,6 +667,20 @@ void subdev_get(int fd)
 					fival.interval.denominator, fival.interval.numerator);
 		}
 	}
+
+	if (options[OptGetSubDevStandard]) {
+		if (doioctl(fd, VIDIOC_SUBDEV_G_STD, &standard) == 0) {
+			printf("Video Standard = 0x%08llx\n", (unsigned long long)standard);
+			printf("\t%s\n", std2s(standard, "\n\t").c_str());
+		}
+	}
+
+	if (options[OptQuerySubDevStandard]) {
+		if (doioctl(fd, VIDIOC_SUBDEV_QUERYSTD, &standard) == 0) {
+			printf("Video Standard = 0x%08llx\n", (unsigned long long)standard);
+			printf("\t%s\n", std2s(standard, "\n\t").c_str());
+		}
+	}
 }
 
 static void print_mbus_code(__u32 code)
@@ -637,4 +771,28 @@ void subdev_list(int fd)
 			frmival.index++;
 		}
 	}
+
+	if (options[OptListSubDevStandards]) {
+		struct v4l2_standard vs;
+
+		printf("ioctl: VIDIOC_SUBDEV_ENUMSTD\n");
+		vs.index = 0;
+		while (test_ioctl(fd, VIDIOC_SUBDEV_ENUMSTD, &vs) >= 0) {
+			if (options[OptConcise]) {
+				printf("\t%2d: 0x%016llX %s\n", vs.index,
+						(unsigned long long)vs.id, vs.name);
+			} else {
+				if (vs.index)
+					printf("\n");
+				printf("\tIndex       : %d\n", vs.index);
+				printf("\tID          : 0x%016llX\n", (unsigned long long)vs.id);
+				printf("\tName        : %s\n", vs.name);
+				printf("\tFrame period: %d/%d\n",
+						vs.frameperiod.numerator,
+						vs.frameperiod.denominator);
+				printf("\tFrame lines : %d\n", vs.framelines);
+			}
+			vs.index++;
+		}
+	}
 }
diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
index 2a87c48f1dbee797..9b15c40c36393a96 100644
--- a/utils/v4l2-ctl/v4l2-ctl.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl.cpp
@@ -271,6 +271,10 @@ static struct option long_options[] = {
 	{"stream-out-user", optional_argument, 0, OptStreamOutUser},
 	{"stream-out-dmabuf", no_argument, 0, OptStreamOutDmaBuf},
 	{"list-patterns", no_argument, 0, OptListPatterns},
+	{"list-subdev-standards", no_argument, 0, OptListSubDevStandards},
+	{"get-subdev-standard", no_argument, 0, OptGetSubDevStandard},
+	{"set-subdev-standard", required_argument, 0, OptSetSubDevStandard},
+	{"get-subdev-detected-standard", no_argument, 0, OptQuerySubDevStandard},
 	{0, 0, 0, 0}
 };
 
diff --git a/utils/v4l2-ctl/v4l2-ctl.h b/utils/v4l2-ctl/v4l2-ctl.h
index e510d778deb04984..d99fa74c1244023d 100644
--- a/utils/v4l2-ctl/v4l2-ctl.h
+++ b/utils/v4l2-ctl/v4l2-ctl.h
@@ -124,6 +124,10 @@ enum Option {
 	OptListSubDevMBusCodes,
 	OptListSubDevFrameSizes,
 	OptListSubDevFrameIntervals,
+	OptListSubDevStandards,
+	OptGetSubDevStandard,
+	OptSetSubDevStandard,
+	OptQuerySubDevStandard,
 	OptListOutFields,
 	OptClearClips,
 	OptClearBitmap,
-- 
2.18.0
