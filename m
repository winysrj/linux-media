Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:40101 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755048AbdLOKiI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 05:38:08 -0500
Received: by mail-wr0-f193.google.com with SMTP id q9so7654166wre.7
        for <linux-media@vger.kernel.org>; Fri, 15 Dec 2017 02:38:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171215075625.27028-2-acourbot@chromium.org>
References: <20171215075625.27028-1-acourbot@chromium.org> <20171215075625.27028-2-acourbot@chromium.org>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Fri, 15 Dec 2017 11:37:26 +0100
Message-ID: <CAOFm3uEUikWxEC_PtWjECL_8E28g92KhWJPSqiEE+H3LYLE+8Q@mail.gmail.com>
Subject: Re: [RFC PATCH 1/9] media: add request API core and UAPI
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alexandre:

On Fri, Dec 15, 2017 at 8:56 AM, Alexandre Courbot
<acourbot@chromium.org> wrote:
> The request API provides a way to group buffers and device parameters
> into units of work to be queued and executed. This patch introduces the
> UAPI and core framework.
>
> This patch is based on the previous work by Laurent Pinchart. The core
> has changed considerably, but the UAPI is mostly untouched.
>
> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>

<snip

> --- /dev/null
> +++ b/drivers/media/media-request.c
> @@ -0,0 +1,390 @@
> +/*
> + * Request and request queue base management
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

Have you considered using the new SPDX tags instead of this fine but
long legalese? And if other Chromium contributors could follow suit
and you could spread the word that would be even better!

See Thomas doc patches [1] for details.
Thanks!

[1] https://lkml.org/lkml/2017/12/4/934
-- 
Cordially
Philippe Ombredanne
