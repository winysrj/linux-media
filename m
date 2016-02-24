Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37508 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbcBXGAC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2016 01:00:02 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Simon Horman <horms+renesas@verge.net.au>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] v4l2: remove MIPI CSI-2 driver for SH-Mobile platforms
Date: Wed, 24 Feb 2016 07:59:57 +0200
Message-ID: <2212155.BHpL65I02t@avalon>
In-Reply-To: <1456279679-11342-1-git-send-email-horms+renesas@verge.net.au>
References: <1456279679-11342-1-git-send-email-horms+renesas@verge.net.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Simon,

Thank you for the patch.

On Wednesday 24 February 2016 11:07:59 Simon Horman wrote:
> This driver does not appear to have ever been used by any SoC's defconfig
> and does not appear to support DT. In sort it seems unused an unlikely
> to be used.
> 
> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
> ---
>  drivers/media/platform/soc_camera/Kconfig          |   7 -
>  drivers/media/platform/soc_camera/Makefile         |   1 -
>  drivers/media/platform/soc_camera/sh_mobile_csi2.c | 400 ------------------

Shouldn't you also remove include/media/drv-intf/sh_mobile_csi2.h ? You would 
then need to update drivers/media/platform/soc_camera/sh_mobile_ceu.c 
accordingly, or remove it altogether.

>  3 files changed, 408 deletions(-)
>  delete mode 100644 drivers/media/platform/soc_camera/sh_mobile_csi2.c
> 
>  Based on the master branch of media_tree

-- 
Regards,

Laurent Pinchart

