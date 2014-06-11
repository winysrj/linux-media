Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:57491 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbaFKH7V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jun 2014 03:59:21 -0400
Received: by mail-wi0-f171.google.com with SMTP id n15so4434235wiw.4
        for <linux-media@vger.kernel.org>; Wed, 11 Jun 2014 00:59:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1402468588-27792-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1401374448-30411-3-git-send-email-sakari.ailus@linux.intel.com> <1402468588-27792-1-git-send-email-sakari.ailus@linux.intel.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 11 Jun 2014 08:58:50 +0100
Message-ID: <CA+V-a8uHaPPS-7Cq+XwyDKBSsJaa6CpNpJZTV2dLeMqEp0UgHg@mail.gmail.com>
Subject: Re: [PATCH v3.1 2/4] smiapp: Add driver-specific test pattern menu
 item definitions
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 11, 2014 at 7:36 AM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> Add numeric definitions for menu items used in the smiapp driver's test
> pattern menu.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad

> ---
> since v3:
> - Add Kbuild entry for the header
>
>  include/uapi/linux/Kbuild   |  1 +
>  include/uapi/linux/smiapp.h | 29 +++++++++++++++++++++++++++++
>  2 files changed, 30 insertions(+)
>  create mode 100644 include/uapi/linux/smiapp.h
>
> diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
> index 6929571..a3ee163 100644
> --- a/include/uapi/linux/Kbuild
> +++ b/include/uapi/linux/Kbuild
> @@ -352,6 +352,7 @@ header-y += serio.h
>  header-y += shm.h
>  header-y += signal.h
>  header-y += signalfd.h
> +header-y += smiapp.h
>  header-y += snmp.h
>  header-y += sock_diag.h
>  header-y += socket.h
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
