Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:35362 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730869AbeHGSsU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 14:48:20 -0400
Received: by mail-pl0-f67.google.com with SMTP id w3-v6so7343501plq.2
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2018 09:33:14 -0700 (PDT)
MIME-Version: 1.0
References: <8687b2e6b66e06ca52e138c6fdb6c1f6d5a3f92f.1533643371.git.mchehab+samsung@kernel.org>
In-Reply-To: <8687b2e6b66e06ca52e138c6fdb6c1f6d5a3f92f.1533643371.git.mchehab+samsung@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Tue, 7 Aug 2018 09:33:03 -0700
Message-ID: <CAKwvOdkM+OAWS0SaPBcKpJukTrpbZGTYjYopAS-zRjo09TCFRA@mail.gmail.com>
Subject: Re: [PATCH] media: cleanup fall-through comments
To: mchehab+samsung@kernel.org
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
        slongerbeam@gmail.com, p.zabel@pengutronix.de,
        Greg KH <gregkh@linuxfoundation.org>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Hans Verkuil <hansverk@cisco.com>,
        Colin Ian King <colin.king@canonical.com>,
        devel@driverdev.osuosl.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 7, 2018 at 5:07 AM Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
>
> As Ian pointed out, adding a '-' to the fallthrough seems to meet
> the regex requirements at level 3 of the warning, at least when
> the comment fits into a single line.
>
> So, replace by a single line the comments that were broken into
> multiple lines just to make gcc -Wimplicit-fallthrough=3 happy.
>
> Suggested-by: Ian Arkver <ian.arkver.dev@gmail.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  drivers/media/dvb-frontends/drx39xyj/drxj.c |  3 +--
>  drivers/media/dvb-frontends/drxd_hard.c     |  6 ++----
>  drivers/media/dvb-frontends/drxk_hard.c     | 18 ++++++------------
>  drivers/staging/media/imx/imx-media-csi.c   |  3 +--
>  4 files changed, 10 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
> index 2ddb7d218ace..2948d12d7c14 100644
> --- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
> +++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
> @@ -2841,8 +2841,7 @@ ctrl_set_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
>                         /* coef = 188/204                          */
>                         max_bit_rate =
>                             (ext_attr->curr_symbol_rate / 8) * nr_bits * 188;
> -                       /* pass through as b/c Annex A/c need following settings */
> -                       /* fall-through */
> +                       /* fall-through - as b/c Annex A/C need following settings */
>                 case DRX_STANDARD_ITU_B:
>                         rc = drxj_dap_write_reg16(dev_addr, FEC_OC_FCT_USAGE__A, FEC_OC_FCT_USAGE__PRE, 0);
>                         if (rc != 0) {
> diff --git a/drivers/media/dvb-frontends/drxd_hard.c b/drivers/media/dvb-frontends/drxd_hard.c
> index 11fc259e4383..684d428efb0d 100644
> --- a/drivers/media/dvb-frontends/drxd_hard.c
> +++ b/drivers/media/dvb-frontends/drxd_hard.c
> @@ -1970,8 +1970,7 @@ static int DRX_Start(struct drxd_state *state, s32 off)
>                 switch (p->transmission_mode) {
>                 default:        /* Not set, detect it automatically */
>                         operationMode |= SC_RA_RAM_OP_AUTO_MODE__M;
> -                       /* try first guess DRX_FFTMODE_8K */
> -                       /* fall through */
> +                       /* fall through - try first guess DRX_FFTMODE_8K */
>                 case TRANSMISSION_MODE_8K:
>                         transmissionParams |= SC_RA_RAM_OP_PARAM_MODE_8K;
>                         if (state->type_A) {
> @@ -2144,8 +2143,7 @@ static int DRX_Start(struct drxd_state *state, s32 off)
>                 switch (p->modulation) {
>                 default:
>                         operationMode |= SC_RA_RAM_OP_AUTO_CONST__M;
> -                       /* try first guess DRX_CONSTELLATION_QAM64 */
> -                       /* fall through */
> +                       /* fall through - try first guess DRX_CONSTELLATION_QAM64 */
>                 case QAM_64:
>                         transmissionParams |= SC_RA_RAM_OP_PARAM_CONST_QAM64;
>                         if (state->type_A) {
> diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
> index ac10781d3550..f1886945a7bc 100644
> --- a/drivers/media/dvb-frontends/drxk_hard.c
> +++ b/drivers/media/dvb-frontends/drxk_hard.c
> @@ -3270,13 +3270,11 @@ static int dvbt_sc_command(struct drxk_state *state,
>         case OFDM_SC_RA_RAM_CMD_SET_PREF_PARAM:
>         case OFDM_SC_RA_RAM_CMD_PROGRAM_PARAM:
>                 status |= write16(state, OFDM_SC_RA_RAM_PARAM1__A, param1);
> -               /* All commands using 1 parameters */
> -               /* fall through */
> +               /* fall through - All commands using 1 parameters */
>         case OFDM_SC_RA_RAM_CMD_SET_ECHO_TIMING:
>         case OFDM_SC_RA_RAM_CMD_USER_IO:
>                 status |= write16(state, OFDM_SC_RA_RAM_PARAM0__A, param0);
> -               /* All commands using 0 parameters */
> -               /* fall through */
> +               /* fall through - All commands using 0 parameters */
>         case OFDM_SC_RA_RAM_CMD_GET_OP_PARAM:
>         case OFDM_SC_RA_RAM_CMD_NULL:
>                 /* Write command */
> @@ -3784,8 +3782,7 @@ static int set_dvbt(struct drxk_state *state, u16 intermediate_freqk_hz,
>         case TRANSMISSION_MODE_AUTO:
>         default:
>                 operation_mode |= OFDM_SC_RA_RAM_OP_AUTO_MODE__M;
> -               /* try first guess DRX_FFTMODE_8K */
> -               /* fall through */
> +               /* fall through - try first guess DRX_FFTMODE_8K */
>         case TRANSMISSION_MODE_8K:
>                 transmission_params |= OFDM_SC_RA_RAM_OP_PARAM_MODE_8K;
>                 break;
> @@ -3799,8 +3796,7 @@ static int set_dvbt(struct drxk_state *state, u16 intermediate_freqk_hz,
>         default:
>         case GUARD_INTERVAL_AUTO:
>                 operation_mode |= OFDM_SC_RA_RAM_OP_AUTO_GUARD__M;
> -               /* try first guess DRX_GUARD_1DIV4 */
> -               /* fall through */
> +               /* fall through - try first guess DRX_GUARD_1DIV4 */
>         case GUARD_INTERVAL_1_4:
>                 transmission_params |= OFDM_SC_RA_RAM_OP_PARAM_GUARD_4;
>                 break;
> @@ -3841,8 +3837,7 @@ static int set_dvbt(struct drxk_state *state, u16 intermediate_freqk_hz,
>         case QAM_AUTO:
>         default:
>                 operation_mode |= OFDM_SC_RA_RAM_OP_AUTO_CONST__M;
> -               /* try first guess DRX_CONSTELLATION_QAM64 */
> -               /* fall through */
> +               /* fall through - try first guess DRX_CONSTELLATION_QAM64 */
>         case QAM_64:
>                 transmission_params |= OFDM_SC_RA_RAM_OP_PARAM_CONST_QAM64;
>                 break;
> @@ -3885,8 +3880,7 @@ static int set_dvbt(struct drxk_state *state, u16 intermediate_freqk_hz,
>         case FEC_AUTO:
>         default:
>                 operation_mode |= OFDM_SC_RA_RAM_OP_AUTO_RATE__M;
> -               /* try first guess DRX_CODERATE_2DIV3 */
> -               /* fall through */
> +               /* fall through - try first guess DRX_CODERATE_2DIV3 */
>         case FEC_2_3:
>                 transmission_params |= OFDM_SC_RA_RAM_OP_PARAM_RATE_2_3;
>                 break;
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index b7ffd231c64b..cd2c291e1e94 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -460,8 +460,7 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
>                         passthrough_cycles = incc->cycles;
>                         break;
>                 }
> -               /* for non-passthrough RGB565 (CSI-2 bus) */
> -               /* Falls through */
> +               /* fallthrough - non-passthrough RGB565 (CSI-2 bus) */
>         default:
>                 burst_size = (image.pix.width & 0xf) ? 8 : 16;
>                 passthrough_bits = 16;
> --
> 2.17.1
>

Can we use the compiler attribute:

__attribute__((fallthrough))

rather than specifically formatted comments?  The thing to be careful
about with attributes is "what is the first version of the compiler
that implements these?"

https://developers.redhat.com/blog/2017/03/10/wimplicit-fallthrough-in-gcc-7/

seems to indicate that the comment parsing was implemented in gcc-7
(and also shows the compiler attribute being used)?
-- 
Thanks,
~Nick Desaulniers
