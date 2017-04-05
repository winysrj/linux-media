Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:56963 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932194AbdDEJoG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Apr 2017 05:44:06 -0400
Message-ID: <1491385427.2381.58.camel@pengutronix.de>
Subject: Re: [RFC] [media] imx: assume MEDIA_ENT_F_ATV_DECODER entities
 output video on pad 1
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: mark.rutland@arm.com, andrew-ct.chen@mediatek.com,
        minghsiu.tsai@mediatek.com, nick@shmanahar.org,
        songjun.wu@microchip.com, hverkuil@xs4all.nl,
        Steve Longerbeam <steve_longerbeam@mentor.com>, pavel@ucw.cz,
        robert.jarzmik@free.fr, devel@driverdev.osuosl.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, shuah@kernel.org,
        linux@armlinux.org.uk, geert@linux-m68k.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        sakari.ailus@linux.intel.com, arnd@arndb.de, mchehab@kernel.org,
        bparrot@ti.com, robh+dt@kernel.org, horms+renesas@verge.net.au,
        tiffany.lin@mediatek.com, linux-arm-kernel@lists.infradead.org,
        niklas.soderlund+renesas@ragnatech.se, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, jean-christophe.trotin@st.com,
        kernel@pengutronix.de, fabio.estevam@nxp.com, shawnguo@kernel.org,
        sudipm.mukherjee@gmail.com
Date: Wed, 05 Apr 2017 11:43:47 +0200
In-Reply-To: <9bfabc5c-d90f-6487-537d-20515ec61f9c@gmail.com>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
         <1490661656-10318-20-git-send-email-steve_longerbeam@mentor.com>
         <1490894749.2404.33.camel@pengutronix.de>
         <9bfabc5c-d90f-6487-537d-20515ec61f9c@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-04-04 at 15:11 -0700, Steve Longerbeam wrote:
> 
> On 03/30/2017 10:25 AM, Philipp Zabel wrote:
> > The TVP5150 DT bindings specify a single output port (port 0) that
> > corresponds to the video output pad (pad 1, DEMOD_PAD_VID_OUT).
> >
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> > I'm trying to get this to work with a TVP5150 analog TV decoder, and the
> > first problem is that this device doesn't have pad 0 as its single
> > output pad. Instead, as a MEDIA_ENT_F_ATV_DECODER entity, it has for
> > pads (input, video out, vbi out, audio out), and video out is pad 1,
> > whereas the device tree only defines a single port (0).
> 
> Shouldn't the DT bindings define ports for these other pads?

In this case, probably yes for the input pad, certainly no for the
VBI/audio pads. See the other mail.

> I haven't seen this documented anywhere, but shouldn't there
> be a 1:1 correspondence between DT ports and media pads?

Not in general. But imagine a dual HDMI->CSI2 converter, for example. We
don't support this yet, but that might reasonably be described in the
device tree as a single device with two output ports. But the internal
representation would be two completely separate v4l2 subdevices.

regards
Philipp
