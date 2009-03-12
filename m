Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52497 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753815AbZCLWMz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 18:12:55 -0400
Date: Thu, 12 Mar 2009 23:12:55 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 4/4] pxa_camera: Fix overrun condition on last buffer
In-Reply-To: <87bps61kzp.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0903122312050.10558@axis700.grange>
References: <1236282351-28471-1-git-send-email-robert.jarzmik@free.fr>
 <1236282351-28471-2-git-send-email-robert.jarzmik@free.fr>
 <1236282351-28471-3-git-send-email-robert.jarzmik@free.fr>
 <1236282351-28471-4-git-send-email-robert.jarzmik@free.fr>
 <1236282351-28471-5-git-send-email-robert.jarzmik@free.fr>
 <Pine.LNX.4.64.0903111930300.4818@axis700.grange> <87bps61kzp.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 12 Mar 2009, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> >> diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
> >> index 16bf0a3..dd56c35 100644
> >> --- a/drivers/media/video/pxa_camera.c
> >> +++ b/drivers/media/video/pxa_camera.c
> >> @@ -734,14 +734,18 @@ static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
> >>  		status & DCSR_ENDINTR ? "EOF " : "", vb, DDADR(channel));
> >>  
> >>  	if (status & DCSR_ENDINTR) {
> >> -		if (camera_status & overrun) {
> >> +		/*
> >> +		 * It's normal if the last frame creates an overrun, as there
> >> +		 * are no more DMA descriptors to fetch from QIF fifos
> >> +		 */
> >> +		if (camera_status & overrun
> >> +		    && !list_is_last(pcdev->capture.next, &pcdev->capture)) {
> >
> > On a second look - didn't you want to test for ->active being the last?
> 
> Mmm, I'm not sure I get you right here. AFAICR pcdev->active has no direct link
> with pcdev->capture (it has nothing to do with a list_head *). Of course with a
> bit of "container_of" magic (or list_entry equivalent), I'll find it ...

Ah, sorry, scratch it, I now understand what you're doing here, looks ok.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
