Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59180 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731126AbeGSNx3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jul 2018 09:53:29 -0400
Date: Thu, 19 Jul 2018 16:10:20 +0300
From: sakari.ailus@iki.fi
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, jacopo mondi <jacopo@jmondi.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        linux-media@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Peter Rosin <peda@axentia.se>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH -next v4 2/3] media: ov772x: use SCCB regmap
Message-ID: <20180719131019.2kolodvc4r5ewqic@lanttu.localdomain>
References: <1531756070-8560-1-git-send-email-akinobu.mita@gmail.com>
 <20180719074736.GA6784@w540>
 <20180719084208.4zdwt4vzcop4hve7@ninjato>
 <2173334.CLADOdgFxd@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2173334.CLADOdgFxd@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 19, 2018 at 03:14:06PM +0300, Laurent Pinchart wrote:
> On Thursday, 19 July 2018 11:42:08 EEST Wolfram Sang wrote:
> > > > -static int ov772x_mask_set(struct i2c_client *client, u8  command, u8 
> > > > mask,
> > > > -			   u8  set)
> > > > -{
> > > > -	s32 val = ov772x_read(client, command);
> > > > -
> > > > -	if (val < 0)
> > > > -		return val;
> > > > -
> > > > -	val &= ~mask;
> > > > -	val |= set & mask;
> > > > -
> > > > -	return ov772x_write(client, command, val);
> > > > -}
> > > > -
> > > 
> > > If I were you I would have kept these functions and wrapped the regmap
> > > operations there. This is not an issue though if you prefer it this
> > > way :)
> > 
> > I have suggested this way. It is not a show stopper issue, but I still
> > like this version better.
> 
> Wrapping the regmap functions minimizes the diff and makes it easier to 
> backport the driver.

May be, but using the regmap functions directly makes the driver cleaner.
Most drivers have some kind of wrappers around the I²C framework (or
regmap) functions; this one is one of the few to get rid of them.

The two could be done in a separate patch, too, albeit I think the current
one seems fine as such.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
