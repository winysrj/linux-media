Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2834 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab2JEKox (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2012 06:44:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 05/14] media: add a V4L2 OF parser
Date: Fri, 5 Oct 2012 12:41:52 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de> <Pine.LNX.4.64.1210021142210.15778@axis700.grange> <506ABE40.9070504@samsung.com>
In-Reply-To: <506ABE40.9070504@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210051241.52205.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue October 2 2012 12:13:20 Sylwester Nawrocki wrote:
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
> host devices from subdevs. And it seems to rely on the existing SoC
> camera infrastructure, which might imply lot's of work need to be done
> for non soc-camera drivers. But I'm going to take a closer look and
> comment more on the details at the corresponding patches.

I have to say that I agree with Sylwester here. It seems awfully complicated,
but I can't really put my finger on the actual cause. It would be really
interesting to see this implemented for a non-SoC device and to compare the
two.

One area that I do not yet completely understand is the i2c bus notifications
(or asynchronous loading or i2c modules).

I would have expected that using OF the i2c devices are still initialized
before the host/bridge driver is initialized. But I gather that's not the
case?

If this deferred probing is a general problem, then I think we need a general
solution as well that's part of the v4l2 core.

Regards,

	Hans
