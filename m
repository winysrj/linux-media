Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-15.mail.aliyun.com ([115.124.20.15]:41012 "EHLO
        out20-15.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752906AbeGEHst (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 03:48:49 -0400
Date: Thu, 5 Jul 2018 15:48:02 +0800
From: Yong <yong.deng@magewell.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Thierry Reding <treding@nvidia.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v10 2/2] media: V3s: Add support for Allwinner CSI.
Message-Id: <20180705154802.03604f156709be11892b19c0@magewell.com>
In-Reply-To: <20180626110821.wkal6fcnoncsze6y@valkosipuli.retiisi.org.uk>
References: <1525417745-37964-1-git-send-email-yong.deng@magewell.com>
        <20180626110821.wkal6fcnoncsze6y@valkosipuli.retiisi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tue, 26 Jun 2018 14:08:21 +0300
Sakari Ailus <sakari.ailus@iki.fi> wrote:

> Hi Yong,
> 
> My apologies for taking so long to review the set. A few comments below.
> 
> On Fri, May 04, 2018 at 03:09:05PM +0800, Yong Deng wrote:
> > Allwinner V3s SoC features two CSI module. CSI0 is used for MIPI CSI-2
> > interface and CSI1 is used for parallel interface. This is not
> > documented in datasheet but by test and guess.
> > 
> > This patch implement a v4l2 framework driver for it.
> > 
> > Currently, the driver only support the parallel interface. MIPI-CSI2,
> > ISP's support are not included in this patch.
> > 
> > Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> > Reviewed-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > Tested-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > Signed-off-by: Yong Deng <yong.deng@magewell.com>
> > ---
> >  MAINTAINERS                                        |   8 +
> >  drivers/media/platform/Kconfig                     |   1 +
> >  drivers/media/platform/Makefile                    |   2 +
> >  drivers/media/platform/sunxi/sun6i-csi/Kconfig     |   9 +
> >  drivers/media/platform/sunxi/sun6i-csi/Makefile    |   3 +
> >  drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 932 +++++++++++++++++++++
> >  drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h | 145 ++++
> >  .../media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h | 196 +++++
> >  .../media/platform/sunxi/sun6i-csi/sun6i_video.c   | 767 +++++++++++++++++
> >  .../media/platform/sunxi/sun6i-csi/sun6i_video.h   |  53 ++
> >  10 files changed, 2116 insertions(+)
> >  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/Kconfig
> >  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/Makefile
> >  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> >  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h
> >  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h
> >  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
> >  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_video.h
> > 

... 

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
> 
> If the driver exposes format configuration through the V4L2 sub-device API,
> trying the format on the video node should limit to the DMA engine only.
> I.e. what the upstream sub-device can (or cannot) do is not relevant here.
> 
> The pipeline there may well be longer than just an image sensor
> represented by just a single sub-device.

OK. I will check the formats in link validation when streaming is started.

> 
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
> > +
> > +	pixfmt->bytesperline = (pixfmt->width * csi_fmt->bpp) >> 3;
> > +	pixfmt->sizeimage = pixfmt->bytesperline * pixfmt->height;
> > +
> > +	if (current_fmt)
> > +		*current_fmt = csi_fmt;
> > +
> > +	return 0;
> > +}
> > +

...

> > +
> > +/* -----------------------------------------------------------------------------
> > + * Media Operations
> > + */
> > +static int sun6i_video_formats_init(struct sun6i_video *video,
> > +				    const struct media_pad *remote)
> > +{
> > +	struct v4l2_subdev_mbus_code_enum mbus_code = { 0 };
> > +	struct sun6i_csi *csi = video->csi;
> > +	struct v4l2_format format;
> > +	struct v4l2_subdev *subdev;
> > +	u32 pad;
> > +	const u32 *pixformats;
> > +	int pixformat_count = 0;
> > +	u32 subdev_codes[32]; /* subdev format codes, 32 should be enough */
> > +	int codes_count = 0;
> > +	int num_fmts = 0;
> > +	int i, j;
> > +
> > +	pad = remote->index;
> > +	subdev = media_entity_to_v4l2_subdev(remote->entity);
> > +	if (subdev == NULL)
> > +		return -ENXIO;
> > +
> > +	/* Get supported pixformats of CSI */
> > +	pixformat_count = sun6i_csi_get_supported_pixformats(csi, &pixformats);
> > +	if (pixformat_count <= 0)
> > +		return -ENXIO;
> > +
> > +	/* Get subdev formats codes */
> > +	mbus_code.pad = pad;
> > +	mbus_code.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> > +	while (!v4l2_subdev_call(subdev, pad, enum_mbus_code, NULL,
> > +				 &mbus_code)) {
> 
> The formats supported by the external sub-device may depend on horizontal
> and vertical flipping. You shouldn't assume any particular configuration
> here: instead, bridge drivers generally just need to make sure the formats
> match in link validation when streaming is started. At least the CSI-2
> receiver driver and the DMA engine driver (video device) should check the
> configuration is valid. See e.g. the IPU3 driver:
> drivers/media/pci/intel/ipu3/ipu3-cio2.c .

Can mbus_code be added dynamically ?
The code here only enum the mbus code and get the possible supported
pairs of pixformat and mbus by SoC. Not try to check if the formats
(width height ...) is valid or not. The formats validation will be 
in link validation when streaming is started as per your advise. 

> 
> > +		if (codes_count >= ARRAY_SIZE(subdev_codes)) {
> > +			dev_warn(video->csi->dev,
> > +				 "subdev_codes array is full!\n");
> > +			break;
> > +		}
> > +		subdev_codes[codes_count] = mbus_code.code;
> > +		codes_count++;
> > +		mbus_code.index++;
> > +	}
> > +
> > +	if (!codes_count)
> > +		return -ENXIO;
> > +
> > +	/* Get supported formats count */
> > +	for (i = 0; i < codes_count; i++) {
> > +		for (j = 0; j < pixformat_count; j++) {
> > +			if (!sun6i_csi_is_format_supported(csi, pixformats[j],
> > +					subdev_codes[i])) {
> > +				continue;
> > +			}
> > +			num_fmts++;
> > +		}
> > +	}
> > +
> > +	if (!num_fmts)
> > +		return -ENXIO;
> > +
> > +	video->num_formats = num_fmts;
> > +	video->formats = devm_kcalloc(video->csi->dev, num_fmts,
> > +			sizeof(struct sun6i_csi_format), GFP_KERNEL);
> > +	if (!video->formats)
> > +		return -ENOMEM;
> > +
> > +	/* Get supported formats */
> > +	num_fmts = 0;
> > +	for (i = 0; i < codes_count; i++) {
> > +		for (j = 0; j < pixformat_count; j++) {
> > +			if (!sun6i_csi_is_format_supported(csi, pixformats[j],
> > +					subdev_codes[i])) {
> > +				continue;
> > +			}
> > +
> > +			video->formats[num_fmts].pixformat = pixformats[j];
> > +			video->formats[num_fmts].mbus_code = subdev_codes[i];
> > +			video->formats[num_fmts].bpp =
> > +					sun6i_csi_get_bpp(pixformats[j]);
> > +			num_fmts++;
> > +		}
> > +	}
> > +
> > +	/* setup default format */
> > +	format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> > +	format.fmt.pix.width = 1280;
> > +	format.fmt.pix.height = 720;
> > +	format.fmt.pix.pixelformat = video->formats[0].pixformat;
> > +	sun6i_video_set_fmt(video, &format);
> > +
> > +	return 0;
> > +}
> > +

...

> 
> -- 
> Kind regards,
> 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi


Thanks,
Yong
