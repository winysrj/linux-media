Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1921 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab2JEL0n (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2012 07:26:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 05/14] media: add a V4L2 OF parser
Date: Fri, 5 Oct 2012 13:23:45 +0200
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de> <201210051241.52205.hverkuil@xs4all.nl> <Pine.LNX.4.64.1210051250210.13761@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1210051250210.13761@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210051323.45571.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri October 5 2012 12:58:21 Guennadi Liakhovetski wrote:
> On Fri, 5 Oct 2012, Hans Verkuil wrote:
> 
> > On Tue October 2 2012 12:13:20 Sylwester Nawrocki wrote:
> > > Hi Guennadi,
> > > 
> > > On 10/02/2012 11:49 AM, Guennadi Liakhovetski wrote:
> > > >>> +	if (!of_property_read_u32_array(node, "data-lanes", data_lanes,
> > > >>> +					ARRAY_SIZE(data_lanes))) {
> > > >>> +		int i;
> > > >>> +		for (i = 0; i<  ARRAY_SIZE(data_lanes); i++)
> > > >>> +			link->mipi_csi_2.data_lanes[i] = data_lanes[i];
> > > >>
> > > >> It doesn't look like what we aimed for. The data-lanes array is supposed
> > > >> to be of variable length, thus I don't think it can be parsed like that. 
> > > >> Or am I missing something ? I think we need more something like below 
> > > >> (based on of_property_read_u32_array(), not tested):
> > > > 
> > > > Ok, you're right, that my version only was suitable for fixed-size arrays, 
> > > > which wasn't our goal. But I don't think we should go down to manually 
> > > > parsing property data. How about (tested;-))
> > > > 
> > > > 	data = of_find_property(node, "data-lanes", NULL);
> > > > 	if (data) {
> > > > 		int i = 0;
> > > > 		const __be32 *lane = NULL;
> > > > 		do {
> > > > 			lane = of_prop_next_u32(data, lane, &data_lanes[i]);
> > > > 		} while (lane && i++ < ARRAY_SIZE(data_lanes));
> > > > 		link->mipi_csi_2.num_data_lanes = i;
> > > > 		while (i--)
> > > > 			link->mipi_csi_2.data_lanes[i] = data_lanes[i];
> > > > 	}
> > > 
> > > Yes, that looks neat and does what it is supposed to do. :) Thanks!
> > > For now, I'll trust you it works ;)
> > > 
> > > With regards to the remaining patches, it looks a bit scary to me how
> > > complicated it got, perhaps mostly because of requirement to reference
> > > host devices from subdevs. And it seems to rely on the existing SoC
> > > camera infrastructure, which might imply lot's of work need to be done
> > > for non soc-camera drivers. But I'm going to take a closer look and
> > > comment more on the details at the corresponding patches.
> > 
> > I have to say that I agree with Sylwester here. It seems awfully complicated,
> > but I can't really put my finger on the actual cause.
> 
> Well, which exactly part? The V4L2 OF part is quite simple.

No, the soc_camera part. The V4L2 OF part looks OK. Sorry, I should have
mentioned that!

> > It would be really
> > interesting to see this implemented for a non-SoC device and to compare the
> > two.
> 
> Sure, volunteers? ;-) In principle, if I find time, I could try to convert 
> sh_vou, which is also interesting, because it's an output driver.
> 
> > One area that I do not yet completely understand is the i2c bus notifications
> > (or asynchronous loading or i2c modules).
> > 
> > I would have expected that using OF the i2c devices are still initialized
> > before the host/bridge driver is initialized. But I gather that's not the
> > case?
> 
> No, it's not. I'm not sure, whether it depends on the order of devices in 
> the .dts, but, I think, it's better to not have to mandate a certain order 
> and I also seem to have seen devices being registered in different order 
> with the same DT, but I'm not 100% sure about that.
> 
> > If this deferred probing is a general problem, then I think we need a general
> > solution as well that's part of the v4l2 core.
> 
> That can be done, perhaps. But we can do it as a next step. As soon as 
> we're happy with the OF implementation as such, we can commit that, 
> possibly leaving soc-camera patches out for now, then we can think where 
> to put async I2C handling.

It would be good to have a number of 'Reviewed-by's or 'Acked-by's for the
DT binding documentation at least before it is merged.

I think the soc_camera patches should be left out for now. I suspect that
by adding core support for async i2c handling first, the soc_camera patches
will become a lot easier to understand.

Regards,

	Hans

> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
