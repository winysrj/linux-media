Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48279 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaFKLjG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jun 2014 07:39:06 -0400
Message-ID: <1402486744.4107.130.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 35/43] ARM: dts: imx6qdl: Add simple-bus to ipu
 compatibility
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Wed, 11 Jun 2014 13:39:04 +0200
In-Reply-To: <1402178205-22697-36-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
	 <1402178205-22697-36-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Samstag, den 07.06.2014, 14:56 -0700 schrieb Steve Longerbeam:
> The IPU can have child devices now, so add "simple-bus" to
> compatible list to ensure creation of the children.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  .../bindings/staging/imx-drm/fsl-imx-drm.txt       |    6 ++++--
>  arch/arm/boot/dts/imx6q.dtsi                       |    2 +-
>  arch/arm/boot/dts/imx6qdl.dtsi                     |    2 +-
>  3 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/staging/imx-drm/fsl-imx-drm.txt b/Documentation/devicetree/bindings/staging/imx-drm/fsl-imx-drm.txt
> index 3be5ce7..dc759e4 100644
> --- a/Documentation/devicetree/bindings/staging/imx-drm/fsl-imx-drm.txt
> +++ b/Documentation/devicetree/bindings/staging/imx-drm/fsl-imx-drm.txt
> @@ -21,7 +21,9 @@ Freescale i.MX IPUv3
>  ====================
>  
>  Required properties:
> -- compatible: Should be "fsl,<chip>-ipu"
> +- compatible: Should be "fsl,<chip>-ipu". The IPU can also have child
> +  devices, so also must include "simple-bus" to ensure creation of the
> +  children.

This would be ok if the submodules (CSI, SMFC, IC, DC, DP, etc.) were
listed as subnodes (which I don't think is a good idea). As it stands,
this is a misuse of simple-bus, as the IPU does not provide access to
the subdevices you are going to add through a simple MMIO mapping.

regards
Philipp

