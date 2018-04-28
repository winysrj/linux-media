Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:52332 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758175AbeD1Q5E (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 12:57:04 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v2 7/8] v4l: vsp1: Integrate DISCOM in display pipeline
Date: Sat, 28 Apr 2018 19:57:19 +0300
Message-ID: <5979699.LE7rGvgjD7@avalon>
In-Reply-To: <20180428110026.GE18201@w540>
References: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com> <20180422223430.16407-8-laurent.pinchart+renesas@ideasonboard.com> <20180428110026.GE18201@w540>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Saturday, 28 April 2018 14:00:26 EEST jacopo mondi wrote:
> On Mon, Apr 23, 2018 at 01:34:29AM +0300, Laurent Pinchart wrote:
> > The DISCOM is used to compute CRCs on display frames. Integrate it in
> > the display pipeline at the output of the blending unit to process
> > output frames.
> > 
> > Computing CRCs on input frames is possible by positioning the DISCOM at
> > a different point in the pipeline. This use case isn't supported at the
> > moment and could be implemented by extending the API between the VSP1
> > and DU drivers if needed.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  drivers/media/platform/vsp1/vsp1_drm.c | 115 +++++++++++++++++++++++++++-
> >  drivers/media/platform/vsp1/vsp1_drm.h |  12 ++++
> >  2 files changed, 124 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/platform/vsp1/vsp1_drm.c
> > b/drivers/media/platform/vsp1/vsp1_drm.c index 5fc31578f9b0..7864b43a90e1
> > 100644
> > --- a/drivers/media/platform/vsp1/vsp1_drm.c
> > +++ b/drivers/media/platform/vsp1/vsp1_drm.c

[snip]

> > @@ -48,10 +54,65 @@ static void vsp1_du_pipeline_frame_end(struct
> > vsp1_pipeline *pipe,> 
> >   * Pipeline Configuration
> >   */
> > 
> > +/*
> > + * Insert the UIF in the pipeline between the prev and next entities. If
> > no UIF + * is available connect the two entities directly.
> > + */
> > +static int vsp1_du_insert_uif(struct vsp1_device *vsp1,
> > +			      struct vsp1_pipeline *pipe,
> > +			      struct vsp1_entity *uif,
> > +			      struct vsp1_entity *prev, unsigned int prev_pad,
> > +			      struct vsp1_entity *next, unsigned int next_pad)
> > +{
> > +	int ret;
> > +
> > +	if (uif) {
> > +		struct v4l2_subdev_format format;
> > +
> > +		prev->sink = uif;
> > +		prev->sink_pad = UIF_PAD_SINK;
> > +
> > +		memset(&format, 0, sizeof(format));
> > +		format.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> > +		format.pad = prev_pad;
> > +
> > +		ret = v4l2_subdev_call(&prev->subdev, pad, get_fmt, NULL,
> > +				       &format);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		format.pad = UIF_PAD_SINK;
> > +
> > +		ret = v4l2_subdev_call(&uif->subdev, pad, set_fmt, NULL,
> > +				       &format);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on UIF sink\n",
> > +			__func__, format.format.width, format.format.height,
> > +			format.format.code);
> > +
> > +		/*
> > +		 * The UIF doesn't mangle the format between its sink and
> > +		 * source pads, so there is no need to retrieve the format on
> > +		 * its source pad.
> > +		 */
> > +
> > +		uif->sink = next;
> > +		uif->sink_pad = next_pad;
> > +	} else {
> > +		prev->sink = next;
> > +		prev->sink_pad = next_pad;
> 
> Isn't the !uif case better handled in the caller? See below...
> Or otherwise, if you prefer handling it here, shouldn't the
> indentation be reduced with

I don't think it's better handled in the caller, I prefer keeping the entities 
linking code in a single place. I'll reduce the indentation.

>         if (!uif) {
> 		prev->sink = next;
> 		prev->sink_pad = next_pad;
>                 return 0;
>         }
> 
> > +	}
> > +
> > +	return 0;
> > +}

[snip]

> > @@ -367,6 +441,31 @@ static int vsp1_du_pipeline_setup_inputs(struct
> > vsp1_device *vsp1,
> >  		}
> >  	}
> > 
> > +	/* Insert and configure the UIF at the BRx output if available. */
> > +	uif = drm_pipe->crc.source == VSP1_DU_CRC_OUTPUT ? drm_pipe->uif : 
NULL;
> > +	if (uif)
> > +		use_uif = true;
> > +	ret = vsp1_du_insert_uif(vsp1, pipe, uif,
> > +				 pipe->brx, pipe->brx->source_pad,
> > +				 &pipe->output->entity, 0);
> > +	if (ret < 0)
> > +		dev_err(vsp1->dev, "%s: failed to setup UIF after %s\n",
> > +			__func__, BRX_NAME(pipe->brx));
> > +
> > +	/*
> > +	 * If the UIF is not in use schedule it for removal by setting its pipe
> > +	 * pointer to NULL, vsp1_du_pipeline_configure() will remove it from 
the
> > +	 * hardware pipeline and from the pipeline's list of entities. 
Otherwise
> > +	 * make sure it is present in the pipeline's list of entities if it
> > +	 * wasn't already.
> > +	 */
> > +	if (!use_uif) {
> 
> ... here. If you don't use uif, don't call vspi1_du_insert_uif().
> True, you have to link entities explicitly here if there is not uif,
> but I may be missing where this was happening before this code was
> added.
> 
> > +		drm_pipe->uif->pipe = NULL;
> > +	} else if (!drm_pipe->uif->pipe) {
> > +		drm_pipe->uif->pipe = pipe;
> > +		list_add_tail(&drm_pipe->uif->list_pipe, &pipe->entities);
> > +	}
> > +
> >  	return 0;
> >  }
> > 
> > @@ -748,6 +847,9 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned
> > int pipe_index,> 
> >  	struct vsp1_drm_pipeline *drm_pipe = &vsp1->drm->pipe[pipe_index];
> >  	struct vsp1_pipeline *pipe = &drm_pipe->pipe;
> > 
> > +	drm_pipe->crc.source = cfg->crc.source;
> > +	drm_pipe->crc.index = cfg->crc.index;
> > +
> >  	vsp1_du_pipeline_setup_inputs(vsp1, pipe);
> >  	vsp1_du_pipeline_configure(pipe);
> >  	mutex_unlock(&vsp1->drm->lock);
> > @@ -816,6 +918,13 @@ int vsp1_drm_init(struct vsp1_device *vsp1)
> > 
> >  		pipe->lif->pipe = pipe;
> >  		list_add_tail(&pipe->lif->list_pipe, &pipe->entities);
> > +
> > +		/*
> > +		 * CRC computation is initially disabled, don't add the UIF to
> > +		 * the pipeline.
> > +		 */
> > +		if (i < vsp1->info->uif_count)
> 
> Why 'initially disabled'? This seems to me to conditionally enable the
> UIF unit. Or is the lif count always the same as the uif count?

Setting drm_pipe->uif isn't adding the UIF to the pipeline, that would be done 
by adding it to the pipe->entities list and setting the uif->pipe pointer.

> > +			drm_pipe->uif = &vsp1->uif[i]->entity;
> >  	}

-- 
Regards,

Laurent Pinchart
