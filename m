Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54938 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S967328AbdIZIAR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 04:00:17 -0400
Date: Tue, 26 Sep 2017 11:00:14 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Cyprian Wronka <cwronka@cadence.com>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, nm@ti.com
Subject: Re: [PATCH 2/2] v4l: cadence: Add Cadence MIPI-CSI2 TX driver
Message-ID: <20170926080014.7a3lbe23rvzpcmkq@valkosipuli.retiisi.org.uk>
References: <20170922114703.30511-1-maxime.ripard@free-electrons.com>
 <20170922114703.30511-3-maxime.ripard@free-electrons.com>
 <20170922123849.hcm76tlplnvd44mt@valkosipuli.retiisi.org.uk>
 <20170922153036.u7k3wmuldphkk6w3@flea.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170922153036.u7k3wmuldphkk6w3@flea.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

On Fri, Sep 22, 2017 at 05:30:36PM +0200, Maxime Ripard wrote:
> Hi Sakari,
> 
> I'll address the minor comments you had and that I stripped.
> 
> On Fri, Sep 22, 2017 at 12:38:49PM +0000, Sakari Ailus wrote:
> > > +	/*
> > > +	 * Create a static mapping between the CSI virtual channels
> > > +	 * and the input streams.
> > 
> > Which virtual channel is used here?
> 
> Like I was trying to explain in the cover letter, the virtual channel
> is not under that block's control. The input video interfaces have an
> additional signal that comes from the upstream device which sets the
> virtual channel.

Oh, I missed while reviewing the set.

Presumably either driver would be in control of that then (this one or the
upstream sub-device).

> 
> It's transparent to the CSI2-TX block, even though it's
> there. Depending on the implementation, it can be either fixed or can
> change, it's up to the other block's designer. The only restriction is
> that it cannot change while a streaming is occuring.
> 
> > > +
> > > +		/*
> > > +		 * If no-one set a format, we consider this pad
> > > +		 * disabled and just skip it.
> > > +		 */
> > > +		if (!fmt)
> > 
> > The pad should have a valid format even if the user didn't configure
> > it.
> 
> Which format should be by default then?

Any valid format for the device should be good.

> 
> > Instead you should use the link state to determine whether the link is
> > active or not.
> 
> Ok, will do.
> 
> > > +			continue;
> > > +
> > > +		/*
> > > +		 * We use the stream ID there, but it's wrong.
> > > +		 *
> > > +		 * A stream could very well send a data type that is
> > > +		 * not equal to its stream ID. We need to find a
> > > +		 * proper way to address it.
> > 
> > Stream IDs will presumably be used in V4L2 for a different purpose. Does
> > the hardware documentation call them such?
> 
> Input video interfaces are called streams, yes, and then they are
> numbered. If it's just confusing because of a collision with one of
> v4l2's nomenclature, I'm totally fine to change it to some other name.

If the hardware documentation uses it then let's stick with it.

> 
> > > +		 */
> > > +		writel(CSI2TX_DT_CFG_DT(fmt->dt),
> > > +		       csi2tx->base + CSI2TX_DT_CFG_REG(stream));
> > > +
> > > +		writel(CSI2TX_DT_FORMAT_BYTES_PER_LINE(mfmt->width * fmt->bpp) |
> > > +		       CSI2TX_DT_FORMAT_MAX_LINE_NUM(mfmt->height + 1),
> > > +		       csi2tx->base + CSI2TX_DT_FORMAT_REG(stream));
> > > +
> > > +		/*
> > > +		 * TODO: This needs to be calculated based on the
> > > +		 * clock rate.
> > 
> > Clock rate of what? Input?
> 
> Of the CSI2 link, so output. I guess I should make that clearer.

Please.

> 
> > 
> > > +		 */
> > > +		writel(CSI2TX_STREAM_IF_CFG_FILL_LEVEL(4),
> > > +		       csi2tx->base + CSI2TX_STREAM_IF_CFG_REG(stream));
> > > +	}
> > > +
> > > +	/* Disable the configuration mode */
> > > +	writel(0, csi2tx->base + CSI2TX_CONFIG_REG);
> > 
> > Shouldn't you start streaming on the downstream sub-device as well?
> 
> I appreciate it's a pretty weak argument, but the current setup we
> have is in the FPGA is:
> 
> capture <- CSI2-RX <- CSI2-TX <- pattern generator
> 
> So far, the CSI2-RX block is calling its remote sub-device, which is
> CSI2-TX. If CSI2-RX is calling its remote sub-device (CSI2-RX), we
> just found ourselves in an endless loop.
> 
> I guess it should be easier, and fixable, when we'll have an actual
> device without such a loopback.

What's the intended use case of the device, capture or output?

How do you currently start the pipeline?

We have a few corner cases in V4L2 for such devices in graph parsing and
stream control. The parsing of the device's fwnode graph endpoints are what
the device can do, but it doesn't know where the parsing should continue
and which part of the graph is already parsed.

That will be addressed but right now a driver just needs to know.

> 
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int csi2tx_stop(struct csi2tx_priv *csi2tx)
> > > +{
> > > +	/*
> > > +	 * Let the last user turn off the lights
> > > +	 */
> > > +	if (!atomic_dec_and_test(&csi2tx->count))
> > > +		return 0;
> > > +
> > > +	/* FIXME: Disable the IP here */
> > 
> > Shouldn't this be addressed?
> 
> Yes, but it's still unclear how at the moment. It will of course
> eventually be implemented.

Ok.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
