Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:8258 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730599AbeKVIhX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 03:37:23 -0500
Date: Thu, 22 Nov 2018 00:01:03 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Subject: Re: [PATCH 3/5] media: sunxi: Add A10 CSI driver
Message-ID: <20181121220102.6nn7uwu2c67zs6pz@mara.localdomain>
References: <cover.71b0f9855c251f9dc389ee77ee6f0e1fad91fb0b.1542097288.git-series.maxime.ripard@bootlin.com>
 <c53e1cdc3b139382b00ee06bf3980d3fd1742ec0.1542097288.git-series.maxime.ripard@bootlin.com>
 <f34c79f5-66d6-2c2f-5616-020ad2b96400@xs4all.nl>
 <20181115205106.thbkojnzdwmaeui3@flea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115205106.thbkojnzdwmaeui3@flea>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 15, 2018 at 09:51:06PM +0100, Maxime Ripard wrote:
> Hi Hans,
> 
> Thanks for your review! I'll address the other comments you made.
> 
> On Tue, Nov 13, 2018 at 01:24:47PM +0100, Hans Verkuil wrote:
> > > +static int csi_probe(struct platform_device *pdev)
> > > +{
> > > +	struct sun4i_csi *csi;
> > > +	struct resource *res;
> > > +	int ret;
> > > +	int irq;
> > > +
> > > +	csi = devm_kzalloc(&pdev->dev, sizeof(*csi), GFP_KERNEL);
> > 
> > devm_kzalloc is not recommended: all devm_ memory is freed when the driver
> > is unbound, but a filehandle might still have a reference open.
> 
> How would a !devm variant with a kfree in the remove help? We would
> still fall in the same case, right?

Not quite. For video nodes this is handled: the release callback gets called
once there are no file handles open to the device. That may well be much
later than the device has been unbound from the driver.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
