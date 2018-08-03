Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:42475 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbeHCFoP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2018 01:44:15 -0400
Received: by mail-yb0-f195.google.com with SMTP id c10-v6so2163484ybf.9
        for <linux-media@vger.kernel.org>; Thu, 02 Aug 2018 20:49:58 -0700 (PDT)
Received: from mail-yw1-f51.google.com (mail-yw1-f51.google.com. [209.85.161.51])
        by smtp.gmail.com with ESMTPSA id r3-v6sm1879605ywr.80.2018.08.02.20.49.57
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Aug 2018 20:49:57 -0700 (PDT)
Received: by mail-yw1-f51.google.com with SMTP id 139-v6so483510ywg.12
        for <linux-media@vger.kernel.org>; Thu, 02 Aug 2018 20:49:57 -0700 (PDT)
MIME-Version: 1.0
References: <1533265497-16718-1-git-send-email-ping-chung.chen@intel.com>
In-Reply-To: <1533265497-16718-1-git-send-email-ping-chung.chen@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 3 Aug 2018 12:49:44 +0900
Message-ID: <CAAFQd5BA+RuXWeOYuteG=GggGCg-ZJg04-mfy2AEGNPHrB=pQQ@mail.gmail.com>
Subject: Re: [RESEND PATCH v4] media: imx208: Add imx208 camera sensor driver
To: ping-chung.chen@intel.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Yeh, Andy" <andy.yeh@intel.com>, "Lai, Jim" <jim.lai@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Grant Grundler <grundler@chromium.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 3, 2018 at 11:57 AM Ping-chung Chen
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
> since v3:
> -- Set explicit indices to link frequencies.
>
[snip]
> +/* Menu items for LINK_FREQ V4L2 control */
> +static const s64 link_freq_menu_items[] = {
> +       [IMX208_LINK_FREQ_384MHZ_INDEX] = IMX208_LINK_FREQ_384MHZ,
> +       [IMX208_LINK_FREQ_384MHZ_INDEX] = IMX208_LINK_FREQ_96MHZ,

IMX208_LINK_FREQ_96MHZ_INDEX?

With this fixed (and if there are no other changes), feel free to add

Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Best regards,
Tomasz
