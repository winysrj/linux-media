Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45346 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab1ARXug (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jan 2011 18:50:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] v4l: Add driver for Micron MT9M032 camera sensor
Date: Wed, 19 Jan 2011 00:50:35 +0100
Cc: Martin Hostettler <martin@neutronstar.dyndns.org>,
	linux-media@vger.kernel.org
References: <1295389122-30325-1-git-send-email-martin@neutronstar.dyndns.org> <201101190005.10652.hverkuil@xs4all.nl>
In-Reply-To: <201101190005.10652.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101190050.35863.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans and Martin,

On Wednesday 19 January 2011 00:05:10 Hans Verkuil wrote:
> On Tuesday, January 18, 2011 23:18:42 Martin Hostettler wrote:

[snip]

> > +	return mt9m032_write_reg(client, MT9M032_VBLANK,
> > additional_blanking_rows);
> 
> I've found it easier to do the v4l2_subdev to i2c_client conversion at the
> lowest level: the read/write register functions. That way the conversion is
> done at only a few places, rather than at every place these read/write reg
> functions are called. Just my opinion, though.

I agree with this.

> > +#ifdef CONFIG_VIDEO_ADV_DEBUG
> > +static long mt9m032_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void
> > *arg) +{
> > +	if (cmd == VIDIOC_DBG_G_REGISTER || cmd == VIDIOC_DBG_S_REGISTER) {
> > +		struct v4l2_dbg_register *p = arg;
> > +
> > +		if (!capable(CAP_SYS_ADMIN))
> > +			return -EPERM;
> > +
> > +		if (cmd == VIDIOC_DBG_G_REGISTER)
> > +			return v4l2_subdev_call(sd, core, g_register, p);
> > +		else
> > +			return v4l2_subdev_call(sd, core, s_register, p);
> > +	} else {
> > +		return -ENOIOCTLCMD;
> > +	}
> > +}
> 
> Huh? Ah, I get it. This is for when the user uses the subdev's device node
> directly. This is not good, the v4l2 framework should do translate this to
> g/s_register.

Agreed.

> The same should be done for g_chip_ident, I guess.

I don't think we need g_chip_ident for subdev nodes, do we ?

> > +#endif

-- 
Regards,

Laurent Pinchart
