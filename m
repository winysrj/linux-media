Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58593
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbcHPQwG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 12:52:06 -0400
Date: Tue, 16 Aug 2016 13:52:00 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC v2 3/9] docs-rst: Don't mangle with UTF-8 chars on
 LaTeX/PDF output
Message-ID: <20160816135200.0de5e3f9@vento.lan>
In-Reply-To: <17A830EF-36AB-4C9A-9B97-351CB9A37664@darmarit.de>
References: <cover.1471294965.git.mchehab@s-opensource.com>
	<5ceebc273ff089c275c753c78f6e6c6e732b4077.1471294965.git.mchehab@s-opensource.com>
	<4483E8C4-BBAC-4866-881D-3FBA5B85E834@darmarit.de>
	<20160816063605.6ef0ed27@vento.lan>
	<20160816080338.56c6e5d1@vento.lan>
	<20160816091657.59926b39@vento.lan>
	<17A830EF-36AB-4C9A-9B97-351CB9A37664@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 16 Aug 2016 14:35:16 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Am 16.08.2016 um 14:16 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> 
> ...
> > The only issue there was the name of the math extension, with is also
> > sphinx.ext.pngmath. On a plus side, I was also able to remove one of the
> > hacks, by applying the enclosed patch (this doesn't work on 1.4 yet - 
> > I suspect it requires some extra stuff to escape).
> > 
> > So, for me, we're pretty much safe using xelatex, as it works fine for
> > Sphinx 1.3 and 1.4 (and, with Sphinx 1.2, provided that the user asks to
> > continue the build, just like what's needed with pdflatex on such
> > version).
> > 
> > To make it generic, we'll need to patch conf.py to detect the Sphinx
> > version, and use the right math extension, depending on the version.
> > Also, as you proposed, Due to Sphinx version is 1.2, we'll need to use a
> > custom-made Makefile for tex.
> > 
> > As xelatex support was added for version 1.5, we don't need to care
> > about it.  
> 
> I haven't checked on which version which math-extension was
> replaced. But it is easy to detect the sphinx version in conf.py.
> Add these lines to conf.py::
> 
>   import sphinx
>   major, minor, patch = map(int, sphinx.__version__.split("."))
> 
> The "minor" is what you are looking for.
> 
>   if minor > 3:
>       extensions.append("sphinx.ext.imgmath")
>   else:
>       extensions.append("sphinx.ext.pngmath")

Worked, thanks!

Added on the patch series I submitted.

Regards,
Mauro
