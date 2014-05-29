Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41982 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932940AbaE2OsT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 May 2014 10:48:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH v3 2/3] smiapp: Add driver-specific test pattern menu item definitions
Date: Thu, 29 May 2014 16:48:40 +0200
Message-ID: <2661194.GTh768bpeF@avalon>
In-Reply-To: <1401374448-30411-3-git-send-email-sakari.ailus@linux.intel.com>
References: <1401374448-30411-1-git-send-email-sakari.ailus@linux.intel.com> <1401374448-30411-3-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 29 May 2014 17:40:47 Sakari Ailus wrote:
> Add numeric definitions for menu items used in the smiapp driver's test
> pattern menu.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  include/uapi/linux/smiapp.h | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>  create mode 100644 include/uapi/linux/smiapp.h
> 
> diff --git a/include/uapi/linux/smiapp.h b/include/uapi/linux/smiapp.h
> new file mode 100644
> index 0000000..53938f4
> --- /dev/null
> +++ b/include/uapi/linux/smiapp.h
> @@ -0,0 +1,29 @@
> +/*
> + * include/uapi/linux/smiapp.h
> + *
> + * Generic driver for SMIA/SMIA++ compliant camera modules
> + *
> + * Copyright (C) 2014 Intel Corporation
> + * Contact: Sakari Ailus <sakari.ailus@iki.fi>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + */
> +
> +#ifndef __UAPI_LINUX_SMIAPP_H_
> +#define __UAPI_LINUX_SMIAPP_H_
> +
> +#define V4L2_SMIAPP_TEST_PATTERN_MODE_DISABLED			0
> +#define V4L2_SMIAPP_TEST_PATTERN_MODE_SOLID_COLOUR		1
> +#define V4L2_SMIAPP_TEST_PATTERN_MODE_COLOUR_BARS		2
> +#define V4L2_SMIAPP_TEST_PATTERN_MODE_COLOUR_BARS_GREY		3
> +#define V4L2_SMIAPP_TEST_PATTERN_MODE_PN9			4

Out of curiosity, what's PN9 ?

> +
> +#endif /* __UAPI_LINUX_SMIAPP_H_ */

-- 
Regards,

Laurent Pinchart

