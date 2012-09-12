Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:43310 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab2ILUxn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 16:53:43 -0400
Message-ID: <5050F653.5070404@wwwdotorg.org>
Date: Wed, 12 Sep 2012 14:53:39 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
	linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] media: add V4L2 DT binding documentation
References: <Pine.LNX.4.64.1209111746420.22084@axis700.grange> <5050DA40.8050105@wwwdotorg.org> <Pine.LNX.4.64.1209122111100.28968@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1209122111100.28968@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/12/2012 01:28 PM, Guennadi Liakhovetski wrote:
> Hi Stephen
> 
> On Wed, 12 Sep 2012, Stephen Warren wrote:
> 
>> On 09/11/2012 09:51 AM, Guennadi Liakhovetski wrote:
>>> This patch adds a document, describing common V4L2 device tree bindings.
>>>
>>> Co-authored-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>>
>> Overall, I think this looks pretty reasonable, so:
...
>>
>>> +			clock-frequency = <50000000>;	/* max clock frequency */
>>> +			clock-output-names = "mclk";
>>> +		};
>>> +
>>> +		port {
>> ...
>>> +			ceu0_0: link@0 {
>>> +				reg = <0>;
>>> +				remote = <&csi2_2>;
>>> +				immutable;
>>
>> Did we decide "immutable" was actually needed? Presumably the driver for
>> the HW in question knows the HW isn't configurable, and would simply not
>> attempt to apply any configuration even if the .dts author erroneously
>> provided some?
> 
> Well, I've been thinking about this today. I think, bridge drivers will 

Sorry, I'm not sure what a "bridge" driver is; is it any v4l2 device?

> call centrally provided helper functions to enumerate links inside ports. 

Presumably a given driver would only parse the ports/links of its own DT
node, and hence would be able to provide a parameter to any helper
function that indicated the same information that "immutable" would?

> While doing that they will want to differentiate between links to external 
> devices with explicit configuration, and links to internal devices, whose 
> configuration drivers might be able to figure out themselves. How should a 
> driver find out what device this link is pointing to? Should it follow the 
> "remote" phandle and then check the "compatible" property? The word 
> "immutable" is a hint, that this is a link to an internal device, but it 
> might either be unneeded or be transformed into something more 
> informative.

I would imagine that a given driver would only ever parse its own DT
node; the far end of any link is purely the domain of the other driver.
I thought that each link node would contain whatever hsync-active,
data-lanes, ... properties that were needed to configure the local device?
