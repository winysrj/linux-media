Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:27915 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbZEYKXD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2009 06:23:03 -0400
Date: Mon, 25 May 2009 13:18:28 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
Cc: ext Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Darius Augulis <augulis.darius@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 08/10 v2] v4l2-subdev: add a v4l2_i2c_subdev_board()
	function
Message-ID: <20090525101828.GA31070@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <Pine.LNX.4.64.0905151817070.4658@axis700.grange> <200905221355.52713.hverkuil@xs4all.nl> <Pine.LNX.4.64.0905221408010.4418@axis700.grange> <200905221458.50332.hverkuil@xs4all.nl> <20090522131452.GA16657@esdhcp037198.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090522131452.GA16657@esdhcp037198.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Fri, May 22, 2009 at 03:14:52PM +0200, Valentin Eduardo (Nokia-D/Helsinki) wrote:
> Hi,
> 
> > >
> > 
> > There are two 'missing somethings': the first is that you can have a v4l2 
> > driver that uses v4l2_i2c_subdev_board, but the i2c driver that is loaded 
> > by that call can also by used by other drivers need to be backwards 
> > compatible with older kernels.
> > 
> > So the i2c driver cannot in general obtain the irq and platform_data from 
> > i2c_client during probe, since it won't be set during probe (actually, the 
> > irq field in i2c_client doesn't even exist on pre-2.6.22 kernels).
> > 
> > But if v4l2_i2c_subdev_board calls s_config explicitly, then this data can 
> > be passed to the i2c driver in a manner that works for all kernels.
> > 
> > The second 'something' is that I need something like s_config anyway for 
> > those drivers that cannot use this new v4l2_i2c_subdev_board because they 
> > have to compile for all kernels. Those drivers can call the existing 
> > functions, and then call s_config explicitly.
> > 
> > For the embedded platforms it really doesn't matter: there you just use 
> > i2c_board_info, and the only time s_config comes into play is when the i2c 
> > driver can also be used by bridge drivers that cannot use 
> > v4l2_i2c_subdev_board.
> 
> I think this is heading to other direction that I first understood. I don't
> see why one i2c driver which implements the new i2c api would not setup
> its irq and platform data other then during probe time. But let's assume that.
> 
> In that case, i2c drivers, even though they implement the new i2c api, should
> not receive the board specific info during probe, but should wait until s_config time.
> 
> That would work for all kernels, but then i2c drivers would not have opportunity to
> communicate with device during probe time and do silly checks there.
> 
> Why can not v4l2_i2c_subdev_board be able to pass i2c_board_info using normal
> i2c api if we are >= 2.6.26, and let s_config to bridge driver? Or even,
> call s_config only for < 2.6.26 kernels ?
> 
> In both cases, I still see that i2c drivers should be able to be configured
> both using normal i2c probes (with board data) or by using s_config.
> 
> Besides that, I think s_config can be passing a void *, something like:
> +	int (*s_config)(struct v4l2_subdev *sd, void *config_data);
> 
> As in my last rfc patch. This way you don't need to care which board data
> need to be passed. We can even pass a i2c board info there. That should just
> be agreed between bridge and sub dev drivers.

I think I understood your point. Maybe what you are trying to keep is the same
v4l2 api so that can be used in all kernel versions. Based on that we cannot
pass i2c_board_info as v4l2 api function (at least for now).

So, I think I'm sending a patch with this in mind. Which is:
* Addition of s_config(irq, platform_data) into core callbacks set:
+       int (*s_config)(struct v4l2_subdev *sd, int irq, void *platform_data);

* Addition of v4l2_i2c_new_subdev_board, which is basically the same
of v4l2_i2c_new_subdev, but with two additional parameters: irq and platform_data.
This function will pass these data to i2c normal probe procedure (if we are >= 2.6.26),
and will call s_config with these two additional parameters.

So, both older i2c version compatible and newer i2c version only drivers can
call it. Is that what you were thinking?

I'm sending that patch as well in other email.


> 
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > -- 
> > Hans Verkuil - video4linux developer - sponsored by TANDBERG
> 
> -- 
> Eduardo Valentin

-- 
Eduardo Valentin
