Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53738 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751606AbeERWNy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 18:13:54 -0400
Date: Sat, 19 May 2018 01:13:47 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Rui Miguel Silva <rui.silva@linaro.org>
Cc: mchehab@kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>
Subject: Re: [PATCH v4 06/12] media: dt-bindings: add bindings for i.MX7
 media driver
Message-ID: <20180518221346.fy4264hehvjjcd4y@kekkonen.localdomain>
References: <20180517125033.18050-1-rui.silva@linaro.org>
 <20180517125033.18050-7-rui.silva@linaro.org>
 <20180518065824.csio2fgwsxo2g2ow@valkosipuli.retiisi.org.uk>
 <m3tvr5xt9t.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3tvr5xt9t.fsf@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 18, 2018 at 09:27:58AM +0100, Rui Miguel Silva wrote:
> > > +endpoint node
> > > +-------------
> > > +
> > > +- data-lanes    : (required) an array specifying active physical
> > > MIPI-CSI2
> > > +		    data input lanes and their mapping to logical lanes; the
> > > +		    array's content is unused, only its length is meaningful;

Btw. do note that you may get a warning due to this from the CSI-2 bus
property parsing code if the lane numbers are wrong.

> > > +
> > > +- fsl,csis-hs-settle : (optional) differential receiver (HS-RX)
> > > settle time;
> > 
> > Could you calculate this, as other drivers do? It probably changes
> > depending on the device runtime configuration.
> 
> The only reference to possible values to this parameter is given by
> table in [0], can you point me out the formula for imx7 in the
> documentation?

I don't know imx7 but the other CSI-2 drivers need no such system specific
configuration.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
