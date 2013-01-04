Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:54339 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab3ADNVx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 08:21:53 -0500
Date: Fri, 4 Jan 2013 14:21:49 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
cc: linux-media <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: DT bindings for subdevices
In-Reply-To: <CA+V-a8sai0qEsBJNtn0nPKQrP3HvMZzX_yawSAGKBqxxHOMoUQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1301041417480.28515@axis700.grange>
References: <CA+V-a8uK38_HrYa2ic5soLE=Ge0aK3=PObNCs_xMf=PAzcwBcg@mail.gmail.com>
 <Pine.LNX.4.64.1301021100130.7829@axis700.grange>
 <CA+V-a8sai0qEsBJNtn0nPKQrP3HvMZzX_yawSAGKBqxxHOMoUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 4 Jan 2013, Prabhakar Lad wrote:

> Hi Guennadi,
> 
> On Wed, Jan 2, 2013 at 3:49 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > Hi Prabhakar
> >
> > On Wed, 2 Jan 2013, Prabhakar Lad wrote:
> >
> >> Hi,
> >>
> >> This is my first step towards DT support for media, Question might be
> >> bit amateur :)
> >
> > No worries, we're all doing our first steps in this direction right at the
> > moment. These two recent threads should give you an idea as to where we
> > stand atm:
> >
> > http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/58646
> >
> > and (optionally, to a lesser extent)
> >
> > http://www.spinics.net/lists/linux-media/index.html#57836
> >
> >> In the video pipeline there will be external devices (decoders/camera)
> >> connected via
> >> i2c, spi, csi. This sub-devices take platform data. So question is
> >> moving ahead and
> >> adding DT support for this subdevices how should this platform data be
> >> passed through.
> >> Should it be different properties for different devices.
> >
> > Mostly, yes.
> >
> >> For example the mt9t001 sensor takes following platform data:
> >> struct mt9t001_platform_data {
> >>       unsigned int clk_pol:1;
> >
> > This would presumably be the standard "pclk-sample" property from the
> > first of the above two quoted threads
> >
> >>       unsigned int ext_clk;
> >
> > Is this the frequency? This should be replaced by a phandle, linking to a
> > clock device-tree node, assuming, your platform is implementing the
> > generic clock API. If it isn't yet, not a problem either:-) In either case
> > your sensor driver shall be using the v4l2_clk API to retrieve the clock
> > rate and your camera host driver should be providing a matching v4l2_clk
> > instance and implementing its methods, including retrieving the frequency.
> >
> Few more doubts:
> 1: The vl42-async/deferred probing would be required for all the devices
>     implementing FDT if I am not wrong ?

There is, of course, more than one way to do it, but that's how we want to 
have it, yes. We want your I2C camera sensors be specified in the DT in a 
standard way - as children of the respective I2C adapter DT node, which 
means they can be probed at any time. And we do want their probing 
functions to have the ability to really access the hardware, if all the 
conditions are satisfied, e.g. if all resources are available. Which is 
exactly why we need asynchronous probing.

Thanks
Guennadi

> Regards,
> --Prabhakar
> 
> >> };
> >> similarly mt9p031 takes following platform data:
> >>
> >> struct mt9p031_platform_data {
> >>       int (*set_xclk)(struct v4l2_subdev *subdev, int hz);
> >
> > Not sure what the xclk is, but, presumable, this should be ported to
> > v4l2_clk too.
> >
> >>       int reset;
> >
> > This is a GPIO number, used to reset the chip. You should use a property,
> > probably, calling it "reset-gpios", specifying the desired GPIO.
> >
> >>       int ext_freq;
> >>       int target_freq;
> >
> > Presumably, ext_freq should be retrieved, using v4l2_clk_get_rate() and
> > target_freq could be a proprietary property of your device.
> >
> > Thanks
> > Guennadi
> >
> >> };
> >>
> >> should this all be individual properties ?
> >>
> >> Regards,
> >> --Prabhakar
> >
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
