Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:39339 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758542Ab2JKQPl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Oct 2012 12:15:41 -0400
Message-ID: <5076F0A9.6020101@wwwdotorg.org>
Date: Thu, 11 Oct 2012 10:15:37 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 05/14] media: add a V4L2 OF parser
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de> <2002286.8sbBLyKbDe@avalon> <5075A74C.80106@wwwdotorg.org> <2098605.jat554dMFe@avalon>
In-Reply-To: <2098605.jat554dMFe@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/10/2012 04:51 PM, Laurent Pinchart wrote:
> On Wednesday 10 October 2012 10:50:20 Stephen Warren wrote:
>> On 10/10/2012 07:18 AM, Laurent Pinchart wrote:
>>> On Monday 08 October 2012 17:15:53 Guennadi Liakhovetski wrote:
>> ...
>>
>>>> But how do you get the subdev pointer? With the notifier I get it from
>>>> i2c_get_clientdata(client) and what do you do without it? How do you get
>>>> to the client?
>>>>
>>>>> And can't it get that from DT as well?
>>>>
>>>> No, I don't think there is a way to get a device pointer from a DT node.
>>
>> I don't believe there's a generic API for this (although perhaps there
>> could be), but it can be implemented quite easily.
>>
>> For example, on Tegra, the SMMU needs to flip a bit in the AHB register
>> space in order to enable itself. The SMMU DT node contains a phandle
>> that points at the AHB DT node. The SMMU driver parses the phandle and
>> passes the DT node pointer to the AHB driver. The AHB driver looks up
>> the struct device that was instantiated for that node. See
>> drivers/amba/tegra-ahb.c:tegra_ahb_enable_smmu(). There are a few other
>> cases of similar code in the kernel, although I can't remember the others!
> 
> That's a very naive approach, but what about storing the struct device in 
> struct device_node when the device is instantiated ? It's so simple that 
> there's probably a good reason why that hasn't been implemented though.

It sounds like that would work.

The advantage of calling a function in the driver for the node, rather
than just grabbing something from the node directly in code unrelated to
the driver for the node, is that it any knowledge of what kind of
device/driver is handling that node is embedded into a function in the
driver for the node, not the driver using the node, which makes
everything a bit more type-safe.

Now, perhaps the implementation of that function could just pull a field
out of struct of_node rather than calling driver_find_device(), but it'd
then have to validate that the struct device that was found was truly
managed by the expected driver, for safety. I assume that's pretty
simple, but haven't checked.
