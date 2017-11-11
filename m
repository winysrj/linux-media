Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60130 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752208AbdKKXiJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Nov 2017 18:38:09 -0500
Date: Sun, 12 Nov 2017 01:38:06 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v10 2/2] media: rcar-csi2: add Renesas R-Car MIPI CSI-2
 receiver driver
Message-ID: <20171111233806.v7zlrjrt6jmv3gr7@valkosipuli.retiisi.org.uk>
References: <20171110133137.9137-1-niklas.soderlund+renesas@ragnatech.se>
 <20171110133137.9137-3-niklas.soderlund+renesas@ragnatech.se>
 <20171110223227.pug7d4qi7rdi4b4b@valkosipuli.retiisi.org.uk>
 <2456560.miCsvfXtsD@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2456560.miCsvfXtsD@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Sat, Nov 11, 2017 at 08:17:59AM +0200, Laurent Pinchart wrote:
> > > +static int rcar_csi2_s_power(struct v4l2_subdev *sd, int on)
> > > +{
> > > +	struct rcar_csi2 *priv = sd_to_csi2(sd);
> > > +
> > > +	if (on)
> > > +		pm_runtime_get_sync(priv->dev);
> > > +	else
> > > +		pm_runtime_put(priv->dev);
> > 
> > The pipeline you have is already rather complex. Would it be an option to
> > power the hardware on when streaming is started? The smiapp driver does
> > this, without even implementing the s_power callback. (You'd still need to
> > call it on the image source, as long as we have drivers that need it.)
> 
> We've briefly discussed this before, and I agree that pipeline power 
> management needs to be redesigned, but we still haven't agreed on a proper 
> architecture for that. Feel free to propose an RFC :-) In the meantime I 

Well, perhaps we should look at the use cases and see if there are gaps.
Runtime PM is essentially used everywhere else in the kernel.

> wouldn't try to enforce one specific model.

What I just wanted to point out that by switching to runtime PM you avoid
adding a new driver which is dependent on the s_power callback which I
don't think we'll want to keep in the long run. In this case there's no
benefit from s_power in any quantifiable way that I can see.

Actually the master driver manages calling the s_power callback so there's
hardly a need to do so here. It's just that the master drivers still need
that as long as there are sub-device drivers that depend on it.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
