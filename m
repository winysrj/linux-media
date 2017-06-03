Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44042 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751162AbdFCV5t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Jun 2017 17:57:49 -0400
Date: Sun, 4 Jun 2017 00:57:09 +0300
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
Message-ID: <20170603215709.GU1019@valkosipuli.retiisi.org.uk>
References: <1495672189-29164-1-git-send-email-steve_longerbeam@mentor.com>
 <1495672189-29164-17-git-send-email-steve_longerbeam@mentor.com>
 <20170531195821.GA16962@amd>
 <20170601082659.GJ1019@valkosipuli.retiisi.org.uk>
 <755909bf-d1de-e0f3-1569-0d4b16e26817@gmail.com>
 <20170603195139.GA3062@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170603195139.GA3062@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 03, 2017 at 09:51:39PM +0200, Pavel Machek wrote:
> Hi!
> 
> > >>>+	/* Auto/manual exposure */
> > >>>+	ctrls->auto_exp = v4l2_ctrl_new_std_menu(hdl, ops,
> > >>>+						 V4L2_CID_EXPOSURE_AUTO,
> > >>>+						 V4L2_EXPOSURE_MANUAL, 0,
> > >>>+						 V4L2_EXPOSURE_AUTO);
> > >>>+	ctrls->exposure = v4l2_ctrl_new_std(hdl, ops,
> > >>>+					    V4L2_CID_EXPOSURE_ABSOLUTE,
> > >>>+					    0, 65535, 1, 0);
> > >>
> > >>Is exposure_absolute supposed to be in microseconds...?
> > >
> > >Yes.
> > 
> > According to the docs V4L2_CID_EXPOSURE_ABSOLUTE is in 100 usec units.
> > 
> >  OTOH V4L2_CID_EXPOSURE has no defined unit, so it's a better fit IMO.
> > >Way more drivers appear to be using EXPOSURE than EXPOSURE_ABSOLUTE, too.
> > 
> > Done, switched to V4L2_CID_EXPOSURE. It's true, this control is not
> > taking 100 usec units, so unit-less is better.
> 
> Thanks. If you know the units, it would be of course better to use
> right units...

Steve: what's the unit in this case? Is it lines or something else?

Pavel: we do need to make sure the user space will be able to know the unit,
too. It's rather a case with a number of controls: the unit is known but
there's no API to convey it to the user.

The exposure is a bit special, too: granularity matters a lot on small
values. On most other controls it does not.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
