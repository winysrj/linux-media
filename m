Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:42407 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab2AQT14 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 14:27:56 -0500
Date: Tue, 17 Jan 2012 21:27:51 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH 13/23] omap3isp: Add lane configuration to platform data
Message-ID: <20120117192751.GB13236@valkosipuli.localdomain>
References: <4F0DFE92.80102@iki.fi>
 <1326317220-15339-13-git-send-email-sakari.ailus@iki.fi>
 <201201161508.26790.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201161508.26790.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the review!

On Mon, Jan 16, 2012 at 03:08:26PM +0100, Laurent Pinchart wrote:
> On Wednesday 11 January 2012 22:26:50 Sakari Ailus wrote:
> > Add lane configuration (order of clock and data lane) to platform data on
> > both CCP2 and CSI-2.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  drivers/media/video/omap3isp/ispcsiphy.h |   15 ++-------------
> >  include/media/omap3isp.h                 |   25 +++++++++++++++++++++++++
> >  2 files changed, 27 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/media/video/omap3isp/ispcsiphy.h
> > b/drivers/media/video/omap3isp/ispcsiphy.h index 9596dc6..e93a661 100644
> > --- a/drivers/media/video/omap3isp/ispcsiphy.h
> > +++ b/drivers/media/video/omap3isp/ispcsiphy.h
> > @@ -27,22 +27,11 @@
> >  #ifndef OMAP3_ISP_CSI_PHY_H
> >  #define OMAP3_ISP_CSI_PHY_H
> > 
> > +#include <media/omap3isp.h>
> > +
> >  struct isp_csi2_device;
> >  struct regulator;
> > 
> > -struct csiphy_lane {
> > -	u8 pos;
> > -	u8 pol;
> > -};
> > -
> > -#define ISP_CSIPHY2_NUM_DATA_LANES	2
> > -#define ISP_CSIPHY1_NUM_DATA_LANES	1
> > -
> > -struct isp_csiphy_lanes_cfg {
> > -	struct csiphy_lane data[ISP_CSIPHY2_NUM_DATA_LANES];
> > -	struct csiphy_lane clk;
> > -};
> > -
> >  struct isp_csiphy_dphy_cfg {
> >  	u8 ths_term;
> >  	u8 ths_settle;
> > diff --git a/include/media/omap3isp.h b/include/media/omap3isp.h
> > index 9c1a001..bc14099 100644
> > --- a/include/media/omap3isp.h
> > +++ b/include/media/omap3isp.h
> > @@ -91,6 +91,29 @@ enum {
> >  };
> > 
> >  /**
> > + * struct isp_csiphy_lane: CCP2/CSI2 lane position and polarity
> > + * @pos: position of the lane
> > + * @pol: polarity of the lane
> > + */
> > +struct isp_csiphy_lane {
> > +	u8 pos;
> > +	u8 pol;
> > +};
> > +
> > +#define ISP_CSIPHY2_NUM_DATA_LANES	2
> > +#define ISP_CSIPHY1_NUM_DATA_LANES	1
> 
> Any reason not to put CSIPHY1 first ? :-)

Yes. I believe wrote it that way. ;-)

I'll change it.

> With that modification,
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks!

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
