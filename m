Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58965 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756725AbZDUJlb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2009 05:41:31 -0400
Date: Tue, 21 Apr 2009 11:41:35 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l2-subdev: add a v4l2_i2c_new_dev_subdev() function
In-Reply-To: <19335.62.70.2.252.1240306140.squirrel@webmail.xs4all.nl>
Message-ID: <Pine.LNX.4.64.0904211135200.6551@axis700.grange>
References: <19335.62.70.2.252.1240306140.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 21 Apr 2009, Hans Verkuil wrote:

> 
> > On Tue, 21 Apr 2009, Hans Verkuil wrote:
> >
> >>
> >> > Video (sub)devices, connecting to SoCs over generic i2c busses cannot
> >> > provide a pointer to struct v4l2_device in i2c-adapter driver_data,
> >> and
> >> > provide their own i2c_board_info data, including a platform_data
> >> field.
> >> > Add a v4l2_i2c_new_dev_subdev() API function that does exactly the
> >> same as
> >> > v4l2_i2c_new_subdev() but uses different parameters, and make
> >> > v4l2_i2c_new_subdev() a wrapper around it.
> >>
> >> Huh? Against what repository are you compiling? The v4l2_device pointer
> >> has already been added!
> >
> > Ok, have to rebase then. I guess, it still would be better to do the way I
> > propose in this patch - to add a new function, with i2c_board_info as a
> > parameter and convert v4l2_i2c_new_subdev() to a wrapper around it, than
> > to convert all existing users, agree? Do you also agree with the name?
> 
> I like the idea of passing in a board_info struct instead of an
> addr/client_type.

And converting v4l2_i2c_new_subdev() to a wrapper is ok too?

> Just make sure when preparing a patch for the v4l-dvb
> repo that this new function is for kernels >= 2.6.26 only.

Why and how? I am not adding any new structs or fields with this patch, am 
I? So it should build with all kernels, with which the current 
v4l2_i2c_new_subdev() builds.

> I prefer a name like v4l2_i2c_subdev_board(). I will probably at some
> stage remove that '_new' part of the existing functions anyway as that
> doesn't add anything to the name.

Ok, will do.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
