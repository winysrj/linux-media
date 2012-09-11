Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:40652 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690Ab2IKPXD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 11:23:03 -0400
Message-ID: <504F5753.60407@wwwdotorg.org>
Date: Tue, 11 Sep 2012 09:22:59 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
	linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC v5] V4L DT bindings
References: <Pine.LNX.4.64.1208242356051.20710@axis700.grange> <Pine.LNX.4.64.1209051030230.16676@axis700.grange> <5047DEE6.9020607@wwwdotorg.org> <Pine.LNX.4.64.1209111555010.22084@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1209111555010.22084@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/2012 08:02 AM, Guennadi Liakhovetski wrote:
> Hi Stephen
> 
> Thanks for the review.
> 
> On Wed, 5 Sep 2012, Stephen Warren wrote:
> 
>> On 09/05/2012 04:57 AM, Guennadi Liakhovetski wrote:
>>> Hi all
>>>
>>> Version 5 of this RFC is a result of a discussion of its version 4, which 
>>> took place during the recent Linux Plumbers conference in San Diego. 
>>> Changes are:
>>>
>>> (1) remove bus-width properties from device (bridge and client) top level. 
>>> This has actually already been decided upon during our discussions with 
>>> Sylwester, I just forgot to actually remove them, sorry.
>>>
>>> (2) links are now grouped under "ports." This should help better describe 
>>> device connection topology by making clearer, which interfaces links are 
>>> attached to. (help needed: in my notes I see "port" optional if only one 
>>> port is present, but I seem to remember, that the final decision was - 
>>> make ports compulsory for uniformity. Which one is true?)
>>
>> I'd tend to make the port node compulsory.
>>
>> A related question: What code is going to parse all the port/link
>> sub-nodes in a device?
> 
> I think we'll have to make a generic V4L DT parser. We certainly don't 
> want each driver reimplement this.
> 
>> And, how does it know which sub-nodes are ports,
>> and which are something else entirely? Perhaps the algorithm is that all
>> port nodes must be named "port"?
> 
> Yes, that was the idea. Is anything speaking against it?

I think that's fine; it's certainly a nice and simple requirement. It's
just a rule that will have to be thought about when designing bindings
for all the devices that use this feature, to make sure they don't
define any other kind of "port" node that would confuse the parser.

I suppose if this ever becomes a problem, an individual binding could
choose to avoid conflicts by placing the "port" nodes in some specific
child node of its device node, and the driver would pass the name of
that node into the common parsing code, which would default to using the
device's main node when not otherwise specified. However, we should
avoid the conflicts if we can. In other words:

Normal:

/foo {
    port@0 { ... };
    port@1 { ... };
};

If there's ever a need to resolve some conflict with that standard layout:

/foo {
    media-ports {
        port@0 { ... };
        port@1 { ... };
    };
};
