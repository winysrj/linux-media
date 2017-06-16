Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33243 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750864AbdFPR6k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 13:58:40 -0400
Received: by mail-lf0-f67.google.com with SMTP id u62so4891165lfg.0
        for <linux-media@vger.kernel.org>; Fri, 16 Jun 2017 10:58:39 -0700 (PDT)
From: Janusz Krzysztofik <jmkrzyszt@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] ov6650: convert to standalone v4l2 subdevice
Date: Fri, 16 Jun 2017 19:56:41 +0200
Message-ID: <3766309.QcUzr5zhsS@z50>
In-Reply-To: <20170616091621.GK12407@valkosipuli.retiisi.org.uk>
References: <20170615225243.12528-1-jmkrzyszt@gmail.com> <20170616091621.GK12407@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 16 June 2017 12:16:21 Sakari Ailus wrote:
> Hi Janusz,
> 
> Thanks for the patch. A few comments below.
> 
> On Fri, Jun 16, 2017 at 12:52:43AM +0200, Janusz Krzysztofik wrote:
> > Remove the soc_camera dependencies.
> > 
> > Lost features, fortunately not used or not critical on test platform:
> > - soc_camera power on/off callback - replaced with clock enable/disable
> >   only, no support for platform provided regulators nor power callback,
...
> > -	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
> > +	if (on)
> > +		ret = v4l2_clk_enable(priv->clk);
> > +	else
> > +		v4l2_clk_disable(priv->clk);
> 
> It'd be nicer to use the clock framework. Although I'm certainly fine with
> v4l2_clk for now, one thing at a time...

I have that in my queue, but the test platform I'm using does not support CCF 
yet so there is no easy way for the host camera interface driver to provide a 
compatible clock other than v4l2_clk based.

Thanks,
Janusz
