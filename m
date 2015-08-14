Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46249 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbbHNNEX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2015 09:04:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Helen Fornazier <helen.fornazier@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/7] [media] vimc: sen: Integrate the tpg on the sensor
Date: Fri, 14 Aug 2015 16:05:21 +0300
Message-ID: <3258949.42PN1APzHG@avalon>
In-Reply-To: <55CDDBFE.3020905@xs4all.nl>
References: <cover.1438891530.git.helen.fornazier@gmail.com> <e3c80eb0aebe828d2df72be9971ad720f439bb71.1438891530.git.helen.fornazier@gmail.com> <55CDDBFE.3020905@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 14 August 2015 14:15:58 Hans Verkuil wrote:
> On 08/06/2015 10:26 PM, Helen Fornazier wrote:
> > Initialize the test pattern generator on the sensor
> > Generate a colored bar image instead of a grey one
> 
> You don't want to put the tpg in every sensor and have all the blocks in
> between process the video. This is all virtual, so all that is necessary
> is to put the tpg in every DMA engine (video node) but have the subdevs
> modify the tpg setting when you start the pipeline.
> 
> So the source would set the width/height to the sensor resolution, and it
> will initialize the crop/compose rectangles. Every other entity in the
> pipeline will continue modifying according to what they do. E.g. a scaler
> will just change the compose rectangle.
> 
> When you start streaming the tpg will generate the image based on all those
> settings as if all the entities would actually do the work.
> 
> Of course, this assumes the processing the entities do map to what the tpg
> can do, but that's true for vimc.

There will be small differences, as generating a YUV image won't be exactly 
the same as debayering a bayer image. It probably doesn't matter much though.

A bigger problem is that the driver aims at supporting output video device 
nodes at some point in mem-to-mem pipelines. For that the debayer, color space 
conversion and scaler subdevs need to perform real image processing.

> An additional advantage is that the entities can use a wide range of
> mediabus formats since the tpg can generate basically anything. Implementing
> multiplanar is similarly easy. This would be much harder if you had to
> write the image processing code for the entities since you'd either have to
> support lots of different formats (impractical) or limit yourself to just a
> few.

-- 
Regards,

Laurent Pinchart

