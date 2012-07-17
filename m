Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37798 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab2GQUPi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jul 2012 16:15:38 -0400
Message-ID: <5005C7E4.3050908@gmail.com>
Date: Tue, 17 Jul 2012 22:15:32 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com,
	Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [RFC/PATCH 05/13] media: s5p-fimc: Add device tree support for
 FIMC devices
References: <4FBFE1EC.9060209@samsung.com> <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com> <1337975573-27117-5-git-send-email-s.nawrocki@samsung.com> <Pine.LNX.4.64.1207161110430.12302@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1207161110430.12302@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/16/2012 11:13 AM, Guennadi Liakhovetski wrote:
> On Fri, 25 May 2012, Sylwester Nawrocki wrote:
> 
>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>> Signed-off-by: Karol Lewandowski<k.lewandowsk@samsung.com>
>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> 
>  From the documentation below I think, I understand what it does, but why
> is it needed? It doesn't describe your video subsystem topology, right?
> How various subdevices are connected. It just lists them all in one
> node... A description for this patch would be very welcome IMHO and,
> maybe, such a node can be completely avoided?

Sorry, I'll provide better description in next iteration.
It's true it doesn't describe the topology in detail, as there are
multiple one-to many possible connections between sub-devices. An exact
topology is coded in the driver and can be changed through MC API.
The "samsung,camif-mux-id" and "video-bus-type" properties at "sensor" 
nodes just specify to which physical SoC camera port an image sensor
is connected.

Originally the all camera devices were supposed to land under common 
'camera' node. And a top level driver would be registering all platform 
devices. With this approach it would be possible to better control PM 
handling (which currently depends on an order of registering devices to 
the driver core). But then we discovered that we couldn't use OF_DEV_AUXDATA 
in such case, which was required to preserve platform device names, in order 
for the clock API to work. So I've moved some sub-devices out of 'camera' 
node and have added only a list of phandles to them in that node. This is 
rather a cheap workaround..

I think all camera sub-devices should be placed under common node, as there
are some properties that don't belong to any sub-node: GPIO config, clocks,
to name a few. Of course simpler devices might not need such a composite 
node. I think we can treat the sub-device interdependencies as an issue
separate from a need for a common node.

If some devices need to reflect the topology better, we probably could
include in some nodes (a list of) phandles to other nodes. This could ease
parsing the topology at the drivers, by using existing OF infrastructure.

--

Thanks,
Sylwester
