Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37969 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267Ab1GDNWH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2011 09:22:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>
Subject: Re: [ RFC PATCH 0/8] RFC for Media Controller capture driver for DM365
Date: Mon, 4 Jul 2011 15:22:37 +0200
Cc: "'Sakari Ailus'" <sakari.ailus@iki.fi>,
	LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
References: <1309439597-15998-1-git-send-email-manjunath.hadli@ti.com> <20110630135736.GK12671@valkosipuli.localdomain> <B85A65D85D7EB246BE421B3FB0FBB593024BCEF739@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024BCEF739@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107041522.37437.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Manjunath,

On Monday 04 July 2011 07:58:06 Hadli, Manjunath wrote:
> On Thu, Jun 30, 2011 at 19:27:36, Sakari Ailus wrote:

[snip]

> > I understand that not all the blocks are there. Are there any major
> > functional differences between those in Davinci and those in OMAP 3?
> > Could the OMAP 3 ISP driver made support Davinci ISP as well?
> 
> Yes, there are a lot of major differences between OMAP3 and Dm365/Dm355,
> both in terms of features, there IP, and the software interface, including
> all the registers which are entirely different. The closest omap3 would
> come to is only to DM6446. I do not think OMAP3 driver can be made to
> support Dm355 and Dm365. It is good to keep the OMAP3 neat and clean to
> cater for OMAP4 and beyond, and keep the Davinci family separate. The
> names might look similar and hence confusing for you, but the names can as
> well be made the same as Dm365 blocks like ISIF and IPIPE and IPIPEIF
> which are different.

The DM6446 ISP is very similar to the OMAP3 ISP, and thus quite different from 
the DM355/365 ISPs. Should the DM6446 be supported by the OMAP3 ISP driver, 
and the DM355/365 by this driver ?

> > There are number of possible improvements that still should be made to
> > the OMAP 3 ISP driver so this way both of the driver would easily get
> > them. To mention some:
> > 
> > - Multiple output pipeline
> > - Switch to videobuf2
> > - Switch to GENIRQ
> 
> Sure. There is definitely a design element convergence, and overtime I
> think some of these would get into the core v4l2 infrastructure.

-- 
Regards,

Laurent Pinchart
