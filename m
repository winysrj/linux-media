Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:35062 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313Ab2GNRNg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jul 2012 13:13:36 -0400
Date: Sat, 14 Jul 2012 11:14:05 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Albert Wang <twang13@marvell.com>
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/7] media: mmp_camera: Add V4l2 camera driver for
 Marvell PXA910/PXA688/PXA2128 CCIC
Message-ID: <20120714111405.09164acc@tpl.lwn.net>
In-Reply-To: <1342016549-23084-1-git-send-email-twang13@marvell.com>
References: <1342016549-23084-1-git-send-email-twang13@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 11 Jul 2012 22:22:29 +0800
Albert Wang <twang13@marvell.com> wrote:

> This v4l2 camera driver is based on soc-camera and videobuf2 framework
> Support Marvell MMP Soc family TD-PXA910/MMP2-PXA688/MMP3-PXA2128 CCIC
> Support Dual CCIC controllers on PXA688/PXA2128
> Support MIPI-CSI2 mode and DVP-Parallel mode

This is going to be really quick.  Life is difficult here, I don't really
have much time to put into anything.

>  arch/arm/mach-mmp/include/mach/camera.h    |   21 +

I don't think that this file belongs here; it should be in the driver
tree.  This camera may not always be tied to this platform; indeed, the
original Cafe was not.  There will never be a 64-bit SoC with some variant
of this device?

>  
> +config VIDEO_MMP
> +	tristate "Marvell MMP CCIC driver based on SOC_CAMERA"
> +	depends on VIDEO_DEV && SOC_CAMERA
> +	select VIDEOBUF2_DMA_CONTIG
> +	---help---
> +	  This is a v4l2 driver for the Marvell PXA910/PXA688/PXA2128 CCIC
> +	  To compile this driver as a module, choose M here: the module will
> +	  be called mmp_camera.

But...the existing driver already builds as mmp_camera.  Even if we
eventually agree that this separate driver should go into the mainline, it
really needs to not build into a module with the same name.

> +/*
> + * V4L2 Driver for Marvell Mobile SoC PXA910/PXA688/PXA2128 CCIC
> + * (CMOS Camera Interface Controller)
> + *
> + * This driver is based on soc_camera and videobuf2 framework,
> + * but part of the low level register function is base on cafe-driver.c
> + *
> + * Copyright 2006 One Laptop Per Child Association, Inc.
> + * Copyright 2006-7 Jonathan Corbet <corbet@lwn.net>

Nit: some of the code clearly comes from marvell-ccic/mcam-core.c, so the
copyright dates (if they really need to be kept) should stretch into 2011
or so.

I don't see anything else obvious, but it was a very quick reading, sorry.

jon
