Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46488 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab1CUVkT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2011 17:40:19 -0400
Received: by wya21 with SMTP id 21so6176272wya.19
        for <linux-media@vger.kernel.org>; Mon, 21 Mar 2011 14:40:18 -0700 (PDT)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: [PATCH/RFC] v4l2-ctl: Add -m option for the multi-planar API
Date: Mon, 21 Mar 2011 22:40:10 +0100
Message-Id: <1300743610-4585-1-git-send-email-snjw23@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add -m option to force using the multiplanar API. That is,
where applicable, instead of V4L2_BUF_TYPE_VIDEO_[OUTPUT/CAPTURE]
buffer types their *_MPLANE counterparts are used when this option
is enabled.

Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>

---
Hello,

This patch has been tested with vivi, after applying a basic
support for multi-planar formats. I intend to also post
the vivi patch after completing the image generation bits.

Regards,
Sylwester
---
 utils/v4l2-ctl/v4l2-ctl.cpp |   93 +++++++++++++++++++++++++++++++++++++-----
 1 files changed, 82 insertions(+), 11 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
index 3db26ab..efd45b8 100644
--- a/utils/v4l2-ctl/v4l2-ctl.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl.cpp
@@ -68,6 +68,7 @@ enum Option {
 	OptSetInput = 'i',
 	OptListCtrls = 'l',
 	OptListCtrlsMenus = 'L',
+	OptUseMultiplanarApi = 'm',
 	OptListOutputs = 'N',
 	OptListInputs = 'n',
 	OptGetOutput = 'O',
@@ -223,6 +224,7 @@ static struct option long_options[] = {
 	{"try-fmt-video-out", required_argument, 0, OptTryVideoOutFormat},
 	{"help", no_argument, 0, OptHelp},
 	{"wrapper", no_argument, 0, OptUseWrapper},
+	{"multiplanar-api", no_argument, 0, OptUseMultiplanarApi},
 	{"get-output", no_argument, 0, OptGetOutput},
 	{"set-output", required_argument, 0, OptSetOutput},
 	{"list-outputs", no_argument, 0, OptListOutputs},
@@ -509,6 +511,9 @@ static void usage(void)
 	       "  --sleep=<secs>     sleep for <secs> seconds, call QUERYCAP and close the file handle\n"
 	       "  --streamoff        turn the stream off [VIDIOC_STREAMOFF]\n"
 	       "  --streamon         turn the stream on [VIDIOC_STREAMON]\n"
+	       "  -m, --multiplanar-api\n"
+	       "                     force using the multiplanar API; it is applicable to video output\n"
+	       "                     and video capture devices\n"
 	       "  --log-status       log the board status in the kernel log [VIDIOC_LOG_STATUS]\n");
 	exit(0);
 }
@@ -541,8 +546,12 @@ static std::string buftype2s(int type)
 	switch (type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 		return "Video Capture";
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		return "Video Capture Multiplanar";
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
 		return "Video Output";
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		return "Video Output Multiplanar";
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 		return "Video Overlay";
 	case V4L2_BUF_TYPE_VBI_CAPTURE:
@@ -1064,6 +1073,19 @@ static void printfmt(const struct v4l2_format &vfmt)
 		if (vfmt.fmt.pix.priv)
 			printf("\tCustom Info   : %08x\n", vfmt.fmt.pix.priv);
 		break;
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		printf("\tWidth/Height      : %u/%u\n", vfmt.fmt.pix_mp.width, vfmt.fmt.pix_mp.height);
+		printf("\tPixel Format      : '%s'\n", fcc2s(vfmt.fmt.pix_mp.pixelformat).c_str());
+		printf("\tField             : %s\n", field2s(vfmt.fmt.pix_mp.field).c_str());
+		printf("\tNumber of planes  : %u\n", vfmt.fmt.pix_mp.num_planes);
+		printf("\tColorspace        : %s\n", colorspace2s(vfmt.fmt.pix_mp.colorspace).c_str());
+		for (int i = 0; i < vfmt.fmt.pix_mp.num_planes; i++) {
+			printf("\tPlane %d           :\n", i);
+			printf("\t   Bytes per Line : %u\n", vfmt.fmt.pix_mp.plane_fmt[i].bytesperline);
+			printf("\t   Size Image     : %u\n", vfmt.fmt.pix_mp.plane_fmt[i].sizeimage);
+		}
+		break;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 		printf("\tLeft/Top    : %d/%d\n",
@@ -1302,8 +1324,12 @@ static std::string cap2s(unsigned cap)

 	if (cap & V4L2_CAP_VIDEO_CAPTURE)
 		s += "\t\tVideo Capture\n";
+	if (cap & V4L2_CAP_VIDEO_CAPTURE_MPLANE)
+		s += "\t\tVideo Capture Multiplanar\n";
 	if (cap & V4L2_CAP_VIDEO_OUTPUT)
 		s += "\t\tVideo Output\n";
+	if (cap & V4L2_CAP_VIDEO_OUTPUT_MPLANE)
+		s += "\t\tVideo Output Multiplanar\n";
 	if (cap & V4L2_CAP_VIDEO_OVERLAY)
 		s += "\t\tVideo Overlay\n";
 	if (cap & V4L2_CAP_VIDEO_OUTPUT_OVERLAY)
@@ -1845,12 +1871,13 @@ static __u32 parse_event(const char *e)
 	return event;
 }

-static __u32 find_pixel_format(int fd, unsigned index)
+static __u32 find_pixel_format(int fd, unsigned index, bool multiplanar)
 {
 	struct v4l2_fmtdesc fmt;

 	fmt.index = index;
-	fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	fmt.type = multiplanar ?
+		V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE : V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	if (doioctl(fd, VIDIOC_ENUM_FMT, &fmt))
 		return 0;
 	return fmt.pixelformat;
@@ -2657,7 +2684,8 @@ int main(int argc, char **argv)
 		}
 	}

