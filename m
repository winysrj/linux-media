Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:58157 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1762371AbdLSLs4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 06:48:56 -0500
Message-ID: <1513684129.7538.11.camel@pengutronix.de>
Subject: Re: [PATCH v2 5/8] media: v4l2-mediabus: convert flags to enums and
 document them
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mats Randgaard <matrandg@cisco.com>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Petr Cvek <petr.cvek@tul.cz>, Rob Herring <robh@kernel.org>,
        Pravin Shedge <pravin.shedge4linux@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        linux-renesas-soc@vger.kernel.org, devel@driverdev.osuosl.org
Date: Tue, 19 Dec 2017 12:48:49 +0100
In-Reply-To: <3c5e8bd156d0481410f7cc2352670fc65a99d756.1513682135.git.mchehab@s-opensource.com>
References: <cover.1513682135.git.mchehab@s-opensource.com>
         <3c5e8bd156d0481410f7cc2352670fc65a99d756.1513682135.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-12-19 at 09:18 -0200, Mauro Carvalho Chehab wrote:
> There is a mess with media bus flags: there are two sets of
> flags, one used by parallel and ITU-R BT.656 outputs,
> and another one for CSI2.
> 
> Depending on the type, the same bit has different meanings.
> 
> That's very confusing, and counter-intuitive. So, split them
> into two sets of flags, inside an enum.
> 
> This way, it becomes clearer that there are two separate sets
> of flags. It also makes easier if CSI1, CSP, CSI3, etc. would
> need a different set of flags.
> 
> As a side effect, enums can be documented via kernel-docs,
> so there will be an improvement at flags documentation.
> 
> Unfortunately, soc_camera and pxa_camera do a mess with
> the flags, using either one set of flags without proper
> checks about the type. That could be fixed, but, as both drivers
> are obsolete and in the process of cleanings, I opted to just
> keep the behavior, using an unsigned int inside those two
> drivers.
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

For imx-media,
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

thanks
Philipp
