Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47540 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725762AbeICFfC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2018 01:35:02 -0400
Date: Sun, 2 Sep 2018 22:17:09 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Tom aan de Wiel <tom.aandewiel@gmail.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: Re: [PATCH] vicodec: change codec license to LGPL
Message-ID: <20180902221600.4b1bc5f1@coco.lan>
In-Reply-To: <6c7584ed-c7ba-b9c2-73fa-2201fcba8201@xs4all.nl>
References: <6c7584ed-c7ba-b9c2-73fa-2201fcba8201@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 2 Sep 2018 12:37:04 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> The FWHT codec can also be used by userspace utilities and libraries, but
> since the current license is GPL and not LGPL it is not possible to include
> it in e.g. gstreamer, since LGPL is required for that.
> 
> Change the license of these four files to LGPL.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> Tom, if you agree to this, can you give your 'Signed-off-by' line? I cannot
> make this change for the codec-fwht.c/h files without it. I think this change
> makes sense.
> 
> Regards,
> 
> 	Hans
> ---
> diff --git a/drivers/media/platform/vicodec/codec-fwht.c b/drivers/media/platform/vicodec/codec-fwht.c
> index 47939160560e..36656031b295 100644
> --- a/drivers/media/platform/vicodec/codec-fwht.c
> +++ b/drivers/media/platform/vicodec/codec-fwht.c
> @@ -1,4 +1,4 @@
> -// SPDX-License-Identifier: GPL-2.0+
> +// SPDX-License-Identifier: LGPL-2.1+

There aren't much C files under LGPL at the Kernel. Yeah, I know it
is compatible with GPL-2.0+, but I would prefer it the tag would
be, instead:

// SPDX-License-Identifier: GPL-2.0+ OR LGPL-2.1+

as this makes easier if one uses some software to parse the Kernel
tree.

(same applies to the other files).

Regards,
Mauro

>  /*
>   * Copyright 2016 Tom aan de Wiel
>   * Copyright 2018 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
> diff --git a/drivers/media/platform/vicodec/codec-fwht.h b/drivers/media/platform/vicodec/codec-fwht.h
> index 1f9e47331197..3e9391fec5fe 100644
> --- a/drivers/media/platform/vicodec/codec-fwht.h
> +++ b/drivers/media/platform/vicodec/codec-fwht.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: GPL-2.0+ */
> +/* SPDX-License-Identifier: LGPL-2.1+ */
>  /*
>   * Copyright 2016 Tom aan de Wiel
>   * Copyright 2018 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
> diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
> index cfcf84b8574d..6b06aa382cbb 100644
> --- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
> +++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
> @@ -1,4 +1,4 @@
> -// SPDX-License-Identifier: GPL-2.0
> +// SPDX-License-Identifier: LGPL-2.1
>  /*
>   * A V4L2 frontend for the FWHT codec
>   *
> diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.h b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
> index 7794c186d905..95d1756556db 100644
> --- a/drivers/media/platform/vicodec/codec-v4l2-fwht.h
> +++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> +/* SPDX-License-Identifier: LGPL-2.1 */
>  /*
>   * Copyright 2018 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
>   */



Thanks,
Mauro
