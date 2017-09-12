Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:45866 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750742AbdILTNl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 15:13:41 -0400
Date: Tue, 12 Sep 2017 14:13:12 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Cyprian Wronka <cwronka@cadence.com>,
        Neil Webb <neilw@cadence.com>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v3 2/2] v4l: cadence: Add Cadence MIPI-CSI2 RX driver
Message-ID: <20170912191312.GB27713@ti.com>
References: <20170904130335.23280-1-maxime.ripard@free-electrons.com>
 <20170904130335.23280-3-maxime.ripard@free-electrons.com>
 <20170912182339.GA27713@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20170912182339.GA27713@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Benoit Parrot <bparrot@ti.com> wrote on Tue [2017-Sep-12 13:23:39 -0500]:

<snip>

> > +static int csi2rx_start(struct csi2rx_priv *csi2rx)
> > +{
> > +	unsigned int i;
> > +	u32 reg;
> > +	int ret;
> > +
> > +	/*
> > +	 * We're not the first users, there's no need to enable the
> > +	 * whole controller.
> > +	 */
> > +	if (atomic_inc_return(&csi2rx->count) > 1)
> > +		return 0;
> > +
> > +	clk_prepare_enable(csi2rx->p_clk);
> > +
> > +	printk("%s %d\n", __func__, __LINE__);
> 
> Some left over debug...
> 
> > +
> > +	csi2rx_reset(csi2rx);
> > +
> > +	reg = csi2rx->num_lanes << 8;
> > +	for (i = 0; i < csi2rx->num_lanes; i++)
> > +		reg |= CSI2RX_STATIC_CFG_DLANE_MAP(i, csi2rx->lanes[i]);
> > +
> > +	writel(reg, csi2rx->base + CSI2RX_STATIC_CFG_REG);
> > +
> > +	ret = v4l2_subdev_call(csi2rx->source_subdev, video, s_stream, true);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/*
> > +	 * Create a static mapping between the CSI virtual channels
> > +	 * and the output stream.
> > +	 *
> > +	 * This should be enhanced, but v4l2 lacks the support for
> > +	 * changing that mapping dynamically.
> > +	 *
> > +	 * We also cannot enable and disable independant streams here,
> > +	 * hence the reference counting.
> > +	 */
> > +	for (i = 0; i < csi2rx->max_streams; i++) {
> > +		clk_prepare_enable(csi2rx->pixel_clk[i]);
> > +
> > +		writel(CSI2RX_STREAM_CFG_FIFO_MODE_LARGE_BUF,
> > +		       csi2rx->base + CSI2RX_STREAM_CFG_REG(i));
> > +
> > +		writel(CSI2RX_STREAM_DATA_CFG_EN_VC_SELECT |
> > +		       CSI2RX_STREAM_DATA_CFG_VC_SELECT(i),
> > +		       csi2rx->base + CSI2RX_STREAM_DATA_CFG_REG(i));

I see here that we are setting the data_type to 0 (as we are not setting
it) so effectively capturing everything on the channel(s).
Will we be adding a method to select/filter specific data type?
For instance if we only want to grab YUV data in one stream and only
RGB24 in another. Of course that would not be possible here as is...

Benoit

> > +
> > +		writel(CSI2RX_STREAM_CTRL_START,
> > +		       csi2rx->base + CSI2RX_STREAM_CTRL_REG(i));
> > +	}
> > +
> > +	clk_prepare_enable(csi2rx->sys_clk);
> > +
> > +	clk_disable_unprepare(csi2rx->p_clk);
> > +
> > +	return 0;
> > +}

<snip>
