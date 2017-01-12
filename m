Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:53653 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750996AbdALDXN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jan 2017 22:23:13 -0500
Subject: Re: [PATCH v3 00/24] i.MX Media Driver
To: Tim Harvey <tharvey@gateworks.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <CAJ+vNU2zU++Xam_UpDPfmSQhauhhS3_z8L-+ww6o-D9brWhiwA@mail.gmail.com>
CC: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        <mchehab@kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>,
        <nick@shmanahar.org>, <markus.heiser@darmarit.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        <laurent.pinchart+renesas@ideasonboard.com>, <bparrot@ti.com>,
        <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>,
        <sudipm.mukherjee@gmail.com>, <minghsiu.tsai@mediatek.com>,
        <tiffany.lin@mediatek.com>, <jean-christophe.trotin@st.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>, <robert.jarzmik@free.fr>,
        <songjun.wu@microchip.com>, <andrew-ct.chen@mediatek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        linux-media <linux-media@vger.kernel.org>,
        <devel@driverdev.osuosl.org>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <afe51f5f-03dd-4092-9ec0-297afb1453c7@mentor.com>
Date: Wed, 11 Jan 2017 19:22:54 -0800
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU2zU++Xam_UpDPfmSQhauhhS3_z8L-+ww6o-D9brWhiwA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tim,


On 01/11/2017 03:14 PM, Tim Harvey wrote:
>
> <snip>
>
> Hi Steve,
>
> I took a stab at testing this today on a gw51xx which has an adv7180
> hooked up as follows:
> - i2c3@0x20
> - 8bit data bus from DAT12 to DAT19, HSYNC, VSYNC, PIXCLK on CSI0 pads
> (CSI0_IPU1)
> - PWRDWN# on MX6QDL_PAD_CSI0_DATA_EN__GPIO5_IO20
> - IRQ# on MX6QDL_PAD_CSI0_DAT5__GPIO5_IO23
> - all three analog inputs available to off-board connector
>
> My patch to the imx6qdl-gw51xx dtsi is:

As long as you used the patch to imx6qdl-sabreauto.dtsti that adds
the adv7180 support as a guide, you should be ok here.

> <snip>
>
>
>
> On an IMX6Q I'm getting the following when the adv7180 module loads:
> [   12.862477] adv7180 2-0020: chip found @ 0x20 (21a8000.i2c)
> [   12.907767] imx-media: Registered subdev adv7180 2-0020
> [   12.907793] imx-media soc:media@0: Entity type for entity adv7180
> 2-0020 was not initialized!
> [   12.907867] imx-media: imx_media_create_link: adv7180 2-0020:0 ->
> ipu1_csi0_mux:1
>
> Is the warning that adv7180 was not initialized expected and or an issue?

Yeah it's still a bug in the adv7180 driver, needs fixing.

>
> Now that your driver is hooking into the current media framework, I'm
> not at all clear on how to link and configure the media entities.

It's all documented at Documentation/media/v4l-drivers/imx.rst.
Follow the SabreAuto pipeline setup example.



> <snip>
>
>
> Additionally I've found that on an IMX6S/IMX6DL we crash while
> registering the media-ic subdev's:
> [    3.975473] imx-media: Registered subdev ipu1_csi1_mux
> [    3.980921] imx-media: Registered subdev ipu1_csi0_mux
> [    4.003205] imx-media: Registered subdev ipu1_ic_prpenc
> [    4.025373] imx-media: Registered subdev ipu1_ic_prpvf
> [    4.037944] ------------[ cut here ]------------
> [    4.042571] Kernel BUG at c06717dc [verbose debug info unavailable]
> [    4.048845] Internal error: Oops - BUG: 0 [#1] SMP ARM
> [    4.053990] Modules linked in:
> [    4.057076] CPU: 1 PID: 1 Comm: swapper/0 Not tainted
> 4.9.0-rc6-00524-g84dad6e-dirty #446
> [    4.065260] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> ...
> [    4.296250] [<c0671780>] (v4l2_subdev_init) from [<c06fb02c>]
> (imx_ic_probe+0x94/0x1ac)
> [    4.304271] [<c06faf98>] (imx_ic_probe) from [<c05173d8>]
> (platform_drv_probe+0x54/0xb8)
> [    4.312373]  r9:c0d5e858 r8:00000000 r7:fffffdfb r6:c0e5dbf8
> r5:da603810 r4:c16738d8
> [    4.320129] [<c0517384>] (platform_drv_probe) from [<c0515978>]
> (driver_probe_device+0x20c/0x2c0)
> [    4.329010]  r7:c0e5dbf8 r6:00000000 r5:da603810 r4:c16738d8
> [    4.334681] [<c051576c>] (driver_probe_device) from [<c0515af4>]
> (__driver_attach+0xc8/0xcc)
> [    4.343129]  r9:c0d5e858 r8:00000000 r7:00000000 r6:da603844
> r5:c0e5dbf8 r4:da603810
> [    4.350889] [<c0515a2c>] (__driver_attach) from [<c0513adc>]
> (bus_for_each_dev+0x74/0xa8)
> [    4.359078]  r7:00000000 r6:c0515a2c r5:c0e5dbf8 r4:00000000
> [    4.364753] [<c0513a68>] (bus_for_each_dev) from [<c05151d4>]
> (driver_attach+0x20/0x28)
>
> I assume there is an iteration that needs a test on a missing pointer
> only available on chips with both IPU's or PRP

Yep, I only have quad boards here so I haven't gotten around to
testing on S/DL.

But it looks like I forgot to clear out the csi subdev pointer array before
passing it to imx_media_of_parse(). I think that might explain the OOPS
above. Try this patch:

diff --git a/drivers/staging/media/imx/imx-media-dev.c 
b/drivers/staging/media/imx/imx-media-dev.c
index 357654d..0cf2d61 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -379,7 +379,7 @@ static int imx_media_probe(struct platform_device *pdev)
  {
         struct device *dev = &pdev->dev;
         struct device_node *node = dev->of_node;
-       struct imx_media_subdev *csi[4];
+       struct imx_media_subdev *csi[4] = {0};
         struct imx_media_dev *imxmd;
         int ret;


Steve

