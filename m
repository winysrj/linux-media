Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:61028 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab3ABL6k (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 06:58:40 -0500
Date: Wed, 2 Jan 2013 12:58:37 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
cc: linux-media@vger.kernel.org, grant.likely@secretlab.ca,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH RFC v2 02/15] [media] Add a V4L2 OF parser
In-Reply-To: <1356969793-27268-3-git-send-email-s.nawrocki@samsung.com>
Message-ID: <Pine.LNX.4.64.1301021255380.7829@axis700.grange>
References: <1356969793-27268-1-git-send-email-s.nawrocki@samsung.com>
 <1356969793-27268-3-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester

Just one question to this one:

On Mon, 31 Dec 2012, Sylwester Nawrocki wrote:

> diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
> new file mode 100644
> index 0000000..cdac04b
> --- /dev/null
> +++ b/drivers/media/v4l2-core/v4l2-of.c
> @@ -0,0 +1,249 @@
> +/*
> + * V4L2 OF binding parsing library
> + *
> + * Copyright (C) 2012 Renesas Electronics Corp.
> + * Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of version 2 of the GNU General Public License as
> + * published by the Free Software Foundation.
> + */
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/slab.h>

Is slab.h really needed? I didn't have it in my version. Maybe you meant 
to include string.h for memset()?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
