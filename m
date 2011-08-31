Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52925 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961Ab1HaR6Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 13:58:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastian Hecht <hechtb@googlemail.com>
Subject: Re: [PATCH] media: Add camera controls for the ov5642 driver
Date: Wed, 31 Aug 2011 19:58:54 +0200
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <alpine.DEB.2.02.1108171553540.17550@ipanema> <201108311739.43057.laurent.pinchart@ideasonboard.com> <CABYn4syYeSA7nG3RCvJVpkwcor8ybkso_aXsmrR=7RB1PDZPjA@mail.gmail.com>
In-Reply-To: <CABYn4syYeSA7nG3RCvJVpkwcor8ybkso_aXsmrR=7RB1PDZPjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311958.54851.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bastian,

On Wednesday 31 August 2011 19:35:41 Bastian Hecht wrote:
> 2011/8/31 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> > On Wednesday 31 August 2011 17:27:49 Bastian Hecht wrote:
> >> 2011/8/28 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> >> > On Wednesday 17 August 2011 18:02:07 Bastian Hecht wrote:

[snip]

> >> >> +#define OV5642_CONTROL_BLUE_SATURATION       (V4L2_CID_PRIVATE_BASE
> >> >> + 0) +#define OV5642_CONTROL_RED_SATURATION      
> >> >>  (V4L2_CID_PRIVATE_BASE + 1) +#define OV5642_CONTROL_GRAY_SCALE  
> >> >>  (V4L2_CID_PRIVATE_BASE + 2) +#define OV5642_CONTROL_SOLARIZE      
> >> >>        (V4L2_CID_PRIVATE_BASE + 3)
> >> > 
> >> > If I'm not mistaken V4L2_CID_PRIVATE_BASE is deprecated.
> >> 
> >> I checked at http://v4l2spec.bytesex.org/spec/x542.htm, googled
> >> "V4L2_CID_PRIVATE_BASE deprecated" and read
> >> Documentation/feature-removal-schedule.txt. I couldn't find anything.
> >> If it is deprecated, do you have an idea how to offer device specific
> >> features to the user?
> > 
> > The basic idea is that controls should be standardized, or at least
> > documented and added to the V4L2 spec. Controls should belong to a
> > class, so you should select the proper base class and add a big offset
> > (I've used 0x1000) in the meantime if you want to export private
> > controls.
> 
> Is this code accessable? Then I can just copy the scheme.

[snip]

I just mean something like

#define OV5642_CONTROL_BLUE_SATURATION		(V4L2_CID_CAMERA_CLASS_BASE | 0x1001)

I'm not sure which class those controls belong to though.

> >> >>  static int ov5642_try_fmt(struct v4l2_subdev *sd, struct
> >> >> v4l2_mbus_framefmt *mf) {
> >> >>       const struct ov5642_datafmt *fmt   =
> >> >> ov5642_find_datafmt(mf->code); @@ -856,6 +1159,9 @@ static int
> >> >> ov5642_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
> >> >> if (!ret)
> >> >>               ret = ov5642_write_array(client,
> >> >> ov5642_default_regs_finalise);
> >> >> 
> >> >> +     /* the chip has been reset, so configure it again */
> >> >> +     if (!ret)
> >> >> +             ret = ov5642_restore_state(sd);
> >> > 
> >> > I suppose there's no way to avoid resetting the chip ?
> >> 
> >> Whenever the clock is down, the chip looses its state.
> > 
> > But the clock isn't turned down at every s_fmt call. Would it be possible
> > reinit the chip in the .s_power operation instead ?
> 
> Guennadi had the same idea. I tried it out already to do it in
> s_power, but the chip hangs most times then. Even when I use mplayer
> and the s_power() is closely followed by the s_fmt() the chip crashes.
> Witch the same register writes but a small time gap. The chip has
> suuuch a strange behavior that I gave up trying to solve it. It sounds
> quite unbelievable I must admit, but meantime I stopped being amazed
> by the ov5642.

Given the outstanding quality of Omnivision chips let's keep it as-is then :-)

-- 
Regards,

Laurent Pinchart
