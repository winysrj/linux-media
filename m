Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:34146 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbcGGPXR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2016 11:23:17 -0400
Received: by mail-io0-f176.google.com with SMTP id i186so23348149iof.1
        for <linux-media@vger.kernel.org>; Thu, 07 Jul 2016 08:23:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1467846004-12731-6-git-send-email-steve_longerbeam@mentor.com>
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com> <1467846004-12731-6-git-send-email-steve_longerbeam@mentor.com>
From: Tim Harvey <tharvey@gateworks.com>
Date: Thu, 7 Jul 2016 08:23:16 -0700
Message-ID: <CAJ+vNU2orZ_C8Hyx6_vqQvDg0P-TzivB22tm_D84mq6YDLxNqA@mail.gmail.com>
Subject: Re: [PATCH 05/11] media: adv7180: init chip with AD recommended
 register settings
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Steve Longerbeam <steve_longerbeam@mentor.com>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Simon Horman <horms+renesas@verge.net.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 6, 2016 at 3:59 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:
> Define and load register tables that conform to Analog Device's
> recommended register settings. It loads the default single-ended
> CVBS on Ain1 configuration for both ADV7180 and ADV7182 chips.
>
> New register addresses have been defined for the tables. Those new
> defines are also used in existing locations where hard-coded addresses
> were used.
>
> Note this patch also enables NEWAVMODE, which is also recommended by
> Analog Devices. This will likely break any current backends using this
> subdev that are expecting different or manually configured AV codes.
>
> Note also that bt.656-4 support has been removed in this patch, but it
> will be brought back in a subsequent patch.
>
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/media/i2c/adv7180.c | 168 ++++++++++++++++++++++++++++++++++----------
>  1 file changed, 130 insertions(+), 38 deletions(-)
>
> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
> index 42816d4..92e2f37 100644
> --- a/drivers/media/i2c/adv7180.c
> +++ b/drivers/media/i2c/adv7180.c
> @@ -56,10 +56,11 @@
>
>  #define ADV7182_REG_INPUT_VIDSEL                       0x0002
>
> +#define ADV7180_REG_OUTPUT_CONTROL                     0x0003
>  #define ADV7180_REG_EXTENDED_OUTPUT_CONTROL            0x0004
>  #define ADV7180_EXTENDED_OUTPUT_CONTROL_NTSCDIS                0xC5
>
> -#define ADV7180_REG_AUTODETECT_ENABLE                  0x07
> +#define ADV7180_REG_AUTODETECT_ENABLE                  0x0007
>  #define ADV7180_AUTODETECT_DEFAULT                     0x7f
>  /* Contrast */
>  #define ADV7180_REG_CON                0x0008  /*Unsigned */
> @@ -100,6 +101,20 @@
>  #define ADV7180_REG_IDENT 0x0011
>  #define ADV7180_ID_7180 0x18
>
> +#define ADV7180_REG_STATUS3            0x0013
> +#define ADV7180_REG_ANALOG_CLAMP_CTL   0x0014
> +#define ADV7180_REG_SHAP_FILTER_CTL_1  0x0017
> +#define ADV7180_REG_CTRL_2             0x001d
> +#define ADV7180_REG_VSYNC_FIELD_CTL_1  0x0031
> +#define ADV7180_REG_MANUAL_WIN_CTL_1   0x003d
> +#define ADV7180_REG_MANUAL_WIN_CTL_2   0x003e
> +#define ADV7180_REG_MANUAL_WIN_CTL_3   0x003f
> +#define ADV7180_REG_LOCK_CNT           0x0051
> +#define ADV7180_REG_CVBS_TRIM          0x0052
> +#define ADV7180_REG_CLAMP_ADJ          0x005a
> +#define ADV7180_REG_RES_CIR            0x005f
> +#define ADV7180_REG_DIFF_MODE          0x0060
> +
>  #define ADV7180_REG_ICONF1             0x2040
>  #define ADV7180_ICONF1_ACTIVE_LOW      0x01
>  #define ADV7180_ICONF1_PSYNC_ONLY      0x10
> @@ -129,9 +144,15 @@
>  #define ADV7180_REG_VPP_SLAVE_ADDR     0xFD
>  #define ADV7180_REG_CSI_SLAVE_ADDR     0xFE
>
> -#define ADV7180_REG_FLCONTROL 0x40e0
> +#define ADV7180_REG_ACE_CTRL1          0x4080
> +#define ADV7180_REG_ACE_CTRL5          0x4084
> +#define ADV7180_REG_FLCONTROL          0x40e0
>  #define ADV7180_FLCONTROL_FL_ENABLE 0x1
>
> +#define ADV7180_REG_RST_CLAMP  0x809c
> +#define ADV7180_REG_AGC_ADJ1   0x80b6
> +#define ADV7180_REG_AGC_ADJ2   0x80c0
> +
>  #define ADV7180_CSI_REG_PWRDN  0x00
>  #define ADV7180_CSI_PWRDN      0x80
>
> @@ -209,6 +230,11 @@ struct adv7180_state {
>                                             struct adv7180_state,       \
>                                             ctrl_hdl)->sd)
>
> +struct adv7180_reg_tbl_t {
> +       unsigned int reg;
> +       unsigned int val;
> +};
> +
>  static int adv7180_select_page(struct adv7180_state *state, unsigned int page)
>  {
>         if (state->register_page != page) {
> @@ -235,6 +261,20 @@ static int adv7180_read(struct adv7180_state *state, unsigned int reg)
>         return i2c_smbus_read_byte_data(state->client, reg & 0xff);
>  }
>
> +static int adv7180_load_reg_tbl(struct adv7180_state *state,
> +                               const struct adv7180_reg_tbl_t *tbl, int n)
> +{
> +       int ret, i;
> +
> +       for (i = 0; i < n; i++) {
> +               ret = adv7180_write(state, tbl[i].reg, tbl[i].val);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       return 0;
> +}
> +
>  static int adv7180_csi_write(struct adv7180_state *state, unsigned int reg,
>         unsigned int value)
>  {
> @@ -828,19 +868,36 @@ static irqreturn_t adv7180_irq(int irq, void *devid)
>         return IRQ_HANDLED;
>  }
>
> +/*
> + * This register table conforms to Analog Device's Register Settings
> + * Recommendation for the ADV7180. It configures single-ended CVBS
> + * input on Ain1, and enables NEWAVMODE.
> + */
> +static const struct adv7180_reg_tbl_t adv7180_single_ended_cvbs[] = {
> +       /* Set analog mux for CVBS on Ain1 */
> +       { ADV7180_REG_INPUT_CONTROL, 0x00 },
> +       /* ADI Required Write: Reset Clamp Circuitry */
> +       { ADV7180_REG_ANALOG_CLAMP_CTL, 0x30 },
> +       /* Enable SFL Output */
> +       { ADV7180_REG_EXTENDED_OUTPUT_CONTROL, 0x57 },
> +       /* Select SH1 Chroma Shaping Filter */
> +       { ADV7180_REG_SHAP_FILTER_CTL_1, 0x41 },
> +       /* Enable NEWAVMODE */
> +       { ADV7180_REG_VSYNC_FIELD_CTL_1, 0x02 },
> +       /* ADI Required Write: optimize windowing function Step 1,2,3 */
> +       { ADV7180_REG_MANUAL_WIN_CTL_1, 0xA2 },
> +       { ADV7180_REG_MANUAL_WIN_CTL_2, 0x6A },
> +       { ADV7180_REG_MANUAL_WIN_CTL_3, 0xA0 },
> +       /* ADI Required Write: Enable ADC step 1,2,3 */
> +       { 0x8055, 0x81 }, /* undocumented register 0x55 */
> +       /* Recommended AFE I BIAS Setting for CVBS mode */
> +       { ADV7180_REG_CVBS_TRIM, 0x0D },
> +};
> +
>  static int adv7180_init(struct adv7180_state *state)
>  {
> -       int ret;
> -
> -       /* ITU-R BT.656-4 compatible */
> -       ret = adv7180_write(state, ADV7180_REG_EXTENDED_OUTPUT_CONTROL,
> -                       ADV7180_EXTENDED_OUTPUT_CONTROL_NTSCDIS);
> -       if (ret < 0)
> -               return ret;
> -
> -       /* Manually set V bit end position in NTSC mode */
> -       return adv7180_write(state, ADV7180_REG_NTSC_V_BIT_END,
> -                                       ADV7180_NTSC_V_BIT_END_MANUAL_NVEND);
> +       return adv7180_load_reg_tbl(state, adv7180_single_ended_cvbs,
> +                                   ARRAY_SIZE(adv7180_single_ended_cvbs));
>  }
>
>  static int adv7180_set_std(struct adv7180_state *state, unsigned int std)
> @@ -862,8 +919,48 @@ static int adv7180_select_input(struct adv7180_state *state, unsigned int input)
>         return adv7180_write(state, ADV7180_REG_INPUT_CONTROL, ret);
>  }
>
> +/*
> + * This register table conforms to Analog Device's Register Settings
> + * Recommendation revision C for the ADV7182. It configures single-ended
> + * CVBS inputs on Ain1, and enables NEWAVMODE.
> + */
> +static const struct adv7180_reg_tbl_t adv7182_single_ended_cvbs[] = {
> +       /* Exit Power Down Mode */
> +       { ADV7180_REG_PWR_MAN, 0x00 },
> +       /* Enable ADV7182 for 28.63636 MHz Crystal Clock Input */
> +       { ADV7180_REG_STATUS3, 0x00 },
> +       /* Set optimized IBIAS for single-ended CVBS input */
> +       { ADV7180_REG_CVBS_TRIM, 0xCD },
> +       /* Switch to single-ended CVBS on AIN1 */
> +       { ADV7180_REG_INPUT_CONTROL, 0x00 },
> +       /* ADI Required Write: Reset Current Clamp Circuitry steps 1,2,3,4 */
> +       { ADV7180_REG_RST_CLAMP, 0x00 },
> +       { ADV7180_REG_RST_CLAMP, 0xFF },
> +       /* Select SH1 Chroma Shaping Filter */
> +       { ADV7180_REG_SHAP_FILTER_CTL_1, 0x41 },
> +       /* Enable Pixel & Sync output drivers */
> +       { ADV7180_REG_OUTPUT_CONTROL, 0x0C },
> +       /* Power-up INTRQ, HS and VS/FIELD/SFL pad */
> +       { ADV7180_REG_EXTENDED_OUTPUT_CONTROL, 0x07 },
> +       /* Enable LLC Output Driver */
> +       { ADV7180_REG_CTRL_2, 0x40 },
> +       /* Optimize ACE Performance */
> +       { ADV7180_REG_ACE_CTRL5, 0x00 },
> +       /* Enable ACE Feature */
> +       { ADV7180_REG_ACE_CTRL1, 0x80 },
> +       /* Enable NEWAVMODE */
> +       { ADV7180_REG_VSYNC_FIELD_CTL_1, 0x02 },
> +};
> +
>  static int adv7182_init(struct adv7180_state *state)
>  {
> +       int ret;
> +
> +       ret = adv7180_load_reg_tbl(state, adv7182_single_ended_cvbs,
> +                                  ARRAY_SIZE(adv7182_single_ended_cvbs));
> +       if (ret)
> +               return ret;
> +
>         if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2)
>                 adv7180_write(state, ADV7180_REG_CSI_SLAVE_ADDR,
>                         ADV7180_DEFAULT_CSI_I2C_ADDR << 1);
> @@ -881,20 +978,15 @@ static int adv7182_init(struct adv7180_state *state)
>
>         /* ADI required writes */
>         if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2) {
> -               adv7180_write(state, 0x0003, 0x4e);
> -               adv7180_write(state, 0x0004, 0x57);
> -               adv7180_write(state, 0x001d, 0xc0);
> +               adv7180_write(state, ADV7180_REG_OUTPUT_CONTROL, 0x4e);
> +               adv7180_write(state, ADV7180_REG_EXTENDED_OUTPUT_CONTROL, 0x57);
> +               adv7180_write(state, ADV7180_REG_CTRL_2, 0xc0);
>         } else {
>                 if (state->chip_info->flags & ADV7180_FLAG_V2)
> -                       adv7180_write(state, 0x0004, 0x17);
> -               else
> -                       adv7180_write(state, 0x0004, 0x07);
> -               adv7180_write(state, 0x0003, 0x0c);
> -               adv7180_write(state, 0x001d, 0x40);
> +                       adv7180_write(state, ADV7180_REG_EXTENDED_OUTPUT_CONTROL,
> +                                     0x17);
>         }
>
> -       adv7180_write(state, 0x0013, 0x00);
> -
>         return 0;
>  }
>
> @@ -967,8 +1059,8 @@ static int adv7182_select_input(struct adv7180_state *state, unsigned int input)
>                 return ret;
>
>         /* Reset clamp circuitry - ADI recommended writes */
> -       adv7180_write(state, 0x809c, 0x00);
> -       adv7180_write(state, 0x809c, 0xff);
> +       adv7180_write(state, ADV7180_REG_RST_CLAMP, 0x00);
> +       adv7180_write(state, ADV7180_REG_RST_CLAMP, 0xff);
>
>         input_type = adv7182_get_input_type(input);
>
> @@ -976,10 +1068,10 @@ static int adv7182_select_input(struct adv7180_state *state, unsigned int input)
>         case ADV7182_INPUT_TYPE_CVBS:
>         case ADV7182_INPUT_TYPE_DIFF_CVBS:
>                 /* ADI recommends to use the SH1 filter */
> -               adv7180_write(state, 0x0017, 0x41);
> +               adv7180_write(state, ADV7180_REG_SHAP_FILTER_CTL_1, 0x41);
>                 break;
>         default:
> -               adv7180_write(state, 0x0017, 0x01);
> +               adv7180_write(state, ADV7180_REG_SHAP_FILTER_CTL_1, 0x01);
>                 break;
>         }
>
> @@ -989,21 +1081,21 @@ static int adv7182_select_input(struct adv7180_state *state, unsigned int input)
>                 lbias = adv7182_lbias_settings[input_type];
>
>         for (i = 0; i < ARRAY_SIZE(adv7182_lbias_settings[0]); i++)
> -               adv7180_write(state, 0x0052 + i, lbias[i]);
> +               adv7180_write(state, ADV7180_REG_CVBS_TRIM + i, lbias[i]);
>
>         if (input_type == ADV7182_INPUT_TYPE_DIFF_CVBS) {
>                 /* ADI required writes to make differential CVBS work */
> -               adv7180_write(state, 0x005f, 0xa8);
> -               adv7180_write(state, 0x005a, 0x90);
> -               adv7180_write(state, 0x0060, 0xb0);
> -               adv7180_write(state, 0x80b6, 0x08);
> -               adv7180_write(state, 0x80c0, 0xa0);
> +               adv7180_write(state, ADV7180_REG_RES_CIR, 0xa8);
> +               adv7180_write(state, ADV7180_REG_CLAMP_ADJ, 0x90);
> +               adv7180_write(state, ADV7180_REG_DIFF_MODE, 0xb0);
> +               adv7180_write(state, ADV7180_REG_AGC_ADJ1, 0x08);
> +               adv7180_write(state, ADV7180_REG_AGC_ADJ2, 0xa0);
>         } else {
> -               adv7180_write(state, 0x005f, 0xf0);
> -               adv7180_write(state, 0x005a, 0xd0);
> -               adv7180_write(state, 0x0060, 0x10);
> -               adv7180_write(state, 0x80b6, 0x9c);
> -               adv7180_write(state, 0x80c0, 0x00);
> +               adv7180_write(state, ADV7180_REG_RES_CIR, 0xf0);
> +               adv7180_write(state, ADV7180_REG_CLAMP_ADJ, 0xd0);
> +               adv7180_write(state, ADV7180_REG_DIFF_MODE, 0x10);
> +               adv7180_write(state, ADV7180_REG_AGC_ADJ1, 0x9c);
> +               adv7180_write(state, ADV7180_REG_AGC_ADJ2, 0x00);
>         }
>
>         return 0;
> --

Steve,

Tested on an IMX6 Gateworks Ventana with IMX6 capture drivers [1].

Tested-by: Tim Harvey <tharvey@gateworks.com>
Acked-by: Tim Harvey <tharvey@gateworks.com>

Added to Cc:
Cc: Lars-Peter Clausen <lars@metafoo.de>

Also adding Cc's to the people who are using the adv7180 on other
boards (renesas r8a779* boards) so we can get some feedback and/or
Tested-by from them:
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Simon Horman <horms+renesas@verge.net.au>

I'm wondering if those boards need the bt656-4 which was previously
being enabled per your comment and is now moved to a dt-prop per a
subsequent patch.

Regards,

Tim

[1] - http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/102914
