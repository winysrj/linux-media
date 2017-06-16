Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55026 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750846AbdFPTkD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 15:40:03 -0400
Date: Fri, 16 Jun 2017 22:39:57 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] ov6650: convert to standalone v4l2 subdevice
Message-ID: <20170616193957.GT12407@valkosipuli.retiisi.org.uk>
References: <20170615225243.12528-1-jmkrzyszt@gmail.com>
 <20170616091621.GK12407@valkosipuli.retiisi.org.uk>
 <3766309.QcUzr5zhsS@z50>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3766309.QcUzr5zhsS@z50>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 16, 2017 at 07:56:41PM +0200, Janusz Krzysztofik wrote:
> On Friday 16 June 2017 12:16:21 Sakari Ailus wrote:
> > Hi Janusz,
> > 
> > Thanks for the patch. A few comments below.
> > 
> > On Fri, Jun 16, 2017 at 12:52:43AM +0200, Janusz Krzysztofik wrote:
> > > Remove the soc_camera dependencies.
> > > 
> > > Lost features, fortunately not used or not critical on test platform:
> > > - soc_camera power on/off callback - replaced with clock enable/disable
> > >   only, no support for platform provided regulators nor power callback,
> ...
> > > -	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
> > > +	if (on)
> > > +		ret = v4l2_clk_enable(priv->clk);
> > > +	else
> > > +		v4l2_clk_disable(priv->clk);
> > 
> > It'd be nicer to use the clock framework. Although I'm certainly fine with
> > v4l2_clk for now, one thing at a time...
> 
> I have that in my queue, but the test platform I'm using does not support CCF 
> yet so there is no easy way for the host camera interface driver to provide a 
> compatible clock other than v4l2_clk based.

Ack. Could you send v2, addressing Hans's comment on moving this out of
soc_camera directory?

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
