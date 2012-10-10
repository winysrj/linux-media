Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41824 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335Ab2JJWu2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 18:50:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 05/14] media: add a V4L2 OF parser
Date: Thu, 11 Oct 2012 00:51:09 +0200
Message-ID: <2098605.jat554dMFe@avalon>
In-Reply-To: <5075A74C.80106@wwwdotorg.org>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de> <2002286.8sbBLyKbDe@avalon> <5075A74C.80106@wwwdotorg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 10 October 2012 10:50:20 Stephen Warren wrote:
> On 10/10/2012 07:18 AM, Laurent Pinchart wrote:
> > On Monday 08 October 2012 17:15:53 Guennadi Liakhovetski wrote:
> ...
> 
> >> But how do you get the subdev pointer? With the notifier I get it from
> >> i2c_get_clientdata(client) and what do you do without it? How do you get
> >> to the client?
> >> 
> >>> And can't it get that from DT as well?
> >> 
> >> No, I don't think there is a way to get a device pointer from a DT node.
> 
> I don't believe there's a generic API for this (although perhaps there
> could be), but it can be implemented quite easily.
>
> For example, on Tegra, the SMMU needs to flip a bit in the AHB register
> space in order to enable itself. The SMMU DT node contains a phandle
> that points at the AHB DT node. The SMMU driver parses the phandle and
> passes the DT node pointer to the AHB driver. The AHB driver looks up
> the struct device that was instantiated for that node. See
> drivers/amba/tegra-ahb.c:tegra_ahb_enable_smmu(). There are a few other
> cases of similar code in the kernel, although I can't remember the others!

That's a very naive approach, but what about storing the struct device in 
struct device_node when the device is instantiated ? It's so simple that 
there's probably a good reason why that hasn't been implemented though.

-- 
Regards,

Laurent Pinchart

