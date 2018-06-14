Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:55227 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755168AbeFNPrr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 11:47:47 -0400
Message-ID: <85a70336e73f88500c71b8d104b234ecbd717099.camel@bootlin.com>
Subject: Re: [PATCH v3 11/14] media: platform: Add Sunxi-Cedrus VPU decoder
 driver
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Florent Revest <florent.revest@free-electrons.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Randy Li <ayaka@soulik.info>
Date: Thu, 14 Jun 2018 17:47:44 +0200
In-Reply-To: <daf66c3c-d5a1-2cf2-433e-56bcef7f69ce@xs4all.nl>
References: <20180507124500.20434-1-paul.kocialkowski@bootlin.com>
         <20180507124500.20434-12-paul.kocialkowski@bootlin.com>
         <daf66c3c-d5a1-2cf2-433e-56bcef7f69ce@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-4wSAGWpL0aInLhDHnk+v"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-4wSAGWpL0aInLhDHnk+v
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 2018-05-07 at 16:02 +0200, Hans Verkuil wrote:
> On 07/05/18 14:44, Paul Kocialkowski wrote:
> > This introduces the Sunxi-Cedrus VPU driver that supports the VPU found
> > in Allwinner SoCs, also known as Video Engine. It is implemented throug=
h
> > a v4l2 m2m decoder device and a media device (used for media requests).
> > So far, it only supports MPEG2 decoding.
> >=20
> > Since this VPU is stateless, synchronization with media requests is
> > required in order to ensure consistency between frame headers that
> > contain metadata about the frame to process and the raw slice data that
> > is used to generate the frame.
> >=20
> > This driver was made possible thanks to the long-standing effort
> > carried out by the linux-sunxi community in the interest of reverse
> > engineering, documenting and implementing support for Allwinner VPU.
> >=20
> > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> > ---
> >  MAINTAINERS                                        |   7 +
> >  drivers/media/platform/Kconfig                     |  15 +
> >  drivers/media/platform/Makefile                    |   1 +
> >  drivers/media/platform/sunxi/cedrus/Makefile       |   4 +
> >  drivers/media/platform/sunxi/cedrus/sunxi_cedrus.c | 333 +++++++++++++=
+
> >  .../platform/sunxi/cedrus/sunxi_cedrus_common.h    | 128 ++++++
> >  .../media/platform/sunxi/cedrus/sunxi_cedrus_dec.c | 188 ++++++++
> >  .../media/platform/sunxi/cedrus/sunxi_cedrus_dec.h |  35 ++
> >  .../media/platform/sunxi/cedrus/sunxi_cedrus_hw.c  | 240 ++++++++++
> >  .../media/platform/sunxi/cedrus/sunxi_cedrus_hw.h  |  37 ++
> >  .../platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c     | 160 +++++++
> >  .../platform/sunxi/cedrus/sunxi_cedrus_mpeg2.h     |  33 ++
> >  .../platform/sunxi/cedrus/sunxi_cedrus_regs.h      | 175 +++++++
> >  .../platform/sunxi/cedrus/sunxi_cedrus_video.c     | 505 +++++++++++++=
++++++++
> >  .../platform/sunxi/cedrus/sunxi_cedrus_video.h     |  31 ++
> >  15 files changed, 1892 insertions(+)
> >  create mode 100644 drivers/media/platform/sunxi/cedrus/Makefile
> >  create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus.c
> >  create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_co=
mmon.h
> >  create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_de=
c.c
> >  create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_de=
c.h
> >  create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw=
.c
> >  create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw=
.h
> >  create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mp=
eg2.c
> >  create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mp=
eg2.h
> >  create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_re=
gs.h
> >  create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_vi=
deo.c
> >  create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_vi=
deo.h
> >=20
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 79bb02ff812f..489f1dccc810 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -656,6 +656,13 @@ L:	linux-crypto@vger.kernel.org
> >  S:	Maintained
> >  F:	drivers/crypto/sunxi-ss/
> > =20
> > +ALLWINNER VPU DRIVER
> > +M:	Maxime Ripard <maxime.ripard@bootlin.com>
> > +M:	Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> > +L:	linux-media@vger.kernel.org
> > +S:	Maintained
> > +F:	drivers/media/platform/sunxi/cedrus/
> > +
> >  ALPHA PORT
> >  M:	Richard Henderson <rth@twiddle.net>
> >  M:	Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> > diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kc=
onfig
> > index 5af07b620094..72d37cd2f7a2 100644
> > --- a/drivers/media/platform/Kconfig
> > +++ b/drivers/media/platform/Kconfig
> > @@ -476,6 +476,21 @@ config VIDEO_TI_VPE
> >  	  Support for the TI VPE(Video Processing Engine) block
> >  	  found on DRA7XX SoC.
> > =20
> > +config VIDEO_SUNXI_CEDRUS
> > +	tristate "Sunxi-Cedrus VPU driver"
> > +	depends on VIDEO_DEV && VIDEO_V4L2 && MEDIA_CONTROLLER
> > +	depends on ARCH_SUNXI
> > +	depends on HAS_DMA
> > +	select VIDEOBUF2_DMA_CONTIG
> > +	select MEDIA_REQUEST_API
> > +	select V4L2_MEM2MEM_DEV
> > +	---help---
> > +	  Support for the VPU found in Allwinner SoCs, also known as the Ceda=
r
> > +	  video engine.
> > +
> > +	  To compile this driver as a module, choose M here: the module
> > +	  will be called sunxi-cedrus.
> > +
> >  config VIDEO_TI_VPE_DEBUG
> >  	bool "VPE debug messages"
> >  	depends on VIDEO_TI_VPE
> > diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/M=
akefile
> > index 932515df4477..444b995424a5 100644
> > --- a/drivers/media/platform/Makefile
> > +++ b/drivers/media/platform/Makefile
> > @@ -69,6 +69,7 @@ obj-$(CONFIG_VIDEO_ROCKCHIP_RGA)	+=3D rockchip/rga/
> >  obj-y	+=3D omap/
> > =20
> >  obj-$(CONFIG_VIDEO_AM437X_VPFE)		+=3D am437x/
> > +obj-$(CONFIG_VIDEO_SUNXI_CEDRUS)	+=3D sunxi/cedrus/
> > =20
> >  obj-$(CONFIG_VIDEO_XILINX)		+=3D xilinx/
> > =20
> > diff --git a/drivers/media/platform/sunxi/cedrus/Makefile b/drivers/med=
ia/platform/sunxi/cedrus/Makefile
> > new file mode 100644
> > index 000000000000..98f30df626a9
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi/cedrus/Makefile
> > @@ -0,0 +1,4 @@
> > +obj-$(CONFIG_VIDEO_SUNXI_CEDRUS) +=3D sunxi-cedrus.o
> > +
> > +sunxi-cedrus-y =3D sunxi_cedrus.o sunxi_cedrus_video.o sunxi_cedrus_hw=
.o \
> > +		 sunxi_cedrus_dec.o sunxi_cedrus_mpeg2.o
> > diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus.c b/drive=
rs/media/platform/sunxi/cedrus/sunxi_cedrus.c
> > new file mode 100644
> > index 000000000000..ccd41d9a3e41
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus.c
> > @@ -0,0 +1,333 @@
> > +/*
> > + * Sunxi-Cedrus VPU driver
> > + *
> > + * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com=
>
> > + * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.co=
m>
> > + *
> > + * Based on the vim2m driver, that is:
> > + *
> > + * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
> > + * Pawel Osciak, <pawel@osciak.com>
> > + * Marek Szyprowski, <m.szyprowski@samsung.com>
> > + *
> > + * This software is licensed under the terms of the GNU General Public
> > + * License version 2, as published by the Free Software Foundation, an=
d
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/platform_device.h>
> > +#include <linux/module.h>
> > +#include <linux/of.h>
> > +
> > +#include <media/videobuf2-dma-contig.h>
> > +#include <media/v4l2-device.h>
> > +#include <media/v4l2-ioctl.h>
> > +#include <media/v4l2-ctrls.h>
> > +#include <media/v4l2-mem2mem.h>
> > +
> > +#include "sunxi_cedrus_common.h"
> > +#include "sunxi_cedrus_video.h"
> > +#include "sunxi_cedrus_dec.h"
> > +#include "sunxi_cedrus_hw.h"
> > +
> > +static int sunxi_cedrus_s_ctrl(struct v4l2_ctrl *ctrl)
> > +{
> > +	struct sunxi_cedrus_ctx *ctx =3D
> > +		container_of(ctrl->handler, struct sunxi_cedrus_ctx, hdl);
> > +
> > +	switch (ctrl->id) {
> > +	case V4L2_CID_MPEG_VIDEO_MPEG2_FRAME_HDR:
> > +		/* This is kept in memory and used directly. */
>=20
> Is there any validation done/needed for the contents of this control?
>=20
> I noticed it is just ignored in std_validate() in v4l2-ctrls.c, but I exp=
ected
> to see some validation here.
>=20
> What happens if someone puts in rubbish data? How robust is the hardware?

I agree, there is definitely a lack of validation here and it is badly
needed. Especially when it comes to the reference frames indices, that
are used directly to address arrays elements at one point.

Since it seems beneficial to add this for all users of this structure,
it's best to add it in a common place. I'll investigate std_validate for
the next revision then.=20

