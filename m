Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:37270 "EHLO
        smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751656AbdF3DmP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 23:42:15 -0400
MIME-Version: 1.0
In-Reply-To: <20170629211957.uz7jijkuoxr2vohc@rob-hp-laptop>
References: <1498561654-14658-1-git-send-email-yong.deng@magewell.com>
 <1498561654-14658-3-git-send-email-yong.deng@magewell.com> <20170629211957.uz7jijkuoxr2vohc@rob-hp-laptop>
From: Chen-Yu Tsai <wens@csie.org>
Date: Fri, 30 Jun 2017 11:41:50 +0800
Message-ID: <CAGb2v66+xHR7xfBX_mPigZE_nvcRQfnpr4QAcKYEUhSGN7h61w@mail.gmail.com>
Subject: Re: [PATCH RFC 2/2] dt-bindings: add binding documentation for
 Allwinner CSI
To: Rob Herring <robh@kernel.org>
Cc: Yong Deng <yong.deng@magewell.com>, mchehab@kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Chen-Yu Tsai <wens@csie.org>, hans.verkuil@cisco.com,
        peter.griffin@linaro.org, hugues.fruchet@st.com,
        Krzysztof Kozlowski <krzk@kernel.org>, bparrot@ti.com,
        Arnd Bergmann <arnd@arndb.de>, jean-christophe.trotin@st.com,
        benjamin.gaignard@linaro.org, tiffany.lin@mediatek.com,
        kamil@wypas.org, kieran+renesas@ksquared.org.uk,
        andrew-ct.chen@mediatek.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 30, 2017 at 5:19 AM, Rob Herring <robh@kernel.org> wrote:
> On Tue, Jun 27, 2017 at 07:07:34PM +0800, Yong Deng wrote:
>> Add binding documentation for Allwinner CSI.
>
> For the subject:
>
> dt-bindings: media: Add Allwinner Camera Sensor Interface (CSI)
>
> "binding documentation" is redundant.
>
>>
>> Signed-off-by: Yong Deng <yong.deng@magewell.com>
>> ---
>>  .../devicetree/bindings/media/sunxi-csi.txt        | 51 ++++++++++++++++++++++
>>  1 file changed, 51 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/sunxi-csi.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/sunxi-csi.txt b/Documentation/devicetree/bindings/media/sunxi-csi.txt
>> new file mode 100644
>> index 0000000..770be0e
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/sunxi-csi.txt
>> @@ -0,0 +1,51 @@
>> +Allwinner V3s Camera Sensor Interface
>> +------------------------------
>> +
>> +Required properties:
>> +  - compatible: value must be "allwinner,sun8i-v3s-csi"
>> +  - reg: base address and size of the memory-mapped region.
>> +  - interrupts: interrupt associated to this IP
>> +  - clocks: phandles to the clocks feeding the CSI
>> +    * ahb: the CSI interface clock
>> +    * mod: the CSI module clock
>> +    * ram: the CSI DRAM clock
>> +  - clock-names: the clock names mentioned above
>> +  - resets: phandles to the reset line driving the CSI
>> +
>> +- ports: A ports node with endpoint definitions as defined in
>> +  Documentation/devicetree/bindings/media/video-interfaces.txt. The
>> +  first port should be the input endpoints, the second one the outputs
>
> Is there more than one endpoint for each port? If so, need to define
> that numbering too.

It is possible to have multiple camera sensors connected to the same
bus. Think front and back cameras on a cell phone or tablet.

I don't think any kind of numbering makes much sense though. The
system is free to use just one sensor at a time, or use many with
some time multiplexing scheme. What might matter to the end user
is where the camera is placed. But using the position or orientation
as a numbering scheme might not work well either. Someone may end
up using two sensors with the same orientation for stereoscopic
vision.

>
>> +
>> +Example:
>> +
>> +     csi1: csi@01cb4000 {
>> +             compatible = "allwinner,sun8i-v3s-csi";
>> +             reg = <0x01cb4000 0x1000>;

Yong, the address range size is 0x4000, including the CCI (I2C)
controller at offset 0x3000. You should also consider this in
the device tree binding, and the driver.

ChenYu

>> +             interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
>> +             clocks = <&ccu CLK_BUS_CSI>,
>> +                      <&ccu CLK_CSI1_SCLK>,
>> +                      <&ccu CLK_DRAM_CSI>;
>> +             clock-names = "ahb", "mod", "ram";
>> +             resets = <&ccu RST_BUS_CSI>;
>> +
>> +             port {
>> +                     #address-cells = <1>;
>> +                     #size-cells = <0>;
>> +
>> +                     /* Parallel bus endpoint */
>> +                     csi1_0: endpoint@0 {
>> +                             reg = <0>;
>
> Don't need this and everything associated with it for a single endpoint.
>
>> +                             remote = <&adv7611_1>;
>> +                             bus-width = <16>;
>> +                             data-shift = <0>;
>> +
>> +                             /* If hsync-active/vsync-active are missing,
>> +                                embedded BT.656 sync is used */
>> +                             hsync-active = <0>; /* Active low */
>> +                             vsync-active = <0>; /* Active low */
>> +                             data-active = <1>;  /* Active high */
>> +                             pclk-sample = <1>;  /* Rising */
>> +                     };
>> +             };
>> +     };
>> +
>> --
>> 1.8.3.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe devicetree" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
