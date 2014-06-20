Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:36717 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967160AbaFTMFY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jun 2014 08:05:24 -0400
Message-ID: <1403259897.2144.4.camel@palomino.walls.org>
Subject: Re: bttv and colorspace
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Fri, 20 Jun 2014 06:24:57 -0400
In-Reply-To: <53A3DDC7.50909@xs4all.nl>
References: <53A3DDC7.50909@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2014-06-20 at 09:07 +0200, Hans Verkuil wrote:
> Hi Mauro,
> 
> I wonder if you remember anything about the reported broken colorspace handling
> of bttv. The spec talks about V4L2_COLORSPACE_BT878 where the Y range is 16-253
> instead of the usual 16-235.
> 
> I downloaded a bt878 datasheet and that mentions the normal 16-235 range.
> 
> I wonder if this was perhaps a bug in older revisions of the bt878. Do you
> remember anything about this?

I have a Rockwell datasheet for the BrookTree 878/879 that has the Y
16-253 (16 is the pedestal level) and Cr/Cb 2-253 on page 118.

I will email to you off list.

Regards,
Andy 


>  I plan on doing some tests with my bttv cards
> next week.
> 
> The main reason I'm interested in this is that I am researching the colorspace
> handling in v4l2 (and how it is defined in the spec). That needs to be nailed
> down because today nobody really knows how it is supposed to work and it is a
> complicated topic.
> 
> Regards,
> 
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


