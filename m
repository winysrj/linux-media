Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:50946 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab2AWJ4P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 04:56:15 -0500
Date: Mon, 23 Jan 2012 10:56:09 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Axel Lin <axel.lin@gmail.com>
cc: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Heungjun Kim <riverful.kim@samsung.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Joonyoung Shim <jy0922.shim@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Andrew Chew <achew@nvidia.com>,
	Paul Mundt <lethal@linux-sh.org>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Johannes Obermaier <johannes.obermaier@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Steven Toth <stoth@kernellabs.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] convert drivers/media/* to use module_i2c_driver()
In-Reply-To: <1327140645.3928.1.camel@phoenix>
Message-ID: <Pine.LNX.4.64.1201231047330.11184@axis700.grange>
References: <1327140645.3928.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 21 Jan 2012, Axel Lin wrote:

> This patch converts the drivers in drivers/media/* to use the
> module_i2_driver() macro which makes the code smaller and a bit simpler.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Heungjun Kim <riverful.kim@samsung.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Joonyoung Shim <jy0922.shim@samsung.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Andrew Chew <achew@nvidia.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
> Cc: Johannes Obermaier <johannes.obermaier@gmail.com>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Steven Toth <stoth@kernellabs.com>
> ---

>  drivers/media/video/ak881x.c                  |   13 +----------
>  drivers/media/video/imx074.c                  |   13 +----------
>  drivers/media/video/mt9m001.c                 |   13 +----------
>  drivers/media/video/mt9m111.c                 |   13 +----------
>  drivers/media/video/mt9t031.c                 |   13 +----------
>  drivers/media/video/mt9t112.c                 |   16 +-------------
>  drivers/media/video/mt9v022.c                 |   13 +----------
>  drivers/media/video/ov2640.c                  |   16 +-------------
>  drivers/media/video/ov5642.c                  |   13 +----------
>  drivers/media/video/ov6650.c                  |   13 +----------
>  drivers/media/video/ov772x.c                  |   17 +--------------
>  drivers/media/video/ov9640.c                  |   13 +----------
>  drivers/media/video/ov9740.c                  |   13 +----------
>  drivers/media/video/rj54n1cb0c.c              |   13 +----------
>  drivers/media/video/tw9910.c                  |   16 +-------------

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
