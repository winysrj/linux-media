Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:46768 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934692AbdCLUXg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Mar 2017 16:23:36 -0400
Date: Sun, 12 Mar 2017 20:22:41 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
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
Subject: Re: [PATCH v5 00/39] i.MX Media Driver
Message-ID: <20170312202240.GT21222@n2100.armlinux.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <20170310201356.GA21222@n2100.armlinux.org.uk>
 <47542ef8-3e91-b4cd-cc65-95000105f172@gmail.com>
 <20170312195741.GS21222@n2100.armlinux.org.uk>
 <ea3ccdb8-903f-93ab-6875-90da440fc52a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea3ccdb8-903f-93ab-6875-90da440fc52a@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 12, 2017 at 01:05:06PM -0700, Steve Longerbeam wrote:
> 
> 
> On 03/12/2017 12:57 PM, Russell King - ARM Linux wrote:
> >On Sat, Mar 11, 2017 at 04:30:53PM -0800, Steve Longerbeam wrote:
> >>If it's too difficult to get the imx219 csi-2 transmitter into the
> >>LP-11 state on power on, perhaps the csi-2 receiver can be a little
> >>more lenient on the transmitter and make the LP-11 timeout a warning
> >>instead of error-out.
> >>
> >>Can you try the attached change on top of the version 5 patchset?
> >>
> >>If that doesn't work then you're just going to have to fix the bug
> >>in imx219.
> >
> >That patch gets me past that hurdle, only to reveal that there's another
> >issue:
> 
> Yeah, ipu_cpmem_set_image() failed because it doesn't recognize the
> bayer formats. Wait, didn't we fix this already? I've lost track.
> Ah, right, we were going to move this support into the IPUv3 driver,
> but in the meantime I think you had some patches to get around this.

What I had was this patch for your v3.  I never got to testing your
v4 because of the LP-11 problem.

In v5, you've changed to propagate the ipu_cpmem_set_image() error
code to avoid the resulting corruption, but that leaves the other bits
of this patch unaddressed, along my "media: imx: smfc: add support
for bayer formats" patch.

Your driver basically has no support for bayer formats.

diff --git a/drivers/staging/media/imx/imx-smfc.c b/drivers/staging/media/imx/imx-smfc.c
index 313732201a52..4351c0365cf4 100644
--- a/drivers/staging/media/imx/imx-smfc.c
+++ b/drivers/staging/media/imx/imx-smfc.c
@@ -234,11 +234,6 @@ static void imx_smfc_setup_channel(struct imx_smfc_priv *priv)
 	buf1 = imx_media_dma_buf_get_next_queued(priv->out_ring);
 	priv->next = buf1;
 
-	image.phys0 = buf0->phys;
-	image.phys1 = buf1->phys;
-	ipu_cpmem_set_image(priv->smfc_ch, &image);
-
-
 	switch (image.pix.pixelformat) {
 	case V4L2_PIX_FMT_SBGGR8:
 	case V4L2_PIX_FMT_SGBRG8:
@@ -247,6 +242,10 @@ static void imx_smfc_setup_channel(struct imx_smfc_priv *priv)
 		burst_size = 8;
 		passthrough = true;
 		passthrough_bits = 8;
+		ipu_cpmem_set_resolution(priv->smfc_ch, image.rect.width, image.rect.height);
+		ipu_cpmem_set_stride(priv->smfc_ch, image.pix.bytesperline);
+		ipu_cpmem_set_buffer(priv->smfc_ch, 0, buf0->phys);
+		ipu_cpmem_set_buffer(priv->smfc_ch, 1, buf1->phys);
 		break;
 
 	case V4L2_PIX_FMT_SBGGR16:
@@ -256,9 +255,17 @@ static void imx_smfc_setup_channel(struct imx_smfc_priv *priv)
 		burst_size = 4;
 		passthrough = true;
 		passthrough_bits = 16;
+		ipu_cpmem_set_resolution(priv->smfc_ch, image.rect.width, image.rect.height);
+		ipu_cpmem_set_stride(priv->smfc_ch, image.pix.bytesperline);
+		ipu_cpmem_set_buffer(priv->smfc_ch, 0, buf0->phys);
+		ipu_cpmem_set_buffer(priv->smfc_ch, 1, buf1->phys);
 		break;
 
 	default:
+		image.phys0 = buf0->phys;
+		image.phys1 = buf1->phys;
+		ipu_cpmem_set_image(priv->smfc_ch, &image);
+
 		burst_size = (outfmt->width & 0xf) ? 8 : 16;
 
 		/*

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
