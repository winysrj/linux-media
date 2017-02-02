Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:55495 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750777AbdBBPGJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Feb 2017 10:06:09 -0500
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Peter Griffin <peter.griffin@linaro.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>
Subject: Re: [STLinux Kernel] [PATCH v6 02/10] ARM: dts: STiH410: add DELTA dt
 node
Date: Thu, 2 Feb 2017 15:06:00 +0000
Message-ID: <3659499c-08ac-396a-0c9f-2e18ee3ec1a1@st.com>
References: <1485965011-17388-1-git-send-email-hugues.fruchet@st.com>
 <1485965011-17388-3-git-send-email-hugues.fruchet@st.com>
 <20170201183716.GJ31988@griffinp-ThinkPad-X1-Carbon-2nd>
In-Reply-To: <20170201183716.GJ31988@griffinp-ThinkPad-X1-Carbon-2nd>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <E17D8E237C2D0D4EB50EEF489E5A0C0D@st.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Peter,

This is now fixed in v7.

Best regards,
Hugues.

On 02/01/2017 07:37 PM, Peter Griffin wrote:
> On Wed, 01 Feb 2017, Hugues Fruchet wrote:
>
>> This patch adds DT node for STMicroelectronics
>> DELTA V4L2 video decoder
>>
>> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
>> ---
>>  arch/arm/boot/dts/stih410.dtsi | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/stih410.dtsi b/arch/arm/boot/dts/stih410.dtsi
>> index 281a124..42e070c 100644
>> --- a/arch/arm/boot/dts/stih410.dtsi
>> +++ b/arch/arm/boot/dts/stih410.dtsi
>> @@ -259,5 +259,15 @@
>>  			clocks = <&clk_sysin>;
>>  			interrupts = <GIC_SPI 205 IRQ_TYPE_EDGE_RISING>;
>>  		};
>> +		delta0 {
>> +			compatible = "st,st-delta";
>> +			clock-names = "delta",
>> +				      "delta-st231",
>> +				      "delta-flash-promip";
>> +			clocks = <&clk_s_c0_flexgen CLK_VID_DMU>,
>> +				 <&clk_s_c0_flexgen CLK_ST231_DMU>,
>> +				 <&clk_s_c0_flexgen CLK_FLASH_PROMIP>;
>> +		};
>> +
>
> I think this node should be in stih407-family.dtsi file?
>
> regards,
>
> Peter.
>