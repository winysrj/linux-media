Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:22175 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbaCKNzw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 09:55:52 -0400
Message-id: <531F15D0.50008@samsung.com>
Date: Tue, 11 Mar 2014 14:55:28 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Grant Likely <grant.likely@linaro.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Rob Herring <robherring2@gmail.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [PATCH v4 1/3] [media] of: move graph helpers from
 drivers/media/v4l2-core to drivers/of
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de>
 <1536567.OYzyi25bjL@avalon> <531D7E9F.3090708@samsung.com>
 <1401949.AJnxRNDZ0C@avalon>
In-reply-to: <1401949.AJnxRNDZ0C@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/10/2014 12:42 PM, Laurent Pinchart wrote:
> Hi Andrzej,
> 
>>> I like that idea. I would prefer making the 'port' nodes mandatory and the
>>> 'ports' and 'endpoint' nodes optional. Leaving the 'port' node out
>>> slightly decreases readability in my opinion, but making the 'endpoint'
>>> node optional increases it. That's just my point of view though.
>>
>> I want to propose another solution to simplify bindings, in fact I have
>> few ideas to consider:
>>
>> 1. Use named ports instead of address-cells/regs. Ie instead of
>> port@number schema, use port-function. This will allow to avoid ports
>> node and #address-cells, #size-cells, reg properties.
>> Additionally it should increase readability of the bindings.
>>
>> device {
>> 	port-dsi {
>> 		endpoint { ... };
>> 	};
>> 	port-rgb {
>> 		endpoint { ... };
>> 	};
>> };
>>
>> It is little bit like with gpios vs reset-gpios properties.
>> Another advantage I see we do not need do mappings of port numbers
>> to functions between dts, drivers and documentation.
> 
> The problem with this approach is that ports are identified by a number inside 
> the kernel, so we would still need to define name to number mappings, or 
> switch to port names internally first.

The mapping will be only internal in the driver.

Anyway the bindings should be kernel agnostic.

Andrzej

> 
>> 2. Similar approach can be taken to endpoint nodes, in fact
>> as endpoints are children of port node and as I understand port node
>> have no other children we can use any name instead of endpoint@number,
>> of course some convention can be helpful.
>>
>> device {
>> 	port-dsi {
>> 		ep-soc1 { ... };
>> 		ep-soc2 { ... };
>> 	};
>> 	port-rgb {
>> 		ep-panel { ... };
>> 	};
>> };
> 
> I see less issues here, as we don't need to number endpoints if I'm not 
> mistaken.
> 
>> I would like to add that those ideas would work nicely with Sylwester's
>> proposition of skipping endpoints nodes in case there is only one
>> endpoint - the most common cases are devices with one or two ports, each
>> port having only one remote endpoint.
>> The complete graph for DSI/LVDS bridge I work recently will look like:
>>
>> dsim {
>> 	dsim_ep: port-dsi {
>> 		remote-endpoint = <&bridge_dsi_ep>;
>> 	};
>> };
>>
>> bridge {
>> 	bridge_dsi_ep: port-dsi {
>> 		remote-endpoint = <&dsim_ep>;
>> 	};
>> 	bridge_lvds_ep: port-lvds {
>> 		remote-endpoint = <&panel_ep>;
>> 	};
>> };
>>
>> panel {
>> 	port-lvds {
>> 		remote-endpoint <&bridge_lvds_ep>;
>> 	};
>> };
> 

