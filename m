Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:61098 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab3JYKyp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Oct 2013 06:54:45 -0400
Message-ID: <526A4DEC.2000603@gmail.com>
Date: Fri, 25 Oct 2013 12:54:36 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	devicetree@vger.kernel.org, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>,
	linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFR 2/2] drm/panel: Add simple panel support
References: <1381947912-11741-1-git-send-email-treding@nvidia.com> <3768216.eiA2v5KI6a@avalon> <525FD8DD.3090509@ti.com> <1853455.BSevh91aGB@avalon> <5268FBE3.80000@ti.com>
In-Reply-To: <5268FBE3.80000@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/24/2013 12:52 PM, Tomi Valkeinen wrote:
> On 24/10/13 13:40, Laurent Pinchart wrote:
>
>>> panel {
>>> 	remote =<&remote-endpoint>;
>>> 	common-video-property =<asd>;
>>> };
>>>
>>> panel {
>>> 	port {
>>> 		endpoint {
>>> 			remote =<&remote-endpoint>;
>>> 			common-video-property =<asd>;
>>> 		};
>>> 	};
>>> };
>>
>> Please note that the common video properties would be in the panel node, not
>> in the endpoint node (unless you have specific requirements to do so, which
>> isn't the common case).
>
> Hmm, well, the panel driver must look for its properties either in the
> panel node, or in the endpoint node (I guess it could look them from
> both, but that doesn't sound good).

Presumably the OS could be searching for port node and any endpoint node
inside it first. If that's not found then it could be parsing the panel
node.

Please note that a port node may be required even if there is only one
port, when there are multiple physical bus interfaces, e.g. at an LCD
controller and only one of them is used. The reg property would select
the physical bus interface.

I wonder if a property like #video-port or #video-endpoint could be used
to indicate that a node contains video bus properties. Probably it's too
late to introduce it now and make it a required property for the endpoint
nodes or nodes containing the common video properties.

> If you write the panel driver, and in all your cases the properties work
> fine in the panel node, does that mean they'll work fine with everybody?

It's likely not safe to assume so. In V4L data bus properties are specified
a both the receiver and the transmitter endpoint nodes separately.

> I guess there are different kinds of properties. Something like a
> regulator is obviously property of the panel. But anything related to
> the video itself, like DPI's bus width, or perhaps even something like
> "orientation" if the panel supports such, could need to be in the
> endpoint node.

If we use port/endpoint nodes it all seems clear, the video bus properties
are put in an endpoint node.

But since we are considering a simplified binding all the properties would
be placed in the panel or display controller node.

> But yes, I understand what you mean. With "common-video-property" I
> meant common properties like DPI bus width.
>
>>> If that can be supported in the SW by adding complexity to a few functions,
>>> and it covers practically all the panels, isn't it worth it?
>>>
>>> Note that I have not tried this, so I don't know if there are issues.
>>> It's just a thought. Even if there's need for a endpoint node, perhaps
>>> the port node can be made optional.
>>
>> It can be worth it, as long as we make sure that simplified bindings cover the
>> needs of the generic code.
>>
>> We could assume that, if the port subnode isn't present, the device will have
>> a single port, with a single endpoint. However, isn't the number of endpoints
>
> Right.
>
>> a system property rather than a device property ? If a port of a device is
>
> Yes.
>
>> connected to two remote ports it will require two endpoints. We could select
>> the simplified or full bindings based on the system topology though.

Yes, I guess it's all about the system topology. Any simplified binding 
would
work only for very simple configuration like single-output LCD 
controller with
single panel attached to it.

> The drivers should not know about simplified/normal bindings. They
> should use CDF DT helper functions to get the port and endpoint
> information. The helper functions would do the assuming.

Yes, anyway all the parsing is supposed to be done within the helpers.

--
Thanks,
Sylwester
