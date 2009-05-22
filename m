Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56014 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758043AbZEVMQE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 08:16:04 -0400
Date: Fri, 22 May 2009 14:16:13 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: eduardo.valentin@nokia.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Darius Augulis <augulis.darius@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 08/10 v2] v4l2-subdev: add a v4l2_i2c_subdev_board()
 function
In-Reply-To: <200905221355.52713.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0905221408010.4418@axis700.grange>
References: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
 <Pine.LNX.4.64.0905211728420.6271@axis700.grange>
 <20090522085827.GA1964@esdhcp037198.research.nokia.com>
 <200905221355.52713.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 22 May 2009, Hans Verkuil wrote:

> A quick note for Guennadi: the i2c_board_info and the new i2c API has been 
> available since 2.6.22, but for the subdev support in v4l2 I've decided not 
> to use the new i2c API for kernels < 2.6.26 due to a serious i2c core 
> kernel bug that wasn't fixed until 2.6.26 (probing for the existence of an 
> i2c device at certain addresses can cause an oops). Strictly speaking it 
> would be possible to support board_info from 2.6.22 onwards, but going that 
> way makes it very messy with lots of #ifdefs. I want to keep the simple 
> rule to only support the new i2c API for 2.6.26 onwards.

Hm, I am afraid, I do not understand.

My patch doesn't change any behaviour. It just adds one more way of 
calling the same function, which is already there, just with different 
parameters. All existing (or new) drivers can call v4l2_i2c_new_subdev() 
just like before - nothing changes for them. Only internally this function 
now will use its "struct i2c_board_info info" which it _already_ has, to 
call a new function - v4l2_i2c_subdev_board(). No change whatsoever! 
Drivers, that know _will_ work this way, e.g., if they don't care about 
_any_ other kernel versions, except for the one they are compiled for, can 
call that function - v4l2_i2c_subdev_board() directly. Are you concerned, 
that some drivers, that do want to work with older kernels, will switch to 
using this function and then fail for older kernels? Well, we can put the

EXPORT_SYMBOL_GPL(v4l2_i2c_subdev_board);

line under an ifdef if you want, but even that I don't think is necessary, 
we just have to catch those careless drivers. Or am I missing something?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
