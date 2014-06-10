Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:36670 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaFJP5j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jun 2014 11:57:39 -0400
Received: by mail-we0-f171.google.com with SMTP id q58so4046455wes.2
        for <linux-media@vger.kernel.org>; Tue, 10 Jun 2014 08:57:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1401374448-30411-3-git-send-email-sakari.ailus@linux.intel.com>
References: <1401374448-30411-1-git-send-email-sakari.ailus@linux.intel.com> <1401374448-30411-3-git-send-email-sakari.ailus@linux.intel.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 10 Jun 2014 16:57:07 +0100
Message-ID: <CA+V-a8vUrB3nUxfiZgjkjpQZh-r8z-mavPesJ4-fPhC=AaExKw@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] smiapp: Add driver-specific test pattern menu item definitions
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thu, May 29, 2014 at 3:40 PM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> Add numeric definitions for menu items used in the smiapp driver's test
> pattern menu.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  include/uapi/linux/smiapp.h | 29 +++++++++++++++++++++++++++++

Don't you need to add an entry in Kbuild file for this ?

Regards,
--Prabhakar Lad

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
> +#define V4L2_SMIAPP_TEST_PATTERN_MODE_DISABLED                 0
> +#define V4L2_SMIAPP_TEST_PATTERN_MODE_SOLID_COLOUR             1
> +#define V4L2_SMIAPP_TEST_PATTERN_MODE_COLOUR_BARS              2
> +#define V4L2_SMIAPP_TEST_PATTERN_MODE_COLOUR_BARS_GREY         3
> +#define V4L2_SMIAPP_TEST_PATTERN_MODE_PN9                      4
> +
> +#endif /* __UAPI_LINUX_SMIAPP_H_ */
> --
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
