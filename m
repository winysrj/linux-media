Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:50757 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876Ab1FFUwU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 16:52:20 -0400
Date: Mon, 6 Jun 2011 22:52:18 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] V4L: pxa_camera: remove redundant calculations
In-Reply-To: <4DED3C3B.8090804@free.fr>
Message-ID: <Pine.LNX.4.64.1106062251500.11169@axis700.grange>
References: <Pine.LNX.4.64.1106061900480.11169@axis700.grange>
 <4DED3C3B.8090804@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 6 Jun 2011, Robert Jarzmik wrote:

> On 06/06/2011 07:02 PM, Guennadi Liakhovetski wrote:
> > soc_camera core now performs the standard .bytesperline and .sizeimage
> > calculations internally, no need to duplicate in drivers.
> Haven't I noticed that this patch is twofold :
>  - the calculation duplication
>  - the suspend/resume change from old suspend/resume to new v4l2_subdev power
> function
> 
> Shouldn't this patch have either the commit message amended, or even better be
> split into 2 distinct patches ?

Oops, yes, indeed, will split, thanks for catching!

> Apart from that, the patch looks ok to me.

Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
