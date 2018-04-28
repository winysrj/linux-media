Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:52304 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752121AbeD1Qu1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 12:50:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v2 6/8] v4l: vsp1: Add support for the DISCOM entity
Date: Sat, 28 Apr 2018 19:50:42 +0300
Message-ID: <56501970.bmiQKbb0Ad@avalon>
In-Reply-To: <20180428104002.GD18201@w540>
References: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com> <20180422223430.16407-7-laurent.pinchart+renesas@ideasonboard.com> <20180428104002.GD18201@w540>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Saturday, 28 April 2018 13:40:02 EEST jacopo mondi wrote:
> HI Laurent,
>    a few comments, mostly minor ones...
> 
> On Mon, Apr 23, 2018 at 01:34:28AM +0300, Laurent Pinchart wrote:
> > The DISCOM calculates a CRC on a configurable window of the frame. It
> > interfaces to the VSP through the UIF glue, hence the name used in the
> > code.
> > 
> > The module supports configuration of the CRC window through the crop
> > rectangle on the ink pad of the corresponding entity. However, unlike
> 
> sink pad?

Oops. Consider it fixed.

> > the traditional V4L2 subdevice model, the crop rectangle does not
> > influence the format on the source pad.
> > 
> > Modeling the DISCOM as a sink-only entity would allow adhering to the
> > V4L2 subdevice model at the expense of more complex code in the driver,
> > as at the hardware level the UIF is handled as a sink+source entity. As
> > the DISCOM is only present in R-Car Gen3 VSP-D and VSP-DL instances it
> > is not exposed to userspace through V4L2 but controlled through the DU
> > driver. We can thus change this model later if needed without fear of
> > affecting userspace.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > Changes since v1:
> > 
> > - Don't return uninitialized value from uif_set_selection()
> > ---
> > 
> >  drivers/media/platform/vsp1/Makefile      |   2 +-
> >  drivers/media/platform/vsp1/vsp1.h        |   4 +
> >  drivers/media/platform/vsp1/vsp1_drv.c    |  20 +++
> >  drivers/media/platform/vsp1/vsp1_entity.c |   6 +
> >  drivers/media/platform/vsp1/vsp1_entity.h |   1 +
> >  drivers/media/platform/vsp1/vsp1_regs.h   |  41 +++++
> >  drivers/media/platform/vsp1/vsp1_uif.c    | 271 +++++++++++++++++++++++++
> >  drivers/media/platform/vsp1/vsp1_uif.h    |  32 ++++
> >  8 files changed, 376 insertions(+), 1 deletion(-)
> >  create mode 100644 drivers/media/platform/vsp1/vsp1_uif.c
> >  create mode 100644 drivers/media/platform/vsp1/vsp1_uif.h

[snip]

> > diff --git a/drivers/media/platform/vsp1/vsp1_uif.c
> > b/drivers/media/platform/vsp1/vsp1_uif.c new file mode 100644
> > index 000000000000..6de7e9c801ae
> > --- /dev/null
> > +++ b/drivers/media/platform/vsp1/vsp1_uif.c
> > @@ -0,0 +1,271 @@

[snip]

> > +static void uif_configure(struct vsp1_entity *entity,
> > +			  struct vsp1_pipeline *pipe,
> > +			  struct vsp1_dl_list *dl,
> > +			  enum vsp1_entity_params params)
> > +{
> > +	struct vsp1_uif *uif = to_uif(&entity->subdev);
> > +	const struct v4l2_rect *crop;
> > +	unsigned int left;
> > +	unsigned int width;
> > +
> > +	/*
> > +	 * Per-partition configuration isn't needed as the DISCOM is used in
> > +	 * display pipelines only.
> > +	 */
> > +	if (params != VSP1_ENTITY_PARAMS_INIT)
> > +		return;
> > +
> > +	vsp1_uif_write(uif, dl, VI6_UIF_DISCOM_DOCMPMR,
> > +		       VI6_UIF_DISCOM_DOCMPMR_SEL(9));
> > +
> > +	crop = vsp1_entity_get_pad_selection(entity, entity->config,
> > +					     UIF_PAD_SINK, V4L2_SEL_TGT_CROP);
> > +
> > +	/* On M3-W the horizontal coordinates are twice the register value. */
> > +	if (uif->m3w_quirk) {
> > +		left = crop->left / 2;
> > +		width = crop->width / 2;
> > +	} else {
> > +		left = crop->left;
> > +		width = crop->width;
> > +	}
> 
> I would write this as
> 
>         left = crop->left;
>         width = crop->width;
> 	/* On M3-W the horizontal coordinates are twice the register value. */
> 	if (uif->m3w_quirk) {
> 		left /= 2;
> 		width /= 2;
>         }
> 
> But that's really up to you.

I prefer my style, but it looks like gcc 6.4.0 generates slightly better code 
with your version (due to the fact that the crop->left value is converted to 
unsigned before being divided by 2), so I'll go for it.

> > +
> > +	vsp1_uif_write(uif, dl, VI6_UIF_DISCOM_DOCMSPXR, left);
> > +	vsp1_uif_write(uif, dl, VI6_UIF_DISCOM_DOCMSPYR, crop->top);
> > +	vsp1_uif_write(uif, dl, VI6_UIF_DISCOM_DOCMSZXR, width);
> > +	vsp1_uif_write(uif, dl, VI6_UIF_DISCOM_DOCMSZYR, crop->height);
> > +
> > +	vsp1_uif_write(uif, dl, VI6_UIF_DISCOM_DOCMCR,
> > +		       VI6_UIF_DISCOM_DOCMCR_CMPR);
> > +}
> > +
> > +static const struct vsp1_entity_operations uif_entity_ops = {
> > +	.configure = uif_configure,
> > +};
> > +
> > +/* ----------------------------------------------------------------------
> > + * Initialization and Cleanup
> > + */
> > +
> > +static const struct soc_device_attribute vsp1_r8a7796[] = {
> > +	{ .soc_id = "r8a7796" },
> > +	{ /* sentinel */ }
> > +};
> > +
> > +struct vsp1_uif *vsp1_uif_create(struct vsp1_device *vsp1, unsigned int
> > index) +{
> > +	struct vsp1_uif *uif;
> > +	char name[6];
> > +	int ret;
> > +
> > +	uif = devm_kzalloc(vsp1->dev, sizeof(*uif), GFP_KERNEL);
> > +	if (uif == NULL)
> 
>         if (!uif)
> 
> Otherwise checkpatch complains iirc.

Only when run with --strict.

Nevertheless, even if both styles are mixed in the driver, the predominant 
style is !uif, so I'll switch to that.

> Those are very minor comments, so feel free to add my reviewed by tag
> 
> Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
> 
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	if (soc_device_match(vsp1_r8a7796))
> > +		uif->m3w_quirk = true;
> > +
> > +	uif->entity.ops = &uif_entity_ops;
> > +	uif->entity.type = VSP1_ENTITY_UIF;
> > +	uif->entity.index = index;
> > +
> > +	/* The datasheet names the two UIF instances UIF4 and UIF5. */
> > +	sprintf(name, "uif.%u", index + 4);
> > +	ret = vsp1_entity_init(vsp1, &uif->entity, name, 2, &uif_ops,
> > +			       MEDIA_ENT_F_PROC_VIDEO_STATISTICS);
> > +	if (ret < 0)
> > +		return ERR_PTR(ret);
> > +
> > +	return uif;
> > +}

[snip]

-- 
Regards,

Laurent Pinchart
