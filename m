Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:47997 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751040AbdJLPnh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Oct 2017 11:43:37 -0400
Subject: Re: [PATCH v3 2/2] ARM: dts: tegra20: Add video decoder node
To: Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1507752381.git.digetx@gmail.com>
 <f58be69f6004393711c9ff3cb4b52aed33e2611a.1507752381.git.digetx@gmail.com>
 <0b6150a7-5b2b-ca4d-eb34-b6614e4833df@mentor.com>
 <81f39096-dc66-c98b-50f6-fc81ee1804ec@gmail.com> <20171012132543.GB4453@ulmo>
 <485a1192-8ef2-5ae1-a45f-d9b7167d8241@nvidia.com>
From: Dmitry Osipenko <digetx@gmail.com>
Message-ID: <22ad307f-99d6-0760-7cc0-adbca25ac7b5@gmail.com>
Date: Thu, 12 Oct 2017 18:43:32 +0300
MIME-Version: 1.0
In-Reply-To: <485a1192-8ef2-5ae1-a45f-d9b7167d8241@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12.10.2017 16:45, Jon Hunter wrote:
> 
> On 12/10/17 14:25, Thierry Reding wrote:
>> * PGP Signed by an unknown key
>>
>> On Thu, Oct 12, 2017 at 03:06:17PM +0300, Dmitry Osipenko wrote:
>>> Hello Vladimir,
>>>
>>> On 12.10.2017 10:43, Vladimir Zapolskiy wrote:
>>>> Hello Dmitry,
>>>>
>>>> On 10/11/2017 11:08 PM, Dmitry Osipenko wrote:
>>>>> Add a device node for the video decoder engine found on Tegra20.
>>>>>
>>>>> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
>>>>> ---
>>>>>  arch/arm/boot/dts/tegra20.dtsi | 17 +++++++++++++++++
>>>>>  1 file changed, 17 insertions(+)
>>>>>
>>>>> diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
>>>>> index 7c85f97f72ea..1b5d54b6c0cb 100644
>>>>> --- a/arch/arm/boot/dts/tegra20.dtsi
>>>>> +++ b/arch/arm/boot/dts/tegra20.dtsi
>>>>> @@ -249,6 +249,23 @@
>>>>>  		*/
>>>>>  	};
>>>>>  
>>>>> +	vde@6001a000 {
>>>>> +		compatible = "nvidia,tegra20-vde";
>>>>> +		reg = <0x6001a000 0x3D00    /* VDE registers */
>>>>> +		       0x40000400 0x3FC00>; /* IRAM region */
>>>>
>>>> this notation of a used region in IRAM is non-standard and potentially it
>>>> may lead to conflicts for IRAM resource between users.
>>>>
>>>> My proposal is to add a valid device tree node to describe an IRAM region
>>>> firstly, then reserve a subregion in it by using a new "iram" property.
>>>>
>>>
>>> The defined in DT IRAM region used by VDE isn't exactly correct, actually it
>>> should be much smaller. I don't know exactly what parts of IRAM VDE uses, for
>>> now it is just safer to assign the rest of the IRAM region to VDE.
>>>
>>> I'm not sure whether it really worthy to use a dynamic allocator for a single
>>> static allocation, but maybe it would come handy later.. Stephen / Jon /
>>> Thierry, what do you think?
>>
>> This sounds like a good idea. I agree that this currently doesn't seem
>> to be warranted, but consider what would happen if at some point we have
>> more devices requiring access to the IRAM. Spreading individual reg
>> properties all across the DT will make it very difficult to ensure they
>> don't overlap.
>>
>> Presumably the mmio-sram driver will check that pool don't overlap. Or
>> even if it doesn't it will make it a lot easier to verify because it's
>> all in the same DT node and then consumers only reference it.
>>
>> I like Vladimir's proposal. I also suspect that Rob may want us to stick
>> to a standardized way referencing such external memory.
> 
> FWIW I agree. Seems like a nice approach and describes the h/w accurately.
> 

Alright :)
