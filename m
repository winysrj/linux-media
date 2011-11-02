Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38705 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097Ab1KBOMF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2011 10:12:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 2/3] omap3isp: preview: Rename min/max input/output sizes defines
Date: Wed, 2 Nov 2011 15:12:04 +0100
Cc: linux-media@vger.kernel.org
References: <1318972497-8367-1-git-send-email-laurent.pinchart@ideasonboard.com> <1318972497-8367-3-git-send-email-laurent.pinchart@ideasonboard.com> <20111026011330.GB20295@valkosipuli.localdomain>
In-Reply-To: <20111026011330.GB20295@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111021512.04596.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Wednesday 26 October 2011 03:13:30 Sakari Ailus wrote:
> Hi Laurent,
> 
> Thanks for the patch. I have a single comment below.
> 
> On Tue, Oct 18, 2011 at 11:14:56PM +0200, Laurent Pinchart wrote:
> > The macros that define the minimum/maximum input and output sizes are
> > defined in seperate files and have no consistent naming. In preparation
> > for preview engine cropping support, move them all to isppreview.c and
> > rename them to PREV_{MIN|MAX}_{IN|OUT}_{WIDTH|HEIGHT}*.
> > 
> > Remove unused and/or unneeded local variables that store the maximum
> > output width.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/video/omap3isp/isppreview.c |   33 ++++++++++++------------
> >  drivers/media/video/omap3isp/ispreg.h     |    3 --
> >  2 files changed, 17 insertions(+), 19 deletions(-)
> > 
> > diff --git a/drivers/media/video/omap3isp/isppreview.c
> > b/drivers/media/video/omap3isp/isppreview.c index c920c1e..d5cce42
> > 100644
> > --- a/drivers/media/video/omap3isp/isppreview.c
> > +++ b/drivers/media/video/omap3isp/isppreview.c
> > @@ -76,9 +76,15 @@ static struct omap3isp_prev_csc flr_prev_csc = {
> > 
> >  #define DEF_DETECT_CORRECT_VAL	0xe
> > 
> > -#define PREV_MIN_WIDTH		64
> > -#define PREV_MIN_HEIGHT		8
> > -#define PREV_MAX_HEIGHT		16384
> > +#define PREV_MIN_IN_WIDTH	64
> > +#define PREV_MIN_IN_HEIGHT	8
> > +#define PREV_MAX_IN_HEIGHT	16384
> > +
> > +#define PREV_MIN_OUT_WIDTH	0
> > +#define PREV_MIN_OUT_HEIGHT	0
> > +#define PREV_MAX_OUT_WIDTH	1280
> > +#define PREV_MAX_OUT_WIDTH_ES2	3300
> > +#define PREV_MAX_OUT_WIDTH_3630	4096
> 
> The preview line buffer size very probably depends on the ISP revision and
> not OMAP revision. I think this name is such for historical reasons.
> 
> I just thought this now that you're changing them anyway. :)

As it seems I'll have to resubmit the patches to v3.3, I'll fix this. Thanks 
for pointing it out.

-- 
Regards,

Laurent Pinchart
