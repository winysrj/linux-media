Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:56498 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753140AbcHXLra (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Aug 2016 07:47:30 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 0/9] Prepare Sphinx to build media PDF books
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160824074213.56fe8e50@vento.lan>
Date: Wed, 24 Aug 2016 13:46:48 +0200
Cc: Jonathan Corbet <corbet@lwn.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <7E41034C-DBBE-4AC0-A533-E03A501EBEE0@darmarit.de>
References: <cover.1471364025.git.mchehab@s-opensource.com> <20160818172127.190fad79@lwn.net> <20160824074213.56fe8e50@vento.lan>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 24.08.2016 um 12:42 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> Markus,
> 
> Em Thu, 18 Aug 2016 17:21:27 -0600
> Jonathan Corbet <corbet@lwn.net> escreveu:
> 
>> On Tue, 16 Aug 2016 13:25:34 -0300
>> Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
>> 
>>> I think this patch series belong to docs-next. Feel free to merge them there, if
>>> you agree. There's one extra patch that touches Documentation/conf.py,
>>> re-adding the media book to the PDF build, but IMHO this one would be better
>>> to be merged via the media tree, after the fixes inside the media documentation
>>> to fix the build.  
>> 
>> It's now in docs-next.  I was able to build some nice-looking docs with it
>> without too much (additional) pain...
> 
> I'm noticing a very weird behavior when I'm building documentation on
> my server. There, I'm using this command:
> 
> 	$ make cleandocs; make V=1 DOCBOOKS="" SPHINXDIRS=media SPHINX_CONF="conf.py" htmldocs

Hi Mauro,

if you build a sub-folder, the conf.py is the default. You don't need 
to name conf.py it explicit and you can leave the DOCBOOKS env.

$ make V=1 SPHINXDIRS=media cleandocs htmldocs

or less verbose:

$ make SPHINXDIRS=media cleandocs htmldocs

But this does not answer your question ;)

> This is what happens on my local machine:
> 	http://pastebin.com/VGqvDa7T

Seems to build fine. But this is not "make V=1" log.

> And this is the result of the same command on my server, accessed via ssh:
> 	http://pastebin.com/1MFi5LEG

Same here, it is not a "make V=1" log. The errors like:

 WARNING: inline latex u"L' = L ^{\\frac{1}{2.19921875}}": latex exited with error

are dubious first. Which branch did you compile. It seems you are
using "inline latex" ... this seems not in Jon's docs-next.
I checked your experimental docs-next, there is a related
markup, so I think you compiling this branch.

.. math::

   L' = L ^{\frac{1}{2.19921875}}

So I guess the error message is related to one of the sphinx-extensions:

# The name of the math extension changed on Sphinx 1.4
if minor > 3:
   extensions.append("sphinx.ext.imgmath")
else:
   extensions.append("sphinx.ext.pngmath")

Since there is a log "Running Sphinx v1.4.6" (both, desktop and server) I
guess it is related to the sphinx.ext.imgmath extension.

I haven't tested math-extensions yet, I will give it a try
and send you my experience later. In the meantime you can check
your math-extensions on desktop and server ...

In general I guess: 

0.) you compiling different branches

or

1.) on your desktop the math-extension miss some latex stuff
and does not run, so you get no errors (or it runs perfect
without any error).

or / and

2.) on your server the math-extension runs and has some 
problems with the "L' = L ^{\frac{1}{2.19921875}}" expression.


> As you can see, it seems that internally sphinx is calling a
> make -C Documentation/output/latex, with is very bad, because it takes
> a lot of extra time to run and produces an useless output. It also produces 
> a wrong output, as it would be calling pdflatex, instead of xelatex.

As said, I haven't tested math-extensions yet. But the math extension 
uses "latex" as default / not xelatex 

* imgmath_latex: http://www.sphinx-doc.org/en/stable/ext/math.html#module-sphinx.ext.imgmath
* pngmath_latex: https://linuxtv.org/downloads/sphinx-1.2.3/ext/math.html#module-sphinx.ext.pngmath

> Do you have any glue about what's going on?

No ;-)  ... check the math-extension process as described above.

> Also, if I use the "-j33" sphinx option, it complains:
> 
> WARNING: the kernel_include extension does not declare if it is safe for parallel reading, assuming it isn't - please ask the extension author to check and make it explicit
> WARNING: doing serial read

Yes I know, it is the same with the kernel_doc extension, I can send a patch for both.

> Btw, we need to add support to build just one PDF file, as we did with
> the htmldocs.

You mean, when you build a subfolder (SPHINXDIRS=media), you wanted
to build a PDF with only media stuff in .. right? .. thats what 
I suggested in one of my last mails .. I can sent a patch for this.

-- Markus --


