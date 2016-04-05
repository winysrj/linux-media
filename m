Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:57964 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbcDEU4r (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Apr 2016 16:56:47 -0400
Date: Tue, 5 Apr 2016 22:56:33 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Simon Horman <horms+renesas@verge.net.au>
cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v4 2/2] media: soc_camera: rcar_vin: add device tree
 support for r8a7792
In-Reply-To: <1458002427-3063-3-git-send-email-horms+renesas@verge.net.au>
Message-ID: <Pine.LNX.4.64.1604052255200.10633@axis700.grange>
References: <1458002427-3063-1-git-send-email-horms+renesas@verge.net.au>
 <1458002427-3063-3-git-send-email-horms+renesas@verge.net.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Simon,

On Tue, 15 Mar 2016, Simon Horman wrote:

> Simply document new compatibility string.
> As a previous patch adds a generic R-Car Gen2 compatibility string
> there appears to be no need for a driver updates.
> 
> By documenting this compat string it may be used in DTSs shipped, for
> example as part of ROMs. It must be used in conjunction with the Gen2
> fallback compat string. At this time there are no known differences between
> the r8a7792 IP block and that implemented by the driver for the Gen2
> fallback compat string. Thus there is no need to update the driver as the
> use of the Gen2 fallback compat string will activate the correct code in
> the current driver while leaving the option for r8a7792-specific driver
> code to be activated in an updated driver should the need arise.
> 
> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
> Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

Strictly speaking, I see an ack from Geert to patch 1/2, but I don't see 
one for this patch 2/2. Have I missed it or did Geert mean to ack the 
whole series and forgot to mention that?

Thanks
Guennadi

> ---
> v4
> * s/sting/string/ in changelog
> * Added Ack from Geert Uytterhoeven
> 
> v3
> * New patch
> ---
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> index 4266123888ed..6a4e61cbe011 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -9,6 +9,7 @@ channel which can be either RGB, YUYV or BT656.
>     - "renesas,vin-r8a7795" for the R8A7795 device
>     - "renesas,vin-r8a7794" for the R8A7794 device
>     - "renesas,vin-r8a7793" for the R8A7793 device
> +   - "renesas,vin-r8a7792" for the R8A7792 device
>     - "renesas,vin-r8a7791" for the R8A7791 device
>     - "renesas,vin-r8a7790" for the R8A7790 device
>     - "renesas,vin-r8a7779" for the R8A7779 device
> -- 
> 2.1.4
> 
