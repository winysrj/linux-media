Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:54806 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751306AbdISKmj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 06:42:39 -0400
Received: by mail-lf0-f43.google.com with SMTP id k23so3225610lfi.11
        for <linux-media@vger.kernel.org>; Tue, 19 Sep 2017 03:42:38 -0700 (PDT)
Subject: Re: [PATCHv2 1/2] dt-bindings: adi,adv7511.txt: document cec clock
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        Archit Taneja <architt@codeaurora.org>,
        linux-renesas-soc@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        devicetree@vger.kernel.org
References: <20170919073331.29007-1-hverkuil@xs4all.nl>
 <20170919073331.29007-2-hverkuil@xs4all.nl>
 <505bc74f-6563-ab1d-9aab-7893410aef7e@cogentembedded.com>
 <74b252c8-c1eb-8498-7b9b-54604fe2806a@cisco.com>
 <e68cffb1-346c-2018-9048-3f8523903809@cogentembedded.com>
 <7bfcd125-db23-61e3-2bc9-67e5c11f27fa@xs4all.nl>
 <ce0588ed-eb3f-0008-0608-b54aefeee704@cogentembedded.com>
 <82f72432-51fa-722b-b1c7-d6f7ea6ae758@xs4all.nl>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <5c8f3625-26f3-8c6e-d42a-def8251a9ac6@cogentembedded.com>
Date: Tue, 19 Sep 2017 13:42:36 +0300
MIME-Version: 1.0
In-Reply-To: <82f72432-51fa-722b-b1c7-d6f7ea6ae758@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 9/19/2017 1:35 PM, Hans Verkuil wrote:

>>>>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>>>>
>>>>>>> Document the cec clock binding.
>>>>>>>
>>>>>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>>>>> Acked-by: Rob Herring <robh@kernel.org>
>>>>>>> ---
>>>>>>>      Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt | 4 ++++
>>>>>>>      1 file changed, 4 insertions(+)
>>>>>>>
>>>>>>> diff --git a/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt b/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
>>>>>>> index 06668bca7ffc..4497ae054d49 100644
>>>>>>> --- a/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
>>>>>>> +++ b/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
>>>>>>> @@ -68,6 +68,8 @@ Optional properties:
>>>>>>>      - adi,disable-timing-generator: Only for ADV7533. Disables the internal timing
>>>>>>>        generator. The chip will rely on the sync signals in the DSI data lanes,
>>>>>>>        rather than generate its own timings for HDMI output.
>>>>>>> +- clocks: from common clock binding: handle to CEC clock.
>>>>>>
>>>>>>        It's called "phandle" in the DT speak. :-)
>>>>>>        Are you sure the clock specifier would always be absent?
>>>>>
>>>>> Sorry? I don't understand the question. Did you mean: "can be absent?"?
>>>>
>>>>       No, you only say that there'll be the clock phandle only. The clock
>>>> specifier may follow the phandle for the clock devices that have
>>>> "#clock-cells" prop != 0.
>>>
>>> I have to say that I just copy-and-pasted this from other bindings.
>>
>>      :-)
>>
>>> Would this be better?
>>>
>>> - clocks: list of clock specifiers, corresponding to entries in
>>>     the clock-names property;
>>
>>      Didn't you say that there'll be only one clock, "cec"? If so, there's
>> gonna  be a single clock phandle+specifier pair. They always go in pairs. :-)
>>
>>> - clock-names: from common clock binding: must be "cec".
> 
> - clocks: cec clock phandle, corresponding to the clock-names entry.

    The clock phandle and specifier.

> - clock-names: from common clock binding: must be "cec".
> 
> This OK?

    Well, you seem to be going in circles, the above was almost the same as 
the original prop description...

> Regards,
> 
> 	Hans

MBR, Sergei
