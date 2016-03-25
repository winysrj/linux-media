Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:47924 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbcCYCUy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 22:20:54 -0400
Date: Fri, 25 Mar 2016 11:20:49 +0900
From: Simon Horman <horms@verge.net.au>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v4 0/2] media: soc_camera: rcar_vin: add fallback and
 r8a7792 bindings
Message-ID: <20160325022049.GE31681@verge.net.au>
References: <1458002427-3063-1-git-send-email-horms+renesas@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1458002427-3063-1-git-send-email-horms+renesas@verge.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 15, 2016 at 09:40:25AM +0900, Simon Horman wrote:
> Hi,
> 
> this short series adds add fallback and r8a7792 bindings to rcar_vin.
> 
> Based on media-tree/master

Hi Guennadi,

I am wondering if you could consider applying this series too.
It still applies cleanly on top of media-tree/master.

Thanks in advance!

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
> 
> -- 
> 2.1.4
> 
