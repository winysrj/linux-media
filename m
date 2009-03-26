Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35873 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828AbZCZVtm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 17:49:42 -0400
Date: Thu, 26 Mar 2009 18:49:23 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Dave Strauss <Dave.Strauss@zoran.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Darius Augulis <augulis.darius@gmail.com>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/5] CSI camera interface driver for MX1
Message-ID: <20090326184923.271b2cc2@pedra.chehab.org>
In-Reply-To: <49CBF437.7030603@zoran.com>
References: <49C89F00.1020402@gmail.com>
	<Pine.LNX.4.64.0903261405520.5438@axis700.grange>
	<49CBD53C.6060700@gmail.com>
	<20090326170910.6926d8de@pedra.chehab.org>
	<Pine.LNX.4.64.0903262116410.5438@axis700.grange>
	<49CBF437.7030603@zoran.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 26 Mar 2009 17:31:35 -0400
Dave Strauss <Dave.Strauss@zoran.com> wrote:

> Guennadi Liakhovetski wrote:
> > On Thu, 26 Mar 2009, Mauro Carvalho Chehab wrote:
> > 
> >>>>> +	/* common v4l buffer stuff -- must be first */
> >>>>> +	struct videobuf_buffer vb;
> >>>>>     
> >>>> Here you have one space
> >>>>
> >>>>   
> >>>>> +
> >>>>> +	const struct soc_camera_data_format        *fmt;
> >>>>>     
> >>>> Here you have 8 spaces
> >>>>
> >>>>   
> >>>>> +
> >>>>> +	int			inwork;
> >>>>>     
> >>>> Here you have tabs. Please, unify.
> >> Please always check your patches with checkpatch.pl. This will point such issues.
> > 
> > No, I did check the patch with checkpatch.pl and it didn't complain about 
> > this. It checks _indentation_ of lines, that _must_ be done with TABs, but 
> > it doesn't check what is used for alignment _inside_ lines, like
> > 
> > 	xxx     = 0;
> > 	y	= 1;
> > 	zzzzz   = 2;
> > 
> > where first and third lines have spaces before "=", and the second one has 
> > a TAB. This is not checked by checkpatch.pl.
> > 
> > Thanks
> > Guennadi
> > ---
> > Guennadi Liakhovetski
> > 
> 
> Newbie question -- where does one find checkpatch.pl?  And are there any other
> tools we should be running on patches before we submit them?


It is at kernel tree, under script directory. You shouldn't copy it from kernel
tree, but to use it from there, to get optimum results, since it will read some
files a kernel documentation, for checking the usage of legacy functions.
> 
> Thanks.
> 
>   - Dave Strauss




Cheers,
Mauro
