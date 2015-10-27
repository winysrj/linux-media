Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:64295 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437AbbJ0WHW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2015 18:07:22 -0400
Date: Tue, 27 Oct 2015 23:07:04 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/4] media: pxa_camera: fix the buffer free path
In-Reply-To: <87io5wwahg.fsf@belgarion.home>
Message-ID: <Pine.LNX.4.64.1510272306300.21185@axis700.grange>
References: <1441539733-19201-1-git-send-email-robert.jarzmik@free.fr>
 <87io5wwahg.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

Didn't you tell me, that your dmaengine patch got rejected and therefore 
these your patches were on hold?

Thanks
Guennadi

On Sat, 24 Oct 2015, Robert Jarzmik wrote:

> Robert Jarzmik <robert.jarzmik@free.fr> writes:
> 
> > Fix the error path where the video buffer wasn't allocated nor
> > mapped. In this case, in the driver free path don't try to unmap memory
> > which was not mapped in the first place.
> >
> > Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> > ---
> > Since v3: take into account the 2 paths possibilities to free_buffer()
> Okay Guennadi, it's been enough time.
> Could you you have another look at this serie please ?
> 
> Cheers.
> 
> --
> Robert
> 
