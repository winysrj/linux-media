Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:35706 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388460AbeGXPfT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jul 2018 11:35:19 -0400
Message-ID: <0568d5b5c4708fbb258dcc56a6859da6ee8bcd42.camel@bootlin.com>
Subject: Re: [linux-sunxi] [PATCH v4 16/19] media: platform: Add
 Sunxi-Cedrus VPU decoder driver
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: linux-media <linux-media@vger.kernel.org>,
        devicetree@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Marco Franchi <marco.franchi@nxp.com>,
        Icenowy Zheng <icenowy@aosc.io>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tom Saeger <tom.saeger@oracle.com>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>
Date: Tue, 24 Jul 2018 16:28:14 +0200
In-Reply-To: <CAAEAJfCr3G5SXyNS3okpJCU9n=KgzVu+cL3x35GeYtoYhmmOgA@mail.gmail.com>
References: <20180618145843.14631-1-paul.kocialkowski@bootlin.com>
         <20180618145843.14631-17-paul.kocialkowski@bootlin.com>
         <CAAEAJfCr3G5SXyNS3okpJCU9n=KgzVu+cL3x35GeYtoYhmmOgA@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-ki4H+HGfh/R5+tWy9FqR"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-ki4H+HGfh/R5+tWy9FqR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 2018-07-09 at 22:41 -0300, Ezequiel Garcia wrote:
> Hi Paul,
>=20
> A modest review round. Hope it helps!
>=20
> I will be reviewing the driver some more later.

Thanks a lot for the review, it is very appreciated!

> On 18 June 2018 at 11:58, Paul Kocialkowski
> <paul.kocialkowski@bootlin.com> wrote:
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
> >=20
> >  create mode 100644 drivers/media/platform/sunxi/Kconfig
> >  create mode 100644 drivers/media/platform/sunxi/Makefile
> >  create mode 100644 drivers/media/platform/sunxi/cedrus/Kconfig
> >  create mode 100644 drivers/media/platform/sunxi/cedrus/Makefile
> >  create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus.c
> >  create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus.h
> >  create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_dec.c
> >  create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_dec.h
> >  create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_hw.c
> >  create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_hw.h
> >  create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_mpeg2.c
> >  create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_mpeg2.h
> >  create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_regs.h
> >  create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_video.c
> >  create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_video.h
> >=20
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 9c125f705f78..b47dee397475 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -656,6 +656,13 @@ L: linux-crypto@vger.kernel.org
> >  S:     Maintained
> >  F:     drivers/crypto/sunxi-ss/
> >=20
> > +ALLWINNER VPU DRIVER
> > +M:     Maxime Ripard <maxime.ripard@bootlin.com>
> > +M:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> > +L:     linux-media@vger.kernel.org
> > +S:     Maintained
> > +F:     drivers/media/platform/sunxi/cedrus/
> > +
> >  ALPHA PORT
> >  M:     Richard Henderson <rth@twiddle.net>
> >  M:     Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> > diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kc=
onfig
> > index c7a1cf8a1b01..26da88bcd87b 100644
> > --- a/drivers/media/platform/Kconfig
> > +++ b/drivers/media/platform/Kconfig
> > @@ -31,6 +31,8 @@ source "drivers/media/platform/davinci/Kconfig"
> >=20
> >  source "drivers/media/platform/omap/Kconfig"
> >=20
> > +source "drivers/media/platform/sunxi/Kconfig"
> > +
> >  config VIDEO_SH_VOU
> >         tristate "SuperH VOU video output driver"
> >         depends on MEDIA_CAMERA_SUPPORT
> > diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/M=
akefile
> > index 932515df4477..01ac00adcbc4 100644
> > --- a/drivers/media/platform/Makefile
> > +++ b/drivers/media/platform/Makefile
> > @@ -69,6 +69,7 @@ obj-$(CONFIG_VIDEO_ROCKCHIP_RGA)      +=3D rockchip/r=
ga/
> >  obj-y  +=3D omap/
> >=20
> >  obj-$(CONFIG_VIDEO_AM437X_VPFE)                +=3D am437x/
> > +obj-$(CONFIG_VIDEO_SUNXI)              +=3D sunxi/
> >=20
> >  obj-$(CONFIG_VIDEO_XILINX)             +=3D xilinx/
> >=20
> > diff --git a/drivers/media/platform/sunxi/Kconfig b/drivers/media/platf=
orm/sunxi/Kconfig
> > new file mode 100644
> > index 000000000000..a639b0949826
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi/Kconfig
> > @@ -0,0 +1,15 @@
> > +config VIDEO_SUNXI
> > +       bool "Allwinner sunXi family Video Devices"
> > +       depends on ARCH_SUNXI
>=20
> You could add || COMPILE_TEST, to get covered
> by build tests.

Thanks, will do.

