Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:45417 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751512AbdLKPJf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 10:09:35 -0500
MIME-Version: 1.0
In-Reply-To: <20171211120612.3775893-1-arnd@arndb.de>
References: <20171211120612.3775893-1-arnd@arndb.de>
From: Michael Ira Krufky <mkrufky@linuxtv.org>
Date: Mon, 11 Dec 2017 10:09:33 -0500
Message-ID: <CAOcJUbzMoB-kp_Hhb=eYBH3w4FhCfwc_QEfkJ6Ua8WBFP_VUGg@mail.gmail.com>
Subject: Re: [PATCH] tuners: tda8290: reduce stack usage with kasan
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 11, 2017 at 7:06 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> With CONFIG_KASAN enabled, we get a relatively large stack frame in one function
>
> drivers/media/tuners/tda8290.c: In function 'tda8290_set_params':
> drivers/media/tuners/tda8290.c:310:1: warning: the frame size of 1520 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>
> With CONFIG_KASAN_EXTRA this goes up to
>
> drivers/media/tuners/tda8290.c: In function 'tda8290_set_params':
> drivers/media/tuners/tda8290.c:310:1: error: the frame size of 3200 bytes is larger than 3072 bytes [-Werror=frame-larger-than=]
>
> We can significantly reduce this by marking local arrays as 'static const', and
> this should result in better compiled code for everyone.
>
> I have another patch for the same symptom to patch tuner_i2c_xfer_*, and we
> actually want both of them.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thank you, Arnd.

Reviewed-by: Michael Ira Krufky <mkrufky@linuxtv.org>


