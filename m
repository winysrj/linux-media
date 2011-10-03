Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:65092 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209Ab1JCP3Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Oct 2011 11:29:25 -0400
Date: Mon, 3 Oct 2011 17:29:23 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Deepthy Ravi <deepthy.ravi@ti.com>
Subject: Re: [PATCH 7/9] V4L: soc-camera: add a Media Controller wrapper
In-Reply-To: <201110031305.41253.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1110031700330.16384@axis700.grange>
References: <1317313137-4403-1-git-send-email-g.liakhovetski@gmx.de>
 <1317313137-4403-8-git-send-email-g.liakhovetski@gmx.de>
 <201110031305.41253.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent

Thanks for the reviews!

On Mon, 3 Oct 2011, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> Thanks for the patch.
> 
> On Thursday 29 September 2011 18:18:55 Guennadi Liakhovetski wrote:
> > This wrapper adds a Media Controller implementation to soc-camera drivers.
> > To really benefit from it individual host drivers should implement support
> > for values of enum soc_camera_target other than SOCAM_TARGET_PIPELINE in
> > their .set_fmt() and .try_fmt() methods.
> 
> [snip]
> 
> > diff --git a/drivers/media/video/soc_entity.c
> > b/drivers/media/video/soc_entity.c new file mode 100644
> > index 0000000..3a04700
> > --- /dev/null
> > +++ b/drivers/media/video/soc_entity.c
> > @@ -0,0 +1,284 @@
> 
> [snip]
> 
> > +static int bus_sd_pad_g_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh
> > *fh,
> > +			    struct v4l2_subdev_format *sd_fmt)
> > +{
> > +	struct soc_camera_device *icd = v4l2_get_subdevdata(sd);
> > +	struct v4l2_mbus_framefmt *f = &sd_fmt->format;
> > +
> > +	if (sd_fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> > +		sd_fmt->format = *v4l2_subdev_get_try_format(fh, sd_fmt->pad);
> > +		return 0;
> > +	}
> > +
> > +	if (sd_fmt->pad == SOC_HOST_BUS_PAD_SINK) {
> > +		f->width	= icd->host_input_width;
> > +		f->height	= icd->host_input_height;
> > +	} else {
> > +		f->width	= icd->user_width;
> > +		f->height	= icd->user_height;
> > +	}
> > +	f->field	= icd->field;
> > +	f->code		= icd->current_fmt->code;
> > +	f->colorspace	= icd->colorspace;
> 
> Can soc-camera hosts perform format conversion ? If so you will likely need to 
> store the mbus code for the input and output separately, possibly in 
> v4l2_mbus_format fields. You could then simplify the [gs]_fmt functions by 
> implementing similar to the __*_get_format functions in the OMAP3 ISP driver.

They can, yes. But, under soc-camera conversions are performed between 
mediabus codes and fourcc formats. Upon pipeline construction (probing) a 
table of format conversions is built, where hosts generate one or more 
translation entries for all client formats, that they support. The only 
example of a more complex translations so far is MIPI CSI-2, but even 
there we have decided to identify CSI-2 formats using the same media-bus 
codes, as what you "get" "between" the CSI-2 block and the DMA engine. For 
the only CSI-2 capable soc-camera host so far - the CEU driver - this is 
also a very natural representation, because there the CSI-2 block is 
indeed an additional pipeline stage, uniquely translating CSI-2 to 
media-bus codes, that are then fed to the CEU parallel port.

> 
> > +	return 0;
> > +}
> > +
> > +static int bus_sd_pad_s_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh
> > *fh,
> > +			    struct v4l2_subdev_format *sd_fmt)
> > +{
> > +	struct soc_camera_device *icd = v4l2_get_subdevdata(sd);
> > +	struct v4l2_mbus_framefmt *mf = &sd_fmt->format;
> > +	struct v4l2_format vf = {
> > +		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> > +	};
> > +	enum soc_camera_target tgt = sd_fmt->pad == SOC_HOST_BUS_PAD_SINK ?
> > +		SOCAM_TARGET_HOST_IN : SOCAM_TARGET_HOST_OUT;
> > +	int ret;
> > +
> > +	se_mbus_to_v4l2(icd, mf, &vf);
> > +
> > +	if (sd_fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> > +		struct v4l2_mbus_framefmt *try_fmt =
> > +			v4l2_subdev_get_try_format(fh, sd_fmt->pad);
> > +		ret = soc_camera_try_fmt(icd, &vf, tgt);
> > +		if (!ret) {
> > +			se_v4l2_to_mbus(icd, &vf, try_fmt);
> > +			sd_fmt->format = *try_fmt;
> > +		}
> > +		return ret;
> > +	}
> > +
> > +	ret = soc_camera_set_fmt(icd, &vf, tgt);
> > +	if (!ret)
> > +		se_v4l2_to_mbus(icd, &vf, &sd_fmt->format);
> > +
> > +	return ret;
> > +}
> > +
> > +static int bus_sd_pad_enum_mbus_code(struct v4l2_subdev *sd,
> > +				     struct v4l2_subdev_fh *fh,
> > +				     struct v4l2_subdev_mbus_code_enum *ce)
> > +{
> > +	struct soc_camera_device *icd = v4l2_get_subdevdata(sd);
> > +
> > +	if (ce->index >= icd->num_user_formats)
> > +		return -EINVAL;
> > +
> > +	ce->code = icd->user_formats[ce->index].code;
> > +	return 0;
> > +}
> > +
> > +static const struct v4l2_subdev_pad_ops se_bus_sd_pad_ops = {
> > +	.get_fmt	= bus_sd_pad_g_fmt,
> > +	.set_fmt	= bus_sd_pad_s_fmt,
> > +	.enum_mbus_code	= bus_sd_pad_enum_mbus_code,
> > +};
> > +
> > +static const struct v4l2_subdev_ops se_bus_sd_ops = {
> > +	.pad		= &se_bus_sd_pad_ops,
> > +};
> > +
> > +static const struct media_entity_operations se_bus_me_ops = {
> > +};
> > +
> > +static const struct media_entity_operations se_vdev_me_ops = {
> > +};
> 
> NULL operations are allowed, you don't have to use an empty structure.

