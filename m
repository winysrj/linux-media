Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:38375 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933150AbdC3R02 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 13:26:28 -0400
Message-ID: <1490894749.2404.33.camel@pengutronix.de>
Subject: [RFC] [media] imx: assume MEDIA_ENT_F_ATV_DECODER entities output
 video on pad 1
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Thu, 30 Mar 2017 19:25:49 +0200
In-Reply-To: <1490661656-10318-20-git-send-email-steve_longerbeam@mentor.com>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
         <1490661656-10318-20-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The TVP5150 DT bindings specify a single output port (port 0) that
corresponds to the video output pad (pad 1, DEMOD_PAD_VID_OUT).

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
I'm trying to get this to work with a TVP5150 analog TV decoder, and the
first problem is that this device doesn't have pad 0 as its single
output pad. Instead, as a MEDIA_ENT_F_ATV_DECODER entity, it has for
pads (input, video out, vbi out, audio out), and video out is pad 1,
whereas the device tree only defines a single port (0).
---

 drivers/staging/media/imx/imx-media-dev.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index 17e2386a3ca3a..c52d6ca797965 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -267,6 +267,15 @@ static int imx_media_create_link(struct imx_media_dev *imxmd,
 	source_pad = link->local_pad;
 	sink_pad = link->remote_pad;
 
+	/*
+	 * If the source subdev is an analog video decoder with a single source
+	 * port, assume that this port 0 corresponds to the DEMOD_PAD_VID_OUT
+	 * entity pad.
+	 */
+	if (source->entity.function == MEDIA_ENT_F_ATV_DECODER &&
+	    local_sd->num_sink_pads == 0 && local_sd->num_src_pads == 1)
+		source_pad = DEMOD_PAD_VID_OUT;
+
 	v4l2_info(&imxmd->v4l2_dev, "%s: %s:%d -> %s:%d\n", __func__,
 		  source->name, source_pad, sink->name, sink_pad);
 
-- 
2.11.0
