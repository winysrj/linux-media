Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:63199 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751494AbdFLM7W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 08:59:22 -0400
Subject: Re: [PATCH 1/2] dt-bindings: add media/cec.txt
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <a76d4eca-c9fa-a61c-dddf-435ff49af365@samsung.com>
Date: Mon, 12 Jun 2017 14:59:08 +0200
MIME-version: 1.0
In-reply-to: <20170609175401.40204-2-hverkuil@xs4all.nl>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <20170609175401.40204-1-hverkuil@xs4all.nl>
        <20170609175401.40204-2-hverkuil@xs4all.nl>
        <CGME20170612125919epcas1p312a7ecbffd99e025a26ba8d4444f1a5b@epcas1p3.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/09/2017 07:54 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Document common HDMI CEC bindings. Add this to the MAINTAINERS file
> as well.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

> ---
>   Documentation/devicetree/bindings/media/cec.txt | 8 ++++++++
>   MAINTAINERS                                     | 1 +
>   2 files changed, 9 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/media/cec.txt
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

For a common property I would rather make it "hdmi-controller", this
"-phandle" part feels like appending "_pointer" to variable names in C code.
But since you are just rearranging existing documentation and Rob agrees with
that I have no objections.

> +- needs-hpd: if present the CEC support is only available when the HPD
> +  is high. Some boards only let the CEC pin through if the HPD is high,
> +  for example if there is a level converter that uses the HPD to power
> +  up or down.
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 053c3bdd1fe5..4ac340d189a3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3137,6 +3137,7 @@ F:	include/media/cec.h
>   F:	include/media/cec-notifier.h
>   F:	include/uapi/linux/cec.h
>   F:	include/uapi/linux/cec-funcs.h
> +F:	Documentation/devicetree/bindings/media/cec.txt
>   
>   CELL BROADBAND ENGINE ARCHITECTURE
>   M:	Arnd Bergmann <arnd@arndb.de
--
Regards,
Sylwester
