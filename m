Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:35550 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752102AbdFLMux (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 08:50:53 -0400
Received: by mail-qt0-f170.google.com with SMTP id w1so123621782qtg.2
        for <linux-media@vger.kernel.org>; Mon, 12 Jun 2017 05:50:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170609175401.40204-2-hverkuil@xs4all.nl>
References: <20170609175401.40204-1-hverkuil@xs4all.nl> <20170609175401.40204-2-hverkuil@xs4all.nl>
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Date: Mon, 12 Jun 2017 14:50:51 +0200
Message-ID: <CA+M3ks7SbgyvWCKbkJD2T9gdyhbKQ9PGyp9jY1M0sbuuNDtXLQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: add media/cec.txt
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
> Document common HDMI CEC bindings. Add this to the MAINTAINERS file
> as well.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Krzysztof Kozlowski <krzk@kernel.org>
> Cc: Andrzej Hajda <a.hajda@samsung.com>
> Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
> Cc: devicetree@vger.kernel.org
> ---
>  Documentation/devicetree/bindings/media/cec.txt | 8 ++++++++
>  MAINTAINERS                                     | 1 +
>  2 files changed, 9 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/cec.txt
>
> diff --git a/Documentation/devicetree/bindings/media/cec.txt b/Documentation/devicetree/bindings/media/cec.txt
> new file mode 100644
> index 000000000000..22d7aae3d3d7
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/cec.txt
> @@ -0,0 +1,8 @@
> +Common bindings for HDMI CEC adapters
> +
> +- hdmi-phandle: phandle to the HDMI controller.
> +
> +- needs-hpd: if present the CEC support is only available when the HPD
> +  is high. Some boards only let the CEC pin through if the HPD is high,
> +  for example if there is a level converter that uses the HPD to power
> +  up or down.
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 053c3bdd1fe5..4ac340d189a3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3137,6 +3137,7 @@ F:        include/media/cec.h
>  F:     include/media/cec-notifier.h
>  F:     include/uapi/linux/cec.h
>  F:     include/uapi/linux/cec-funcs.h
> +F:     Documentation/devicetree/bindings/media/cec.txt
>
>  CELL BROADBAND ENGINE ARCHITECTURE
>  M:     Arnd Bergmann <arnd@arndb.de>
> --
> 2.11.0
>

Looks good for me

Acked-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
