Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59267 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbeIERwx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Sep 2018 13:52:53 -0400
Message-ID: <1536153757.4084.9.camel@pengutronix.de>
Subject: Re: [PATCH v2 3/4] media: imx-pxp: add i.MX Pixel Pipeline driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Jacopo Mondi <jacopo@jmondi.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE"
        <linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>
Date: Wed, 05 Sep 2018 15:22:37 +0200
In-Reply-To: <CAOMZO5D20FG0=5FLJ3XMBd=vam9h3GMgkUKEfiPCbUKNrTw2Vg@mail.gmail.com>
References: <20180905100018.27556-1-p.zabel@pengutronix.de>
         <20180905100018.27556-4-p.zabel@pengutronix.de>
         <CAOMZO5D20FG0=5FLJ3XMBd=vam9h3GMgkUKEfiPCbUKNrTw2Vg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,

On Wed, 2018-09-05 at 10:11 -0300, Fabio Estevam wrote:
> Hi Philipp,
> 
> On Wed, Sep 5, 2018 at 7:00 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> 
> > index 000000000000..2f90c692f3fe
> > --- /dev/null
> > +++ b/drivers/media/platform/imx-pxp.c
> > @@ -0,0 +1,1774 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> 
> The recommended SPDX format in this case is:
> 
> // SPDX-License-Identifier: GPL-2.0+
> 
> as per Documentation/process/license-rules.rst

Oh, right, we are still using the old identifiers. Thanks!

regards
Philipp
