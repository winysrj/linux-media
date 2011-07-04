Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:46109 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584Ab1GDF6l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2011 01:58:41 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'Sakari Ailus'" <sakari.ailus@iki.fi>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>
Date: Mon, 4 Jul 2011 11:28:06 +0530
Subject: RE: [ RFC PATCH 0/8] RFC for Media Controller capture driver for
 DM365
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024BCEF739@dbde02.ent.ti.com>
References: <1309439597-15998-1-git-send-email-manjunath.hadli@ti.com>
 <20110630135736.GK12671@valkosipuli.localdomain>
In-Reply-To: <20110630135736.GK12671@valkosipuli.localdomain>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Sakari,
 Thank you for the comments. My responses inlined.

-Manjunath

On Thu, Jun 30, 2011 at 19:27:36, Sakari Ailus wrote:
> Hi Manjunath,
> 
> Thanks for the patches.
> 
> On Thu, Jun 30, 2011 at 06:43:09PM +0530, Manjunath Hadli wrote:
> > Thease are the RFC patches for the DM365 video capture, of which the 
> > current set includes only CCDC and the VPFE framework. Once the 
> > present set is reviewed, I will send out the other parts like H3A, 
> > sensor additions etc.
> > 
> > Introduction
> > ------------
> > This is the proposal of the initial version of design and 
> > implementation  of the Davinci family (dm644x,dm355,dm365)VPFE (Video 
> > Port Front End) drivers using Media Controloler , the initial version 
> > which supports the following:
> > 1) dm365 vpfe
> > 2) ccdc,previewer,resizer,h3a,af blocks
> > 3) supports both continuous and single-shot modes
> > 4) supports user pointer exchange and memory mapped modes for buffer 
> > allocation
> > 
> > This driver bases its design on Laurent Pinchart's Media Controller 
> > Design whose patches for Media Controller and subdev enhancements form the base.
> > The driver also takes copious elements taken from Laurent Pinchart and 
> > others' OMAP ISP driver based on Media Controller. So thank you all 
> > the people who are responsible for the Media Controller and the OMAP ISP driver.
> 
> This may be a stupid question, but how much changes are there between this driver and the OMAP 3 ISP driver?
The elements which pertain to how to write to media controller driver for a capture device have been imbibed from the OMAP3 but as such the code is very different. For example the v4l2 video routines as an almost separate library is a good element we took as a design, but the rest of it is entirely different.
> 
> I understand that not all the blocks are there. Are there any major functional differences between those in Davinci and those in OMAP 3? Could the OMAP 3 ISP driver made support Davinci ISP as well?
Yes, there are a lot of major differences between OMAP3 and Dm365/Dm355, both in terms of features, there IP, and the software interface, including all the registers which are entirely different. The closest omap3 would come to is only to DM6446. 
 I do not think OMAP3 driver can be made to support Dm355 and Dm365. It is good to keep the OMAP3 neat and clean to cater for OMAP4 and beyond, and keep the Davinci family separate. The names might look similar and hence confusing for you, but the names can as well be made the same as Dm365 blocks like ISIF and IPIPE and IPIPEIF which are different.

> 
> There are number of possible improvements that still should be made to the OMAP 3 ISP driver so this way both of the driver would easily get them. To mention some:
> 
> - Multiple output pipeline
> - Switch to videobuf2
> - Switch to GENIRQ
Sure. There is definitely a design element convergence, and overtime I think some of these would get into the core v4l2 infrastructure.
> 
> Cc Laurent.
> 
> Regards,
> 
> --
> Sakari Ailus
> sakari.ailus@iki.fi
> 

