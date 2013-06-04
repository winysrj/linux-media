Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:47914 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759219Ab3FDBIN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 21:08:13 -0400
Date: Tue, 4 Jun 2013 10:08:11 +0900
From: Simon Horman <horms@verge.net.au>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: g.liakhovetski@gmx.de, mchehab@redhat.com,
	linux-media@vger.kernel.org, magnus.damm@gmail.com,
	linux-sh@vger.kernel.org, phil.edworthy@renesas.com,
	matsu@igel.co.jp, vladimir.barinov@cogentembedded.com
Subject: Re: [PATCH v6] V4L2: soc_camera: Renesas R-Car VIN driver
Message-ID: <20130604010811.GB23054@verge.net.au>
References: <201305240211.29665.sergei.shtylyov@cogentembedded.com>
 <51AB9556.2080900@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AB9556.2080900@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 02, 2013 at 10:56:22PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 05/24/2013 02:11 AM, Sergei Shtylyov wrote:
> 
> >From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> >
> >Add Renesas R-Car VIN (Video In) V4L2 driver.
> >
> >Based on the patch by Phil Edworthy <phil.edworthy@renesas.com>.
> >
> >Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> >[Sergei: removed deprecated IRQF_DISABLED flag, reordered/renamed 'enum chip_id'
> >values, reordered rcar_vin_id_table[] entries,  removed senseless parens from
> >to_buf_list() macro, used ALIGN() macro in rcar_vin_setup(), added {} to the
> >*if* statement  and  used 'bool' values instead of 0/1 where necessary, removed
> >unused macros, done some reformatting and clarified some comments.]
> >Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> >
> >---
> >This patch is against the 'media_tree.git' repo.
> >It requires two following patches from Guennadi Liakhovetski:
> >
> >https://patchwork.linuxtv.org/patch/18209/
> >https://patchwork.linuxtv.org/patch/18210/
> >
> 
> [...]
> >Index: media_tree/include/linux/platform_data/camera-rcar.h
> >===================================================================
> >--- /dev/null
> >+++ media_tree/include/linux/platform_data/camera-rcar.h
> >@@ -0,0 +1,25 @@
> >+/*
> >+ * Platform data for Renesas R-Car VIN soc-camera driver
> >+ *
> >+ * Copyright (C) 2011-2013 Renesas Solutions Corp.
> >+ * Copyright (C) 2013 Cogent Embedded, Inc., <source@cogentembedded.com>
> >+ *
> >+ * This program is free software; you can redistribute  it and/or modify it
> >+ * under  the terms of  the GNU General  Public License as published by the
> >+ * Free Software Foundation;  either version 2 of the  License, or (at your
> >+ * option) any later version.
> >+ */
> >+
> >+#ifndef __CAMERA_RCAR_H_
> >+#define __CAMERA_RCAR_H_
> >+
> >+#define RCAR_VIN_HSYNC_ACTIVE_LOW	(1 << 0)
> >+#define RCAR_VIN_VSYNC_ACTIVE_LOW	(1 << 1)
> >+#define RCAR_VIN_BT601			(1 << 2)
> >+#define RCAR_VIN_BT656			(1 << 3)
> >+
> >+struct rcar_vin_platform_data {
> >+	unsigned int flags;
> >+};
> >+
> >+#endif /* __CAMERA_RCAR_H_ */
> 
>    I wonder how to deal with a cross tree dependency caused by this file.
> Perhaps the VIN platform code could be merged thru the media tree (or
> maybe vice versa, all patches merged thru the Renesas tree)?

I am comfortable with either option with a slight preference for
taking the changes through the media tree.
