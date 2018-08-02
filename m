Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:34050 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbeHBGAC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2018 02:00:02 -0400
Received: by mail-yb0-f193.google.com with SMTP id e9-v6so348742ybq.1
        for <linux-media@vger.kernel.org>; Wed, 01 Aug 2018 21:10:53 -0700 (PDT)
Received: from mail-yw0-f177.google.com (mail-yw0-f177.google.com. [209.85.161.177])
        by smtp.gmail.com with ESMTPSA id i125-v6sm264679ywd.92.2018.08.01.21.10.51
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Aug 2018 21:10:51 -0700 (PDT)
Received: by mail-yw0-f177.google.com with SMTP id c135-v6so346291ywa.0
        for <linux-media@vger.kernel.org>; Wed, 01 Aug 2018 21:10:51 -0700 (PDT)
MIME-Version: 1.0
References: <1533091146-29235-1-git-send-email-ping-chung.chen@intel.com>
In-Reply-To: <1533091146-29235-1-git-send-email-ping-chung.chen@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 2 Aug 2018 13:10:39 +0900
Message-ID: <CAAFQd5CS801SLWmZMD07Qm=ZpL9bVcBq03-8t6tekP8c69RTQg@mail.gmail.com>
Subject: Re: [PATCH v3] media: imx208: Add imx208 camera sensor driver
To: ping-chung.chen@intel.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Yeh, Andy" <andy.yeh@intel.com>, "Lai, Jim" <jim.lai@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Grant Grundler <grundler@chromium.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ping-chung,

On Wed, Aug 1, 2018 at 11:31 AM Ping-chung Chen
<ping-chung.chen@intel.com> wrote:
>
> From: "Chen, Ping-chung" <ping-chung.chen@intel.com>
>
> Add a V4L2 sub-device driver for the Sony IMX208 image sensor.
> This is a camera sensor using the I2C bus for control and the
> CSI-2 bus for data.
>
> Signed-off-by: Ping-Chung Chen <ping-chung.chen@intel.com>
> ---
> since v1:
> -- Update the function media_entity_pads_init for upstreaming.
> -- Change the structure name mutex as imx208_mx.
> -- Refine the control flow of test pattern function.
> -- vflip/hflip control support (will impact the output bayer order)
> -- support 4 bayer orders output (via change v/hflip)
>     - SRGGB10(default), SGRBG10, SGBRG10, SBGGR10
> -- Simplify error handling in the set_stream function.
> since v2:
> -- Refine coding style.
> -- Fix the if statement to use pm_runtime_get_if_in_use().
> -- Print more error log during error handling.
> -- Remove mutex_destroy() from imx208_free_controls().
> -- Add more comments.

Thanks for addressing the comments. There are still few remaining,
though. Please see inline.

[snip]
> +enum {
> +       IMX208_LINK_FREQ_384MHZ_INDEX,
> +       IMX208_LINK_FREQ_96MHZ_INDEX,
> +};
> +
> +/*
> + * pixel_rate = link_freq * data-rate * nr_of_lanes / bits_per_sample
> + * data rate => double data rate; number of lanes => 2; bits per pixel => 10
> + */
> +static u64 link_freq_to_pixel_rate(u64 f)
> +{
> +       f *= IMX208_DATA_RATE_DOUBLE * IMX208_NUM_OF_LANES;
> +       do_div(f, IMX208_PIXEL_BITS);
> +
> +       return f;
> +}
> +
> +/* Menu items for LINK_FREQ V4L2 control */
> +static const s64 link_freq_menu_items[] = {
> +       IMX208_LINK_FREQ_384MHZ,
> +       IMX208_LINK_FREQ_96MHZ,

I asked for having explicit indices using IMX208_LINK_FREQ_*_INDEX
enum used here too.

> +};
> +
> +/* Link frequency configs */
> +static const struct imx208_link_freq_config link_freq_configs[] = {
> +       [IMX208_LINK_FREQ_384MHZ_INDEX] = {
> +               .pixels_per_line = IMX208_PPL_384MHZ,
> +               .reg_list = {
> +                       .num_of_regs = ARRAY_SIZE(pll_ctrl_reg),
> +                       .regs = pll_ctrl_reg,
> +               }
> +       },
> +       [IMX208_LINK_FREQ_96MHZ_INDEX] = {
> +               .pixels_per_line = IMX208_PPL_96MHZ,
> +               .reg_list = {
> +                       .num_of_regs = ARRAY_SIZE(pll_ctrl_reg),
> +                       .regs = pll_ctrl_reg,
> +               }
> +       },
> +};
> +
> +/* Mode configs */
> +static const struct imx208_mode supported_modes[] = {
> +       [IMX208_LINK_FREQ_384MHZ_INDEX] = {

This is not the right index for this array (even if numerically the
same. This array is just a list of available modes (resolutions) and
there is no other data structure referring to particular entries of
it, so it doesn't need explicit indexing.

> +               .width = 1936,
> +               .height = 1096,
> +               .vts_def = IMX208_VTS_60FPS,
> +               .vts_min = IMX208_VTS_60FPS_MIN,
> +               .reg_list = {
> +                       .num_of_regs = ARRAY_SIZE(mode_1936x1096_60fps_regs),
> +                       .regs = mode_1936x1096_60fps_regs,
> +               },
> +               .link_freq_index = IMX208_LINK_FREQ_384MHZ_INDEX,
> +       },
> +       [IMX208_LINK_FREQ_96MHZ_INDEX] = {

Ditto.

Best regards,
Tomasz
