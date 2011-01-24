Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39975 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab1AXLWZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 06:22:25 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: martin@neutronstar.dyndns.org
Subject: Re: [PATCH] v4l: Add driver for Micron MT9M032 camera sensor
Date: Mon, 24 Jan 2011 12:22:30 +0100
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1295389122-30325-1-git-send-email-martin@neutronstar.dyndns.org> <201101190005.10652.hverkuil@xs4all.nl> <20110119191214.GB13173@neutronstar.dyndns.org>
In-Reply-To: <20110119191214.GB13173@neutronstar.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101241222.30468.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Martin,

On Wednesday 19 January 2011 20:12:14 martin@neutronstar.dyndns.org wrote:
> On Wed, Jan 19, 2011 at 12:05:10AM +0100, Hans Verkuil wrote:
> > On Tuesday, January 18, 2011 23:18:42 Martin Hostettler wrote:

[snip]

> > > +#ifdef CONFIG_VIDEO_ADV_DEBUG
> > > +static long mt9m032_ioctl(struct v4l2_subdev *sd, unsigned int cmd,
> > > void *arg) +{
> > > +	if (cmd == VIDIOC_DBG_G_REGISTER || cmd == VIDIOC_DBG_S_REGISTER) {
> > > +		struct v4l2_dbg_register *p = arg;
> > > +
> > > +		if (!capable(CAP_SYS_ADMIN))
> > > +			return -EPERM;
> > > +
> > > +		if (cmd == VIDIOC_DBG_G_REGISTER)
> > > +			return v4l2_subdev_call(sd, core, g_register, p);
> > > +		else
> > > +			return v4l2_subdev_call(sd, core, s_register, p);
> > > +	} else {
> > > +		return -ENOIOCTLCMD;
> > > +	}
> > > +}
> > 
> > Huh? Ah, I get it. This is for when the user uses the subdev's device
> > node directly. This is not good, the v4l2 framework should do translate
> > this to g/s_register. The same should be done for g_chip_ident, I guess.
> 
> I'm not sure what you are saying here. Should i move this to a patch for
> v4l2-subdev.c to dispatch those ioctls for all subdevs?

Yes, please do that.

> I need these ioctls to work with the driver and last that i looked nothing
> in the general framework or the omap3 ISP driver was forwarding there from
> the video device node to the subdevice driver...

-- 
Regards,

Laurent Pinchart
