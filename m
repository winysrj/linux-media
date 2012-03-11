Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:44509 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab2CKBzx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Mar 2012 20:55:53 -0500
Date: Sun, 11 Mar 2012 03:55:45 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: Re: [PATCH v4 5/5] v4l: Add driver for Micron MT9M032 camera sensor
Message-ID: <20120311015545.GG1591@valkosipuli.localdomain>
References: <1331305285-10781-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1331305285-10781-6-git-send-email-laurent.pinchart@ideasonboard.com>
 <4F5A56D0.50803@iki.fi>
 <24208361.kjqmef2Tq0@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24208361.kjqmef2Tq0@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Mar 09, 2012 at 09:20:47PM +0100, Laurent Pinchart wrote:
> > Laurent Pinchart wrote:
> > ...
> > 
> > > +static int mt9m032_setup_pll(struct mt9m032 *sensor)
> > > +{
> > > +	static const struct aptina_pll_limits limits = {
> > > +		.ext_clock_min = 8000000,
> > > +		.ext_clock_max = 16500000,
> > > +		.int_clock_min = 2000000,
> > > +		.int_clock_max = 24000000,
> > > +		.out_clock_min = 322000000,
> > > +		.out_clock_max = 693000000,
> > > +		.pix_clock_max = 99000000,
> > > +		.n_min = 1,
> > > +		.n_max = 64,
> > > +		.m_min = 16,
> > > +		.m_max = 255,
> > > +		.p1_min = 1,
> > > +		.p1_max = 128,
> > > +	};
> > > +
> > > +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> > > +	struct mt9m032_platform_data *pdata = sensor->pdata;
> > > +	struct aptina_pll pll;
> > > +	int ret;
> > > +
> > > +	pll.ext_clock = pdata->ext_clock;
> > > +	pll.pix_clock = pdata->pix_clock;
> > > +
> > > +	ret = aptina_pll_calculate(&client->dev, &limits, &pll);
> > > +	if (ret < 0)
> > > +		return ret;
> > > +
> > > +	sensor->pix_clock = pll.pix_clock;
> > 
> > I wouldn't expect aptina_pll_calculate() to change the supplied pixel
> > clock. I'd consider it a bug if it does that. So you could use the pixel
> > clock from platform data equally well.
> 
> But does it make a difference ? :-) Taking the value from pll.pix_clock seems 
> more logical to me.

This is an input parameter rather than output. I don't see a reason to read
it back. It works even if you do, but makes no sense.

I've been thinking of splitting the similar struct on SMIA++  between input
and output parameters later on.

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
