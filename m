Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:60177 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751666AbdBMJVr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 04:21:47 -0500
Message-ID: <1486977617.2873.29.camel@pengutronix.de>
Subject: Re: [PATCH v3 21/24] media: imx: Add MIPI CSI-2 Receiver subdev
 driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>,
        robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
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
Date: Mon, 13 Feb 2017 10:20:17 +0100
In-Reply-To: <e9076980-ce84-f9ee-096d-865243b82a9e@gmail.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
         <1483755102-24785-22-git-send-email-steve_longerbeam@mentor.com>
         <1486036237.2289.37.camel@pengutronix.de>
         <ca0a2eb3-21b6-d312-c8e0-61da48c4c700@gmail.com>
         <20170208234235.GA27312@n2100.armlinux.org.uk>
         <d6dba77e-902c-7a4c-cc70-fe3a5c9649bb@gmail.com>
         <e9076980-ce84-f9ee-096d-865243b82a9e@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Thu, 2017-02-09 at 15:51 -0800, Steve Longerbeam wrote:
> 
> On 02/09/2017 03:49 PM, Steve Longerbeam wrote:
> >
> >
> > On 02/08/2017 03:42 PM, Russell King - ARM Linux wrote:
> >> On Wed, Feb 08, 2017 at 03:23:53PM -0800, Steve Longerbeam wrote:
> >>>> Actually, this exact function already exists as 
> >>>> dw_mipi_dsi_phy_write in
> >>>> drivers/gpu/drm/rockchip/dw-mipi-dsi.c, and it looks like the D-PHY
> >>>> register 0x44 might contain a field called HSFREQRANGE_SEL.
> >>> Thanks for pointing out drivers/gpu/drm/rockchip/dw-mipi-dsi.c.
> >>> It's clear from that driver that there probably needs to be a fuller
> >>> treatment of the D-PHY programming here, but I don't know where
> >>> to find the MIPI CSI-2 D-PHY documentation for the i.MX6. The code
> >>> in imxcsi2_reset() was also pulled from FSL, and that's all I really 
> >>> have
> >>> to go on for the D-PHY programming. I assume the D-PHY is also a
> >>> Synopsys core, like the host controller, but the i.MX6 manual doesn't
> >>> cover it.
> >> Why exactly?  What problems are you seeing that would necessitate a
> >> more detailed programming of the D-PHY?  From my testing, I can wind
> >> a 2-lane MIPI bus on iMX6D from 912Mbps per lane down to (eg) 308Mbps
> >> per lane with your existing code without any issues.
> >
> > That's good to hear.
> >
> > Just from my experience with struggles to get the CSI2 receiver
> > up and running with an active clock lane, and my suspicions that
> > some of that could be due to my lack of understanding of the D-PHY
> > programming.
> 
> But I should add that after a re-org of the sequence, it looks more stable
> now. Tested on both the SabreSD and SabreLite with the OV5640.

It seems the OV5640 driver never puts its the CSI-2 lanes into stop
state while not streaming. With the recent s_stream reordering,
streaming from TC358743 does not work anymore, since imx6-mipi-csi2
s_stream is called before tc358743 s_stream, while all lanes are still
in stop state. Then it waits for the clock lane to become active and
fails. I have applied the following patch to revert the reordering
locally to get it to work again.

The initialization order, as Russell pointed out, should be:

1. reset the D-PHY.
2. place MIPI sensor in LP-11 state
3. perform D-PHY initialisation
4. configure CSI2 lanes and de-assert resets and shutdown signals

So csi2_s_stream should wait for stop state on all lanes (the result of
2.) before dphy_init (3.), not wait for active clock afterwards. That
should happen only after sensor_s_stream was called. So unless we are
allowed to reorder steps 1. and 2., we might need the prepare_stream
callback after all.

More specifically, the chapter 40.3.1 "Startup Sequence" in the i.MX6DQ
reference manual states:

1. Deassert presetn signal (global reset)
   - This is probably the APB global reset, so not something we have to
     care about.
2. Configure MIPI Camera Sensor to put all Tx lanes in PL-11 state
3. D-PHY initialization (write 0x14 to address 0x44)
4. CSI2 Controller programming
   - Set N_LANES
   - Deassert PHY_SHUTDOWNZ
   - Deassert PHY_RSTZ
   - Deassert CSI2_RESETN
5. Read the PHY status register (PHY_STATE) to confirm that all data and
   clock lanes of the D-PHY are in Stop State
6. Configure the MIPI Camera Sensor to start transmitting a clock on the
   D-PHY clock lane
7. CSI2 Controller programming - Read the PHY status register
   (PHY_STATE) to confirm that the D-PHY is receiving a clock on the
   D-PHY clock lane

2. can be done in sensor s_power (which tc358743 currently does) only if
the sensor can still be configured in step 6.
Also, 3./4./5. are csi2 code, 6. is sensor code, and 7. is csi2 code
again. For reliable startup we need csi2 receiver code to be called on
both sides of the sensor enabling its clock lane.

----------8<----------
>From f12758caa3e1d05980cd2ac07587d125449fc860 Mon Sep 17 00:00:00 2001
From: Philipp Zabel <p.zabel@pengutronix.de>
Date: Mon, 13 Feb 2017 09:28:27 +0100
Subject: [PATCH] media: imx: revert streamon sequence change

Without this patch, starting streaming from a TC358743 MIPI CSI-2 source
fails with the following error messages:

    imx6-mipi-csi2: clock lane timeout, phy_state = 0x000006f0
    ipu1_csi0: pipeline_set_stream failed with -110

The phy state above has the stopstateclk, rxulpsclknot, and
stopstatedata[3:0] bits set: at this point all lanes are in stop state,
no lane is in ultra low power state or active.
This is no suprise, since tc358743 s_stream(sd, 1) has not been called
due to the recently changed ordering. The imx6-mipi-csi2 s_stream does
wait for the clock lane to become active, so csi2_s_stream must happen
after tc358743_s_stream.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/media/imx/imx-media-utils.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
index 81eabcf76a66f..495ccefa3cd2a 100644
--- a/drivers/staging/media/imx/imx-media-utils.c
+++ b/drivers/staging/media/imx/imx-media-utils.c
@@ -782,8 +782,8 @@ static const u32 stream_on_seq[] = {
 	IMX_MEDIA_GRP_ID_IC_PRPENC,
 	IMX_MEDIA_GRP_ID_IC_PRP,
 	IMX_MEDIA_GRP_ID_VDIC,
-	IMX_MEDIA_GRP_ID_CSI2,
 	IMX_MEDIA_GRP_ID_SENSOR,
+	IMX_MEDIA_GRP_ID_CSI2,
 	IMX_MEDIA_GRP_ID_VIDMUX,
 	IMX_MEDIA_GRP_ID_CSI,
 };
@@ -795,8 +795,8 @@ static const u32 stream_off_seq[] = {
 	IMX_MEDIA_GRP_ID_VDIC,
 	IMX_MEDIA_GRP_ID_CSI,
 	IMX_MEDIA_GRP_ID_VIDMUX,
-	IMX_MEDIA_GRP_ID_SENSOR,
 	IMX_MEDIA_GRP_ID_CSI2,
+	IMX_MEDIA_GRP_ID_SENSOR,
 };
 
 #define NUM_STREAM_ENTITIES ARRAY_SIZE(stream_on_seq)
-- 
2.11.0
---------->8----------

regards
Philipp
