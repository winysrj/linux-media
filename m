Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56462 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752779AbeDQNUN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 09:20:13 -0400
Date: Tue, 17 Apr 2018 16:20:10 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, nm@ti.com,
        Simon Hatliff <hatliff@cadence.com>
Subject: Re: [PATCH v8 2/2] v4l: cadence: Add Cadence MIPI-CSI2 TX driver
Message-ID: <20180417132010.zhr3nrigeqzeorg3@valkosipuli.retiisi.org.uk>
References: <20180404122025.8726-1-maxime.ripard@bootlin.com>
 <20180404122025.8726-3-maxime.ripard@bootlin.com>
 <20180413121437.slsv2ef2j5k2aihw@valkosipuli.retiisi.org.uk>
 <20180417131024.kc6smxh4mbd44nst@flea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180417131024.kc6smxh4mbd44nst@flea>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 17, 2018 at 03:10:24PM +0200, Maxime Ripard wrote:
> Hi Sakari,
> 
> On Fri, Apr 13, 2018 at 03:14:37PM +0300, Sakari Ailus wrote:
> > > +static int csi2tx_set_pad_format(struct v4l2_subdev *subdev,
> > > +				 struct v4l2_subdev_pad_config *cfg,
> > > +				 struct v4l2_subdev_format *fmt)
> > > +{
> > > +	struct csi2tx_priv *csi2tx = v4l2_subdev_to_csi2tx(subdev);
> > > +
> > > +	if (fmt->pad >= CSI2TX_PAD_MAX)
> > > +		return -EINVAL;
> > > +
> > > +	csi2tx->pad_fmts[fmt->pad] = fmt->format;
> > 
> > Have I asked previously if there are any limitations with this?
> > 
> > The CSI-2 TX link has multiple formats so I wouldn't support formats on
> > that pad in order to be compatible with the planned VC/data type support
> > patchset. Or do you see issues with that?
> 
> It's not just about the CSI-2 link, but more about the input pads as
> well, that can be configured (and we need to know the format in order
> to configure the IP properly).
> 
> Maybe we can simply prevent the format change on the CSI-2 pad, but
> not the others?

Yes, that was what I wanted to suggest. It's in line with the intended way
to support multiplexed pads.

The latest set is here:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=vc>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
