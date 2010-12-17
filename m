Return-path: <mchehab@gaivota>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61422 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268Ab0LQMqU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Dec 2010 07:46:20 -0500
MIME-Version: 1.0
In-Reply-To: <1292571836-10684-1-git-send-email-khw0178.kim@samsung.com>
References: <1292571836-10684-1-git-send-email-khw0178.kim@samsung.com>
Date: Fri, 17 Dec 2010 21:46:18 +0900
Message-ID: <AANLkTinFVP56z4dcwuQimi1hPG+vmThhDn95X7kGpcVy@mail.gmail.com>
Subject: Re: [PATCH] [media] s5p-fimc: fix main scaler SFRs depends on FIMC version
From: Kyungmin Park <kmpark@infradead.org>
To: Hyunwoong Kim <khw0178.kim@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	s.nawrocki@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Fri, Dec 17, 2010 at 4:43 PM, Hyunwoong Kim <khw0178.kim@samsung.com> wrote:
> The main scaler has four SFRs for main scaler ratio depends on FIMC version.
> FIMC 4.x has only two SFRs and FIMC 5.x has four SFRs for main scaler.
> Those are MainHorRatio, MainHorRatio_ext, MainVerRatio and MainverRatio_ext.
>
> The FIMC 5.x has 15 bit resolution for scaling ratio as below.
> {MainHorRatio,MainHorRatio_ext} = {[14:6],[5:0]}.
> {MainVerRatio,MainVerRatio_ext} = {[14:6],[5:0]}.
> MainHorRatio = CISCCTRL[24:16], MainHorRatio_ext = CIEXTEN[15:10]
> MainVerRatio = CISCCTRL[8:0],   MainVerRatio_ext = CIEXTEN[5:0]
>
> This patch supports FIMC 4.x and FIMC 5.x using platform_device_id::driver_data.
>
> Signed-off-by: Hyunwoong Kim <khw0178.kim@samsung.com>
> Reviewed-by: Jonghun Han <jonghun.han@samsung.com>
> ---
>  drivers/media/video/s5p-fimc/fimc-capture.c |    7 +++-
>  drivers/media/video/s5p-fimc/fimc-core.c    |   21 ++++++++++--
>  drivers/media/video/s5p-fimc/fimc-core.h    |    5 ++-
>  drivers/media/video/s5p-fimc/fimc-reg.c     |   48 ++++++++++++++++++++++++--
>  drivers/media/video/s5p-fimc/regs-fimc.h    |   10 +++++-
>  5 files changed, 81 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
> index b216530..ca48e02 100644
> --- a/drivers/media/video/s5p-fimc/fimc-capture.c
> +++ b/drivers/media/video/s5p-fimc/fimc-capture.c
> @@ -208,6 +208,7 @@ static int start_streaming(struct vb2_queue *q)
>        struct fimc_ctx *ctx = q->drv_priv;
>        struct fimc_dev *fimc = ctx->fimc_dev;
>        struct s3c_fimc_isp_info *isp_info;
> +       struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
>        int ret;
>
>        ret = v4l2_subdev_call(fimc->vid_cap.sd, video, s_stream, 1);
> @@ -230,7 +231,11 @@ static int start_streaming(struct vb2_queue *q)
>                        return ret;
>                }
>                fimc_hw_set_input_path(ctx);
> -               fimc_hw_set_scaler(ctx);
> +               fimc_hw_set_prescaler(ctx);
> +               if (!variant->has_mainscaler_ext)
> +                       fimc_hw_set_mainscaler(ctx);
> +               else
> +                       fimc_hw_set_mainscaler_ext(ctx);
It's just personal preference, I don't like the negative variable check,
how about this?

                    if (variant->has_mainscaler_ext)
                           fimc_hw_set_mainscaler_ext(ctx);
                    else
                           fimc_hw_set_mainscaler(ctx);


