Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:53270 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751319AbeBGWgI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Feb 2018 17:36:08 -0500
Date: Thu, 8 Feb 2018 00:36:05 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, jian.xu.zheng@intel.com,
        rajmohan.mani@intel.com
Subject: Re: [PATCH] media: intel-ipu3: cio2: Use SPDX license headers
Message-ID: <20180207223605.jhun55osbpxmnzpz@kekkonen.localdomain>
References: <1517890793-9360-1-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1517890793-9360-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

Thanks for the patch.

On Mon, Feb 05, 2018 at 08:19:53PM -0800, Yong Zhi wrote:
> Adopt SPDX license headers and update year to 2018.
> 
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> ---
>  drivers/media/pci/intel/ipu3/ipu3-cio2.c | 12 ++----------
>  drivers/media/pci/intel/ipu3/ipu3-cio2.h | 14 ++------------
>  2 files changed, 4 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> index 6c4444b..725973f 100644
> --- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> +++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> @@ -1,14 +1,6 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
> - * Copyright (c) 2017 Intel Corporation.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License version
> - * 2 as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> + * Copyright (C) 2018 Intel Corporation
>   *
>   * Based partially on Intel IPU4 driver written by
>   *  Sakari Ailus <sakari.ailus@linux.intel.com>
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.h b/drivers/media/pci/intel/ipu3/ipu3-cio2.h
> index 78a5799..6a11051 100644
> --- a/drivers/media/pci/intel/ipu3/ipu3-cio2.h
> +++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.h
> @@ -1,15 +1,5 @@
> -/*
> - * Copyright (c) 2017 Intel Corporation.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License version
> - * 2 as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - */
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (C) 2018 Intel Corporation */

Should this be:

/* Copyright (C) 2017 -- 2018 Intel Corporation */

?

Same for the one above.

>  
>  #ifndef __IPU3_CIO2_H
>  #define __IPU3_CIO2_H
> -- 
> 1.9.1
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
