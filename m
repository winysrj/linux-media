Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35915 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752493AbdCOStG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 14:49:06 -0400
Subject: Re: [PATCH v5 07/39] ARM: dts: imx6qdl-sabrelite: remove erratum
 ERR006687 workaround
To: Fabio Estevam <festevam@gmail.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <1489121599-23206-8-git-send-email-steve_longerbeam@mentor.com>
 <9f5d0ac4-0602-c729-5c00-1d9ef49247c1@boundarydevices.com>
 <CAOMZO5BNrSEyrbWbCBCbsy4yTrh4AHfk2Too0qHuffxqUCgADg@mail.gmail.com>
Cc: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        mchehab@kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Nick Dyer <nick@shmanahar.org>, markus.heiser@darmarit.de,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        bparrot@ti.com, Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        minghsiu.tsai@mediatek.com, Tiffany Lin <tiffany.lin@mediatek.com>,
        Jean-Christophe TROTIN <jean-christophe.trotin@st.com>,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        shuah@kernel.org, sakari.ailus@linux.intel.com,
        Pavel Machek <pavel@ucw.cz>, devel@driverdev.osuosl.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        linux-media <linux-media@vger.kernel.org>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <16767ed6-bc06-790c-1830-18439c977a37@gmail.com>
Date: Wed, 15 Mar 2017 11:49:00 -0700
MIME-Version: 1.0
In-Reply-To: <CAOMZO5BNrSEyrbWbCBCbsy4yTrh4AHfk2Too0qHuffxqUCgADg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/10/2017 11:17 AM, Fabio Estevam wrote:
> On Fri, Mar 10, 2017 at 3:59 PM, Troy Kisky
> <troy.kisky@boundarydevices.com> wrote:
>> On 3/9/2017 8:52 PM, Steve Longerbeam wrote:
>>> There is a pin conflict with GPIO_6. This pin functions as a power
>>> input pin to the OV5642 camera sensor, but ENET uses it as the h/w
>>> workaround for erratum ERR006687, to wake-up the ARM cores on normal
>>> RX and TX packet done events. So we need to remove the h/w workaround
>>> to support the OV5642. The result is that the CPUidle driver will no
>>> longer allow entering the deep idle states on the sabrelite.
>>>
>>> This is a partial revert of
>>>
>>> commit 6261c4c8f13e ("ARM: dts: imx6qdl-sabrelite: use GPIO_6 for FEC
>>>                       interrupt.")
>>> commit a28eeb43ee57 ("ARM: dts: imx6: tag boards that have the HW workaround
>>>                       for ERR006687")
>>>
>>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>>> ---
>>>  arch/arm/boot/dts/imx6qdl-sabrelite.dtsi | 4 ----
>>>  1 file changed, 4 deletions(-)
>>>
>>> diff --git a/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi b/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
>>> index 8413179..89dce27 100644
>>> --- a/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
>>> +++ b/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
>>> @@ -270,9 +270,6 @@
>>>       txd1-skew-ps = <0>;
>>>       txd2-skew-ps = <0>;
>>>       txd3-skew-ps = <0>;
>>
>> How about
>>
>> +#if !IS_ENABLED(CONFIG_VIDEO_OV5642)
>
> Or maybe just create a new device tree for using the camera, like
> imx6q-sabrelite-camera.dts.
>
> This way we can keep the FEC erratum for the existing sabrelite dtb's.

Is it really necessary to keep the erratum in sabrelite dts? Because the
sabrelite is a _reference_ platform, vendors use this dts as a working
example of how to configure their imx6-based hardware. So as a working
example, it should contain as much example hardware config as possible
as a guide. If a vendor does not require OV5642 support and requires
the lower power consumption that the erratum workaround provides, they
can refer to other example imx6 dts files which still implement the
erratum, or look at the git log of this file.

Steve
