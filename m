Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34841 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753003AbeGDNMr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 09:12:47 -0400
Received: by mail-wm0-f65.google.com with SMTP id v3-v6so2081209wmh.0
        for <linux-media@vger.kernel.org>; Wed, 04 Jul 2018 06:12:46 -0700 (PDT)
Date: Wed, 4 Jul 2018 14:12:42 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Neil Armstrong <narmstrong@baylibre.com>
Cc: airlied@linux.ie, hans.verkuil@cisco.com, olof@lixom.net,
        seanpaul@google.com, sadolfsson@google.com, felixe@google.com,
        bleung@google.com, darekm@google.com, marcheu@chromium.org,
        fparent@baylibre.com, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, eballetbo@gmail.com
Subject: Re: [PATCH v7 5/6] mfd: cros_ec_dev: Add CEC sub-device registration
Message-ID: <20180704131242.GF496@dell>
References: <1527841154-24832-1-git-send-email-narmstrong@baylibre.com>
 <1527841154-24832-6-git-send-email-narmstrong@baylibre.com>
 <20180704074717.GP20176@dell>
 <eef093a4-55ea-fb59-97ee-408abeccc080@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eef093a4-55ea-fb59-97ee-408abeccc080@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 04 Jul 2018, Neil Armstrong wrote:

> Hi Lee,
> 
> On 04/07/2018 09:47, Lee Jones wrote:
> > On Fri, 01 Jun 2018, Neil Armstrong wrote:
> > 
> >> The EC can expose a CEC bus, thus add the cros-ec-cec MFD sub-device
> >> when the CEC feature bit is present.
> >>
> >> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> >> Reviewed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> >> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >>  drivers/mfd/cros_ec_dev.c | 16 ++++++++++++++++
> >>  1 file changed, 16 insertions(+)
> > 
> > For my own reference:
> >   Acked-for-MFD-by: Lee Jones <lee.jones@linaro.org>
> > 
> 
> Should I keep these Acked-for-MFD-by for the v8 ?

Yes please.

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
