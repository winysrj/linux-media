Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37590
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S936357AbdGTN43 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 09:56:29 -0400
Date: Thu, 20 Jul 2017 10:56:20 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Kieran Bingham <kieranbingham@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 06/14] v4l: vsp1: Add pipe index argument to the
 VSP-DU API
Message-ID: <20170720105620.0efa0010@vento.lan>
In-Reply-To: <3451025.QtdIjcAE8v@avalon>
References: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com>
        <20170626181226.29575-7-laurent.pinchart+renesas@ideasonboard.com>
        <915884a5-e69d-b821-4a53-afa73a03c233@gmail.com>
        <3451025.QtdIjcAE8v@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 14 Jul 2017 02:04:06 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> On Thursday 13 Jul 2017 14:16:03 Kieran Bingham wrote:
> > On 26/06/17 19:12, Laurent Pinchart wrote:  
> > > In the H3 ES2.0 SoC the VSP2-DL instance has two connections to DU
> > > channels that need to be configured independently. Extend the VSP-DU API
> > > with a pipeline index to identify which pipeline the caller wants to
> > > operate on.
> > > 
> > > Signed-off-by: Laurent Pinchart
> > > <laurent.pinchart+renesas@ideasonboard.com>  
> > 
> > A bit of comment merge between this and the next patch but it's minor and
> > not worth the effort to change that ... so I'll happily ignore it if you do
> > :)
> > 
> > Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> >   
> > > ---
> > > 
> > >  drivers/gpu/drm/rcar-du/rcar_du_vsp.c  | 12 ++++++------
> > >  drivers/media/platform/vsp1/vsp1_drm.c | 32 +++++++++++++++++++--------
> > >  include/media/vsp1.h                   | 10 ++++++----
> > >  3 files changed, 34 insertions(+), 20 deletions(-)  
> 
> [snip]
> 
> > > diff --git a/drivers/media/platform/vsp1/vsp1_drm.c
> > > b/drivers/media/platform/vsp1/vsp1_drm.c index c72d021ff820..daaafe7885fa
> > > 100644
> > > --- a/drivers/media/platform/vsp1/vsp1_drm.c
> > > +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> > > @@ -58,21 +58,26 @@ EXPORT_SYMBOL_GPL(vsp1_du_init);
> > >  /**
> > >   * vsp1_du_setup_lif - Setup the output part of the VSP pipeline
> > >   * @dev: the VSP device
> > > + * @pipe_index: the DRM pipeline index
> > >   * @cfg: the LIF configuration
> > >   *
> > >   * Configure the output part of VSP DRM pipeline for the given frame
> > >   @cfg.width
> > > - * and @cfg.height. This sets up formats on the BRU source pad, the WPF0
> > > sink
> > > - * and source pads, and the LIF sink pad.
> > > + * and @cfg.height. This sets up formats on the blend unit (BRU or BRS)
> > > source
> > > + * pad, the WPF sink and source pads, and the LIF sink pad.
> > >   *
> > > - * As the media bus code on the BRU source pad is conditioned by the
> > > - * configuration of the BRU sink 0 pad, we also set up the formats on all
> > > BRU
> > > + * The @pipe_index argument selects which DRM pipeline to setup. The
> > > number of
> > > + * available pipelines depend on the VSP instance.
> > > + *
> > > + * As the media bus code on the blend unit source pad is conditioned by
> > > the
> > > + * configuration of its sink 0 pad, we also set up the formats on all
> > > blend unit
> > >   * sinks, even if the configuration will be overwritten later by
> > > - * vsp1_du_setup_rpf(). This ensures that the BRU configuration is set to
> > > a well
> > > - * defined state.
> > > + * vsp1_du_setup_rpf(). This ensures that the blend unit configuration is
> > > set to
> > > + * a well defined state.  
> > 
> > I presume those comment updates for the BRU/ blend-unit configuration are
> > actually for the next patch - but I don't think it matters here - and isn't
> > worth the effort to move the hunks.  
> 
> Too late, I've fixed it already :-) Thanks for pointing it out.

Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>


Thanks,
Mauro
