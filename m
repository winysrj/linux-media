Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35205 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750729AbdAPRNn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jan 2017 12:13:43 -0500
Subject: Re: [PATCH v3 01/24] [media] dt-bindings: Add bindings for i.MX media
 driver
To: Philipp Zabel <p.zabel@pengutronix.de>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-2-git-send-email-steve_longerbeam@mentor.com>
 <1484308551.31475.23.camel@pengutronix.de>
 <e609fd03-a546-330c-ec89-de1844d1b46f@gmail.com>
 <1484568579.8415.91.camel@pengutronix.de>
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
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <3fbe85f8-ddc2-2299-ac9d-47d07485c162@gmail.com>
Date: Mon, 16 Jan 2017 09:13:39 -0800
MIME-Version: 1.0
In-Reply-To: <1484568579.8415.91.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/16/2017 04:09 AM, Philipp Zabel wrote:
> On Fri, 2017-01-13 at 11:03 -0800, Steve Longerbeam wrote:
>> On 01/13/2017 03:55 AM, Philipp Zabel wrote:
>>> Am Freitag, den 06.01.2017, 18:11 -0800 schrieb Steve Longerbeam:
>>>> Add bindings documentation for the i.MX media driver.
>>>>
>>>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>>>> ---
>>>>    Documentation/devicetree/bindings/media/imx.txt | 57 +++++++++++++++++++++++++
>>>>    1 file changed, 57 insertions(+)
>>>>    create mode 100644 Documentation/devicetree/bindings/media/imx.txt
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/media/imx.txt b/Documentation/devicetree/bindings/media/imx.txt
>>>> new file mode 100644
>>>> index 0000000..254b64a
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/media/imx.txt
>>>> @@ -0,0 +1,57 @@
>>>> +Freescale i.MX Media Video Devices
>>>> +
>>>> +Video Media Controller node
>>>> +---------------------------
>>>> +
>>>> +This is the parent media controller node for video capture support.
>>>> +
>>>> +Required properties:
>>>> +- compatible : "fsl,imx-media";
>>> Would you be opposed to calling this "capture-subsystem" instead of
>>> "imx-media"? We already use "fsl,imx-display-subsystem" and
>>> "fsl,imx-gpu-subsystem" for the display and GPU compound devices.
>> sure. Some pie-in-the-sky day when DRM and media are unified,
>> there could be a single device that handles them all,
> Indeed :)
>
>>   but for now
>> I'm fine with "fsl,capture-subsystem".
> Actually, I meant fsl,imx-capture-subsystem.

right, I caught my error and that is the name chosen.

>   fsl,imx-media-subsystem
> would be fine, too. Either way, I'll be happy if it looks similar to the
> other two.
>
> [...]
>>> This is a clever method to get better frame timestamps. Too bad about
>>> the routing requirements. Can this be used on Nitrogen6X?
>> Absolutely, this support just needs use of the input-capture channels in the
>> imx GPT. I still need to submit the patch to the imx-gpt driver that adds an
>> input capture API, so at this point fsl,input-capture-channel has no effect,
>> but it does work (tested on SabreAuto).
> Nice.
>
> [...]
>>>> +Required properties:
>>>> +- compatible	: "fsl,imx6-mipi-csi2";
>>> I think this should get an additional "snps,dw-mipi-csi2" compatible,
>>> since the only i.MX6 specific part is the bolted-on IPU2CSI gasket.
>> right, minus the gasket it's a Synopsys core. I'll add that compatible flag.
>> Or should wait until the day this subdev is exported for general use, after
>> pulling out the gasket specifics?
> It can be added right away.

ok, I will add.

Steve

>
>>>> +- reg           : physical base address and length of the register set;
>>>> +- clocks	: the MIPI CSI-2 receiver requires three clocks: hsi_tx
>>>> +                  (the DPHY clock), video_27m, and eim_sel;
>>> Note that hsi_tx is incorrectly named. CCGR3[CG8] just happens to be the
>>> shared gate bit that gates the HSI clocks as well as the MIPI
>>> "ac_clk_125m", "cfg_clk", "ips_clk", and "pll_refclk" inputs to the mipi
>>> csi-2 core, but we are missing shared gate clocks in the clock tree for
>>> these.
>> Yes, so many clocks for the MIPI core. Why so many? I would think
>> there would need to be at most three: a clock for the MIPI CSI-2 core
>> and HSI core, and a clock for the D-PHY (oh and maybe a clock for an
>> M-PHY if there is one). I have no clue what all these other clocks are.
>> But anyway, a single gating bit, CCGR3[CG8], seems to enable them all.
> I would imagine the CSI-2 core has a high-speed clock input from the
> D-PHY for serial input, an APB clock for register access (ips_clk), and
> a pixel clock input for the parallel output (pixel_clk), at least.
> The D-PHY will have a PLL reference input (pll_refclk?) and probably its
> own register clock (cfg_clk?).
>
> I've looked at the MIPI DSI chapter, and it looks like ac_clk_125m is
> used for DSI only.
>
>>> Both cfg_clk and pll_refclk are sourced from video_27m, so "cfg" ->
>>> video_27m seems fine.
>>> But I don't get "dphy".
>> I presume it's the clock for the D-PHY.
>>
>>>    Which input clock would that correspond to?
>>> "pll_refclk?"
>> the mux at CDCDR says it comes from PLL3_120M, or PLL2_PFD2.
> I think that makes sense.
>
> regards
> Philipp
>

