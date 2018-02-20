Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33821 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751346AbeBTHhU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Feb 2018 02:37:20 -0500
Received: by mail-wm0-f67.google.com with SMTP id a20so3283142wmd.1
        for <linux-media@vger.kernel.org>; Mon, 19 Feb 2018 23:37:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180220044425.169493-10-acourbot@chromium.org>
References: <20180220044425.169493-1-acourbot@chromium.org> <20180220044425.169493-10-acourbot@chromium.org>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Tue, 20 Feb 2018 08:36:38 +0100
Message-ID: <CAOFm3uF6GRh1_7qgD1vSF8k=Lo4J8hG14MZwRK8r0ORAdy60+Q@mail.gmail.com>
Subject: Re: [RFCv4 09/21] v4l2: add request API support
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

On Tue, Feb 20, 2018 at 5:44 AM, Alexandre Courbot
<acourbot@chromium.org> wrote:
> Add a v4l2 request entity data structure that takes care of storing the
> request-related state of a V4L2 device ; in this case, its controls.
>
> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>

<snip>

> --- /dev/null
> +++ b/drivers/media/v4l2-core/v4l2-request.c
> @@ -0,0 +1,178 @@
> +/*
> + * Media requests support for V4L2
> + *
> + * Copyright (C) 2018, The Chromium OS Authors.  All rights reserved.
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

Do you mind using SPDX tags per [1] rather that this fine but long
legalese. (Here and in the whole patch series)

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/license-rules.rst
-- 
Cordially
Philippe Ombredanne
