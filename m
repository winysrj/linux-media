Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:1643 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbZBNJvu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Feb 2009 04:51:50 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Subject: Re: VIDIOC_G_REGISTER question
Date: Sat, 14 Feb 2009 10:51:52 +0100
Cc: linux-media@vger.kernel.org
References: <1234574774.3112.16.camel@palomino.walls.org>
In-Reply-To: <1234574774.3112.16.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902141051.52447.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 14 February 2009 02:26:14 Andy Walls wrote:
> I'm treating the CX23418 A/V Core as a non-I2C host chip.
>
> Am I allowed to modify the register value passed in to a
> VIDIOC_G_REGISTER ioctl() like below?  The spec doesn't say if this
> feedback is expected or not.

Good point. The short answer is no, because no other driver does that AFAIK. 

The long answer is that perhaps we should do this, but that requires going 
through all drivers and updating them, and it requires changing the API for 
s_register (currently that has a const argument) and requiring drivers to 
update reg in s_register as well. But I do not really see much of an 
advantage in doing this. It would also make it impossible to have a 
for-loop on the reg field when iterating over registers (for the record: 
v4l2-dbg doesn't do that).

Nice idea, BTW, making the analog front end addr 1 on the host.

For the chip revision I would suggest looking at various revision registers 
in the analog front end: regs 0x0000, 0x0004, 0x000c and 0x0100 all have 
some sort of a version/revision ID in them. The 0x0100 should match the 
revision as used in the cx2584x. I never really looked at these regs, so I 
don't know which makes the most sense.

Just FYI, once all drivers are using v4l2_subdev I'm going to simplify the 
chip_ident and s/g_register functions by integrating it into v4l2_subdev. 
The idea is to put ident and revision into the v4l2_subdev struct, and have 
a dbg_match op in v4l2_subdev that is used to do the matching for 
g_chip_ident and g/s_register. For i2c devices this will be a standard 
function in v4l2-common.h. So g_chip_ident will disappear and g/s_register 
no longer needs to do any matching.

Regards,

	Hans

> static inline int cx18_av_dbg_match(const struct v4l2_dbg_match *match)
> {
>         return match->type == V4L2_CHIP_MATCH_HOST && match->addr == 1;
> }
>
> static int cx18_av_g_chip_ident(struct v4l2_subdev *sd,
>                                 struct v4l2_dbg_chip_ident *chip)
> {
>         if (cx18_av_dbg_match(&chip->match))
>         {
>                 /*
>                  * Nothing else is going to claim to be this combination,
>                  * and the real host chip revision will be returned by a
> host * match on address 0.
>                  */
>                 chip->ident = V4L2_IDENT_CX25843;
>                 chip->revision = V4L2_IDENT_CX23418; /* Why not */
>         }
>         return 0;
> }
>
>
> #ifdef CONFIG_VIDEO_ADV_DEBUG
> static int cx18_av_g_register(struct v4l2_subdev *sd,
>                               struct v4l2_dbg_register *reg)
> {
>         struct cx18 *cx = v4l2_get_subdevdata(sd);
>
>         if (!cx18_av_dbg_match(&reg->match))
>                 return -EINVAL;
>         if (!capable(CAP_SYS_ADMIN))
>                 return -EPERM;
>         reg->reg &= 0x00000ffc;         <============ Is this OK ????
>         reg->size = 4;
>         reg->val = cx18_av_read4(cx, reg->reg);
>         return 0;
> }
> [...]
>
>
>
> Regards,
> Andy
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
