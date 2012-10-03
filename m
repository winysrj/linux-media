Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:55314 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741Ab2JCH54 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2012 03:57:56 -0400
Date: Wed, 3 Oct 2012 09:57:54 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Alex Pollard <apollard@eos-aus.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RE: Previewing PAL fields on framebuffer
In-Reply-To: <5F8EBA134B205E4088143663B38B1DC910D5DA74@EOSMX01.EOSAUS.LOCAL>
Message-ID: <Pine.LNX.4.64.1210030939080.26201@axis700.grange>
References: <5F8EBA134B205E4088143663B38B1DC910D5DA0F@EOSMX01.EOSAUS.LOCAL>
 <Pine.LNX.4.64.1210030844220.26201@axis700.grange>
 <5F8EBA134B205E4088143663B38B1DC910D5DA74@EOSMX01.EOSAUS.LOCAL>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please, don't drop the mailing list from the CC list.

On Wed, 3 Oct 2012, Alex Pollard wrote:

> Thanks!
> 
> I have found that in their demo application the capture board developer 
> (e-consystems) supports various interlacing options thru ioctl calls. So 
> I think I will find a solution.

Isn't specifying one of V4L2_FIELD_INTERLACED* values in standard V4L2 
ioctl()s enough? Or is this what you mean?

> The main issue now is the ability to do 
> overlays on the low-latency framebuffer preview, I am guessing 
> ipu_prp_vf_sdc_bg.c provides a way to accomplish this.

Sorry, I don't know what file you mean. In any case you'd have to 
implement overlay support in the mx3fb.c framebuffer driver.

Thanks
Guennadi

> Cheers,
> Alex
> 
> -----Original Message-----
> From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de] 
> Sent: Wednesday, 3 October 2012 5:06 PM
> To: Alex Pollard
> Cc: Linux Media Mailing List
> Subject: Re: Previewing PAL fields on framebuffer
> 
> Hi Alex
> 
> (added linux-media to CC on your request)
> 
> On Wed, 3 Oct 2012, Alex Pollard wrote:
> 
> > Hi,
> > 
> > I am wondering if it is possible to use the DMA features in 
> > drivers/dma/ipu/ipu_idmac.c to write the top field of a PAL frame into a 
> > framebuffer on alternating lines, and write the bottom field of the PAL 
> > frame to the other lines ie deinterlace.
> 
> Looking at the i.MX31 CSI documentation it seems it could be possible to 
> use CSI_SENS_FRM_SIZE and CSI_ACT_FRM_SIZE to specify stride != width to 
> basically do stride = 2 * width and then do 2 transfers per frame - one 
> beginning with line 0 and one beginning with line 1? But that's just an 
> idea, the description of those registers is vague and I'm also not sure 
> how to implement that.
> 
> Good luck
> Guennadi
> 
> > Do you know a good discussion 
> > list where I could post the question? I am using an i.MX53 but the 
> > support "community" is a bit quiet.
> > 
> > Thanks
> > 
> > Alex Pollard
> > Software Engineer
> > 
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
