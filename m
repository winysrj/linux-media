Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:32789 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754846AbdEHRNa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 May 2017 13:13:30 -0400
Date: Mon, 8 May 2017 12:13:27 -0500
From: Rob Herring <robh@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        pavel@ucw.cz, sebastian.reichel@collabora.co.uk
Subject: Re: [RFC v2 1/3] dt: bindings: Add a binding for flash devices
 associated to a sensor
Message-ID: <20170508171327.ow7p33566gt3lenp@rob-hp-laptop>
References: <1493974110-26510-1-git-send-email-sakari.ailus@linux.intel.com>
 <1493974110-26510-2-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1493974110-26510-2-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 05, 2017 at 11:48:28AM +0300, Sakari Ailus wrote:
> Camera flash drivers (and LEDs) are separate from the sensor devices in
> DT. In order to make an association between the two, provide the
> association information to the software.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
> ---
>  Documentation/devicetree/bindings/media/video-interfaces.txt | 11 +++++++++++
>  1 file changed, 11 insertions(+)

Acked-by: Rob Herring <robh@kernel.org>

> 
> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
> index 9cd2a36..dac764b 100644
> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> @@ -67,6 +67,17 @@ are required in a relevant parent node:
>  		    identifier, should be 1.
>   - #size-cells    : should be zero.
>  
> +
> +Optional properties
> +-------------------
> +
> +- flash: An array of phandles that refer to the flash light sources
> +  related to an image sensor. These could be e.g. LEDs. In case the LED
> +  driver (current sink or source chip for the LED(s)) drives more than a
> +  single LED, then the phandles here refer to the child nodes of the LED
> +  driver describing individual LEDs.
> +
> +
>  Optional endpoint properties
>  ----------------------------
>  
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
