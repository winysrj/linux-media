Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:50050 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab2JBLEg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 07:04:36 -0400
Date: Tue, 2 Oct 2012 13:04:23 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 05/14] media: add a V4L2 OF parser
In-Reply-To: <506ABE40.9070504@samsung.com>
Message-ID: <Pine.LNX.4.64.1210021241170.15778@axis700.grange>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de>
 <1348754853-28619-6-git-send-email-g.liakhovetski@gmx.de> <506A0D28.10505@gmail.com>
 <Pine.LNX.4.64.1210021142210.15778@axis700.grange> <506ABE40.9070504@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2 Oct 2012, Sylwester Nawrocki wrote:

> Hi Guennadi,
> 
> On 10/02/2012 11:49 AM, Guennadi Liakhovetski wrote:
> >>> +	if (!of_property_read_u32_array(node, "data-lanes", data_lanes,
> >>> +					ARRAY_SIZE(data_lanes))) {
> >>> +		int i;
> >>> +		for (i = 0; i<  ARRAY_SIZE(data_lanes); i++)
> >>> +			link->mipi_csi_2.data_lanes[i] = data_lanes[i];
> >>
> >> It doesn't look like what we aimed for. The data-lanes array is supposed
> >> to be of variable length, thus I don't think it can be parsed like that. 
> >> Or am I missing something ? I think we need more something like below 
> >> (based on of_property_read_u32_array(), not tested):
> > 
> > Ok, you're right, that my version only was suitable for fixed-size arrays, 
> > which wasn't our goal. But I don't think we should go down to manually 
> > parsing property data. How about (tested;-))
> > 
> > 	data = of_find_property(node, "data-lanes", NULL);
> > 	if (data) {
> > 		int i = 0;
> > 		const __be32 *lane = NULL;
> > 		do {
> > 			lane = of_prop_next_u32(data, lane, &data_lanes[i]);
> > 		} while (lane && i++ < ARRAY_SIZE(data_lanes));
> > 		link->mipi_csi_2.num_data_lanes = i;
> > 		while (i--)
> > 			link->mipi_csi_2.data_lanes[i] = data_lanes[i];
> > 	}
> 
> Yes, that looks neat and does what it is supposed to do. :) Thanks!
> For now, I'll trust you it works ;)
> 
> With regards to the remaining patches, it looks a bit scary to me how
> complicated it got, perhaps mostly because of requirement to reference
> host devices from subdevs.

If you mean uses of the v4l2_of_get_remote() function, then it's the other 
way round: I'm accessing subdevices from bridges, which is also 
understandable - you need the subdevice.

Or do you mean the need to turn the master clock on and off from the 
subdevice driver? This shall be eliminated, once we switch to using the 
generic clock framework.

> And it seems to rely on the existing SoC
> camera infrastructure, which might imply lot's of work need to be done
> for non soc-camera drivers.

Sorry, what "it" is relying on soc-camera? The patch series consists of 
several generic patches, which have nothing to do with soc-camera, and 
patches, porting soc-camera to use OF with cameras. I think, complexity 
with soc-camera is also higher, than what you'd need with specific single 
bridge drivers, because it is generic.

A big part of the complexity is supporting deferred subdevice (sensor) 
probing. Beginning with what most bridge drivers currently use - static 
subdevice lists in platform data, for which they then register I2C 
devices, it is natural to implement that in 2 steps: (1) support directly 
registered I2C sensors from platform data, that request deferred probing 
until the bridge driver has been probed and is ready to handle them; (2) 
support I2C subdevices in DT. After this your bridge driver will support 3 
(!) modes in which subdevices can be initialised. In principle you could 
drop step (1) - supporting that isn't really required, but then the jump 
to (2) will be larger.

Another part of the complexity is specific to soc-camera, it comes from 
the way, how subdevices are represented in platform data - as platform 
devices with a bus ID, used to link bridges and subdevices. With DT those 
platform devices and bus ID have to be generated dynamically.

And you're right - soc-camera bridge drivers have the advantage, that the 
soc-camera core has taken the most work on supporting DT on itself, so, DT 
support will come to them at only a fraction of the cost;-)

Thanks
Guennadi

> But I'm going to take a closer look and
> comment more on the details at the corresponding patches.
> 
> --
> 
> Regards,
> Sylwester

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
