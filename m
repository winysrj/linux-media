Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:33918 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933569Ab1JDU72 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Oct 2011 16:59:28 -0400
Date: Tue, 4 Oct 2011 23:59:23 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
	Paul Chiha <paul.chiha@greyinnovation.com>,
	linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: Help with omap3isp resizing
Message-ID: <20111004205923.GO6180@valkosipuli.localdomain>
References: <51A4F524D105AA4C93787F33E2C90E62EE5203@greysvr02.GreyInnovation.local>
 <201110041350.33441.laurent.pinchart@ideasonboard.com>
 <1317729252.8358.54.camel@iivanov-desktop>
 <201110041500.56885.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201110041500.56885.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 04, 2011 at 03:00:55PM +0200, Laurent Pinchart wrote:
> Hi Ivan,

Hi all,

> On Tuesday 04 October 2011 13:54:12 Ivan T. Ivanov wrote:
> > On Tue, 2011-10-04 at 13:50 +0200, Laurent Pinchart wrote:
> > > On Tuesday 04 October 2011 13:46:32 Ivan T. Ivanov wrote:
> > > > On Tue, 2011-10-04 at 13:03 +0200, Laurent Pinchart wrote:
> > > > > On Monday 03 October 2011 07:51:34 Paul Chiha wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > I've been having trouble getting the resizer to work, and mainly
> > > > > > because I don't know how to correctly configure it.
> > > > > > I'm using kernel 2.6.37 on arm DM37x board.
> > > > > > 
> > > > > > I've been able to configure the media links
> > > > > > sensor=>ccdc=>ccdc_output (all with 640x480
> > > > > > V4L2_MBUS_FMT_UYVY8_2X8) and VIDIOC_STREAMON works on /dev/video2.
> > > > > > But if I configure media links
> > > > > > sensor=>ccdc=>resizer=>resizer_output, then VIDIOC_STREAMON fails
> > > > > > on /dev/video6 (with pixelformat mismatch). I noticed that the
> > > > > > resizer driver only supports
> > > > > > V4L2_MBUS_FMT_UYVY8_1X16 & V4L2_MBUS_FMT_YUYV8_1X16, so I tried
> > > > > > again with all the links set to V4L2_MBUS_FMT_UYVY8_1X16 instead,
> > > > > > but then ioctl VIDIOC_SUBDEV_S_FMT fails on /dev/v4l-subdev8,
> > > > > > because the sensor driver doesn't support 1X16.
> > > > > > Then I tried using V4L2_MBUS_FMT_UYVY8_2X8 for the sensor and
> > > > > > V4L2_MBUS_FMT_UYVY8_1X16 for the resizer, but it either failed with
> > > > > > pixelformat mismatch or link pipeline mismatch, depending on which
> > > > > > pads were different.
> > > > > > 
> > > > > > Can someone please tell me what I need to do to make this work?
> > > > > 
> > > > > Long story short, I don't think that pipeline has ever been tested.
> > > > > I'm unfortunately lacking hardware to work on that, as none of my
> > > > > OMAP3 hardware has a YUV input.
> > > > 
> > > > If i am not mistaken currently resizer sub device supports only:
> > > > 
> > > > /* resizer pixel formats */
> > > > static const unsigned int resizer_formats[] = {
> > > > 
> > > > 	V4L2_MBUS_FMT_UYVY8_1X16,
> > > > 	V4L2_MBUS_FMT_YUYV8_1X16,
> > > > 
> > > > };
> > > > 
> > > > Adding something like this [1] in ispresizer.c  should add
> > > > support 2X8 formats. Completely untested :-).
> > > > 
> > > > Regards,
> > > > iivanov
> > > > 
> > > > 
> > > > [1]
> > > > 
> > > > @@ -1307,6 +1311,10 @@ static int resizer_s_crop(struct v4l2_subdev
> > > > *sd, struct v4l2_subdev_fh *fh, static const unsigned int
> > > > resizer_formats[] = {
> > > > 
> > > >  	V4L2_MBUS_FMT_UYVY8_1X16,
> > > >  	V4L2_MBUS_FMT_YUYV8_1X16,
> > > > 
> > > > +	V4L2_MBUS_FMT_UYVY8_2X8,
> > > > +	V4L2_MBUS_FMT_VYUY8_2X8,
> > > > +	V4L2_MBUS_FMT_YUYV8_2X8,
> > > > +	V4L2_MBUS_FMT_YVYU8_2X8,
> > > > 
> > > >  };
> > > 
> > > I'd rather modify ispccdc.c to output V4L2_MBUS_FMT_YUYV8_1X16. What do
> > > you think ?
> > 
> > For memory->Resizer->memory use cases, CCDC is no involved in pipeline.
> 
> But the original poster wants to use the sensor -> ccdc -> resizer -> resizer 
> output pipeline.
> 
> > Also several sensor drivers that i have checked, usually define its
> > output as 2X8 output. I think is more natural to add 2X8 support to
> > CCDC and Resizer engines instead to modifying exiting drivers.
> 
> Sure, sensor drivers should not be modified. What I was talking about was to 
> configure the pipeline as
> 
> sensor:0 [YUYV8_2X8], CCDC:0 [YUYV8_2X8], CCDC:1 [YUYV8_1X16], resizer:0 
> [YUYV8_1X16]

Looks good to me. This also does reflect the real bus formats in the device
quite well; the links from ccdc onwards only use one clock cycle for sample.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
