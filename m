Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:59349 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966945AbeEXUrl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 16:47:41 -0400
Date: Thu, 24 May 2018 23:47:34 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: bingbu.cao@intel.com, linux-media@vger.kernel.org,
        bingbu.cao@linux.intel.com, tian.shu.qiu@linux.intel.com,
        rajmohan.mani@intel.com, mchehab@kernel.org
Subject: Re: [PATCH v3] media: imx319: Add imx319 camera sensor driver
Message-ID: <20180524204733.s2ijd3t2izztvjnv@kekkonen.localdomain>
References: <1526886658-14417-1-git-send-email-bingbu.cao@intel.com>
 <1526963581-28655-1-git-send-email-bingbu.cao@intel.com>
 <20180522200848.GB15035@w540>
 <20180523073833.onxqj72hi23qkz42@paasikivi.fi.intel.com>
 <20180524200738.GD18369@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180524200738.GD18369@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Thu, May 24, 2018 at 10:07:38PM +0200, jacopo mondi wrote:
...
> > > about that, but I wonder why setting controls should be enabled only
> > > when streaming. I would have expected runtime_pm_get/put in subdevices
> > > node open/close functions not only when streaming. Am I missing something?
> >
> > You can do it either way. If powering on the sensor takes a long time, then
> > doing that in the open callback may be helpful as the user space has a way
> > to keep the device powered.
> 
> Ok, so I assume my comment could be ignored, assuming is fine not
> being able to set control if the sensor is not streaming. Is it?

I'd say so. From the user's point of view, the sensor doesn't really do
anything when it's in software standby mode.

...

> > > > +	mode = v4l2_find_nearest_size(supported_modes,
> > > > +		ARRAY_SIZE(supported_modes), width, height,
> > > > +		fmt->format.width, fmt->format.height);
> > > > +	imx319_update_pad_format(imx319, mode, fmt);
> > > > +	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> > > > +		framefmt = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
> > > > +		*framefmt = fmt->format;
> > > > +	} else {
> > > > +		imx319->cur_mode = mode;
> > > > +		pixel_rate =
> > > > +		(link_freq_menu_items[0] * 2 * 4) / 10;
> > >
> > > This assumes a fixed link frequency and a fixed number of data lanes,
> > > and a fixed bpp value (but this is ok, as all the formats you have are
> > > 10bpp). In OF world those parameters come from DT, what about ACPI?
> >
> > I presume the driver only supports a particular number of lanes (4). ACPI
> > supports _DSD properties, i.e. the same can be done on ACPI.
> >
> > If the driver only supports these, then it should check this matches with
> > what the firmware (ACPI) has. The fwnode API is the same.
> 
> Thanks, so I assume those parameters represented in ACPI DSD nodes
> will be checked to be supported by the sensor in v2.

Agreed.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
