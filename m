Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37330 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751416AbdFAI1i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 04:27:38 -0400
Date: Thu, 1 Jun 2017 11:26:59 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v7 16/34] [media] add Omnivision OV5640 sensor driver
Message-ID: <20170601082659.GJ1019@valkosipuli.retiisi.org.uk>
References: <1495672189-29164-1-git-send-email-steve_longerbeam@mentor.com>
 <1495672189-29164-17-git-send-email-steve_longerbeam@mentor.com>
 <20170531195821.GA16962@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170531195821.GA16962@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Wed, May 31, 2017 at 09:58:21PM +0200, Pavel Machek wrote:
> Hi!
> 
> > +/* min/typical/max system clock (xclk) frequencies */
> > +#define OV5640_XCLK_MIN  6000000
> > +#define OV5640_XCLK_MAX 24000000
> > +
> > +/*
> > + * FIXME: there is no subdev API to set the MIPI CSI-2
> > + * virtual channel yet, so this is hardcoded for now.
> > + */
> > +#define OV5640_MIPI_VC	1
> 
> Can the FIXME be fixed?

Yes, but it's quite a bit of work. It makes sense to use a static virtual
channel for now. A patchset which is however incomplete can be found here:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=vc>

For what it's worth, all other devices use virtual channel zero for image
data and so should this one.

> 
> > +/*
> > + * image size under 1280 * 960 are SUBSAMPLING
> 
> -> Image
> 
> > + * image size upper 1280 * 960 are SCALING
> 
> above?
> 
> > +/*
> > + * FIXME: all of these register tables are likely filled with
> > + * entries that set the register to their power-on default values,
> > + * and which are otherwise not touched by this driver. Those entries
> > + * should be identified and removed to speed register load time
> > + * over i2c.
> > + */
> 
> load->loading? Can the FIXME be fixed?
> 
> > +	/* Auto/manual exposure */
> > +	ctrls->auto_exp = v4l2_ctrl_new_std_menu(hdl, ops,
> > +						 V4L2_CID_EXPOSURE_AUTO,
> > +						 V4L2_EXPOSURE_MANUAL, 0,
> > +						 V4L2_EXPOSURE_AUTO);
> > +	ctrls->exposure = v4l2_ctrl_new_std(hdl, ops,
> > +					    V4L2_CID_EXPOSURE_ABSOLUTE,
> > +					    0, 65535, 1, 0);
> 
> Is exposure_absolute supposed to be in microseconds...?

Yes. OTOH V4L2_CID_EXPOSURE has no defined unit, so it's a better fit IMO.
Way more drivers appear to be using EXPOSURE than EXPOSURE_ABSOLUTE, too.

Ideally we should have only one control for exposure.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
