Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:33318 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750778AbbECRW5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 May 2015 13:22:57 -0400
Message-ID: <55465967.4060405@xs4all.nl>
Date: Sun, 03 May 2015 19:22:47 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: soc-camera: opinion poll - future directions
References: <Pine.LNX.4.64.1505031800140.4237@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1505031800140.4237@axis700.grange>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 05/03/2015 06:11 PM, Guennadi Liakhovetski wrote:
> Hi all,
> 
> Just a quick opinion poll - where and how should the soc-camera framework 
> and drivers be heading? Possible (probably not all) directions:
> 
> (1) all is good, keep as is. That means keep all drivers, killing them off 
> only when it becomes very obvious, that noone wants them, keep developing 
> drivers, that are still being used and updating all of them on any API 
> updates. Keep me as maintainer, which means slow patch processing rate and 
> no active participation in new developments - at hardware, soc-camera or 
> V4L levels.
> 
> (2) we want more! I.e. some contributors are planning to either add new 
> drivers to it or significantly develop existing ones, see significant 
> benefit in it. In this case it might become necessary to replace me with 
> someone, who can be more active in this area.
> 
> (3) slowly phase out. Try to either deprecate and remove soc-camera 
> drivers one by one or move them out to become independent V4L2 host or 
> subdevice drivers, but keep updating while still there.
> 
> (4) basically as (3) but even more aggressively - get rid of it ASAP:)
> 
> Opinions? Expecially would be interesting to hear from respective 
> host-driver maintainers / developers, sorry, not adding CCs, they probably 
> read the list anyway:)

I'm closest to 1. I would certainly not use it for new drivers, I see no
reason to do that anymore. The core frameworks are quite good these days
and I think the need for soc-camera has basically disappeared. But there
is no need to phase out or remove soc-camera drivers (unless they are
clearly broken and nobody will fix them). And if someone wants to turn
a soc-camera driver into a standalone driver, then I would encourage
that.

However, there are two things that need work fairly soon:

1) the dependency of subdev drivers on soc_camera: that has to go. I plan
to work on that, but the first step is to replace the video crop ops by
the pad selection ops. I finally got my Renesas sh7724 board up and running,
so I hope to make progress on this soon. I'll update soc-camera as well
to conform to v4l2-compliance. Once that's done I will investigate how to
remove the soc-camera dependency.

The soc-camera dependency kills the reusability of those drivers and it
really needs to be addressed.

2) Converting soc-camera videobuf drivers to vb2. At some point vb1 will be
removed, so any remaining vb1 driver will likely be killed off if nobody does
the conversion. I believe it is only omap1 and pxa that still use videobuf.

I think omap1 might be a candidate for removal, but I don't know about the pxa.
Guennadi, what is the status of these drivers? If I would do a vb2 conversion
for the pxa, would you be able to test it?

Regards,

	Hans