-	if (options[OptSetVideoFormat] || options[OptTryVideoFormat]) {
+	if (!options[OptUseMultiplanarApi] &&
+	    (options[OptSetVideoFormat] || options[OptTryVideoFormat])) {
 		struct v4l2_format in_vfmt;

 		in_vfmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
@@ -2670,7 +2698,36 @@ int main(int argc, char **argv)
 				in_vfmt.fmt.pix.pixelformat = vfmt.fmt.pix.pixelformat;
 				if (in_vfmt.fmt.pix.pixelformat < 256) {
 					in_vfmt.fmt.pix.pixelformat =
-						find_pixel_format(fd, in_vfmt.fmt.pix.pixelformat);
+						find_pixel_format(fd, in_vfmt.fmt.pix.pixelformat,
+								  false);
+				}
+			}
+			if (options[OptSetVideoFormat])
+				ret = doioctl(fd, VIDIOC_S_FMT, &in_vfmt);
+			else
+				ret = doioctl(fd, VIDIOC_TRY_FMT, &in_vfmt);
+			if (ret == 0 && verbose)
+				printfmt(in_vfmt);
+		}
+	}
+
+
+	if (options[OptUseMultiplanarApi] &&
+	    (options[OptSetVideoFormat] || options[OptTryVideoFormat])) {
+		struct v4l2_format in_vfmt;
+
+		in_vfmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+		if (doioctl(fd, VIDIOC_G_FMT, &in_vfmt) == 0) {
+			if (set_fmts & FmtWidth)
+				in_vfmt.fmt.pix_mp.width = vfmt.fmt.pix_mp.width;
+			if (set_fmts & FmtHeight)
+				in_vfmt.fmt.pix_mp.height = vfmt.fmt.pix_mp.height;
+			if (set_fmts & FmtPixelFormat) {
+				in_vfmt.fmt.pix_mp.pixelformat = vfmt.fmt.pix_mp.pixelformat;
+				if (in_vfmt.fmt.pix_mp.pixelformat < 256) {
+					in_vfmt.fmt.pix_mp.pixelformat =
+						find_pixel_format(fd, in_vfmt.fmt.pix_mp.pixelformat,
+								  true);
 				}
 			}
 			if (options[OptSetVideoFormat])
@@ -2884,13 +2941,19 @@ int main(int argc, char **argv)
 	/* Get options */

 	if (options[OptGetVideoFormat]) {
-		vfmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		if (options[OptUseMultiplanarApi] || options[OptAll])
+			vfmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+		else
+			vfmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 		if (doioctl(fd, VIDIOC_G_FMT, &vfmt) == 0)
 			printfmt(vfmt);
 	}

 	if (options[OptGetVideoOutFormat]) {
-		vfmt_out.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+		if (options[OptUseMultiplanarApi] || options[OptAll])
+			vfmt_out.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+		else
+			vfmt_out.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
 		if (doioctl(fd, VIDIOC_G_FMT, &vfmt_out) == 0)
 			printfmt(vfmt_out);
 	}
@@ -3384,14 +3447,20 @@ int main(int argc, char **argv)

 	if (options[OptListFormats]) {
 		printf("ioctl: VIDIOC_ENUM_FMT\n");
-		print_video_formats(fd, V4L2_BUF_TYPE_VIDEO_CAPTURE);
-		print_video_formats(fd, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+		print_video_formats(fd, options[OptUseMultiplanarApi] ?
+			V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE : V4L2_BUF_TYPE_VIDEO_CAPTURE);
+
+		print_video_formats(fd, options[OptUseMultiplanarApi] ?
+			V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE : V4L2_BUF_TYPE_VIDEO_OUTPUT);
+
 		print_video_formats(fd, V4L2_BUF_TYPE_VIDEO_OVERLAY);
 	}

 	if (options[OptListFormatsExt]) {
 		printf("ioctl: VIDIOC_ENUM_FMT\n");
-		print_video_formats_ext(fd, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+		print_video_formats_ext(fd, options[OptUseMultiplanarApi] ?
+			V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE : V4L2_BUF_TYPE_VIDEO_CAPTURE);
+
 		print_video_formats(fd, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 		print_video_formats(fd, V4L2_BUF_TYPE_VIDEO_OVERLAY);
 	}
@@ -3399,7 +3468,8 @@ int main(int argc, char **argv)
 	if (options[OptListFrameSizes]) {
 		printf("ioctl: VIDIOC_ENUM_FRAMESIZES\n");
 		if (frmsize.pixel_format < 256)
-			frmsize.pixel_format = find_pixel_format(fd, frmsize.pixel_format);
+			frmsize.pixel_format = find_pixel_format(fd, frmsize.pixel_format,
+								 options[OptUseMultiplanarApi]);
 		frmsize.index = 0;
 		while (test_ioctl(fd, VIDIOC_ENUM_FRAMESIZES, &frmsize) >= 0) {
 			print_frmsize(frmsize, "");
@@ -3410,7 +3480,8 @@ int main(int argc, char **argv)
 	if (options[OptListFrameIntervals]) {
 		printf("ioctl: VIDIOC_ENUM_FRAMEINTERVALS\n");
 		if (frmival.pixel_format < 256)
-			frmival.pixel_format = find_pixel_format(fd, frmival.pixel_format);
+			frmival.pixel_format = find_pixel_format(fd, frmival.pixel_format,
+								 options[OptUseMultiplanarApi]);
 		frmival.index = 0;
 		while (test_ioctl(fd, VIDIOC_ENUM_FRAMEINTERVALS, &frmival) >= 0) {
 			print_frmival(frmival, "");
--
1.7.1

