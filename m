Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40464 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752524AbcFQVgU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 17:36:20 -0400
Date: Sat, 18 Jun 2016 00:35:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	pali.rohar@gmail.com, sre@kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH] userspace API definitions for auto-focus coil
Message-ID: <20160617213545.GH24980@valkosipuli.retiisi.org.uk>
References: <20160601220840.GA21946@amd>
 <20160602074544.GR26360@valkosipuli.retiisi.org.uk>
 <20160602193027.GB7984@amd>
 <20160602212746.GT26360@valkosipuli.retiisi.org.uk>
 <20160605190716.GA11321@amd>
 <575512E5.5030000@gmail.com>
 <20160611220654.GC26360@valkosipuli.retiisi.org.uk>
 <20160612084811.GA27446@amd>
 <20160612112253.GD26360@valkosipuli.retiisi.org.uk>
 <20160613191753.GA17459@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160613191753.GA17459@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Mon, Jun 13, 2016 at 09:17:53PM +0200, Pavel Machek wrote:
> On Sun 2016-06-12 14:22:53, Sakari Ailus wrote:
> > Hi Pavel,
> > 
> > On Sun, Jun 12, 2016 at 10:48:11AM +0200, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > > >Add userspace API definitions.
> > > > > >
> > > > > >Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > > > > >
> > > > > >diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> > > > > >index b6a357a..23011cc 100644
> > > > > >--- a/include/uapi/linux/v4l2-controls.h
> > > > > >+++ b/include/uapi/linux/v4l2-controls.h
> > > > > >@@ -974,4 +975,9 @@ enum v4l2_detect_md_mode {
> > > > > >  #define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_CLASS_BASE + 3)
> > > > > >  #define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DETECT_CLASS_BASE + 4)
> > > > > >
> > > > > >+/* Control IDs specific to the AD5820 driver as defined by V4L2 */
> > > > > >+#define V4L2_CID_FOCUS_AD5820_BASE 	(V4L2_CTRL_CLASS_CAMERA | 0x10af)
> > > > 
> > > > Please check V4L2_CID_USER_*_BASE. That's how custom controls are handled
> > > > nowadays.
> > > 
> > > So something like this?
> > > 
> > > Thanks,
> > > 									Pavel
> > > 
> > > diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
> > > index 2efa5dc1..b04b471 100644
> > > --- a/drivers/media/i2c/ad5820.c
> > > +++ b/drivers/media/i2c/ad5820.c
> > > @@ -40,6 +40,11 @@
> > >  #define AD5820_RAMP_MODE_LINEAR		(0 << 3)
> > >  #define AD5820_RAMP_MODE_64_16		(1 << 3)
> > >  
> > > +/* Control IDs specific to the AD5820 driver as defined by V4L2 */
> > > +#define V4L2_CID_FOCUS_AD5820_RAMP_TIME		(V4L2_CID_USER_AD5820_BASE+0)
> > > +#define V4L2_CID_FOCUS_AD5820_RAMP_MODE		(V4L2_CID_FOCUS_AD5820_BASE+1)
> > > +
> > > +
> > 
> > We could still define these in a header file that can be included by the
> > user space. Please use V4L2_CID_AD5820 prefix.
> 
> Not V4L2_CID_USER_AD5820...?

The rest of the controls have no USER as part of the macro name, so I
wouldn't use it here either.

> 
> > A separate header file should be used,
> >  e.g. include/uapi/linux/ad5820.h.
> 
> Ok, separate header file for 2 lines seemed like a bit of overkill,
> but why not.

That follows an existing pattern of how controls have been implemented in
other drivers.

> 
> Something like this?

Yes. A few minor comments below.

Could you merge this with the driver patch? I've dropped that from my ad5820
branch as it does not compile.

> 
> commit 8dd701d2580e41b06bb2285e6bd59a4f1702b4d8
> Author: Pavel <pavel@ucw.cz>
> Date:   Mon Jun 13 21:17:15 2016 +0200
> 
>     Userspace api, as Sakari asked.
> 
> diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
> index 2efa5dc1..ed3facc 100644
> --- a/drivers/media/i2c/ad5820.c
> +++ b/drivers/media/i2c/ad5820.c
> @@ -32,6 +32,8 @@
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-subdev.h>
>  
> +#include <uapi/linux/ad5820.h>
> +
>  #define AD5820_NAME		"ad5820"
>  
>  /* Register definitions */
> @@ -40,6 +42,8 @@
>  #define AD5820_RAMP_MODE_LINEAR		(0 << 3)
>  #define AD5820_RAMP_MODE_64_16		(1 << 3)
>  
> +
> +

Extra newlines.

>  #define CODE_TO_RAMP_US(s)	((s) == 0 ? 0 : (1 << ((s) - 1)) * 50)
>  #define RAMP_US_TO_CODE(c)	fls(((c) + ((c)>>1)) / 50)
>  
> @@ -165,13 +169,13 @@ static int ad5820_set_ctrl(struct v4l2_ctrl *ctrl)
>  		coil->focus_absolute = ctrl->val;
>  		return ad5820_update_hw(coil);
>  
> -	case V4L2_CID_FOCUS_AD5820_RAMP_TIME:
> +	case V4L2_CID_AD5820_RAMP_TIME:
>  		code = RAMP_US_TO_CODE(ctrl->val);
>  		ctrl->val = CODE_TO_RAMP_US(code);
>  		coil->focus_ramp_time = ctrl->val;
>  		break;
>  
> -	case V4L2_CID_FOCUS_AD5820_RAMP_MODE:
> +	case V4L2_CID_AD5820_RAMP_MODE:
>  		coil->focus_ramp_mode = ctrl->val;
>  		break;
>  	}
> @@ -191,7 +195,7 @@ static const char * const ad5820_focus_menu[] = {
>  static const struct v4l2_ctrl_config ad5820_ctrls[] = {
>  	{
>  		.ops		= &ad5820_ctrl_ops,
> -		.id		= V4L2_CID_FOCUS_AD5820_RAMP_TIME,
> +		.id		= V4L2_CID_AD5820_RAMP_TIME,
>  		.type		= V4L2_CTRL_TYPE_INTEGER,
>  		.name		= "Focus ramping time [us]",
>  		.min		= 0,
> @@ -202,7 +206,7 @@ static const struct v4l2_ctrl_config ad5820_ctrls[] = {
>  	},
>  	{
>  		.ops		= &ad5820_ctrl_ops,
> -		.id		= V4L2_CID_FOCUS_AD5820_RAMP_MODE,
> +		.id		= V4L2_CID_AD5820_RAMP_MODE,
>  		.type		= V4L2_CTRL_TYPE_MENU,
>  		.name		= "Focus ramping mode",
>  		.min		= 0,
> diff --git a/include/uapi/linux/ad5820.h b/include/uapi/linux/ad5820.h
> new file mode 100644
> index 0000000..d44ba9c
> --- /dev/null
> +++ b/include/uapi/linux/ad5820.h
> @@ -0,0 +1,18 @@
> +/*
> + * AD5820 DAC driver for camera voice coil focus.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + */
> +
> +#ifndef __LINUX_AD5820_H
> +#define __LINUX_AD5820_H
> +
> +#include <linux/v4l2-controls.h>
> +
> +/* Control IDs specific to the AD5820 driver as defined by V4L2 */
> +#define V4L2_CID_AD5820_RAMP_TIME	(V4L2_CID_AD5820_BASE+0)

(V4L2_CID_AD5820_BASE + 0)

Same below.

> +#define V4L2_CID_AD5820_RAMP_MODE	(V4L2_CID_AD5820_BASE+1)
> +
> +#endif
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index 23011cc..015e90b 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -181,6 +181,10 @@ enum v4l2_colorfx {
>   * We reserve 16 controls for this driver. */
>  #define V4L2_CID_USER_TC358743_BASE		(V4L2_CID_USER_BASE + 0x1080)
>  
> +/* The base for the ad5820 driver controls.
> + * We reserve 16 controls for this driver. */
> +#define V4L2_CID_AD5820_BASE			(V4L2_CID_USER_BASE + 0x1090)
> +
>  /* MPEG-class control IDs */
>  /* The MPEG controls are applicable to all codec controls
>   * and the 'MPEG' part of the define is historical */
> @@ -986,9 +990,4 @@ enum v4l2_detect_md_mode {
>  #define V4L2_CID_MODE_SENSITIVITY		(V4L2_CID_MODE_CLASS_BASE+6)
>  #define V4L2_CID_MODE_OPSYSCLOCK		(V4L2_CID_MODE_CLASS_BASE+7)
>  
> -/* Control IDs specific to the AD5820 driver as defined by V4L2 */
> -#define V4L2_CID_FOCUS_AD5820_BASE 		(V4L2_CTRL_CLASS_CAMERA | 0x10af)
> -#define V4L2_CID_FOCUS_AD5820_RAMP_TIME		(V4L2_CID_FOCUS_AD5820_BASE+0)
> -#define V4L2_CID_FOCUS_AD5820_RAMP_MODE		(V4L2_CID_FOCUS_AD5820_BASE+1)
> -
>  #endif
> 
> 

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
