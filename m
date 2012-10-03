Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:55022 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab2JCHGL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2012 03:06:11 -0400
Date: Wed, 3 Oct 2012 09:06:09 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Alex Pollard <apollard@eos-aus.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Previewing PAL fields on framebuffer
In-Reply-To: <5F8EBA134B205E4088143663B38B1DC910D5DA0F@EOSMX01.EOSAUS.LOCAL>
Message-ID: <Pine.LNX.4.64.1210030844220.26201@axis700.grange>
References: <5F8EBA134B205E4088143663B38B1DC910D5DA0F@EOSMX01.EOSAUS.LOCAL>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex

(added linux-media to CC on your request)

On Wed, 3 Oct 2012, Alex Pollard wrote:

> Hi,
> 
> I am wondering if it is possible to use the DMA features in 
> drivers/dma/ipu/ipu_idmac.c to write the top field of a PAL frame into a 
> framebuffer on alternating lines, and write the bottom field of the PAL 
> frame to the other lines ie deinterlace.

Looking at the i.MX31 CSI documentation it seems it could be possible to 
use CSI_SENS_FRM_SIZE and CSI_ACT_FRM_SIZE to specify stride != width to 
basically do stride = 2 * width and then do 2 transfers per frame - one 
beginning with line 0 and one beginning with line 1? But that's just an 
idea, the description of those registers is vague and I'm also not sure 
how to implement that.

Good luck
Guennadi

> Do you know a good discussion 
> list where I could post the question? I am using an i.MX53 but the 
> support "community" is a bit quiet.
> 
> Thanks
> 
> Alex Pollard
> Software Engineer
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
