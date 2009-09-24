Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51138 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752324AbZIXSHK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Sep 2009 14:07:10 -0400
Date: Thu, 24 Sep 2009 20:07:27 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org
Subject: Re: V4L-DVB Summit Day 1
In-Reply-To: <200909232239.20105.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0909242000240.4913@axis700.grange>
References: <200909232239.20105.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans

Thanks for keeping us updated. One comment:

On Wed, 23 Sep 2009, Hans Verkuil wrote:

> In the afternoon we discussed the proposed timings API. There was no 
> opposition to this API. The idea I had to also use this for sensor setup 
> turned out to be based on a misconception on how the S_FMT relates to sensors. 
> ENUM_FRAMESIZES basically gives you the possible resolutions that the scaler 
> hidden inside the bridge can scale the native sensor resolution. It does not 
> enumerate the various native sensor resolutions, since there is only one. So 
> S_FMT really sets up the scaler.

Just as Jinlu Yu noticed in his email, this doesn't reflect the real 
situation, I am afraid. You can use binning and skipping on the sensor to 
scale the image, and you can also use the bridge to do the scaling, as you 
say. Worth than that, there's also a case, where there _several_ ways to 
perform scaling on the sensor, among which one can freely choose, and the 
host can scale too. And indeed it makes sense to scale on the source to 
save the bandwidth and thus increase the framerate. So, what I'm currently 
doing on sh-mobile, I try to scale on the client - in the best possible 
way. And then use bridge scaling to provide the exact result.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
