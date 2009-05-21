Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43456 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753196AbZEUPdi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2009 11:33:38 -0400
Date: Thu, 21 May 2009 17:33:48 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Darius Augulis <augulis.darius@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 08/10 v2] v4l2-subdev: add a v4l2_i2c_subdev_board()
 function
In-Reply-To: <200905211553.13802.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0905211728420.6271@axis700.grange>
References: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
 <Pine.LNX.4.64.0905151905440.4658@axis700.grange> <200905211553.13802.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, 21 May 2009, Hans Verkuil wrote:

> On Friday 15 May 2009 19:20:10 Guennadi Liakhovetski wrote:
> > Introduce a function similar to v4l2_i2c_new_subdev() but taking a
> > pointer to a struct i2c_board_info as a parameter instead of a client
> > type and an I2C address, and make v4l2_i2c_new_subdev() a wrapper around
> > it.
> >
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> >
> > Hans, renamed as you requested and updated to a (more) current state.
> 
> NAK. Not because it is a bad idea, but because you need to patch against the 
> version in the v4l-dvb repo. The version in the kernel is missing a lot of 
> the compatibility code which we unfortunately need to keep.
> 
> Any function passing the board_info will be valid for kernels >= 2.6.26 
> only.

Here's a quote from your earlier email.

On Tue, 21 Apr 2009, Hans Verkuil wrote:

> The board_info struct didn't appear until 2.6.22, so that's certainly a
> cut-off point. Since the probe version of this call does not work on
> kernels < 2.6.26 the autoprobing mechanism is still used for those older
> kernels. I think it makes life much easier to require that everything that
> uses board_info needs kernel 2.6.26 at the minimum. I don't think that is
> an issue anyway for soc-camera. Unless there is a need to use soc-camera
> from v4l-dvb with kernels <2.6.26?

So, will this my patch build and work with >= 2.6.22 or not? I really 
would not like to consciously make code uglier now because of 
compatibility with < 2.6.26 to make it better some time later again.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
