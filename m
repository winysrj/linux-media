Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3036 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbZEVM66 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 08:58:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 08/10 v2] v4l2-subdev: add a v4l2_i2c_subdev_board() function
Date: Fri, 22 May 2009 14:58:49 +0200
Cc: eduardo.valentin@nokia.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Darius Augulis <augulis.darius@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>
References: <Pine.LNX.4.64.0905151817070.4658@axis700.grange> <200905221355.52713.hverkuil@xs4all.nl> <Pine.LNX.4.64.0905221408010.4418@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0905221408010.4418@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905221458.50332.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 22 May 2009 14:16:13 Guennadi Liakhovetski wrote:
> On Fri, 22 May 2009, Hans Verkuil wrote:
> > A quick note for Guennadi: the i2c_board_info and the new i2c API has
> > been available since 2.6.22, but for the subdev support in v4l2 I've
> > decided not to use the new i2c API for kernels < 2.6.26 due to a
> > serious i2c core kernel bug that wasn't fixed until 2.6.26 (probing for
> > the existence of an i2c device at certain addresses can cause an oops).
> > Strictly speaking it would be possible to support board_info from
> > 2.6.22 onwards, but going that way makes it very messy with lots of
> > #ifdefs. I want to keep the simple rule to only support the new i2c API
> > for 2.6.26 onwards.
>
> Hm, I am afraid, I do not understand.
>
> My patch doesn't change any behaviour. It just adds one more way of
> calling the same function, which is already there, just with different
> parameters. All existing (or new) drivers can call v4l2_i2c_new_subdev()
> just like before - nothing changes for them. Only internally this
> function now will use its "struct i2c_board_info info" which it _already_
> has, to call a new function - v4l2_i2c_subdev_board(). No change
> whatsoever! Drivers, that know _will_ work this way, e.g., if they don't
> care about _any_ other kernel versions, except for the one they are
> compiled for, can call that function - v4l2_i2c_subdev_board() directly.
> Are you concerned, that some drivers, that do want to work with older
> kernels, will switch to using this function and then fail for older
> kernels? Well, we can put the
>
> EXPORT_SYMBOL_GPL(v4l2_i2c_subdev_board);
>
> line under an ifdef if you want, but even that I don't think is
> necessary, we just have to catch those careless drivers. Or am I missing
> something?

There are two 'missing somethings': the first is that you can have a v4l2 
driver that uses v4l2_i2c_subdev_board, but the i2c driver that is loaded 
by that call can also by used by other drivers need to be backwards 
compatible with older kernels.

So the i2c driver cannot in general obtain the irq and platform_data from 
i2c_client during probe, since it won't be set during probe (actually, the 
irq field in i2c_client doesn't even exist on pre-2.6.22 kernels).

But if v4l2_i2c_subdev_board calls s_config explicitly, then this data can 
be passed to the i2c driver in a manner that works for all kernels.

The second 'something' is that I need something like s_config anyway for 
those drivers that cannot use this new v4l2_i2c_subdev_board because they 
have to compile for all kernels. Those drivers can call the existing 
functions, and then call s_config explicitly.

For the embedded platforms it really doesn't matter: there you just use 
i2c_board_info, and the only time s_config comes into play is when the i2c 
driver can also be used by bridge drivers that cannot use 
v4l2_i2c_subdev_board.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
