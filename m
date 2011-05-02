Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:21684 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab1EBLJ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 May 2011 07:09:57 -0400
From: <kalle.jokiniemi@nokia.com>
To: <laurent.pinchart@ideasonboard.com>
CC: <tony@atomide.com>, <mchebab@infradead.org>,
	<linux-omap@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: RE: [PATCH 1/2] OMAP3: ISP: Add regulator control for omap34xx
Date: Mon, 2 May 2011 11:09:39 +0000
Message-ID: <9D0D31AA57AAF5499AFDC63D6472631B09D008@008-AM1MPN1-036.mgdnok.nokia.com>
References: <1304061120-6383-1-git-send-email-kalle.jokiniemi@nokia.com>
 <1304061120-6383-2-git-send-email-kalle.jokiniemi@nokia.com>
 <201104291148.57770.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201104291148.57770.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

 > -----Original Message-----
 > From: ext Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
 > Sent: 29. huhtikuuta 2011 12:49
 > To: Jokiniemi Kalle (Nokia-SD/Tampere)
 > Cc: tony@atomide.com; mchebab@infradead.org; linux-
 > omap@vger.kernel.org; linux-media@vger.kernel.org
 > Subject: Re: [PATCH 1/2] OMAP3: ISP: Add regulator control for omap34xx
 > 
 > Hi Kalle,
 > 
 > On Friday 29 April 2011 09:11:59 Kalle Jokiniemi wrote:
 > > The current omap3isp driver is missing regulator handling
 > > for CSIb complex in omap34xx based devices. This patch
 > > adds a mechanism for this to the omap3isp driver.
 > >
 > > Signed-off-by: Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
 > 
 > Thanks for the patch.

Sent an updated one, comments on what was done below.

 > 
 > The CSIb pins are multiplexed with the parallel interface cam_d[6:9] signals,
 > so the driver might need to handle the vdds_csib regulator for the parallel
 > interface as well. We can leave that out now though, as I'm not sure we'll
 > ever see a platform that will require that.
 > 
 > > ---
 > >  drivers/media/video/omap3isp/ispccp2.c |   24
 > +++++++++++++++++++++++-
 > >  drivers/media/video/omap3isp/ispccp2.h |    1 +
 > >  2 files changed, 24 insertions(+), 1 deletions(-)
 > >
 > > diff --git a/drivers/media/video/omap3isp/ispccp2.c
 > > b/drivers/media/video/omap3isp/ispccp2.c index 0e16cab..3b17b0d 100644
 > > --- a/drivers/media/video/omap3isp/ispccp2.c
 > > +++ b/drivers/media/video/omap3isp/ispccp2.c
 > > @@ -30,6 +30,7 @@
 > >  #include <linux/module.h>
 > >  #include <linux/mutex.h>
 > >  #include <linux/uaccess.h>
 > > +#include <linux/regulator/consumer.h>
 > >
 > >  #include "isp.h"
 > >  #include "ispreg.h"
 > > @@ -163,6 +164,9 @@ static void ccp2_if_enable(struct isp_ccp2_device
 > > *ccp2, u8 enable) struct isp_pipeline *pipe =
 > > to_isp_pipeline(&ccp2->subdev.entity); int i;
 > >
 > > +	if (enable && ccp2->vdds_csib)
 > > +		regulator_enable(ccp2->vdds_csib);
 > > +
 > >  	/* Enable/Disable all the LCx channels */
 > >  	for (i = 0; i < CCP2_LCx_CHANS_NUM; i++)
 > >  		isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_CCP2,
 > ISPCCP2_LCx_CTRL(i),
 > > @@ -186,6 +190,8 @@ static void ccp2_if_enable(struct isp_ccp2_device
 > > *ccp2, u8 enable) ISPCCP2_LC01_IRQENABLE,
 > >  				    ISPCCP2_LC01_IRQSTATUS_LC0_FS_IRQ);
 > >  	}
 > 
 > If you resubmit the patch to address the comments below, please add a blank
 > line here.

