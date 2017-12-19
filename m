Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:43494 "EHLO
        smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932699AbdLSKgP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 05:36:15 -0500
MIME-Version: 1.0
In-Reply-To: <1510558216-43800-1-git-send-email-yong.deng@magewell.com>
References: <1510558216-43800-1-git-send-email-yong.deng@magewell.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Tue, 19 Dec 2017 18:35:49 +0800
Message-ID: <CAGb2v65vSRs-OzR91VWG=LMk2z0y=f9CSSJm_3-U_ywyMidgaw@mail.gmail.com>
Subject: Re: [linux-sunxi] [PATCH v3 1/3] media: V3s: Add support for
 Allwinner CSI.
To: Yong Deng <yong.deng@magewell.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Benoit Parrot <bparrot@ti.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Rick Chang <rick.chang@mediatek.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        =?UTF-8?Q?Ond=C5=99ej_Jirman?= <megous@megous.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 13, 2017 at 3:30 PM, Yong Deng <yong.deng@magewell.com> wrote:
> Allwinner V3s SoC have two CSI module. CSI0 is used for MIPI interface
> and CSI1 is used for parallel interface. This is not documented in
> datasheet but by testing and guess.
>
> This patch implement a v4l2 framework driver for it.
>
> Currently, the driver only support the parallel interface. MIPI-CSI2,
> ISP's support are not included in this patch.
>
> Signed-off-by: Yong Deng <yong.deng@magewell.com>
> ---
>  drivers/media/platform/Kconfig                     |   1 +
>  drivers/media/platform/Makefile                    |   2 +
>  drivers/media/platform/sunxi/sun6i-csi/Kconfig     |   9 +
>  drivers/media/platform/sunxi/sun6i-csi/Makefile    |   3 +
>  drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 918 +++++++++++++++++++++
>  drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h | 146 ++++
>  .../media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h | 203 +++++
>  .../media/platform/sunxi/sun6i-csi/sun6i_video.c   | 722 ++++++++++++++++
>  .../media/platform/sunxi/sun6i-csi/sun6i_video.h   |  61 ++
>  9 files changed, 2065 insertions(+)
>  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/Kconfig
>  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/Makefile
>  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
>  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h
>  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h
>  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
>  create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_video.h
>

[...]

> diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
> new file mode 100644
> index 0000000..0cebcbd
> --- /dev/null
> +++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c

[...]

> +/* -----------------------------------------------------------------------------
> + * Media Operations
> + */
> +static int sun6i_video_formats_init(struct sun6i_video *video)
> +{
> +       struct v4l2_subdev_mbus_code_enum mbus_code = { 0 };
> +       struct sun6i_csi *csi = video->csi;
> +       struct v4l2_format format;
> +       struct v4l2_subdev *subdev;
> +       u32 pad;
> +       const u32 *pixformats;
> +       int pixformat_count = 0;
> +       u32 subdev_codes[32]; /* subdev format codes, 32 should be enough */
> +       int codes_count = 0;
> +       int num_fmts = 0;
> +       int i, j;
> +
> +       subdev = sun6i_video_remote_subdev(video, &pad);
> +       if (subdev == NULL)
> +               return -ENXIO;
> +
> +       /* Get supported pixformats of CSI */
> +       pixformat_count = sun6i_csi_get_supported_pixformats(csi, &pixformats);
> +       if (pixformat_count <= 0)
> +               return -ENXIO;
> +
> +       /* Get subdev formats codes */
> +       mbus_code.pad = pad;
> +       mbus_code.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +       while (!v4l2_subdev_call(subdev, pad, enum_mbus_code, NULL,
> +                                &mbus_code)) {
> +               if (codes_count >= ARRAY_SIZE(subdev_codes)) {
> +                       dev_warn(video->csi->dev,
> +                                "subdev_codes array is full!\n");
> +                       break;
> +               }
> +               subdev_codes[codes_count] = mbus_code.code;
> +               codes_count++;
> +               mbus_code.index++;
> +       }
> +
> +       if (!codes_count)
> +               return -ENXIO;
> +
> +       /* Get supported formats count */
> +       for (i = 0; i < codes_count; i++) {
> +               for (j = 0; j < pixformat_count; j++) {
> +                       if (!sun6i_csi_is_format_support(csi, pixformats[j],
> +                                       mbus_code.code)) {

Bug here. You are testing against mbus_code.code, which would be whatever
was leftover from the previous section. Instead you should be testing
against subdev_codes[i], the list you just built.

Without it, it won't get past this part of the code if the last enumerated
media bus format isn't supported.

> +                               continue;
> +                       }
> +                       num_fmts++;
> +               }
> +       }
> +
> +       if (!num_fmts)
> +               return -ENXIO;
> +
> +       video->num_formats = num_fmts;
> +       video->formats = devm_kcalloc(video->csi->dev, num_fmts,
> +                       sizeof(struct sun6i_csi_format), GFP_KERNEL);
> +       if (!video->formats)
> +               return -ENOMEM;
> +
> +       /* Get supported formats */
> +       num_fmts = 0;
> +       for (i = 0; i < codes_count; i++) {
> +               for (j = 0; j < pixformat_count; j++) {
> +                       if (!sun6i_csi_is_format_support(csi, pixformats[j],
> +                                       mbus_code.code)) {

Same here.

This gets me past the enumeration part of things...

> +                               continue;
> +                       }
> +
> +                       video->formats[num_fmts].fourcc = pixformats[j];
> +                       video->formats[num_fmts].mbus_code =
> +                                       mbus_code.code;
> +                       video->formats[num_fmts].bpp =
> +                                       v4l2_pixformat_get_bpp(pixformats[j]);
> +                       num_fmts++;
> +               }
> +       }
> +
> +       /* setup default format */
> +       format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +       format.fmt.pix.width = 1280;
> +       format.fmt.pix.height = 720;
> +       format.fmt.pix.pixelformat = video->formats[0].fourcc;
> +       sun6i_video_set_fmt(video, &format);

But my system crashes here within the OV5640 driver.
So no tests about the actual functionality. This was on the Bananapi M3,
which has an A83T SoC.


In general I think you should make your driver much more noisy than it
currently is. I spent the whole afternoon adding error messages and
debug traces to narrow down the issue.

ChenYu
