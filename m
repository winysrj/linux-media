Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:44728 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727489AbeGSM42 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jul 2018 08:56:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: jacopo mondi <jacopo@jmondi.org>,
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
Date: Thu, 19 Jul 2018 15:14:06 +0300
Message-ID: <2173334.CLADOdgFxd@avalon>
In-Reply-To: <20180719084208.4zdwt4vzcop4hve7@ninjato>
References: <1531756070-8560-1-git-send-email-akinobu.mita@gmail.com> <20180719074736.GA6784@w540> <20180719084208.4zdwt4vzcop4hve7@ninjato>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday, 19 July 2018 11:42:08 EEST Wolfram Sang wrote:
> > > -static int ov772x_mask_set(struct i2c_client *client, u8  command, u8 
> > > mask,
> > > -			   u8  set)
> > > -{
> > > -	s32 val = ov772x_read(client, command);
> > > -
> > > -	if (val < 0)
> > > -		return val;
> > > -
> > > -	val &= ~mask;
> > > -	val |= set & mask;
> > > -
> > > -	return ov772x_write(client, command, val);
> > > -}
> > > -
> > 
> > If I were you I would have kept these functions and wrapped the regmap
> > operations there. This is not an issue though if you prefer it this
> > way :)
> 
> I have suggested this way. It is not a show stopper issue, but I still
> like this version better.

Wrapping the regmap functions minimizes the diff and makes it easier to 
backport the driver.

-- 
Regards,

Laurent Pinchart
