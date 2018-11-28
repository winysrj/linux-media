Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:53008 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727552AbeK1UGN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Nov 2018 15:06:13 -0500
Date: Wed, 28 Nov 2018 11:05:08 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Marco Felsch <m.felsch@pengutronix.de>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        enrico.scholz@sigma-chemnitz.de, devicetree@vger.kernel.org,
        akinobu.mita@gmail.com, linux-media@vger.kernel.org,
        graphics@pengutronix.de,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [PATCH v3 6/6] media: mt9m111: allow to setup pixclk polarity
Message-ID: <20181128090507.ciqu6u5dnuzfriyu@kekkonen.localdomain>
References: <20181127100253.30845-1-m.felsch@pengutronix.de>
 <20181127100253.30845-7-m.felsch@pengutronix.de>
 <20181127211512.2zqvrqa37vdsk35b@kekkonen.localdomain>
 <20181128082901.qsrmi2vrjcyrwypg@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128082901.qsrmi2vrjcyrwypg@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 28, 2018 at 09:29:01AM +0100, Marco Felsch wrote:
> On 18-11-27 23:15, Sakari Ailus wrote:
> > On Tue, Nov 27, 2018 at 11:02:53AM +0100, Marco Felsch wrote:
> > > From: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
> > > 
> > > The chip can be configured to output data transitions on the
> > > rising or falling edge of PIXCLK (Datasheet R58:1[9]), default is on the
> > > falling edge.
> > > 
> > > Parsing the fw-node is made in a subfunction to bundle all (future)
> > > dt-parsing / fw-parsing stuff.
> > > 
> > > Signed-off-by: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
> > > (m.grzeschik@pengutronix.de: Fix inverting clock. INV_PIX_CLOCK bit is set
> > > per default. Set bit to 0 (enable mask bit without value) to enable
> > > falling edge sampling.)
> > > Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> > > (m.felsch@pengutronix.de: use fwnode helpers)
> > > (m.felsch@pengutronix.de: mv fw parsing into own function)
> > > (m.felsch@pengutronix.de: adapt commit msg)
> > > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> > 
> > This one as well:
> 
> Sorry for that, I forget to adapt the Kconfig to often. Thanks for your
> fix.

No worries. I hope we'll have automated compile testing in not too distant
future...

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
