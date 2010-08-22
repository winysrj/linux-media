Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:40793 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751708Ab0HVSHJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Aug 2010 14:07:09 -0400
Date: Sun, 22 Aug 2010 20:07:28 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Michael Grzeschik <mgr@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 00/11] MT9M111/MT9M131
In-Reply-To: <87fwybn6da.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.1008222003560.872@axis700.grange>
References: <1280833069-26993-1-git-send-email-m.grzeschik@pengutronix.de>
 <20100817131742.GB16061@pengutronix.de> <87fwybn6da.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi Robert

On Wed, 18 Aug 2010, Robert Jarzmik wrote:

> Michael Grzeschik <mgr@pengutronix.de> writes:
> 
> > Hi Robert, Guennadi,
> >
> > after the messed up previous patchseries, this v2 series is left
> > without any feedback. Hopefully not forgotten. :-)
> No, not forgotten.
> 
> I need a week, but Guennadi can superseed me anytime if he is the first to fire
> :)

Well, I looked through remaining patches 3-11, they look ok, but of course 
I cannot test patch 10, which is the most intrusive one. Patch 5 is also 
changing behaviour, but since indeed 26 black columns are specified in the 
datasheet (also for mt9m111), it should be ok. So, Robert, I'll wait for 
your review and test results, if you don't mind. We still have a bit of 
time until the 2.6.37 merge window, so, should be ok.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
