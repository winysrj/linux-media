Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-75.mail.aliyun.com ([115.124.20.75]:53922 "EHLO
        out20-75.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750885AbeCICat (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2018 21:30:49 -0500
Date: Fri, 9 Mar 2018 10:30:29 +0800
From: Yong <yong.deng@magewell.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v9 2/2] media: V3s: Add support for Allwinner CSI.
Message-Id: <20180309103029.cc7047d4edaf1728b225054c@magewell.com>
In-Reply-To: <20180306151418.5hts7jwgndi7qzsx@paasikivi.fi.intel.com>
References: <1520302562-1577-1-git-send-email-yong.deng@magewell.com>
        <20180306151418.5hts7jwgndi7qzsx@paasikivi.fi.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tue, 6 Mar 2018 17:14:18 +0200
Sakari Ailus <sakari.ailus@linux.intel.com> wrote:

> Hi Yong,
> 
> Thanks for the patchset; please see my comments below.
> 
> On Tue, Mar 06, 2018 at 10:16:02AM +0800, Yong Deng wrote:
> > Allwinner V3s SoC features two CSI module. CSI0 is used for MIPI CSI-2
> > interface and CSI1 is used for parallel interface. This is not
> > documented in datasheet but by test and guess.

...

> > +
> > +static const u32 supported_pixformats[] = {
> > +	V4L2_PIX_FMT_SBGGR8,
> > +	V4L2_PIX_FMT_SGBRG8,
> > +	V4L2_PIX_FMT_SGRBG8,
> > +	V4L2_PIX_FMT_SRGGB8,
> > +	V4L2_PIX_FMT_SBGGR10,
> > +	V4L2_PIX_FMT_SGBRG10,
> > +	V4L2_PIX_FMT_SGRBG10,
> > +	V4L2_PIX_FMT_SRGGB10,
> > +	V4L2_PIX_FMT_SBGGR12,
> > +	V4L2_PIX_FMT_SGBRG12,
> > +	V4L2_PIX_FMT_SGRBG12,
> > +	V4L2_PIX_FMT_SRGGB12,
> > +	V4L2_PIX_FMT_YUYV,
> > +	V4L2_PIX_FMT_YVYU,
> > +	V4L2_PIX_FMT_UYVY,
> > +	V4L2_PIX_FMT_VYUY,
> > +	V4L2_PIX_FMT_HM12,
> > +	V4L2_PIX_FMT_NV12,
> > +	V4L2_PIX_FMT_NV21,
> > +	V4L2_PIX_FMT_YUV420,
> > +	V4L2_PIX_FMT_YVU420,
> > +	V4L2_PIX_FMT_NV16,
> > +	V4L2_PIX_FMT_NV61,
> > +	V4L2_PIX_FMT_YUV422P,
> > +};
> 
> How about moving this where it's actually used? You'd also get rid of the
> function to obtain this list.

I think which formats are supported is determined by hardware (CSI).
And different SoCs may support different formats. The distinction will
be made in sun6i-csi.c.

> 
> > +
> > +static inline struct sun6i_csi_dev *sun6i_csi_to_dev(struct sun6i_csi *csi)
> > +{
> > +	return container_of(csi, struct sun6i_csi_dev, csi);
> > +}
> > +
> > +int sun6i_csi_get_supported_pixformats(struct sun6i_csi *csi,
> > +				       const u32 **pixformats)
> > +{
> > +	if (pixformats != NULL)
> > +		*pixformats = supported_pixformats;
> > +
> > +	return ARRAY_SIZE(supported_pixformats);
> > +}
> > +
> > +/* TODO add 10&12 bit YUV, RGB support */
> > +bool sun6i_csi_is_format_support(struct sun6i_csi *csi,
> 
> s/support/supported/

OK.

> 
> > +				 u32 pixformat, u32 mbus_code)
> > +{
> > +	struct sun6i_csi_dev *sdev = sun6i_csi_to_dev(csi);
> > +
> > +	/*
> > +	 * Some video receivers have the ability to be compatible with
> > +	 * 8bit and 16bit bus width.
> > +	 * Identify the media bus format from device tree.
> > +	 */
> > +	if ((sdev->csi.v4l2_ep.bus_type == V4L2_MBUS_PARALLEL
> > +	      || sdev->csi.v4l2_ep.bus_type == V4L2_MBUS_BT656)
> > +	     && sdev->csi.v4l2_ep.bus.parallel.bus_width == 16) {
> > +		switch (pixformat) {
> > +		case V4L2_PIX_FMT_HM12:
> > +		case V4L2_PIX_FMT_NV12:
> > +		case V4L2_PIX_FMT_NV21:
> > +		case V4L2_PIX_FMT_NV16:
> > +		case V4L2_PIX_FMT_NV61:
> > +		case V4L2_PIX_FMT_YUV420:
> > +		case V4L2_PIX_FMT_YVU420:
> > +		case V4L2_PIX_FMT_YUV422P:
> > +			switch (mbus_code) {
> > +			case MEDIA_BUS_FMT_UYVY8_1X16:
> > +			case MEDIA_BUS_FMT_VYUY8_1X16:
> > +			case MEDIA_BUS_FMT_YUYV8_1X16:
> > +			case MEDIA_BUS_FMT_YVYU8_1X16:
> > +				return true;
> > +			default:
> > +				dev_dbg(sdev->dev, "Unsupported mbus code: 0x%x\n",
> > +					mbus_code);
> > +				break;
> > +			}
> > +			break;
> > +		default:
> > +			dev_dbg(sdev->dev, "Unsupported pixformat: 0x%x\n",
> > +				pixformat);
> > +			break;
> > +		}
> > +		return false;
> > +	}
> > +
> > +	switch (pixformat) {
> > +	case V4L2_PIX_FMT_SBGGR8:
> > +		return (mbus_code == MEDIA_BUS_FMT_SBGGR8_1X8);
> > +	case V4L2_PIX_FMT_SGBRG8:
> > +		return (mbus_code == MEDIA_BUS_FMT_SGBRG8_1X8);
> > +	case V4L2_PIX_FMT_SGRBG8:
> > +		return (mbus_code == MEDIA_BUS_FMT_SGRBG8_1X8);
> > +	case V4L2_PIX_FMT_SRGGB8:
> > +		return (mbus_code == MEDIA_BUS_FMT_SRGGB8_1X8);
> > +	case V4L2_PIX_FMT_SBGGR10:
> > +		return (mbus_code == MEDIA_BUS_FMT_SBGGR10_1X10);
> > +	case V4L2_PIX_FMT_SGBRG10:
> > +		return (mbus_code == MEDIA_BUS_FMT_SGBRG10_1X10);
> > +	case V4L2_PIX_FMT_SGRBG10:
> > +		return (mbus_code == MEDIA_BUS_FMT_SGRBG10_1X10);
> > +	case V4L2_PIX_FMT_SRGGB10:
> > +		return (mbus_code == MEDIA_BUS_FMT_SRGGB10_1X10);
> > +	case V4L2_PIX_FMT_SBGGR12:
> > +		return (mbus_code == MEDIA_BUS_FMT_SBGGR12_1X12);
> > +	case V4L2_PIX_FMT_SGBRG12:
> > +		return (mbus_code == MEDIA_BUS_FMT_SGBRG12_1X12);
> > +	case V4L2_PIX_FMT_SGRBG12:
> > +		return (mbus_code == MEDIA_BUS_FMT_SGRBG12_1X12);
> > +	case V4L2_PIX_FMT_SRGGB12:
> > +		return (mbus_code == MEDIA_BUS_FMT_SRGGB12_1X12);
> > +
> > +	case V4L2_PIX_FMT_YUYV:
> > +		return (mbus_code == MEDIA_BUS_FMT_YUYV8_2X8);
> > +	case V4L2_PIX_FMT_YVYU:
> > +		return (mbus_code == MEDIA_BUS_FMT_YVYU8_2X8);
> > +	case V4L2_PIX_FMT_UYVY:
> > +		return (mbus_code == MEDIA_BUS_FMT_UYVY8_2X8);
> > +	case V4L2_PIX_FMT_VYUY:
> > +		return (mbus_code == MEDIA_BUS_FMT_VYUY8_2X8);
> > +
> > +	case V4L2_PIX_FMT_HM12:
> > +	case V4L2_PIX_FMT_NV12:
> > +	case V4L2_PIX_FMT_NV21:
> > +	case V4L2_PIX_FMT_NV16:
> > +	case V4L2_PIX_FMT_NV61:
> > +	case V4L2_PIX_FMT_YUV420:
> > +	case V4L2_PIX_FMT_YVU420:
> > +	case V4L2_PIX_FMT_YUV422P:
> > +		switch (mbus_code) {
> > +		case MEDIA_BUS_FMT_UYVY8_2X8:
> > +		case MEDIA_BUS_FMT_VYUY8_2X8:
> > +		case MEDIA_BUS_FMT_YUYV8_2X8:
> > +		case MEDIA_BUS_FMT_YVYU8_2X8:
> > +			return true;
> > +		default:
> > +			dev_dbg(sdev->dev, "Unsupported mbus code: 0x%x\n",
> > +				mbus_code);
> > +			break;
> > +		}
> > +		break;
> > +	default:
> > +		dev_dbg(sdev->dev, "Unsupported pixformat: 0x%x\n", pixformat);
> > +		break;
> > +	}
> > +
> > +	return false;
> > +}
> > +
> > +int sun6i_csi_set_power(struct sun6i_csi *csi, bool enable)
> 
> How about switching to runtime PM? I do admit there have been reasons why
> subdevs used the s_power callback but CSI-2 receivers should have hardly
> done that for a long, long time.

I don't understand you very much. But this works well and have been tested.
And I am not familiar with runtime PM.

> 
> > +{
> > +	struct sun6i_csi_dev *sdev = sun6i_csi_to_dev(csi);
> > +	struct regmap *regmap = sdev->regmap;
> > +	int ret;
> > +
> > +	if (!enable) {
> > +		regmap_update_bits(regmap, CSI_EN_REG, CSI_EN_CSI_EN, 0);
> > +
> > +		clk_disable_unprepare(sdev->clk_ram);
> > +		clk_disable_unprepare(sdev->clk_mod);
> > +		reset_control_assert(sdev->rstc_bus);
> > +		return 0;
> > +	}
> > +
> > +	ret = clk_prepare_enable(sdev->clk_mod);
> > +	if (ret) {
> > +		dev_err(sdev->dev, "Enable csi clk err %d\n", ret);
> > +		return ret;
> > +	}
> > +
> > +	ret = clk_prepare_enable(sdev->clk_ram);
> > +	if (ret) {
> > +		dev_err(sdev->dev, "Enable clk_dram_csi clk err %d\n", ret);
> > +		return ret;
> > +	}
> > +
> > +	ret = reset_control_deassert(sdev->rstc_bus);
> > +	if (ret) {
> > +		dev_err(sdev->dev, "reset err %d\n", ret);
> > +		return ret;
> > +	}
> > +
> > +	regmap_update_bits(regmap, CSI_EN_REG, CSI_EN_CSI_EN, CSI_EN_CSI_EN);
> > +
> > +	return 0;
> > +}
> > +

...

> > +
> > +/* -----------------------------------------------------------------------------
> > + * Media Controller and V4L2
> > + */
> > +static int sun6i_csi_link_entity(struct sun6i_csi *csi,
> > +				 struct media_entity *entity)
> > +{
> > +	struct media_entity *sink;
> > +	struct media_pad *sink_pad;
> > +	int ret;
> > +	int i;
> > +
> > +	if (!entity->num_pads) {
> > +		dev_err(csi->dev, "%s: invalid entity\n", entity->name);
> > +		return -EINVAL;
> > +	}
> > +
> > +	for (i = 0; i < entity->num_pads; i++) {
> > +		if (entity->pads[i].flags & MEDIA_PAD_FL_SOURCE)
> > +			break;
> 
> I think you're looking for a pad corresponding to an fwnode. Could you use
> media_entity_get_fwnode_pad()?

OK.

> 
> > +	}
> > +
> > +	if (i == entity->num_pads) {
> > +		dev_err(csi->dev, "%s: no source pad in external entity %s\n",
> > +			__func__, entity->name);
> > +		return -EINVAL;
> > +	}
> > +
> > +	sink = &csi->video.vdev.entity;
> > +	sink_pad = &csi->video.pad;
> > +
> > +	dev_dbg(csi->dev, "creating %s:%u -> %s:%u link\n",
> > +		entity->name, i, sink->name, sink_pad->index);
> > +	ret = media_create_pad_link(entity, i, sink, sink_pad->index,
> > +				    MEDIA_LNK_FL_ENABLED);
> > +	if (ret < 0) {
> > +		dev_err(csi->dev, "failed to create %s:%u -> %s:%u link\n",
> > +			entity->name, i, sink->name, sink_pad->index);
> > +		return ret;
> > +	}
> > +
> > +	return media_entity_call(sink, link_setup, sink_pad, &entity->pads[i],
> > +				 MEDIA_LNK_FL_ENABLED);
> 
> In general there's no need to call the link setup function this way outside
> the MC framework. Is there a reason for doing so here?

Do you mean use media_entity_setup_link instead? 

> 
> > +}
> > +
> > +static int sun6i_subdev_notify_complete(struct v4l2_async_notifier *notifier)
> > +{
> > +	struct sun6i_csi *csi = container_of(notifier, struct sun6i_csi,
> > +					     notifier);
> > +	struct v4l2_device *v4l2_dev = &csi->v4l2_dev;
> > +	struct v4l2_subdev *sd;
> > +	int ret;
> > +
> > +	dev_dbg(csi->dev, "notify complete, all subdevs registered\n");
> > +
> > +	if (notifier->num_subdevs != 1)
> > +		return -EINVAL;
> > +
> > +	sd = list_first_entry(&v4l2_dev->subdevs, struct v4l2_subdev, list);
> > +	if (sd == NULL)
> > +		return -EINVAL;
> > +
> > +	ret = sun6i_csi_link_entity(csi, &sd->entity);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = v4l2_device_register_subdev_nodes(&csi->v4l2_dev);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	return media_device_register(&csi->media_dev);
> > +}
> > +
> > +static const struct v4l2_async_notifier_operations sun6i_csi_async_ops = {
> > +	.complete = sun6i_subdev_notify_complete,
> > +};
> > +

...

> > +
> > +static struct vb2_ops sun6i_csi_vb2_ops = {
> 
> const

OK.

> 
> > +	.queue_setup		= sun6i_video_queue_setup,
> > +	.wait_prepare		= vb2_ops_wait_prepare,
> > +	.wait_finish		= vb2_ops_wait_finish,
> > +	.buf_prepare		= sun6i_video_buffer_prepare,
> > +	.start_streaming	= sun6i_video_start_streaming,
> > +	.stop_streaming		= sun6i_video_stop_streaming,
> > +	.buf_queue		= sun6i_video_buffer_queue,
> > +};
> > +
> > +static int vidioc_querycap(struct file *file, void *priv,
> > +				struct v4l2_capability *cap)
> > +{
> > +	struct sun6i_video *video = video_drvdata(file);
> > +
> > +	strlcpy(cap->driver, "sun6i-video", sizeof(cap->driver));
> > +	strlcpy(cap->card, video->vdev.name, sizeof(cap->card));
> > +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
> > +		 video->csi->dev->of_node->name);
> > +
> > +	return 0;
> > +}
> > +
> > +static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
> > +				   struct v4l2_fmtdesc *f)
> > +{
> > +	struct sun6i_video *video = video_drvdata(file);
> > +	u32 index = f->index;
> > +
> > +	if (index >= video->num_formats)
> > +		return -EINVAL;
> > +
> > +	f->pixelformat = video->formats[index].pixformat;
> > +
> > +	return 0;
> > +}
> > +
> > +static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
> > +				struct v4l2_format *fmt)
> > +{
> > +	struct sun6i_video *video = video_drvdata(file);
> > +
> > +	*fmt = video->fmt;
> > +
> > +	return 0;
> > +}
> > +
> > +
> > +static int sun6i_video_try_fmt_source(struct sun6i_video *video,
> > +				      u32 which,
> > +				      struct v4l2_pix_format *pixfmt,
> > +				      struct sun6i_csi_format *csi_fmt)
> > +{
> > +	struct v4l2_subdev *subdev;
> > +	struct v4l2_subdev_pad_config *pad_cfg;
> > +	struct v4l2_subdev_format format = {
> > +		.which = which,
> > +	};
> > +	u32 pad;
> > +	int ret;
> > +
> > +	subdev = sun6i_video_remote_subdev(video, &pad);
> > +	if (subdev == NULL)
> > +		return -ENXIO;
> > +
> > +	v4l2_fill_mbus_format(&format.format, pixfmt, csi_fmt->mbus_code);
> > +
> > +	pad_cfg = v4l2_subdev_alloc_pad_config(subdev);
> > +	if (pad_cfg == NULL)
> > +		return -ENOMEM;
> > +
> > +	format.pad = pad;
> > +	ret = v4l2_subdev_call(subdev, pad, set_fmt, pad_cfg, &format);
> > +	if (ret)
> > +		goto done;
> > +
> > +	v4l2_fill_pix_format(pixfmt, &format.format);
> > +
> > +done:
> > +	v4l2_subdev_free_pad_config(pad_cfg);
> > +	return ret;
> > +}
> > +
> > +static int sun6i_video_try_fmt(struct sun6i_video *video, u32 which,
> > +			       struct v4l2_format *f,
> > +			       struct sun6i_csi_format **current_fmt)
> > +{
> > +	struct sun6i_csi_format *csi_fmt;
> > +	struct v4l2_pix_format *pixfmt = &f->fmt.pix;
> > +	int ret;
> > +
> > +	csi_fmt = find_format_by_pixformat(video, pixfmt->pixelformat);
> > +	if (csi_fmt == NULL) {
> > +		if (video->num_formats > 0) {
> > +			csi_fmt = &video->formats[0];
> > +			pixfmt->pixelformat = csi_fmt->pixformat;
> > +		} else
> > +			return -EINVAL;
> > +	}
> > +
> > +	ret = sun6i_video_try_fmt_source(video, which, pixfmt, csi_fmt);
> > +	if (ret)
> > +		return ret;
> 
> As the rest of the driver supports the media controller, I'd refrain from
> checking the format on the external sub-device here. That format may change
> later on without the knowledge of the sun6i-csi driver. It may, for
> instance, be changed by the user.
> 
> Instead, you should have a link_validate op in the media_entity_operations
> struct set for your sub-device and the video node. That guarantees that the
> links are properly validated before streaming starts.
> 
> Typically MC-centric drivers only query format information and sometimes
> controls from the external devices.

If so, the user will can't get a hint when setting a unsupported format 
but get error only when starting the stream. This will make it impossible
for users to find out where the problem is.

I think if the user want to change the format of sub-device through 
sub-device node, he should do it before setting the format of v4l2 device.

> 
> > +
> > +	pixfmt->bytesperline = (pixfmt->width * csi_fmt->bpp) >> 3;
> 
> Is there line alignment or something for the device?

I am not sure. This is not documented.

> 
> > +	pixfmt->sizeimage = (pixfmt->width * csi_fmt->bpp * pixfmt->height) / 8;
> 
> pixfmt->bytesperline * pixfmt->height

OK.

> 
> 
> > +
> > +	if (current_fmt)
> > +		*current_fmt = csi_fmt;
> > +
> > +	return 0;
> > +}
> > +
> > +static int sun6i_video_set_fmt(struct sun6i_video *video, struct v4l2_format *f)
> > +{
> > +	struct sun6i_csi_format *current_fmt;
> > +	int ret;
> > +
> > +	ret = sun6i_video_try_fmt(video, V4L2_SUBDEV_FORMAT_ACTIVE, f,
> > +				  &current_fmt);
> > +	if (ret)
> > +		return ret;
> > +
> > +	video->fmt = *f;
> > +	video->current_fmt = current_fmt;
> > +
> > +	return 0;
> > +}
> > +
> > +static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
> > +				struct v4l2_format *f)
> > +{
> > +	struct sun6i_video *video = video_drvdata(file);
> > +
> > +	if (vb2_is_busy(&video->vb2_vidq))
> > +		return -EBUSY;
> > +
> > +	return sun6i_video_set_fmt(video, f);
> > +}
> > +
> > +static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
> > +				  struct v4l2_format *f)
> > +{
> > +	struct sun6i_video *video = video_drvdata(file);
> > +
> > +	return sun6i_video_try_fmt(video, V4L2_SUBDEV_FORMAT_TRY, f, NULL);
> > +}
> > +
> > +static int vidioc_enum_input(struct file *file, void *fh,
> > +			 struct v4l2_input *inp)
> > +{
> > +	struct sun6i_video *video = video_drvdata(file);
> > +	struct v4l2_subdev *subdev;
> > +	u32 pad;
> > +	int ret;
> > +
> > +	if (inp->index != 0)
> > +		return -EINVAL;
> > +
> > +	subdev = sun6i_video_remote_subdev(video, &pad);
> > +	if (subdev == NULL)
> > +		return -ENXIO;
> > +
> > +	ret = v4l2_subdev_call(subdev, video, g_input_status, &inp->status);
> > +	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
> > +		return ret;
> > +
> > +	inp->type = V4L2_INPUT_TYPE_CAMERA;
> 
> What does the input status mean for a camera? How about removing it?

Set it to zero?

> 
> > +
> > +	inp->capabilities = 0;
> > +	inp->std = 0;
> > +	if (v4l2_subdev_has_op(subdev, pad, dv_timings_cap))
> > +		inp->capabilities = V4L2_IN_CAP_DV_TIMINGS;
> > +
> > +	strlcpy(inp->name, subdev->name, sizeof(inp->name));
> > +
> > +	return 0;
> > +}

...

> 
> -- 
> Kind regards,
> 
> Sakari Ailus
> sakari.ailus@linux.intel.com


Thanks,
Yong
