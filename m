Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:28579 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751462AbdJKNic (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 09:38:32 -0400
Date: Wed, 11 Oct 2017 08:36:39 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Cyprian Wronka <cwronka@cadence.com>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>, <nm@ti.com>
Subject: Re: [PATCH 2/2] v4l: cadence: Add Cadence MIPI-CSI2 TX driver
Message-ID: <20171011133639.GC25400@ti.com>
References: <20170922114703.30511-1-maxime.ripard@free-electrons.com>
 <20170922114703.30511-3-maxime.ripard@free-electrons.com>
 <20170929182125.GB3163@ti.com>
 <20171011115544.w7eswyhke6dskgbb@flea>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20171011115544.w7eswyhke6dskgbb@flea>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

Maxime Ripard <maxime.ripard@free-electrons.com> wrote on Wed [2017-Oct-11 13:55:44 +0200]:
> Hi Benoit,
> 
> On Fri, Sep 29, 2017 at 06:21:25PM +0000, Benoit Parrot wrote:
> > > +struct csi2tx_priv {
> > > +	struct device			*dev;
> > > +	atomic_t			count;
> > > +
> > > +	void __iomem			*base;
> > > +
> > > +	struct clk			*esc_clk;
> > > +	struct clk			*p_clk;
> > > +	struct clk			*pixel_clk[CSI2TX_STREAMS_MAX];
> > > +
> > > +	struct v4l2_subdev		subdev;
> > > +	struct media_pad		pads[CSI2TX_PAD_MAX];
> > > +	struct v4l2_mbus_framefmt	pad_fmts[CSI2TX_PAD_MAX];
> > > +
> > > +	bool				has_internal_dphy;
> > 
> > I assume dphy support is for a subsequent revision?
> 
> Yes, the situation is similar to the CSI2-RX driver.
> 
> > > +		/*
> > > +		 * We use the stream ID there, but it's wrong.
> > > +		 *
> > > +		 * A stream could very well send a data type that is
> > > +		 * not equal to its stream ID. We need to find a
> > > +		 * proper way to address it.
> > > +		 */
> > 
> > I don't quite get the above comment, from the code below it looks like
> > you are using the current fmt as a source to provide the correct DT.
> > Am I missing soemthing?
> 
> Yes, so far the datatype is inferred from the format set. Is there
> anything wrong with that?

No, nothing wrong with that behavior it just doesn't not match the comment
above, where it is says that the DT is set to the stream ID...

Regards,
Benoit
