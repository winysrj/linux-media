Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:43402 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbeKBWHk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 18:07:40 -0400
Reply-To: kieran.bingham+renesas@ideasonboard.com
Subject: Re: [PATCH v3 1/4] dt-bindings: media: i2c: Add bindings for Maxim
 Integrated MAX9286
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Jacopo Mondi <jacopo@jmondi.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
References: <20181009205726.7664-1-kieran.bingham@ideasonboard.com>
 <71c30ead-66cd-2c84-3349-0dd393f66300@ideasonboard.com>
 <20181015190121.GI24305@bigcity.dyn.berto.se> <2443594.YVDbUcPb3K@avalon>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <c6a66cfa-b2f4-f50a-0fd7-ceb89839579b@ideasonboard.com>
Date: Fri, 2 Nov 2018 13:00:30 +0000
MIME-Version: 1.0
In-Reply-To: <2443594.YVDbUcPb3K@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16/10/2018 01:37, Laurent Pinchart wrote:
> Hello,
> 
> On Monday, 15 October 2018 22:01:21 EEST Niklas Söderlund wrote:
>> On 2018-10-15 18:37:40 +0100, Kieran Bingham wrote:
>>>>> diff --git
>>>>> a/Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt
>>>>> b/Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt
>>>>> new file mode 100644
>>>>> index 000000000000..a73e3c0dc31b
>>>>> --- /dev/null
>>>>> +++ b/Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt
>>>>> @@ -0,0 +1,182 @@
>>>>> +Maxim Integrated Quad GMSL Deserializer
>>>>> +---------------------------------------
>>>>> +
>>>>> +The MAX9286 deserializer receives video data on up to 4 Gigabit
>>>>> Multimedia
>>>>> +Serial Links (GMSL) and outputs them on a CSI-2 port using up to 4
>>>>> data lanes.
>>>>
>>>> CSI-2 D-PHY I presume?

Updated.

>>>
>>> Yes, that's how I've adapted the driver based on the latest bus changes.
>>>
>>> Niklas - Could you confirm that everything in VIN/CSI2 is configured to
>>> use D-PHY and not C-PHY at all ?
>>
>> Yes it's only D-PHY.
>>
>>>>> +
>>>>> +- remote-endpoint: phandle to the remote GMSL source endpoint subnode
>>>>> in the
>>>>> +  remote node port.
>>>>> +
>>>>> +Required Endpoint Properties for CSI-2 Output Port (Port 4):
>>>>> +
>>>>> +- data-lanes: array of physical CSI-2 data lane indexes.
>>>>> +- clock-lanes: index of CSI-2 clock lane.
>>>>
>>>> Is any number of lanes supported? How about lane remapping? If you do
>>>> not have lane remapping, the clock-lanes property is redundant.
>>>
>>> Uhm ... Niklas?
>>
>> The MAX9286 documentation contains information on lane remapping and
>> support for any number (1-4) of enabled data-lanes. I have not tested if
>> this works in practice but the registers are there and documented :-)
> 
> That's my understanding too. Clock lane remapping doesn't seem to be supported 
> though. We could thus omit the clock-lanes property.

Ok - no point describing something that can't be changed.

Dropped.

--
Regards

Kieran
