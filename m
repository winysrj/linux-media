Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:54708 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab2CTNLU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 09:11:20 -0400
Date: Tue, 20 Mar 2012 14:11:08 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Fabio Estevam <festevam@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, mchehab@infradead.org,
	kernel@pengutronix.de, Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] video: mx3_camera: Allocate camera object via kzalloc
In-Reply-To: <CAOMZO5B=0LMqi-v-KwJkvsBEqUU+Bj8TRo08i7zGSv97jnZpVQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1203201409420.21870@axis700.grange>
References: <1329761467-14417-1-git-send-email-festevam@gmail.com>
 <Pine.LNX.4.64.1202201916410.2836@axis700.grange>
 <CAOMZO5AAeqHZFqpZYB_riSCQvCRSjQtR2EqpZvC5V3TRyzuWJQ@mail.gmail.com>
 <4F67E4FD.2070709@redhat.com> <Pine.LNX.4.64.1203200851300.20315@axis700.grange>
 <CAOMZO5CJHkb1JrAd+DYvYP-DrV6XsqO3wtoxJGe_s9sE1tQktw@mail.gmail.com>
 <Pine.LNX.4.64.1203201340300.21870@axis700.grange>
 <CAOMZO5B=0LMqi-v-KwJkvsBEqUU+Bj8TRo08i7zGSv97jnZpVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 20 Mar 2012, Fabio Estevam wrote:

> On 3/20/12, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> >> Is this valid only for mx3_camera driver?
> >
> > No
> >
> >> All other soc camera drivers use kzalloc.
> >>
> >> What makes mx3_camera different in this respect?
> >
> > Nothing
> 
> Ok, so isn't my patch correct then?

No. It doesn't improve anything.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
