Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:58130 "EHLO
        aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752667AbdC3Jcb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 05:32:31 -0400
Subject: Re: [PATCHv5 11/11] arm: sti: update sti-cec for CEC notifier support
To: Patrice CHOTARD <patrice.chotard@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <20170329141543.32935-1-hverkuil@xs4all.nl>
 <20170329141543.32935-12-hverkuil@xs4all.nl>
 <CA+M3ks442wftNR8+dctdSkKMCPSw9Rd2CH5UG-VEP7XySGjCjw@mail.gmail.com>
 <c29adefb-13e6-e723-eb96-3b0049b39ddd@st.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "moderated list:ARM/S5P EXYNOS AR..."
        <linux-samsung-soc@vger.kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <a966a94d-8031-88ec-f931-d521fa74b9a7@cisco.com>
Date: Thu, 30 Mar 2017 11:32:27 +0200
MIME-Version: 1.0
In-Reply-To: <c29adefb-13e6-e723-eb96-3b0049b39ddd@st.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/30/2017 11:30 AM, Patrice CHOTARD wrote:
> Hi Benjamin
> 
> On 03/30/2017 09:41 AM, Benjamin Gaignard wrote:
>> + Patrice for sti DT
> 
> In order to be coherent with all previous STi DT patches,
> 
> can you update the commit message with "ARM: dts: STiH410: update 
> sti-cec for CEC notifier support"

Done.

Regards,

	Hans

> 
> Thanks
> 
> Patrice
> 
>>
>> 2017-03-29 16:15 GMT+02:00 Hans Verkuil <hverkuil@xs4all.nl>:
>>> From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
>>>
>>> To use CEC notifier sti CEC driver needs to get phandle
>>> of the hdmi device.
>>>
>>> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>> CC: devicetree@vger.kernel.org
>>> ---
>>>  arch/arm/boot/dts/stih407-family.dtsi | 12 ------------
>>>  arch/arm/boot/dts/stih410.dtsi        | 13 +++++++++++++
>>>  2 files changed, 13 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/arch/arm/boot/dts/stih407-family.dtsi b/arch/arm/boot/dts/stih407-family.dtsi
>>> index d753ac36788f..044184580326 100644
>>> --- a/arch/arm/boot/dts/stih407-family.dtsi
>>> +++ b/arch/arm/boot/dts/stih407-family.dtsi
>>> @@ -742,18 +742,6 @@
>>>                                  <&clk_s_c0_flexgen CLK_ETH_PHY>;
>>>                 };
>>>
>>> -               cec: sti-cec@094a087c {
>>> -                       compatible = "st,stih-cec";
>>> -                       reg = <0x94a087c 0x64>;
>>> -                       clocks = <&clk_sysin>;
>>> -                       clock-names = "cec-clk";
>>> -                       interrupts = <GIC_SPI 140 IRQ_TYPE_NONE>;
>>> -                       interrupt-names = "cec-irq";
>>> -                       pinctrl-names = "default";
>>> -                       pinctrl-0 = <&pinctrl_cec0_default>;
>>> -                       resets = <&softreset STIH407_LPM_SOFTRESET>;
>>> -               };
>>> -
>>>                 rng10: rng@08a89000 {
>>>                         compatible      = "st,rng";
>>>                         reg             = <0x08a89000 0x1000>;
>>> diff --git a/arch/arm/boot/dts/stih410.dtsi b/arch/arm/boot/dts/stih410.dtsi
>>> index 3c9672c5b09f..21fe72b183d8 100644
>>> --- a/arch/arm/boot/dts/stih410.dtsi
>>> +++ b/arch/arm/boot/dts/stih410.dtsi
>>> @@ -281,5 +281,18 @@
>>>                                  <&clk_s_c0_flexgen CLK_ST231_DMU>,
>>>                                  <&clk_s_c0_flexgen CLK_FLASH_PROMIP>;
>>>                 };
>>> +
>>> +               sti-cec@094a087c {
>>> +                       compatible = "st,stih-cec";
>>> +                       reg = <0x94a087c 0x64>;
>>> +                       clocks = <&clk_sysin>;
>>> +                       clock-names = "cec-clk";
>>> +                       interrupts = <GIC_SPI 140 IRQ_TYPE_NONE>;
>>> +                       interrupt-names = "cec-irq";
>>> +                       pinctrl-names = "default";
>>> +                       pinctrl-0 = <&pinctrl_cec0_default>;
>>> +                       resets = <&softreset STIH407_LPM_SOFTRESET>;
>>> +                       hdmi-phandle = <&sti_hdmi>;
>>> +               };
>>>         };
>>>  };
>>> --
>>> 2.11.0
>>>
>>
>>
>>
> 
