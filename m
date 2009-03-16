Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46724 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754429AbZCPUra (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 16:47:30 -0400
Date: Mon, 16 Mar 2009 21:47:17 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Trent Piepho <xyzzy@speakeasy.org>
cc: Robert Jarzmik <robert.jarzmik@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] pxa_camera: Enforce YUV422P frame sizes to be 16
 multiples
In-Reply-To: <Pine.LNX.4.58.0903161254510.28292@shell2.speakeasy.net>
Message-ID: <Pine.LNX.4.64.0903162146020.4409@axis700.grange>
References: <1236986240-24115-1-git-send-email-robert.jarzmik@free.fr>
 <1236986240-24115-2-git-send-email-robert.jarzmik@free.fr>
 <Pine.LNX.4.64.0903142359230.8263@axis700.grange> <8763i9fhn9.fsf@free.fr>
 <Pine.LNX.4.58.0903161254510.28292@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 16 Mar 2009, Trent Piepho wrote:

> On Mon, 16 Mar 2009, Robert Jarzmik wrote:
> > >> +	if (xlate->host_fmt->fourcc == V4L2_PIX_FMT_YUV422P) {
> > >> +		if (!IS_ALIGNED(pix->width * pix->height, PIX_YUV422P_ALIGN))
> > >> +			pix->height = ALIGN(pix->height, PIX_YUV422P_ALIGN / 2);
> > >> +		if (!IS_ALIGNED(pix->width * pix->height, PIX_YUV422P_ALIGN))
> > >> +			pix->width = ALIGN(pix->width, PIX_YUV422P_ALIGN / 2);
> > >
> > > Shouldn't this have been sqrt(PIX_YUV422P_ALIGN) (of course, not
> > > literally) instead of PIX_YUV422P_ALIGN / 2? At least above you say,
> > > height and width shall be 4 bytes aligned, not 8.
> > That's a very good catch.
> > Maybe 2 defines will fit better, as I'm not very please with log2 logic here ... :
> >
> > /*
> >  * YUV422P picture size should be a multiple of 16, so the heuristic aligns
> >  * height, width on 4 byte boundaries to reach the 16 multiple for the size.
> >  */
> > #define YUV422P_X_Y_ALIGN 4
> > #define YUV422P_SIZE_ALIGN YUV422P_X_Y_ALIGN * YUV422P_X_Y_ALIGN
> 
> Before you spend too much time on this, maybe I could offer a patch to use
> the generic alignment function I posted before?  I beleive the method in
> that code will produce better results I think there are multiple drivers
> that could make use of it.

As Robert already replied to you: submit your patches, get them into 
mainline, then we'll gladly switch to them if they suit our purpose.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
