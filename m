Return-path: <linux-media-owner@vger.kernel.org>
Received: from eth1683.vic.adsl.internode.on.net ([150.101.217.146]:3272 "EHLO
	greyinnovation.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753223Ab1JFD3B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2011 23:29:01 -0400
Content-class: urn:content-classes:message
Subject: Re: Help with omap3isp resizing
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Date: Thu, 6 Oct 2011 14:29:23 +1100
Message-ID: <51A4F524D105AA4C93787F33E2C90E62EE5443@greysvr02.GreyInnovation.local>
In-Reply-To: <20111005105438.GA8614@valkosipuli.localdomain>
References: <51A4F524D105AA4C93787F33E2C90E62EE5203@greysvr02.GreyInnovation.local> <201110041350.33441.laurent.pinchart@ideasonboard.com> <1317729252.8358.54.camel@iivanov-desktop> <201110041500.56885.laurent.pinchart@ideasonboard.com> <51A4F524D105AA4C93787F33E2C90E62EE5350@greysvr02.GreyInnovation.local> <20111005105438.GA8614@valkosipuli.localdomain>
From: "Paul Chiha" <paul.chiha@greyinnovation.com>
To: "Sakari Ailus" <sakari.ailus@iki.fi>,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
	<linux-media@vger.kernel.org>,
	"Sakari Ailus" <sakari.ailus@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday, 5 October 2011 9:55 PM Sakari Ailus wrote:
> On Wed, Oct 05, 2011 at 01:51:29PM +1100, Paul Chiha wrote:
> > On Tue, Oct 04, 2011 at 03:00:55PM +0200, Laurent Pinchart wrote:
> > > Hi Ivan,
> > >
> > > On Tuesday 04 October 2011 13:54:12 Ivan T. Ivanov wrote:
> > > > On Tue, 2011-10-04 at 13:50 +0200, Laurent Pinchart wrote:
> > > > > On Tuesday 04 October 2011 13:46:32 Ivan T. Ivanov wrote:
> > > > > > On Tue, 2011-10-04 at 13:03 +0200, Laurent Pinchart wrote:
> > > > > > > On Monday 03 October 2011 07:51:34 Paul Chiha wrote:
> > > > > > > > Hi,
> > > > > > > >
> > > > > > > > I've been having trouble getting the resizer to work,
and
> > > > > > > > mainly because I don't know how to correctly configure
it.
> > > > > > > > I'm using kernel 2.6.37 on arm DM37x board.
> > > > > > > >
> > > > > > > > I've been able to configure the media links
> > > > > > > > sensor=>ccdc=>ccdc_output (all with 640x480
> > > > > > > > V4L2_MBUS_FMT_UYVY8_2X8) and VIDIOC_STREAMON works on
> > > /dev/video2.
> > > > > > > > But if I configure media links
> > > > > > > > sensor=>ccdc=>resizer=>resizer_output, then
> > > > > > > > VIDIOC_STREAMON fails on /dev/video6 (with pixelformat
> > > > > > > > mismatch). I noticed that the resizer driver only
supports
> > > > > > > > V4L2_MBUS_FMT_UYVY8_1X16 & V4L2_MBUS_FMT_YUYV8_1X16,
> so I
> > > > > > > > tried again with all the links set to
> > > > > > > > V4L2_MBUS_FMT_UYVY8_1X16 instead, but then ioctl
> > > > > > > > VIDIOC_SUBDEV_S_FMT fails on /dev/v4l-subdev8, because
the
> sensor driver doesn't support 1X16.
> > > > > > > > Then I tried using V4L2_MBUS_FMT_UYVY8_2X8 for the
sensor
> > > > > > > > and
> > > > > > > > V4L2_MBUS_FMT_UYVY8_1X16 for the resizer, but it either
> > > > > > > > failed with pixelformat mismatch or link pipeline
> > > > > > > > mismatch, depending on which pads were different.
> > > > > > > >
> > > > > > > > Can someone please tell me what I need to do to make
this work?
> > > > > > >
> > > > > > > Long story short, I don't think that pipeline has ever
been tested.
> > > > > > > I'm unfortunately lacking hardware to work on that, as
none
> > > > > > > of my
> > > > > > > OMAP3 hardware has a YUV input.
> > > > > >
> > > > > > If i am not mistaken currently resizer sub device supports
only:
> > > > > >
> > > > > > /* resizer pixel formats */
> > > > > > static const unsigned int resizer_formats[] = {
> > > > > >
> > > > > > 	V4L2_MBUS_FMT_UYVY8_1X16,
> > > > > > 	V4L2_MBUS_FMT_YUYV8_1X16,
> > > > > >
> > > > > > };
> > > > > >
> > > > > > Adding something like this [1] in ispresizer.c  should add
> > > > > > support
> > > > > > 2X8 formats. Completely untested :-).
> > > > > >
> > > > > > Regards,
> > > > > > iivanov
> > > > > >
> > > > > >
> > > > > > [1]
> > > > > >
> > > > > > @@ -1307,6 +1311,10 @@ static int resizer_s_crop(struct
> > > > > > v4l2_subdev *sd, struct v4l2_subdev_fh *fh, static const
> > > > > > unsigned int resizer_formats[] = {
> > > > > >
> > > > > >  	V4L2_MBUS_FMT_UYVY8_1X16,
> > > > > >  	V4L2_MBUS_FMT_YUYV8_1X16,
> > > > > >
> > > > > > +	V4L2_MBUS_FMT_UYVY8_2X8,
> > > > > > +	V4L2_MBUS_FMT_VYUY8_2X8,
> > > > > > +	V4L2_MBUS_FMT_YUYV8_2X8,
> > > > > > +	V4L2_MBUS_FMT_YVYU8_2X8,
> > > > > >
> > > > > >  };
> > > > >
> > > > > I'd rather modify ispccdc.c to output
V4L2_MBUS_FMT_YUYV8_1X16.
> > > > > What do you think ?
> > > >
> > > > For memory->Resizer->memory use cases, CCDC is no involved in
pipeline.
> > >
> > > But the original poster wants to use the sensor -> ccdc -> resizer
> > > -> resizer output pipeline.
> > >
> > > > Also several sensor drivers that i have checked, usually define
> > > > its output as 2X8 output. I think is more natural to add 2X8
> > > > support to CCDC and Resizer engines instead to modifying exiting
drivers.
> > >
> > > Sure, sensor drivers should not be modified. What I was talking
> > > about was to configure the pipeline as
> > >
> > > sensor:0 [YUYV8_2X8], CCDC:0 [YUYV8_2X8], CCDC:1 [YUYV8_1X16],
> > > resizer:0 [YUYV8_1X16]
> > >
> > > --
> > > Regards,
> > >
> > > Laurent Pinchart
> >
> > Thanks for your help. I've updated ispccdc.c to support the _1X16
> > codes and the pipeline seems to work now. However, I needed to take
> > out the memcpy in ccdc_try_format(), because otherwise pad 0 format
> > was being copied to pad 1 or 2, regardless of what pad 1 or 2 were
> > being set to. I'm not sure why it was done that way. I think it's
> > better that the given code gets checked to see if it's in the list
and
> > if so use it. Do you know of any valid reason why this copy is done?
> 
> If I remember corretly, it's because there's nothing the CCDC may do
to the size
> of the image --- the driver doesn't either support cropping on the
CCDC. The sink
> format used to be always the same as the source format, the assumption
which
> no longer is valid when YUYV8_2X8 etc. formats are supported. This
must be
> taken into account, i.e. YUYV8_2X8 must be converted to YUYV8_1X16
instead of
> just copying the format as such.
> 
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk

FYI ... here's the diff of the ISP CCDC changes I made to get the
sensor->ccdc->resizer pipeline to work.
Note: it's based on kernel 2.6.37.

--- drivers/media/video/isp/ispccdc.c
+++ drivers/media/video/isp/ispccdc.c 
@@ -53,6 +53,10 @@
        V4L2_MBUS_FMT_SGBRG12_1X12,
        V4L2_MBUS_FMT_UYVY8_2X8,
        V4L2_MBUS_FMT_YUYV8_2X8,
+       V4L2_MBUS_FMT_UYVY8_1X16,
+       V4L2_MBUS_FMT_VYUY8_1X16,
+       V4L2_MBUS_FMT_YUYV8_1X16,
+       V4L2_MBUS_FMT_YVYU8_1X16,
 };
 
 /*
@@ -791,7 +795,7 @@
        format = &ccdc->formats[CCDC_PAD_SINK];
 
        if ((format->code != V4L2_MBUS_FMT_UYVY8_2X8) &&
-                       (format->code != V4L2_MBUS_FMT_UYVY8_2X8))
+                       (format->code != V4L2_MBUS_FMT_YUYV8_2X8))
                ccdc->update = OMAP3ISP_CCDC_ALAW | OMAP3ISP_CCDC_LPF
                             | OMAP3ISP_CCDC_BLCLAMP |
OMAP3ISP_CCDC_BCOMP;
 
@@ -1167,12 +1171,22 @@
        /* CCDC_PAD_SINK */
        format = &ccdc->formats[CCDC_PAD_SINK];
 
