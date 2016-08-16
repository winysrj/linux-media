Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58583
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbcHPQvT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 12:51:19 -0400
Date: Tue, 16 Aug 2016 13:51:12 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC v2 3/9] docs-rst: Don't mangle with UTF-8 chars on
 LaTeX/PDF output
Message-ID: <20160816135112.4207b489@vento.lan>
In-Reply-To: <1C2F668D-41DD-4682-89D9-639430AAF3A6@darmarit.de>
References: <cover.1471294965.git.mchehab@s-opensource.com>
	<5ceebc273ff089c275c753c78f6e6c6e732b4077.1471294965.git.mchehab@s-opensource.com>
	<4483E8C4-BBAC-4866-881D-3FBA5B85E834@darmarit.de>
	<20160816063605.6ef0ed27@vento.lan>
	<20160816080338.56c6e5d1@vento.lan>
	<1C2F668D-41DD-4682-89D9-639430AAF3A6@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 16 Aug 2016 13:48:13 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Am 16.08.2016 um 13:03 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> 
> > Em Tue, 16 Aug 2016 06:36:05 -0300
> > Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:
> > 
> > 2) the Latex auto-generated Makefile is hardcoded to use pdflatex. So,
> > I had to manually replace it to xelatex. One easy solution would be to
> > not use Make -C $BUILDDIR/latex, but to just call xelatex $BUILDDIR/$tex_name.  
> 
> I recommend to ship your own tex-Makefile, see:
> 
>   https://lkml.org/lkml/2016/8/10/114

That makes sense for me, but let the others review what we have so far.
We can later improve and use a makefile for tex. I would prefer to call
the version that will be copied to the output dir with a different name
(like Makefile.tex or Makefile.in), as I found really weird to have a
file called Makefile inside the Kernel tree that contains just a makefile
prototype.

Regards,
Mauro
