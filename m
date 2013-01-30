Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:52557 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab3A3WfT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 17:35:19 -0500
Message-ID: <5109A01A.3020102@gmail.com>
Date: Wed, 30 Jan 2013 23:35:06 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	g.liakhovetski@gmx.de, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, grant.likely@secretlab.ca,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, myungjoo.ham@samsung.com,
	sw0312.kim@samsung.com, prabhakar.lad@ti.com,
	devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH RFC v4 01/14] [media] Add common video interfaces OF bindings
 documentation
References: <1358969489-20420-1-git-send-email-s.nawrocki@samsung.com> <1525960.fMnIjkZnjX@avalon> <51017DB2.5050905@samsung.com> <453041220.G3D9E6yQdS@avalon> <510914D0.6050404@samsung.com>
In-Reply-To: <510914D0.6050404@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 01/30/2013 01:40 PM, Sylwester Nawrocki wrote:
> On 01/25/2013 02:52 AM, Laurent Pinchart wrote:
>>>>> +Data interfaces on all video devices are described by their child 'port'
>>>>> +nodes. Configuration of a port depends on other devices participating in
>>>>> +the data transfer and is described by 'endpoint' subnodes.
>>>>> +
>>>>> +dev {
>>>>> +	#address-cells =<1>;
>>>>> +	#size-cells =<0>;
>>>>> +	port@0 {
>>>>> +		endpoint@0 { ... };
>>>>> +		endpoint@1 { ... };
>>>>> +	};
>>>>> +	port@1 { ... };
>>>>> +};
>>>>> +
>>>>> +If a port can be configured to work with more than one other device on
>>>>> +the same bus, an 'endpoint' child node must be provided for each of
>>>>> +them. If more than one port is present in a device node or there is more
>>>>> +than one endpoint at a port, a common scheme, using '#address-cells',
>>>>> +'#size-cells' and 'reg' properties is used.
>>>>
>>>> Wouldn't this cause problems if the device has both video ports and a
>>>> child bus ? Using #address-cells and #size-cells for the video ports would
>>>> prevent the child bus from being handled in the usual way.
>>>
>>> Indeed, it looks like a serious issue in these bindings.
>>>
>>>> A possible solution would be to number ports with a dash instead of a @,
>>>> as done in pinctrl for instance. We would then get
>>>>
>>>> 	port-0 {
>>>> 		endpoint-0 { ... };
>>>> 		endpoint-1 { ... };
>>>> 	};
>>>> 	port-1 { ... };

Another possible solution could be putting the port nodes under
a ports node, for these cases where a device has a child bus.
Where there is no conflict, the ports node could be omitted for
simplicity. Does it sound reasonable ?

device {
	ports {
		#address-cells = <1>;
		#size-cells = <0>;
		port@0 {	
			endpoint@0 {
				reg = <0>;
			};
			endpoint@1 { ... };
		};
		port@1 { ... };
	};
};

> One problem here is that index of the port or the endpoint node can have
> random value and don't need to start with 0, which is the case for the pinctrl
> properties. It makes iterating over those nodes more difficult, instead
> of using standard functions like of_node_cmp() we would need to search for
> sub-strings in the node name.

--

Thanks,
Sylwester
