Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:60485 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752789AbeDXJ1x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 05:27:53 -0400
Subject: Re: [PATCH v3 7/7] dt-bindings: tda998x: add the calibration gpio
To: Russell King <rmk+kernel@armlinux.org.uk>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
References: <20180409121529.GA31403@n2100.armlinux.org.uk>
 <E1f5Vj1-0002Lx-Hz@rmk-PC.armlinux.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <201abf9a-74b0-f8db-0950-403f251b15d6@xs4all.nl>
Date: Tue, 24 Apr 2018 11:27:47 +0200
MIME-Version: 1.0
In-Reply-To: <E1f5Vj1-0002Lx-Hz@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/09/18 14:16, Russell King wrote:
> Add the optional calibration gpio for integrated TDA9950 CEC support.
> This GPIO corresponds with the interrupt from the TDA998x, as the
> calibration requires driving the interrupt pin low.
> 
> Reviewed-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  Documentation/devicetree/bindings/display/bridge/tda998x.txt | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/display/bridge/tda998x.txt b/Documentation/devicetree/bindings/display/bridge/tda998x.txt
> index 24cc2466185a..1a4eaca40d94 100644
> --- a/Documentation/devicetree/bindings/display/bridge/tda998x.txt
> +++ b/Documentation/devicetree/bindings/display/bridge/tda998x.txt
> @@ -27,6 +27,9 @@ Required properties;
>  	in question is used. The implementation allows one or two DAIs. If two
>  	DAIs are defined, they must be of different type.
>  
> +  - nxp,calib-gpios: calibration GPIO, which must correspond with the
> +	gpio used for the TDA998x interrupt pin.
> +
>  [1] Documentation/sound/alsa/soc/DAI.txt
>  [2] include/dt-bindings/display/tda998x.h
>  
> 
