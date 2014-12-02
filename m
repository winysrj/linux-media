Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:41981 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbaLBNMB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Dec 2014 08:12:01 -0500
Message-ID: <547DBA99.1010703@mentor.com>
Date: Tue, 2 Dec 2014 15:11:53 +0200
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
MIME-Version: 1.0
To: Andy Yan <andy.yan@rock-chips.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Wolfram Sang <wsa@the-dreams.de>
CC: Shawn Guo <shawn.guo@linaro.org>, <devicetree@vger.kernel.org>,
	<linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH 1/3] staging: imx-drm: document internal HDMI I2C master
 controller DT binding
References: <1416073759-19939-1-git-send-email-vladimir_zapolskiy@mentor.com>		 <1416073759-19939-2-git-send-email-vladimir_zapolskiy@mentor.com>		 <547C8113.3050100@mentor.com> <1417446703.4624.18.camel@pengutronix.de>	 <547C8B9E.8050605@mentor.com> <1417450979.4624.23.camel@pengutronix.de> <547D5DE2.2040704@rock-chips.com>
In-Reply-To: <547D5DE2.2040704@rock-chips.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

thank you for joining the discussion.

On 02.12.2014 08:36, Andy Yan wrote:
> Hi Vladimir:
> 
>   I am working on convert imx-hdmi to dw_hdmi now:
>   https://lkml.org/lkml/2014/12/1/190
>   I also have a plan to use  the internal HDMI I2C master under the I2c 
> framework,
> and I also have a patch to do this work. So glad to see your work.
>   Please also Cc me<and.yan@rock-chips.com> and Zubair.Kakakhel@imgtec.com,
> maybe Zubair also have interests on your future patch.
> On 2014年12月02日 00:22, Philipp Zabel wrote:
>> Hi Vladimir,
>>
>> [Added Andy Yan to Cc:, because imx-hdmi->dw-hdmi]
>>
>> Am Montag, den 01.12.2014, 17:39 +0200 schrieb Vladimir Zapolskiy:
>>> On 01.12.2014 17:11, Philipp Zabel wrote:
>>>> Am Montag, den 01.12.2014, 16:54 +0200 schrieb Vladimir Zapolskiy:
>>>>> Hi Philipp and Shawn,
>>>>>
>>>>> On 15.11.2014 19:49, Vladimir Zapolskiy wrote:
>>>>>> Provide information about how to bind internal iMX6Q/DL HDMI DDC I2C
>>>>>> master controller. The property is set as optional one, because iMX6
>>>>>> HDMI DDC bus may be represented by one of general purpose I2C busses
>>>>>> found on SoC.
>>>>>>
>>>>>> Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
>>>>>> Cc: Wolfram Sang <wsa@the-dreams.de>
>>>>>> Cc: Philipp Zabel <p.zabel@pengutronix.de>
>>>>>> Cc: Shawn Guo <shawn.guo@linaro.org>
>>>>>> Cc: devicetree@vger.kernel.org
>>>>>> Cc: linux-media@vger.kernel.org
>>>>>> Cc: linux-arm-kernel@lists.infradead.org
>>>>>> Cc: linux-i2c@vger.kernel.org
>>>>>> ---
>>>>>>   Documentation/devicetree/bindings/staging/imx-drm/hdmi.txt |   10 +++++++++-
>>>>>>   1 file changed, 9 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/Documentation/devicetree/bindings/staging/imx-drm/hdmi.txt b/Documentation/devicetree/bindings/staging/imx-drm/hdmi.txt
>>>>>> index 1b756cf..43c8924 100644
>>>>>> --- a/Documentation/devicetree/bindings/staging/imx-drm/hdmi.txt
>>>>>> +++ b/Documentation/devicetree/bindings/staging/imx-drm/hdmi.txt
>>>>>> @@ -10,6 +10,8 @@ Required properties:
>>>>>>    - #address-cells : should be <1>
>>>>>>    - #size-cells : should be <0>
>>>>>>    - compatible : should be "fsl,imx6q-hdmi" or "fsl,imx6dl-hdmi".
>>>>>> +   If internal HDMI DDC I2C master controller is supposed to be used,
>>>>>> +   then "simple-bus" should be added to compatible value.
>>>>>>    - gpr : should be <&gpr>.
>>>>>>      The phandle points to the iomuxc-gpr region containing the HDMI
>>>>>>      multiplexer control register.
>>>>>> @@ -22,6 +24,7 @@ Required properties:
>>>>>>   
>>>>>>   Optional properties:
>>>>>>    - ddc-i2c-bus: phandle of an I2C controller used for DDC EDID probing
>>>>>> + - ddc: internal HDMI DDC I2C master controller
>>>>>>   
>>>>>>   example:
>>>>>>   
>>>>>> @@ -32,7 +35,7 @@ example:
>>>>>>           hdmi: hdmi@0120000 {
>>>>>>                   #address-cells = <1>;
>>>>>>                   #size-cells = <0>;
>>>>>> -                compatible = "fsl,imx6q-hdmi";
>>>>>> +                compatible = "fsl,imx6q-hdmi", "simple-bus";
>>>>>>                   reg = <0x00120000 0x9000>;
>>>>>>                   interrupts = <0 115 0x04>;
>>>>>>                   gpr = <&gpr>;
>>>>>> @@ -40,6 +43,11 @@ example:
>>>>>>                   clock-names = "iahb", "isfr";
>>>>>>                   ddc-i2c-bus = <&i2c2>;
>>>>>>   
>>>>>> +                hdmi_ddc: ddc {
>>>>>> +                        compatible = "fsl,imx6q-hdmi-ddc";
>>>>>> +                        status = "disabled";
>>>>>> +                };
>>>>>> +
>>>>>>                   port@0 {
>>>>>>                           reg = <0>;
>>>>>>   
>>>>>>
>>>>> knowing in advance that I2C framework lacks a graceful support of non
>>>>> fully compliant I2C devices, do you have any objections to the proposed
>>>>> iMX HDMI DTS change?
>>>> I'm not sure about this. Have you seen "drm: Decouple EDID parsing from
>>>> I2C adapter"? I feel like in the absence of a ddc-i2c-bus property the
>>>> imx-hdmi/dw-hdmi driver should try to use the internal HDMI DDC I2C
>>>> master controller, bypassing the I2C framework altogether.
>>>>
>>> My idea is exactly not to bypass the I2C framework, briefly the
>>> rationale is that
>>> * it allows to reuse I2C UAPI/tools naturally applied to the internal
>>> iMX HDMI DDC bus,
>>> * it allows to use iMX HDMI DDC bus as an additional feature-limited I2C
>>> bus on SoC (who knows, I absolutely won't be surprised, if anyone needs
>>> it on practice),
>>> * if an HDMI controller supports an external I2C bus, the integration
>>> with HDMI DDC bus driver based on I2C framework is seamless.
>>>
>>> However I agree that the selected approach may look odd, the question is
>>> if the oddness comes from the technical side or from the fact that
>>> nobody has done it before this way.
>>>
>>> I'm open to any critique, if the proposal of creating an I2C bus from
>>> HDMI DDC bus is lame, then I suppose the shared iMX HDMI DDC bus driver
>>> should be converted to something formless and internally used by
>>> imx-hdmi. The negative side-effects of such a change from my point of
>>> view are
>>> * more or less natural modularity is lost,
>>> * a number of I2C framework API/functions should be copy-pasted to the
>>> updated HDMI DDC bus driver to support a subset of I2C read/write
>>> transactions.
>> If Wolfram is happy to accomodate such feature limited, 'I2C master'
>> devices in i2c/drivers/busses in principle, I won't disagree.
>>
>> But then it should be abstracted properly. The dw-hdmi-tx core on i.MX6
>> has the DDC I2C master register space at 0x7e00 - 0x7e12. What are the
>> offsets on the Rockchip version? If the "simple-bus" compatible is to be
>> set on the hdmi driver, the ddc driver should do its own register
>> access, and therefore needs a reg property. I suspect for the ddc-i2cm
>> we should get away with a common compatible like "snps,dw-hdmi-i2c".
>>
>> 	hdmi: hdmi@120000 {
>> 		/* ... */
>> 		compatible = "fsl,imx6q-hdmi", "snps,dw-hdmi";
>> 		ddc-i2c-bus = <&hdmi_ddc>;
>>
>> 		hdmi_ddc: i2c@127e00 {
>> 			compatible = "snps,dw-hdmi-i2c";
>> 			reg = <0x1207e00 0x13>
>> 		};
>>
>> 		/* could add phy-i2cm, cec, ... here */
>> 	};
>>
>> Also there's an i2c bus for communication with the phy at 0x3020 -
>> 0x3032, should that be handled in a similar way, then?
> 
>     Rockchip RK3288 has the same DDC I2C master and phy i2c master
>     register offset as imx hdmi.

Good to know, I was not aware of it. Definitely it should be supported
as well.

>      what my suggestion is: make the ddc-i2c-bus property optional, if 
> the dw_hdmi driver
>     can't found the ddc-i2c-bus node, then use the internal i2cm:
>         ddc_node = of_parse_phandle(np, "ddc-i2c-bus", 0);
>          if (ddc_node) {
>                  hdmi->ddc = of_find_i2c_adapter_by_node(ddc_node);
>                  of_node_put(ddc_node);
>                  if (!hdmi->ddc) {
>                          dev_dbg(hdmi->dev, "failed to read ddc node\n");
>                          return -EPROBE_DEFER;
>                  }
> 
>          } else {
>                  hdmi->ddc = dw_hdmi_ddc_adapter_register(hdmi).
>          }
> 
>          and we can have a file put with dw_hdmi.c in a same dir, which
>         implement  standard i2c adapter interface .
>        I found that other hdmi platform such as msm(/msm/hdmi/hdmi_i2c.c) ,
>        radeon(radeon_i2c.c) also do like this

Thank you for references.

I see that msm and a number of other DRM device drivers (radeon,
nouveau, i915, gma500) quite resemble the situation, now I'm convinced
that the same should be done for iMX6/RK3288 HDMI driver. In background
I'll try to review all out of i2c/busses/* registered i2c adapters, may
be there is something in common between all of them.

I'll prepare the change of the HDMI DDC support for review (will be able
to test it only on iMX6), Wolfram, please skip from your consideration
the published version of the i2c bus driver.

Wolfram, by the way is I2C_CLASS_DDC adapter class in operational use or
deprecated?

> 
>>
>> Do we need to make the hdmi driver a proper interrupt controller? At
>> least the two i2c masters have two interrupts each, "done" and "error".
>>
>> regards
>> Philipp
>>


--
With best wishes,
Vladimir
