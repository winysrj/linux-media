Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59412 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933757AbeAKWsD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Jan 2018 17:48:03 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: mchehab@kernel.org, shuah@kernel.org, sakari.ailus@linux.intel.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] media: v4l2-core: v4l2-mc: Add SPDX license identifier
Date: Fri, 12 Jan 2018 00:47:59 +0200
Message-ID: <19188511.bh6ath78zl@avalon>
In-Reply-To: <20180111222622.32206-1-shuahkh@osg.samsung.com>
References: <20180111222622.32206-1-shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

Thank you for the patch.

On Friday, 12 January 2018 00:26:22 EET Shuah Khan wrote:
> Replace GPL license statement with SPDX GPL-2.0 license identifier.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> Changes since v1:
> - Fixed SPDX comment format
> - Fixed SPDX license text to eliminate change in license. It now
>   reads GPL-2.0-or-later to maintain the original.
> 
>  drivers/media/v4l2-core/v4l2-mc.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-mc.c
> b/drivers/media/v4l2-core/v4l2-mc.c index 303980b71aae..8b61ccf3df81 100644
> --- a/drivers/media/v4l2-core/v4l2-mc.c
> +++ b/drivers/media/v4l2-core/v4l2-mc.c
> @@ -1,3 +1,5 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +
>  /*
>   * Media Controller ancillary functions
>   *
> @@ -5,16 +7,6 @@
>   * Copyright (C) 2016 Shuah Khan <shuahkh@osg.samsung.com>
>   * Copyright (C) 2006-2010 Nokia Corporation
>   * Copyright (c) 2016 Intel Corporation.
> - *
> - *  This program is free software; you can redistribute it and/or modify
> - *  it under the terms of the GNU General Public License as published by
> - *  the Free Software Foundation; either version 2 of the License, or
> - *  (at your option) any later version.
> - *
> - *  This program is distributed in the hope that it will be useful,
> - *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> - *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - *  GNU General Public License for more details.
>   */
> 
>  #include <linux/module.h>


-- 
Regards,

Laurent Pinchart
