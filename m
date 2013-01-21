Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3022 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab3AUJCI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jan 2013 04:02:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH 1/3] [media] Add header file defining standard image sizes
Date: Mon, 21 Jan 2013 10:01:55 +0100
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
References: <1358630842-12689-1-git-send-email-sylvester.nawrocki@gmail.com> <1358630842-12689-2-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1358630842-12689-2-git-send-email-sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301211001.55354.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat January 19 2013 22:27:20 Sylwester Nawrocki wrote:
> Add common header file defining standard image sizes, so we can
> avoid redefining those in each driver.
> 
> Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
> ---
>  include/media/image-sizes.h |   34 ++++++++++++++++++++++++++++++++++

Since this is a v4l2 core header it should be renamed with a 'v4l2-' prefix.

Regards,

	Hans

>  1 files changed, 34 insertions(+), 0 deletions(-)
>  create mode 100644 include/media/image-sizes.h
> 
> diff --git a/include/media/image-sizes.h b/include/media/image-sizes.h
> new file mode 100644
> index 0000000..10daf92
> --- /dev/null
> +++ b/include/media/image-sizes.h
> @@ -0,0 +1,34 @@
> +/*
> + * Standard image size definitions
> + *
> + * Copyright (C) 2013, Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef _IMAGE_SIZES_H
> +#define _IMAGE_SIZES_H
> +
> +#define CIF_WIDTH	352
> +#define CIF_HEIGHT	288
> +
> +#define QCIF_WIDTH	176
> +#define QCIF_HEIGHT	144
> +
> +#define QQCIF_WIDTH	88
> +#define QQCIF_HEIGHT	72
> +
> +#define QQVGA_WIDTH	160
> +#define QQVGA_HEIGHT	120
> +
> +#define QVGA_WIDTH	320
> +#define QVGA_HEIGHT	240
> +
> +#define SXGA_WIDTH	1280
> +#define SXGA_HEIGHT	1024
> +
> +#define VGA_WIDTH	640
> +#define VGA_HEIGHT	480
> +
> +#endif /* _IMAGE_SIZES_H */
> 
