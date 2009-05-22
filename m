Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:28173 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbZEVNUX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 09:20:23 -0400
Date: Fri, 22 May 2009 16:14:52 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Darius Augulis <augulis.darius@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 08/10 v2] v4l2-subdev: add a v4l2_i2c_subdev_board()
	function
Message-ID: <20090522131452.GA16657@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <Pine.LNX.4.64.0905151817070.4658@axis700.grange> <200905221355.52713.hverkuil@xs4all.nl> <Pine.LNX.4.64.0905221408010.4418@axis700.grange> <200905221458.50332.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905221458.50332.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Fri, May 22, 2009 at 02:58:49PM +0200, ext Hans Verkuil wrote:
> On Friday 22 May 2009 14:16:13 Guennadi Liakhovetski wrote:
> > On Fri, 22 May 2009, Hans Verkuil wrote:
> > > A quick note for Guennadi: the i2c_board_info and the new i2c API has
> > > been available since 2.6.22, but for the subdev support in v4l2 I've
> > > decided not to use the new i2c API for kernels < 2.6.26 due to a
> > > serious i2c core kernel bug that wasn't fixed until 2.6.26 (probing for
> > > the existence of an i2c device at certain addresses can cause an oops).
> > > Strictly speaking it would be possible to support board_info from
> > > 2.6.22 onwards, but going that way makes it very messy with lots of
> > > #ifdefs. I want to keep the simple rule to only support the new i2c API
> > > for 2.6.26 onwards.
> >
> > Hm, I am afraid, I do not understand.
> >
> > My patch doesn't change any behaviour. It just adds one more way of
> > calling the same function, which is already there, just with different
> > parameters. All existing (or new) drivers can call v4l2_i2c_new_subdev()
> > just like before - nothing changes for them. Only internally this
> > function now will use its "struct i2c_board_info info" which it _already_
> > has, to call a new function - v4l2_i2c_subdev_board(). No change
> > whatsoever! Drivers, that know _will_ work this way, e.g., if they don't
> > care about _any_ other kernel versions, except for the one they are
> > compiled for, can call that function - v4l2_i2c_subdev_board() directly.
> > Are you concerned, that some drivers, that do want to work with older
> > kernels, will switch to using this function and then fail for older
> > kernels? Well, we can put the
> >
> > EXPORT_SYMBOL_GPL(v4l2_i2c_subdev_board);
> >
> > line under an ifdef if you want, but even that I don't think is
> > necessary, we just have to catch those careless drivers. Or am I missing
> > something?
> 
> There are two 'missing somethings': the first is that you can have a v4l2 
> driver that uses v4l2_i2c_subdev_board, but the i2c driver that is loaded 
> by that call can also by used by other drivers need to be backwards 
> compatible with older kernels.
> 
> So the i2c driver cannot in general obtain the irq and platform_data from 
> i2c_client during probe, since it won't be set during probe (actually, the 
> irq field in i2c_client doesn't even exist on pre-2.6.22 kernels).
> 
> But if v4l2_i2c_subdev_board calls s_config explicitly, then this data can 
> be passed to the i2c driver in a manner that works for all kernels.
> 
> The second 'something' is that I need something like s_config anyway for 
> those drivers that cannot use this new v4l2_i2c_subdev_board because they 
> have to compile for all kernels. Those drivers can call the existing 
> functions, and then call s_config explicitly.
> 
> For the embedded platforms it really doesn't matter: there you just use 
> i2c_board_info, and the only time s_config comes into play is when the i2c 
> driver can also be used by bridge drivers that cannot use 
> v4l2_i2c_subdev_board.

I think this is heading to other direction that I first understood. I don't
see why one i2c driver which implements the new i2c api would not setup
its irq and platform data other then during probe time. But let's assume that.

In that case, i2c drivers, even though they implement the new i2c api, should
not receive the board specific info during probe, but should wait until s_config time.

That would work for all kernels, but then i2c drivers would not have opportunity to
communicate with device during probe time and do silly checks there.

Why can not v4l2_i2c_subdev_board be able to pass i2c_board_info using normal
i2c api if we are >= 2.6.26, and let s_config to bridge driver? Or even,
call s_config only for < 2.6.26 kernels ?

In both cases, I still see that i2c drivers should be able to be configured
both using normal i2c probes (with board data) or by using s_config.

Besides that, I think s_config can be passing a void *, something like:
+	int (*s_config)(struct v4l2_subdev *sd, void *config_data);

As in my last rfc patch. This way you don't need to care which board data
need to be passed. We can even pass a i2c board info there. That should just
be agreed between bridge and sub dev drivers.

> 
> Regards,
> 
> 	Hans
> 
> -- 
> Hans Verkuil - video4linux developer - sponsored by TANDBERG

-- 
Eduardo Valentin
