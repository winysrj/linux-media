Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:37187 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbeGLMfn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Jul 2018 08:35:43 -0400
Received: by mail-wm0-f65.google.com with SMTP id n17-v6so5859333wmh.2
        for <linux-media@vger.kernel.org>; Thu, 12 Jul 2018 05:26:22 -0700 (PDT)
Date: Thu, 12 Jul 2018 13:26:18 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Neil Armstrong <narmstrong@baylibre.com>
Cc: airlied@linux.ie, hans.verkuil@cisco.com, olof@lixom.net,
        seanpaul@google.com, sadolfsson@google.com, felixe@google.com,
        bleung@google.com, darekm@google.com, marcheu@chromium.org,
        fparent@baylibre.com, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, eballetbo@gmail.com,
        Stefan Adolfsson <sadolfsson@chromium.org>
Subject: Re: [PATCH v8 3/6] mfd: cros-ec: Increase maximum mkbp event size
Message-ID: <20180712122618.GD4641@dell>
References: <1530716901-30164-1-git-send-email-narmstrong@baylibre.com>
 <1530716901-30164-4-git-send-email-narmstrong@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1530716901-30164-4-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 04 Jul 2018, Neil Armstrong wrote:

> Having a 16 byte mkbp event size makes it possible to send CEC
> messages from the EC to the AP directly inside the mkbp event
> instead of first doing a notification and then a read.
> 
> Signed-off-by: Stefan Adolfsson <sadolfsson@chromium.org>
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> Tested-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/platform/chrome/cros_ec_proto.c | 40 +++++++++++++++++++++++++--------
>  include/linux/mfd/cros_ec.h             |  2 +-
>  include/linux/mfd/cros_ec_commands.h    | 16 +++++++++++++
>  3 files changed, 48 insertions(+), 10 deletions(-)

For my own reference:
  Acked-for-MFD-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
