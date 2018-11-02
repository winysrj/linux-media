Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:36120 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbeKBUEb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 16:04:31 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v2 1/5] dt-bindings: adv748x: make data-lanes property
 mandatory for CSI-2 endpoints
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: jacopo mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
References: <20181004204138.2784-1-niklas.soderlund@ragnatech.se>
 <18767245.bJLhzbqhM5@avalon> <20181005084945.GL31281@w540>
 <4582789.bxBjXKKKhz@avalon> <20181102103443.GG22306@bigcity.dyn.berto.se>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <e3df16ee-58dc-1565-2878-b688d5d6dd18@ideasonboard.com>
Date: Fri, 2 Nov 2018 10:57:40 +0000
MIME-Version: 1.0
In-Reply-To: <20181102103443.GG22306@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On 02/11/2018 10:34, Niklas Söderlund wrote:
> Hi Laurent, Jacopo
> 
> Thanks for your comments.
> 
> On 2018-10-05 13:02:53 +0300, Laurent Pinchart wrote:
>> Hi Jacopo,
>>
>> On Friday, 5 October 2018 11:49:45 EEST jacopo mondi wrote:
>>> On Fri, Oct 05, 2018 at 01:00:47AM +0300, Laurent Pinchart wrote:
>>>> On Friday, 5 October 2018 00:42:17 EEST Laurent Pinchart wrote:
>>>>> On Thursday, 4 October 2018 23:41:34 EEST Niklas Söderlund wrote:
>>>>>> From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
>>>>>>
>>>>>> The CSI-2 transmitters can use a different number of lanes to transmit
>>>>>> data. Make the data-lanes mandatory for the endpoints describe the
>>>>>
>>>>> s/describe/that describe/ ?
>>>>>
>>>>>> transmitters as no good default can be set to fallback on.
>>>>>>
>>>>>> Signed-off-by: Niklas Söderlund
>>>>>> <niklas.soderlund+renesas@ragnatech.se>
>>>>>> ---
>>>>>>
>>>>>>  Documentation/devicetree/bindings/media/i2c/adv748x.txt | 3 +++
>>>>>>  1 file changed, 3 insertions(+)
>>>>>>
>>>>>> diff --git a/Documentation/devicetree/bindings/media/i2c/adv748x.txt
>>>>>> b/Documentation/devicetree/bindings/media/i2c/adv748x.txt index
>>>>>> 5dddc95f9cc46084..f9dac01ab795fc28 100644
>>>>>> --- a/Documentation/devicetree/bindings/media/i2c/adv748x.txt
>>>>>> +++ b/Documentation/devicetree/bindings/media/i2c/adv748x.txt
>>>>>> @@ -50,6 +50,9 @@ are numbered as follows.
>>>>>>
>>>>>>  The digital output port nodes must contain at least one endpoint.
>>>>>>
>>>>>> +The endpoints described in TXA and TXB ports must if present contain
>>>>>> +the data-lanes property as described in video-interfaces.txt.
>>>>>> +
>>>>>
>>>>> Would it make sense to merge those two paragraphs, as they refer to the
>>>>> same endpoint ?
>>>>>
>>>>> "The digital output port nodes, when present, shall contain at least one
>>>>> endpoint. Each of those endpoints shall contain the data-lanes property
>>>>> as described in video-interfaces.txt."
>>>>>
>>>>> (DT bindings normally use "shall" instead of "must", but that hasn't
>>>>> really been enforced.)
>>>>>
>>>>> If you want to keep the paragraphs separate, I would recommend using
>>>>> "digital output ports" instead of "TXA and TXB" in the second paragraph
>>>>> for consistency (or the other way around).
>>>>>
>>>>> I'm fine with any of the above option, so please pick your favourite,
>>>>> and add
>>>>>
>>>>> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>>
>>>> I just realized that TXB only supports a single data lane, so we may want
>>>> not to have a data-lanes property for TXB.
>>>
>>> Isn't it better to restrict its value to <1> but make it mandatory
>>> anyhow? I understand conceptually that property should not be there,
>>> as it has a single acceptable value, but otherwise we need to traeat
>>> differently the two output ports, in documentation and code.
>>
>> The two ports are different, so I wouldn't be shocked if we handled them 
>> differently :-) I believe it would actually reduce the code size (and save CPU 
>> cycles at runtime).
> 
> I'm leaning towards Jacopo on this that I think it's more clear to treat 
> the two the same. I also think it adheres to the notion that DT shall 
> describe hardware which I think this adds value. Also I only have 
> datasheets for adv7482 so I can't be sure other adv748x don't support 
> more then one lane on TXB.
> 
> I do not feel strongly about this so I'm open to treating them 
> differently. I might keep it as is for v3 if no one screams to loud :-)

I personally think that TXA and TXB are 'the same' entities, just in
different configurations, and so I would say they are 'the same' too.

For reference, from the adv748x.h header file:

 * The ADV748x range of receivers have the following configurations:
 *
 *                  Analog   HDMI  MHL  4-Lane  1-Lane
 *                    In      In         CSI     CSI
 *       ADV7480               X    X     X
 *       ADV7481      X        X    X     X       X
 *       ADV7482      X        X          X       X


So both the ADV7481 and ADV7482 have both a TXA and a TXB, where the
ADV7480 has only the TXA.

TXB is always only 'one-lane'

--
Kieran



> 
>>
>>> Why not inserting a paragraph with the required endpoint properties
>>> description?
>>>
>>> Eg:
>>>
>>>  Required endpoint properties:
>>>  - data-lanes: See "video-interfaces.txt" for description. The property
>>>    is mandatory for CSI-2 output endpoints and the accepted values
>>>    depends on which endpoint the property is applied to:
>>>    - TXA: accepted values are <1>, <2>, <4>
>>>    - TXB: accepted value is <1>
>>>
>>>>>>  Ports are optional if they are not connected to anything at the
>>>>>>  hardware level.
>>>>>>
>>>>>>  Example:
>>
>> -- 
>> Regards,
>>
>> Laurent Pinchart
>>
