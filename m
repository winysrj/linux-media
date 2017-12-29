Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:43257 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750708AbdL2Mqa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Dec 2017 07:46:30 -0500
Received: by mail-wm0-f68.google.com with SMTP id n138so48157626wmg.2
        for <linux-media@vger.kernel.org>; Fri, 29 Dec 2017 04:46:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1514533978-20408-6-git-send-email-zhengsq@rock-chips.com>
References: <1514533978-20408-1-git-send-email-zhengsq@rock-chips.com> <1514533978-20408-6-git-send-email-zhengsq@rock-chips.com>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Fri, 29 Dec 2017 13:45:47 +0100
Message-ID: <CAOFm3uEEBvVKrR+HyCQ76gbVNz51Q343gm0JyfPgMxHFawR74w@mail.gmail.com>
Subject: Re: [PATCH v5 05/16] media: rkisp1: add Rockchip ISP1 subdev driver
To: Shunqian Zheng <zhengsq@rock-chips.com>
Cc: "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE"
        <linux-arm-kernel@lists.infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        zyc@rock-chips.com, eddie.cai.linux@gmail.com,
        Jeffy Chen <jeffy.chen@rock-chips.com>,
        allon.huang@rock-chips.com,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Luis.Oliveira@synopsys.com, Jose Abreu <Jose.Abreu@synopsys.com>,
        jacob2.chen@rock-chips.com, Jacob Chen <cc@rock-chips.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Shunqian,

On Fri, Dec 29, 2017 at 8:52 AM, Shunqian Zheng <zhengsq@rock-chips.com> wrote:
> From: Jacob Chen <jacob2.chen@rock-chips.com>
>
> Add the subdev driver for rockchip isp1.

<snip>

> --- /dev/null
> +++ b/drivers/media/platform/rockchip/isp1/rkisp1.c
> @@ -0,0 +1,1205 @@
> +/*
> + * Rockchip isp1 driver
> + *
> + * Copyright (C) 2017 Rockchip Electronics Co., Ltd.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */


Do you mind using a simpler SPDX identifier instead of this long
legalese boilerplate?
This is documented in Thomas doc patches. This applies to your entire
patch set of course.
Thanks!

-- 
Cordially
Philippe Ombredanne