> > +		break;
> > +	default:
> > +		v4l2_err(&ctx->dev->v4l2_dev, "Invalid control\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct v4l2_ctrl_ops sunxi_cedrus_ctrl_ops =3D {
> > +	.s_ctrl =3D sunxi_cedrus_s_ctrl,
> > +};
> > +
> > +static const struct sunxi_cedrus_control controls[] =3D {
> > +	[SUNXI_CEDRUS_CTRL_DEC_MPEG2_FRAME_HDR] =3D {
> > +		.id		=3D V4L2_CID_MPEG_VIDEO_MPEG2_FRAME_HDR,
> > +		.elem_size	=3D sizeof(struct v4l2_ctrl_mpeg2_frame_hdr),
> > +	},
> > +};
> > +
> > +static int sunxi_cedrus_init_ctrls(struct sunxi_cedrus_dev *dev,
> > +				   struct sunxi_cedrus_ctx *ctx)
> > +{
> > +	struct v4l2_ctrl_handler *hdl =3D &ctx->hdl;
> > +	unsigned int num_ctrls =3D ARRAY_SIZE(controls);
> > +	unsigned int i;
> > +
> > +	v4l2_ctrl_handler_init(hdl, num_ctrls);
> > +	if (hdl->error) {
> > +		dev_err(dev->dev, "Couldn't initialize our control handler\n");
> > +		return hdl->error;
> > +	}
> > +
> > +	for (i =3D 0; i < num_ctrls; i++) {
> > +		struct v4l2_ctrl_config cfg =3D { 0 };
> > +
> > +		cfg.ops =3D &sunxi_cedrus_ctrl_ops;
> > +		cfg.elem_size =3D controls[i].elem_size;
> > +		cfg.id =3D controls[i].id;
> > +
> > +		ctx->ctrls[i] =3D v4l2_ctrl_new_custom(hdl, &cfg, NULL);
> > +		if (hdl->error) {
> > +			v4l2_ctrl_handler_free(hdl);
> > +			return hdl->error;
> > +		}
> > +	}
> > +
> > +	ctx->fh.ctrl_handler =3D hdl;
> > +	v4l2_ctrl_handler_setup(hdl);
>=20
> This initializes the header with all zeroes, is that what you want?
> Just checking.

I guess the underlying point here is that we should somehow check that a
proper header was passed, overriding the zero-ed default.

Otherwise, I doubt that feeding zero values to the hardware will cause
any substantial issue (but I should really double-check that).

What do you think?

> > +
> > +	return 0;
> > +}
> > +
> > +static void sunxi_cedrus_deinit_ctrls(struct sunxi_cedrus_dev *dev,
> > +				      struct sunxi_cedrus_ctx *ctx)
> > +{
> > +	unsigned int num_ctrls =3D ARRAY_SIZE(controls);
> > +	unsigned int i;
> > +
> > +	v4l2_ctrl_handler_free(&ctx->hdl);
> > +	for (i =3D 0; i < num_ctrls; i++)
> > +		ctx->ctrls[0] =3D NULL;
>=20
> Is this necessary? Since ctx is freed right after this call?

You're right, it most likely is not.

> > +}
> > +
> > +static int sunxi_cedrus_open(struct file *file)
> > +{
> > +	struct sunxi_cedrus_dev *dev =3D video_drvdata(file);
> > +	struct sunxi_cedrus_ctx *ctx =3D NULL;
> > +	int rc;
> > +
> > +	if (mutex_lock_interruptible(&dev->dev_mutex))
> > +		return -ERESTARTSYS;
> > +
> > +	ctx =3D kzalloc(sizeof(*ctx), GFP_KERNEL);
> > +	if (!ctx) {
> > +		mutex_unlock(&dev->dev_mutex);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	INIT_WORK(&ctx->run_work, sunxi_cedrus_device_work);
> > +
> > +	INIT_LIST_HEAD(&ctx->src_list);
> > +	INIT_LIST_HEAD(&ctx->dst_list);
> > +
> > +	v4l2_fh_init(&ctx->fh, video_devdata(file));
> > +	file->private_data =3D &ctx->fh;
> > +	ctx->dev =3D dev;
> > +
> > +	rc =3D sunxi_cedrus_init_ctrls(dev, ctx);
> > +	if (rc)
> > +		goto err_free;
> > +
> > +	ctx->fh.m2m_ctx =3D v4l2_m2m_ctx_init(dev->m2m_dev, ctx,
> > +					    &sunxi_cedrus_queue_init);
> > +	if (IS_ERR(ctx->fh.m2m_ctx)) {
> > +		rc =3D PTR_ERR(ctx->fh.m2m_ctx);
> > +		goto err_ctrl_deinit;
> > +	}
> > +
> > +	v4l2_fh_add(&ctx->fh);
> > +
> > +	dev_dbg(dev->dev, "Created instance: %p, m2m_ctx: %p\n",
> > +		ctx, ctx->fh.m2m_ctx);
> > +
> > +	mutex_unlock(&dev->dev_mutex);
> > +	return 0;
> > +
> > +err_ctrl_deinit:
> > +	sunxi_cedrus_deinit_ctrls(dev, ctx);
> > +err_free:
> > +	kfree(ctx);
> > +	mutex_unlock(&dev->dev_mutex);
> > +	return rc;
> > +}
> > +
> > +static int sunxi_cedrus_release(struct file *file)
> > +{
> > +	struct sunxi_cedrus_dev *dev =3D video_drvdata(file);
> > +	struct sunxi_cedrus_ctx *ctx =3D container_of(file->private_data,
> > +			struct sunxi_cedrus_ctx, fh);
> > +
> > +	dev_dbg(dev->dev, "Releasing instance %p\n", ctx);
> > +
> > +	mutex_lock(&dev->dev_mutex);
> > +	v4l2_fh_del(&ctx->fh);
> > +	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
> > +	sunxi_cedrus_deinit_ctrls(dev, ctx);
> > +	v4l2_fh_exit(&ctx->fh);
> > +	v4l2_fh_exit(&ctx->fh);
> > +	kfree(ctx);
> > +	mutex_unlock(&dev->dev_mutex);
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct v4l2_file_operations sunxi_cedrus_fops =3D {
> > +	.owner		=3D THIS_MODULE,
> > +	.open		=3D sunxi_cedrus_open,
> > +	.release	=3D sunxi_cedrus_release,
> > +	.poll		=3D v4l2_m2m_fop_poll,
> > +	.unlocked_ioctl	=3D video_ioctl2,
> > +	.mmap		=3D v4l2_m2m_fop_mmap,
> > +};
> > +
> > +static const struct video_device sunxi_cedrus_video_device =3D {
> > +	.name		=3D SUNXI_CEDRUS_NAME,
> > +	.vfl_dir	=3D VFL_DIR_M2M,
> > +	.fops		=3D &sunxi_cedrus_fops,
> > +	.ioctl_ops	=3D &sunxi_cedrus_ioctl_ops,
> > +	.minor		=3D -1,
> > +	.release	=3D video_device_release_empty,
> > +};
> > +
> > +static const struct v4l2_m2m_ops sunxi_cedrus_m2m_ops =3D {
> > +	.device_run	=3D sunxi_cedrus_device_run,
> > +	.job_abort	=3D sunxi_cedrus_job_abort,
> > +};
> > +
> > +static const struct media_device_ops sunxi_cedrus_m2m_media_ops =3D {
> > +	.req_validate =3D vb2_request_validate,
> > +	.req_queue =3D vb2_m2m_request_queue,
> > +};
> > +
> > +static int sunxi_cedrus_probe(struct platform_device *pdev)
> > +{
> > +	struct sunxi_cedrus_dev *dev;
> > +	struct video_device *vfd;
> > +	int ret;
> > +
> > +	dev =3D devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
> > +	if (!dev)
> > +		return -ENOMEM;
> > +
> > +	dev->dev =3D &pdev->dev;
> > +	dev->pdev =3D pdev;
> > +
> > +	ret =3D sunxi_cedrus_hw_probe(dev);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Failed to probe hardware\n");
> > +		return ret;
> > +	}
> > +
> > +	mutex_init(&dev->dev_mutex);
> > +	spin_lock_init(&dev->irq_lock);
> > +
> > +	dev->vfd =3D sunxi_cedrus_video_device;
> > +	vfd =3D &dev->vfd;
> > +	vfd->lock =3D &dev->dev_mutex;
> > +	vfd->v4l2_dev =3D &dev->v4l2_dev;
> > +
> > +	dev->mdev.dev =3D &pdev->dev;
> > +	strlcpy(dev->mdev.model, SUNXI_CEDRUS_NAME, sizeof(dev->mdev.model));
> > +	media_device_init(&dev->mdev);
> > +	dev->mdev.ops =3D &sunxi_cedrus_m2m_media_ops;
> > +	dev->v4l2_dev.mdev =3D &dev->mdev;
> > +	dev->pad[0].flags =3D MEDIA_PAD_FL_SINK;
> > +	dev->pad[1].flags =3D MEDIA_PAD_FL_SOURCE;
> > +	ret =3D media_entity_pads_init(&vfd->entity, 2, dev->pad);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret =3D v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
> > +	if (ret)
> > +		goto unreg_media;
> > +
> > +	ret =3D video_register_device(vfd, VFL_TYPE_GRABBER, 0);
> > +	if (ret) {
> > +		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
> > +		goto unreg_dev;
> > +	}
> > +
> > +	video_set_drvdata(vfd, dev);
> > +	snprintf(vfd->name, sizeof(vfd->name), "%s",
> > +		 sunxi_cedrus_video_device.name);
> > +	v4l2_info(&dev->v4l2_dev,
> > +		  "Device registered as /dev/video%d\n", vfd->num);
> > +
> > +	platform_set_drvdata(pdev, dev);
> > +
> > +	dev->m2m_dev =3D v4l2_m2m_init(&sunxi_cedrus_m2m_ops);
> > +	if (IS_ERR(dev->m2m_dev)) {
> > +		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem device\n");
> > +		ret =3D PTR_ERR(dev->m2m_dev);
> > +		goto err_m2m;
> > +	}
> > +
> > +	/* Register the media device node */
> > +	ret =3D media_device_register(&dev->mdev);
> > +	if (ret)
> > +		goto err_m2m;
> > +
> > +	return 0;
> > +
> > +err_m2m:
> > +	v4l2_m2m_release(dev->m2m_dev);
> > +	video_unregister_device(&dev->vfd);
> > +unreg_media:
> > +	media_device_unregister(&dev->mdev);
> > +unreg_dev:
> > +	v4l2_device_unregister(&dev->v4l2_dev);
> > +
> > +	return ret;
> > +}
> > +
> > +static int sunxi_cedrus_remove(struct platform_device *pdev)
> > +{
> > +	struct sunxi_cedrus_dev *dev =3D platform_get_drvdata(pdev);
> > +
> > +	v4l2_info(&dev->v4l2_dev, "Removing " SUNXI_CEDRUS_NAME);
> > +
> > +	if (media_devnode_is_registered(dev->mdev.devnode)) {
> > +		media_device_unregister(&dev->mdev);
> > +		media_device_cleanup(&dev->mdev);
> > +	}
> > +
> > +	v4l2_m2m_release(dev->m2m_dev);
> > +	video_unregister_device(&dev->vfd);
> > +	v4l2_device_unregister(&dev->v4l2_dev);
> > +	sunxi_cedrus_hw_remove(dev);
> > +
> > +	return 0;
> > +}
> > +
> > +#ifdef CONFIG_OF
> > +static const struct of_device_id of_sunxi_cedrus_match[] =3D {
> > +	{ .compatible =3D "allwinner,sun4i-a10-video-engine" },
> > +	{ .compatible =3D "allwinner,sun5i-a13-video-engine" },
> > +	{ .compatible =3D "allwinner,sun7i-a20-video-engine" },
> > +	{ .compatible =3D "allwinner,sun8i-a33-video-engine" },
> > +	{ /* sentinel */ }
> > +};
> > +MODULE_DEVICE_TABLE(of, of_sunxi_cedrus_match);
> > +#endif
> > +
> > +static struct platform_driver sunxi_cedrus_driver =3D {
> > +	.probe		=3D sunxi_cedrus_probe,
> > +	.remove		=3D sunxi_cedrus_remove,
> > +	.driver		=3D {
> > +		.name	=3D SUNXI_CEDRUS_NAME,
> > +		.owner =3D THIS_MODULE,
> > +		.of_match_table =3D of_match_ptr(of_sunxi_cedrus_match),
> > +	},
> > +};
> > +module_platform_driver(sunxi_cedrus_driver);
> > +
> > +MODULE_LICENSE("GPL v2");
> > +MODULE_AUTHOR("Florent Revest <florent.revest@free-electrons.com>");
> > +MODULE_DESCRIPTION("Sunxi-Cedrus VPU driver");
> > diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h =
b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> > new file mode 100644
> > index 000000000000..ee6883ef9cb7
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> > @@ -0,0 +1,128 @@
> > +/*
> > + * Sunxi-Cedrus VPU driver
> > + *
> > + * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com=
>
> > + * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.co=
m>
> > + *
> > + * Based on the vim2m driver, that is:
> > + *
> > + * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
> > + * Pawel Osciak, <pawel@osciak.com>
> > + * Marek Szyprowski, <m.szyprowski@samsung.com>
> > + *
> > + * This software is licensed under the terms of the GNU General Public
> > + * License version 2, as published by the Free Software Foundation, an=
d
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef _SUNXI_CEDRUS_COMMON_H_
> > +#define _SUNXI_CEDRUS_COMMON_H_
> > +
> > +#include <linux/platform_device.h>
> > +
> > +#include <media/videobuf2-v4l2.h>
> > +#include <media/v4l2-device.h>
> > +#include <media/v4l2-ctrls.h>
> > +
> > +#define SUNXI_CEDRUS_NAME	"sunxi-cedrus"
> > +
> > +enum sunxi_cedrus_control_id {
> > +	SUNXI_CEDRUS_CTRL_DEC_MPEG2_FRAME_HDR =3D 0,
> > +	SUNXI_CEDRUS_CTRL_MAX,
> > +};
> > +
> > +struct sunxi_cedrus_control {
> > +	u32	id;
> > +	u32	elem_size;
> > +};
> > +
> > +struct sunxi_cedrus_fmt {
> > +	u32 fourcc;
> > +	int depth;
> > +	u32 types;
> > +	unsigned int num_planes;
> > +};
> > +
> > +struct sunxi_cedrus_mpeg2_run {
> > +	const struct v4l2_ctrl_mpeg2_frame_hdr		*hdr;
> > +};
> > +
> > +struct sunxi_cedrus_run {
> > +	struct vb2_v4l2_buffer	*src;
> > +	struct vb2_v4l2_buffer	*dst;
> > +
> > +	union {
> > +		struct sunxi_cedrus_mpeg2_run	mpeg2;
> > +	};
> > +};
> > +
> > +struct sunxi_cedrus_ctx {
> > +	struct v4l2_fh fh;
> > +	struct sunxi_cedrus_dev	*dev;
> > +
> > +	struct sunxi_cedrus_fmt *vpu_src_fmt;
> > +	struct v4l2_pix_format_mplane src_fmt;
> > +	struct sunxi_cedrus_fmt *vpu_dst_fmt;
> > +	struct v4l2_pix_format_mplane dst_fmt;
> > +
> > +	struct v4l2_ctrl_handler hdl;
> > +	struct v4l2_ctrl *ctrls[SUNXI_CEDRUS_CTRL_MAX];
> > +
> > +	struct vb2_buffer *dst_bufs[VIDEO_MAX_FRAME];
> > +
> > +	int job_abort;
> > +
> > +	struct work_struct try_schedule_work;
> > +	struct work_struct run_work;
> > +	struct list_head src_list;
> > +	struct list_head dst_list;
> > +};
> > +
> > +struct sunxi_cedrus_buffer {
> > +	struct vb2_v4l2_buffer vb;
> > +	enum vb2_buffer_state state;
> > +	struct list_head list;
> > +};
> > +
> > +struct sunxi_cedrus_dev {
> > +	struct v4l2_device v4l2_dev;
> > +	struct video_device vfd;
> > +	struct media_device mdev;
> > +	struct media_pad pad[2];
> > +	struct platform_device *pdev;
> > +	struct device *dev;
> > +	struct v4l2_m2m_dev *m2m_dev;
> > +
> > +	/* Mutex for device file */
> > +	struct mutex dev_mutex;
> > +	/* Spinlock for interrupt */
> > +	spinlock_t irq_lock;
> > +
> > +	void __iomem		*base;
> > +
> > +	struct clk *mod_clk;
> > +	struct clk *ahb_clk;
> > +	struct clk *ram_clk;
> > +
> > +	struct reset_control *rstc;
> > +
> > +	struct regmap *syscon;
> > +};
> > +
> > +static inline void sunxi_cedrus_write(struct sunxi_cedrus_dev *dev,
> > +				      u32 val, u32 reg)
> > +{
> > +	writel(val, dev->base + reg);
> > +}
> > +
> > +static inline u32 sunxi_cedrus_read(struct sunxi_cedrus_dev *dev, u32 =
reg)
> > +{
> > +	return readl(dev->base + reg);
> > +}
> > +
> > +#endif
> > diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.c b/d=
rivers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.c
> > new file mode 100644
> > index 000000000000..8c92af34ebeb
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.c
> > @@ -0,0 +1,188 @@
> > +/*
> > + * Sunxi-Cedrus VPU driver
> > + *
> > + * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com=
>
> > + * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.co=
m>
> > + *
> > + * Based on the vim2m driver, that is:
> > + *
> > + * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
> > + * Pawel Osciak, <pawel@osciak.com>
> > + * Marek Szyprowski, <m.szyprowski@samsung.com>
> > + *
> > + * This software is licensed under the terms of the GNU General Public
> > + * License version 2, as published by the Free Software Foundation, an=
d
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <media/videobuf2-dma-contig.h>
> > +#include <media/v4l2-device.h>
> > +#include <media/v4l2-ioctl.h>
> > +#include <media/v4l2-ctrls.h>
> > +#include <media/v4l2-event.h>
> > +#include <media/v4l2-mem2mem.h>
> > +
> > +#include "sunxi_cedrus_common.h"
> > +#include "sunxi_cedrus_mpeg2.h"
> > +#include "sunxi_cedrus_dec.h"
> > +#include "sunxi_cedrus_hw.h"
> > +
> > +static inline void *get_ctrl_ptr(struct sunxi_cedrus_ctx *ctx,
> > +				 enum sunxi_cedrus_control_id id)
> > +{
> > +	struct v4l2_ctrl *ctrl =3D ctx->ctrls[id];
> > +
> > +	return ctrl->p_cur.p;
> > +}
> > +
> > +void sunxi_cedrus_device_work(struct work_struct *work)
> > +{
> > +	struct sunxi_cedrus_ctx *ctx =3D container_of(work,
> > +			struct sunxi_cedrus_ctx, run_work);
> > +	struct sunxi_cedrus_buffer *buffer_entry;
> > +	struct vb2_v4l2_buffer *src_buf, *dst_buf;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&ctx->dev->irq_lock, flags);
> > +
> > +	if (list_empty(&ctx->src_list) ||
> > +	    list_empty(&ctx->dst_list)) {
> > +		pr_err("Empty source and/or destination buffers lists\n");
> > +		spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
> > +		return;
> > +	}
> > +
> > +	buffer_entry =3D list_last_entry(&ctx->src_list, struct sunxi_cedrus_=
buffer, list);
> > +	list_del(ctx->src_list.prev);
> > +
> > +	src_buf =3D &buffer_entry->vb;
> > +	v4l2_m2m_buf_done(src_buf, buffer_entry->state);
> > +
> > +	buffer_entry =3D list_last_entry(&ctx->dst_list, struct sunxi_cedrus_=
buffer, list);
> > +	list_del(ctx->dst_list.prev);
> > +
> > +	dst_buf =3D &buffer_entry->vb;
> > +	v4l2_m2m_buf_done(dst_buf, buffer_entry->state);
> > +
> > +	spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
> > +
> > +	v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->fh.m2m_ctx);
> > +}
> > +
> > +void sunxi_cedrus_device_run(void *priv)
> > +{
> > +	struct sunxi_cedrus_ctx *ctx =3D priv;
> > +	struct sunxi_cedrus_run run =3D { 0 };
> > +	struct media_request *src_req, *dst_req;
> > +	unsigned long flags;
> > +	bool mpeg1 =3D false;
> > +
> > +	run.src =3D v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
> > +	if (!run.src) {
> > +		v4l2_err(&ctx->dev->v4l2_dev,
> > +			 "No source buffer to prepare\n");
> > +		return;
> > +	}
> > +
> > +	run.dst =3D v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
> > +	if (!run.dst) {
> > +		v4l2_err(&ctx->dev->v4l2_dev,
> > +			 "No destination buffer to prepare\n");
> > +		return;
> > +	}
> > +
> > +	/* Apply request(s) controls if needed. */
> > +	src_req =3D run.src->vb2_buf.req_obj.req;
> > +	dst_req =3D run.dst->vb2_buf.req_obj.req;
> > +
> > +	if (src_req)
> > +		v4l2_ctrl_request_setup(src_req, &ctx->hdl);
> > +
> > +	if (dst_req && dst_req !=3D src_req)
> > +		v4l2_ctrl_request_setup(dst_req, &ctx->hdl);
> > +
> > +	ctx->job_abort =3D 0;
> > +
> > +	spin_lock_irqsave(&ctx->dev->irq_lock, flags);
> > +
> > +	switch (ctx->vpu_src_fmt->fourcc) {
> > +	case V4L2_PIX_FMT_MPEG2_FRAME:
> > +		if (!ctx->ctrls[SUNXI_CEDRUS_CTRL_DEC_MPEG2_FRAME_HDR]) {
> > +			v4l2_err(&ctx->dev->v4l2_dev,
> > +				 "Invalid MPEG2 frame header control\n");
> > +			ctx->job_abort =3D 1;
> > +			goto unlock_complete;
> > +		}
> > +
> > +		run.mpeg2.hdr =3D get_ctrl_ptr(ctx, SUNXI_CEDRUS_CTRL_DEC_MPEG2_FRAM=
E_HDR);
> > +		sunxi_cedrus_mpeg2_setup(ctx, &run);
> > +
> > +		mpeg1 =3D run.mpeg2.hdr->type =3D=3D MPEG1;
> > +		break;
> > +
> > +	default:
> > +		ctx->job_abort =3D 1;
> > +	}
> > +
> > +unlock_complete:
> > +	spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
> > +
> > +	/* Complete request(s) controls if needed. */
> > +
> > +	if (src_req)
> > +		v4l2_ctrl_request_complete(src_req, &ctx->hdl);
> > +
> > +	if (dst_req && dst_req !=3D src_req)
> > +		v4l2_ctrl_request_complete(dst_req, &ctx->hdl);
> > +
> > +	spin_lock_irqsave(&ctx->dev->irq_lock, flags);
> > +
> > +	if (!ctx->job_abort) {
> > +		if (ctx->vpu_src_fmt->fourcc =3D=3D V4L2_PIX_FMT_MPEG2_FRAME)
> > +			sunxi_cedrus_mpeg2_trigger(ctx, mpeg1);
> > +	} else {
> > +		v4l2_m2m_buf_done(run.src, VB2_BUF_STATE_ERROR);
> > +		v4l2_m2m_buf_done(run.dst, VB2_BUF_STATE_ERROR);
> > +	}
> > +
> > +	spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
> > +
> > +	if (ctx->job_abort)
> > +		v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->fh.m2m_ctx);
> > +}
> > +
> > +void sunxi_cedrus_job_abort(void *priv)
> > +{
> > +	struct sunxi_cedrus_ctx *ctx =3D priv;
> > +	struct vb2_v4l2_buffer *src_buf, *dst_buf;
> > +	unsigned long flags;
> > +
> > +	ctx->job_abort =3D 1;
> > +
> > +	/*
> > +	 * V4L2 m2m and request API cleanup is done here while hardware state
> > +	 * cleanup is done in the interrupt context. Doing all the cleanup in
> > +	 * the interrupt context is a bit risky, since the job_abort call mig=
ht
> > +	 * originate from the release hook, where interrupts have already bee=
n
> > +	 * disabled.
> > +	 */
> > +
> > +	spin_lock_irqsave(&ctx->dev->irq_lock, flags);
> > +
> > +	src_buf =3D v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> > +	if (src_buf)
> > +		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
> > +
> > +	dst_buf =3D v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
> > +	if (dst_buf)
> > +		v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
> > +
> > +	spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
> > +
> > +	v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->fh.m2m_ctx);
> > +}
> > diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.h b/d=
rivers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.h
> > new file mode 100644
> > index 000000000000..9899b399b2ba
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.h
> > @@ -0,0 +1,35 @@
> > +/*
> > + * Sunxi-Cedrus VPU driver
> > + *
> > + * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com=
>
> > + * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.co=
m>
> > + *
> > + * Based on the vim2m driver, that is:
> > + *
> > + * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
> > + * Pawel Osciak, <pawel@osciak.com>
> > + * Marek Szyprowski, <m.szyprowski@samsung.com>
> > + *
> > + * This software is licensed under the terms of the GNU General Public
> > + * License version 2, as published by the Free Software Foundation, an=
d
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef _SUNXI_CEDRUS_DEC_H_
> > +#define _SUNXI_CEDRUS_DEC_H_
> > +
> > +extern const struct v4l2_ioctl_ops sunxi_cedrus_ioctl_ops;
> > +
> > +void sunxi_cedrus_device_work(struct work_struct *work);
> > +void sunxi_cedrus_device_run(void *priv);
> > +void sunxi_cedrus_job_abort(void *priv);
> > +
> > +int sunxi_cedrus_queue_init(void *priv, struct vb2_queue *src_vq,
> > +			    struct vb2_queue *dst_vq);
> > +
> > +#endif
> > diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c b/dr=
ivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c
> > new file mode 100644
> > index 000000000000..5783bd985855
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c
> > @@ -0,0 +1,240 @@
> > +/*
> > + * Sunxi-Cedrus VPU driver
> > + *
> > + * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com=
>
> > + * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.co=
m>
> > + *
> > + * Based on the vim2m driver, that is:
> > + *
> > + * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
> > + * Pawel Osciak, <pawel@osciak.com>
> > + * Marek Szyprowski, <m.szyprowski@samsung.com>
> > + *
> > + * This software is licensed under the terms of the GNU General Public
> > + * License version 2, as published by the Free Software Foundation, an=
d
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/platform_device.h>
> > +#include <linux/of_reserved_mem.h>
> > +#include <linux/dma-mapping.h>
> > +#include <linux/mfd/syscon.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/clk.h>
> > +#include <linux/regmap.h>
> > +#include <linux/reset.h>
> > +#include <linux/soc/sunxi/sunxi_sram.h>
> > +
> > +#include <media/videobuf2-core.h>
> > +#include <media/v4l2-mem2mem.h>
> > +
> > +#include "sunxi_cedrus_common.h"
> > +#include "sunxi_cedrus_hw.h"
> > +#include "sunxi_cedrus_regs.h"
> > +
> > +#define SYSCON_SRAM_CTRL_REG0	0x0
> > +#define SYSCON_SRAM_C1_MAP_VE	0x7fffffff
> > +
> > +int sunxi_cedrus_engine_enable(struct sunxi_cedrus_dev *dev,
> > +			       enum sunxi_cedrus_engine engine)
> > +{
> > +	u32 reg =3D 0;
> > +
> > +	/*
> > +	 * FIXME: This is only valid on 32-bits DDR's, we should test
> > +	 * it on the A13/A33.
> > +	 */
> > +	reg |=3D VE_CTRL_REC_WR_MODE_2MB;
> > +
> > +	reg |=3D VE_CTRL_CACHE_BUS_BW_128;
> > +
> > +	switch (engine) {
> > +	case SUNXI_CEDRUS_ENGINE_MPEG:
> > +		reg |=3D VE_CTRL_DEC_MODE_MPEG;
> > +		break;
> > +
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	sunxi_cedrus_write(dev, reg, VE_CTRL);
> > +	return 0;
> > +}
> > +
> > +void sunxi_cedrus_engine_disable(struct sunxi_cedrus_dev *dev)
> > +{
> > +	sunxi_cedrus_write(dev, VE_CTRL_DEC_MODE_DISABLED, VE_CTRL);
> > +}
> > +
> > +static irqreturn_t sunxi_cedrus_ve_irq(int irq, void *dev_id)
> > +{
> > +	struct sunxi_cedrus_dev *dev =3D dev_id;
> > +	struct sunxi_cedrus_ctx *ctx;
> > +	struct sunxi_cedrus_buffer *src_buffer, *dst_buffer;
> > +	struct vb2_v4l2_buffer *src_vb, *dst_vb;
> > +	unsigned long flags;
> > +	unsigned int value, status;
> > +
> > +	spin_lock_irqsave(&dev->irq_lock, flags);
> > +
> > +	/* Disable MPEG interrupts and stop the MPEG engine */
> > +	value =3D sunxi_cedrus_read(dev, VE_MPEG_CTRL);
> > +	sunxi_cedrus_write(dev, value & (~0xf), VE_MPEG_CTRL);
> > +
> > +	status =3D sunxi_cedrus_read(dev, VE_MPEG_STATUS);
> > +	sunxi_cedrus_write(dev, 0x0000c00f, VE_MPEG_STATUS);
> > +	sunxi_cedrus_engine_disable(dev);
> > +
> > +	ctx =3D v4l2_m2m_get_curr_priv(dev->m2m_dev);
> > +	if (!ctx) {
> > +		pr_err("Instance released before the end of transaction\n");
> > +		spin_unlock_irqrestore(&dev->irq_lock, flags);
> > +
> > +		return IRQ_HANDLED;
> > +	}
> > +
> > +	src_vb =3D v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> > +	dst_vb =3D v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
> > +
> > +	if (!src_vb || !dst_vb) {
> > +		pr_err("Unable to get source and/or destination buffers\n");
> > +		spin_unlock_irqrestore(&dev->irq_lock, flags);
> > +
> > +		return IRQ_HANDLED;
> > +	}
> > +
> > +	src_buffer =3D container_of(src_vb, struct sunxi_cedrus_buffer, vb);
> > +	dst_buffer =3D container_of(dst_vb, struct sunxi_cedrus_buffer, vb);
> > +
> > +	/* First bit of MPEG_STATUS indicates success. */
> > +	if (ctx->job_abort || !(status & 0x01))
> > +		src_buffer->state =3D dst_buffer->state =3D VB2_BUF_STATE_ERROR;
> > +	else
> > +		src_buffer->state =3D dst_buffer->state =3D VB2_BUF_STATE_DONE;
> > +
> > +	list_add_tail(&src_buffer->list, &ctx->src_list);
> > +	list_add_tail(&dst_buffer->list, &ctx->dst_list);
> > +
> > +	spin_unlock_irqrestore(&dev->irq_lock, flags);
> > +
> > +	schedule_work(&ctx->run_work);
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +int sunxi_cedrus_hw_probe(struct sunxi_cedrus_dev *dev)
> > +{
> > +	struct resource *res;
> > +	int irq_dec;
> > +	int ret;
> > +
> > +	irq_dec =3D platform_get_irq(dev->pdev, 0);
> > +	if (irq_dec <=3D 0) {
> > +		dev_err(dev->dev, "could not get ve IRQ\n");
> > +		return -ENXIO;
> > +	}
> > +	ret =3D devm_request_irq(dev->dev, irq_dec, sunxi_cedrus_ve_irq, 0,
> > +			       dev_name(dev->dev), dev);
> > +	if (ret) {
> > +		dev_err(dev->dev, "could not request ve IRQ\n");
> > +		return -ENXIO;
> > +	}
> > +
> > +	/*
> > +	 * The VPU is only able to handle bus addresses so we have to subtrac=
t
> > +	 * the RAM offset to the physcal addresses.
> > +	 */
> > +	dev->dev->dma_pfn_offset =3D PHYS_PFN_OFFSET;
> > +
> > +	ret =3D of_reserved_mem_device_init(dev->dev);
> > +	if (ret && ret !=3D -ENODEV) {
> > +		dev_err(dev->dev, "could not reserve memory\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	ret =3D sunxi_sram_claim(dev->dev);
> > +	if (ret) {
> > +		dev_err(dev->dev, "couldn't map SRAM to device\n");
> > +		return ret;
> > +	}
> > +
> > +	dev->ahb_clk =3D devm_clk_get(dev->dev, "ahb");
> > +	if (IS_ERR(dev->ahb_clk)) {
> > +		dev_err(dev->dev, "failed to get ahb clock\n");
> > +		return PTR_ERR(dev->ahb_clk);
> > +	}
> > +	dev->mod_clk =3D devm_clk_get(dev->dev, "mod");
> > +	if (IS_ERR(dev->mod_clk)) {
> > +		dev_err(dev->dev, "failed to get mod clock\n");
> > +		return PTR_ERR(dev->mod_clk);
> > +	}
> > +	dev->ram_clk =3D devm_clk_get(dev->dev, "ram");
> > +	if (IS_ERR(dev->ram_clk)) {
> > +		dev_err(dev->dev, "failed to get ram clock\n");
> > +		return PTR_ERR(dev->ram_clk);
> > +	}
> > +
> > +	dev->rstc =3D devm_reset_control_get(dev->dev, NULL);
> > +
> > +	res =3D platform_get_resource(dev->pdev, IORESOURCE_MEM, 0);
> > +	dev->base =3D devm_ioremap_resource(dev->dev, res);
> > +	if (!dev->base)
> > +		dev_err(dev->dev, "could not maps MACC registers\n");
> > +
> > +	dev->syscon =3D syscon_regmap_lookup_by_phandle(dev->dev->of_node,
> > +						      "syscon");
> > +	if (IS_ERR(dev->syscon)) {
> > +		dev->syscon =3D NULL;
> > +	} else {
> > +		regmap_write_bits(dev->syscon, SYSCON_SRAM_CTRL_REG0,
> > +				  SYSCON_SRAM_C1_MAP_VE,
> > +				  SYSCON_SRAM_C1_MAP_VE);
> > +	}
> > +
> > +	ret =3D clk_prepare_enable(dev->ahb_clk);
> > +	if (ret) {
> > +		dev_err(dev->dev, "could not enable ahb clock\n");
> > +		return -EFAULT;
> > +	}
> > +	ret =3D clk_prepare_enable(dev->mod_clk);
> > +	if (ret) {
> > +		clk_disable_unprepare(dev->ahb_clk);
> > +		dev_err(dev->dev, "could not enable mod clock\n");
> > +		return -EFAULT;
> > +	}
> > +	ret =3D clk_prepare_enable(dev->ram_clk);
> > +	if (ret) {
> > +		clk_disable_unprepare(dev->mod_clk);
> > +		clk_disable_unprepare(dev->ahb_clk);
> > +		dev_err(dev->dev, "could not enable ram clock\n");
> > +		return -EFAULT;
> > +	}
> > +
> > +	ret =3D reset_control_reset(dev->rstc);
> > +	if (ret) {
> > +		clk_disable_unprepare(dev->ram_clk);
> > +		clk_disable_unprepare(dev->mod_clk);
> > +		clk_disable_unprepare(dev->ahb_clk);
> > +		dev_err(dev->dev, "could not reset device\n");
> > +		return -EFAULT;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +void sunxi_cedrus_hw_remove(struct sunxi_cedrus_dev *dev)
> > +{
> > +	reset_control_assert(dev->rstc);
> > +
> > +	clk_disable_unprepare(dev->ram_clk);
> > +	clk_disable_unprepare(dev->mod_clk);
> > +	clk_disable_unprepare(dev->ahb_clk);
> > +
> > +	sunxi_sram_release(dev->dev);
> > +	of_reserved_mem_device_release(dev->dev);
> > +}
> > diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.h b/dr=
ivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.h
> > new file mode 100644
> > index 000000000000..34f3fae462a8
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.h
> > @@ -0,0 +1,37 @@
> > +/*
> > + * Sunxi-Cedrus VPU driver
> > + *
> > + * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com=
>
> > + * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.co=
m>
> > + *
> > + * Based on the vim2m driver, that is:
> > + *
> > + * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
> > + * Pawel Osciak, <pawel@osciak.com>
> > + * Marek Szyprowski, <m.szyprowski@samsung.com>
> > + *
> > + * This software is licensed under the terms of the GNU General Public
> > + * License version 2, as published by the Free Software Foundation, an=
d
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef _SUNXI_CEDRUS_HW_H_
> > +#define _SUNXI_CEDRUS_HW_H_
> > +
> > +enum sunxi_cedrus_engine {
> > +	SUNXI_CEDRUS_ENGINE_MPEG,
> > +};
> > +
> > +int sunxi_cedrus_engine_enable(struct sunxi_cedrus_dev *dev,
> > +			       enum sunxi_cedrus_engine engine);
> > +void sunxi_cedrus_engine_disable(struct sunxi_cedrus_dev *dev);
> > +
> > +int sunxi_cedrus_hw_probe(struct sunxi_cedrus_dev *dev);
> > +void sunxi_cedrus_hw_remove(struct sunxi_cedrus_dev *dev);
> > +
> > +#endif
> > diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c b=
/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c
> > new file mode 100644
> > index 000000000000..5be3e3b9ceef
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c
> > @@ -0,0 +1,160 @@
> > +/*
> > + * Sunxi-Cedrus VPU driver
> > + *
> > + * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com=
>
> > + * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.co=
m>
> > + *
> > + * Based on the vim2m driver, that is:
> > + *
> > + * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
> > + * Pawel Osciak, <pawel@osciak.com>
> > + * Marek Szyprowski, <m.szyprowski@samsung.com>
> > + *
> > + * This software is licensed under the terms of the GNU General Public
> > + * License version 2, as published by the Free Software Foundation, an=
d
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <media/videobuf2-dma-contig.h>
> > +
> > +#include "sunxi_cedrus_common.h"
> > +#include "sunxi_cedrus_hw.h"
> > +#include "sunxi_cedrus_regs.h"
> > +
> > +static const u8 mpeg_default_intra_quant[64] =3D {
> > +	 8, 16, 16, 19, 16, 19, 22, 22,
> > +	22, 22, 22, 22, 26, 24, 26, 27,
> > +	27, 27, 26, 26, 26, 26, 27, 27,
> > +	27, 29, 29, 29, 34, 34, 34, 29,
> > +	29, 29, 27, 27, 29, 29, 32, 32,
> > +	34, 34, 37, 38, 37, 35, 35, 34,
> > +	35, 38, 38, 40, 40, 40, 48, 48,
> > +	46, 46, 56, 56, 58, 69, 69, 83
> > +};
> > +
> > +#define m_iq(i) (((64 + i) << 8) | mpeg_default_intra_quant[i])
> > +
> > +static const u8 mpeg_default_non_intra_quant[64] =3D {
> > +	16, 16, 16, 16, 16, 16, 16, 16,
> > +	16, 16, 16, 16, 16, 16, 16, 16,
> > +	16, 16, 16, 16, 16, 16, 16, 16,
> > +	16, 16, 16, 16, 16, 16, 16, 16,
> > +	16, 16, 16, 16, 16, 16, 16, 16,
> > +	16, 16, 16, 16, 16, 16, 16, 16,
> > +	16, 16, 16, 16, 16, 16, 16, 16,
> > +	16, 16, 16, 16, 16, 16, 16, 16
> > +};
> > +
> > +#define m_niq(i) ((i << 8) | mpeg_default_non_intra_quant[i])
> > +
> > +void sunxi_cedrus_mpeg2_setup(struct sunxi_cedrus_ctx *ctx,
> > +			      struct sunxi_cedrus_run *run)
> > +{
> > +	struct sunxi_cedrus_dev *dev =3D ctx->dev;
> > +	const struct v4l2_ctrl_mpeg2_frame_hdr *frame_hdr =3D run->mpeg2.hdr;
> > +
> > +	u16 width =3D DIV_ROUND_UP(frame_hdr->width, 16);
> > +	u16 height =3D DIV_ROUND_UP(frame_hdr->height, 16);
> > +
> > +	u32 pic_header =3D 0;
> > +	u32 vld_len =3D frame_hdr->slice_len - frame_hdr->slice_pos;
> > +	int i;
> > +
> > +	struct vb2_buffer *fwd_vb2_buf, *bwd_vb2_buf;
> > +	dma_addr_t src_buf_addr, dst_luma_addr, dst_chroma_addr;
> > +	dma_addr_t fwd_luma =3D 0, fwd_chroma =3D 0, bwd_luma =3D 0, bwd_chro=
ma =3D 0;
> > +
> > +
> > +	fwd_vb2_buf =3D ctx->dst_bufs[frame_hdr->forward_ref_index];
> > +	if (fwd_vb2_buf) {
> > +		fwd_luma =3D vb2_dma_contig_plane_dma_addr(fwd_vb2_buf, 0);
> > +		fwd_chroma =3D vb2_dma_contig_plane_dma_addr(fwd_vb2_buf, 1);
> > +	}
> > +
> > +	bwd_vb2_buf =3D ctx->dst_bufs[frame_hdr->backward_ref_index];
> > +	if (bwd_vb2_buf) {
> > +		bwd_luma =3D vb2_dma_contig_plane_dma_addr(bwd_vb2_buf, 0);
> > +		bwd_chroma =3D vb2_dma_contig_plane_dma_addr(bwd_vb2_buf, 1);
> > +	}
> > +
> > +	/* Activate MPEG engine. */
> > +	sunxi_cedrus_engine_enable(dev, SUNXI_CEDRUS_ENGINE_MPEG);
> > +
> > +	/* Set quantization matrices. */
> > +	for (i =3D 0; i < 64; i++) {
> > +		sunxi_cedrus_write(dev, m_iq(i), VE_MPEG_IQ_MIN_INPUT);
> > +		sunxi_cedrus_write(dev, m_niq(i), VE_MPEG_IQ_MIN_INPUT);
> > +	}
> > +
> > +	/* Set frame dimensions. */
> > +	sunxi_cedrus_write(dev, width << 8 | height, VE_MPEG_SIZE);
> > +	sunxi_cedrus_write(dev, width << 20 | height << 4, VE_MPEG_FRAME_SIZE=
);
> > +
> > +	/* Set MPEG picture header. */
> > +	pic_header |=3D (frame_hdr->picture_coding_type & 0xf) << 28;
> > +	pic_header |=3D (frame_hdr->f_code[0][0] & 0xf) << 24;
> > +	pic_header |=3D (frame_hdr->f_code[0][1] & 0xf) << 20;
> > +	pic_header |=3D (frame_hdr->f_code[1][0] & 0xf) << 16;
> > +	pic_header |=3D (frame_hdr->f_code[1][1] & 0xf) << 12;
> > +	pic_header |=3D (frame_hdr->intra_dc_precision & 0x3) << 10;
> > +	pic_header |=3D (frame_hdr->picture_structure & 0x3) << 8;
> > +	pic_header |=3D (frame_hdr->top_field_first & 0x1) << 7;
> > +	pic_header |=3D (frame_hdr->frame_pred_frame_dct & 0x1) << 6;
> > +	pic_header |=3D (frame_hdr->concealment_motion_vectors & 0x1) << 5;
> > +	pic_header |=3D (frame_hdr->q_scale_type & 0x1) << 4;
> > +	pic_header |=3D (frame_hdr->intra_vlc_format & 0x1) << 3;
> > +	pic_header |=3D (frame_hdr->alternate_scan & 0x1) << 2;
> > +	sunxi_cedrus_write(dev, pic_header, VE_MPEG_PIC_HDR);
> > +
> > +	/* Enable interrupt and an unknown control flag. */
> > +	sunxi_cedrus_write(dev, VE_MPEG_CTRL_MPEG2, VE_MPEG_CTRL);
> > +
> > +	/* Macroblock address. */
> > +	sunxi_cedrus_write(dev, 0, VE_MPEG_MBA);
> > +
> > +	/* Clear previous errors. */
> > +	sunxi_cedrus_write(dev, 0, VE_MPEG_ERROR);
> > +
> > +	/* Clear correct macroblocks register. */
> > +	sunxi_cedrus_write(dev, 0, VE_MPEG_CTR_MB);
> > +
> > +	/* Forward and backward prediction reference buffers. */
> > +	sunxi_cedrus_write(dev, fwd_luma, VE_MPEG_FWD_LUMA);
> > +	sunxi_cedrus_write(dev, fwd_chroma, VE_MPEG_FWD_CHROMA);
> > +	sunxi_cedrus_write(dev, bwd_luma, VE_MPEG_BACK_LUMA);
> > +	sunxi_cedrus_write(dev, bwd_chroma, VE_MPEG_BACK_CHROMA);
> > +
> > +	/* Destination luma and chroma buffers. */
> > +	dst_luma_addr =3D vb2_dma_contig_plane_dma_addr(&run->dst->vb2_buf, 0=
);
> > +	dst_chroma_addr =3D vb2_dma_contig_plane_dma_addr(&run->dst->vb2_buf,=
 1);
> > +	sunxi_cedrus_write(dev, dst_luma_addr, VE_MPEG_REC_LUMA);
> > +	sunxi_cedrus_write(dev, dst_chroma_addr, VE_MPEG_REC_CHROMA);
> > +	sunxi_cedrus_write(dev, dst_luma_addr, VE_MPEG_ROT_LUMA);
> > +	sunxi_cedrus_write(dev, dst_chroma_addr, VE_MPEG_ROT_CHROMA);
> > +
> > +	/* Source offset and length in bits. */
> > +	sunxi_cedrus_write(dev, frame_hdr->slice_pos, VE_MPEG_VLD_OFFSET);
> > +	sunxi_cedrus_write(dev, vld_len, VE_MPEG_VLD_LEN);
> > +
> > +	/* Source beginning and end addresses. */
> > +	src_buf_addr =3D vb2_dma_contig_plane_dma_addr(&run->src->vb2_buf, 0)=
;
> > +	sunxi_cedrus_write(dev, VE_MPEG_VLD_ADDR_VAL(src_buf_addr),
> > +			   VE_MPEG_VLD_ADDR);
> > +	sunxi_cedrus_write(dev, src_buf_addr + VBV_SIZE - 1, VE_MPEG_VLD_END)=
;
> > +}
> > +
> > +void sunxi_cedrus_mpeg2_trigger(struct sunxi_cedrus_ctx *ctx, bool mpe=
g1)
> > +{
> > +	struct sunxi_cedrus_dev *dev =3D ctx->dev;
> > +
> > +	/* Trigger MPEG engine. */
> > +	if (mpeg1)
> > +		sunxi_cedrus_write(dev, VE_TRIG_MPEG1, VE_MPEG_TRIGGER);
> > +	else
> > +		sunxi_cedrus_write(dev, VE_TRIG_MPEG2, VE_MPEG_TRIGGER);
> > +}
> > diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.h b=
/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.h
> > new file mode 100644
> > index 000000000000..b572001d47f2
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.h
> > @@ -0,0 +1,33 @@
> > +/*
> > + * Sunxi-Cedrus VPU driver
> > + *
> > + * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com=
>
> > + * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.co=
m>
> > + *
> > + * Based on the vim2m driver, that is:
> > + *
> > + * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
> > + * Pawel Osciak, <pawel@osciak.com>
> > + * Marek Szyprowski, <m.szyprowski@samsung.com>
> > + *
> > + * This software is licensed under the terms of the GNU General Public
> > + * License version 2, as published by the Free Software Foundation, an=
d
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef _SUNXI_CEDRUS_MPEG2_H_
> > +#define _SUNXI_CEDRUS_MPEG2_H_
> > +
> > +struct sunxi_cedrus_ctx;
> > +struct sunxi_cedrus_run;
> > +
> > +void sunxi_cedrus_mpeg2_setup(struct sunxi_cedrus_ctx *ctx,
> > +			      struct sunxi_cedrus_run *run);
> > +void sunxi_cedrus_mpeg2_trigger(struct sunxi_cedrus_ctx *ctx, bool mpe=
g1);
> > +
> > +#endif
> > diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_regs.h b/=
drivers/media/platform/sunxi/cedrus/sunxi_cedrus_regs.h
> > new file mode 100644
> > index 000000000000..6705d41dad07
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_regs.h
> > @@ -0,0 +1,175 @@
> > +/*
> > + * Sunxi-Cedrus VPU driver
> > + *
> > + * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com=
>
> > + * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.co=
m>
> > + *
> > + * Based on the vim2m driver, that is:
> > + *
> > + * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
> > + * Pawel Osciak, <pawel@osciak.com>
> > + * Marek Szyprowski, <m.szyprowski@samsung.com>
> > + *
> > + * This software is licensed under the terms of the GNU General Public
> > + * License version 2, as published by the Free Software Foundation, an=
d
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef _SUNXI_CEDRUS_REGS_H_
> > +#define _SUNXI_CEDRUS_REGS_H_
> > +
> > +/*
> > + * For more information, consult http://linux-sunxi.org/VE_Register_gu=
ide
> > + */
> > +
> > +/* VE_MPEG_CTRL:
> > + * The bit 3 (0x8) is used to enable IRQs
> > + * The other bits are unknown but needed
> > + */
> > +#define VE_MPEG_CTRL_MPEG2	0x800001b8
> > +#define VE_MPEG_CTRL_MPEG4	(0x80084118 | BIT(7))
> > +#define VE_MPEG_CTRL_MPEG4_P	(VE_MPEG_CTRL_MPEG4 | BIT(12))
> > +
> > +/* VE_MPEG_VLD_ADDR:
> > + * The bits 27 to 4 are used for the address
> > + * The bits 31 to 28 (0x7) are used to select the MPEG or JPEG engine
> > + */
> > +#define VE_MPEG_VLD_ADDR_VAL(x)	((x & 0x0ffffff0) | (x >> 28) | (0x7 <=
< 28))
> > +
> > +/* VE_MPEG_TRIGGER:
> > + * The first three bits are used to trigger the engine
> > + * The bits 24 to 26 are used to select the input format (1 for MPEG1,=
 2 for
> > + *                           MPEG2, 4 for MPEG4)
> > + * The bit 21 (0x8) is used to disable bitstream error handling
> > + *
> > + * In MPEG4 the w*h value is somehow used for an offset, unknown but n=
eeded
> > + */
> > +#define VE_TRIG_MPEG1		0x8100000f
> > +#define VE_TRIG_MPEG2		0x8200000f
> > +#define VE_TRIG_MPEG4(w, h)	(0x8400000d | ((w * h) << 8))
> > +
> > +/* VE_MPEG_SDROT_CTRL:
> > + * The bit 8 at zero is used to disable x downscaling
> > + * The bit 10 at 0 is used to disable y downscaling
> > + * The other bits are unknown but needed
> > + */
> > +#define VE_NO_SDROT_CTRL	0x40620000
> > +
> > +/* Decent size fo video buffering verifier */
> > +#define VBV_SIZE		(1024 * 1024)
> > +
> > +/* Registers addresses */
> > +#define VE_CTRL				0x000
> > +/*
> > + * The datasheet states that this should be set to 2MB on a 32bits
> > + * DDR-3.
> > + */
> > +#define VE_CTRL_REC_WR_MODE_2MB			(1 << 20)
> > +#define VE_CTRL_REC_WR_MODE_1MB			(0 << 20)
> > +
> > +#define VE_CTRL_CACHE_BUS_BW_128		(3 << 16)
> > +#define VE_CTRL_CACHE_BUS_BW_256		(2 << 16)
> > +
> > +#define VE_CTRL_DEC_MODE_DISABLED		(7 << 0)
> > +#define VE_CTRL_DEC_MODE_H265			(4 << 0)
> > +#define VE_CTRL_DEC_MODE_H264			(1 << 0)
> > +#define VE_CTRL_DEC_MODE_MPEG			(0 << 0)
> > +
> > +#define VE_VERSION			0x0f0
> > +
> > +#define VE_MPEG_PIC_HDR			0x100
> > +#define VE_MPEG_VOP_HDR			0x104
> > +#define VE_MPEG_SIZE			0x108
> > +#define VE_MPEG_FRAME_SIZE		0x10c
> > +#define VE_MPEG_MBA			0x110
> > +#define VE_MPEG_CTRL			0x114
> > +#define VE_MPEG_TRIGGER			0x118
> > +#define VE_MPEG_STATUS			0x11c
> > +#define VE_MPEG_TRBTRD_FIELD		0x120
> > +#define VE_MPEG_TRBTRD_FRAME		0x124
> > +#define VE_MPEG_VLD_ADDR		0x128
> > +#define VE_MPEG_VLD_OFFSET		0x12c
> > +#define VE_MPEG_VLD_LEN			0x130
> > +#define VE_MPEG_VLD_END			0x134
> > +#define VE_MPEG_MBH_ADDR		0x138
> > +#define VE_MPEG_DCAC_ADDR		0x13c
> > +#define VE_MPEG_NCF_ADDR		0x144
> > +#define VE_MPEG_REC_LUMA		0x148
> > +#define VE_MPEG_REC_CHROMA		0x14c
> > +#define VE_MPEG_FWD_LUMA		0x150
> > +#define VE_MPEG_FWD_CHROMA		0x154
> > +#define VE_MPEG_BACK_LUMA		0x158
> > +#define VE_MPEG_BACK_CHROMA		0x15c
> > +#define VE_MPEG_IQ_MIN_INPUT		0x180
> > +#define VE_MPEG_QP_INPUT		0x184
> > +#define VE_MPEG_JPEG_SIZE		0x1b8
> > +#define VE_MPEG_JPEG_RES_INT		0x1c0
> > +#define VE_MPEG_ERROR			0x1c4
> > +#define VE_MPEG_CTR_MB			0x1c8
> > +#define VE_MPEG_ROT_LUMA		0x1cc
> > +#define VE_MPEG_ROT_CHROMA		0x1d0
> > +#define VE_MPEG_SDROT_CTRL		0x1d4
> > +#define VE_MPEG_RAM_WRITE_PTR		0x1e0
> > +#define VE_MPEG_RAM_WRITE_DATA		0x1e4
> > +
> > +#define VE_H264_FRAME_SIZE		0x200
> > +#define VE_H264_PIC_HDR			0x204
> > +#define VE_H264_SLICE_HDR		0x208
> > +#define VE_H264_SLICE_HDR2		0x20c
> > +#define VE_H264_PRED_WEIGHT		0x210
> > +#define VE_H264_QP_PARAM		0x21c
> > +#define VE_H264_CTRL			0x220
> > +#define VE_H264_TRIGGER			0x224
> > +#define VE_H264_STATUS			0x228
> > +#define VE_H264_CUR_MB_NUM		0x22c
> > +#define VE_H264_VLD_ADDR		0x230
> > +#define VE_H264_VLD_OFFSET		0x234
> > +#define VE_H264_VLD_LEN			0x238
> > +#define VE_H264_VLD_END			0x23c
> > +#define VE_H264_SDROT_CTRL		0x240
> > +#define VE_H264_OUTPUT_FRAME_IDX	0x24c
> > +#define VE_H264_EXTRA_BUFFER1		0x250
> > +#define VE_H264_EXTRA_BUFFER2		0x254
> > +#define VE_H264_BASIC_BITS		0x2dc
> > +#define VE_H264_RAM_WRITE_PTR		0x2e0
> > +#define VE_H264_RAM_WRITE_DATA		0x2e4
> > +
> > +#define VE_SRAM_H264_PRED_WEIGHT_TABLE	0x000
> > +#define VE_SRAM_H264_FRAMEBUFFER_LIST	0x400
> > +#define VE_SRAM_H264_REF_LIST0		0x640
> > +#define VE_SRAM_H264_REF_LIST1		0x664
> > +#define VE_SRAM_H264_SCALING_LISTS	0x800
> > +
> > +#define VE_ISP_INPUT_SIZE		0xa00
> > +#define VE_ISP_INPUT_STRIDE		0xa04
> > +#define VE_ISP_CTRL			0xa08
> > +#define VE_ISP_INPUT_LUMA		0xa78
> > +#define VE_ISP_INPUT_CHROMA		0xa7c
> > +
> > +#define VE_AVC_PARAM			0xb04
> > +#define VE_AVC_QP			0xb08
> > +#define VE_AVC_MOTION_EST		0xb10
> > +#define VE_AVC_CTRL			0xb14
> > +#define VE_AVC_TRIGGER			0xb18
> > +#define VE_AVC_STATUS			0xb1c
> > +#define VE_AVC_BASIC_BITS		0xb20
> > +#define VE_AVC_UNK_BUF			0xb60
> > +#define VE_AVC_VLE_ADDR			0xb80
> > +#define VE_AVC_VLE_END			0xb84
> > +#define VE_AVC_VLE_OFFSET		0xb88
> > +#define VE_AVC_VLE_MAX			0xb8c
> > +#define VE_AVC_VLE_LENGTH		0xb90
> > +#define VE_AVC_REF_LUMA			0xba0
> > +#define VE_AVC_REF_CHROMA		0xba4
> > +#define VE_AVC_REC_LUMA			0xbb0
> > +#define VE_AVC_REC_CHROMA		0xbb4
> > +#define VE_AVC_REF_SLUMA		0xbb8
> > +#define VE_AVC_REC_SLUMA		0xbbc
> > +#define VE_AVC_MB_INFO			0xbc0
> > +
> > +#endif
> > diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.c b=
/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.c
> > new file mode 100644
> > index 000000000000..089abfe6bfeb
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.c
> > @@ -0,0 +1,505 @@
> > +/*
> > + * Sunxi-Cedrus VPU driver
> > + *
> > + * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com=
>
> > + * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.co=
m>
> > + *
> > + * Based on the vim2m driver, that is:
> > + *
> > + * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
> > + * Pawel Osciak, <pawel@osciak.com>
> > + * Marek Szyprowski, <m.szyprowski@samsung.com>
> > + *
> > + * This software is licensed under the terms of the GNU General Public
> > + * License version 2, as published by the Free Software Foundation, an=
d
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <media/videobuf2-dma-contig.h>
> > +#include <media/v4l2-device.h>
> > +#include <media/v4l2-ioctl.h>
> > +#include <media/v4l2-ctrls.h>
> > +#include <media/v4l2-event.h>
> > +#include <media/v4l2-mem2mem.h>
> > +
> > +#include "sunxi_cedrus_common.h"
> > +#include "sunxi_cedrus_mpeg2.h"
> > +#include "sunxi_cedrus_dec.h"
> > +#include "sunxi_cedrus_hw.h"
> > +
> > +/* Flags that indicate a format can be used for capture/output. */
> > +#define SUNXI_CEDRUS_CAPTURE	BIT(0)
> > +#define SUNXI_CEDRUS_OUTPUT	BIT(1)
> > +
> > +#define SUNXI_CEDRUS_MIN_WIDTH	16U
> > +#define SUNXI_CEDRUS_MIN_HEIGHT	16U
> > +#define SUNXI_CEDRUS_MAX_WIDTH	3840U
> > +#define SUNXI_CEDRUS_MAX_HEIGHT	2160U
> > +
> > +static struct sunxi_cedrus_fmt formats[] =3D {
> > +	{
> > +		.fourcc =3D V4L2_PIX_FMT_MB32_NV12,
> > +		.types	=3D SUNXI_CEDRUS_CAPTURE,
> > +		.depth =3D 2,
> > +		.num_planes =3D 2,
> > +	},
> > +	{
> > +		.fourcc =3D V4L2_PIX_FMT_MPEG2_FRAME,
> > +		.types	=3D SUNXI_CEDRUS_OUTPUT,
> > +		.num_planes =3D 1,
> > +	},
> > +};
> > +
> > +#define NUM_FORMATS ARRAY_SIZE(formats)
> > +
> > +static struct sunxi_cedrus_fmt *find_format(struct v4l2_format *f)
> > +{
> > +	struct sunxi_cedrus_fmt *fmt;
> > +	unsigned int k;
> > +
> > +	for (k =3D 0; k < NUM_FORMATS; k++) {
> > +		fmt =3D &formats[k];
> > +		if (fmt->fourcc =3D=3D f->fmt.pix_mp.pixelformat)
> > +			break;
> > +	}
> > +
> > +	if (k =3D=3D NUM_FORMATS)
> > +		return NULL;
> > +
> > +	return &formats[k];
> > +}
> > +
> > +static inline struct sunxi_cedrus_ctx *file2ctx(struct file *file)
> > +{
> > +	return container_of(file->private_data, struct sunxi_cedrus_ctx, fh);
> > +}
> > +
> > +static int vidioc_querycap(struct file *file, void *priv,
> > +			   struct v4l2_capability *cap)
> > +{
> > +	strncpy(cap->driver, SUNXI_CEDRUS_NAME, sizeof(cap->driver) - 1);
> > +	strncpy(cap->card, SUNXI_CEDRUS_NAME, sizeof(cap->card) - 1);
> > +	snprintf(cap->bus_info, sizeof(cap->bus_info),
> > +		 "platform:%s", SUNXI_CEDRUS_NAME);
> > +	cap->device_caps =3D V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
> > +	cap->capabilities =3D cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> > +	return 0;
> > +}
> > +
> > +static int enum_fmt(struct v4l2_fmtdesc *f, u32 type)
> > +{
> > +	struct sunxi_cedrus_fmt *fmt;
> > +	int i, num =3D 0;
> > +
> > +	for (i =3D 0; i < NUM_FORMATS; ++i) {
> > +		if (formats[i].types & type) {
> > +			/* index-th format of type type found ? */
> > +			if (num =3D=3D f->index)
> > +				break;
> > +			/*
> > +			 * Correct type but haven't reached our index yet,
> > +			 * just increment per-type index
> > +			 */
> > +			++num;
> > +		}
> > +	}
> > +
> > +	if (i < NUM_FORMATS) {
> > +		fmt =3D &formats[i];
> > +		f->pixelformat =3D fmt->fourcc;
> > +		return 0;
> > +	}
> > +
> > +	return -EINVAL;
> > +}
> > +
> > +static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
> > +				   struct v4l2_fmtdesc *f)
> > +{
> > +	return enum_fmt(f, SUNXI_CEDRUS_CAPTURE);
> > +}
> > +
> > +static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
> > +				   struct v4l2_fmtdesc *f)
> > +{
> > +	return enum_fmt(f, SUNXI_CEDRUS_OUTPUT);
> > +}
> > +
> > +static int vidioc_g_fmt(struct sunxi_cedrus_ctx *ctx, struct v4l2_form=
at *f)
> > +{
> > +	switch (f->type) {
> > +	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> > +		f->fmt.pix_mp =3D ctx->dst_fmt;
> > +		break;
> > +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> > +		f->fmt.pix_mp =3D ctx->src_fmt;
> > +		break;
> > +	default:
> > +		dev_dbg(ctx->dev->dev, "invalid buf type\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int vidioc_g_fmt_vid_out(struct file *file, void *priv,
> > +				struct v4l2_format *f)
> > +{
> > +	return vidioc_g_fmt(file2ctx(file), f);
> > +}
> > +
> > +static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
> > +				struct v4l2_format *f)
> > +{
> > +	return vidioc_g_fmt(file2ctx(file), f);
> > +}
> > +
> > +static int vidioc_try_fmt(struct v4l2_format *f, struct sunxi_cedrus_f=
mt *fmt)
> > +{
> > +	int i;
> > +	__u32 bpl;
> > +
> > +	f->fmt.pix_mp.field =3D V4L2_FIELD_NONE;
> > +	f->fmt.pix_mp.num_planes =3D fmt->num_planes;
> > +
> > +	switch (f->type) {
> > +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> > +		if (f->fmt.pix_mp.plane_fmt[0].sizeimage =3D=3D 0)
> > +			return -EINVAL;
> > +
> > +		f->fmt.pix_mp.plane_fmt[0].bytesperline =3D 0;
> > +		break;
> > +	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> > +		/* Limit to hardware min/max. */
> > +		f->fmt.pix_mp.width =3D clamp(f->fmt.pix_mp.width,
> > +			SUNXI_CEDRUS_MIN_WIDTH, SUNXI_CEDRUS_MAX_WIDTH);
> > +		f->fmt.pix_mp.height =3D clamp(f->fmt.pix_mp.height,
> > +			SUNXI_CEDRUS_MIN_HEIGHT, SUNXI_CEDRUS_MAX_HEIGHT);
> > +
> > +		for (i =3D 0; i < f->fmt.pix_mp.num_planes; ++i) {
> > +			bpl =3D (f->fmt.pix_mp.width * fmt->depth) >> 3;
> > +			f->fmt.pix_mp.plane_fmt[i].bytesperline =3D bpl;
> > +			f->fmt.pix_mp.plane_fmt[i].sizeimage =3D
> > +				f->fmt.pix_mp.height * bpl;
> > +		}
> > +		break;
> > +	}
> > +	return 0;
> > +}
> > +
> > +static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
> > +				  struct v4l2_format *f)
> > +{
> > +	struct sunxi_cedrus_fmt *fmt;
> > +	struct sunxi_cedrus_ctx *ctx =3D file2ctx(file);
> > +
> > +	fmt =3D find_format(f);
> > +	if (!fmt) {
> > +		f->fmt.pix_mp.pixelformat =3D formats[0].fourcc;
> > +		fmt =3D find_format(f);
> > +	}
> > +	if (!(fmt->types & SUNXI_CEDRUS_CAPTURE)) {
> > +		v4l2_err(&ctx->dev->v4l2_dev,
> > +			 "Fourcc format (0x%08x) invalid.\n",
> > +			 f->fmt.pix_mp.pixelformat);
> > +		return -EINVAL;
> > +	}
> > +
> > +	return vidioc_try_fmt(f, fmt);
> > +}
> > +
> > +static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
> > +				  struct v4l2_format *f)
> > +{
> > +	struct sunxi_cedrus_fmt *fmt;
> > +	struct sunxi_cedrus_ctx *ctx =3D file2ctx(file);
> > +
> > +	fmt =3D find_format(f);
> > +	if (!fmt) {
> > +		f->fmt.pix_mp.pixelformat =3D formats[0].fourcc;
> > +		fmt =3D find_format(f);
> > +	}
> > +	if (!(fmt->types & SUNXI_CEDRUS_OUTPUT)) {
> > +		v4l2_err(&ctx->dev->v4l2_dev,
> > +			 "Fourcc format (0x%08x) invalid.\n",
> > +			 f->fmt.pix_mp.pixelformat);
> > +		return -EINVAL;
> > +	}
> > +
> > +	return vidioc_try_fmt(f, fmt);
> > +}
> > +
> > +static int vidioc_s_fmt(struct sunxi_cedrus_ctx *ctx, struct v4l2_form=
at *f)
> > +{
> > +	struct v4l2_pix_format_mplane *pix_fmt_mp =3D &f->fmt.pix_mp;
> > +	struct sunxi_cedrus_fmt *fmt;
> > +	int i, ret =3D 0;
> > +
> > +	switch (f->type) {
> > +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> > +		ctx->vpu_src_fmt =3D find_format(f);
> > +		ctx->src_fmt =3D *pix_fmt_mp;
> > +		break;
> > +	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> > +		fmt =3D find_format(f);
> > +		ctx->vpu_dst_fmt =3D fmt;
> > +
> > +		for (i =3D 0; i < fmt->num_planes; ++i) {
> > +			pix_fmt_mp->plane_fmt[i].bytesperline =3D
> > +				pix_fmt_mp->width * fmt->depth;
> > +			pix_fmt_mp->plane_fmt[i].sizeimage =3D
> > +				pix_fmt_mp->plane_fmt[i].bytesperline
> > +				* pix_fmt_mp->height;
> > +		}
> > +		ctx->dst_fmt =3D *pix_fmt_mp;
> > +		break;
> > +	default:
> > +		dev_dbg(ctx->dev->dev, "invalid buf type\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
> > +				struct v4l2_format *f)
> > +{
> > +	int ret;
> > +
> > +	ret =3D vidioc_try_fmt_vid_cap(file, priv, f);
> > +	if (ret)
> > +		return ret;
> > +
> > +	return vidioc_s_fmt(file2ctx(file), f);
> > +}
> > +
> > +static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
> > +				struct v4l2_format *f)
> > +{
> > +	int ret;
> > +
> > +	ret =3D vidioc_try_fmt_vid_out(file, priv, f);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret =3D vidioc_s_fmt(file2ctx(file), f);
> > +	return ret;
> > +}
> > +
> > +const struct v4l2_ioctl_ops sunxi_cedrus_ioctl_ops =3D {
> > +	.vidioc_querycap		=3D vidioc_querycap,
> > +
> > +	.vidioc_enum_fmt_vid_cap	=3D vidioc_enum_fmt_vid_cap,
> > +	.vidioc_g_fmt_vid_cap_mplane	=3D vidioc_g_fmt_vid_cap,
> > +	.vidioc_try_fmt_vid_cap_mplane	=3D vidioc_try_fmt_vid_cap,
> > +	.vidioc_s_fmt_vid_cap_mplane	=3D vidioc_s_fmt_vid_cap,
> > +
> > +	.vidioc_enum_fmt_vid_out_mplane =3D vidioc_enum_fmt_vid_out,
> > +	.vidioc_g_fmt_vid_out_mplane	=3D vidioc_g_fmt_vid_out,
> > +	.vidioc_try_fmt_vid_out_mplane	=3D vidioc_try_fmt_vid_out,
> > +	.vidioc_s_fmt_vid_out_mplane	=3D vidioc_s_fmt_vid_out,
> > +
> > +	.vidioc_reqbufs			=3D v4l2_m2m_ioctl_reqbufs,
> > +	.vidioc_querybuf		=3D v4l2_m2m_ioctl_querybuf,
> > +	.vidioc_qbuf			=3D v4l2_m2m_ioctl_qbuf,
> > +	.vidioc_dqbuf			=3D v4l2_m2m_ioctl_dqbuf,
> > +	.vidioc_prepare_buf		=3D v4l2_m2m_ioctl_prepare_buf,
> > +	.vidioc_create_bufs		=3D v4l2_m2m_ioctl_create_bufs,
> > +	.vidioc_expbuf			=3D v4l2_m2m_ioctl_expbuf,
> > +
> > +	.vidioc_streamon		=3D v4l2_m2m_ioctl_streamon,
> > +	.vidioc_streamoff		=3D v4l2_m2m_ioctl_streamoff,
> > +
> > +	.vidioc_subscribe_event		=3D v4l2_ctrl_subscribe_event,
> > +	.vidioc_unsubscribe_event	=3D v4l2_event_unsubscribe,
> > +};
> > +
> > +static int sunxi_cedrus_queue_setup(struct vb2_queue *vq, unsigned int=
 *nbufs,
> > +				    unsigned int *nplanes, unsigned int sizes[],
> > +				    struct device *alloc_devs[])
> > +{
> > +	struct sunxi_cedrus_ctx *ctx =3D vb2_get_drv_priv(vq);
> > +
> > +	if (*nbufs < 1)
> > +		*nbufs =3D 1;
> > +
> > +	if (*nbufs > VIDEO_MAX_FRAME)
> > +		*nbufs =3D VIDEO_MAX_FRAME;
>=20
> No need for these two checks, the vb2 core takes care of that.

That is definitely good to know.

Thanks a lot for the feedback!

Cheers,

Paul

> > +
> > +	switch (vq->type) {
> > +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> > +		*nplanes =3D ctx->vpu_src_fmt->num_planes;
> > +
> > +		sizes[0] =3D ctx->src_fmt.plane_fmt[0].sizeimage;
> > +		break;
> > +
> > +	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> > +		*nplanes =3D ctx->vpu_dst_fmt->num_planes;
> > +
> > +		sizes[0] =3D round_up(ctx->dst_fmt.plane_fmt[0].sizeimage, 8);
> > +		sizes[1] =3D sizes[0];
> > +		break;
> > +
> > +	default:
> > +		dev_dbg(ctx->dev->dev, "invalid queue type: %d\n", vq->type);
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int sunxi_cedrus_buf_init(struct vb2_buffer *vb)
> > +{
> > +	struct vb2_queue *vq =3D vb->vb2_queue;
> > +	struct sunxi_cedrus_ctx *ctx =3D container_of(vq->drv_priv,
> > +			struct sunxi_cedrus_ctx, fh);
> > +
> > +	if (vq->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> > +		ctx->dst_bufs[vb->index] =3D vb;
> > +
> > +	return 0;
> > +}
> > +
> > +static void sunxi_cedrus_buf_cleanup(struct vb2_buffer *vb)
> > +{
> > +	struct vb2_queue *vq =3D vb->vb2_queue;
> > +	struct sunxi_cedrus_ctx *ctx =3D container_of(vq->drv_priv,
> > +			struct sunxi_cedrus_ctx, fh);
> > +
> > +	if (vq->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> > +		ctx->dst_bufs[vb->index] =3D NULL;
> > +}
> > +
> > +static int sunxi_cedrus_buf_prepare(struct vb2_buffer *vb)
> > +{
> > +	struct sunxi_cedrus_ctx *ctx =3D vb2_get_drv_priv(vb->vb2_queue);
> > +	struct vb2_queue *vq =3D vb->vb2_queue;
> > +	int i;
> > +
> > +	dev_dbg(ctx->dev->dev, "type: %d\n", vb->vb2_queue->type);
> > +
> > +	switch (vq->type) {
> > +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> > +		if (vb2_plane_size(vb, 0)
> > +		    < ctx->src_fmt.plane_fmt[0].sizeimage) {
> > +			dev_dbg(ctx->dev->dev, "plane too small for output\n");
> > +			return -EINVAL;
> > +		}
> > +		break;
> > +
> > +	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> > +		for (i =3D 0; i < ctx->vpu_dst_fmt->num_planes; ++i) {
> > +			if (vb2_plane_size(vb, i)
> > +			    < ctx->dst_fmt.plane_fmt[i].sizeimage) {
> > +				dev_dbg(ctx->dev->dev,
> > +					"plane %d too small for capture\n", i);
> > +				break;
> > +			}
> > +		}
> > +
> > +		if (i !=3D ctx->vpu_dst_fmt->num_planes)
> > +			return -EINVAL;
> > +		break;
> > +
> > +	default:
> > +		dev_dbg(ctx->dev->dev, "invalid queue type: %d\n", vq->type);
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static void sunxi_cedrus_stop_streaming(struct vb2_queue *q)
> > +{
> > +	struct sunxi_cedrus_ctx *ctx =3D vb2_get_drv_priv(q);
> > +	struct vb2_v4l2_buffer *vbuf;
> > +	unsigned long flags;
> > +
> > +	flush_scheduled_work();
> > +	for (;;) {
> > +		spin_lock_irqsave(&ctx->dev->irq_lock, flags);
> > +
> > +		if (V4L2_TYPE_IS_OUTPUT(q->type))
> > +			vbuf =3D v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> > +		else
> > +			vbuf =3D v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
> > +
> > +		spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
> > +
> > +		if (vbuf =3D=3D NULL)
> > +			return;
> > +
> > +		v4l2_ctrl_request_complete(vbuf->vb2_buf.req_obj.req,
> > +					   &ctx->hdl);
> > +		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
> > +	}
> > +}
> > +
> > +static void sunxi_cedrus_buf_queue(struct vb2_buffer *vb)
> > +{
> > +	struct vb2_v4l2_buffer *vbuf =3D to_vb2_v4l2_buffer(vb);
> > +	struct sunxi_cedrus_ctx *ctx =3D vb2_get_drv_priv(vb->vb2_queue);
> > +
> > +	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
> > +}
> > +
> > +static void sunxi_cedrus_buf_request_complete(struct vb2_buffer *vb)
> > +{
> > +	struct sunxi_cedrus_ctx *ctx =3D vb2_get_drv_priv(vb->vb2_queue);
> > +
> > +	v4l2_ctrl_request_complete(vb->req_obj.req, &ctx->hdl);
> > +}
> > +
> > +static struct vb2_ops sunxi_cedrus_qops =3D {
> > +	.queue_setup		=3D sunxi_cedrus_queue_setup,
> > +	.buf_prepare		=3D sunxi_cedrus_buf_prepare,
> > +	.buf_init		=3D sunxi_cedrus_buf_init,
> > +	.buf_cleanup		=3D sunxi_cedrus_buf_cleanup,
> > +	.buf_queue		=3D sunxi_cedrus_buf_queue,
> > +	.buf_request_complete	=3D sunxi_cedrus_buf_request_complete,
> > +	.stop_streaming		=3D sunxi_cedrus_stop_streaming,
> > +	.wait_prepare		=3D vb2_ops_wait_prepare,
> > +	.wait_finish		=3D vb2_ops_wait_finish,
> > +};
> > +
> > +int sunxi_cedrus_queue_init(void *priv, struct vb2_queue *src_vq,
> > +			    struct vb2_queue *dst_vq)
> > +{
> > +	struct sunxi_cedrus_ctx *ctx =3D priv;
> > +	int ret;
> > +
> > +	src_vq->type =3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> > +	src_vq->io_modes =3D VB2_MMAP | VB2_DMABUF;
> > +	src_vq->drv_priv =3D ctx;
> > +	src_vq->buf_struct_size =3D sizeof(struct sunxi_cedrus_buffer);
> > +	src_vq->allow_zero_bytesused =3D 1;
> > +	src_vq->min_buffers_needed =3D 1;
> > +	src_vq->ops =3D &sunxi_cedrus_qops;
> > +	src_vq->mem_ops =3D &vb2_dma_contig_memops;
> > +	src_vq->timestamp_flags =3D V4L2_BUF_FLAG_TIMESTAMP_COPY;
> > +	src_vq->lock =3D &ctx->dev->dev_mutex;
> > +	src_vq->dev =3D ctx->dev->dev;
> > +
> > +	ret =3D vb2_queue_init(src_vq);
> > +	if (ret)
> > +		return ret;
> > +
> > +	dst_vq->type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> > +	dst_vq->io_modes =3D VB2_MMAP | VB2_DMABUF;
> > +	dst_vq->drv_priv =3D ctx;
> > +	dst_vq->buf_struct_size =3D sizeof(struct sunxi_cedrus_buffer);
> > +	dst_vq->allow_zero_bytesused =3D 1;
> > +	dst_vq->min_buffers_needed =3D 1;
> > +	dst_vq->ops =3D &sunxi_cedrus_qops;
> > +	dst_vq->mem_ops =3D &vb2_dma_contig_memops;
> > +	dst_vq->timestamp_flags =3D V4L2_BUF_FLAG_TIMESTAMP_COPY;
> > +	dst_vq->lock =3D &ctx->dev->dev_mutex;
> > +	dst_vq->dev =3D ctx->dev->dev;
> > +
> > +	return vb2_queue_init(dst_vq);
> > +}
> > diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.h b=
/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.h
> > new file mode 100644
> > index 000000000000..d5b7f881c386
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.h
> > @@ -0,0 +1,31 @@
> > +/*
> > + * Sunxi-Cedrus VPU driver
> > + *
> > + * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com=
>
> > + * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.co=
m>
> > + *
> > + * Based on the vim2m driver, that is:
> > + *
> > + * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
> > + * Pawel Osciak, <pawel@osciak.com>
> > + * Marek Szyprowski, <m.szyprowski@samsung.com>
> > + *
> > + * This software is licensed under the terms of the GNU General Public
> > + * License version 2, as published by the Free Software Foundation, an=
d
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef _SUNXI_CEDRUS_VIDEO_H_
> > +#define _SUNXI_CEDRUS_VIDEO_H_
> > +
> > +extern const struct v4l2_ioctl_ops sunxi_cedrus_ioctl_ops;
> > +
> > +int sunxi_cedrus_queue_init(void *priv, struct vb2_queue *src_vq,
> > +			    struct vb2_queue *dst_vq);
> > +
> > +#endif
> >=20
>=20
> Regards,
>=20
> 	Hans
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-4wSAGWpL0aInLhDHnk+v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlsijiAACgkQ3cLmz3+f
v9G+4Af/RaAi0Rx9E3zrqfHbtQ0uXnqzjGjp8YZoaU+vGAjqfYPfwSu/5vDRlgBu
GsE2KK6905rV+XkfKXJ3SdQkxmiqKs6kS6QEz2H3y1B6f6Lmy+uUEebEA34XwjRx
Jn0eB4z+Pm22EOwmosUQQHHN4ywIEx2cRuhVGqKnzTGGoKyHHpGUKXRoOgXnxGf1
VoztMaPImcbg+4zSeCn8TCU5b8OsOOQVfvh3HSblZoAFShlfKSxjUErvKMNqz2RB
Jn+zWVeLRaqoT9KXUgsqitwqzRIv7/VrK8bcsIPVvM3CpA2A3tqC+cltaAzgLsPY
P3xxrvnMCTjI2Lnc0UCm0YCwCKsq0A==
=/EiR
-----END PGP SIGNATURE-----

--=-4wSAGWpL0aInLhDHnk+v--
