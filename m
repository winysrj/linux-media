Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:46042 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763860AbZBNB0G (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2009 20:26:06 -0500
Received: from [192.168.1.2] (01-025.155.popsite.net [66.217.131.25])
	(authenticated bits=0)
	by mail1.radix.net (8.13.4/8.13.4) with ESMTP id n1E1Q3OK018809
	for <linux-media@vger.kernel.org>; Fri, 13 Feb 2009 20:26:04 -0500 (EST)
Subject: VIDIOC_G_REGISTER question
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Fri, 13 Feb 2009 20:26:14 -0500
Message-Id: <1234574774.3112.16.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I'm treating the CX23418 A/V Core as a non-I2C host chip.

Am I allowed to modify the register value passed in to a
VIDIOC_G_REGISTER ioctl() like below?  The spec doesn't say if this
feedback is expected or not.


static inline int cx18_av_dbg_match(const struct v4l2_dbg_match *match)
{
        return match->type == V4L2_CHIP_MATCH_HOST && match->addr == 1;
}

static int cx18_av_g_chip_ident(struct v4l2_subdev *sd,
                                struct v4l2_dbg_chip_ident *chip)
{
        if (cx18_av_dbg_match(&chip->match))
        {
                /*
                 * Nothing else is going to claim to be this combination,
                 * and the real host chip revision will be returned by a host
                 * match on address 0.
                 */
                chip->ident = V4L2_IDENT_CX25843;
                chip->revision = V4L2_IDENT_CX23418; /* Why not */
        }
        return 0;
}


#ifdef CONFIG_VIDEO_ADV_DEBUG
static int cx18_av_g_register(struct v4l2_subdev *sd,
                              struct v4l2_dbg_register *reg)
{
        struct cx18 *cx = v4l2_get_subdevdata(sd);

        if (!cx18_av_dbg_match(&reg->match))
                return -EINVAL;
        if (!capable(CAP_SYS_ADMIN))
                return -EPERM;
        reg->reg &= 0x00000ffc;         <============ Is this OK ????
        reg->size = 4;
        reg->val = cx18_av_read4(cx, reg->reg);
        return 0;
}
[...]



Regards,
Andy