>                fimc_hw_set_target_format(ctx);
>                fimc_hw_set_rotation(ctx);
>                fimc_hw_set_effect(ctx);
> diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
> index 7f56987..3cfa4b6 100644
> --- a/drivers/media/video/s5p-fimc/fimc-core.c
> +++ b/drivers/media/video/s5p-fimc/fimc-core.c
> @@ -246,6 +246,7 @@ int fimc_set_scaler_info(struct fimc_ctx *ctx)
>        struct fimc_scaler *sc = &ctx->scaler;
>        struct fimc_frame *s_frame = &ctx->s_frame;
>        struct fimc_frame *d_frame = &ctx->d_frame;
> +       struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
>        int tx, ty, sx, sy;
>        int ret;
>
> @@ -284,8 +285,13 @@ int fimc_set_scaler_info(struct fimc_ctx *ctx)
>        sc->pre_dst_width = sx / sc->pre_hratio;
>        sc->pre_dst_height = sy / sc->pre_vratio;
>
> -       sc->main_hratio = (sx << 8) / (tx << sc->hfactor);
> -       sc->main_vratio = (sy << 8) / (ty << sc->vfactor);
> +       if (!variant->has_mainscaler_ext) {
> +               sc->main_hratio = (sx << 8) / (tx << sc->hfactor);
> +               sc->main_vratio = (sy << 8) / (ty << sc->vfactor);
> +       } else {
> +               sc->main_hratio = (sx << 14) / (tx << sc->hfactor);
> +               sc->main_vratio = (sy << 14) / (ty << sc->vfactor);
> +       }
Ditto
>
>        sc->scaleup_h = (tx >= sx) ? 1 : 0;
>        sc->scaleup_v = (ty >= sy) ? 1 : 0;
> @@ -569,6 +575,7 @@ static void fimc_dma_run(void *priv)
>  {
>        struct fimc_ctx *ctx = priv;
>        struct fimc_dev *fimc;
> +       struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
>        unsigned long flags;
>        u32 ret;
>
> @@ -601,7 +608,12 @@ static void fimc_dma_run(void *priv)
>                        err("Scaler setup error");
>                        goto dma_unlock;
>                }
> -               fimc_hw_set_scaler(ctx);
> +
> +               fimc_hw_set_prescaler(ctx);
> +               if (!variant->has_mainscaler_ext)
> +                       fimc_hw_set_mainscaler(ctx);
> +               else
> +                       fimc_hw_set_mainscaler_ext(ctx);
ditto
>                fimc_hw_set_target_format(ctx);
>                fimc_hw_set_rotation(ctx);
>                fimc_hw_set_effect(ctx);
> @@ -1722,6 +1734,7 @@ static struct samsung_fimc_variant fimc1_variant_s5pv210 = {
>        .pix_hoff        = 1,
>        .has_inp_rot     = 1,
>        .has_out_rot     = 1,
> +       .has_mainscaler_ext = 1,
>        .min_inp_pixsize = 16,
>        .min_out_pixsize = 16,
>        .hor_offs_align  = 1,
> @@ -1743,6 +1756,7 @@ static struct samsung_fimc_variant fimc0_variant_s5pv310 = {
>        .has_inp_rot     = 1,
>        .has_out_rot     = 1,
>        .has_cistatus2   = 1,
> +       .has_mainscaler_ext = 1,
>        .min_inp_pixsize = 16,
>        .min_out_pixsize = 16,
>        .hor_offs_align  = 1,
> @@ -1753,6 +1767,7 @@ static struct samsung_fimc_variant fimc0_variant_s5pv310 = {
>  static struct samsung_fimc_variant fimc2_variant_s5pv310 = {
>        .pix_hoff        = 1,
>        .has_cistatus2   = 1,
> +       .has_mainscaler_ext = 1,
>        .min_inp_pixsize = 16,
>        .min_out_pixsize = 16,
>        .hor_offs_align  = 1,
> diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
> index 4efc1a1..dd5b949 100644
> --- a/drivers/media/video/s5p-fimc/fimc-core.h
> +++ b/drivers/media/video/s5p-fimc/fimc-core.h
> @@ -380,6 +380,7 @@ struct samsung_fimc_variant {
>        unsigned int    has_inp_rot:1;
>        unsigned int    has_out_rot:1;
>        unsigned int    has_cistatus2:1;
> +       unsigned int    has_mainscaler_ext:1;
>        struct fimc_pix_limit *pix_limit;
>        u16             min_inp_pixsize;
>        u16             min_out_pixsize;
> @@ -575,7 +576,9 @@ void fimc_hw_set_target_format(struct fimc_ctx *ctx);
>  void fimc_hw_set_out_dma(struct fimc_ctx *ctx);
>  void fimc_hw_en_lastirq(struct fimc_dev *fimc, int enable);
>  void fimc_hw_en_irq(struct fimc_dev *fimc, int enable);
> -void fimc_hw_set_scaler(struct fimc_ctx *ctx);
> +void fimc_hw_set_prescaler(struct fimc_ctx *ctx);
> +void fimc_hw_set_mainscaler(struct fimc_ctx *ctx);
> +void fimc_hw_set_mainscaler_ext(struct fimc_ctx *ctx);
>  void fimc_hw_en_capture(struct fimc_ctx *ctx);
>  void fimc_hw_set_effect(struct fimc_ctx *ctx);
>  void fimc_hw_set_in_dma(struct fimc_ctx *ctx);
> diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
> index 5ed8f06..bc75298 100644
> --- a/drivers/media/video/s5p-fimc/fimc-reg.c
> +++ b/drivers/media/video/s5p-fimc/fimc-reg.c
> @@ -249,7 +249,7 @@ void fimc_hw_en_lastirq(struct fimc_dev *dev, int enable)
>        writel(cfg, dev->regs + S5P_CIOCTRL);
>  }
>
> -static void fimc_hw_set_prescaler(struct fimc_ctx *ctx)
> +void fimc_hw_set_prescaler(struct fimc_ctx *ctx)
>  {
>        struct fimc_dev *dev =  ctx->fimc_dev;
>        struct fimc_scaler *sc = &ctx->scaler;
> @@ -267,7 +267,7 @@ static void fimc_hw_set_prescaler(struct fimc_ctx *ctx)
>        writel(cfg, dev->regs + S5P_CISCPREDST);
>  }
>
> -void fimc_hw_set_scaler(struct fimc_ctx *ctx)
> +static void fimc_hw_set_scaler(struct fimc_ctx *ctx)
>  {
>        struct fimc_dev *dev = ctx->fimc_dev;
>        struct fimc_scaler *sc = &ctx->scaler;
> @@ -275,8 +275,6 @@ void fimc_hw_set_scaler(struct fimc_ctx *ctx)
>        struct fimc_frame *dst_frame = &ctx->d_frame;
>        u32 cfg = 0;
>
> -       fimc_hw_set_prescaler(ctx);
> -
>        if (!(ctx->flags & FIMC_COLOR_RANGE_NARROW))
>                cfg |= (S5P_CISCCTRL_CSCR2Y_WIDE | S5P_CISCCTRL_CSCY2R_WIDE);
>
> @@ -316,15 +314,57 @@ void fimc_hw_set_scaler(struct fimc_ctx *ctx)
>                        cfg |= S5P_CISCCTRL_INTERLACE;
>        }
>
> +       writel(cfg, dev->regs + S5P_CISCCTRL);
> +}
> +
> +void fimc_hw_set_mainscaler(struct fimc_ctx *ctx)
> +{
> +       struct fimc_dev *dev = ctx->fimc_dev;
> +       struct fimc_scaler *sc = &ctx->scaler;
> +       u32 cfg;
> +
>        dbg("main_hratio= 0x%X  main_vratio= 0x%X",
>                sc->main_hratio, sc->main_vratio);
>
> +       fimc_hw_set_scaler(ctx);
> +
> +       cfg = readl(dev->regs + S5P_CISCCTRL);
> +       cfg &= ~S5P_CISCCTRL_SC_HORRATIO_MASK;
> +       cfg &= ~S5P_CISCCTRL_SC_VERRATIO_MASK;
>        cfg |= S5P_CISCCTRL_SC_HORRATIO(sc->main_hratio);
>        cfg |= S5P_CISCCTRL_SC_VERRATIO(sc->main_vratio);
>
>        writel(cfg, dev->regs + S5P_CISCCTRL);
>  }
>
> +void fimc_hw_set_mainscaler_ext(struct fimc_ctx *ctx)
> +{
> +       struct fimc_dev *dev = ctx->fimc_dev;
> +       struct fimc_scaler *sc = &ctx->scaler;
> +       u32 cfg, cfg_ext;
> +
> +       dbg("main_hratio= 0x%X  main_vratio= 0x%X",
> +               sc->main_hratio, sc->main_vratio);
> +
> +       fimc_hw_set_scaler(ctx);
> +
> +       cfg = readl(dev->regs + S5P_CISCCTRL);
> +       cfg &= ~S5P_CISCCTRL_SC_HORRATIO_MASK;
> +       cfg &= ~S5P_CISCCTRL_SC_VERRATIO_MASK;
> +       cfg |= S5P_CISCCTRL_SC_HORRATIO_EXT(sc->main_hratio);
> +       cfg |= S5P_CISCCTRL_SC_VERRATIO_EXT(sc->main_vratio);
> +
> +       writel(cfg, dev->regs + S5P_CISCCTRL);
> +
> +       cfg_ext = readl(dev->regs + S5P_CIEXTEN);
> +       cfg_ext &= ~S5P_CIEXTEN_MAINHORRATIO_EXT_MASK;
> +       cfg_ext &= ~S5P_CIEXTEN_MAINVERRATIO_EXT_MASK;
> +       cfg_ext |= S5P_CIEXTEN_MAINHORRATIO_EXT(sc->main_hratio);
> +       cfg_ext |= S5P_CIEXTEN_MAINVERRATIO_EXT(sc->main_vratio);
> +
> +       writel(cfg_ext, dev->regs + S5P_CIEXTEN);
> +}
> +
>  void fimc_hw_en_capture(struct fimc_ctx *ctx)
>  {
>        struct fimc_dev *dev = ctx->fimc_dev;
> diff --git a/drivers/media/video/s5p-fimc/regs-fimc.h b/drivers/media/video/s5p-fimc/regs-fimc.h
> index 57e33f8..4d1abd1 100644
> --- a/drivers/media/video/s5p-fimc/regs-fimc.h
> +++ b/drivers/media/video/s5p-fimc/regs-fimc.h
> @@ -141,6 +141,10 @@
>  #define S5P_CISCCTRL_ONE2ONE           (1 << 9)
>  #define S5P_CISCCTRL_SC_HORRATIO(x)    ((x) << 16)
>  #define S5P_CISCCTRL_SC_VERRATIO(x)    ((x) << 0)
> +#define S5P_CISCCTRL_SC_HORRATIO_MASK  (0x1ff << 16)
> +#define S5P_CISCCTRL_SC_VERRATIO_MASK  (0x1ff << 0)
> +#define S5P_CISCCTRL_SC_HORRATIO_EXT(x) ((x >> 6) << 16)
> +#define S5P_CISCCTRL_SC_VERRATIO_EXT(x)        ((x >> 6) << 0)
>
>  /* Target area */
>  #define S5P_CITAREA                    0x5c
> @@ -262,7 +266,11 @@
>  #define S5P_ORIG_SIZE_HOR(x)           ((x) << 0)
>
>  /* Real output DMA image size (extension register) */
> -#define S5P_CIEXTEN                    0x188
> +#define S5P_CIEXTEN                            0x188
> +#define S5P_CIEXTEN_MAINHORRATIO_EXT(x)                (((x) & 0x3f) << 10)
> +#define S5P_CIEXTEN_MAINVERRATIO_EXT(x)                ((x) & 0x3f)
> +#define S5P_CIEXTEN_MAINHORRATIO_EXT_MASK      (0x3f << 10)
> +#define S5P_CIEXTEN_MAINVERRATIO_EXT_MASK      (0x3f)
>
>  #define S5P_CIDMAPARAM                 0x18c
>  #define S5P_CIDMAPARAM_R_LINEAR                (0 << 29)
> --
> 1.6.2.5

Thank you,
Kyungmin Park
