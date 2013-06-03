Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor3.renesas.com ([210.160.252.173]:42753 "EHLO
	relmlor3.renesas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab3FCNcj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 09:32:39 -0400
Received: from relmlir2.idc.renesas.com ([10.200.68.152])
 by relmlor3.idc.renesas.com ( SJSMS)
 with ESMTP id <0MNT00LTZKAER0B0@relmlor3.idc.renesas.com> for
 linux-media@vger.kernel.org; Mon, 03 Jun 2013 22:32:38 +0900 (JST)
Received: from relmlac4.idc.renesas.com ([10.200.69.24])
 by relmlir2.idc.renesas.com ( SJSMS)
 with ESMTP id <0MNT00GLIKAEIL00@relmlir2.idc.renesas.com> for
 linux-media@vger.kernel.org; Mon, 03 Jun 2013 22:32:38 +0900 (JST)
In-reply-to: <201306031149.45454.hverkuil@xs4all.nl>
References: <1370252135-23261-1-git-send-email-phil.edworthy@renesas.com>
 <201306031149.45454.hverkuil@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-version: 1.0
From: phil.edworthy@renesas.com
Subject: Re: [PATCH] ov10635: Add OmniVision ov10635 SoC camera driver
Message-id: <OF4BD2B449.93EBBD07-ON80257B7F.0049D5FC-80257B7F.004A56F1@eu.necel.com>
Date: Mon, 03 Jun 2013 14:31:55 +0100
Content-type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

> Subject: Re: [PATCH] ov10635: Add OmniVision ov10635 SoC camera driver
<snip>
> > +#include <media/v4l2-chip-ident.h>
> 
> Don't implement chip_ident or use this header: it's going to be 
> removed in 3.11.

<snip>
> > +/* Set status of additional camera capabilities */
> > +static int ov10635_s_ctrl(struct v4l2_ctrl *ctrl)
> > +{
> > +   struct ov10635_priv *priv = container_of(ctrl->handler,
> > +               struct ov10635_priv, hdl);
> > +   struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
> > +
> > +   switch (ctrl->id) {
> > +   case V4L2_CID_VFLIP:
> > +      if (ctrl->val)
> > +         return ov10635_reg_rmw(client, OV10635_VFLIP,
> > +            OV10635_VFLIP_ON, 0);
> > +      else
> 
> No need for 'else'.
Ok.

> > +         return ov10635_reg_rmw(client, OV10635_VFLIP,
> > +            0, OV10635_VFLIP_ON);
> > +      break;
> 
> No need for 'break'. Ditto for HFLIP.
Ok.

<snip>
> > +/* Get chip identification */
> > +static int ov10635_g_chip_ident(struct v4l2_subdev *sd,
> > +            struct v4l2_dbg_chip_ident *id)
> > +{
> > +   struct i2c_client *client = v4l2_get_subdevdata(sd);
> > +   struct ov10635_priv *priv = to_ov10635(client);
> > +
> > +   id->ident   = priv->model;
> > +   id->revision   = priv->revision;
> > +
> > +   return 0;
> > +}
> 
> Drop this function, no longer needed.

<snip>
> > diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-
> chip-ident.h
> > index 4ee125b..8fc3303 100644
> > --- a/include/media/v4l2-chip-ident.h
> > +++ b/include/media/v4l2-chip-ident.h
> > @@ -77,6 +77,7 @@ enum {
> >     V4L2_IDENT_OV2640 = 259,
> >     V4L2_IDENT_OV9740 = 260,
> >     V4L2_IDENT_OV5642 = 261,
> > +   V4L2_IDENT_OV10635 = 262,
> > 
> >     /* module saa7146: reserved range 300-309 */
> >     V4L2_IDENT_SAA7146 = 300,
> > 
> 
> This can be dropped as well, because this header will go away.

Thanks for the very quick review! I'll have a look at the media tree to 
see what's changing wrt the chip ident.

Phil
