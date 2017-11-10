Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:52106 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751409AbdKJNMH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Nov 2017 08:12:07 -0500
Received: by mail-lf0-f67.google.com with SMTP id f134so2705961lfg.8
        for <linux-media@vger.kernel.org>; Fri, 10 Nov 2017 05:12:07 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Fri, 10 Nov 2017 14:12:04 +0100
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Fukawa <tomoharu.fukawa.eb@renesas.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v9 2/2] media: rcar-csi2: add Renesas R-Car MIPI CSI-2
 receiver driver
Message-ID: <20171110131204.GA5458@bigcity.dyn.berto.se>
References: <20171109234320.13016-1-niklas.soderlund+renesas@ragnatech.se>
 <20171109234320.13016-3-niklas.soderlund+renesas@ragnatech.se>
 <CAMuHMdWgUNeJPkORSKRQJfxkarRdSnzu2Q9cSB7E1nJzV2oFSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdWgUNeJPkORSKRQJfxkarRdSnzu2Q9cSB7E1nJzV2oFSQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

On 2017-11-10 10:30:24 +0100, Geert Uytterhoeven wrote:
> Hi Niklas,
> 
> On Fri, Nov 10, 2017 at 12:43 AM, Niklas Söderlund
> <niklas.soderlund+renesas@ragnatech.se> wrote:
> > A V4L2 driver for Renesas R-Car MIPI CSI-2 receiver. The driver
> > supports the rcar-vin driver on R-Car Gen3 SoCs where separate CSI-2
> > hardware blocks are connected between the video sources and the video
> > grabbers (VIN).
> >
> > Driver is based on a prototype by Koji Matsuoka in the Renesas BSP.
> >
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
> Thanks for your patch!

Thanks for your feedback, much appreciated!

> 
> > --- /dev/null
> > +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > @@ -0,0 +1,933 @@
> 
> > +/* Control Timing Select */
> > +#define TREF_REG                       0x00
> > +#define TREF_TREF                      (1 << 0)
> 
> BIT(0)? (many more)

Good idea.

> 
> > +struct phypll_hsfreqrange {
> > +       unsigned int    mbps;
> > +       unsigned char   reg;
> 
> The "unsigned char" doesn't buy you much, due to alignment rules.
> What about making both u16 instead?

Yes that would work, thanks.

> 
> > +static const struct rcar_csi2_format *rcar_csi2_code_to_fmt(unsigned int code)
> > +{
> > +       int i;
> 
> unsigned int

Thanks.

> 
> > +
> > +       for (i = 0; i < ARRAY_SIZE(rcar_csi2_formats); i++)
> > +               if (rcar_csi2_formats[i].code == code)
> > +                       return rcar_csi2_formats + i;
> > +       return NULL;
> > +}
> 
> > +struct rcar_csi2_info {
> > +       const struct phypll_hsfreqrange *hsfreqrange;
> > +       bool clear_ulps;
> > +       bool have_phtw;
> > +       unsigned int csi0clkfreqrange;
> 
> I'd sort by decreasing size/alignment, i.e. the bools last.

I had not consider packing of the struct, thanks for pointing this out.

> 
> > +};
> > +
> > +struct rcar_csi2 {
> > +       struct device *dev;
> > +       void __iomem *base;
> > +       const struct rcar_csi2_info *info;
> > +
> > +       unsigned short lanes;
> > +       unsigned char lane_swap[4];
> > +
> > +       struct v4l2_subdev subdev;
> > +       struct media_pad pads[NR_OF_RCAR_CSI2_PAD];
> > +
> > +       struct v4l2_mbus_framefmt mf;
> > +
> > +       struct mutex lock;
> > +       int stream_count;
> > +
> > +       struct v4l2_async_notifier notifier;
> > +       struct v4l2_async_subdev remote;
> 
> Likewise.

Thanks for this, I learnt something new.

> 
> > +static int rcar_csi2_start(struct rcar_csi2 *priv)
> > +{
> 
> > +       dev_dbg(priv->dev, "Input size (%dx%d%c)\n", mf->width,
> 
> %u for __u32

Good catch.

> 
> > +               mf->height, mf->field == V4L2_FIELD_NONE ? 'p' : 'i');
> 
> > +static int rcar_csi2_probe_resources(struct rcar_csi2 *priv,
> > +                                    struct platform_device *pdev)
> > +{
> > +       struct resource *mem;
> > +       int irq;
> > +
> > +       mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +       if (!mem)
> 
> No need to check mem, platform_get_resource() and devm_ioremap_resource()
> are designed to be pipelined.

Did not know that, thanks.

> 
> > +               return -ENODEV;
> > +
> > +       priv->base = devm_ioremap_resource(&pdev->dev, mem);
> 
> 
> > +static const struct soc_device_attribute r8a7795es1[] = {
> > +       { .soc_id = "r8a7795", .revision = "ES1.*" },
> > +       { /* sentinel */ }
> > +};
> > +
> > +static int rcar_csi2_probe(struct platform_device *pdev)
> > +{
> > +       struct rcar_csi2 *priv;
> > +       unsigned int i;
> > +       int ret;
> > +
> > +       priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> > +       if (!priv)
> > +               return -ENOMEM;
> > +
> > +       priv->info = of_device_get_match_data(&pdev->dev);
> > +
> > +       /* r8a7795 ES1.x behaves different then ES2.0+ but no own compat */
> > +       if (priv->info == &rcar_csi2_info_r8a7795 &&
> > +           soc_device_match(r8a7795es1))
> > +               priv->info = &rcar_csi2_info_r8a7795es1;
> 
> Please store &rcar_csi2_info_r8a7795es1 in r8a7795es1[0].data instead.

Good idea.

I will fix this and resend, thanks again for taking the time to review 
this patch.

> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds

-- 
Regards,
Niklas Söderlund
