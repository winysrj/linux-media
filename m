Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42612 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751231AbdKYQEX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Nov 2017 11:04:23 -0500
Date: Sat, 25 Nov 2017 18:04:20 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, hverkuil@xs4all.nl,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 08/10] media: i2c: ov772x: Remove soc_camera
 dependencies
Message-ID: <20171125160420.ni5drissfnbkgvrd@valkosipuli.retiisi.org.uk>
References: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org>
 <1510743363-25798-9-git-send-email-jacopo+renesas@jmondi.org>
 <20171117004315.gyc2j6x2orhxulcv@valkosipuli.retiisi.org.uk>
 <20171117091451.GC4668@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171117091451.GC4668@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 17, 2017 at 10:14:51AM +0100, jacopo mondi wrote:
> Hi Sakari!
> 
> On Fri, Nov 17, 2017 at 02:43:15AM +0200, Sakari Ailus wrote:
> > Hi Jacopo,
> >
> > On Wed, Nov 15, 2017 at 11:56:01AM +0100, Jacopo Mondi wrote:
> > >
> 
> [snip]
> 
> > > +#include <linux/clk.h>
> > >  #include <linux/init.h>
> > >  #include <linux/kernel.h>
> > >  #include <linux/module.h>
> > > @@ -25,8 +26,8 @@
> > >  #include <linux/videodev2.h>
> > >
> > >  #include <media/i2c/ov772x.h>
> > > -#include <media/soc_camera.h>
> > > -#include <media/v4l2-clk.h>
> > > +
> > > +#include <media/v4l2-device.h>
> >
> > Alphabetical order would be nice.
> 
> ups!
> 
> >
> > >  #include <media/v4l2-ctrls.h>
> > >  #include <media/v4l2-subdev.h>
> > >  #include <media/v4l2-image-sizes.h>
> > > @@ -393,7 +394,7 @@ struct ov772x_win_size {
> > >  struct ov772x_priv {
> > >  	struct v4l2_subdev                subdev;
> > >  	struct v4l2_ctrl_handler	  hdl;
> > > -	struct v4l2_clk			 *clk;
> > > +	struct clk			 *clk;
> > >  	struct ov772x_camera_info        *info;
> > >  	const struct ov772x_color_format *cfmt;
> > >  	const struct ov772x_win_size     *win;
> > > @@ -550,7 +551,7 @@ static int ov772x_reset(struct i2c_client *client)
> > >  }
> > >
> > >  /*
> > > - * soc_camera_ops function
> > > + * subdev ops
> > >   */
> > >
> > >  static int ov772x_s_stream(struct v4l2_subdev *sd, int enable)
> > > @@ -650,13 +651,36 @@ static int ov772x_s_register(struct v4l2_subdev *sd,
> > >  }
> > >  #endif
> > >
> > > +static int ov772x_power_on(struct ov772x_priv *priv)
> > > +{
> > > +	int ret;
> > > +
> > > +	if (priv->info->platform_enable) {
> > > +		ret = priv->info->platform_enable();
> > > +		if (ret)
> > > +			return ret;
> >
> > What does this do, enable the regulator?
> 
> Well, it depends on what function the platform code stores in
> 'platform_enable' pointer, doesn't it?
> 
> As you can see in [05/10] of this series, for Migo-R it's not about
> a regulator, but switching between the two available video inputs
> (OV7725 and TW9910) toggling their 'enable' pins.

Ok. That's not a very nice design.

Fair enough. I guess it's good to proceed one thing at a time.

If someone has this sensor on a board with DT support, we can use the
regulator framework and just ignore the platform callbacks.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
