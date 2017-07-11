Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47430 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932486AbdGKQMu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 12:12:50 -0400
Date: Tue, 11 Jul 2017 19:12:45 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: v4l2-fwnode: status, plans for merge, any branch to merge
 against?
Message-ID: <20170711161245.5ftg6jgomudzlosz@valkosipuli.retiisi.org.uk>
References: <20170304130318.GU3220@valkosipuli.retiisi.org.uk>
 <20170306072323.GA23509@amd>
 <20170310225418.GJ3220@valkosipuli.retiisi.org.uk>
 <20170613122240.GA2803@amd>
 <20170613124748.GD12407@valkosipuli.retiisi.org.uk>
 <20170613210900.GA31456@amd>
 <20170614110634.GP12407@valkosipuli.retiisi.org.uk>
 <20170704150819.GA10703@localhost>
 <20170705093248.hndchnamibhqczfr@valkosipuli.retiisi.org.uk>
 <20170706103851.GA9555@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170706103851.GA9555@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Thu, Jul 06, 2017 at 12:38:51PM +0200, Pavel Machek wrote:
> Hi!
> 
> > > > > > I expect to have most of them in during the next merge window.
> > > > > 
> > > > > So git://linuxtv.org/media_tree.git branch master is the right one to
> > > > > work one?
> > > > 
> > > > I also pushed the rebased ccp2 branch there:
> > > > 
> > > > <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=ccp2>
> > > > 
> > > > It's now right on the top of media-tree master.
> > > 
> > > Is ccp2 branch expected to go into 4.13, too?
> > 
> > Hi Pavel,
> > 
> > What I've done is just rebased the ccp2 branch. In other words, the patches
> > in that branch are no more ready than they were.
> 
> I thought they were ready even back then :-).
> 
> > To get these merged we should ideally
> > 
> > 1) Make sure there will be no regressions,
> 
> Well, all I have running recent kernels is N900. If ccp branch works
> for you on N9, that's probably as much testing as we can get.
> 
> > 2) clean things up in the omap3isp; which resources are needed and when
> > (e.g. regulators, PHY configuration) isn't clear at the moment and
> > 
> > 2) have one driver using the implementation.
> > 
> > At least 1) is needed. I think a number of framework patches could be
> > mergeable before 2) and 3) are done. I can prepare a set later this week.
> > But even that'd be likely for 4.14, not 4.13.
> 
> Yep, it is too late for v4.13 now. But getting stuff ready for v4.14
> would be good.
> 
> I started looking through the patches; I believe they are safe, but it
> is probably better to review the series you've just mailed.
> 
> The driver using the implementation -- yes, I have it all working on
> n900 (incuding userland, I can actually take photos.) I can post the
> series, or better link to kernel.org.
> 
> Right now, my goal would be to get sensor working on N900 with
> mainline (without flash and focus).
> 
> I'd very much like any comment on patch attached below.
> 
> Age   Commit message (Expand)	Author	Files	Lines
> 2017-06-16   omap3isp: Destroy CSI-2 phy mutexes in error and module
> 2017-06-16	omap3isp: Skip CSI-2 receiver initialisation in CCP2
> 2017-06-16	omap3isp: Correctly put the last iterated endpoint
> 2017-06-16	omap3isp: Always initialise isp and mutex for csiphy1
> 2017-06-16	omap3isp: Return -EPROBE_DEFER if the required
> 2017-06-16 omap3isp: Correctly set IO_OUT_SEL and VP_CLK_POL for CCP2
> 2017-06-16    omap3isp: Make external sub-device bus configuration a
> 2017-06-15    omap3isp: Parse CSI1 configuration from the device tree
> 2017-06-15    omap3isp: Check for valid port in endpoints	Sakari
> 2017-06-15	omap3isp: Ignore endpoints with invalid configuration
> 
> # Nothing changes for bus_type == V4L2_MBUS_CSI2. FIXME: Is bus_type
>   set correctly?
> 
> 2017-06-15	smiapp: add CCP2 support	Pavel Machek	1
> 
> # bus_type will be guess, so no code changes on existing system:
> 
> 2017-06-15	v4l: Add support for CSI-1 and CCP2 busses	Sakari
> 
> # Reads unused value -> can't break anything:
> 
> 2017-06-13	v4l: fwnode: Obtain data bus type from FW	Sakari
> 
> # No code changes -> totally safe:
> 
> 2017-06-13	v4l: fwnode: Call CSI2 bus csi2, not csi	Sakari
> 2017-06-13	dt: bindings: Add strobe property for CCP2	Sakari
> 2017-06-13	dt: bindings: Explicitly specify bus type
> 
> Best regards,
> 								Pavel
> 
> commit 1220492dd4c1872c8036caa573680f95aabc69bc
> Author: Pavel <pavel@ucw.cz>
> Date:   Tue Feb 28 12:02:26 2017 +0100
> 
>     omap3isp: add CSI1 support
>     
>     Use proper code path for csi1/ccp2 support.
>     
>     Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
> index 24a9fc5..47210b1 100644
> --- a/drivers/media/platform/omap3isp/ispccp2.c
> +++ b/drivers/media/platform/omap3isp/ispccp2.c
> @@ -1149,6 +1149,7 @@ int omap3isp_ccp2_init(struct isp_device *isp)
>  				"Could not get regulator vdds_csib\n");
>  			ccp2->vdds_csib = NULL;
>  		}
> +		ccp2->phy = &isp->isp_csiphy2;
>  	} else if (isp->revision == ISP_REVISION_15_0) {
>  		ccp2->phy = &isp->isp_csiphy1;
>  	}
> diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c b/drivers/media/platform/omap3isp/ispcsiphy.c
> index 50c0f64..862fdd3 100644
> --- a/drivers/media/platform/omap3isp/ispcsiphy.c
> +++ b/drivers/media/platform/omap3isp/ispcsiphy.c
> @@ -197,9 +197,10 @@ static int omap3isp_csiphy_config(struct isp_csiphy *phy)
>  	}
>  
>  	if (buscfg->interface == ISP_INTERFACE_CCP2B_PHY1
> -	    || buscfg->interface == ISP_INTERFACE_CCP2B_PHY2)
> +	    || buscfg->interface == ISP_INTERFACE_CCP2B_PHY2) {
>  		lanes = &buscfg->bus.ccp2.lanecfg;
> -	else
> +		phy->num_data_lanes = 1;
> +	} else
>  		lanes = &buscfg->bus.csi2.lanecfg;
>  
>  	/* Clock and data lanes verification */
> @@ -302,13 +303,16 @@ int omap3isp_csiphy_acquire(struct isp_csiphy *phy)
>  	if (rval < 0)
>  		goto done;
>  
> -	rval = csiphy_set_power(phy, ISPCSI2_PHY_CFG_PWR_CMD_ON);
> -	if (rval) {
> -		regulator_disable(phy->vdd);
> -		goto done;
> +	if (phy->isp->revision == ISP_REVISION_15_0) {

Shouldn't you make the related changes to omap3isp_csiphy_release() as
well?

Other than that the patch looks good to me.

> +		rval = csiphy_set_power(phy, ISPCSI2_PHY_CFG_PWR_CMD_ON);
> +		if (rval) {
> +			regulator_disable(phy->vdd);
> +			goto done;
> +		}
> +
> +		csiphy_power_autoswitch_enable(phy, true);
>  	}
>  
> -	csiphy_power_autoswitch_enable(phy, true);
>  	phy->phy_in_use = 1;
>  
>  done:
> 

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