Ok

> > +
> > +int soc_camera_mc_streamon(struct soc_camera_device *icd)
> > +{
> > +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> > +	struct v4l2_subdev *bus_sd = &ici->bus_sd;
> > +	struct media_entity *bus_me = &bus_sd->entity;
> > +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> > +	struct v4l2_mbus_framefmt mf;
> > +	int ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
> > +	if (WARN_ON(ret < 0))
> > +		return ret;
> > +	if (icd->host_input_width != mf.width ||
> > +	    icd->host_input_height != mf.height ||
> > +	    icd->current_fmt->code != mf.code)
> > +		return -EINVAL;
> 
> Shouldn't you also check that the source pad format matches the video node 
> format ?

I think, that's true by construction. It is already cheked in 
soc_camera_set_fmt():

	} else if (!icd->current_fmt ||
		   icd->current_fmt->host_fmt->fourcc != pix->pixelformat) {
		dev_err(icd->pdev,
			"Host driver hasn't set up current format correctly!\n");
		return -EINVAL;


> 
> > +
> > +	media_entity_pipeline_start(bus_me, &ici->pipe);
> > +	return 0;
> > +}
> > +
> > +void soc_camera_mc_streamoff(struct soc_camera_device *icd)
> > +{
> > +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> > +	struct v4l2_subdev *bus_sd = &ici->bus_sd;
> > +	struct media_entity *bus_me = &bus_sd->entity;
> > +	media_entity_pipeline_stop(bus_me);
> > +}
> > +
> > +int soc_camera_mc_install(struct soc_camera_device *icd)
> > +{
> > +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> > +	struct v4l2_subdev *bus_sd = &ici->bus_sd;
> > +	struct media_entity *bus_me = &bus_sd->entity;
> > +	struct media_pad *bus_pads = ici->bus_pads;
> > +	struct media_pad *vdev_pads = ici->vdev_pads;
> > +	struct video_device *vdev = icd->vdev;
> > +	struct media_entity *vdev_me = &vdev->entity;
> > +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> > +	int ret;
> > +
> > +	if (!ici->v4l2_dev.mdev || soc_entity_native_mc(icd))
> > +		return 0;
> > +
> > +	/* Configure the video bus subdevice, entity, and pads */
> > +	v4l2_subdev_init(bus_sd, &se_bus_sd_ops);
> > +	v4l2_set_subdevdata(bus_sd, icd);
> > +	bus_sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> > +	snprintf(bus_sd->name, sizeof(bus_sd->name), "%s input", ici->drv_name);
> > +
> > +	bus_pads[SOC_HOST_BUS_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
> > +	bus_pads[SOC_HOST_BUS_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
> > +	bus_me->ops = &se_bus_me_ops;
> > +
> > +	ret = media_entity_init(bus_me, 2, bus_pads, 0);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	/* Configure the video-device entity */
> > +	vdev_pads[SOC_HOST_VDEV_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
> > +	vdev_me->ops = &se_vdev_me_ops;
> > +
> > +	ret = media_entity_init(vdev_me, 1, vdev_pads, 0);
> > +	if (ret < 0)
> > +		goto evmei;
> > +
> > +	/* Link the two entities */
> > +	ret = media_entity_create_link(bus_me, SOC_HOST_BUS_PAD_SOURCE,
> > +				vdev_me, SOC_HOST_VDEV_PAD_SINK,
> > +				MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED);
> > +	if (ret < 0)
> > +		goto elink;
> > +
> > +	ret = v4l2_device_register_subdev(&ici->v4l2_dev, bus_sd);
> > +	if (ret < 0)
> > +		goto eregsd;
> > +
> > +	ret = v4l2_device_register_subdev_nodes(&ici->v4l2_dev);
> > +	if (ret < 0)
> > +		goto eregsdn;
> > +
> > +	/*
> > +	 * Link the client: make it immutable too for now, since there is no
> > +	 * meaningful mapping for the .link_setup() method to the soc-camera
> > +	 * API
> > +	 */
> > +	ret = media_entity_create_link(&sd->entity, 0,
> > +				bus_me, SOC_HOST_BUS_PAD_SINK,
> > +				MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED);
> > +	if (ret < 0)
> > +		goto eclink;
> 
> Qhat do you think about moving this above subdev registration ?

I don't yet:-) But yes, perhaps, this can be done.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
