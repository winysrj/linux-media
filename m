Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55066 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759410AbZCZUT7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 16:19:59 -0400
Date: Thu, 26 Mar 2009 21:19:54 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Darius Augulis <augulis.darius@gmail.com>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/5] CSI camera interface driver for MX1
In-Reply-To: <20090326170910.6926d8de@pedra.chehab.org>
Message-ID: <Pine.LNX.4.64.0903262116410.5438@axis700.grange>
References: <49C89F00.1020402@gmail.com> <Pine.LNX.4.64.0903261405520.5438@axis700.grange>
 <49CBD53C.6060700@gmail.com> <20090326170910.6926d8de@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 26 Mar 2009, Mauro Carvalho Chehab wrote:

> > >> +	/* common v4l buffer stuff -- must be first */
> > >> +	struct videobuf_buffer vb;
> > >>     
> > >
> > > Here you have one space
> > >
> > >   
> > >> +
> > >> +	const struct soc_camera_data_format        *fmt;
> > >>     
> > >
> > > Here you have 8 spaces
> > >
> > >   
> > >> +
> > >> +	int			inwork;
> > >>     
> > >
> > > Here you have tabs. Please, unify.
> 
> Please always check your patches with checkpatch.pl. This will point such issues.

No, I did check the patch with checkpatch.pl and it didn't complain about 
this. It checks _indentation_ of lines, that _must_ be done with TABs, but 
it doesn't check what is used for alignment _inside_ lines, like

	xxx     = 0;
	y	= 1;
	zzzzz   = 2;

where first and third lines have spaces before "=", and the second one has 
a TAB. This is not checked by checkpatch.pl.

Thanks
Guennadi
---
Guennadi Liakhovetski
