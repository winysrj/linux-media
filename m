Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:46826 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbcBXGR1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2016 01:17:27 -0500
Date: Wed, 24 Feb 2016 15:17:24 +0900
From: Simon Horman <horms@verge.net.au>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] v4l2: remove MIPI CSI-2 driver for SH-Mobile platforms
Message-ID: <20160224061721.GK5435@verge.net.au>
References: <1456279679-11342-1-git-send-email-horms+renesas@verge.net.au>
 <2212155.BHpL65I02t@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2212155.BHpL65I02t@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 24, 2016 at 07:59:57AM +0200, Laurent Pinchart wrote:
> Hi Simon,
> 
> Thank you for the patch.
> 
> On Wednesday 24 February 2016 11:07:59 Simon Horman wrote:
> > This driver does not appear to have ever been used by any SoC's defconfig
> > and does not appear to support DT. In sort it seems unused an unlikely
> > to be used.
> > 
> > Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
> > ---
> >  drivers/media/platform/soc_camera/Kconfig          |   7 -
> >  drivers/media/platform/soc_camera/Makefile         |   1 -
> >  drivers/media/platform/soc_camera/sh_mobile_csi2.c | 400 ------------------
> 
> Shouldn't you also remove include/media/drv-intf/sh_mobile_csi2.h ? You would 
> then need to update drivers/media/platform/soc_camera/sh_mobile_ceu.c 
> accordingly, or remove it altogether.

Thanks.

sh_mobile_ceu appears to be used by several SH boards so I'd rather
not remove it, at least not for this reason.

So I'd prefer to look into updating sh_mobile_ceu.c and removing
sh_mobile_csi2.h.

> >  3 files changed, 408 deletions(-)
> >  delete mode 100644 drivers/media/platform/soc_camera/sh_mobile_csi2.c
> > 
> >  Based on the master branch of media_tree
> 
> -- 
> Regards,
> 
> Laurent Pinchart
