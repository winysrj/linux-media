Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33819 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936349AbcCQQnj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Mar 2016 12:43:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Simon Horman <horms+renesas@verge.net.au>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v4 0/2] media: soc_camera: rcar_vin: add fallback and r8a7792 bindings
Date: Thu, 17 Mar 2016 13:08:38 +0200
Message-ID: <4368165.sSKIRcCx2U@avalon>
In-Reply-To: <1458002427-3063-1-git-send-email-horms+renesas@verge.net.au>
References: <1458002427-3063-1-git-send-email-horms+renesas@verge.net.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Simon,

Thank you for the patches.

For the whole series,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

On Tuesday 15 March 2016 09:40:25 Simon Horman wrote:
> Hi,
> 
> this short series adds add fallback and r8a7792 bindings to rcar_vin.
> 
> Based on media-tree/master
> 
> Changes since v3:
> * Add Acks
> * Correct typo in changelog
> 
> Simon Horman (1):
>   media: soc_camera: rcar_vin: add device tree support for r8a7792
> 
> Yoshihiro Kaneko (1):
>   media: soc_camera: rcar_vin: add R-Car Gen 2 and 3 fallback
>     compatibility strings
> 
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 12 ++++++++++--
>  drivers/media/platform/soc_camera/rcar_vin.c         |  2 ++
>  2 files changed, 12 insertions(+), 2 deletions(-)

-- 
Regards,

Laurent Pinchart

