Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:40291 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932907AbdDEL7J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Apr 2017 07:59:09 -0400
Message-ID: <1491393519.2904.40.camel@pengutronix.de>
Subject: Re: [PATCH v6 17/39] platform: add video-multiplexer subdevice
 driver
From: Lucas Stach <l.stach@pengutronix.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Steve Longerbeam <slongerbeam@gmail.com>, mark.rutland@arm.com,
        andrew-ct.chen@mediatek.com, minghsiu.tsai@mediatek.com,
        sakari.ailus@linux.intel.com, nick@shmanahar.org,
        songjun.wu@microchip.com, hverkuil@xs4all.nl,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        robert.jarzmik@free.fr, devel@driverdev.osuosl.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, shuah@kernel.org,
        linux@armlinux.org.uk, geert@linux-m68k.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de, arnd@arndb.de, mchehab@kernel.org,
        bparrot@ti.com, robh+dt@kernel.org, horms+renesas@verge.net.au,
        tiffany.lin@mediatek.com, linux-arm-kernel@lists.infradead.org,
        niklas.soderlund+renesas@ragnatech.se, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, jean-christophe.trotin@st.com,
        p.zabel@pengutronix.de, fabio.estevam@nxp.com, shawnguo@kernel.org,
        sudipm.mukherjee@gmail.com
Date: Wed, 05 Apr 2017 13:58:39 +0200
In-Reply-To: <20170405111857.GA26831@amd>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
         <1490661656-10318-18-git-send-email-steve_longerbeam@mentor.com>
         <20170405111857.GA26831@amd>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mittwoch, den 05.04.2017, 13:18 +0200 schrieb Pavel Machek:
> Hi!
> 
> > + * video stream multiplexer controlled via gpio or syscon
> > + *
> > + * Copyright (C) 2013 Pengutronix, Sascha Hauer <kernel@pengutronix.de>
> > + * Copyright (C) 2016 Pengutronix, Philipp Zabel <kernel@pengutronix.de>
> 
> This is actually quite interesting. Same email address for two
> people...
> 
> Plus, I believe this wants to say that copyright is with Pengutronix,
> not Sascha and Philipp. In that case you probably want to list
> copyright and authors separately?
> 
Nope, copyright doesn't get transferred to the employer within the rules
of the German "Urheberrecht", but stays at the original author of the
code.
Same email is just to ensure that any requests regarding this code get
routed to the right people, even if someone leaves the company or is
temporarily unavailable. kernel@ is a list for the Pengutronix kernel
team.

Regards,
Lucas
