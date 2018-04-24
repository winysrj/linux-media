Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:37035 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751561AbeDXTgq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 15:36:46 -0400
Date: Tue, 24 Apr 2018 21:36:44 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: Re: [PATCH v2 08/12] media: ov5640: Adjust the clock based on the
 expected rate
Message-ID: <20180424193644.cjzlauohsokbsrux@flea>
References: <20180416123701.15901-1-maxime.ripard@bootlin.com>
 <20180416123701.15901-9-maxime.ripard@bootlin.com>
 <20180424072147.t5ix4zpiwwjx4rzv@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20180424072147.t5ix4zpiwwjx4rzv@paasikivi.fi.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tue, Apr 24, 2018 at 10:21:47AM +0300, Sakari Ailus wrote:
> >  /* download ov5640 settings to sensor through i2c */
> >  static int ov5640_load_regs(struct ov5640_dev *sensor,
> >  			    const struct ov5640_mode_info *mode)
> > @@ -1620,6 +1830,14 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
> >  	if (ret)
> >  		return ret;
> >  
> > +	if (sensor->ep.bus_type == V4L2_MBUS_CSI2)
> > +		ret = ov5640_set_mipi_pclk(sensor, mode->clock);
> 
> What is the value of the mode->clock expected to signify? It'd seem like
> that this changes from this patch to the next. Which one is correct?

It doesn't, this is the clock rate computed through the formula
described above (and that might be incorrect for MIPI-CSI, given
Samuel feedback) from the way the registers are initialized in the
arrays.

This shouldn't bring any change to the clock rate, but instead of
hardcoding it, we now have the infrastructure to calculate the factors
for any given rate.

The subsequent patch will remove that hardcoded clock rate and
generate it dynamically from the timings / format.

Does that make sense? Or maybe I should split this some other way?

> Please also add a comment or two documenting this; it'll be otherwise
> difficult to find out later on.

I'm not sure there's a point in documenting that intermediate step
that is just there for a single commit. Maybe I should expand the
commit log to make it clearer?

Maxime

-- 
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com
