Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:45769 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbeIERld (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Sep 2018 13:41:33 -0400
Received: by mail-oi0-f65.google.com with SMTP id t68-v6so13405322oie.12
        for <linux-media@vger.kernel.org>; Wed, 05 Sep 2018 06:11:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180905100018.27556-4-p.zabel@pengutronix.de>
References: <20180905100018.27556-1-p.zabel@pengutronix.de> <20180905100018.27556-4-p.zabel@pengutronix.de>
From: Fabio Estevam <festevam@gmail.com>
Date: Wed, 5 Sep 2018 10:11:19 -0300
Message-ID: <CAOMZO5D20FG0=5FLJ3XMBd=vam9h3GMgkUKEfiPCbUKNrTw2Vg@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] media: imx-pxp: add i.MX Pixel Pipeline driver
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Jacopo Mondi <jacopo@jmondi.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE"
        <linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Wed, Sep 5, 2018 at 7:00 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:

> index 000000000000..2f90c692f3fe
> --- /dev/null
> +++ b/drivers/media/platform/imx-pxp.c
> @@ -0,0 +1,1774 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later

The recommended SPDX format in this case is:

// SPDX-License-Identifier: GPL-2.0+

as per Documentation/process/license-rules.rst

Thanks