-       if ((format->code == V4L2_MBUS_FMT_YUYV8_2X8) ||
-                       (format->code == V4L2_MBUS_FMT_UYVY8_2X8)) {
+       switch (format->code) {
+       case V4L2_MBUS_FMT_YUYV8_2X8:
+       case V4L2_MBUS_FMT_UYVY8_2X8:
                if (pdata->is_bt656)
                        syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR8;
                else
                        syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR16;
+               break;
+       case V4L2_MBUS_FMT_UYVY8_1X16:
+       case V4L2_MBUS_FMT_VYUY8_1X16:
+       case V4L2_MBUS_FMT_YUYV8_1X16:
+       case V4L2_MBUS_FMT_YVYU8_1X16:
+               syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR16;
+               break;
+       default:
+               ;
        }
 
        isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC,
ISPCCDC_SYN_MODE);
@@ -1199,10 +1213,19 @@
                ccdc_pattern = ccdc_sgrbg_pattern;
                break;
        }
-       if ((format->code != V4L2_MBUS_FMT_YUYV8_2X8) &&
-                       (format->code != V4L2_MBUS_FMT_UYVY8_2X8))
-       ispccdc_config_imgattr(ccdc, ccdc_pattern);
 
+       switch (format->code) {
+       case V4L2_MBUS_FMT_YUYV8_2X8:
+       case V4L2_MBUS_FMT_UYVY8_2X8:
+       case V4L2_MBUS_FMT_UYVY8_1X16:
+       case V4L2_MBUS_FMT_VYUY8_1X16:
+       case V4L2_MBUS_FMT_YUYV8_1X16:
+       case V4L2_MBUS_FMT_YVYU8_1X16:
+               break;
+       default:
+               ispccdc_config_imgattr(ccdc, ccdc_pattern);
+       }
+
        /* BT656: Generate VD0 on the last line of each field, and we
         * don't use VD1.
         * Non BT656: Generate VD0 on the last line of the image and VD1
on the
@@ -1870,20 +1893,21 @@
        unsigned int height = fmt->height;
        unsigned int i;
 
+       for (i = 0; i < ARRAY_SIZE(ccdc_fmts); i++) {
+               if (fmt->code == ccdc_fmts[i])
+                       break;
+       }
+
+       /* If not found, use SGRBG10 as default */
+       if (i >= ARRAY_SIZE(ccdc_fmts))
+               fmt->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+
        switch (pad) {
        case CCDC_PAD_SINK:
                /* TODO: If the CCDC output formatter pad is connected
directly
                 * to the resizer, only YUV formats can be used.
                 */
-               for (i = 0; i < ARRAY_SIZE(ccdc_fmts); i++) {
-                       if (fmt->code == ccdc_fmts[i])
-                               break;
-               }
 
-               /* If not found, use SGRBG10 as default */
-               if (i >= ARRAY_SIZE(ccdc_fmts))
-                       fmt->code = V4L2_MBUS_FMT_SGRBG10_1X10;
-
                /* Clamp the input size. */
                fmt->width = clamp_t(u32, width, 32, 4096);
                fmt->height = clamp_t(u32, height, 32, 4096);
@@ -1891,21 +1915,19 @@
 
        case CCDC_PAD_SOURCE_OF:
                format = __ccdc_get_format(ccdc, fh, CCDC_PAD_SINK,
which);
-               memcpy(fmt, format, sizeof(*fmt));
 
                /* The data formatter truncates the number of horizontal
output
                 * pixels to a multiple of 16. To avoid clipping data,
allow
                 * callers to request an output size bigger than the
input size
                 * up to the nearest multiple of 16.
                 */
-               fmt->width = clamp_t(u32, width, 32, (fmt->width + 15) &
~15);
+               fmt->width = clamp_t(u32, width, 32, format->width +
15);
                fmt->width &= ~15;
-               fmt->height = clamp_t(u32, height, 32, fmt->height);
+               fmt->height = clamp_t(u32, height, 32, format->height);
                break;
 
        case CCDC_PAD_SOURCE_VP:
                format = __ccdc_get_format(ccdc, fh, CCDC_PAD_SINK,
which);
-               memcpy(fmt, format, sizeof(*fmt));
 
                /* The video port interface truncates the data to 10
bits. */
                info = isp_video_format_info(fmt->code);
@@ -1915,8 +1937,8 @@
                 * port output must be at least one line less than the
number
                 * of input lines.
                 */
-               fmt->width = clamp_t(u32, width, 32, fmt->width);
-               fmt->height = clamp_t(u32, height, 32, fmt->height - 1);
+               fmt->width = clamp_t(u32, width, 32, format->width);
+               fmt->height = clamp_t(u32, height, 32, format->height -
1);
                break;
        }

