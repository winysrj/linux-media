Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:47556 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbaCEUKO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 15:10:14 -0500
Date: Wed, 05 Mar 2014 17:10:06 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Paul Bolle <pebolle@tiscali.nl>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [media] v4l: omap4iss: Add DEBUG compiler flag
Message-id: <20140305171006.6243354a@samsung.com>
In-reply-to: <1600194.93iSF4Yz3E@avalon>
References: <1391958577.25424.22.camel@x220> <1409428.L7JLLEda5C@avalon>
 <1392117421.5686.4.camel@x220> <1600194.93iSF4Yz3E@avalon>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 11 Feb 2014 13:38:51 +0100
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Paul,
> 
> Thank you for the patch.
> 
> On Tuesday 11 February 2014 12:17:01 Paul Bolle wrote:
> > Commit d632dfefd36f ("[media] v4l: omap4iss: Add support for OMAP4
> > camera interface - Build system") added a Kconfig entry for
> > VIDEO_OMAP4_DEBUG. But nothing uses that symbol.
> > 
> > This entry was apparently copied from a similar entry for "OMAP 3
> > Camera debug messages". The OMAP 3 entry is used to set the DEBUG
> > compiler flag, which enables calls of dev_dbg().
> > 
> > So add a Makefile line to do that for omap4iss too.
> > 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> and applied to my tree.
> 
> > ---
> > 0) v1 was called "[media] v4l: omap4iss: Remove VIDEO_OMAP4_DEBUG". This
> > versions implements Laurent's alternative (which is much better).
> 
> Thanks :-)
> 
> > 1) Still untested.
> > 
> >  drivers/staging/media/omap4iss/Makefile | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/staging/media/omap4iss/Makefile
> > b/drivers/staging/media/omap4iss/Makefile index a716ce9..f46c6bd 100644
> > --- a/drivers/staging/media/omap4iss/Makefile
> > +++ b/drivers/staging/media/omap4iss/Makefile
> > @@ -1,5 +1,7 @@
> >  # Makefile for OMAP4 ISS driver
> > 
> > +ccflags-$(CONFIG_VIDEO_OMAP4_DEBUG) += -DDEBUG
> > +

This seems to be a very bad idea on my eyes. It is just creating an
alias to an already existing Kconfig symbol with no good reason.

To be fair, there are also two other drivers doing this:

	drivers/media/platform/omap3isp/Makefile:ccflags-$(CONFIG_VIDEO_OMAP3_DEBUG) += -DDEBUG
	drivers/media/platform/ti-vpe/Makefile:ccflags-$(CONFIG_VIDEO_TI_VPE_DEBUG) += -DDEBUG

It sounds better do to a s/CONFIG_DEBUG/CONFIG_VIDEO_whatever_DEBUG/ 
inside each of those driver, or to just remove this, and document that
one should enable CONFIG_DEBUG if they want to debug v4l2 drivers.

> >  omap4-iss-objs += \
> >  	iss.o iss_csi2.o iss_csiphy.o iss_ipipeif.o iss_ipipe.o iss_resizer.o
> > iss_video.o
> 


-- 

Cheers,
Mauro
