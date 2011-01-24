Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33790 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab1AXLUj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 06:20:39 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] v4l: Add driver for Micron MT9M032 camera sensor
Date: Mon, 24 Jan 2011 12:20:41 +0100
Cc: Martin Hostettler <martin@neutronstar.dyndns.org>,
	linux-media@vger.kernel.org
References: <1295389122-30325-1-git-send-email-martin@neutronstar.dyndns.org> <201101190050.35863.laurent.pinchart@ideasonboard.com> <201101190823.18900.hverkuil@xs4all.nl>
In-Reply-To: <201101190823.18900.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101241220.41598.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Wednesday 19 January 2011 08:23:18 Hans Verkuil wrote:
> On Wednesday, January 19, 2011 00:50:35 Laurent Pinchart wrote:
> > On Wednesday 19 January 2011 00:05:10 Hans Verkuil wrote:
> > > On Tuesday, January 18, 2011 23:18:42 Martin Hostettler wrote:

[snip]

> > > > +#ifdef CONFIG_VIDEO_ADV_DEBUG
> > > > +static long mt9m032_ioctl(struct v4l2_subdev *sd, unsigned int cmd,
> > > > void *arg) +{
> > > > +	if (cmd == VIDIOC_DBG_G_REGISTER || cmd == VIDIOC_DBG_S_REGISTER) {
> > > > +		struct v4l2_dbg_register *p = arg;
> > > > +
> > > > +		if (!capable(CAP_SYS_ADMIN))
> > > > +			return -EPERM;
> > > > +
> > > > +		if (cmd == VIDIOC_DBG_G_REGISTER)
> > > > +			return v4l2_subdev_call(sd, core, g_register, p);
> > > > +		else
> > > > +			return v4l2_subdev_call(sd, core, s_register, p);
> > > > +	} else {
> > > > +		return -ENOIOCTLCMD;
> > > > +	}
> > > > +}
> > > 
> > > Huh? Ah, I get it. This is for when the user uses the subdev's device
> > > node directly. This is not good, the v4l2 framework should do
> > > translate this to g/s_register.
> > 
> > Agreed.
> > 
> > > The same should be done for g_chip_ident, I guess.
> > 
> > I don't think we need g_chip_ident for subdev nodes, do we ?
> 
> Why not? It makes the use of v4l2-dbg a bit easier if it is there. If you
> provide g/s_register, then you should provide this one as well.

Because v4l2_dbg_register::match is used to address a specific subdevice. When 
issuing the VIDIOC_DBG_[GS]_REGISTER ioctls on a subdev device node, the field 
isn't needed anymore.

> I though of another one that should be handled in the framework:
> VIDIOC_LOG_STATUS.
> 
> That definitely should be handled as well.

-- 
Regards,

Laurent Pinchart
