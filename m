Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([213.240.235.226]:36462 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755967Ab1JDL6f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Oct 2011 07:58:35 -0400
Subject: Re: Help with omap3isp resizing
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Paul Chiha <paul.chiha@greyinnovation.com>,
	linux-media@vger.kernel.org
Date: Tue, 04 Oct 2011 14:46:32 +0300
In-Reply-To: <201110041303.03055.laurent.pinchart@ideasonboard.com>
References: <51A4F524D105AA4C93787F33E2C90E62EE5203@greysvr02.GreyInnovation.local>
	 <201110041303.03055.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1317728792.8358.49.camel@iivanov-desktop>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Paul,

On Tue, 2011-10-04 at 13:03 +0200, Laurent Pinchart wrote:
> Hi Paul,
> 
> On Monday 03 October 2011 07:51:34 Paul Chiha wrote:
> > Hi,
> > 
> > I've been having trouble getting the resizer to work, and mainly because
> > I don't know how to correctly configure it.
> > I'm using kernel 2.6.37 on arm DM37x board.
> > 
> > I've been able to configure the media links sensor=>ccdc=>ccdc_output
> > (all with 640x480 V4L2_MBUS_FMT_UYVY8_2X8) and VIDIOC_STREAMON works on
> > /dev/video2.
> > But if I configure media links sensor=>ccdc=>resizer=>resizer_output,
> > then VIDIOC_STREAMON fails on /dev/video6 (with pixelformat mismatch).
> > I noticed that the resizer driver only supports V4L2_MBUS_FMT_UYVY8_1X16
> > & V4L2_MBUS_FMT_YUYV8_1X16, so I tried again with all the links set to
> > V4L2_MBUS_FMT_UYVY8_1X16 instead, but then ioctl VIDIOC_SUBDEV_S_FMT
> > fails on /dev/v4l-subdev8, because the sensor driver doesn't support
> > 1X16.
> > Then I tried using V4L2_MBUS_FMT_UYVY8_2X8 for the sensor and
> > V4L2_MBUS_FMT_UYVY8_1X16 for the resizer, but it either failed with
> > pixelformat mismatch or link pipeline mismatch, depending on which pads
> > were different.
> > 
> > Can someone please tell me what I need to do to make this work?
> 
> Long story short, I don't think that pipeline has ever been tested. I'm 
> unfortunately lacking hardware to work on that, as none of my OMAP3 hardware 
> has a YUV input.

If i am not mistaken currently resizer sub device supports only:

/* resizer pixel formats */
static const unsigned int resizer_formats[] = {
	V4L2_MBUS_FMT_UYVY8_1X16,
	V4L2_MBUS_FMT_YUYV8_1X16,
};

Adding something like this [1] in ispresizer.c  should add
support 2X8 formats. Completely untested :-).

Regards, 
iivanov


[1]

@@ -1307,6 +1311,10 @@ static int resizer_s_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 static const unsigned int resizer_formats[] = {
 	V4L2_MBUS_FMT_UYVY8_1X16,
 	V4L2_MBUS_FMT_YUYV8_1X16,
+	V4L2_MBUS_FMT_UYVY8_2X8,
+	V4L2_MBUS_FMT_VYUY8_2X8,
+	V4L2_MBUS_FMT_YUYV8_2X8,
+	V4L2_MBUS_FMT_YVYU8_2X8,
 };
 
 static unsigned int resizer_max_in_width(struct isp_res_device *res)
@@ -1340,12 +1348,21 @@ static void resizer_try_format(struct isp_res_device *res,
 	struct resizer_ratio ratio;
 	struct v4l2_rect crop;
 
+	switch (fmt->code) {
+
+	case V4L2_MBUS_FMT_YUYV8_1X16:
+	case V4L2_MBUS_FMT_UYVY8_1X16:
+	case V4L2_MBUS_FMT_UYVY8_2X8:
+	case V4L2_MBUS_FMT_VYUY8_2X8:
+	case V4L2_MBUS_FMT_YUYV8_2X8:
+	case V4L2_MBUS_FMT_YVYU8_2X8:
+		break;
+	default:
+		fmt->code = V4L2_MBUS_FMT_YUYV8_1X16;
+	}
+
 	switch (pad) {
 	case RESZ_PAD_SINK:
-		if (fmt->code != V4L2_MBUS_FMT_YUYV8_1X16 &&
-		    fmt->code != V4L2_MBUS_FMT_UYVY8_1X16)
-			fmt->code = V4L2_MBUS_FMT_YUYV8_1X16;
-
 		fmt->width = clamp_t(u32, fmt->width, MIN_IN_WIDTH,
 				     resizer_max_in_width(res));
 		fmt->height = clamp_t(u32, fmt->height, MIN_IN_HEIGHT,


