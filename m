Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56100 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbbLEWUY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2015 17:20:24 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH v2 17/32] v4l: vsp1: Fix typo in VI6_DISP_IRQ_STA_DST register name
Date: Sun, 06 Dec 2015 00:20:35 +0200
Message-ID: <2694247.f6vaztlhDB@avalon>
In-Reply-To: <56635B69.3000800@cogentembedded.com>
References: <1449281586-25726-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1449281586-25726-18-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <56635B69.3000800@cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio,

On Sunday 06 December 2015 00:47:21 Sergei Shtylyov wrote:
> On 12/5/2015 5:12 AM, Laurent Pinchart wrote:
> > Rename the VI6_DISP_IRQ_STA_DSE register
> 
>     Register bit, perhaps?

Indeed. I know I can count on you to catch even such small issues :-)

I'll fix it for the next version (or the pull request if no issue that require 
a new review round is found).

> > to VI6_DISP_IRQ_STA_DST to fix
> > a typo and match the datasheet.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >   drivers/media/platform/vsp1/vsp1_regs.h | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/platform/vsp1/vsp1_regs.h
> > b/drivers/media/platform/vsp1/vsp1_regs.h index
> > 25b48738b147..8173ceaab9f9 100644
> > --- a/drivers/media/platform/vsp1/vsp1_regs.h
> > +++ b/drivers/media/platform/vsp1/vsp1_regs.h
> > @@ -46,7 +46,7 @@
> > 
> >   #define VI6_DISP_IRQ_ENB_LNEE(n)	(1 << (n))
> >   
> >   #define VI6_DISP_IRQ_STA		0x007c
> > 
> > -#define VI6_DISP_IRQ_STA_DSE		(1 << 8)
> > +#define VI6_DISP_IRQ_STA_DST		(1 << 8)
> > 
> >   #define VI6_DISP_IRQ_STA_MAE		(1 << 5)
> >   #define VI6_DISP_IRQ_STA_LNE(n)		(1 << (n))
> 
> MBR, Sergei

-- 
Regards,

Laurent Pinchart

