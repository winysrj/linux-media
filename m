Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60464 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750818AbdGBOXT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 2 Jul 2017 10:23:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1.1 2/2] drm: rcar-du: Repair vblank for DRM page flips using the VSP1
Date: Sun, 02 Jul 2017 17:23:24 +0300
Message-ID: <1681295.5XGp1sIbmj@avalon>
In-Reply-To: <87mv8pj2z2.wl%kuninori.morimoto.gx@renesas.com>
References: <cover.22236bc88adc598797b31ea82329ec99304fe34d.1498744799.git-series.kieran.bingham+renesas@ideasonboard.com> <6d71aa0796dd8892510d6911a280eba235398ed4.1498751638.git-series.kieran.bingham+renesas@ideasonboard.com> <87mv8pj2z2.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Morimoto-san,

On Friday 30 Jun 2017 08:32:04 Kuninori Morimoto wrote:
> Hi Kieran
> 
> > -static void rcar_du_vsp_complete(void *private)
> > +static void rcar_du_vsp_complete(void *private, bool completed)
> >  {
> >  	struct rcar_du_crtc *crtc = private;
> > 
> > -	rcar_du_crtc_finish_page_flip(crtc);
> > +	if (crtc->vblank_enable)
> > +		drm_crtc_handle_vblank(&crtc->crtc);
> > +
> > +	if (completed)
> > +		rcar_du_crtc_finish_page_flip(crtc);
> >  }
> 
> Here, this "vblank_enable" flag, timestamp will be update on
> drm_crtc_handle_vblank().
> 
> For example modetest Flip test, if we stop it by Ctrl+C, then, vblank_enable
> will be false, Then, vblank timestamp isn't updated on waiting method on
> drm_atomic_helper_wait_for_vblanks(). Thus we will have timeout error.

I've noticed this issue as well when testing Kieran's patch, and I will fix 
it.

> And, print complete is now indicated on VSP Frame End,
> in interlace input case, print complete will be indicated to user
> on each ODD, EVEN timing.
> 
> Before this patch, for example 1080i@60Hz, print complete indication
> happen in 30Hz.
> After this patch, in interlace case, indication coming 60Hz

Isn't this to be expected ? In 1080i@60Hz the frame rate is 60 frames per 
second, so shouldn't vertical blanking be reported at 60Hz ?

-- 
Regards,

Laurent Pinchart
