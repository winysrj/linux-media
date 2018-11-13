Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot1-f68.google.com ([209.85.210.68]:36702 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728943AbeKNALb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 19:11:31 -0500
MIME-Version: 1.0
References: <cover.71b0f9855c251f9dc389ee77ee6f0e1fad91fb0b.1542097288.git-series.maxime.ripard@bootlin.com>
 <c53e1cdc3b139382b00ee06bf3980d3fd1742ec0.1542097288.git-series.maxime.ripard@bootlin.com>
 <CAOMZO5CjFt1dyu8KOK+jKd88x8hwGNy9aJ-sGgooS9970TGTVQ@mail.gmail.com> <9a9616d2-a189-bd0e-e2e6-f84bdcb1dfd1@cisco.com>
In-Reply-To: <9a9616d2-a189-bd0e-e2e6-f84bdcb1dfd1@cisco.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Tue, 13 Nov 2018 12:13:09 -0200
Message-ID: <CAOMZO5DHfgV+iDo4ye7DV9CAA0QjSVXsYH1nbD2+5d9iE-uTCg@mail.gmail.com>
Subject: Re: [PATCH 3/5] media: sunxi: Add A10 CSI driver
To: Hans Verkuil <hansverk@cisco.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media <linux-media@vger.kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE"
        <linux-arm-kernel@lists.infradead.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, Nov 13, 2018 at 11:37 AM Hans Verkuil <hansverk@cisco.com> wrote:
>
> On 11/13/18 13:48, Fabio Estevam wrote:
> > On Tue, Nov 13, 2018 at 6:25 AM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> >
> >> --- /dev/null
> >> +++ b/drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.c
> >> @@ -0,0 +1,275 @@
> >> +// SPDX-License-Identifier: GPL-2.0-or-later
> >
> > According to Documentation/process/license-rules.rst this should be:
> >
> > +// SPDX-License-Identifier: GPL-2.0+
> >
> > Same applies to other places in this patch.
> >
>
> Actually, LICENSES/preferred/GPL-2.0 has GPL-2.0-or-later
> as a valid license:
>
> Valid-License-Identifier: GPL-2.0-or-later
>
> Personally I very much prefer GPL-2.0-or-later since I think it is
> much clearer.

I saw feedback from Greg to use the SPDX style from
Documentation/process/license-rules.rst.

Please check:
https://lkml.org/lkml/2018/11/10/232