> > +       help
> > +         If you have an Allwinner SoC based on the sunXi family, say Y=
.
> > +
> > +         Note that this option doesn't include new drivers in the
> > +         kernel: saying N will just cause Kconfig to skip all the
> > +         questions about Allwinner media devices.
> > +
> > +if VIDEO_SUNXI
> > +
> > +source "drivers/media/platform/sunxi/cedrus/Kconfig"
> > +
> > +endif
> > diff --git a/drivers/media/platform/sunxi/Makefile b/drivers/media/plat=
form/sunxi/Makefile
> > new file mode 100644
> > index 000000000000..cee2846c3ecf
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi/Makefile
> > @@ -0,0 +1 @@
> > +obj-$(CONFIG_VIDEO_SUNXI_CEDRUS)       +=3D cedrus/
> > diff --git a/drivers/media/platform/sunxi/cedrus/Kconfig b/drivers/medi=
a/platform/sunxi/cedrus/Kconfig
> > new file mode 100644
> > index 000000000000..870a4b64a45c
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi/cedrus/Kconfig
> > @@ -0,0 +1,13 @@
> > +config VIDEO_SUNXI_CEDRUS
> > +       tristate "Allwinner Cedrus VPU driver"
> > +       depends on VIDEO_DEV && VIDEO_V4L2 && MEDIA_CONTROLLER
> > +       depends on HAS_DMA
> > +       select VIDEOBUF2_DMA_CONTIG
> > +       select MEDIA_REQUEST_API
> > +       select V4L2_MEM2MEM_DEV
> > +       help
> > +         Support for the VPU found in Allwinner SoCs, also known as th=
e Cedar
> > +         video engine.
> > +
> > +         To compile this driver as a module, choose M here: the module
> > +         will be called cedrus.
> > diff --git a/drivers/media/platform/sunxi/cedrus/Makefile b/drivers/med=
ia/platform/sunxi/cedrus/Makefile
> > new file mode 100644
> > index 000000000000..632a0be90ed7
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi/cedrus/Makefile
> > @@ -0,0 +1,3 @@
> > +obj-$(CONFIG_VIDEO_SUNXI_CEDRUS) +=3D cedrus.o
> > +
> > +cedrus-y =3D cedrus.o cedrus_video.o cedrus_hw.o cedrus_dec.o cedrus_m=
peg2.o
> > diff --git a/drivers/media/platform/sunxi/cedrus/cedrus.c b/drivers/med=
ia/platform/sunxi/cedrus/cedrus.c
> > new file mode 100644
> > index 000000000000..1718db1b549b
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi/cedrus/cedrus.c
> > @@ -0,0 +1,327 @@
> > +// SPDX-License-Identifier: GPL-2.0
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
> > +#include "cedrus.h"
> > +#include "cedrus_video.h"
> > +#include "cedrus_dec.h"
> > +#include "cedrus_hw.h"
> > +
> > +static int cedrus_s_ctrl(struct v4l2_ctrl *ctrl)
> > +{
> > +       struct cedrus_ctx *ctx =3D
> > +               container_of(ctrl->handler, struct cedrus_ctx, hdl);
> > +       struct cedrus_dev *dev =3D ctx->dev;
> > +
> > +       switch (ctrl->id) {
> > +       case V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_HEADER:
> > +               /* This is kept in memory and used directly. */
> > +               break;
> > +       default:
> > +               v4l2_err(&dev->v4l2_dev, "Invalid control to set\n");
> > +               return -EINVAL;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static const struct v4l2_ctrl_ops cedrus_ctrl_ops =3D {
> > +       .s_ctrl =3D cedrus_s_ctrl,
> > +};
> > +
> > +static const struct cedrus_control controls[] =3D {
> > +       [CEDRUS_CTRL_DEC_MPEG2_SLICE_HEADER] =3D {
> > +               .id             =3D V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_HEA=
DER,
> > +               .elem_size      =3D sizeof(struct v4l2_ctrl_mpeg2_slice=
_header),
> > +       },
> > +};
> > +
> > +static int cedrus_init_ctrls(struct cedrus_dev *dev, struct cedrus_ctx=
 *ctx)
> > +{
> > +       struct v4l2_ctrl_handler *hdl =3D &ctx->hdl;
> > +       unsigned int num_ctrls =3D ARRAY_SIZE(controls);
> > +       unsigned int i;
> > +
> > +       v4l2_ctrl_handler_init(hdl, num_ctrls);
> > +       if (hdl->error) {
> > +               v4l2_err(&dev->v4l2_dev,
> > +                        "Failed to initialize control handler\n");
> > +               return hdl->error;
> > +       }
> > +
> > +       for (i =3D 0; i < num_ctrls; i++) {
> > +               struct v4l2_ctrl_config cfg =3D { 0 };
> > +
> > +               cfg.ops =3D &cedrus_ctrl_ops;
> > +               cfg.elem_size =3D controls[i].elem_size;
> > +               cfg.id =3D controls[i].id;
> > +
> > +               ctx->ctrls[i] =3D v4l2_ctrl_new_custom(hdl, &cfg, NULL)=
;
> > +               if (hdl->error) {
> > +                       v4l2_err(&dev->v4l2_dev,
> > +                                "Failed to create new custom control\n=
");
> > +
> > +                       v4l2_ctrl_handler_free(hdl);
> > +                       return hdl->error;
> > +               }
> > +       }
> > +
> > +       ctx->fh.ctrl_handler =3D hdl;
> > +       v4l2_ctrl_handler_setup(hdl);
> > +
> > +       return 0;
> > +}
> > +
> > +static int cedrus_open(struct file *file)
> > +{
> > +       struct cedrus_dev *dev =3D video_drvdata(file);
> > +       struct cedrus_ctx *ctx =3D NULL;
> > +       int ret;
> > +
> > +       if (mutex_lock_interruptible(&dev->dev_mutex))
> > +               return -ERESTARTSYS;
> > +
> > +       ctx =3D kzalloc(sizeof(*ctx), GFP_KERNEL);
> > +       if (!ctx) {
> > +               mutex_unlock(&dev->dev_mutex);
> > +               return -ENOMEM;
> > +       }
> > +
> > +       INIT_WORK(&ctx->run_work, cedrus_device_work);
> > +
>=20
> This cedrus_device_work looks odd, but I think it's already
> cleaned up in your WIP github branch.

Yes, it was replaced by the interrupt bottom-half, which we hopefully
can also eventually get rid of thanks to your patches!

> > +       INIT_LIST_HEAD(&ctx->src_list);
> > +       INIT_LIST_HEAD(&ctx->dst_list);
> > +
> > +       v4l2_fh_init(&ctx->fh, video_devdata(file));
> > +       file->private_data =3D &ctx->fh;
> > +       ctx->dev =3D dev;
> > +
> > +       ret =3D cedrus_init_ctrls(dev, ctx);
> > +       if (ret)
> > +               goto err_free;
> > +
> > +       ctx->fh.m2m_ctx =3D v4l2_m2m_ctx_init(dev->m2m_dev, ctx,
> > +                                           &cedrus_queue_init);
> > +       if (IS_ERR(ctx->fh.m2m_ctx)) {
> > +               ret =3D PTR_ERR(ctx->fh.m2m_ctx);
> > +               goto err_ctrls;
> > +       }
> > +
> > +       v4l2_fh_add(&ctx->fh);
> > +
> > +       mutex_unlock(&dev->dev_mutex);
> > +
> > +       return 0;
> > +
> > +err_ctrls:
> > +       v4l2_ctrl_handler_free(&ctx->hdl);
> > +err_free:
> > +       kfree(ctx);
> > +       mutex_unlock(&dev->dev_mutex);
> > +
> > +       return ret;
> > +}
> > +
> > +static int cedrus_release(struct file *file)
> > +{
> > +       struct cedrus_dev *dev =3D video_drvdata(file);
> > +       struct cedrus_ctx *ctx =3D container_of(file->private_data,
> > +                                             struct cedrus_ctx, fh);
> > +
> > +       mutex_lock(&dev->dev_mutex);
> > +
> > +       v4l2_fh_del(&ctx->fh);
> > +       v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
> > +
> > +       v4l2_ctrl_handler_free(&ctx->hdl);
> > +
> > +       v4l2_fh_exit(&ctx->fh);
> > +       v4l2_fh_exit(&ctx->fh);
> > +
> > +       kfree(ctx);
> > +
> > +       mutex_unlock(&dev->dev_mutex);
> > +
> > +       return 0;
> > +}
> > +
> > +static const struct v4l2_file_operations cedrus_fops =3D {
> > +       .owner          =3D THIS_MODULE,
> > +       .open           =3D cedrus_open,
> > +       .release        =3D cedrus_release,
> > +       .poll           =3D v4l2_m2m_fop_poll,
> > +       .unlocked_ioctl =3D video_ioctl2,
> > +       .mmap           =3D v4l2_m2m_fop_mmap,
> > +};
> > +
> > +static const struct video_device cedrus_video_device =3D {
> > +       .name           =3D CEDRUS_NAME,
> > +       .vfl_dir        =3D VFL_DIR_M2M,
> > +       .fops           =3D &cedrus_fops,
> > +       .ioctl_ops      =3D &cedrus_ioctl_ops,
> > +       .minor          =3D -1,
> > +       .release        =3D video_device_release_empty,
> > +};
> > +
> > +static const struct v4l2_m2m_ops cedrus_m2m_ops =3D {
> > +       .device_run     =3D cedrus_device_run,
> > +       .job_abort      =3D cedrus_job_abort,
> > +};
> > +
> > +static const struct media_device_ops cedrus_m2m_media_ops =3D {
> > +       .req_validate =3D vb2_request_validate,
> > +       .req_queue =3D vb2_m2m_request_queue,
> > +};
> > +
> > +static int cedrus_probe(struct platform_device *pdev)
> > +{
> > +       struct cedrus_dev *dev;
> > +       struct video_device *vfd;
> > +       int ret;
> > +
> > +       dev =3D devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
> > +       if (!dev)
> > +               return -ENOMEM;
> > +
> > +       dev->dev =3D &pdev->dev;
> > +       dev->pdev =3D pdev;
> > +
> > +       ret =3D cedrus_hw_probe(dev);
> > +       if (ret) {
> > +               dev_err(&pdev->dev, "Failed to probe hardware\n");
> > +               return ret;
> > +       }
> > +
> > +       mutex_init(&dev->dev_mutex);
> > +       spin_lock_init(&dev->irq_lock);
> > +
> > +       dev->vfd =3D cedrus_video_device;
> > +       vfd =3D &dev->vfd;
> > +       vfd->lock =3D &dev->dev_mutex;
> > +       vfd->v4l2_dev =3D &dev->v4l2_dev;
> > +
> > +       dev->mdev.dev =3D &pdev->dev;
> > +       strlcpy(dev->mdev.model, CEDRUS_NAME, sizeof(dev->mdev.model));
> > +
> > +       media_device_init(&dev->mdev);
> > +       dev->mdev.ops =3D &cedrus_m2m_media_ops;
> > +       dev->v4l2_dev.mdev =3D &dev->mdev;
> > +       dev->pad[0].flags =3D MEDIA_PAD_FL_SINK;
> > +       dev->pad[1].flags =3D MEDIA_PAD_FL_SOURCE;
> > +
> > +       ret =3D media_entity_pads_init(&vfd->entity, 2, dev->pad);
> > +       if (ret) {
> > +               dev_err(&pdev->dev, "Failed to initialize media entity =
pads\n");
> > +               return ret;
> > +       }
> > +
> > +       ret =3D v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
> > +       if (ret) {
> > +               dev_err(&pdev->dev, "Failed to register V4L2 device\n")=
;
> > +               return ret;
> > +       }
> > +
> > +       ret =3D video_register_device(vfd, VFL_TYPE_GRABBER, 0);
> > +       if (ret) {
> > +               v4l2_err(&dev->v4l2_dev, "Failed to register video devi=
ce\n");
> > +               goto err_v4l2;
> > +       }
> > +
> > +       video_set_drvdata(vfd, dev);
> > +       snprintf(vfd->name, sizeof(vfd->name), "%s", cedrus_video_devic=
e.name);
> > +
> > +       v4l2_info(&dev->v4l2_dev,
> > +                 "Device registered as /dev/video%d\n", vfd->num);
> > +
> > +       platform_set_drvdata(pdev, dev);
> > +
> > +       dev->m2m_dev =3D v4l2_m2m_init(&cedrus_m2m_ops);
> > +       if (IS_ERR(dev->m2m_dev)) {
> > +               v4l2_err(&dev->v4l2_dev,
> > +                        "Failed to initialize V4L2 M2M device\n");
> > +               ret =3D PTR_ERR(dev->m2m_dev);
> > +               goto err_video;
> > +       }
> > +
> > +       ret =3D media_device_register(&dev->mdev);
> > +       if (ret) {
> > +               v4l2_err(&dev->v4l2_dev, "Failed to register media devi=
ce\n");
> > +               goto err_m2m;
> > +       }
> > +
> > +       return 0;
> > +
> > +err_m2m:
> > +       v4l2_m2m_release(dev->m2m_dev);
> > +err_video:
> > +       video_unregister_device(&dev->vfd);
> > +err_v4l2:
> > +       v4l2_device_unregister(&dev->v4l2_dev);
> > +
> > +       return ret;
> > +}
> > +
> > +static int cedrus_remove(struct platform_device *pdev)
> > +{
> > +       struct cedrus_dev *dev =3D platform_get_drvdata(pdev);
> > +
> > +       v4l2_info(&dev->v4l2_dev, "Removing " CEDRUS_NAME);
> > +
> > +       if (media_devnode_is_registered(dev->mdev.devnode)) {
> > +               media_device_unregister(&dev->mdev);
> > +               media_device_cleanup(&dev->mdev);
> > +       }
> > +
> > +       v4l2_m2m_release(dev->m2m_dev);
> > +       video_unregister_device(&dev->vfd);
> > +       v4l2_device_unregister(&dev->v4l2_dev);
> > +       cedrus_hw_remove(dev);
> > +
> > +       return 0;
> > +}
> > +
> > +#ifdef CONFIG_OF
> > +static const struct of_device_id of_cedrus_match[] =3D {
> > +       { .compatible =3D "allwinner,sun4i-a10-video-engine" },
> > +       { .compatible =3D "allwinner,sun5i-a13-video-engine" },
> > +       { .compatible =3D "allwinner,sun7i-a20-video-engine" },
> > +       { .compatible =3D "allwinner,sun8i-a33-video-engine" },
> > +       { /* sentinel */ }
> > +};
> > +MODULE_DEVICE_TABLE(of, of_cedrus_match);
> > +#endif
> > +
> > +static struct platform_driver cedrus_driver =3D {
> > +       .probe          =3D cedrus_probe,
> > +       .remove         =3D cedrus_remove,
> > +       .driver         =3D {
> > +               .name   =3D CEDRUS_NAME,
> > +               .owner =3D THIS_MODULE,
> > +               .of_match_table =3D of_match_ptr(of_cedrus_match),
> > +       },
> > +};
> > +module_platform_driver(cedrus_driver);
> > +
> > +MODULE_LICENSE("GPL v2");
> > +MODULE_AUTHOR("Florent Revest <florent.revest@free-electrons.com>");
> > +MODULE_DESCRIPTION("Sunxi-Cedrus VPU driver");
> > diff --git a/drivers/media/platform/sunxi/cedrus/cedrus.h b/drivers/med=
ia/platform/sunxi/cedrus/cedrus.h
> > new file mode 100644
> > index 000000000000..106bda44a3c3
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi/cedrus/cedrus.h
> > @@ -0,0 +1,117 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
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
> > + */
> > +
> > +#ifndef _CEDRUS_H_
> > +#define _CEDRUS_H_
> > +
> > +#include <linux/platform_device.h>
> > +
> > +#include <media/videobuf2-v4l2.h>
> > +#include <media/v4l2-device.h>
> > +#include <media/v4l2-ctrls.h>
> > +
> > +#define CEDRUS_NAME    "cedrus"
> > +
> > +enum cedrus_control_id {
> > +       CEDRUS_CTRL_DEC_MPEG2_SLICE_HEADER =3D 0,
> > +       CEDRUS_CTRL_MAX,
> > +};
> > +
> > +struct cedrus_control {
> > +       u32     id;
> > +       u32     elem_size;
> > +};
> > +
> > +struct cedrus_fmt {
> > +       u32             fourcc;
> > +       int             depth;
> > +       u32             types;
> > +       unsigned int    num_planes;
> > +};
> > +
> > +struct cedrus_mpeg2_run {
> > +       const struct v4l2_ctrl_mpeg2_slice_header       *hdr;
> > +};
> > +
> > +struct cedrus_run {
> > +       struct vb2_v4l2_buffer  *src;
> > +       struct vb2_v4l2_buffer  *dst;
> > +
> > +       union {
> > +               struct cedrus_mpeg2_run mpeg2;
> > +       };
> > +};
> > +
> > +struct cedrus_ctx {
> > +       struct v4l2_fh                  fh;
> > +       struct cedrus_dev               *dev;
> > +
> > +       struct cedrus_fmt               *vpu_src_fmt;
> > +       struct v4l2_pix_format_mplane   src_fmt;
> > +       struct cedrus_fmt               *vpu_dst_fmt;
> > +       struct v4l2_pix_format_mplane   dst_fmt;
> > +
> > +       struct v4l2_ctrl_handler        hdl;
> > +       struct v4l2_ctrl                *ctrls[CEDRUS_CTRL_MAX];
> > +
> > +       struct vb2_buffer               *dst_bufs[VIDEO_MAX_FRAME];
> > +
> > +       int                             job_abort;
> > +
> > +       struct work_struct              try_schedule_work;
> > +       struct work_struct              run_work;
> > +       struct list_head                src_list;
> > +       struct list_head                dst_list;
> > +};
> > +
> > +struct cedrus_buffer {
> > +       struct vb2_v4l2_buffer          vb;
> > +       enum vb2_buffer_state           state;
> > +       struct list_head                list;
> > +};
> > +
> > +struct cedrus_dev {
> > +       struct v4l2_device      v4l2_dev;
> > +       struct video_device     vfd;
> > +       struct media_device     mdev;
> > +       struct media_pad        pad[2];
> > +       struct platform_device  *pdev;
> > +       struct device           *dev;
> > +       struct v4l2_m2m_dev     *m2m_dev;
> > +
> > +       /* Device file mutex */
> > +       struct mutex            dev_mutex;
> > +       /* Interrupt spinlock */
> > +       spinlock_t              irq_lock;
> > +
> > +       void __iomem            *base;
> > +
> > +       struct clk              *mod_clk;
> > +       struct clk              *ahb_clk;
> > +       struct clk              *ram_clk;
> > +
> > +       struct reset_control    *rstc;
> > +};
> > +
> > +static inline void cedrus_write(struct cedrus_dev *dev, u32 reg, u32 v=
al)
> > +{
> > +       writel(val, dev->base + reg);
> > +}
> > +
> > +static inline u32 cedrus_read(struct cedrus_dev *dev, u32 reg)
> > +{
> > +       return readl(dev->base + reg);
> > +}
> > +
> > +#endif
> > diff --git a/drivers/media/platform/sunxi/cedrus/cedrus_dec.c b/drivers=
/media/platform/sunxi/cedrus/cedrus_dec.c
> > new file mode 100644
> > index 000000000000..bd9727ae9f63
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi/cedrus/cedrus_dec.c
> > @@ -0,0 +1,170 @@
> > +// SPDX-License-Identifier: GPL-2.0
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
> > + */
> > +
> > +#include <media/videobuf2-dma-contig.h>
> > +#include <media/v4l2-device.h>
> > +#include <media/v4l2-ioctl.h>
> > +#include <media/v4l2-ctrls.h>
> > +#include <media/v4l2-event.h>
> > +#include <media/v4l2-mem2mem.h>
> > +
> > +#include "cedrus.h"
> > +#include "cedrus_mpeg2.h"
> > +#include "cedrus_dec.h"
> > +#include "cedrus_hw.h"
> > +
> > +static inline void *get_ctrl_ptr(struct cedrus_ctx *ctx,
> > +                                enum cedrus_control_id id)
> > +{
> > +       struct v4l2_ctrl *ctrl =3D ctx->ctrls[id];
> > +
> > +       return ctrl->p_cur.p;
> > +}
> > +
> > +void cedrus_device_work(struct work_struct *work)
> > +{
> > +       struct cedrus_ctx *ctx =3D container_of(work,
> > +                                             struct cedrus_ctx, run_wo=
rk);
> > +       struct cedrus_dev *dev =3D ctx->dev;
> > +       struct cedrus_buffer *buffer_entry;
> > +       struct vb2_v4l2_buffer *src_buf, *dst_buf;
> > +       unsigned long flags;
> > +
> > +       spin_lock_irqsave(&ctx->dev->irq_lock, flags);
> > +
> > +       if (list_empty(&ctx->src_list) || list_empty(&ctx->dst_list)) {
> > +               v4l2_err(&dev->v4l2_dev,
> > +                        "Empty source and/or destination buffer lists\=
n");
> > +               spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
> > +               return;
> > +       }
> > +
> > +       buffer_entry =3D list_last_entry(&ctx->src_list, struct cedrus_=
buffer, list);
> > +       list_del(ctx->src_list.prev);
> > +
> > +       src_buf =3D &buffer_entry->vb;
> > +       v4l2_m2m_buf_done(src_buf, buffer_entry->state);
> > +
> > +       buffer_entry =3D list_last_entry(&ctx->dst_list, struct cedrus_=
buffer, list);
> > +       list_del(ctx->dst_list.prev);
> > +
> > +       dst_buf =3D &buffer_entry->vb;
> > +       v4l2_m2m_buf_done(dst_buf, buffer_entry->state);
> > +
> > +       spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
> > +
> > +       v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->fh.m2m_ctx);
> > +}
> > +
> > +void cedrus_device_run(void *priv)
> > +{
> > +       struct cedrus_ctx *ctx =3D priv;
> > +       struct cedrus_dev *dev =3D ctx->dev;
> > +       struct cedrus_run run =3D { 0 };
> > +       struct media_request *src_req;
> > +       unsigned long flags;
> > +
> > +       run.src =3D v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
> > +       if (!run.src) {
> > +               v4l2_err(&dev->v4l2_dev, "No source buffer to prepare\n=
");
>=20
> I believe it's a mem2mem core nasty bug if you can't get a source or dest=
ination
> buffer in .device_run. Perhaps catch it with WARN or BUG?
> Or just let the kernel burn, like other drivers do :-)

Yes you're right, this check is rather pointless, so I've just gotten
rid of it.

> > +               return;
> > +       }
> > +
> > +       run.dst =3D v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
> > +       if (!run.dst) {
> > +               v4l2_err(&dev->v4l2_dev, "No destination buffer to prep=
are\n");
> > +               return;
> > +       }
> > +
> > +       /* Apply request(s) controls if needed. */
> > +       src_req =3D run.src->vb2_buf.req_obj.req;
> > +
> > +       if (src_req)
> > +               v4l2_ctrl_request_setup(src_req, &ctx->hdl);
> > +
> > +       ctx->job_abort =3D 0;
> > +
> > +       spin_lock_irqsave(&ctx->dev->irq_lock, flags);
> > +
> > +       switch (ctx->vpu_src_fmt->fourcc) {
> > +       case V4L2_PIX_FMT_MPEG2_SLICE:
> > +               if (!ctx->ctrls[CEDRUS_CTRL_DEC_MPEG2_SLICE_HEADER]) {
> > +                       v4l2_err(&dev->v4l2_dev,
> > +                                "Invalid MPEG2 frame header control\n"=
);
> > +                       ctx->job_abort =3D 1;
> > +                       goto unlock_complete;
> > +               }
> > +
> > +               run.mpeg2.hdr =3D get_ctrl_ptr(ctx, CEDRUS_CTRL_DEC_MPE=
G2_SLICE_HEADER);
> > +               cedrus_mpeg2_setup(ctx, &run);
> > +               break;
> > +
> > +       default:
> > +               ctx->job_abort =3D 1;
> > +       }
> > +
> > +unlock_complete:
> > +       spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
> > +
> > +       /* Complete request(s) controls if needed. */
> > +
> > +       if (src_req)
> > +               v4l2_ctrl_request_complete(src_req, &ctx->hdl);
> > +
> > +       spin_lock_irqsave(&ctx->dev->irq_lock, flags);
> > +
> > +       if (!ctx->job_abort) {
> > +               if (ctx->vpu_src_fmt->fourcc =3D=3D V4L2_PIX_FMT_MPEG2_=
SLICE)
> > +                       cedrus_mpeg2_trigger(ctx);
> > +       } else {
> > +               v4l2_m2m_buf_done(run.src, VB2_BUF_STATE_ERROR);
> > +               v4l2_m2m_buf_done(run.dst, VB2_BUF_STATE_ERROR);
> > +       }
> > +
> > +       spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
> > +
> > +       if (ctx->job_abort)
> > +               v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->fh.m2m_ctx)=
;
> > +}
> > +
> > +void cedrus_job_abort(void *priv)
> > +{
> > +       struct cedrus_ctx *ctx =3D priv;
> > +       struct vb2_v4l2_buffer *src_buf, *dst_buf;
> > +       unsigned long flags;
> > +
> > +       ctx->job_abort =3D 1;
> > +
>=20
> If you can't actually cancel the DMA operation,
> then perhaps you want to simply not define .job_abort,
> and wait for the running operation (if any) to finish.
>=20
> See https://www.mail-archive.com/linux-media@vger.kernel.org/msg132881.ht=
ml
>=20
> It should also cleanup your impementation. The whole ctx->job_abort
> dance looks kinda cumbersome.

Okay, I'll keep that in mind and probably get rid of the whole thing if
there is nothing sensible that we can do to abort the job at hardware
level. It used to be relevant to keep it around for controls validation,
but that's no longer the case.

Since it seems that your series has not landed yet, I'll keep it around
for v6.

> > +       /*
> > +        * V4L2 M2M and request API cleanup is done here while hardware=
 state
> > +        * cleanup is done in the interrupt context. Doing all the clea=
nup in
> > +        * the interrupt context is a bit risky, since the job_abort ca=
ll might
> > +        * originate from the release hook, where interrupts have alrea=
dy been
> > +        * disabled.
> > +        */
> > +
> > +       spin_lock_irqsave(&ctx->dev->irq_lock, flags);
> > +
> > +       src_buf =3D v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> > +       if (src_buf)
> > +               v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
> > +
> > +       dst_buf =3D v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
> > +       if (dst_buf)
> > +               v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
> > +
> > +       spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
> > +
> > +       v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->fh.m2m_ctx);
> > +}
> > diff --git a/drivers/media/platform/sunxi/cedrus/cedrus_dec.h b/drivers=
/media/platform/sunxi/cedrus/cedrus_dec.h
> > new file mode 100644
> > index 000000000000..b38812136504
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi/cedrus/cedrus_dec.h
> > @@ -0,0 +1,27 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
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
> > + */
> > +
> > +#ifndef _CEDRUS_DEC_H_
> > +#define _CEDRUS_DEC_H_
> > +
> > +extern const struct v4l2_ioctl_ops cedrus_ioctl_ops;
> > +
> > +void cedrus_device_work(struct work_struct *work);
> > +void cedrus_device_run(void *priv);
> > +void cedrus_job_abort(void *priv);
> > +
> > +int cedrus_queue_init(void *priv, struct vb2_queue *src_vq,
> > +                     struct vb2_queue *dst_vq);
> > +
> > +#endif
> > diff --git a/drivers/media/platform/sunxi/cedrus/cedrus_hw.c b/drivers/=
media/platform/sunxi/cedrus/cedrus_hw.c
> > new file mode 100644
> > index 000000000000..9ee1380f4e30
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi/cedrus/cedrus_hw.c
> > @@ -0,0 +1,262 @@
> > +// SPDX-License-Identifier: GPL-2.0
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
> > + */
> > +
> > +#include <linux/platform_device.h>
> > +#include <linux/of_reserved_mem.h>
> > +#include <linux/dma-mapping.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/clk.h>
> > +#include <linux/regmap.h>
> > +#include <linux/reset.h>
> > +#include <linux/soc/sunxi/sunxi_sram.h>
> > +
> > +#include <media/videobuf2-core.h>
> > +#include <media/v4l2-mem2mem.h>
> > +
> > +#include "cedrus.h"
> > +#include "cedrus_hw.h"
> > +#include "cedrus_regs.h"
> > +
> > +int cedrus_engine_enable(struct cedrus_dev *dev, enum cedrus_engine en=
gine)
> > +{
> > +       u32 reg =3D 0;
> > +
> > +       /*
> > +        * FIXME: This is only valid on 32-bits DDR's, we should test
> > +        * it on the A13/A33.
> > +        */
> > +       reg |=3D VE_CTRL_REC_WR_MODE_2MB;
> > +
> > +       reg |=3D VE_CTRL_CACHE_BUS_BW_128;
> > +
> > +       switch (engine) {
> > +       case CEDRUS_ENGINE_MPEG:
> > +               reg |=3D VE_CTRL_DEC_MODE_MPEG;
> > +               break;
> > +
> > +       default:
> > +               return -EINVAL;
> > +       }
> > +
> > +       cedrus_write(dev, VE_CTRL, reg);
> > +
> > +       return 0;
> > +}
> > +
> > +void cedrus_engine_disable(struct cedrus_dev *dev)
> > +{
> > +       cedrus_write(dev, VE_CTRL, VE_CTRL_DEC_MODE_DISABLED);
> > +}
> > +
> > +static irqreturn_t cedrus_ve_irq(int irq, void *data)
> > +{
> > +       struct cedrus_dev *dev =3D data;
> > +       struct cedrus_ctx *ctx;
> > +       struct cedrus_buffer *src_buffer, *dst_buffer;
> > +       struct vb2_v4l2_buffer *src_vb, *dst_vb;
> > +       unsigned long flags;
> > +       unsigned int value, status;
> > +
> > +       spin_lock_irqsave(&dev->irq_lock, flags);
> > +
> > +       /* Disable MPEG interrupts and stop the MPEG engine. */
> > +       value =3D cedrus_read(dev, VE_MPEG_CTRL);
> > +       cedrus_write(dev, VE_MPEG_CTRL, value & (~0xf));
> > +
> > +       status =3D cedrus_read(dev, VE_MPEG_STATUS);
> > +       cedrus_write(dev, VE_MPEG_STATUS, 0x0000c00f);
> > +       cedrus_engine_disable(dev);
> > +
> > +       ctx =3D v4l2_m2m_get_curr_priv(dev->m2m_dev);
> > +       if (!ctx) {
> > +               v4l2_err(&dev->v4l2_dev,
> > +                        "Instance released before the end of transacti=
on\n");
> > +               spin_unlock_irqrestore(&dev->irq_lock, flags);
> > +
> > +               return IRQ_HANDLED;
> > +       }
> > +
> > +       src_vb =3D v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> > +       dst_vb =3D v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
> > +
> > +       if (!src_vb || !dst_vb) {
> > +               v4l2_err(&dev->v4l2_dev,
> > +                        "Missing source and/or destination buffers\n")=
;
> > +               spin_unlock_irqrestore(&dev->irq_lock, flags);
> > +
> > +               return IRQ_HANDLED;
> > +       }
> > +
> > +       src_buffer =3D container_of(src_vb, struct cedrus_buffer, vb);
> > +       dst_buffer =3D container_of(dst_vb, struct cedrus_buffer, vb);
> > +
> > +       /* First bit of MPEG_STATUS indicates success. */
> > +       if (ctx->job_abort || !(status & 0x01))
> > +               src_buffer->state =3D dst_buffer->state =3D VB2_BUF_STA=
TE_ERROR;
> > +       else
> > +               src_buffer->state =3D dst_buffer->state =3D VB2_BUF_STA=
TE_DONE;
> > +
> > +       list_add_tail(&src_buffer->list, &ctx->src_list);
> > +       list_add_tail(&dst_buffer->list, &ctx->dst_list);
> > +
> > +       spin_unlock_irqrestore(&dev->irq_lock, flags);
> > +
> > +       schedule_work(&ctx->run_work);
> > +
> > +       return IRQ_HANDLED;
> > +}
> > +
> > +int cedrus_hw_probe(struct cedrus_dev *dev)
> > +{
> > +       struct resource *res;
> > +       int irq_dec;
> > +       int ret;
> > +
> > +       irq_dec =3D platform_get_irq(dev->pdev, 0);
> > +       if (irq_dec <=3D 0) {
> > +               v4l2_err(&dev->v4l2_dev, "Failed to get IRQ\n");
> > +               return -ENXIO;
> > +       }
> > +       ret =3D devm_request_irq(dev->dev, irq_dec, cedrus_ve_irq, 0,
> > +                              dev_name(dev->dev), dev);
> > +       if (ret) {
> > +               v4l2_err(&dev->v4l2_dev, "Failed to request IRQ\n");
> > +               return -ENXIO;
> > +       }
> > +
> > +       /*
> > +        * The VPU is only able to handle bus addresses so we have to s=
ubtract
> > +        * the RAM offset to the physcal addresses.
> > +        */
> > +       dev->dev->dma_pfn_offset =3D PHYS_PFN_OFFSET;
> > +
> > +       ret =3D of_reserved_mem_device_init(dev->dev);
> > +       if (ret && ret !=3D -ENODEV) {
> > +               v4l2_err(&dev->v4l2_dev, "Failed to reserved memory\n")=
;
> > +               return -ENODEV;
> > +       }
> > +
> > +       ret =3D sunxi_sram_claim(dev->dev);
> > +       if (ret) {
> > +               v4l2_err(&dev->v4l2_dev, "Failed to claim SRAM\n");
> > +               goto err_mem;
> > +       }
> > +
> > +       dev->ahb_clk =3D devm_clk_get(dev->dev, "ahb");
> > +       if (IS_ERR(dev->ahb_clk)) {
> > +               v4l2_err(&dev->v4l2_dev, "Failed to get AHB clock\n");
> > +
> > +               ret =3D PTR_ERR(dev->ahb_clk);
> > +               goto err_sram;
> > +       }
> > +
> > +       dev->mod_clk =3D devm_clk_get(dev->dev, "mod");
> > +       if (IS_ERR(dev->mod_clk)) {
> > +               v4l2_err(&dev->v4l2_dev, "Failed to get MOD clock\n");
> > +
> > +               ret =3D PTR_ERR(dev->mod_clk);
> > +               goto err_sram;
> > +       }
> > +
> > +       dev->ram_clk =3D devm_clk_get(dev->dev, "ram");
> > +       if (IS_ERR(dev->ram_clk)) {
> > +               v4l2_err(&dev->v4l2_dev, "Failed to get RAM clock\n");
> > +
> > +               ret =3D PTR_ERR(dev->ram_clk);
> > +               goto err_sram;
> > +       }
> > +
> > +       dev->rstc =3D devm_reset_control_get(dev->dev, NULL);
> > +       if (IS_ERR(dev->rstc)) {
> > +               v4l2_err(&dev->v4l2_dev, "Failed to get reset control\n=
");
> > +
> > +               ret =3D PTR_ERR(dev->rstc);
> > +               goto err_sram;
> > +       }
> > +
> > +       res =3D platform_get_resource(dev->pdev, IORESOURCE_MEM, 0);
> > +       dev->base =3D devm_ioremap_resource(dev->dev, res);
> > +       if (!dev->base) {
> > +               v4l2_err(&dev->v4l2_dev, "Failed to map registers\n");
> > +
> > +               ret =3D -EFAULT;
> > +               goto err_sram;
> > +       }
> > +
> > +       ret =3D clk_set_rate(dev->mod_clk, CEDRUS_CLOCK_RATE_DEFAULT);
> > +       if (ret) {
> > +               v4l2_err(&dev->v4l2_dev, "Failed to set clock rate\n");
> > +               goto err_sram;
> > +       }
> > +
> > +       ret =3D clk_prepare_enable(dev->ahb_clk);
> > +       if (ret) {
> > +               v4l2_err(&dev->v4l2_dev, "Failed to enable AHB clock\n"=
);
> > +
> > +               ret =3D -EFAULT;
> > +               goto err_sram;
> > +       }
> > +
> > +       ret =3D clk_prepare_enable(dev->mod_clk);
> > +       if (ret) {
> > +               v4l2_err(&dev->v4l2_dev, "Failed to enable MOD clock\n"=
);
> > +
> > +               ret =3D -EFAULT;
> > +               goto err_ahb_clk;
> > +       }
> > +
> > +       ret =3D clk_prepare_enable(dev->ram_clk);
> > +       if (ret) {
> > +               v4l2_err(&dev->v4l2_dev, "Failed to enable RAM clock\n"=
);
> > +
> > +               ret =3D -EFAULT;
> > +               goto err_mod_clk;
> > +       }
> > +
>=20
> This might look cleaner with the clock bulk API.
>=20
> Also, have you considered clock enable/disable in open/release,
> or start/stop? (possibly, via pm runtime).

We are interested in implementing runtime pm, but this is not really on
our priorities for now so we'll probably keep it for after the driver is
merged.

> > +       ret =3D reset_control_reset(dev->rstc);
> > +       if (ret) {
> > +               v4l2_err(&dev->v4l2_dev, "Failed to apply reset\n");
> > +
> > +               ret =3D -EFAULT;
> > +               goto err_ram_clk;
> > +       }
> > +
> > +       return 0;
> > +
> > +err_ram_clk:
> > +       clk_disable_unprepare(dev->ram_clk);
> > +err_mod_clk:
> > +       clk_disable_unprepare(dev->mod_clk);
> > +err_ahb_clk:
> > +       clk_disable_unprepare(dev->ahb_clk);
> > +err_sram:
> > +       sunxi_sram_release(dev->dev);
> > +err_mem:
> > +       of_reserved_mem_device_release(dev->dev);
> > +
> > +       return ret;
> > +}
> > +
> > +void cedrus_hw_remove(struct cedrus_dev *dev)
> > +{
> > +       reset_control_assert(dev->rstc);
> > +
> > +       clk_disable_unprepare(dev->ram_clk);
> > +       clk_disable_unprepare(dev->mod_clk);
> > +       clk_disable_unprepare(dev->ahb_clk);
> > +
> > +       sunxi_sram_release(dev->dev);
> > +
> > +       of_reserved_mem_device_release(dev->dev);
> > +}
> > diff --git a/drivers/media/platform/sunxi/cedrus/cedrus_hw.h b/drivers/=
media/platform/sunxi/cedrus/cedrus_hw.h
> > new file mode 100644
> > index 000000000000..ead4f5089881
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi/cedrus/cedrus_hw.h
> > @@ -0,0 +1,30 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
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
> > + */
> > +
> > +#ifndef _CEDRUS_HW_H_
> > +#define _CEDRUS_HW_H_
> > +
> > +#define CEDRUS_CLOCK_RATE_DEFAULT      320000000
> > +
>=20
> This define is only used in cedrus_hw.c. Perhaps shouldn't belong
> in a header.

I have a personal preference for keeping constants defines in headers,
but I can reconsider that if you think it's a bad practice.

> > +enum cedrus_engine {
> > +       CEDRUS_ENGINE_MPEG,
> > +};
> > +
> > +int cedrus_engine_enable(struct cedrus_dev *dev, enum cedrus_engine en=
gine);
> > +void cedrus_engine_disable(struct cedrus_dev *dev);
> > +
> > +int cedrus_hw_probe(struct cedrus_dev *dev);
> > +void cedrus_hw_remove(struct cedrus_dev *dev);
> > +
> > +#endif
> > diff --git a/drivers/media/platform/sunxi/cedrus/cedrus_mpeg2.c b/drive=
rs/media/platform/sunxi/cedrus/cedrus_mpeg2.c
> > new file mode 100644
> > index 000000000000..0d6dcaec73b3
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi/cedrus/cedrus_mpeg2.c
> > @@ -0,0 +1,146 @@
> > +// SPDX-License-Identifier: GPL-2.0
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
> > + */
> > +
> > +#include <media/videobuf2-dma-contig.h>
> > +
> > +#include "cedrus.h"
> > +#include "cedrus_hw.h"
> > +#include "cedrus_regs.h"
> > +
> > +static const u8 mpeg_default_intra_quant[64] =3D {
> > +       8, 16, 16, 19, 16, 19, 22, 22,
> > +       22, 22, 22, 22, 26, 24, 26, 27,
> > +       27, 27, 26, 26, 26, 26, 27, 27,
> > +       27, 29, 29, 29, 34, 34, 34, 29,
> > +       29, 29, 27, 27, 29, 29, 32, 32,
> > +       34, 34, 37, 38, 37, 35, 35, 34,
> > +       35, 38, 38, 40, 40, 40, 48, 48,
> > +       46, 46, 56, 56, 58, 69, 69, 83
> > +};
> > +
> > +#define m_iq(i) (((64 + i) << 8) | mpeg_default_intra_quant[i])
> > +
> > +static const u8 mpeg_default_non_intra_quant[64] =3D {
> > +       16, 16, 16, 16, 16, 16, 16, 16,
> > +       16, 16, 16, 16, 16, 16, 16, 16,
> > +       16, 16, 16, 16, 16, 16, 16, 16,
> > +       16, 16, 16, 16, 16, 16, 16, 16,
> > +       16, 16, 16, 16, 16, 16, 16, 16,
> > +       16, 16, 16, 16, 16, 16, 16, 16,
> > +       16, 16, 16, 16, 16, 16, 16, 16,
> > +       16, 16, 16, 16, 16, 16, 16, 16
> > +};
> > +
> > +#define m_niq(i) ((i << 8) | mpeg_default_non_intra_quant[i])
> > +
> > +void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run=
)
> > +{
> > +       struct cedrus_dev *dev =3D ctx->dev;
> > +       const struct v4l2_ctrl_mpeg2_slice_header *frame_hdr =3D run->m=
peg2.hdr;
> > +
> > +       u16 width =3D DIV_ROUND_UP(frame_hdr->width, 16);
> > +       u16 height =3D DIV_ROUND_UP(frame_hdr->height, 16);
> > +
> > +       u32 pic_header =3D 0;
> > +       u32 vld_len =3D frame_hdr->slice_len - frame_hdr->slice_pos;
> > +       int i;
> > +
> > +       struct vb2_buffer *fwd_vb2_buf, *bwd_vb2_buf;
> > +       dma_addr_t src_buf_addr, dst_luma_addr, dst_chroma_addr;
> > +       dma_addr_t fwd_luma =3D 0, fwd_chroma =3D 0, bwd_luma =3D 0, bw=
d_chroma =3D 0;
> > +
> > +       fwd_vb2_buf =3D ctx->dst_bufs[frame_hdr->forward_ref_index];
> > +       if (fwd_vb2_buf) {
> > +               fwd_luma =3D vb2_dma_contig_plane_dma_addr(fwd_vb2_buf,=
 0);
> > +               fwd_chroma =3D vb2_dma_contig_plane_dma_addr(fwd_vb2_bu=
f, 1);
> > +       }
> > +
> > +       bwd_vb2_buf =3D ctx->dst_bufs[frame_hdr->backward_ref_index];
> > +       if (bwd_vb2_buf) {
> > +               bwd_luma =3D vb2_dma_contig_plane_dma_addr(bwd_vb2_buf,=
 0);
> > +               bwd_chroma =3D vb2_dma_contig_plane_dma_addr(bwd_vb2_bu=
f, 1);
> > +       }
> > +
> > +       /* Activate MPEG engine. */
> > +       cedrus_engine_enable(dev, CEDRUS_ENGINE_MPEG);
> > +
> > +       /* Set quantization matrices. */
> > +       for (i =3D 0; i < 64; i++) {
> > +               cedrus_write(dev, VE_MPEG_IQ_MIN_INPUT, m_iq(i));
> > +               cedrus_write(dev, VE_MPEG_IQ_MIN_INPUT, m_niq(i));
> > +       }
> > +
> > +       /* Set frame dimensions. */
> > +       cedrus_write(dev, VE_MPEG_SIZE, width << 8 | height);
> > +       cedrus_write(dev, VE_MPEG_FRAME_SIZE, width << 20 | height << 4=
);
> > +
> > +       /* Set MPEG picture header. */
> > +       pic_header |=3D (frame_hdr->picture_coding_type & 0xf) << 28;
> > +       pic_header |=3D (frame_hdr->f_code[0][0] & 0xf) << 24;
> > +       pic_header |=3D (frame_hdr->f_code[0][1] & 0xf) << 20;
> > +       pic_header |=3D (frame_hdr->f_code[1][0] & 0xf) << 16;
> > +       pic_header |=3D (frame_hdr->f_code[1][1] & 0xf) << 12;
> > +       pic_header |=3D (frame_hdr->intra_dc_precision & 0x3) << 10;
> > +       pic_header |=3D (frame_hdr->picture_structure & 0x3) << 8;
> > +       pic_header |=3D (frame_hdr->top_field_first & 0x1) << 7;
> > +       pic_header |=3D (frame_hdr->frame_pred_frame_dct & 0x1) << 6;
> > +       pic_header |=3D (frame_hdr->concealment_motion_vectors & 0x1) <=
< 5;
> > +       pic_header |=3D (frame_hdr->q_scale_type & 0x1) << 4;
> > +       pic_header |=3D (frame_hdr->intra_vlc_format & 0x1) << 3;
> > +       pic_header |=3D (frame_hdr->alternate_scan & 0x1) << 2;
> > +       cedrus_write(dev, VE_MPEG_PIC_HDR, pic_header);
> > +
> > +       /* Enable interrupt and an unknown control flag. */
> > +       cedrus_write(dev, VE_MPEG_CTRL, VE_MPEG_CTRL_MPEG2);
> > +
> > +       /* Macroblock address. */
> > +       cedrus_write(dev, VE_MPEG_MBA, 0);
> > +
> > +       /* Clear previous errors. */
> > +       cedrus_write(dev, VE_MPEG_ERROR, 0);
> > +
> > +       /* Clear correct macroblocks register. */
> > +       cedrus_write(dev, VE_MPEG_CTR_MB, 0);
> > +
> > +       /* Forward and backward prediction reference buffers. */
> > +       cedrus_write(dev, VE_MPEG_FWD_LUMA, fwd_luma);
> > +       cedrus_write(dev, VE_MPEG_FWD_CHROMA, fwd_chroma);
> > +       cedrus_write(dev, VE_MPEG_BACK_LUMA, bwd_luma);
> > +       cedrus_write(dev, VE_MPEG_BACK_CHROMA, bwd_chroma);
> > +
> > +       /* Destination luma and chroma buffers. */
> > +       dst_luma_addr =3D vb2_dma_contig_plane_dma_addr(&run->dst->vb2_=
buf, 0);
> > +       dst_chroma_addr =3D vb2_dma_contig_plane_dma_addr(&run->dst->vb=
2_buf, 1);
> > +       cedrus_write(dev, VE_MPEG_REC_LUMA, dst_luma_addr);
> > +       cedrus_write(dev, VE_MPEG_REC_CHROMA, dst_chroma_addr);
> > +       cedrus_write(dev, VE_MPEG_ROT_LUMA, dst_luma_addr);
> > +       cedrus_write(dev, VE_MPEG_ROT_CHROMA, dst_chroma_addr);
> > +
> > +       /* Source offset and length in bits. */
> > +       cedrus_write(dev, VE_MPEG_VLD_OFFSET, frame_hdr->slice_pos);
> > +       cedrus_write(dev, VE_MPEG_VLD_LEN, vld_len);
> > +
> > +       /* Source beginning and end addresses. */
> > +       src_buf_addr =3D vb2_dma_contig_plane_dma_addr(&run->src->vb2_b=
uf, 0);
> > +       cedrus_write(dev, VE_MPEG_VLD_ADDR, VE_MPEG_VLD_ADDR_VAL(src_bu=
f_addr));
> > +       cedrus_write(dev, VE_MPEG_VLD_END, src_buf_addr + VBV_SIZE - 1)=
;
> > +}
> > +
> > +void cedrus_mpeg2_trigger(struct cedrus_ctx *ctx)
> > +{
> > +       struct cedrus_dev *dev =3D ctx->dev;
> > +
> > +       /* Trigger MPEG engine. */
> > +       cedrus_write(dev, VE_MPEG_TRIGGER, VE_TRIG_MPEG2);
> > +}
> > diff --git a/drivers/media/platform/sunxi/cedrus/cedrus_mpeg2.h b/drive=
rs/media/platform/sunxi/cedrus/cedrus_mpeg2.h
> > new file mode 100644
> > index 000000000000..fd864fab6986
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi/cedrus/cedrus_mpeg2.h
> > @@ -0,0 +1,24 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
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
> > + */
> > +
> > +#ifndef _CEDRUS_MPEG2_H_
> > +#define _CEDRUS_MPEG2_H_
> > +
> > +struct cedrus_ctx;
> > +struct cedrus_run;
> > +
> > +void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run=
);
> > +void cedrus_mpeg2_trigger(struct cedrus_ctx *ctx);
> > +
> > +#endif
> > diff --git a/drivers/media/platform/sunxi/cedrus/cedrus_regs.h b/driver=
s/media/platform/sunxi/cedrus/cedrus_regs.h
> > new file mode 100644
> > index 000000000000..442befcdb6ea
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi/cedrus/cedrus_regs.h
> > @@ -0,0 +1,167 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
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
> > + */
> > +
> > +#ifndef _CEDRUS_REGS_H_
> > +#define _CEDRUS_REGS_H_
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
> > +#define VE_MPEG_CTRL_MPEG2     0x800001b8
> > +#define VE_MPEG_CTRL_MPEG4     (0x80084118 | BIT(7))
> > +#define VE_MPEG_CTRL_MPEG4_P   (VE_MPEG_CTRL_MPEG4 | BIT(12))
> > +
> > +/* VE_MPEG_VLD_ADDR:
> > + * The bits 27 to 4 are used for the address
> > + * The bits 31 to 28 (0x7) are used to select the MPEG or JPEG engine
> > + */
> > +#define VE_MPEG_VLD_ADDR_VAL(x)        ((x & 0x0ffffff0) | (x >> 28) |=
 (0x7 << 28))
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
> > +#define VE_TRIG_MPEG1          0x8100000f
> > +#define VE_TRIG_MPEG2          0x8200000f
> > +#define VE_TRIG_MPEG4(w, h)    (0x8400000d | ((w * h) << 8))
> > +
> > +/* VE_MPEG_SDROT_CTRL:
> > + * The bit 8 at zero is used to disable x downscaling
> > + * The bit 10 at 0 is used to disable y downscaling
> > + * The other bits are unknown but needed
> > + */
> > +#define VE_NO_SDROT_CTRL       0x40620000
> > +
> > +/* Decent size fo video buffering verifier */
> > +#define VBV_SIZE               (1024 * 1024)
> > +
> > +/* Registers addresses */
> > +#define VE_CTRL                                0x000
> > +/*
> > + * The datasheet states that this should be set to 2MB on a 32bits
> > + * DDR-3.
> > + */
> > +#define VE_CTRL_REC_WR_MODE_2MB                        (1 << 20)
> > +#define VE_CTRL_REC_WR_MODE_1MB                        (0 << 20)
> > +
> > +#define VE_CTRL_CACHE_BUS_BW_128               (3 << 16)
> > +#define VE_CTRL_CACHE_BUS_BW_256               (2 << 16)
> > +
> > +#define VE_CTRL_DEC_MODE_DISABLED              (7 << 0)
> > +#define VE_CTRL_DEC_MODE_H265                  (4 << 0)
> > +#define VE_CTRL_DEC_MODE_H264                  (1 << 0)
> > +#define VE_CTRL_DEC_MODE_MPEG                  (0 << 0)
> > +
> > +#define VE_VERSION                     0x0f0
> > +
> > +#define VE_MPEG_PIC_HDR                        0x100
> > +#define VE_MPEG_VOP_HDR                        0x104
> > +#define VE_MPEG_SIZE                   0x108
> > +#define VE_MPEG_FRAME_SIZE             0x10c
> > +#define VE_MPEG_MBA                    0x110
> > +#define VE_MPEG_CTRL                   0x114
> > +#define VE_MPEG_TRIGGER                        0x118
> > +#define VE_MPEG_STATUS                 0x11c
> > +#define VE_MPEG_TRBTRD_FIELD           0x120
> > +#define VE_MPEG_TRBTRD_FRAME           0x124
> > +#define VE_MPEG_VLD_ADDR               0x128
> > +#define VE_MPEG_VLD_OFFSET             0x12c
> > +#define VE_MPEG_VLD_LEN                        0x130
> > +#define VE_MPEG_VLD_END                        0x134
> > +#define VE_MPEG_MBH_ADDR               0x138
> > +#define VE_MPEG_DCAC_ADDR              0x13c
> > +#define VE_MPEG_NCF_ADDR               0x144
> > +#define VE_MPEG_REC_LUMA               0x148
> > +#define VE_MPEG_REC_CHROMA             0x14c
> > +#define VE_MPEG_FWD_LUMA               0x150
> > +#define VE_MPEG_FWD_CHROMA             0x154
> > +#define VE_MPEG_BACK_LUMA              0x158
> > +#define VE_MPEG_BACK_CHROMA            0x15c
> > +#define VE_MPEG_IQ_MIN_INPUT           0x180
> > +#define VE_MPEG_QP_INPUT               0x184
> > +#define VE_MPEG_JPEG_SIZE              0x1b8
> > +#define VE_MPEG_JPEG_RES_INT           0x1c0
> > +#define VE_MPEG_ERROR                  0x1c4
> > +#define VE_MPEG_CTR_MB                 0x1c8
> > +#define VE_MPEG_ROT_LUMA               0x1cc
> > +#define VE_MPEG_ROT_CHROMA             0x1d0
> > +#define VE_MPEG_SDROT_CTRL             0x1d4
> > +#define VE_MPEG_RAM_WRITE_PTR          0x1e0
> > +#define VE_MPEG_RAM_WRITE_DATA         0x1e4
> > +
> > +#define VE_H264_FRAME_SIZE             0x200
> > +#define VE_H264_PIC_HDR                        0x204
> > +#define VE_H264_SLICE_HDR              0x208
> > +#define VE_H264_SLICE_HDR2             0x20c
> > +#define VE_H264_PRED_WEIGHT            0x210
> > +#define VE_H264_QP_PARAM               0x21c
> > +#define VE_H264_CTRL                   0x220
> > +#define VE_H264_TRIGGER                        0x224
> > +#define VE_H264_STATUS                 0x228
> > +#define VE_H264_CUR_MB_NUM             0x22c
> > +#define VE_H264_VLD_ADDR               0x230
> > +#define VE_H264_VLD_OFFSET             0x234
> > +#define VE_H264_VLD_LEN                        0x238
> > +#define VE_H264_VLD_END                        0x23c
> > +#define VE_H264_SDROT_CTRL             0x240
> > +#define VE_H264_OUTPUT_FRAME_IDX       0x24c
> > +#define VE_H264_EXTRA_BUFFER1          0x250
> > +#define VE_H264_EXTRA_BUFFER2          0x254
> > +#define VE_H264_BASIC_BITS             0x2dc
> > +#define VE_H264_RAM_WRITE_PTR          0x2e0
> > +#define VE_H264_RAM_WRITE_DATA         0x2e4
> > +
> > +#define VE_SRAM_H264_PRED_WEIGHT_TABLE 0x000
> > +#define VE_SRAM_H264_FRAMEBUFFER_LIST  0x400
> > +#define VE_SRAM_H264_REF_LIST0         0x640
> > +#define VE_SRAM_H264_REF_LIST1         0x664
> > +#define VE_SRAM_H264_SCALING_LISTS     0x800
> > +
> > +#define VE_ISP_INPUT_SIZE              0xa00
> > +#define VE_ISP_INPUT_STRIDE            0xa04
> > +#define VE_ISP_CTRL                    0xa08
> > +#define VE_ISP_INPUT_LUMA              0xa78
> > +#define VE_ISP_INPUT_CHROMA            0xa7c
> > +
> > +#define VE_AVC_PARAM                   0xb04
> > +#define VE_AVC_QP                      0xb08
> > +#define VE_AVC_MOTION_EST              0xb10
> > +#define VE_AVC_CTRL                    0xb14
> > +#define VE_AVC_TRIGGER                 0xb18
> > +#define VE_AVC_STATUS                  0xb1c
> > +#define VE_AVC_BASIC_BITS              0xb20
> > +#define VE_AVC_UNK_BUF                 0xb60
> > +#define VE_AVC_VLE_ADDR                        0xb80
> > +#define VE_AVC_VLE_END                 0xb84
> > +#define VE_AVC_VLE_OFFSET              0xb88
> > +#define VE_AVC_VLE_MAX                 0xb8c
> > +#define VE_AVC_VLE_LENGTH              0xb90
> > +#define VE_AVC_REF_LUMA                        0xba0
> > +#define VE_AVC_REF_CHROMA              0xba4
> > +#define VE_AVC_REC_LUMA                        0xbb0
> > +#define VE_AVC_REC_CHROMA              0xbb4
> > +#define VE_AVC_REF_SLUMA               0xbb8
> > +#define VE_AVC_REC_SLUMA               0xbbc
> > +#define VE_AVC_MB_INFO                 0xbc0
> > +
> > +#endif
> > diff --git a/drivers/media/platform/sunxi/cedrus/cedrus_video.c b/drive=
rs/media/platform/sunxi/cedrus/cedrus_video.c
> > new file mode 100644
> > index 000000000000..ad7da8d36966
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi/cedrus/cedrus_video.c
> > @@ -0,0 +1,502 @@
> > +// SPDX-License-Identifier: GPL-2.0
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
> > + */
> > +
> > +#include <media/videobuf2-dma-contig.h>
> > +#include <media/v4l2-device.h>
> > +#include <media/v4l2-ioctl.h>
> > +#include <media/v4l2-ctrls.h>
> > +#include <media/v4l2-event.h>
> > +#include <media/v4l2-mem2mem.h>
> > +
> > +#include "cedrus.h"
> > +#include "cedrus_mpeg2.h"
> > +#include "cedrus_dec.h"
> > +#include "cedrus_hw.h"
> > +
> > +/* Flags that indicate a format can be used for capture/output. */
> > +#define CEDRUS_CAPTURE BIT(0)
> > +#define CEDRUS_OUTPUT  BIT(1)
> > +
> > +#define CEDRUS_MIN_WIDTH       16U
> > +#define CEDRUS_MIN_HEIGHT      16U
> > +#define CEDRUS_MAX_WIDTH       3840U
> > +#define CEDRUS_MAX_HEIGHT      2160U
> > +
> > +static struct cedrus_fmt formats[] =3D {
> > +       {
> > +               .fourcc =3D V4L2_PIX_FMT_MB32_NV12,
> > +               .types  =3D CEDRUS_CAPTURE,
> > +               .depth =3D 2,
> > +               .num_planes =3D 2,
> > +       },
> > +       {
> > +               .fourcc =3D V4L2_PIX_FMT_MPEG2_SLICE,
> > +               .types  =3D CEDRUS_OUTPUT,
> > +               .num_planes =3D 1,
> > +       },
> > +};
> > +
> > +#define NUM_FORMATS ARRAY_SIZE(formats)
> > +
> > +static struct cedrus_fmt *find_format(struct v4l2_format *f)
> > +{
> > +       struct cedrus_fmt *fmt;
> > +       unsigned int k;
> > +
> > +       for (k =3D 0; k < NUM_FORMATS; k++) {
> > +               fmt =3D &formats[k];
> > +               if (fmt->fourcc =3D=3D f->fmt.pix_mp.pixelformat)
> > +                       break;
> > +       }
> > +
> > +       if (k =3D=3D NUM_FORMATS)
> > +               return NULL;
> > +
> > +       return &formats[k];
> > +}
> > +
> > +static inline struct cedrus_ctx *file2ctx(struct file *file)
> > +{
> > +       return container_of(file->private_data, struct cedrus_ctx, fh);
> > +}
> > +
> > +static int vidioc_querycap(struct file *file, void *priv,
> > +                          struct v4l2_capability *cap)
> > +{
> > +       strncpy(cap->driver, CEDRUS_NAME, sizeof(cap->driver) - 1);
> > +       strncpy(cap->card, CEDRUS_NAME, sizeof(cap->card) - 1);
> > +       snprintf(cap->bus_info, sizeof(cap->bus_info),
> > +                "platform:%s", CEDRUS_NAME);
> > +       cap->device_caps =3D V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREA=
MING;
> > +       cap->capabilities =3D cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> > +       return 0;
> > +}
> > +
> > +static int enum_fmt(struct v4l2_fmtdesc *f, u32 type)
> > +{
> > +       struct cedrus_fmt *fmt;
> > +       int i, num =3D 0;
> > +
> > +       for (i =3D 0; i < NUM_FORMATS; ++i) {
> > +               if (formats[i].types & type) {
> > +                       /* index-th format of type type found ? */
> > +                       if (num =3D=3D f->index)
> > +                               break;
> > +                       /*
> > +                        * Correct type but haven't reached our index y=
et,
> > +                        * just increment per-type index
> > +                        */
> > +                       ++num;
> > +               }
> > +       }
> > +
> > +       if (i < NUM_FORMATS) {
> > +               fmt =3D &formats[i];
> > +               f->pixelformat =3D fmt->fourcc;
> > +               return 0;
> > +       }
> > +
> > +       return -EINVAL;
> > +}
> > +
> > +static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
> > +                                  struct v4l2_fmtdesc *f)
> > +{
> > +       return enum_fmt(f, CEDRUS_CAPTURE);
> > +}
> > +
> > +static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
> > +                                  struct v4l2_fmtdesc *f)
> > +{
> > +       return enum_fmt(f, CEDRUS_OUTPUT);
> > +}
> > +
> > +static int vidioc_g_fmt(struct cedrus_ctx *ctx, struct v4l2_format *f)
> > +{
> > +       struct cedrus_dev *dev =3D ctx->dev;
> > +
> > +       switch (f->type) {
> > +       case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> > +               f->fmt.pix_mp =3D ctx->dst_fmt;
> > +               break;
> > +       case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> > +               f->fmt.pix_mp =3D ctx->src_fmt;
> > +               break;
> > +       default:
> > +               v4l2_err(&dev->v4l2_dev,
> > +                        "Invalid buffer type for getting format\n");
> > +               return -EINVAL;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static int vidioc_g_fmt_vid_out(struct file *file, void *priv,
> > +                               struct v4l2_format *f)
> > +{
> > +       return vidioc_g_fmt(file2ctx(file), f);
> > +}
> > +
> > +static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
> > +                               struct v4l2_format *f)
> > +{
> > +       return vidioc_g_fmt(file2ctx(file), f);
> > +}
> > +
> > +static int vidioc_try_fmt(struct v4l2_format *f, struct cedrus_fmt *fm=
t)
> > +{
> > +       int i;
> > +       __u32 bpl;
> > +
>=20
> nit: unsigned int -- or, given it's clamped, just use int.

Looks like this no longer applies :)

> > +       f->fmt.pix_mp.field =3D V4L2_FIELD_NONE;
> > +       f->fmt.pix_mp.num_planes =3D fmt->num_planes;
> > +
> > +       switch (f->type) {
> > +       case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> > +               if (f->fmt.pix_mp.plane_fmt[0].sizeimage =3D=3D 0)
> > +                       return -EINVAL;
> > +
> > +               f->fmt.pix_mp.plane_fmt[0].bytesperline =3D 0;
> > +               break;
> > +       case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> > +               /* Limit to hardware min/max. */
> > +               f->fmt.pix_mp.width =3D clamp(f->fmt.pix_mp.width,
> > +                                           CEDRUS_MIN_WIDTH, CEDRUS_MA=
X_WIDTH);
> > +               f->fmt.pix_mp.height =3D clamp(f->fmt.pix_mp.height,
> > +                                            CEDRUS_MIN_HEIGHT,
> > +                                            CEDRUS_MAX_HEIGHT);
> > +
> > +               for (i =3D 0; i < f->fmt.pix_mp.num_planes; ++i) {
> > +                       bpl =3D (f->fmt.pix_mp.width * fmt->depth) >> 3=
;
> > +                       f->fmt.pix_mp.plane_fmt[i].bytesperline =3D bpl=
;
> > +                       f->fmt.pix_mp.plane_fmt[i].sizeimage =3D
> > +                               f->fmt.pix_mp.height * bpl;
> > +               }
> > +               break;
> > +       }
> > +       return 0;
> > +}
> > +
> > +static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
> > +                                 struct v4l2_format *f)
> > +{
> > +       struct cedrus_fmt *fmt;
> > +       struct cedrus_ctx *ctx =3D file2ctx(file);
> > +       struct cedrus_dev *dev =3D ctx->dev;
> > +
> > +       fmt =3D find_format(f);
> > +       if (!fmt) {
> > +               f->fmt.pix_mp.pixelformat =3D formats[0].fourcc;
> > +               fmt =3D find_format(f);
> > +       }
> > +       if (!(fmt->types & CEDRUS_CAPTURE)) {
> > +               v4l2_err(&dev->v4l2_dev, "Invalid destination format: %=
08x\n",
> > +                        f->fmt.pix_mp.pixelformat);
> > +               return -EINVAL;
> > +       }
> > +
> > +       return vidioc_try_fmt(f, fmt);
> > +}
> > +
> > +static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
> > +                                 struct v4l2_format *f)
> > +{
> > +       struct cedrus_fmt *fmt;
> > +       struct cedrus_ctx *ctx =3D file2ctx(file);
> > +       struct cedrus_dev *dev =3D ctx->dev;
> > +
> > +       fmt =3D find_format(f);
> > +       if (!fmt) {
> > +               f->fmt.pix_mp.pixelformat =3D formats[0].fourcc;
> > +               fmt =3D find_format(f);
> > +       }
> > +       if (!(fmt->types & CEDRUS_OUTPUT)) {
> > +               v4l2_err(&dev->v4l2_dev, "Invalid source format: %08x\n=
",
> > +                        f->fmt.pix_mp.pixelformat);
> > +               return -EINVAL;
> > +       }
> > +
> > +       return vidioc_try_fmt(f, fmt);
> > +}
> > +
> > +static int vidioc_s_fmt(struct cedrus_ctx *ctx, struct v4l2_format *f)
> > +{
> > +       struct cedrus_dev *dev =3D ctx->dev;
> > +       struct v4l2_pix_format_mplane *pix_fmt_mp =3D &f->fmt.pix_mp;
> > +       struct cedrus_fmt *fmt;
> > +       int i, ret =3D 0;
> > +
> > +       switch (f->type) {
> > +       case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> > +               ctx->vpu_src_fmt =3D find_format(f);
> > +               ctx->src_fmt =3D *pix_fmt_mp;
> > +               break;
> > +       case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> > +               fmt =3D find_format(f);
> > +               ctx->vpu_dst_fmt =3D fmt;
> > +
> > +               for (i =3D 0; i < fmt->num_planes; ++i) {
> > +                       pix_fmt_mp->plane_fmt[i].bytesperline =3D
> > +                               pix_fmt_mp->width * fmt->depth;
> > +                       pix_fmt_mp->plane_fmt[i].sizeimage =3D
> > +                               pix_fmt_mp->plane_fmt[i].bytesperline
> > +                               * pix_fmt_mp->height;
> > +               }
> > +               ctx->dst_fmt =3D *pix_fmt_mp;
> > +               break;
> > +       default:
> > +               v4l2_err(&dev->v4l2_dev,
> > +                        "Invalid buffer type for setting format\n");
> > +               return -EINVAL;
> > +       }
> > +
> > +       return ret;
> > +}
> > +
> > +static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
> > +                               struct v4l2_format *f)
> > +{
> > +       struct cedrus_ctx *ctx =3D file2ctx(file);
> > +       int ret;
> > +
> > +       ret =3D vidioc_try_fmt_vid_cap(file, priv, f);
> > +       if (ret)
> > +               return ret;
> > +
> > +       return vidioc_s_fmt(ctx, f);
> > +}
> > +
> > +static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
> > +                               struct v4l2_format *f)
> > +{
> > +       struct cedrus_ctx *ctx =3D file2ctx(file);
> > +       int ret;
> > +
> > +       ret =3D vidioc_try_fmt_vid_out(file, priv, f);
> > +       if (ret)
> > +               return ret;
> > +
> > +       return vidioc_s_fmt(ctx, f);
> > +}
> > +
> > +const struct v4l2_ioctl_ops cedrus_ioctl_ops =3D {
> > +       .vidioc_querycap                =3D vidioc_querycap,
> > +
> > +       .vidioc_enum_fmt_vid_cap        =3D vidioc_enum_fmt_vid_cap,
> > +       .vidioc_g_fmt_vid_cap_mplane    =3D vidioc_g_fmt_vid_cap,
> > +       .vidioc_try_fmt_vid_cap_mplane  =3D vidioc_try_fmt_vid_cap,
> > +       .vidioc_s_fmt_vid_cap_mplane    =3D vidioc_s_fmt_vid_cap,
> > +
> > +       .vidioc_enum_fmt_vid_out_mplane =3D vidioc_enum_fmt_vid_out,
> > +       .vidioc_g_fmt_vid_out_mplane    =3D vidioc_g_fmt_vid_out,
> > +       .vidioc_try_fmt_vid_out_mplane  =3D vidioc_try_fmt_vid_out,
> > +       .vidioc_s_fmt_vid_out_mplane    =3D vidioc_s_fmt_vid_out,
> > +
> > +       .vidioc_reqbufs                 =3D v4l2_m2m_ioctl_reqbufs,
> > +       .vidioc_querybuf                =3D v4l2_m2m_ioctl_querybuf,
> > +       .vidioc_qbuf                    =3D v4l2_m2m_ioctl_qbuf,
> > +       .vidioc_dqbuf                   =3D v4l2_m2m_ioctl_dqbuf,
> > +       .vidioc_prepare_buf             =3D v4l2_m2m_ioctl_prepare_buf,
> > +       .vidioc_create_bufs             =3D v4l2_m2m_ioctl_create_bufs,
> > +       .vidioc_expbuf                  =3D v4l2_m2m_ioctl_expbuf,
> > +
> > +       .vidioc_streamon                =3D v4l2_m2m_ioctl_streamon,
> > +       .vidioc_streamoff               =3D v4l2_m2m_ioctl_streamoff,
> > +
> > +       .vidioc_subscribe_event         =3D v4l2_ctrl_subscribe_event,
> > +       .vidioc_unsubscribe_event       =3D v4l2_event_unsubscribe,
> > +};
> > +
> > +static int cedrus_queue_setup(struct vb2_queue *vq, unsigned int *nbuf=
s,
> > +                             unsigned int *nplanes, unsigned int sizes=
[],
> > +                             struct device *alloc_devs[])
> > +{
> > +       struct cedrus_ctx *ctx =3D vb2_get_drv_priv(vq);
> > +       struct cedrus_dev *dev =3D ctx->dev;
> > +
> > +       switch (vq->type) {
> > +       case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> > +               *nplanes =3D ctx->vpu_src_fmt->num_planes;
> > +
> > +               sizes[0] =3D ctx->src_fmt.plane_fmt[0].sizeimage;
> > +               break;
> > +
> > +       case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> > +               *nplanes =3D ctx->vpu_dst_fmt->num_planes;
> > +
> > +               sizes[0] =3D round_up(ctx->dst_fmt.plane_fmt[0].sizeima=
ge, 8);
> > +               sizes[1] =3D sizes[0];
> > +               break;
> > +
> > +       default:
> > +               v4l2_err(&dev->v4l2_dev,
> > +                        "Invalid buffer type for queue setup\n");
> > +               return -EINVAL;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static int cedrus_buf_init(struct vb2_buffer *vb)
> > +{
> > +       struct vb2_queue *vq =3D vb->vb2_queue;
> > +       struct cedrus_ctx *ctx =3D container_of(vq->drv_priv,
> > +                                             struct cedrus_ctx, fh);
> > +
> > +       if (vq->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> > +               ctx->dst_bufs[vb->index] =3D vb;
> > +
> > +       return 0;
> > +}
> > +
> > +static void cedrus_buf_cleanup(struct vb2_buffer *vb)
> > +{
> > +       struct vb2_queue *vq =3D vb->vb2_queue;
> > +       struct cedrus_ctx *ctx =3D container_of(vq->drv_priv,
> > +                                             struct cedrus_ctx, fh);
> > +
> > +       if (vq->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> > +               ctx->dst_bufs[vb->index] =3D NULL;
> > +}
> > +
> > +static int cedrus_buf_prepare(struct vb2_buffer *vb)
> > +{
> > +       struct cedrus_ctx *ctx =3D vb2_get_drv_priv(vb->vb2_queue);
> > +       struct cedrus_dev *dev =3D ctx->dev;
> > +       struct vb2_queue *vq =3D vb->vb2_queue;
> > +       int i;
> > +
> > +       switch (vq->type) {
> > +       case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> > +               if (vb2_plane_size(vb, 0)
> > +                   < ctx->src_fmt.plane_fmt[0].sizeimage) {
> > +                       v4l2_err(&dev->v4l2_dev,
> > +                                "Buffer plane size too small for outpu=
t\n");
> > +                       return -EINVAL;
> > +               }
> > +               break;
> > +
> > +       case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> > +               for (i =3D 0; i < ctx->vpu_dst_fmt->num_planes; ++i) {
> > +                       if (vb2_plane_size(vb, i)
> > +                           < ctx->dst_fmt.plane_fmt[i].sizeimage) {
> > +                               v4l2_err(&dev->v4l2_dev,
> > +                                        "Buffer plane %d size too smal=
l for capture\n",
> > +                                        i);
> > +                               break;
> > +                       }
> > +               }
> > +
> > +               if (i !=3D ctx->vpu_dst_fmt->num_planes)
> > +                       return -EINVAL;
> > +               break;
> > +
> > +       default:
> > +               v4l2_err(&dev->v4l2_dev,
> > +                        "Invalid buffer type for buffer preparation\n"=
);
> > +               return -EINVAL;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static void cedrus_stop_streaming(struct vb2_queue *q)
> > +{
> > +       struct cedrus_ctx *ctx =3D vb2_get_drv_priv(q);
> > +       struct vb2_v4l2_buffer *vbuf;
> > +       unsigned long flags;
> > +
> > +       flush_scheduled_work();
>=20
> Just like the other work stuff, flush_scheduled_work seems bogus.
>=20
> > +       for (;;) {
> > +               spin_lock_irqsave(&ctx->dev->irq_lock, flags);
> > +
> > +               if (V4L2_TYPE_IS_OUTPUT(q->type))
> > +                       vbuf =3D v4l2_m2m_src_buf_remove(ctx->fh.m2m_ct=
x);
> > +               else
> > +                       vbuf =3D v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ct=
x);
> > +
> > +               spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
> > +
> > +               if (vbuf =3D=3D NULL)
> > +                       return;
> > +
> > +               v4l2_ctrl_request_complete(vbuf->vb2_buf.req_obj.req,
> > +                                          &ctx->hdl);
> > +               v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
> > +       }
> > +}
> > +
> > +static void cedrus_buf_queue(struct vb2_buffer *vb)
> > +{
> > +       struct vb2_v4l2_buffer *vbuf =3D to_vb2_v4l2_buffer(vb);
> > +       struct cedrus_ctx *ctx =3D vb2_get_drv_priv(vb->vb2_queue);
> > +
> > +       v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
> > +}
> > +
> > +static void cedrus_buf_request_complete(struct vb2_buffer *vb)
> > +{
> > +       struct cedrus_ctx *ctx =3D vb2_get_drv_priv(vb->vb2_queue);
> > +
> > +       v4l2_ctrl_request_complete(vb->req_obj.req, &ctx->hdl);
> > +}
> > +
> > +static struct vb2_ops cedrus_qops =3D {
> > +       .queue_setup            =3D cedrus_queue_setup,
> > +       .buf_prepare            =3D cedrus_buf_prepare,
> > +       .buf_init               =3D cedrus_buf_init,
> > +       .buf_cleanup            =3D cedrus_buf_cleanup,
> > +       .buf_queue              =3D cedrus_buf_queue,
> > +       .buf_request_complete   =3D cedrus_buf_request_complete,
> > +       .stop_streaming         =3D cedrus_stop_streaming,
> > +       .wait_prepare           =3D vb2_ops_wait_prepare,
> > +       .wait_finish            =3D vb2_ops_wait_finish,
> > +};
> > +
> > +int cedrus_queue_init(void *priv, struct vb2_queue *src_vq,
> > +                     struct vb2_queue *dst_vq)
> > +{
> > +       struct cedrus_ctx *ctx =3D priv;
> > +       int ret;
> > +
> > +       src_vq->type =3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> > +       src_vq->io_modes =3D VB2_MMAP | VB2_DMABUF;
> > +       src_vq->drv_priv =3D ctx;
> > +       src_vq->buf_struct_size =3D sizeof(struct cedrus_buffer);
> > +       src_vq->allow_zero_bytesused =3D 1;
> > +       src_vq->min_buffers_needed =3D 1;
> > +       src_vq->ops =3D &cedrus_qops;
> > +       src_vq->mem_ops =3D &vb2_dma_contig_memops;
> > +       src_vq->timestamp_flags =3D V4L2_BUF_FLAG_TIMESTAMP_COPY;
> > +       src_vq->lock =3D &ctx->dev->dev_mutex;
> > +       src_vq->dev =3D ctx->dev->dev;
> > +
> > +       ret =3D vb2_queue_init(src_vq);
> > +       if (ret)
> > +               return ret;
> > +
> > +       dst_vq->type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> > +       dst_vq->io_modes =3D VB2_MMAP | VB2_DMABUF;
> > +       dst_vq->drv_priv =3D ctx;
> > +       dst_vq->buf_struct_size =3D sizeof(struct cedrus_buffer);
> > +       dst_vq->allow_zero_bytesused =3D 1;
> > +       dst_vq->min_buffers_needed =3D 1;
> > +       dst_vq->ops =3D &cedrus_qops;
> > +       dst_vq->mem_ops =3D &vb2_dma_contig_memops;
> > +       dst_vq->timestamp_flags =3D V4L2_BUF_FLAG_TIMESTAMP_COPY;
> > +       dst_vq->lock =3D &ctx->dev->dev_mutex;
> > +       dst_vq->dev =3D ctx->dev->dev;
> > +
> > +       return vb2_queue_init(dst_vq);
> > +}
> > diff --git a/drivers/media/platform/sunxi/cedrus/cedrus_video.h b/drive=
rs/media/platform/sunxi/cedrus/cedrus_video.h
> > new file mode 100644
> > index 000000000000..ed7cea8a6d8f
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi/cedrus/cedrus_video.h
> > @@ -0,0 +1,23 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
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
> > + */
> > +
> > +#ifndef _CEDRUS_VIDEO_H_
> > +#define _CEDRUS_VIDEO_H_
> > +
> > +extern const struct v4l2_ioctl_ops cedrus_ioctl_ops;
> > +
> > +int cedrus_queue_init(void *priv, struct vb2_queue *src_vq,
> > +                     struct vb2_queue *dst_vq);
> > +
> > +#endif
> > --
> > 2.17.0
> >=20
> > --
> > You received this message because you are subscribed to the Google Grou=
ps "linux-sunxi" group.
> > To unsubscribe from this group and stop receiving emails from it, send =
an email to linux-sunxi+unsubscribe@googlegroups.com.
> > For more options, visit https://groups.google.com/d/optout.
>=20
>=20
>=20
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-ki4H+HGfh/R5+tWy9FqR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAltXN34ACgkQ3cLmz3+f
v9Eqhgf+JuF6Sgd+obmJTezchuVfRlchv5frno01Iw9hhrXqOPDg4iPSfMjpD2Cj
NkWWPOHxxkmJumoIUm9w3dGpRD8vo4nQICZP0Ntl9ZH80A7SHal3uZ6oLbuCN3ux
5rpnvr1CMKltEsN4B/gMmNiJmlufMFZnARsq02OXJFqwZi4HEG0w9WY9ha1qvQ8f
WC4/sHJWyUX56E9akY8ofQN6+mPdA+zolDR85ADWZCpVAyQmTazSHGYC7a7gYAVR
a0QCibMGNm8eVm3u2EYQATlTBEXzuNjPtO9SgNfxKi32d7FKpRijbJ0Am4EsfMnW
cVul1pIaq84FyR4U0E0LZcRytvSATg==
=uKX3
-----END PGP SIGNATURE-----

--=-ki4H+HGfh/R5+tWy9FqR--
