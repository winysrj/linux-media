Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:58290 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbbFGTBl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2015 15:01:41 -0400
Date: Sun, 7 Jun 2015 15:25:01 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Daniel Mack <zonque@gmail.com>
Subject: Re: [PATCH 0/4] media: pxa_camera conversion to dmaengine
In-Reply-To: <87sia44jer.fsf@belgarion.home>
Message-ID: <alpine.DEB.2.00.1506071522520.17147@axis700.grange>
References: <1426980085-12281-1-git-send-email-robert.jarzmik@free.fr> <87oal5zvez.fsf@belgarion.home> <87sia44jer.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

I've sent you two replies, did you get them? Spam filter?

Thanks
Guennadi

On Sat, 6 Jun 2015, Robert Jarzmik wrote:

> Robert Jarzmik <robert.jarzmik@free.fr> writes:
> 
> > Robert Jarzmik <robert.jarzmik@free.fr> writes:
> >
> >> Hi Guennadi,
> >>
> >> I've been cooking this since 2012. At that time, I thought the dmaengine API was
> >> not rich enough to support the pxa_camera subtleties (or complexity).
> >>
> >> I was wrong. I submitted a driver to Vinod for a dma pxa driver which would
> >> support everything needed to make pxa_camera work normally.
> >>
> >> As a consequence, I wrote this serie. Should the pxa-dma driver be accepted,
> >> then this serie will be my next move towards pxa conversion to dmaengine. And to
> >> parallelize the review work, I'll submit it right away to receive a review and
> >> fix pxa_camera so that it is ready by the time pxa-dma is also reviewed.
> > Hi Guennadi,
> >
> > Any update on this serie ? The pxa-dma driver is upstreamed now.
> 
> Guennadi, are you around ?
> 
> Cheers.
> 
> -- 
> Robert
> 
