Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35686 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751469AbdCLAa6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Mar 2017 19:30:58 -0500
Subject: Re: [PATCH v5 00/39] i.MX Media Driver
To: Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <20170310201356.GA21222@n2100.armlinux.org.uk>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <47542ef8-3e91-b4cd-cc65-95000105f172@gmail.com>
Date: Sat, 11 Mar 2017 16:30:53 -0800
MIME-Version: 1.0
In-Reply-To: <20170310201356.GA21222@n2100.armlinux.org.uk>
Content-Type: multipart/mixed;
 boundary="------------B0044A2B02560C3AD74EC7A5"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------B0044A2B02560C3AD74EC7A5
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit



On 03/10/2017 12:13 PM, Russell King - ARM Linux wrote:
> Version 5 gives me no v4l2 controls exposed through the video device
> interface.
>
> Just like with version 4, version 5 is completely useless with IMX219:
>
> imx6-mipi-csi2: LP-11 timeout, phy_state = 0x00000200
> ipu1_csi0: pipeline start failed with -110
> imx6-mipi-csi2: LP-11 timeout, phy_state = 0x00000200
> ipu1_csi0: pipeline start failed with -110
> imx6-mipi-csi2: LP-11 timeout, phy_state = 0x00000200
> ipu1_csi0: pipeline start failed with -110
>

If it's too difficult to get the imx219 csi-2 transmitter into the
LP-11 state on power on, perhaps the csi-2 receiver can be a little
more lenient on the transmitter and make the LP-11 timeout a warning
instead of error-out.

Can you try the attached change on top of the version 5 patchset?

If that doesn't work then you're just going to have to fix the bug
in imx219.

Steve

--------------B0044A2B02560C3AD74EC7A5
Content-Type: text/x-patch;
 name="warn-on-lp-11-timeout.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="warn-on-lp-11-timeout.diff"

diff --git a/drivers/staging/media/imx/imx6-mipi-csi2.c b/drivers/staging/media/imx/imx6-mipi-csi2.c
index d8f931e..720bf4d 100644
--- a/drivers/staging/media/imx/imx6-mipi-csi2.c
+++ b/drivers/staging/media/imx/imx6-mipi-csi2.c
@@ -224,11 +224,8 @@ static int csi2_dphy_wait_stopstate(struct csi2_dev *csi2)
 
 	ret = readl_poll_timeout(csi2->base + CSI2_PHY_STATE, reg,
 				 (reg & mask) == mask, 0, 500000);
-	if (ret) {
-		v4l2_err(&csi2->sd, "LP-11 timeout, phy_state = 0x%08x\n", reg);
-		return ret;
-	}
-
+	if (ret)
+		v4l2_warn(&csi2->sd, "LP-11 timeout, phy_state = 0x%08x\n", reg);
 	return 0;
 }
 

--------------B0044A2B02560C3AD74EC7A5--
