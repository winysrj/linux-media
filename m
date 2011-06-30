Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:45108 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab1F3N5l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2011 09:57:41 -0400
Date: Thu, 30 Jun 2011 16:57:36 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	laurent.pinchart@ideasonboard.com
Subject: Re: [ RFC PATCH 0/8] RFC for Media Controller capture driver for
 DM365
Message-ID: <20110630135736.GK12671@valkosipuli.localdomain>
References: <1309439597-15998-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309439597-15998-1-git-send-email-manjunath.hadli@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Manjunath,

Thanks for the patches.

On Thu, Jun 30, 2011 at 06:43:09PM +0530, Manjunath Hadli wrote:
> Thease are the RFC patches for the DM365 video capture, of which 
> the current set includes only CCDC and the VPFE framework. Once
> the present set is reviewed, I will send out the other parts
> like H3A, sensor additions etc.
> 
> Introduction
> ------------
> This is the proposal of the initial version of design and implementation  of
> the Davinci family (dm644x,dm355,dm365)VPFE (Video Port Front End) drivers
> using Media Controloler , the initial version which supports
> the following:
> 1) dm365 vpfe
> 2) ccdc,previewer,resizer,h3a,af blocks
> 3) supports both continuous and single-shot modes
> 4) supports user pointer exchange and memory mapped modes for buffer allocation
> 
> This driver bases its design on Laurent Pinchart's Media Controller Design
> whose patches for Media Controller and subdev enhancements form the base.
> The driver also takes copious elements taken from Laurent Pinchart and
> others' OMAP ISP driver based on Media Controller. So thank you all the
> people who are responsible for the Media Controller and the OMAP ISP driver.

This may be a stupid question, but how much changes are there between this
driver and the OMAP 3 ISP driver?

I understand that not all the blocks are there. Are there any major
functional differences between those in Davinci and those in OMAP 3? Could
the OMAP 3 ISP driver made support Davinci ISP as well?

There are number of possible improvements that still should be made to the
OMAP 3 ISP driver so this way both of the driver would easily get them. To
mention some:

- Multiple output pipeline
- Switch to videobuf2
- Switch to GENIRQ

Cc Laurent.

Regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
