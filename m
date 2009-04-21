Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37217 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753245AbZDUJpL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2009 05:45:11 -0400
Date: Tue, 21 Apr 2009 11:45:17 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Agustin <gatoguan-os@yahoo.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l2-subdev: add a v4l2_i2c_new_dev_subdev() function
In-Reply-To: <182771.15423.qm@web32107.mail.mud.yahoo.com>
Message-ID: <Pine.LNX.4.64.0904211142330.6551@axis700.grange>
References: <182771.15423.qm@web32107.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 21 Apr 2009, Agustin wrote:

> 
> Hi,
> 
> --- On 21/4/09, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > Video (sub)devices, connecting to SoCs over generic i2c busses cannot 
> > provide a pointer to struct v4l2_device in i2c-adapter driver_data, and 
> > provide their own i2c_board_info data, including a platform_data field. 
> > Add a v4l2_i2c_new_dev_subdev() API function that does exactly the same
> > as v4l2_i2c_new_subdev() but uses different parameters, and make 
> > v4l2_i2c_new_subdev() a wrapper around it.
> 
> [snip]
> 
> I am wondering about this ongoing effort and its pursued goal: is it to 
> hierarchize the v4l architecture, adding new abstraction levels? If so, 
> what for?

Driver-reuse. soc-camera framework will be able to use all available and 
new v4l2-subdev drivers, and vice versa.

> To me, as an eventual driver developer, this makes it harder to 
> integrate my own drivers, as I use I2C and V4L in my system but I don't 
> want them to be tightly coupled.

This conversion shouldn't make the coupling any tighter.

> Of course I can ignore this "subdev" stuff and just link against 
> soc-camera which is what I need, and manage I2C without V4L knowing 
> about it. Which is what I do.

You won't be able to. The only link to woc-camera will be the v4l2-subdev 
link. Already now with this patch many essential soc-camera API operations 
are gone.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
