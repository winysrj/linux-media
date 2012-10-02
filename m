Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:31965 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab2JBKNX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 06:13:23 -0400
Message-id: <506ABE40.9070504@samsung.com>
Date: Tue, 02 Oct 2012 12:13:20 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 05/14] media: add a V4L2 OF parser
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de>
 <1348754853-28619-6-git-send-email-g.liakhovetski@gmx.de>
 <506A0D28.10505@gmail.com> <Pine.LNX.4.64.1210021142210.15778@axis700.grange>
In-reply-to: <Pine.LNX.4.64.1210021142210.15778@axis700.grange>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 10/02/2012 11:49 AM, Guennadi Liakhovetski wrote:
>>> +	if (!of_property_read_u32_array(node, "data-lanes", data_lanes,
>>> +					ARRAY_SIZE(data_lanes))) {
>>> +		int i;
>>> +		for (i = 0; i<  ARRAY_SIZE(data_lanes); i++)
>>> +			link->mipi_csi_2.data_lanes[i] = data_lanes[i];
>>
>> It doesn't look like what we aimed for. The data-lanes array is supposed
>> to be of variable length, thus I don't think it can be parsed like that. 
>> Or am I missing something ? I think we need more something like below 
>> (based on of_property_read_u32_array(), not tested):
> 
> Ok, you're right, that my version only was suitable for fixed-size arrays, 
> which wasn't our goal. But I don't think we should go down to manually 
> parsing property data. How about (tested;-))
> 
> 	data = of_find_property(node, "data-lanes", NULL);
> 	if (data) {
> 		int i = 0;
> 		const __be32 *lane = NULL;
> 		do {
> 			lane = of_prop_next_u32(data, lane, &data_lanes[i]);
> 		} while (lane && i++ < ARRAY_SIZE(data_lanes));
> 		link->mipi_csi_2.num_data_lanes = i;
> 		while (i--)
> 			link->mipi_csi_2.data_lanes[i] = data_lanes[i];
> 	}

Yes, that looks neat and does what it is supposed to do. :) Thanks!
For now, I'll trust you it works ;)

With regards to the remaining patches, it looks a bit scary to me how
complicated it got, perhaps mostly because of requirement to reference
host devices from subdevs. And it seems to rely on the existing SoC
camera infrastructure, which might imply lot's of work need to be done
for non soc-camera drivers. But I'm going to take a closer look and
comment more on the details at the corresponding patches.

--

Regards,
Sylwester
