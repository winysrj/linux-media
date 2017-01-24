Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:40563 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750977AbdAXL2e (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jan 2017 06:28:34 -0500
Message-ID: <1485257289.3600.97.camel@pengutronix.de>
Subject: Re: [PATCH v3 00/24] i.MX Media Driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Tue, 24 Jan 2017 12:28:09 +0100
In-Reply-To: <2b6ae556-df48-6b6b-87f1-d092eba586b9@xs4all.nl>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
         <c6e98327-7e2c-f34a-2d23-af7b236de441@xs4all.nl>
         <1484929911.2897.70.camel@pengutronix.de>
         <3fb68686-9447-2d8a-e2d2-005e4138cd43@gmail.com>
         <5d23d244-aa0e-401c-24a9-07f28acf1563@xs4all.nl>
         <1485169204.2874.57.camel@pengutronix.de>
         <2b6ae556-df48-6b6b-87f1-d092eba586b9@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-01-23 at 12:08 +0100, Hans Verkuil wrote:
> On 01/23/2017 12:00 PM, Philipp Zabel wrote:
> > On Fri, 2017-01-20 at 21:39 +0100, Hans Verkuil wrote:
[...]
> As long as it is mentioned in the TODO, and ideally in the Kconfig as well,
> then I'm fine with it.
>
> The big advantage of being in the kernel is that it is much easier to start
> providing fixes, improvements, etc. If you use a staging driver you know
> that there is no guarantee whatsoever with respect to stable ABI/APIs.

Of course, but there should be a clear way how to progress on those
issues that are documented as blockers, otherwise the driver will linger
in staging.
Worse, currently we are not even in agreement what to put into the TODO.

regards
Philipp

