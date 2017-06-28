Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:45492 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751234AbdF1Kuu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Jun 2017 06:50:50 -0400
Subject: Re: [PATCH v1 1/6] DT bindings: add bindings for ov965x camera
 module
To: "H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Hugues FRUCHET <hugues.fruchet@st.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick FERTRE <yannick.fertre@st.com>,
        Discussions about the Letux Kernel
        <letux-kernel@openphoenux.org>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <5bcc7ec0-4ae5-3703-3cee-ed644eef710a@samsung.com>
Date: Wed, 28 Jun 2017 12:50:39 +0200
MIME-version: 1.0
In-reply-to: <6F68CD33-70E6-47C1-9E89-5E2AA776879F@goldelico.com>
Content-type: text/plain; charset="utf-8"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <1498143942-12682-1-git-send-email-hugues.fruchet@st.com>
        <1498143942-12682-2-git-send-email-hugues.fruchet@st.com>
        <D5629236-95D8-45B6-9719-E8B9796FEC90@goldelico.com>
        <64e3005d-31df-71f2-762b-2c1b1152fc2d@st.com>
        <5cd25a47-f3be-8c40-3940-29f26a245076@kernel.org>
        <39501C78-7B81-4803-94C1-25DFA06EA526@goldelico.com>
        <e2a9df8b-00f8-ae36-f4f3-63dcc98dea50@kernel.org>
        <CGME20170628091334epcas5p2071ae52aa3f9312b1099e37ffac20eb1@epcas5p2.samsung.com>
        <6F68CD33-70E6-47C1-9E89-5E2AA776879F@goldelico.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/28/2017 11:12 AM, H. Nikolaus Schaller wrote:
>> Am 28.06.2017 um 00:57 schrieb Sylwester Nawrocki <snawrocki@kernel.org>:
>> On 06/27/2017 07:48 AM, H. Nikolaus Schaller wrote:
>>>> Am 26.06.2017 um 22:04 schrieb Sylwester Nawrocki <snawrocki@kernel.org>:
>>>> On 06/26/2017 12:35 PM, Hugues FRUCHET wrote:
>>>>>> What I am missing to support the GTA04 camera is the control of the optional "vana-supply".
>>>>>> So the driver does not power up the camera module when needed and therefore probing fails.
>>>>>>
>>>>>>     - vana-supply: a regulator to power up the camera module.
>>>>>>
>>>>>> Driver code is not complex to add:
>>>>
>>>>> Yes, I saw it in your code, but as I don't have any programmable power
>>>>> supply on my setup, I have not pushed this commit.
>>>>
>>>> Since you are about to add voltage supplies to the DT binding I'd suggest
>>>> to include all three voltage supplies of the sensor chip. Looking at the OV9650
>>>> and the OV9655 datasheet there are following names used for the voltage supply
>>>> pins:
>>>>
>>>> AVDD - Analog power supply,
>>>> DVDD - Power supply for digital core logic,
>>>> DOVDD - Digital power supply for I/O.
>>>
>>> The latter two are usually not independently switchable from the SoC power
>>> the module is connected to.
>>>
>>> And sometimes DVDD and DOVDD are connected together.
>>>
>>> So the driver can't make much use of knowing or requesting them because the
>>> 1.8V supply is always active, even during suspend.
>>>
>>>>
>>>> I doubt the sensor can work without any of these voltage supplies, thus
>>>> regulator_get_optional() should not be used. I would just use the regulator
>>>> bulk API to handle all three power supplies.
>>>
>>> The digital part works with AVDD turned off. So the LDO supplying AVDD should
>>> be switchable to save power (&vaux3 on the GTA04 device).>
>>> But not all designs can switch it off. Hence the idea to define it as an
>>> /optional/ regulator. If it is not defined by DT, the driver simply assumes
>>> it is always powered on.
>>
>> I didn't say we can't define regulator supply properties as optional in the DT
>> binding.  If we define them as such and any of these *-supply properties is
>> missing in DT with regulator_get() the regulator core will use dummy regulator
>> for that particular voltage supply.  While with regulator_get_optional()
>> -ENODEV is returned when the regulator cannot be found.
> 
> Ah, ok. I see.
> 
> I had thought that it is the right thing to do like devm_gpiod_get_optional().
> 
> That one it is described as:
> 
> "* This is equivalent to gpiod_get(), except that when no GPIO was assigned to
>   * the requested function it will return NULL. This is convenient for drivers
>   * that need to handle optional GPIOs."
> 
> Seems to be inconsistent definition of what "optional" means.

Indeed, this commit explains it further:

commit de1dd9fd2156874b45803299b3b27e65d5defdd9
regulator: core: Provide hints to the core about optional supplies

> So we indeed should use devm_regulator_get() in this case. Thanks for > pointing out!

>>> So in summary we only need AVDD switched for the GTA04 - but it does not
>>> matter if the others are optional properties. We would not use them.
>>>
>>> It does matter if they are mandatory because it adds DT complexity (size
>>> and processing) without added function.
>>
>> We should not be defining DT binding only with selected use cases/board
>> designs in mind.  IMO all three voltage supplies should be listed in the
>> binding, presumably all can be made optional, with an assumption that when
>> the property is missing selected pin is hooked up to a fixed regulator.
> 
> Ok, then it should just be defined in the bindings but not used by 
> the driver?

Yes, I think so. So we have a possibly complete binding right from the 
beginning. I someone needs handling other supplies than AVDD they could
update the driver in future.


Regards,
Sylwester
