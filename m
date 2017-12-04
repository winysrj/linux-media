Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36080 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752403AbdLDLOm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Dec 2017 06:14:42 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 5/9] v4l: vsp1: Document the vsp1_du_atomic_config structure
Date: Mon, 04 Dec 2017 13:14:55 +0200
Message-ID: <108031064.g4TCGARr8e@avalon>
In-Reply-To: <9703309e-d841-f8dc-b37a-be7a96ce91ae@cogentembedded.com>
References: <20171203105735.10529-1-laurent.pinchart+renesas@ideasonboard.com> <20171203105735.10529-6-laurent.pinchart+renesas@ideasonboard.com> <9703309e-d841-f8dc-b37a-be7a96ce91ae@cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei,

On Monday, 4 December 2017 11:31:49 EET Sergei Shtylyov wrote:
> On 12/3/2017 1:57 PM, Laurent Pinchart wrote:
> > The structure is used in the API that the VSP1 driver exposes to the DU
> > driver. Documenting it is thus important.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >   include/media/vsp1.h | 10 ++++++++++
> >   1 file changed, 10 insertions(+)
> > 
> > diff --git a/include/media/vsp1.h b/include/media/vsp1.h
> > index 68a8abe4fac5..7850f96fb708 100644
> > --- a/include/media/vsp1.h
> > +++ b/include/media/vsp1.h
> > @@ -41,6 +41,16 @@ struct vsp1_du_lif_config {
> >   int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
> >   		      const struct vsp1_du_lif_config *cfg);
> > 
> > +/**
> > + * struct vsp1_du_atomic_config - VSP atomic configuration parameters
> > + * @pixelformat: plan pixel format (V4L2 4CC)
> 
>     s/plan/plane/?

Of course, my bad. This will be fixed in v2. Thank you for catching the typo.

-- 
Regards,

Laurent Pinchart
