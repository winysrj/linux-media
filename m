Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:36088 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754494AbeALKRM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 05:17:12 -0500
Subject: Re: [RFC PATCH 1/9] media: add request API core and UAPI
To: Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20171215075625.27028-1-acourbot@chromium.org>
 <20171215075625.27028-2-acourbot@chromium.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3011d231-68f2-2c0a-9b9c-6787c9ad2443@xs4all.nl>
Date: Fri, 12 Jan 2018 11:16:56 +0100
MIME-Version: 1.0
In-Reply-To: <20171215075625.27028-2-acourbot@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alexandre,

A quick review: I'm primarily concentrating on the uAPI as that is the most
critical part to get right at this stage.

On 12/15/17 08:56, Alexandre Courbot wrote:
> The request API provides a way to group buffers and device parameters
> into units of work to be queued and executed. This patch introduces the
> UAPI and core framework.
> 
> This patch is based on the previous work by Laurent Pinchart. The core
> has changed considerably, but the UAPI is mostly untouched.
> 
> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> ---
>  drivers/media/Makefile               |   3 +-
>  drivers/media/media-device.c         |   6 +
>  drivers/media/media-request.c        | 390 +++++++++++++++++++++++++++++++++++
>  drivers/media/v4l2-core/v4l2-ioctl.c |   2 +-
>  include/media/media-device.h         |   3 +
>  include/media/media-entity.h         |   6 +
>  include/media/media-request.h        | 269 ++++++++++++++++++++++++
>  include/uapi/linux/media.h           |  11 +
>  8 files changed, 688 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/media/media-request.c
>  create mode 100644 include/media/media-request.h
> 

<snip>

> diff --git a/include/media/media-request.h b/include/media/media-request.h
> new file mode 100644
> index 000000000000..ead7fd8898c4
> --- /dev/null
> +++ b/include/media/media-request.h
> @@ -0,0 +1,269 @@
> +/*
> + * Generic request queue.
> + *
> + * Copyright (C) 2017, The Chromium OS Authors.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef _MEDIA_REQUEST_H
> +#define _MEDIA_REQUEST_H
> +
> +#include <linux/kref.h>
> +#include <linux/wait.h>
> +#include <linux/list.h>
> +
> +struct media_device;
> +struct media_request_queue;
> +struct media_request_cmd;
> +struct media_entity;
> +struct media_request_entity_data;
> +
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +
> +enum media_request_state {
> +	MEDIA_REQUEST_STATE_IDLE,
> +	MEDIA_REQUEST_STATE_QUEUED,
> +	MEDIA_REQUEST_STATE_COMPLETE,

COMPLETE -> COMPLETED

> +	MEDIA_REQUEST_STATE_DELETED,
> +};

Regards,

	Hans
