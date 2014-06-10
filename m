Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3203 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaFJMRK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jun 2014 08:17:10 -0400
Message-ID: <5396F704.3070701@xs4all.nl>
Date: Tue, 10 Jun 2014 14:16:04 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
CC: laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v3 2/3] smiapp: Add driver-specific test pattern menu
 item definitions
References: <1401374448-30411-1-git-send-email-sakari.ailus@linux.intel.com> <1401374448-30411-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1401374448-30411-3-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/29/14 16:40, Sakari Ailus wrote:
> Add numeric definitions for menu items used in the smiapp driver's test
> pattern menu.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

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
> +
> +#endif /* __UAPI_LINUX_SMIAPP_H_ */
> 

