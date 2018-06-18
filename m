Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35082 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754985AbeFRHpY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 03:45:24 -0400
Received: by mail-wr0-f195.google.com with SMTP id l10-v6so15700018wrn.2
        for <linux-media@vger.kernel.org>; Mon, 18 Jun 2018 00:45:24 -0700 (PDT)
Date: Mon, 18 Jun 2018 08:45:20 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Neil Armstrong <narmstrong@baylibre.com>
Cc: airlied@linux.ie, hans.verkuil@cisco.com, olof@lixom.net,
        seanpaul@google.com, sadolfsson@google.com, felixe@google.com,
        bleung@google.com, darekm@google.com, marcheu@chromium.org,
        fparent@baylibre.com, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, eballetbo@gmail.com
Subject: Re: [PATCH v7 4/6] mfd: cros-ec: Introduce CEC commands and events
 definitions.
Message-ID: <20180618074520.GL31141@dell>
References: <1527841154-24832-1-git-send-email-narmstrong@baylibre.com>
 <1527841154-24832-5-git-send-email-narmstrong@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1527841154-24832-5-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 01 Jun 2018, Neil Armstrong wrote:

> The EC can expose a CEC bus, this patch adds the CEC related definitions
> needed by the cros-ec-cec driver.
> 
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> Tested-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  include/linux/mfd/cros_ec_commands.h | 81 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 81 insertions(+)

For my own reference:
  Acked-for-MFD-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
