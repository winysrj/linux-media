Return-path: <linux-media-owner@vger.kernel.org>
Received: from web32103.mail.mud.yahoo.com ([68.142.207.117]:30311 "HELO
	web32103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752011AbZDUMqJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2009 08:46:09 -0400
Message-ID: <86952.30815.qm@web32103.mail.mud.yahoo.com>
Date: Tue, 21 Apr 2009 05:46:06 -0700 (PDT)
From: Agustin <gatoguan-os@yahoo.com>
Reply-To: gatoguan-os@yahoo.com
Subject: Re: [PATCH] v4l2-subdev: add a v4l2_i2c_new_dev_subdev() function
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-i2c@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 21/4/09, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> On Tue, 21 Apr 2009, Agustin wrote:
> > 
> > Hi,
> > 
> > On 21/4/09, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > > Video (sub)devices, connecting to SoCs over generic i2c busses cannot 
> > > provide a pointer to struct v4l2_device in i2c-adapter driver_data, and 
> > > provide their own i2c_board_info data, including a platform_data field. 
> > > Add a v4l2_i2c_new_dev_subdev() API function that does exactly the same
> > > as v4l2_i2c_new_subdev() but uses different parameters, and make 
> > > v4l2_i2c_new_subdev() a wrapper around it.
> > 
> > [snip]
> > 
> > I am wondering about this ongoing effort and its pursued goal: is it
> > to hierarchize the v4l architecture, adding new abstraction levels?
> > If so, what for?

> Driver-reuse. soc-camera framework will be able to use all available and 
> new v4l2-subdev drivers, and vice versa.

Well, "Driver reuse." sounds more as a mantra than a reason for me. Then I can't find any "available" v4l2-subdev driver in 2.6.29.

I assume this subdev stuff plays a mayor role in current V4L2 architecture refactorization. Then we probably should take this opportunity to relieve V4L APIs from all its explicit I2C mangling, because...

> > To me, as an eventual driver developer, this makes it harder to 
> > integrate my own drivers, as I use I2C and V4L in my system but I
> > don't want them to be tightly coupled.

> This conversion shouldn't make the coupling any tighter.

But still I think V4L system should not be aware of I2C at all.

To me, V4L is a kernel subsystem in charge of moving multimedia data from/to userspace/hardware, and the APIs should reflect just that.

If one V4L driver uses I2C for device control, what does V4L have to say about that, really? Or why V4L would never care about usb or SPI links?

I2C and V4L should stay cleanly and clearly apart.

> > Of course I can ignore this "subdev" stuff and just link against 
> > soc-camera which is what I need, and manage I2C without V4L knowing 
> > about it. Which is what I do.

> You won't be able to. The only link to woc-camera will be the
> v4l2-subdev link. Already now with this patch many essential
> soc-camera API operations are gone.

I guess you mean that I will have to use v4l2-subdev interface to connect to soc-camera, and not to surrender my I2C management to an I2C-extraneous subsystem. Is that right?

(Sorry for arriving this late to the discussion just to critizise your good efforts.)

Regards,
--Agustín.
