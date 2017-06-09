Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:35340 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751591AbdFIOHV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Jun 2017 10:07:21 -0400
Date: Fri, 9 Jun 2017 09:07:19 -0500
From: Rob Herring <robh@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 7/9] dt-bindings: media/s5p-cec.txt: document needs-hpd
 property
Message-ID: <20170609140719.o2qzty6eyez66oxy@rob-hp-laptop>
References: <20170607144616.15247-1-hverkuil@xs4all.nl>
 <20170607144616.15247-8-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170607144616.15247-8-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 07, 2017 at 04:46:14PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Needed for boards that wire the CEC pin in such a way that it
> is unavailable when the HPD is low.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Krzysztof Kozlowski <krzk@kernel.org>
> Cc: Andrzej Hajda <a.hajda@samsung.com>
> Cc: devicetree@vger.kernel.org
> ---
>  Documentation/devicetree/bindings/media/s5p-cec.txt | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/s5p-cec.txt b/Documentation/devicetree/bindings/media/s5p-cec.txt
> index 4bb08d9d940b..261af4d1a791 100644
> --- a/Documentation/devicetree/bindings/media/s5p-cec.txt
> +++ b/Documentation/devicetree/bindings/media/s5p-cec.txt
> @@ -17,6 +17,12 @@ Required properties:
>    - samsung,syscon-phandle - phandle to the PMU system controller
>    - hdmi-phandle - phandle to the HDMI controller
>  
> +Optional:
> +  - needs-hpd : if present the CEC support is only available when the HPD
> +    is high. Some boards only let the CEC pin through if the HPD is high, for
> +    example if there is a level converter that uses the HPD to power up
> +    or down.

Seems like something common. Can you document in a common location?

> +
>  Example:
>  
>  hdmicec: cec@100B0000 {
> -- 
> 2.11.0
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
