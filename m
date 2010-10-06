Return-path: <mchehab@pedra>
Received: from devils.ext.ti.com ([198.47.26.153]:35613 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759073Ab0JFOWB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 10:22:01 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
Date: Wed, 6 Oct 2010 19:51:48 +0530
Subject: RE: [RFC/PATCH v2 0/6] OMAP3 ISP driver
Message-ID: <19F8576C6E063C45BE387C64729E739404AA21CDFB@dbde02.ent.ti.com>
References: <1286284734-12292-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <19F8576C6E063C45BE387C64729E739404AA21CCD4@dbde02.ent.ti.com>
 <201010061616.35863.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201010061616.35863.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Wednesday, October 06, 2010 7:47 PM
> To: Hiremath, Vaibhav
> Cc: linux-media@vger.kernel.org; sakari.ailus@maxwell.research.nokia.com
> Subject: Re: [RFC/PATCH v2 0/6] OMAP3 ISP driver
> 
> Hi Vaibhav,
> 
> On Wednesday 06 October 2010 11:56:23 Hiremath, Vaibhav wrote:
> > On Tuesday, October 05, 2010 6:49 PM Laurent Pinchart wrote:
> > >
> > > Hi everybody,
> > >
> > > Here's the second version of the OMAP3 ISP driver, rebased on top of
> the
> > > latest media controller and sub-device API patches.
> > >
> > > As with the previous version, the V4L/DVB patches come from the
> upstream
> > > staging/v2.6.37 branch and won't be needed anymore when the driver
> will
> > > be rebased on top of 2.6.36.
> > >
> > > Patch 6/6 (the driver itself) is too big for vger, even in compressed
> > > form. You can find it at
> > > http://git.linuxtv.org/pinchartl/media.git?h=refs/heads/media-0004-
> > > omap3isp (sorry for the inconvenience). I'll try splitting up the
> patch in
> > > the next version for easier review.
> 
> [snip]
> 
> > Hi Laurent,
> >
> > I have some specific comment on this patch series, especially from
> > re-usability point of view.
> >
> > I have made this comment earlier as well during Helsinki conference, I
> am
> > not quite sure whether you remember this or not.
> 
> Yes I do. I haven't had time to take that into account yet to, as most of
> my
> time was spent consolidating this patch series to get the driver ready for
> submission.
> 
> > Let me introduce some SoC's here,
> >
> > OMAP3530/OMAP3730/OMAP3430/OMAP3630 -
> > ------------------------------------
> > I am pretty sure that your patch addresses all the requirement and is
> being
> > tested for this SoC family. Infact I am also working on this along side
> to
> > validate it and add some feature support on top of other platforms, like
> > OMAP3EVM, Beagle, BeagleXM, etc..
> 
> That's right, that's the chip family I'm working with. The driver has been
> tested (to various degrees) on the 3430, 3530 and 3630. I'm not aware of
> anyone using it on the 3730 (but there could be silent users).
> 
> > So I do not have any specific comments here,
[Hiremath, Vaibhav] You can consider me into this. We are using AM/DM3730 which is exactly same as OMAP3630.

Thanks,
Vaibhav

> >
> > AM3517 -
> > --------
> > AM3517 is another SoC, inheriting most of the IP's/modules from OMAP3,
> but
> > in case of Capture module it only uses CCDC front end module of the ISP.
> > Another difference is the output data pins become 16-bit in this case,
> > since it doesn't have any support for bridge/lane-shifter.
> >
> > I would want to re-use CCDC sub-device driver here, have you thought of
> > this?
> 
> I've had a look at the AM3517 datasheet. The CCDC looks similar indeed
> (registers have identical addresses, that's a good start), but there's a
> major
> difference regarding memory management, as the AM3517 has no IOMMU. An
> alternative isp_video implementation would be needed. This isn't an easy
> task,
> but it's worth looking at how code could be reused.
> 
> > DM6446 (Davinci & Family)
> > -------------------------
> > Specifically I am will take DM6446 SoC here (which is near to OMAP),
> since
> > it has almost same building blocks inside ISP, except all serial (MIPI
> > CSI) interfaces.
> >
> > Also here I would want to re-use almost all the components like, CCDC,
> > Resizer, Previewer, etc... Also DM355 (OR 365 I don't remember
> correctly)
> > but one of them support 2 instance of resizer module.
> 
> Once again a bit difference is the lack of IOMMU. The rest looks pretty
> similar indeed.
> 
> > Here it might be easy to tweak the code in order to re-use but in case
> of
> > AM3517 I am not sure how do we want to handle this.
> 
> Do you think we should start with the AM3517 or the DM6446 ? While the
> DM6446
> ISP is closer to the OMAP3 ISP, it's also more complex, so more code will
> need
> to be verified and modified.
> 
> > The intent is not to block this patch series, but to give some food to
> our
> > brains and have healthy discussion here. We could add all this support
> on
> > top of it, I am ok with this.
> 
> That's good, because I wasn't going to hold the OMAP3 ISP driver until it
> can
> support all other TI chips :-)
> 
> > I am also reviewing the patch series and comments are following this
> > post...
> 
> Thanks.
> 
> --
> Regards,
> 
> Laurent Pinchart
