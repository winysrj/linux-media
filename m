Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:34488 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752193AbdFLMvS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 08:51:18 -0400
Received: by mail-qt0-f170.google.com with SMTP id c10so123916243qtd.1
        for <linux-media@vger.kernel.org>; Mon, 12 Jun 2017 05:51:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170609175401.40204-3-hverkuil@xs4all.nl>
References: <20170609175401.40204-1-hverkuil@xs4all.nl> <20170609175401.40204-3-hverkuil@xs4all.nl>
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Date: Mon, 12 Jun 2017 14:51:17 +0200
Message-ID: <CA+M3ks74U-y7mdoW+khh8537+Ttz=ViiE0LyanwZzQV49s-TGg@mail.gmail.com>
Subject: Re: [PATCH 2/2] dt-bindings: media/s5p-cec.txt, media/stih-cec.txt:
 refer to cec.txt
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-06-09 19:54 GMT+02:00 Hans Verkuil <hverkuil@xs4all.nl>:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Now that there is a cec.txt with common CEC bindings, update the two
> driver-specific bindings to refer to cec.txt.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Krzysztof Kozlowski <krzk@kernel.org>
> Cc: Andrzej Hajda <a.hajda@samsung.com>
> Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
> Cc: devicetree@vger.kernel.org
> ---
>  Documentation/devicetree/bindings/media/s5p-cec.txt  | 6 ++----
>  Documentation/devicetree/bindings/media/stih-cec.txt | 2 +-
>  2 files changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/media/s5p-cec.txt b/Documentation/devicetree/bindings/media/s5p-cec.txt
> index 261af4d1a791..1b1a10ba48ce 100644
> --- a/Documentation/devicetree/bindings/media/s5p-cec.txt
> +++ b/Documentation/devicetree/bindings/media/s5p-cec.txt
> @@ -15,13 +15,11 @@ Required properties:
>    - clock-names : from common clock binding: must contain "hdmicec",
>                   corresponding to entry in the clocks property.
>    - samsung,syscon-phandle - phandle to the PMU system controller
> -  - hdmi-phandle - phandle to the HDMI controller
> +  - hdmi-phandle - phandle to the HDMI controller, see also cec.txt.
>
>  Optional:
>    - needs-hpd : if present the CEC support is only available when the HPD
> -    is high. Some boards only let the CEC pin through if the HPD is high, for
> -    example if there is a level converter that uses the HPD to power up
> -    or down.
> +               is high. See cec.txt for more details.
>
>  Example:
>
> diff --git a/Documentation/devicetree/bindings/media/stih-cec.txt b/Documentation/devicetree/bindings/media/stih-cec.txt
> index 289a08b33651..8be2a040c6c6 100644
> --- a/Documentation/devicetree/bindings/media/stih-cec.txt
> +++ b/Documentation/devicetree/bindings/media/stih-cec.txt
> @@ -9,7 +9,7 @@ Required properties:
>   - pinctrl-names: Contains only one value - "default"
>   - pinctrl-0: Specifies the pin control groups used for CEC hardware.
>   - resets: Reference to a reset controller
> - - hdmi-phandle: Phandle to the HDMI controller
> + - hdmi-phandle: Phandle to the HDMI controller, see also cec.txt.
>
>  Example for STIH407:
>
> --
> 2.11.0
>

Acked-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
