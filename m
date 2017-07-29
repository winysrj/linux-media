Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:35901 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753112AbdG2Dlu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 23:41:50 -0400
Received: by mail-yw0-f169.google.com with SMTP id u207so71623367ywc.3
        for <linux-media@vger.kernel.org>; Fri, 28 Jul 2017 20:41:50 -0700 (PDT)
Received: from mail-yw0-f178.google.com (mail-yw0-f178.google.com. [209.85.161.178])
        by smtp.gmail.com with ESMTPSA id c9sm8449339ywk.20.2017.07.28.20.41.48
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jul 2017 20:41:48 -0700 (PDT)
Received: by mail-yw0-f178.google.com with SMTP id s143so452570ywg.1
        for <linux-media@vger.kernel.org>; Fri, 28 Jul 2017 20:41:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1501267690-2338-1-git-send-email-chiranjeevi.rapolu@intel.com>
References: <1501267690-2338-1-git-send-email-chiranjeevi.rapolu@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Sat, 29 Jul 2017 12:41:27 +0900
Message-ID: <CAAFQd5DAk_qEXZXeC16HPxVJCtV3B_YSsMDefwTd5MJxZ6PNTg@mail.gmail.com>
Subject: Re: [PATCH v1] media: ov13858: Correct link-frequency and pixel-rate
To: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chiranjeevi,

On Sat, Jul 29, 2017 at 3:48 AM, Chiranjeevi Rapolu
<chiranjeevi.rapolu@intel.com> wrote:
> Previously both link-frequency and pixel-rate reported by
> the sensor was incorrect, resulting in incorrect FPS.
> Report link-frequency in Hz rather than link data rate in bps.
> Calculate pixel-rate from link-frequency.
>
> Signed-off-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
> ---
>  drivers/media/i2c/ov13858.c | 28 +++++++++++++++-------------
>  1 file changed, 15 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/media/i2c/ov13858.c b/drivers/media/i2c/ov13858.c
> index 86550d8..2a5bb43 100644
> --- a/drivers/media/i2c/ov13858.c
> +++ b/drivers/media/i2c/ov13858.c
> @@ -60,8 +60,8 @@
>  #define OV13858_VBLANK_MIN             56
>
>  /* HBLANK control - read only */
> -#define OV13858_PPL_540MHZ             2244
> -#define OV13858_PPL_1080MHZ            4488
> +#define OV13858_PPL_270MHZ             2244
> +#define OV13858_PLL_540MHZ             4488

typo? "PPL" seems correct, because it's supposed to be pixels per line.

>
>  /* Exposure control */
>  #define OV13858_REG_EXPOSURE           0x3500
> @@ -944,31 +944,33 @@ struct ov13858_mode {
>
>  /* Configurations for supported link frequencies */
>  #define OV13858_NUM_OF_LINK_FREQS      2
> -#define OV13858_LINK_FREQ_1080MBPS     1080000000
> -#define OV13858_LINK_FREQ_540MBPS      540000000
> +#define OV13858_LINK_FREQ_540MHZ       540000000
> +#define OV13858_LINK_FREQ_270MHZ       270000000
>  #define OV13858_LINK_FREQ_INDEX_0      0
>  #define OV13858_LINK_FREQ_INDEX_1      1
>
>  /* Menu items for LINK_FREQ V4L2 control */
>  static const s64 link_freq_menu_items[OV13858_NUM_OF_LINK_FREQS] = {
> -       OV13858_LINK_FREQ_1080MBPS,
> -       OV13858_LINK_FREQ_540MBPS
> +       OV13858_LINK_FREQ_540MHZ,
> +       OV13858_LINK_FREQ_270MHZ
>  };
>
>  /* Link frequency configs */
>  static const struct ov13858_link_freq_config
>                         link_freq_configs[OV13858_NUM_OF_LINK_FREQS] = {
>         {
> -               .pixel_rate = 864000000,
> -               .pixels_per_line = OV13858_PPL_1080MHZ,
> +               /* pixel_rate = link_freq * 2 * nr_of_lanes / bits_per_sample */
> +               .pixel_rate = ((uint64_t)OV13858_LINK_FREQ_540MHZ * 2 * 4) / 10,

Instead of this cast, you can just define OV13858_LINK_FREQ_540MHZ to
be 540000000ULL.

> +               .pixels_per_line = OV13858_PLL_540MHZ,

s/PLL/PPL/?

>                 .reg_list = {
>                         .num_of_regs = ARRAY_SIZE(mipi_data_rate_1080mbps),
>                         .regs = mipi_data_rate_1080mbps,
>                 }
>         },
>         {
> -               .pixel_rate = 432000000,
> -               .pixels_per_line = OV13858_PPL_540MHZ,
> +               /* pixel_rate = link_freq * 2 * nr_of_lanes / bits_per_sample */
> +               .pixel_rate = ((uint64_t)OV13858_LINK_FREQ_270MHZ * 2 * 4) / 10,

Ditto.

> +               .pixels_per_line = OV13858_PPL_270MHZ,
>                 .reg_list = {
>                         .num_of_regs = ARRAY_SIZE(mipi_data_rate_540mbps),
>                         .regs = mipi_data_rate_540mbps,
> @@ -1634,10 +1636,10 @@ static int ov13858_init_controls(struct ov13858 *ov13858)
>
>         ov13858->hblank = v4l2_ctrl_new_std(
>                                 ctrl_hdlr, &ov13858_ctrl_ops, V4L2_CID_HBLANK,
> -                               OV13858_PPL_1080MHZ - ov13858->cur_mode->width,
> -                               OV13858_PPL_1080MHZ - ov13858->cur_mode->width,
> +                               OV13858_PLL_540MHZ - ov13858->cur_mode->width,
> +                               OV13858_PLL_540MHZ - ov13858->cur_mode->width,
>                                 1,
> -                               OV13858_PPL_1080MHZ - ov13858->cur_mode->width);
> +                               OV13858_PLL_540MHZ - ov13858->cur_mode->width);

Ditto.

Best regards,
Tomasz
