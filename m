Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:42075 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974Ab1GDOzz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2011 10:55:55 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>
CC: "'Sakari Ailus'" <sakari.ailus@iki.fi>,
	LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Date: Mon, 4 Jul 2011 20:25:34 +0530
Subject: RE: [ RFC PATCH 0/8] RFC for Media Controller capture driver for
 DM365
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024BCEF73A@dbde02.ent.ti.com>
References: <1309439597-15998-1-git-send-email-manjunath.hadli@ti.com>
 <20110630135736.GK12671@valkosipuli.localdomain>
 <B85A65D85D7EB246BE421B3FB0FBB593024BCEF739@dbde02.ent.ti.com>
 <201107041522.37437.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201107041522.37437.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Thank you Laurent.

On Mon, Jul 04, 2011 at 18:52:37, Laurent Pinchart wrote:
> Hi Manjunath,
> 
> On Monday 04 July 2011 07:58:06 Hadli, Manjunath wrote:
> > On Thu, Jun 30, 2011 at 19:27:36, Sakari Ailus wrote:
> 
> [snip]
> 
> > > I understand that not all the blocks are there. Are there any major 
> > > functional differences between those in Davinci and those in OMAP 3?
> > > Could the OMAP 3 ISP driver made support Davinci ISP as well?
> > 
> > Yes, there are a lot of major differences between OMAP3 and 
> > Dm365/Dm355, both in terms of features, there IP, and the software 
> > interface, including all the registers which are entirely different. 
> > The closest omap3 would come to is only to DM6446. I do not think 
> > OMAP3 driver can be made to support Dm355 and Dm365. It is good to 
> > keep the OMAP3 neat and clean to cater for OMAP4 and beyond, and keep 
> > the Davinci family separate. The names might look similar and hence 
> > confusing for you, but the names can as well be made the same as Dm365 
> > blocks like ISIF and IPIPE and IPIPEIF which are different.
> 
> The DM6446 ISP is very similar to the OMAP3 ISP, and thus quite different from the DM355/365 ISPs. Should the DM6446 be supported by the OMAP3 ISP driver, and the DM355/365 by this driver ?

DM6446 capture IP is in some respects similar to OMAP3 for some features, but there are a large number of differences also (MMU, VRFB, a lot of display interfaces etc). Having a single driver catering to  
Since DM6446 and OMAP3 is going to be unwieldy.
Also, DM6446 belongs to the Davinci family of chips, it should be clubbed with the other Davinci SoCs as it will simplify a lot of other things including directory subdirectory/file naming, organization of machine/platform code etc among other things. Other than Video a lot of other system registers and features which are common with the rest of Davinci SoCs which if treated together is a good thing, whereas OMAP3 can be modified and developed with those on the OMAP family (OMAP4 for ex).

> 
> > > There are number of possible improvements that still should be made 
> > > to the OMAP 3 ISP driver so this way both of the driver would easily 
> > > get them. To mention some:
> > > 
> > > - Multiple output pipeline
> > > - Switch to videobuf2
> > > - Switch to GENIRQ
> > 
> > Sure. There is definitely a design element convergence, and overtime I 
> > think some of these would get into the core v4l2 infrastructure.
> 
> --
> Regards,
> 
> Laurent Pinchart
> 

