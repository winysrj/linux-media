Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:33854 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754786AbcIFGpo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2016 02:45:44 -0400
Received: by mail-lf0-f52.google.com with SMTP id u14so16324525lfd.1
        for <linux-media@vger.kernel.org>; Mon, 05 Sep 2016 23:45:42 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Tue, 6 Sep 2016 08:45:40 +0200
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        corbet@lwn.net, mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com
Subject: Re: [PATCH 2/2] v4l: vsp1: Add HGT support
Message-ID: <20160906064540.GE27014@bigcity.dyn.berto.se>
References: <20160902134714.12224-1-niklas.soderlund+renesas@ragnatech.se>
 <20160902134714.12224-3-niklas.soderlund+renesas@ragnatech.se>
 <4112113.lBOXq3Iuhk@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4112113.lBOXq3Iuhk@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your review.

On 2016-09-05 18:43:58 +0300, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Friday 02 Sep 2016 15:47:14 Niklas Söderlund wrote:
> > The HGT is a Histogram Generator Two-Dimensions. It computes a weighted
> > frequency histograms for hue and saturation areas over a configurable
> > region of the image with optional subsampling.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/platform/vsp1/Makefile      |   2 +-
> >  drivers/media/platform/vsp1/vsp1.h        |   3 +
> >  drivers/media/platform/vsp1/vsp1_drv.c    |  32 +-
> >  drivers/media/platform/vsp1/vsp1_entity.c |  33 +-
> >  drivers/media/platform/vsp1/vsp1_entity.h |   1 +
> >  drivers/media/platform/vsp1/vsp1_hgt.c    | 495 +++++++++++++++++++++++++++
> >  drivers/media/platform/vsp1/vsp1_hgt.h    |  51 +++
> >  drivers/media/platform/vsp1/vsp1_pipe.c   |  16 +
> >  drivers/media/platform/vsp1/vsp1_pipe.h   |   2 +
> >  drivers/media/platform/vsp1/vsp1_regs.h   |   9 +
> >  drivers/media/platform/vsp1/vsp1_video.c  |  10 +-
> >  11 files changed, 638 insertions(+), 16 deletions(-)
> >  create mode 100644 drivers/media/platform/vsp1/vsp1_hgt.c
> >  create mode 100644 drivers/media/platform/vsp1/vsp1_hgt.h
> 
> [snip]
> 
> > diff --git a/drivers/media/platform/vsp1/vsp1_hgt.c
> > b/drivers/media/platform/vsp1/vsp1_hgt.c new file mode 100644
> > index 0000000..c43373d
> > --- /dev/null
> > +++ b/drivers/media/platform/vsp1/vsp1_hgt.c
> > @@ -0,0 +1,495 @@
> > +/*
> > + * vsp1_hgt.c  --  R-Car VSP1 Histogram Generator 2D
> > + *
> > + * Copyright (C) 2016 Renesas Electronics Corporation
> > + *
> > + * Contact: Niklas Söderlund (niklas.soderlund@ragnatech.se)
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + */
> > +
> > +#include <linux/device.h>
> > +#include <linux/gfp.h>
> > +
> > +#include <media/v4l2-subdev.h>
> > +#include <media/videobuf2-vmalloc.h>
> > +
> > +#include "vsp1.h"
> > +#include "vsp1_dl.h"
> > +#include "vsp1_hgt.h"
> > +
> > +#define HGT_MIN_SIZE				4U
> > +#define HGT_MAX_SIZE				8192U
> > +#define HGT_DATA_SIZE				((2 + 6 + 6 * 32) * 4)
> > +
> > +/* ------------------------------------------------------------------------
> > + * Device Access
> > + */
> > +
> > +static inline u32 vsp1_hgt_read(struct vsp1_hgt *hgt, u32 reg)
> > +{
> > +	return vsp1_read(hgt->entity.vsp1, reg);
> > +}
> > +
> > +static inline void vsp1_hgt_write(struct vsp1_hgt *hgt, struct vsp1_dl_list
> > *dl,
> > +				  u32 reg, u32 data)
> > +{
> > +	vsp1_dl_list_write(dl, reg, data);
> > +}
> > +
> > +/* ------------------------------------------------------------------------
> > + * Frame End Handler
> > + */
> > +
> > +void vsp1_hgt_frame_end(struct vsp1_entity *entity)
> > +{
> > +	struct vsp1_hgt *hgt = to_hgt(&entity->subdev);
> > +	struct vsp1_histogram_buffer *buf;
> > +	unsigned int m, n;
> > +	u32 *data;
> > +
> > +	buf = vsp1_histogram_buffer_get(&hgt->histo);
> > +	if (!buf)
> > +		return;
> > +
> > +	data = buf->addr;
> > +
> > +	*data++ = vsp1_hgt_read(hgt, VI6_HGT_MAXMIN);
> > +	*data++ = vsp1_hgt_read(hgt, VI6_HGT_SUM);
> > +
> > +	for (n = 0; n < 6; n++)
> 
> Nitpicking, the driver uses pre-increment in for loops (++n), not post-
> increment. This used to be a best-practice rule in C++, where pre-increment 
> can be faster for non-native types (see http://antonym.org/2008/05/stl-iterators-and-performance.html for instance). I'm not sure if that's still 
> relevant, but I've taken the habit of using the pre-increment operator in for 
> loops, and that's what the rest of this driver does. This comment applies to 
> all other locations in this file.

Will update this for v2.

> 
> > +		*data++ = vsp1_hgt_read(hgt, VI6_HGT_HUE_AREA(n));
> 
> As commented on patch 1/2, I don't think this is needed. Userspace has 
> configured the hue areas, it should already have access to this information. 
> Note that if you wanted to keep this code you would need to synchronize it 
> with the .s_ctrl() handler to avoid race conditions. That's not trivial, and 
> in my opinion not needed.

Will drop the hue area configuration in v2.

> 
> > +	for (m = 0; m < 6; m++)
> > +		for (n = 0; n < 32; n++)
> > +			*data++ = vsp1_hgt_read(hgt, VI6_HGT_HISTO(m, n));
> > +
> > +	vsp1_histogram_buffer_complete(&hgt->histo, buf, HGT_DATA_SIZE);
> > +}
> > +
> > +/* ------------------------------------------------------------------------
> > + * Controls
> > + */
> > +
> > +#define V4L2_CID_VSP1_HGT_HUE_AREAS	(V4L2_CID_USER_BASE | 0x1001)
> > +
> > +static int hgt_hue_areas_s_ctrl(struct v4l2_ctrl *ctrl)
> > +{
> > +	struct vsp1_hgt *hgt = container_of(ctrl->handler, struct vsp1_hgt,
> > +					    ctrls.handler);
> > +	int m, n;
> 
> m and n take positive values only, you can make them unsigned int. 
> Additionally, I would use i and j here, as m and n have a specific hardware 
> meaning.

Will fix.

> 
> > +	bool ok;
> > +
> > +	/*
> > +	 * Make sure values meet one of two possible HW constrains
> > +	 * 0L <= 0U <= 1L <= 1U <= 2L <= 2U <= 3L <= 3U <= 4L <= 4U <= 5L <= 
> 5U
> > +	 * 0U <= 1L <= 1U <= 2L <= 2U <= 3L <= 3U <= 4L <= 4U <= 5L <= 5U <= 
> 0L
> 
> Wouldn't it be better to test for 0U <= 1L <= 1U <= 2L <= 2U <= 3L <= 3U <= 4L 
> <= 4U <= 5L <= 5U unconditionally, and then for (OL <= OU || 5U <= OL) ? You 
> could possibly fold the test and fix loops in a single operation then.

Will update for v2, good suggestion.

> 
> > +	 */
> > +	for (m = 0; m <= 1; m++) {
> > +		ok = true;
> > +		for (n = 0; n < HGT_NUM_HUE_AREAS - 1; n++) {
> > +			if (ctrl->p_new.p_u8[(m + n + 0) % HGT_NUM_HUE_AREAS]
> > >
> 
> m + n + 0 is always < HGT_NUM_HUE_AREAS so you can remove the % 
> HGT_NUM_HUE_AREAS here.
> 
> You could also shorten a few lines if you declared
> 
> 	const u8 *value = ctrl->p_new.p_u8;
> 
> at the beginning of the function.
> 

Will fix for in v2.


> > +			    ctrl->p_new.p_u8[(m + n + 1) % HGT_NUM_HUE_AREAS])
> > +				ok = false;
> > +		}
> > +		if (ok)
> > +			break;
> > +	}
> > +
> > +	/* Values do not match HW, adjust to a valid setting */
> 
> You can spell out HW as hardware :-)
> 
> s/a valid setting/valid settings./

Thanks.

> 
> > +	if (!ok) {
> > +		for (n = 0; n < HGT_NUM_HUE_AREAS - 1; n++) {
> > +			if (ctrl->p_new.p_u8[n] > ctrl->p_new.p_u8[n+1])
> > +				ctrl->p_new.p_u8[n] = ctrl->p_new.p_u8[n+1];
> > +		}
> > +	}
> > +
> > +	for (n = 0; n < HGT_NUM_HUE_AREAS; n++)
> > +		hgt->hue_area[n] = ctrl->p_new.p_u8[n];
> 
> With hue_area declared as u8 unsigned of unsigned int (assuming it makes 
> sense, please see below) you could use a memcpy.

I be happy to do this if declaring hue_area as u8 make sens, but IMHO i 
think a memcpy here will decrease the readability of the code.

> 
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct v4l2_ctrl_ops hgt_hue_areas_ctrl_ops = {
> > +	.s_ctrl = hgt_hue_areas_s_ctrl,
> > +};
> > +
> > +static const struct v4l2_ctrl_config hgt_hue_areas = {
> > +	.ops = &hgt_hue_areas_ctrl_ops,
> > +	.id = V4L2_CID_VSP1_HGT_HUE_AREAS,
> > +	.name = "Boundary Values for Hue Area",
> > +	.type = V4L2_CTRL_TYPE_U8,
> > +	.min = 0,
> > +	.max = 255,
> > +	.def = 0,
> > +	.step = 1,
> > +	.dims = { 12 },
> > +};
> > +
> > +
> > +/* ------------------------------------------------------------------------
> > + * V4L2 Subdevice Operations
> > + */
> 
> [snip]
> 
> > +static const struct v4l2_subdev_ops hgt_ops = {
> > +	.pad    = &hgt_pad_ops,
> > +};
> 
> Except for the list of formats that differ between the two entityes, the 
> subdev operations are identical for the HGO and HGT. I've sent you a patch 
> that moves the implementation from vsp1_hgo.c to vsp1_histo.c, could you 
> rebase this patch on top of it (and test the result) ?

Thanks for the patch, will rebase v2 on top of it.

> 
> > +/* ------------------------------------------------------------------------
> > + * VSP1 Entity Operations
> > + */
> > +
> > +static void hgt_configure(struct vsp1_entity *entity,
> > +			  struct vsp1_pipeline *pipe,
> > +			  struct vsp1_dl_list *dl, bool full)
> > +{
> > +	struct vsp1_hgt *hgt = to_hgt(&entity->subdev);
> > +	struct v4l2_rect *compose;
> > +	struct v4l2_rect *crop;
> > +	unsigned int hratio;
> > +	unsigned int vratio;
> > +	uint8_t lower, upper;
> 
> Within the kernel you can use u8 instead of uint8_t.
> 

Will update in v2.

> Could you please declare the two variables on separate lines ?
> 

Will update in v2. I assume this is to keep consistent with other parts 
of the driver? If so I will update all occurrences in the HGT driver to 
only declare one variable per line.

> > +	int i;
> 
> i only takes positive values, you can make it unsigned int.

Will update in v2.

> 
> > +
> > +	if (!full)
> > +		return;
> > +
> > +	crop = vsp1_entity_get_pad_selection(entity, entity->config,
> > +					     HGT_PAD_SINK, V4L2_SEL_TGT_CROP);
> > +	compose = vsp1_entity_get_pad_selection(entity, entity->config,
> > +						HGT_PAD_SINK,
> > +						V4L2_SEL_TGT_COMPOSE);
> > +
> > +	vsp1_hgt_write(hgt, dl, VI6_HGT_REGRST, VI6_HGT_REGRST_RCLEA);
> > +
> > +	vsp1_hgt_write(hgt, dl, VI6_HGT_OFFSET,
> > +		       (crop->left << VI6_HGT_OFFSET_HOFFSET_SHIFT) |
> > +		       (crop->top << VI6_HGT_OFFSET_VOFFSET_SHIFT));
> > +	vsp1_hgt_write(hgt, dl, VI6_HGT_SIZE,
> > +		       (crop->width << VI6_HGT_SIZE_HSIZE_SHIFT) |
> > +		       (crop->height << VI6_HGT_SIZE_VSIZE_SHIFT));
> > +
> > +	mutex_lock(hgt->ctrls.handler.lock);
> > +	for (i = 0; i < 6; i++) {
> > +		lower = hgt->hue_area[i*2 + 0];
> > +		upper = hgt->hue_area[i*2 + 1];
> > +		vsp1_hgt_write(hgt, dl, VI6_HGT_HUE_AREA(i),
> > +			       (lower << VI6_HGT_HUE_AREA_LOWER_SHIFT) |
> > +			       (upper << VI6_HGT_HUE_AREA_UPPER_SHIFT));
> > +	}
> > +	mutex_unlock(hgt->ctrls.handler.lock);
> > +
> > +	hratio = crop->width * 2 / compose->width / 3;
> > +	vratio = crop->height * 2 / compose->height / 3;
> > +	vsp1_hgt_write(hgt, dl, VI6_HGT_MODE,
> > +		       (hratio << VI6_HGT_MODE_HRATIO_SHIFT) |
> > +		       (vratio << VI6_HGT_MODE_VRATIO_SHIFT));
> > +}
> > +
> > +static void hgt_destroy(struct vsp1_entity *entity)
> > +{
> > +	struct vsp1_hgt *hgt = to_hgt(&entity->subdev);
> > +
> > +	vsp1_histogram_cleanup(&hgt->histo);
> > +}
> > +
> > +static const struct vsp1_entity_operations hgt_entity_ops = {
> > +	.configure = hgt_configure,
> > +	.destroy = hgt_destroy,
> > +};
> > +
> > +/* ------------------------------------------------------------------------
> > + * Initialization and Cleanup
> > + */
> > +
> > +struct vsp1_hgt *vsp1_hgt_create(struct vsp1_device *vsp1)
> > +{
> > +	struct vsp1_hgt *hgt;
> > +	int i, ret;
> 
> i takes positive a values only, you can declare it as an unsigned int.
> 

Will fix in v2.

> > +
> > +	hgt = devm_kzalloc(vsp1->dev, sizeof(*hgt), GFP_KERNEL);
> > +	if (hgt == NULL)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	hgt->entity.ops = &hgt_entity_ops;
> > +	hgt->entity.type = VSP1_ENTITY_HGT;
> > +
> > +	ret = vsp1_entity_init(vsp1, &hgt->entity, "hgt", 2, &hgt_ops,
> > +			       MEDIA_ENT_F_PROC_VIDEO_STATISTICS);
> > +	if (ret < 0)
> > +		return ERR_PTR(ret);
> > +
> > +	/* Initialize the control handler. */
> > +	for (i = 0; i < HGT_NUM_HUE_AREAS; i++)
> > +		hgt->hue_area[i] = hgt_hue_areas.def;
> 
> The right way to do this is to call v4l2_ctrl_handler_setup() at the end of 
> the function. I need to fix a few locations in the driver where the values are 
> initialized manually.

Ohh, did not know that, will fix.

> 
> > +	v4l2_ctrl_handler_init(&hgt->ctrls.handler, 12);
> 
> s/12/1/

Ops, thanks for spotting this.

> 
> > +	hgt->ctrls.hue_areas = v4l2_ctrl_new_custom(&hgt->ctrls.handler,
> > +						    &hgt_hue_areas, NULL);
> > +	hgt->entity.subdev.ctrl_handler = &hgt->ctrls.handler;
> > +
> > +	/* Initialize the video device and queue for statistics data. */
> > +	ret = vsp1_histogram_init(vsp1, &hgt->histo, hgt->entity.subdev.name,
> > +				  HGT_DATA_SIZE, V4L2_META_FMT_VSP1_HGT);
> > +	if (ret < 0) {
> > +		vsp1_entity_destroy(&hgt->entity);
> > +		return ERR_PTR(ret);
> > +	}
> > +
> > +	return hgt;
> > +}
> > diff --git a/drivers/media/platform/vsp1/vsp1_hgt.h
> > b/drivers/media/platform/vsp1/vsp1_hgt.h new file mode 100644
> > index 0000000..a2f1eae
> > --- /dev/null
> > +++ b/drivers/media/platform/vsp1/vsp1_hgt.h
> > @@ -0,0 +1,51 @@
> > +/*
> > + * vsp1_hgt.h  --  R-Car VSP1 Histogram Generator 2D
> > + *
> > + * Copyright (C) 2016 Renesas Electronics Corporation
> > + *
> > + * Contact: Niklas Söderlund (niklas.soderlund@ragnatech.se)
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + */
> > +#ifndef __VSP1_HGT_H__
> > +#define __VSP1_HGT_H__
> > +
> > +#include <media/media-entity.h>
> > +#include <media/v4l2-ctrls.h>
> > +#include <media/v4l2-subdev.h>
> > +
> > +#include "vsp1_entity.h"
> > +#include "vsp1_histo.h"
> > +
> > +struct vsp1_device;
> > +
> > +#define HGT_PAD_SINK				0
> > +#define HGT_PAD_SOURCE				1
> > +
> > +#define HGT_NUM_HUE_AREAS			12
> 
> Technically speaking there are 6 areas. I would thus define HGT_NUM_HUE_AREAS 
> as equal to 6, and either use HGT_NUM_HUE_AREAS * 2 or modify the code to 
> process the lower and upper boundaries separately.

Will fix in v2.

> 
> > +struct vsp1_hgt {
> > +	struct vsp1_entity entity;
> > +	struct vsp1_histogram histo;
> > +
> > +	struct {
> > +		struct v4l2_ctrl_handler handler;
> > +		struct v4l2_ctrl *hue_areas;
> 
> You don't need to store the hue_areas control in the vsp1_hgt structure, the 
> value is only used in vsp1_hgt_create() where it can be stored in a local 
> variable. You can thus get rid of the ctrls structure and just add a struct 
> v4l2_ctrl_handler ctrls field.
> 

Will fix in v2.

> > +	} ctrls;
> > +
> > +	unsigned int hue_area[HGT_NUM_HUE_AREAS];
> 
> Shouldn't this be called hue_areas ?
> 
> Using u8 would save a bit of memory, but possibly at the expense of the .text 
> size. Could you check that ?

Will check and update if it makes sens.

> 
> > +};
> > +
> > +
> 
> A single blank line will do.

Yes.

> 
> > +static inline struct vsp1_hgt *to_hgt(struct v4l2_subdev *subdev)
> > +{
> > +	return container_of(subdev, struct vsp1_hgt, entity.subdev);
> > +}
> > +
> > +struct vsp1_hgt *vsp1_hgt_create(struct vsp1_device *vsp1);
> > +void vsp1_hgt_frame_end(struct vsp1_entity *hgt);
> > +
> > +#endif /* __VSP1_HGT_H__ */
> 
> [snip]
> 

-- 
Regards,
Niklas Söderlund
