Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:47442 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934858AbdCLVKj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Mar 2017 17:10:39 -0400
Date: Sun, 12 Mar 2017 21:09:53 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: mark.rutland@arm.com, andrew-ct.chen@mediatek.com,
        minghsiu.tsai@mediatek.com, nick@shmanahar.org,
        songjun.wu@microchip.com, hverkuil@xs4all.nl, pavel@ucw.cz,
        shuah@kernel.org, devel@driverdev.osuosl.org,
        markus.heiser@darmarIT.de,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        robert.jarzmik@free.fr, geert@linux-m68k.org,
        p.zabel@pengutronix.de, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de, arnd@arndb.de,
        tiffany.lin@mediatek.com, bparrot@ti.com, robh+dt@kernel.org,
        horms+renesas@verge.net.au, mchehab@kernel.org,
        laurent.pinchart+renesas@ideasonboard.com,
        linux-arm-kernel@lists.infradead.org,
        niklas.soderlund+renesas@ragnatech.se, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, jean-christophe.trotin@st.com,
        sakari.ailus@linux.intel.com, fabio.estevam@nxp.com,
        shawnguo@kernel.org, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH v5 00/39] i.MX Media Driver
Message-ID: <20170312210952.GV21222@n2100.armlinux.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <20170312175118.GP21222@n2100.armlinux.org.uk>
 <191ef88d-2925-2264-6c77-46647394fc72@gmail.com>
 <20170312192932.GQ21222@n2100.armlinux.org.uk>
 <58b30bca-20ca-d4bd-7b86-04a4b8e71935@gmail.com>
 <c6eda3b3-52b8-8560-8f46-a6e2d6303bbd@gmail.com>
 <fa07c8d2-0943-b7d1-8d37-76e03bd527c0@gmail.com>
 <20170312204037.GU21222@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170312204037.GU21222@n2100.armlinux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 12, 2017 at 08:40:37PM +0000, Russell King - ARM Linux wrote:
> On Sun, Mar 12, 2017 at 01:36:32PM -0700, Steve Longerbeam wrote:
> > But hold on, if my logic is correct, then why did the CSI power-off
> > get reached in your case, multiple times? Yes I think there is a bug,
> > link_notify() is not checking if the link has already been disabled.
> > I will fix this. But I'm surprised media core's link_notify handling
> > doesn't do this.
> 
> Well, I think there's something incredibly fishy going on here.  I
> turned that dev_dbg() at the top of the function into a dev_info(),
> and I get:
> 
> root@hbi2ex:~# dmesg |grep -A2 imx-ipuv3-csi
> [   53.370949] imx-ipuv3-csi imx-ipuv3-csi.0: power OFF
> [   53.371015] ------------[ cut here ]------------
> [   53.371075] WARNING: CPU: 0 PID: 1515 at drivers/staging/media/imx/imx-media-csi.c:806 csi_s_power+0xb8/0xd0 [imx_media_csi]
> --
> [   53.372624] imx-ipuv3-csi imx-ipuv3-csi.0: power OFF
> [   53.372637] ------------[ cut here ]------------
> [   53.372663] WARNING: CPU: 0 PID: 1515 at drivers/staging/media/imx/imx-media-csi.c:806 csi_s_power+0xb8/0xd0 [imx_media_csi]
> 
> There isn't a power on event being generated before these two power
> off events.  I don't see a power on event even when I attempt to
> start streaming either (which fails due to the lack of bayer
> support.)

Found it - my imx219 driver returns '1' from its s_power function when
powering up, which triggers a bug in your code - when imx_media_set_power()
fails to power up, you call imx_media_set_power() telling it to power
everything off - including devices that are already powered off.

This is really bad news - s_power() may be called via other paths,
such as when the subdev is opened.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
