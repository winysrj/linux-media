Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:47424 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751239AbdKJJa0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Nov 2017 04:30:26 -0500
MIME-Version: 1.0
In-Reply-To: <20171109234320.13016-3-niklas.soderlund+renesas@ragnatech.se>
References: <20171109234320.13016-1-niklas.soderlund+renesas@ragnatech.se> <20171109234320.13016-3-niklas.soderlund+renesas@ragnatech.se>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 10 Nov 2017 10:30:24 +0100
Message-ID: <CAMuHMdWgUNeJPkORSKRQJfxkarRdSnzu2Q9cSB7E1nJzV2oFSQ@mail.gmail.com>
Subject: Re: [PATCH v9 2/2] media: rcar-csi2: add Renesas R-Car MIPI CSI-2
 receiver driver
To: =?UTF-8?Q?Niklas_S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Fukawa <tomoharu.fukawa.eb@renesas.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Fri, Nov 10, 2017 at 12:43 AM, Niklas S=C3=B6derlund
<niklas.soderlund+renesas@ragnatech.se> wrote:
> A V4L2 driver for Renesas R-Car MIPI CSI-2 receiver. The driver
> supports the rcar-vin driver on R-Car Gen3 SoCs where separate CSI-2
> hardware blocks are connected between the video sources and the video
> grabbers (VIN).
>
> Driver is based on a prototype by Koji Matsuoka in the Renesas BSP.
>
> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>

Thanks for your patch!

> --- /dev/null
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -0,0 +1,933 @@

> +/* Control Timing Select */
> +#define TREF_REG                       0x00
> +#define TREF_TREF                      (1 << 0)

BIT(0)? (many more)

> +struct phypll_hsfreqrange {
> +       unsigned int    mbps;
> +       unsigned char   reg;

The "unsigned char" doesn't buy you much, due to alignment rules.
What about making both u16 instead?

> +static const struct rcar_csi2_format *rcar_csi2_code_to_fmt(unsigned int=
 code)
> +{
> +       int i;

unsigned int

> +
> +       for (i =3D 0; i < ARRAY_SIZE(rcar_csi2_formats); i++)
> +               if (rcar_csi2_formats[i].code =3D=3D code)
> +                       return rcar_csi2_formats + i;
> +       return NULL;
> +}

> +struct rcar_csi2_info {
> +       const struct phypll_hsfreqrange *hsfreqrange;
> +       bool clear_ulps;
> +       bool have_phtw;
> +       unsigned int csi0clkfreqrange;

I'd sort by decreasing size/alignment, i.e. the bools last.

> +};
> +
> +struct rcar_csi2 {
> +       struct device *dev;
> +       void __iomem *base;
> +       const struct rcar_csi2_info *info;
> +
> +       unsigned short lanes;
> +       unsigned char lane_swap[4];
> +
> +       struct v4l2_subdev subdev;
> +       struct media_pad pads[NR_OF_RCAR_CSI2_PAD];
> +
> +       struct v4l2_mbus_framefmt mf;
> +
> +       struct mutex lock;
> +       int stream_count;
> +
> +       struct v4l2_async_notifier notifier;
> +       struct v4l2_async_subdev remote;

Likewise.

> +static int rcar_csi2_start(struct rcar_csi2 *priv)
> +{

> +       dev_dbg(priv->dev, "Input size (%dx%d%c)\n", mf->width,

%u for __u32

> +               mf->height, mf->field =3D=3D V4L2_FIELD_NONE ? 'p' : 'i')=
;

> +static int rcar_csi2_probe_resources(struct rcar_csi2 *priv,
> +                                    struct platform_device *pdev)
> +{
> +       struct resource *mem;
> +       int irq;
> +
> +       mem =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!mem)

No need to check mem, platform_get_resource() and devm_ioremap_resource()
are designed to be pipelined.

> +               return -ENODEV;
> +
> +       priv->base =3D devm_ioremap_resource(&pdev->dev, mem);


> +static const struct soc_device_attribute r8a7795es1[] =3D {
> +       { .soc_id =3D "r8a7795", .revision =3D "ES1.*" },
> +       { /* sentinel */ }
> +};
> +
> +static int rcar_csi2_probe(struct platform_device *pdev)
> +{
> +       struct rcar_csi2 *priv;
> +       unsigned int i;
> +       int ret;
> +
> +       priv =3D devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> +       if (!priv)
> +               return -ENOMEM;
> +
> +       priv->info =3D of_device_get_match_data(&pdev->dev);
> +
> +       /* r8a7795 ES1.x behaves different then ES2.0+ but no own compat =
*/
> +       if (priv->info =3D=3D &rcar_csi2_info_r8a7795 &&
> +           soc_device_match(r8a7795es1))
> +               priv->info =3D &rcar_csi2_info_r8a7795es1;

Please store &rcar_csi2_info_r8a7795es1 in r8a7795es1[0].data instead.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
