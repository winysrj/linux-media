Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49105 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922AbZFQXnV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 19:43:21 -0400
Date: Wed, 17 Jun 2009 20:43:16 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: typo: v4l2_bound_align_image name mismatch.
Message-ID: <20090617204316.7fad9a6b@pedra.chehab.org>
In-Reply-To: <Pine.LNX.4.58.0906170911390.32713@shell2.speakeasy.net>
References: <20090617111330.0ba40210@pedra.chehab.org>
	<Pine.LNX.4.58.0906170911390.32713@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 17 Jun 2009 09:17:21 -0700 (PDT)
Trent Piepho <xyzzy@speakeasy.org> escreveu:

> On Wed, 17 Jun 2009, Mauro Carvalho Chehab wrote:
> > It seems that there's a typo error at pxa-camera. One more fix for the align stuff.
> 
> Sorry about that.  I did the pxa patch first, then changed the name of
> function before finding other drivers to patch and didn't go back and fix
> the pxa patch.
> 
> 01/02: v4l2: Fix flaw in alignment code
> http://linuxtv.org/hg/~tap/fix?cmd=changeset;node=4ef7fb102b6c
> 
> 02/02: pxa-camera: fix typo
> http://linuxtv.org/hg/~tap/fix?cmd=changeset;node=1ca713eae3b4

Applied, thanks.

I'll fold both patches on your original ones at -git. It is important to fold
the second one to avoid bisect breakages.

> 
> > Forwarded message:
> >
> > Date: Wed, 17 Jun 2009 13:47:57 +0000
> > From: Jonathan Cameron <jic23@cam.ac.uk>
> > To: Linux Media Mailing List <linux-media@vger.kernel.org>,  Mauro Carvalho Chehab <mchehab@infradead.org>
> > Subject: typo: v4l2_bound_align_image name mismatch.
> >
> >
> > Just came across a build error with pxa_camera with Mauro's linux-next tree.
> >
> > pxa-camera calls v4l2_bound_align_image whereas the function is called
> > v4l_bound_align_image.
> >
> > Cheers,
> >
> > ---
> > Jonathan Cameron
> >
> >
> >
> >
> > Cheers,
> > Mauro
> >




Cheers,
Mauro
