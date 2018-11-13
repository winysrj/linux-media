Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:58568 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732356AbeKNApo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 19:45:44 -0500
Date: Tue, 13 Nov 2018 15:46:47 +0100
From: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Hans Verkuil <hansverk@cisco.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
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
Subject: Re: [PATCH 3/5] media: sunxi: Add A10 CSI driver
Message-ID: <20181113154647.06900549@windsurf>
In-Reply-To: <CAOMZO5DHfgV+iDo4ye7DV9CAA0QjSVXsYH1nbD2+5d9iE-uTCg@mail.gmail.com>
References: <cover.71b0f9855c251f9dc389ee77ee6f0e1fad91fb0b.1542097288.git-series.maxime.ripard@bootlin.com>
        <c53e1cdc3b139382b00ee06bf3980d3fd1742ec0.1542097288.git-series.maxime.ripard@bootlin.com>
        <CAOMZO5CjFt1dyu8KOK+jKd88x8hwGNy9aJ-sGgooS9970TGTVQ@mail.gmail.com>
        <9a9616d2-a189-bd0e-e2e6-f84bdcb1dfd1@cisco.com>
        <CAOMZO5DHfgV+iDo4ye7DV9CAA0QjSVXsYH1nbD2+5d9iE-uTCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tue, 13 Nov 2018 12:13:09 -0200, Fabio Estevam wrote:

> > Actually, LICENSES/preferred/GPL-2.0 has GPL-2.0-or-later
> > as a valid license:
> >
> > Valid-License-Identifier: GPL-2.0-or-later
> >
> > Personally I very much prefer GPL-2.0-or-later since I think it is
> > much clearer.  
> 
> I saw feedback from Greg to use the SPDX style from
> Documentation/process/license-rules.rst.
> 
> Please check:
> https://lkml.org/lkml/2018/11/10/232

According to https://spdx.org/licenses/, i.e the reference SPDX site,
GPL-2.0-or-later is the right thing to use, and GPL-2.0+ is
"deprecated". But apparently Greg's feedback is "let's not used the
SDPX style, as we don't want to change this all over".

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
