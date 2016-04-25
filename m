Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36984 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbcDYOAR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 10:00:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 02/13] v4l: Add Renesas R-Car FCP driver
Date: Mon, 25 Apr 2016 17:00:38 +0300
Message-ID: <4014578.egSdWWCY1K@avalon>
In-Reply-To: <CAMuHMdWOQJfOdZmo7Z3EiXeXFeANLtDPRZvSwx9mG5ecG5kpvQ@mail.gmail.com>
References: <1461455400-28767-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1461455400-28767-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <CAMuHMdWOQJfOdZmo7Z3EiXeXFeANLtDPRZvSwx9mG5ecG5kpvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

Thank you for the review.

On Monday 25 Apr 2016 09:37:07 Geert Uytterhoeven wrote:
> On Sun, Apr 24, 2016 at 1:49 AM, Laurent Pinchart
> 
> <laurent.pinchart+renesas@ideasonboard.com> wrote:
> > The FCP is a companion module of video processing modules in the
> > Renesas R-Car Gen3 SoCs. It provides data compression and decompression,
> > data caching, and conversion of AXI transaction in order to reduce the
> 
> transactions

I'll fix that.

> > memory bandwidth.
> > 
> > --- /dev/null
> > +++ b/drivers/media/platform/rcar-fcp.c
> > @@ -0,0 +1,176 @@
> > 
> > +/**
> > + * rcar_fcp_enable - Enable an FCP
> > + * @fcp: The FCP instance
> > + *
> > + * Before any memory access through an FCP is performed by a module, the
> > FCP + * must be enabled by a call to this function. The enable calls are
> > reference + * counted, each of them must be followed by one
> > rcar_fcp_disable() call when + * no more memory transfer can occur
> > through the FCP.
> > + */
> > +void rcar_fcp_enable(struct rcar_fcp_device *fcp)
> > +{
> > +       if (fcp)
> > +               pm_runtime_get_sync(fcp->dev);
> 
> Given pm_runtime_get_sync() returns an error code (which is usually just
> ignored), perhaps you want to forward that?

I'll fix this too.

> > +}
> > +EXPORT_SYMBOL_GPL(rcar_fcp_enable);
> 
> Regardless
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

-- 
Regards,

Laurent Pinchart

