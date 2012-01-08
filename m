Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:51981 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab2AHPsm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Jan 2012 10:48:42 -0500
Date: Sun, 8 Jan 2012 16:48:37 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/3] V4L: mt9m111: clean up and fix .s_crop() / .s_fmt()
In-Reply-To: <871uramduo.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.1201081647450.8175@axis700.grange>
References: <Pine.LNX.4.64.1112211649070.30646@axis700.grange> <871uramduo.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert

On Sun, 8 Jan 2012, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > Hi all
> >
> > While working on a context-switching test, I've cleaned up the mt9m111 
> > driver a bit and fixed its cropping and scaling functions. These are 
> > planned for 3.3.
> 
> Hi Guennadi,
> 
> I've looked more deeply into the patchset, and I have no comment, it all looks
> good. I've not been able to test it due to a ill tempered board, but I reviewed
> patches 1 and 2 with my manual, and patch 3 a bit, and checked compilation
> versus kernel 3.2.
> 
> So please find my:
> Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Thanks for the review and the ack, but I'm afraid it's a bit too late - 
the patches are already in next.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
