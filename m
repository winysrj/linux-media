Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:52574
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756737AbcKKQR6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 11:17:58 -0500
Subject: Re: [RFC PATCH v2 1/2] [media] tvp5150: Add input connectors DT
 bindings
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1460500973-9066-1-git-send-email-javier@osg.samsung.com>
 <1460500973-9066-2-git-send-email-javier@osg.samsung.com>
 <2355815.rhlvKGshE1@avalon>
 <744e5205-59e6-e135-3985-db097044aa11@osg.samsung.com>
 <7966dcbe-4a9d-714a-ae2f-8c18b053762a@xs4all.nl>
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, Kevin Hilman <khilman@baylibre.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <36c6d230-a910-294a-27ff-8ef77d43647a@osg.samsung.com>
Date: Fri, 11 Nov 2016 13:17:47 -0300
MIME-Version: 1.0
In-Reply-To: <7966dcbe-4a9d-714a-ae2f-8c18b053762a@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[adding Kevin as cc since he was interested in this feature as well]

Hello Hans,

On 11/11/2016 01:11 PM, Hans Verkuil wrote:
> This old mail came up in a discussion today so let me comment on this:
>

Thanks a lot for the feedback.
 
> On 04/27/2016 09:12 PM, Javier Martinez Canillas wrote:
>> Hello Laurent,
>>
>> Thanks a lot for your feedback.
>>
>> On 04/27/2016 10:29 AM, Laurent Pinchart wrote:
>>> Hi Javier,
>>>
>>> Thank you for the patch.
>>>
>>> On Tuesday 12 Apr 2016 18:42:52 Javier Martinez Canillas wrote:
>>>> The tvp5150 and tvp5151 decoders support different video input source
>>>> connections to their AIP1A and AIP1B pins. Either two Composite or a
>>>> S-Video input signals are supported.
>>>>
>>>> The possible configurations are as follows:
>>>>
>>>> - Analog Composite signal connected to AIP1A.
>>>> - Analog Composite signal connected to AIP1B.
>>>> - Analog S-Video Y (luminance) and C (chrominance)
>>>>   signals connected to AIP1A and AIP1B respectively.
>>>>
>>>> This patch extends the Device Tree binding documentation to describe
>>>> how the input connectors for these devices should be defined in a DT.
>>>>
>>>> Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>>>>
>>>> ---
>>>> Hello,
>>>>
>>>> The DT binding assumes that there is a 1:1 map between physical connectors
>>>> and connections, so there will be a connector described in the DT for each
>>>> connection.
>>>>
>>>> There is also the question about how the DT bindings will be extended to
>>>> support other attributes (color/position/group) using the properties API.
>>>
>>> I foresee lots of bikeshedding on that particular topic, but I don't think it 
>>> will be a blocker. We need a volunteer to quickstart a discussion on the 
>>> devicetree (or possible devicetree-spec) mailing list :-)
>>>
>>
>> Yes, I plan to extend this binding once we have the properties API in mainline
>> but that can be done as a follow-up since it should just be more properties on
>> top of compatible, label and port that will be supported in the meantime.
>>  
>>>> But I believe that can be done as a follow-up, once the properties API is
>>>> in mainline.
>>>>
>>>> Best regards,
>>>> Javier
>>>>
>>>> Changes in v2:
>>>> - Remove from the changelog a mention of devices that multiplex the
>>>>   physical RCA connectors to be used for the S-Video Y and C signals
>>>>   since it's a special case and it doesn't really work on the IGEPv2.
>>>>
>>>>  .../devicetree/bindings/media/i2c/tvp5150.txt      | 59 +++++++++++++++++++
>>>>  1 file changed, 59 insertions(+)
>>>> :
>>>> diff --git a/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
>>>> b/Documentation/devicetree/bindings/media/i2c/tvp5150.txt index
>>>> 8c0fc1a26bf0..df555650b0b4 100644
>>>> --- a/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
>>>> +++ b/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
>>>> @@ -26,8 +26,46 @@ Required Endpoint Properties for parallel
>>>> synchronization: If none of hsync-active, vsync-active and
>>>> field-even-active is specified, the endpoint is assumed to use embedded
>>>> BT.656 synchronization.
>>>>
>>>> +-Optional nodes:
>>>> +- connectors: The list of tvp5150 input connectors available on a given
>>>> +  board. The node should contain a child 'port' node for each connector.
>>>
>>> I had understood this as meaning that connectors should be fully described in 
>>> the connectors subnode, until I read through the whole patch and saw that 
>>> dedicated DT nodes are needed for the connectors. I thus believe the paragraph 
>>> should be reworded to avoid the ambiguity.
>>>
>>
>> I see what you mean, OK I'll make it clear that this only is the list of ports
>> and that connectors should be described somewhere else (i.e: the root node).
>>
>>> This being said, why do you need a connectors subnode ? Can't we just add the 
>>> port nodes for the input ports directly in the tvp5150 node (or possibly in a 
>>> ports subnode, as defined in the OF graph bindings).
>>>
>>
>> Yes we could, I went with a "connectors" subnode because the video decoders
>> will have another port node to point to the bridge device node endpoint. So
>> I thought it could be more clear to make a distinction between those ports.
>>
>> We can go with the "ports" subnode instead of "connectors" but then again it
>> could be confusing to differentiate between bridge and connectors ports both
>> for users writing/reading DTS and the drivers parsing the DT.
>>
>> I used as an inspiration the regulators binding where regulators are usually
>> described under a "regulators" subnode.
> 
> I am inclined to go with Laurent on this. In the end these are just pins and while
> they usually will be hooked up to connectors, that doesn't have to be the case.
> There may be another component in between, so I don't really like it that it is
> called 'connector'. In my mind it is just another (input) port. It is really
> only after looking at the remote endpoint that you see that there is a connector
> connected to the pin(s).
>

Ok, I'll re-spin the patches then and do the change according to Laurent's and your
suggestions. It may take some time though since I'm currently busy with other tasks.
 
> Regards,
> 
> 	Hans
> 

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
