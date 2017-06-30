Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751613AbdF3QGS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 12:06:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAGb2v66+xHR7xfBX_mPigZE_nvcRQfnpr4QAcKYEUhSGN7h61w@mail.gmail.com>
References: <1498561654-14658-1-git-send-email-yong.deng@magewell.com>
 <1498561654-14658-3-git-send-email-yong.deng@magewell.com>
 <20170629211957.uz7jijkuoxr2vohc@rob-hp-laptop> <CAGb2v66+xHR7xfBX_mPigZE_nvcRQfnpr4QAcKYEUhSGN7h61w@mail.gmail.com>
From: Rob Herring <robh@kernel.org>
Date: Fri, 30 Jun 2017 11:05:55 -0500
Message-ID: <CAL_JsqK5n966u9dfBiAxphURghetxu5Cfkj03oNafAFT4NO10A@mail.gmail.com>
Subject: Re: [PATCH RFC 2/2] dt-bindings: add binding documentation for
 Allwinner CSI
To: Chen-Yu Tsai <wens@csie.org>
Cc: Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Peter Griffin <peter.griffin@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Benoit Parrot <bparrot@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        tiffany lin <tiffany.lin@mediatek.com>, kamil@wypas.org,
        kieran+renesas@ksquared.org.uk,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?=
        <andrew-ct.chen@mediatek.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 29, 2017 at 10:41 PM, Chen-Yu Tsai <wens@csie.org> wrote:
> On Fri, Jun 30, 2017 at 5:19 AM, Rob Herring <robh@kernel.org> wrote:
>> On Tue, Jun 27, 2017 at 07:07:34PM +0800, Yong Deng wrote:
>>> Add binding documentation for Allwinner CSI.
>>
>> For the subject:
>>
>> dt-bindings: media: Add Allwinner Camera Sensor Interface (CSI)
>>
>> "binding documentation" is redundant.
>>
>>>
>>> Signed-off-by: Yong Deng <yong.deng@magewell.com>
>>> ---
>>>  .../devicetree/bindings/media/sunxi-csi.txt        | 51 ++++++++++++++++++++++
>>>  1 file changed, 51 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/media/sunxi-csi.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/media/sunxi-csi.txt b/Documentation/devicetree/bindings/media/sunxi-csi.txt
>>> new file mode 100644
>>> index 0000000..770be0e
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/media/sunxi-csi.txt
>>> @@ -0,0 +1,51 @@
>>> +Allwinner V3s Camera Sensor Interface
>>> +------------------------------
>>> +
>>> +Required properties:
>>> +  - compatible: value must be "allwinner,sun8i-v3s-csi"
>>> +  - reg: base address and size of the memory-mapped region.
>>> +  - interrupts: interrupt associated to this IP
>>> +  - clocks: phandles to the clocks feeding the CSI
>>> +    * ahb: the CSI interface clock
>>> +    * mod: the CSI module clock
>>> +    * ram: the CSI DRAM clock
>>> +  - clock-names: the clock names mentioned above
>>> +  - resets: phandles to the reset line driving the CSI
>>> +
>>> +- ports: A ports node with endpoint definitions as defined in
>>> +  Documentation/devicetree/bindings/media/video-interfaces.txt. The
>>> +  first port should be the input endpoints, the second one the outputs
>>
>> Is there more than one endpoint for each port? If so, need to define
>> that numbering too.
>
> It is possible to have multiple camera sensors connected to the same
> bus. Think front and back cameras on a cell phone or tablet.
>
> I don't think any kind of numbering makes much sense though. The
> system is free to use just one sensor at a time, or use many with
> some time multiplexing scheme. What might matter to the end user
> is where the camera is placed. But using the position or orientation
> as a numbering scheme might not work well either. Someone may end
> up using two sensors with the same orientation for stereoscopic
> vision.

Well, for muxing, you need to no which endpoint is which mux input,
but if the muxing is at the board level, then that's really outside
this binding. For stereoscopic, don't you need both sensors to work at
the same time (i.e. not muxed). That would be multiple ports.

When would you have 2 output endpoints though? That could be to
different processing blocks, but those connections are internal,
fixed, and known. So you should document the numbering in that case.

Rob
