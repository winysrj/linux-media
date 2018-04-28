Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:50720 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757613AbeD1QTT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 12:19:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v2 5/8] v4l: vsp1: Extend the DU API to support CRC computation
Date: Sat, 28 Apr 2018 19:19:34 +0300
Message-ID: <2143831.DOFRIRY06f@avalon>
In-Reply-To: <20180428100316.GC18201@w540>
References: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com> <20180422223430.16407-6-laurent.pinchart+renesas@ideasonboard.com> <20180428100316.GC18201@w540>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Saturday, 28 April 2018 13:03:16 EEST jacopo mondi wrote:
> Hi Laurent,
>    just one minor comment below
> 
> On Mon, Apr 23, 2018 at 01:34:27AM +0300, Laurent Pinchart wrote:
> > Add a parameter (in the form of a structure to ease future API
> > extensions) to the VSP atomic flush handler to pass CRC source
> > configuration, and pass the CRC value to the completion callback.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  drivers/gpu/drm/rcar-du/rcar_du_vsp.c  |  6 ++++--
> >  drivers/media/platform/vsp1/vsp1_drm.c |  6 ++++--
> >  drivers/media/platform/vsp1/vsp1_drm.h |  2 +-
> >  include/media/vsp1.h                   | 29 +++++++++++++++++++++++++++--
> >  4 files changed, 36 insertions(+), 7 deletions(-)

[snip]

> > diff --git a/include/media/vsp1.h b/include/media/vsp1.h
> > index ff7ef894465d..ac63a9928a79 100644
> > --- a/include/media/vsp1.h
> > +++ b/include/media/vsp1.h

[snip]

> > @@ -61,11 +61,36 @@ struct vsp1_du_atomic_config {
> >  	unsigned int zpos;
> >  };
> > 
> > +/**
> > + * enum vsp1_du_crc_source - Source used for CRC calculation
> > + * @VSP1_DU_CRC_NONE: CRC calculation disabled
> > + * @VSP_DU_CRC_PLANE: Perform CRC calculation on an input plane
> > + * @VSP_DU_CRC_OUTPUT: Perform CRC calculation on the composed output
> 
> These two paramters are called VSP1_DU_CRC_* not VSP_DU_CRC_*

My bad. I've fixed this in my tree but will wait for other review comments 
before posting a v3.

> > + */
> > +enum vsp1_du_crc_source {
> > +	VSP1_DU_CRC_NONE,
> > +	VSP1_DU_CRC_PLANE,
> > +	VSP1_DU_CRC_OUTPUT,
> > +};

[snip]

-- 
Regards,

Laurent Pinchart
