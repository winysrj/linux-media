Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:56570 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760348Ab3DBOyk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Apr 2013 10:54:40 -0400
Date: Tue, 2 Apr 2013 16:54:37 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com
Subject: Re: [PATCH] V4L: Remove incorrect EXPORT_SYMBOL() usage at v4l2-of.c
In-Reply-To: <1364913818-7970-1-git-send-email-s.nawrocki@samsung.com>
Message-ID: <Pine.LNX.4.64.1304021652021.31999@axis700.grange>
References: <1364913818-7970-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester

On Tue, 2 Apr 2013, Sylwester Nawrocki wrote:

> v4l2_of_parse_parallel_bus() function is now static and
> EXPORT_SYMBOL() doesn't apply to it any more. Drop this
> meaningless statement, which was supposed to be done in
> the original merged patch.
> 
> While at it, edit the copyright notice so it is sorted in
> both the v4l2-of.c and v4l2-of.h file in newest entries
> on top order, and state clearly I'm just the author of
> parts of the code, not the copyright owner.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

This is not concerning the contents of this patch, but rather the form 
confuses me a bit - the two above Sob's: you are the author, and you're 
sending the patch to the list, but Kyungmin Park's Sob is the last in the 
list, which to me means that your patch went via his tree, but it's you 
who's sending it?... I think I saw this pattern in some other your patches 
too. What exactly does this mean?

Thanks
Guennadi

> ---
>  drivers/media/v4l2-core/v4l2-of.c |    3 +--
>  include/media/v4l2-of.h           |    6 +++---
>  2 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
> index e38e210..aa59639 100644
> --- a/drivers/media/v4l2-core/v4l2-of.c
> +++ b/drivers/media/v4l2-core/v4l2-of.c
> @@ -2,7 +2,7 @@
>   * V4L2 OF binding parsing library
>   *
>   * Copyright (C) 2012 - 2013 Samsung Electronics Co., Ltd.
> - * Sylwester Nawrocki <s.nawrocki@samsung.com>
> + * Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
>   *
>   * Copyright (C) 2012 Renesas Electronics Corp.
>   * Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> @@ -103,7 +103,6 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
>  	bus->flags = flags;
>  
>  }
> -EXPORT_SYMBOL(v4l2_of_parse_parallel_bus);
>  
>  /**
>   * v4l2_of_parse_endpoint() - parse all endpoint node properties
> diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
> index 00f9147..3a8a841 100644
> --- a/include/media/v4l2-of.h
> +++ b/include/media/v4l2-of.h
> @@ -1,12 +1,12 @@
>  /*
>   * V4L2 OF binding parsing library
>   *
> + * Copyright (C) 2012 - 2013 Samsung Electronics Co., Ltd.
> + * Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
> + *
>   * Copyright (C) 2012 Renesas Electronics Corp.
>   * Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>   *
> - * Copyright (C) 2012 - 2013 Samsung Electronics Co., Ltd.
> - * Sylwester Nawrocki <s.nawrocki@samsung.com>
> - *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of version 2 of the GNU General Public License as
>   * published by the Free Software Foundation.
> -- 
> 1.7.9.5
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
