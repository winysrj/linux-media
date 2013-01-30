Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34273 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab3A3Mkw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 07:40:52 -0500
Message-id: <510914D0.6050404@samsung.com>
Date: Wed, 30 Jan 2013 13:40:48 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	g.liakhovetski@gmx.de, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, grant.likely@secretlab.ca,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, myungjoo.ham@samsung.com,
	sw0312.kim@samsung.com, prabhakar.lad@ti.com,
	devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH RFC v4 01/14] [media] Add common video interfaces OF
 bindings documentation
References: <1358969489-20420-1-git-send-email-s.nawrocki@samsung.com>
 <1525960.fMnIjkZnjX@avalon> <51017DB2.5050905@samsung.com>
 <453041220.G3D9E6yQdS@avalon>
In-reply-to: <453041220.G3D9E6yQdS@avalon>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 01/25/2013 02:52 AM, Laurent Pinchart wrote:
>>>> +Data interfaces on all video devices are described by their child 'port'
>>>> +nodes. Configuration of a port depends on other devices participating in
>>>> +the data transfer and is described by 'endpoint' subnodes.
>>>> +
>>>> +dev {
>>>> +	#address-cells = <1>;
>>>> +	#size-cells = <0>;
>>>> +	port@0 {
>>>> +		endpoint@0 { ... };
>>>> +		endpoint@1 { ... };
>>>> +	};
>>>> +	port@1 { ... };
>>>> +};
>>>> +
>>>> +If a port can be configured to work with more than one other device on
>>>> +the same bus, an 'endpoint' child node must be provided for each of
>>>> +them. If more than one port is present in a device node or there is more
>>>> +than one endpoint at a port, a common scheme, using '#address-cells',
>>>> +'#size-cells' and 'reg' properties is used.
>>>
>>> Wouldn't this cause problems if the device has both video ports and a
>>> child bus ? Using #address-cells and #size-cells for the video ports would
>>> prevent the child bus from being handled in the usual way.
>>
>> Indeed, it looks like a serious issue in these bindings.
>>
>>> A possible solution would be to number ports with a dash instead of a @,
>>> as done in pinctrl for instance. We would then get
>>>
>>> 	port-0 {
>>> 		endpoint-0 { ... };
>>> 		endpoint-1 { ... };
>>> 	};
>>> 	port-1 { ... };

One problem here is that index of the port or the endpoint node can have 
random value and don't need to start with 0, which is the case for the pinctrl
properties. It makes iterating over those nodes more difficult, instead
of using standard functions like of_node_cmp() we would need to search for 
sub-strings in the node name.

>> Sounds like a good alternative, I can't think of any better solution at the
>> moment.
>>
>>>> +Two 'endpoint' nodes are linked with each other through their
>>>> +'remote-endpoint' phandles.  An endpoint subnode of a device contains
>>>> +all properties needed for configuration of this device for data exchange
>>>> +with the other device.  In most cases properties at the peer 'endpoint'
>>>> +nodes will be identical, however they might need to be different when
>>>> +there is any signal modifications on the bus between two devices, e.g.
>>>> +there are logic signal inverters on the lines.
>>>> +
>>>> +Required properties
>>>> +-------------------
>>>> +
>>>> +If there is more than one 'port' or more than one 'endpoint' node
>>>> following +properties are required in relevant parent node:
>>>> +
>>>> +- #address-cells : number of cells required to define port number,
>>>> should be 1.
>>>> +- #size-cells    : should be zero.
>>>
>>> I wonder if we should specify whether a port is a data sink or data
>>> source. A source can be connected to multiple sinks at the same time, but
>>> a sink can only be connected to a single source. If we want to perform
>>> automatic sanity checks in the core knowing the direction might help.
>>
>> Multiple sources can be linked to a single sink, but only one link can be
>> active at any time.
>>
>> So I'm not sure if knowing if a DT port is a data source or data sink would
>> let us to validate device tree structure statically in general.
>>
>> Such source/sink property could be useful later at runtime, when data
>> pipeline is set up for streaming.
> 
> Yes, I was mostly thinking about runtime.
> 
>> How do you think this could be represented ? By just having boolean
>> properties like: 'source' and 'sink' in the port nodes ? Or perhaps in the
>> endpoint nodes, since some devices might be bidirectional ? I don't recall
>> any at the moment though.
> 
> Source and sink properties would do. We could also use a direction property 
> that could take sink, source and bidirectional values, but that might be more 
> complex.

Since we're going to allow multiple endpoints at a port to be active at any
time, for the reasons we discussed in IRC [1], I assume it's no longer
possible to perform sanity checks mentioned above in the core. Should we 
then keep the 'source', 'sink' properties in the port nodes ?

[1] http://linuxtv.org/irc/v4l/index.php?date=2013-01-29

> I don't think we will have bidirectional link (as that would most probably 
> involve a very different kind of bus, and thus new bindings).

--

Thanks,
Sylwester

