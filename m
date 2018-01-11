Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45601 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933571AbeAKMyn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Jan 2018 07:54:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: mchehab@kernel.org, shuah@kernel.org, sakari.ailus@linux.intel.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: v4l2-core: v4l2-mc: Add SPDX license identifier
Date: Thu, 11 Jan 2018 14:55:17 +0200
Message-ID: <2473844.IFKS5XRpDA@avalon>
In-Reply-To: <20180110163540.8396-2-shuahkh@osg.samsung.com>
References: <20180110163540.8396-1-shuahkh@osg.samsung.com> <20180110163540.8396-2-shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

Thank you for the patch.

On Wednesday, 10 January 2018 18:35:36 EET Shuah Khan wrote:
> Replace GPL license statement with SPDX GPL-2.0 license identifier.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/v4l2-core/v4l2-mc.c | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-mc.c
> b/drivers/media/v4l2-core/v4l2-mc.c index 303980b71aae..1297132acd4e 100644
> --- a/drivers/media/v4l2-core/v4l2-mc.c
> +++ b/drivers/media/v4l2-core/v4l2-mc.c
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0 */

The header doesn't match the existing license.

Furthermore, unless I'm mistaken, the standard comment style for SPDX headers 
in the kernel is //, not /* ... */

>  /*
>   * Media Controller ancillary functions
>   *
> @@ -5,16 +6,6 @@
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