Done.


 > 
 > > +	if (!enable && ccp2->vdds_csib)
 > > +		regulator_disable(ccp2->vdds_csib);
 > >  }
 > >
 > >  /*
 > > @@ -1137,6 +1143,10 @@ error:
 > >   */
 > >  void omap3isp_ccp2_cleanup(struct isp_device *isp)
 > >  {
 > > +	struct isp_ccp2_device *ccp2 = &isp->isp_ccp2;
 > > +
 > > +	if (isp->revision == ISP_REVISION_2_0)
 > > +		regulator_put(ccp2->vdds_csib);
 > 
 > What about testing ccp2->vdds_csib != NULL here like you do above ? Not all
 > ES2.0 platforms will use a regulator, so you can end up calling
 > regulator_put(NULL). regulator_put() will return immediately, but the API
 > doesn't allow it explictly either.
 > 
 > If regulator_put(NULL) is deemed to be safe, I would remove the revision
 > check
 > here. If it isn't, I would replace it with a ccp2->vdds_csib != NULL check.

Regulator_put checks for NULL, so it's safe to call always.


 > 
 > >  }
 > >
 > >  /*
 > > @@ -1155,10 +1165,22 @@ int omap3isp_ccp2_init(struct isp_device *isp)
 > >  	 * the CSI2c or CSI2a receivers. The PHY then needs to be explicitly
 > >  	 * configured.
 > >  	 *
 > > +	 * On the OMAP34xx the CSI1/CCB is operated in the CSIb IO complex,
 > 
 > CSI1/CCB ? Do you mean CCP ?
 > 
 > The OMAP34xx has no CCP2 support anyway, so I would s,CSI1/CCB,CSI1
 > receiver,.

Done.

 > 
 > > +	 * which is powered by vdds_csib power rail. Hence the request for
 > > +	 * the regulator.
 > > +	 *
 > >  	 * TODO: Don't hardcode the usage of PHY1 (shared with CSI2c).
 > >  	 */
 > > -	if (isp->revision == ISP_REVISION_15_0)
 > > +	if (isp->revision == ISP_REVISION_15_0) {
 > >  		ccp2->phy = &isp->isp_csiphy1;
 > > +	} else if (isp->revision == ISP_REVISION_2_0) {
 > > +		ccp2->vdds_csib = regulator_get(isp->dev, "vdds_csib");
 > > +		if (IS_ERR(ccp2->vdds_csib)) {
 > > +			dev_dbg(isp->dev,
 > > +				"Could not get regulator vdds_csib\n");
 > > +			ccp2->vdds_csib = NULL;
 > > +		}
 > > +	}
 > 
 > If you resubmit your patch to address the above comments, could you please
 > reorder the code (and the comment) here and put the ES2.0 check before the
 > 15.0 ?

Done for both the code and comments.

- Kalle

 > 
 > >  	ret = ccp2_init_entities(ccp2);
 > >  	if (ret < 0)
 > > diff --git a/drivers/media/video/omap3isp/ispccp2.h
 > > b/drivers/media/video/omap3isp/ispccp2.h index 5505a86..6674e9d 100644
 > > --- a/drivers/media/video/omap3isp/ispccp2.h
 > > +++ b/drivers/media/video/omap3isp/ispccp2.h
 > > @@ -81,6 +81,7 @@ struct isp_ccp2_device {
 > >  	struct isp_interface_mem_config mem_cfg;
 > >  	struct isp_video video_in;
 > >  	struct isp_csiphy *phy;
 > > +	struct regulator *vdds_csib;
 > >  	unsigned int error;
 > >  	enum isp_pipeline_stream_state state;
 > >  	wait_queue_head_t wait;
 > 
 > --
 > Regards,
 > 
 > Laurent Pinchart
