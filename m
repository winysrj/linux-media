Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:49807 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab2CKJEm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Mar 2012 05:04:42 -0400
Date: Sun, 11 Mar 2012 11:04:34 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: jean-philippe francois <jp.francois@cynove.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: Re: [PATCH v5.1 35/35] smiapp: Add driver
Message-ID: <20120311090434.GH1591@valkosipuli.localdomain>
References: <1960253.l1xo097dr7@avalon>
 <1331215050-20823-2-git-send-email-sakari.ailus@iki.fi>
 <CAGGh5h37Rd9O1Hp6FHBo1KcQRdEb=2OJxGkA0aJmyWkEB9juGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGGh5h37Rd9O1Hp6FHBo1KcQRdEb=2OJxGkA0aJmyWkEB9juGQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi François,

On Thu, Mar 08, 2012 at 04:06:34PM +0100, jean-philippe francois wrote:
> Le 8 mars 2012 14:57, Sakari Ailus <sakari.ailus@iki.fi> a écrit :
> > Add driver for SMIA++/SMIA image sensors. The driver exposes the sensor as
> > three subdevs, pixel array, binner and scaler --- in case the device has a
> > scaler.
> >
> > Currently it relies on the board code for external clock handling. There is
> > no fast way out of this dependency before the ISP drivers (omap3isp) among
> > others will be able to export that clock through the clock framework
> > instead.
> >
> > +       case V4L2_CID_EXPOSURE:
> > +               return smiapp_write(
> > +                       client,
> > +                       SMIAPP_REG_U16_COARSE_INTEGRATION_TIME, ctrl->val);
> > +
> At this point, knowing pixel clock and line length, it is possible
> to get / set the exposure in useconds or millisecond value.

It is possible, but still I don't think we even want that at this level.
This is a fairly low level interface.

The exposure time in seconds can always be constructed from horizontal and
vertical blanking and the pixel rate in the user space.

How you choose the exposure value in seconds does contain policy decisions
which belong to the user space. Sensor drivers don't even have enough
information to make these decisions. Providing the exposure time in native
unit for sensors allows making these decisions in the user space.

For example:

- To get a common frame rate such as 30 or 25 fps, you need to add blanking,
either horizontal or vertical. Using horizontal blanking gives you more
unwanted rolling shutter effect but amortises the data rate over time. Which
one you want (horizontal or vertical) is dependent on your hardware and what
else is involved in your use case

- Hardware limitations. Most blocks in the OMAP 3 ISP have the maximum speed
of is 100 Mp/s but for the CSI-2 receiver it's 200 Mp/s. So if the ISP is
configured to write the images to memory in the CSI-2 receiver, the maximum
pixel rate is 200 Mp/s, not 100. This kind of limitations are quite common
in ISPs and not limited to OMAP 3 ISP. Should the sensor driver know which
blocks are part of the pipeline, and limit minimum frame time based on that?
I admit not everything is in place yet for the full solution of this
problem, but making the pixel rate configurable available to the user space
is definitely a part of it. Ideally the user should be provided a way to
enumerate these limitations to be able to make informed decisions.

It shouldn't be the responsibility of the regular applications to deal with
these things, though. We need additional functionality in libv4l2 to provide
a higher level interface to the exposure time --- just like for the pipeline
configuration. On the other hand, an application tailored to a device must
be able to make these decisions by itself.

> From userspace, if for example you change the format and crop,
> you can just set the expo to a value in msec or usec, and get the
> same exposure after your format change.
> 
> The driver is IMO the place where we have all the info. Here is some
> example code with usec. (The 522 constant is the fine integration register...)
> 
> static int  mt9j_expo_to_shutter(struct usb_ovfx2 * ov, u32 expo)
> {
> 	int rc = 0;
> 	u32 expo_pix; // exposition in pixclk unit
> 	u16 coarse_expo;
> 	u16 row_time;
> 	expo_pix = expo * 96;   /// pixel clock in MHz
> 	MT9J_RREAD(ov, LINE_LENGTH_PCK, &row_time);
> 	expo_pix = expo_pix - 522;
> 	coarse_expo = (expo_pix + row_time/2)/ row_time;
> 	MT9J_RWRITE(ov, COARSE_EXPO_REG, coarse_expo);
> 	return rc;
> }
> 
> static int  mt9j_shutter_to_expo(struct usb_ovfx2 * ov, u32  * expo)
> {
> 	int rc = 0;
> 	u32 expo_pix; // exposition in pixclk unit
> 	u16 coarse_expo;
> 	u16 row_time;
> 	MT9J_RREAD(ov, LINE_LENGTH_PCK, &row_time);
> 	MT9J_RREAD(ov, COARSE_EXPO_REG, &coarse_expo);
> 	expo_pix = row_time * coarse_expo + 522;
> 	*expo = expo_pix / (96);
> 	return rc;
> }
> 
> Maybe you have enough on your plate for now, and this can
> wait after inclusion, but it is a nice abstraction to have  from
> userspace point of view.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
