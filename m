Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D5CC4360F
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 16:08:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B636F206DF
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 16:08:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="bgj+5BUD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbfCMQIe (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 12:08:34 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:56070 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfCMQId (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 12:08:33 -0400
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5F85F5AA;
        Wed, 13 Mar 2019 17:08:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552493311;
        bh=ODSUg5zqu3rNwpMkV16HNS3Ziqe8c//LRwI/ItxvdJM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bgj+5BUDGP3nJ8PvbaPj8K3etCLEIjatRIqbU/B/99dGCtK64g9ujPiLQEk9zjkgW
         Succ7z6dviImaZejq7NYe8rvgWLch5KeWHyycz9v3hodERGcIOsuSDXjb9RcwmQlII
         jeJEeV0ZiSKUmZ7J4HxT/9kC92NxQw6OL/dmVg3Q=
Date:   Wed, 13 Mar 2019 18:08:24 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>
Subject: Re: [PATCH v6 18/18] drm: rcar-du: Add writeback support for R-Car
 Gen3
Message-ID: <20190313160824.GG4722@pendragon.ideasonboard.com>
References: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
 <20190313000532.7087-19-laurent.pinchart+renesas@ideasonboard.com>
 <b2c70be1-f423-e3ad-9ad8-ef7a074f10a0@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b2c70be1-f423-e3ad-9ad8-ef7a074f10a0@ideasonboard.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Kieran,

On Wed, Mar 13, 2019 at 12:06:40PM +0000, Kieran Bingham wrote:
> On 13/03/2019 00:05, Laurent Pinchart wrote:
> > Implement writeback support for R-Car Gen3 by exposing writeback
> > connectors. Behind the scene the calls are forwarded to the VSP
> > backend.
> > 
> > Using writeback connectors will allow implemented writeback support for
> > R-Car Gen2 with a consistent API if desired.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> 
> An extra blank line, and I was a bit concerned about a function naming
> below - but other than that:
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> > ---
> > Changes since v5:
> > 
> > - Skip writeback connector when configuring output routing
> > - Implement writeback connector atomic state operations
> > ---
> >  drivers/gpu/drm/rcar-du/Kconfig             |   4 +
> >  drivers/gpu/drm/rcar-du/Makefile            |   3 +-
> >  drivers/gpu/drm/rcar-du/rcar_du_crtc.c      |   7 +-
> >  drivers/gpu/drm/rcar-du/rcar_du_crtc.h      |   7 +-
> >  drivers/gpu/drm/rcar-du/rcar_du_kms.c       |  12 +
> >  drivers/gpu/drm/rcar-du/rcar_du_vsp.c       |   5 +
> >  drivers/gpu/drm/rcar-du/rcar_du_writeback.c | 243 ++++++++++++++++++++
> >  drivers/gpu/drm/rcar-du/rcar_du_writeback.h |  39 ++++
> >  8 files changed, 317 insertions(+), 3 deletions(-)
> >  create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_writeback.c
> >  create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_writeback.h

[snip]

> > diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> > index 0806a69c4679..99ae03a1713a 100644
> > --- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> > +++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> > @@ -25,6 +25,7 @@
> >  #include "rcar_du_drv.h"
> >  #include "rcar_du_kms.h"
> >  #include "rcar_du_vsp.h"
> > +#include "rcar_du_writeback.h"
> >  
> >  static void rcar_du_vsp_complete(void *private, unsigned int status, u32 crc)
> >  {
> > @@ -35,6 +36,8 @@ static void rcar_du_vsp_complete(void *private, unsigned int status, u32 crc)
> >  
> >  	if (status & VSP1_DU_STATUS_COMPLETE)
> >  		rcar_du_crtc_finish_page_flip(crtc);
> > +	if (status & VSP1_DU_STATUS_WRITEBACK)
> > +		rcar_du_writeback_complete(crtc);
> >  
> >  	drm_crtc_add_crc_entry(&crtc->crtc, false, 0, &crc);
> >  }
> > @@ -106,6 +109,8 @@ void rcar_du_vsp_atomic_flush(struct rcar_du_crtc *crtc)
> >  	state = to_rcar_crtc_state(crtc->crtc.state);
> >  	cfg.crc = state->crc;
> >  
> > +	rcar_du_writeback_atomic_flush(crtc, &cfg.writeback);
> 
> Hrm ...the naming here worries me a bit. This doesn't do the actual
> flushing (execution?) of the writeback operation, it just configures the
> writeback into the VSP cfg structure. The 'flush' to hardware takes
> place in vsp1_du_atomic_flush().
> 
> Or maybe it is ok becuase it calls drm_writeback_queue_job() as well as
> setting up the cfg...

You've got a point. I've renamed the function to
rcar_du_writeback_setup().

> > +
> >  	vsp1_du_atomic_flush(crtc->vsp->vsp, crtc->vsp_pipe, &cfg);
> >  }
> >  

[snip]

-- 
Regards,

Laurent Pinchart
