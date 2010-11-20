Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51879 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab0KTR2a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Nov 2010 12:28:30 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: David Cohen <david.cohen@nokia.com>
Subject: Re: [omap3isp RFC][PATCH 2/4] omap3isp: Move CCDC LSC prefetch wait to main isp code
Date: Sat, 20 Nov 2010 18:28:34 +0100
Cc: ext Sergio Aguirre <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1290209031-12817-1-git-send-email-saaguirre@ti.com> <1290209031-12817-3-git-send-email-saaguirre@ti.com> <20101120113956.GF13186@esdhcp04381.research.nokia.com>
In-Reply-To: <20101120113956.GF13186@esdhcp04381.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011201828.35042.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi David,

On Saturday 20 November 2010 12:39:56 David Cohen wrote:
> On Sat, Nov 20, 2010 at 12:23:49AM +0100, ext Sergio Aguirre wrote:
> > Since this sequence strictly touches ISP global registers, it's
> > not really part of the same register address space than the CCDC.
> > 
> > Do this check in main isp code instead.
> > 
> > Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> > ---
> > 
> >  drivers/media/video/isp/isp.c     |   24 ++++++++++++++++++++++++
> >  drivers/media/video/isp/isp.h     |    2 ++
> >  drivers/media/video/isp/ispccdc.c |   26 +-------------------------
> >  3 files changed, 27 insertions(+), 25 deletions(-)
> > 
> > diff --git a/drivers/media/video/isp/isp.c
> > b/drivers/media/video/isp/isp.c index 2e5030f..ee45eb6 100644
> > --- a/drivers/media/video/isp/isp.c
> > +++ b/drivers/media/video/isp/isp.c
> > @@ -339,6 +339,30 @@ void isphist_dma_done(struct isp_device *isp)
> > 
> >  	}
> >  
> >  }
> > 
> > +int ispccdc_lsc_wait_prefetch(struct isp_device *isp)
> 
> This is up to you, but to ensure this function now belongs to ISP core
> and not CCDC anymore, I would change the function name to something like
> isp_ccdc_lsc_wait_prefetch().
> isp_* is prefix for ISP core and ispccdc_* is prefix for CCDC driver.
> I know we have the isphist_dma_done() inside ISP core, but changing it
> to isp_hist_dma_done could be a good cleanup as well.
> But this is my opinion only. :)

I agree. I plan to submit a patch at some point that will rename all non-
static functions to use the omap3isp_ prefix instead of the isp_ prefix. 
Static functions should use the module name as prefix (ccdc_, preview_, ...).

It will be a simple patch but will conflict with pretty much everything, so 
I'll try to push at at a quiet time (or at least quiet enough) to minimize 
disturbances. I will also see if I can use spatch [1] to generate it.


[1] http://coccinelle.lip6.fr/

-- 
Regards,

Laurent Pinchart
