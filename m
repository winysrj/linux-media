Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:50807 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965309AbdKQJO5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 04:14:57 -0500
Date: Fri, 17 Nov 2017 10:14:51 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, hverkuil@xs4all.nl,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 08/10] media: i2c: ov772x: Remove soc_camera
 dependencies
Message-ID: <20171117091451.GC4668@w540>
References: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org>
 <1510743363-25798-9-git-send-email-jacopo+renesas@jmondi.org>
 <20171117004315.gyc2j6x2orhxulcv@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20171117004315.gyc2j6x2orhxulcv@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari!

On Fri, Nov 17, 2017 at 02:43:15AM +0200, Sakari Ailus wrote:
> Hi Jacopo,
>
> On Wed, Nov 15, 2017 at 11:56:01AM +0100, Jacopo Mondi wrote:
> >

[snip]

> > +#include <linux/clk.h>
> >  #include <linux/init.h>
> >  #include <linux/kernel.h>
> >  #include <linux/module.h>
> > @@ -25,8 +26,8 @@
> >  #include <linux/videodev2.h>
> >
> >  #include <media/i2c/ov772x.h>
> > -#include <media/soc_camera.h>
> > -#include <media/v4l2-clk.h>
> > +
> > +#include <media/v4l2-device.h>
>
> Alphabetical order would be nice.

ups!

>
> >  #include <media/v4l2-ctrls.h>
> >  #include <media/v4l2-subdev.h>
> >  #include <media/v4l2-image-sizes.h>
> > @@ -393,7 +394,7 @@ struct ov772x_win_size {
> >  struct ov772x_priv {
> >  	struct v4l2_subdev                subdev;
> >  	struct v4l2_ctrl_handler	  hdl;
> > -	struct v4l2_clk			 *clk;
> > +	struct clk			 *clk;
> >  	struct ov772x_camera_info        *info;
> >  	const struct ov772x_color_format *cfmt;
> >  	const struct ov772x_win_size     *win;
> > @@ -550,7 +551,7 @@ static int ov772x_reset(struct i2c_client *client)
> >  }
> >
> >  /*
> > - * soc_camera_ops function
> > + * subdev ops
> >   */
> >
> >  static int ov772x_s_stream(struct v4l2_subdev *sd, int enable)
> > @@ -650,13 +651,36 @@ static int ov772x_s_register(struct v4l2_subdev *sd,
> >  }
> >  #endif
> >
> > +static int ov772x_power_on(struct ov772x_priv *priv)
> > +{
> > +	int ret;
> > +
> > +	if (priv->info->platform_enable) {
> > +		ret = priv->info->platform_enable();
> > +		if (ret)
> > +			return ret;
>
> What does this do, enable the regulator?

Well, it depends on what function the platform code stores in
'platform_enable' pointer, doesn't it?

As you can see in [05/10] of this series, for Migo-R it's not about
a regulator, but switching between the two available video inputs
(OV7725 and TW9910) toggling their 'enable' pins.

Thanks
   j