> ---
>  drivers/media/tuners/tda8290.c | 76 ++++++++++++++++++++++--------------------
>  1 file changed, 39 insertions(+), 37 deletions(-)
>
> diff --git a/drivers/media/tuners/tda8290.c b/drivers/media/tuners/tda8290.c
> index a59c567c55d6..19854221b72d 100644
> --- a/drivers/media/tuners/tda8290.c
> +++ b/drivers/media/tuners/tda8290.c
> @@ -63,8 +63,8 @@ static int tda8290_i2c_bridge(struct dvb_frontend *fe, int close)
>  {
>         struct tda8290_priv *priv = fe->analog_demod_priv;
>
> -       unsigned char  enable[2] = { 0x21, 0xC0 };
> -       unsigned char disable[2] = { 0x21, 0x00 };
> +       static unsigned char  enable[2] = { 0x21, 0xC0 };
> +       static unsigned char disable[2] = { 0x21, 0x00 };
>         unsigned char *msg;
>
>         if (close) {
> @@ -84,9 +84,9 @@ static int tda8295_i2c_bridge(struct dvb_frontend *fe, int close)
>  {
>         struct tda8290_priv *priv = fe->analog_demod_priv;
>
> -       unsigned char  enable[2] = { 0x45, 0xc1 };
> -       unsigned char disable[2] = { 0x46, 0x00 };
> -       unsigned char buf[3] = { 0x45, 0x01, 0x00 };
> +       static unsigned char  enable[2] = { 0x45, 0xc1 };
> +       static unsigned char disable[2] = { 0x46, 0x00 };
> +       static unsigned char buf[3] = { 0x45, 0x01, 0x00 };
>         unsigned char *msg;
>
>         if (close) {
> @@ -178,24 +178,24 @@ static void tda8290_set_params(struct dvb_frontend *fe,
>  {
>         struct tda8290_priv *priv = fe->analog_demod_priv;
>
> -       unsigned char soft_reset[]  = { 0x00, 0x00 };
> +       static unsigned char soft_reset[]  = { 0x00, 0x00 };
>         unsigned char easy_mode[]   = { 0x01, priv->tda8290_easy_mode };
> -       unsigned char expert_mode[] = { 0x01, 0x80 };
> -       unsigned char agc_out_on[]  = { 0x02, 0x00 };
> -       unsigned char gainset_off[] = { 0x28, 0x14 };
> -       unsigned char if_agc_spd[]  = { 0x0f, 0x88 };
> -       unsigned char adc_head_6[]  = { 0x05, 0x04 };
> -       unsigned char adc_head_9[]  = { 0x05, 0x02 };
> -       unsigned char adc_head_12[] = { 0x05, 0x01 };
> -       unsigned char pll_bw_nom[]  = { 0x0d, 0x47 };
> -       unsigned char pll_bw_low[]  = { 0x0d, 0x27 };
> -       unsigned char gainset_2[]   = { 0x28, 0x64 };
> -       unsigned char agc_rst_on[]  = { 0x0e, 0x0b };
> -       unsigned char agc_rst_off[] = { 0x0e, 0x09 };
> -       unsigned char if_agc_set[]  = { 0x0f, 0x81 };
> -       unsigned char addr_adc_sat  = 0x1a;
> -       unsigned char addr_agc_stat = 0x1d;
> -       unsigned char addr_pll_stat = 0x1b;
> +       static unsigned char expert_mode[] = { 0x01, 0x80 };
> +       static unsigned char agc_out_on[]  = { 0x02, 0x00 };
> +       static unsigned char gainset_off[] = { 0x28, 0x14 };
> +       static unsigned char if_agc_spd[]  = { 0x0f, 0x88 };
> +       static unsigned char adc_head_6[]  = { 0x05, 0x04 };
> +       static unsigned char adc_head_9[]  = { 0x05, 0x02 };
> +       static unsigned char adc_head_12[] = { 0x05, 0x01 };
> +       static unsigned char pll_bw_nom[]  = { 0x0d, 0x47 };
> +       static unsigned char pll_bw_low[]  = { 0x0d, 0x27 };
> +       static unsigned char gainset_2[]   = { 0x28, 0x64 };
> +       static unsigned char agc_rst_on[]  = { 0x0e, 0x0b };
> +       static unsigned char agc_rst_off[] = { 0x0e, 0x09 };
> +       static unsigned char if_agc_set[]  = { 0x0f, 0x81 };
> +       static unsigned char addr_adc_sat  = 0x1a;
> +       static unsigned char addr_agc_stat = 0x1d;
> +       static unsigned char addr_pll_stat = 0x1b;
>         unsigned char adc_sat, agc_stat,
>                       pll_stat;
>         int i;
> @@ -468,9 +468,9 @@ static void tda8290_standby(struct dvb_frontend *fe)
>  {
>         struct tda8290_priv *priv = fe->analog_demod_priv;
>
> -       unsigned char cb1[] = { 0x30, 0xD0 };
> -       unsigned char tda8290_standby[] = { 0x00, 0x02 };
> -       unsigned char tda8290_agc_tri[] = { 0x02, 0x20 };
> +       static unsigned char cb1[] = { 0x30, 0xD0 };
> +       static unsigned char tda8290_standby[] = { 0x00, 0x02 };
> +       static unsigned char tda8290_agc_tri[] = { 0x02, 0x20 };
>         struct i2c_msg msg = {.addr = priv->tda827x_addr, .flags=0, .buf=cb1, .len = 2};
>
>         if (fe->ops.analog_ops.i2c_gate_ctrl)
> @@ -495,9 +495,9 @@ static void tda8290_init_if(struct dvb_frontend *fe)
>  {
>         struct tda8290_priv *priv = fe->analog_demod_priv;
>
> -       unsigned char set_VS[] = { 0x30, 0x6F };
> -       unsigned char set_GP00_CF[] = { 0x20, 0x01 };
> -       unsigned char set_GP01_CF[] = { 0x20, 0x0B };
> +       static unsigned char set_VS[] = { 0x30, 0x6F };
> +       static unsigned char set_GP00_CF[] = { 0x20, 0x01 };
> +       static unsigned char set_GP01_CF[] = { 0x20, 0x0B };
>
>         if ((priv->cfg.config == TDA8290_LNA_GP0_HIGH_ON) ||
>             (priv->cfg.config == TDA8290_LNA_GP0_HIGH_OFF))
> @@ -539,10 +539,12 @@ static void tda8295_init_if(struct dvb_frontend *fe)
>  static void tda8290_init_tuner(struct dvb_frontend *fe)
>  {
>         struct tda8290_priv *priv = fe->analog_demod_priv;
> -       unsigned char tda8275_init[]  = { 0x00, 0x00, 0x00, 0x40, 0xdC, 0x04, 0xAf,
> -                                         0x3F, 0x2A, 0x04, 0xFF, 0x00, 0x00, 0x40 };
> -       unsigned char tda8275a_init[] = { 0x00, 0x00, 0x00, 0x00, 0xdC, 0x05, 0x8b,
> -                                         0x0c, 0x04, 0x20, 0xFF, 0x00, 0x00, 0x4b };
> +       static unsigned char tda8275_init[]  =
> +               { 0x00, 0x00, 0x00, 0x40, 0xdC, 0x04, 0xAf,
> +                 0x3F, 0x2A, 0x04, 0xFF, 0x00, 0x00, 0x40 };
> +       static unsigned char tda8275a_init[] =
> +                { 0x00, 0x00, 0x00, 0x00, 0xdC, 0x05, 0x8b,
> +                  0x0c, 0x04, 0x20, 0xFF, 0x00, 0x00, 0x4b };
>         struct i2c_msg msg = {.addr = priv->tda827x_addr, .flags=0,
>                               .buf=tda8275_init, .len = 14};
>         if (priv->ver & TDA8275A)
> @@ -834,11 +836,11 @@ int tda829x_probe(struct i2c_adapter *i2c_adap, u8 i2c_addr)
>                 .addr = i2c_addr,
>         };
>
> -       unsigned char soft_reset[]   = { 0x00, 0x00 };
> -       unsigned char easy_mode_b[]  = { 0x01, 0x02 };
> -       unsigned char easy_mode_g[]  = { 0x01, 0x04 };
> -       unsigned char restore_9886[] = { 0x00, 0xd6, 0x30 };
> -       unsigned char addr_dto_lsb = 0x07;
> +       static unsigned char soft_reset[]   = { 0x00, 0x00 };
> +       static unsigned char easy_mode_b[]  = { 0x01, 0x02 };
> +       static unsigned char easy_mode_g[]  = { 0x01, 0x04 };
> +       static unsigned char restore_9886[] = { 0x00, 0xd6, 0x30 };
> +       static unsigned char addr_dto_lsb = 0x07;
>         unsigned char data;
>  #define PROBE_BUFFER_SIZE 8
>         unsigned char buf[PROBE_BUFFER_SIZE];
> --
> 2.9.0
>
