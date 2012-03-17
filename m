Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:63501 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab2CQJ4z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Mar 2012 05:56:55 -0400
Date: Sat, 17 Mar 2012 10:56:48 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Philipp Zabel <philipp.zabel@gmail.com>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] [media] V4L: pxa_camera: add clk_prepare/clk_unprepare
 calls
In-Reply-To: <87sjh7a7eu.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.1203171055530.24391@axis700.grange>
References: <1331835211.14662.5.camel@flow> <87sjh7a7eu.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert

On Sat, 17 Mar 2012, Robert Jarzmik wrote:

> Philipp Zabel <philipp.zabel@gmail.com> writes:
> 
> > This patch adds clk_prepare/clk_unprepare calls to the pxa_camera
> > driver by using the helper functions clk_prepare_enable and
> > clk_disable_unprepare.
> >
> > Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> > Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> > Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Cc: Robert Jarzmik <robert.jarzmik@free.fr>
> 
> Certainly, clocks have to be prepared before being enabled AFAIK.
> Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Thanks for the ack, but I've already pushed this patch up to Mauro. Now, 
only if he picks it up when pushing to Linus.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
