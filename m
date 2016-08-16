Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57446
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbcHPMRi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 08:17:38 -0400
Date: Tue, 16 Aug 2016 09:16:57 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC v2 3/9] docs-rst: Don't mangle with UTF-8 chars on
 LaTeX/PDF output
Message-ID: <20160816091657.59926b39@vento.lan>
In-Reply-To: <20160816080338.56c6e5d1@vento.lan>
References: <cover.1471294965.git.mchehab@s-opensource.com>
	<5ceebc273ff089c275c753c78f6e6c6e732b4077.1471294965.git.mchehab@s-opensource.com>
	<4483E8C4-BBAC-4866-881D-3FBA5B85E834@darmarit.de>
	<20160816063605.6ef0ed27@vento.lan>
	<20160816080338.56c6e5d1@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 16 Aug 2016 08:03:38 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> Em Tue, 16 Aug 2016 06:36:05 -0300
> Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> Did some tests on Jessie. texlive required 219 packages there, 771MB.

...

> There are 2 issues there that are easy to solve, but would require some
> extra logic. I added a quick hack to make them build with xelatex.
> See enclosed. The issues are:
> 
> 1) the name of the math extension changed from sphinx.ext.pngmath to
> sphinx.ext.imgmath on Sphinx 1.4. I guess it should be possible to add
> some logic at conf.py to change the include depending on the Sphinx
> version;
> 
> 2) the Latex auto-generated Makefile is hardcoded to use pdflatex. So,
> I had to manually replace it to xelatex. One easy solution would be to
> not use Make -C $BUILDDIR/latex, but to just call xelatex $BUILDDIR/$tex_name.

...

> I'll try to install Ubuntu Xenial on a LXC container and repeat the test
> there. Xenial seems to use Sphinx 1.3.6, according with:
> 	http://packages.ubuntu.com/search?keywords=python-sphinx

On Ubuntu Xenial LXC container, I had to install:
	texlive-xetex python3-sphinx python3-sphinx-rtd-theme ttf-dejavu make gcc python3-sphinx-rtd-theme

With actually installed 259 packages, 1,6 GB after install (about 800MB
of download).

The only issue there was the name of the math extension, with is also
sphinx.ext.pngmath. On a plus side, I was also able to remove one of the
hacks, by applying the enclosed patch (this doesn't work on 1.4 yet - 
I suspect it requires some extra stuff to escape).

So, for me, we're pretty much safe using xelatex, as it works fine for
Sphinx 1.3 and 1.4 (and, with Sphinx 1.2, provided that the user asks to
continue the build, just like what's needed with pdflatex on such
version).

To make it generic, we'll need to patch conf.py to detect the Sphinx
version, and use the right math extension, depending on the version.
Also, as you proposed, Due to Sphinx version is 1.2, we'll need to use a
custom-made Makefile for tex.

As xelatex support was added for version 1.5, we don't need to care
about it.

Jon,

What do you think? Let's move to xelatex?

Thanks,
Mauro

diff --git a/Documentation/Makefile.sphinx b/Documentation/Makefile.sphinx
index 8aa4fffda860..aa7ff32be589 100644
--- a/Documentation/Makefile.sphinx
+++ b/Documentation/Makefile.sphinx
@@ -49,7 +49,6 @@ ifeq ($(HAVE_PDFLATEX),0)
 	@echo "  SKIP    Sphinx $@ target."
 else # HAVE_PDFLATEX
 	$(call cmd,sphinx,latex)
-	(cd $(BUILDDIR); for i in *.rst; do echo >$$i; done)
 	$(Q)$(MAKE) PDFLATEX=xelatex -C $(BUILDDIR)/latex
 endif # HAVE_PDFLATEX
 
diff --git a/Documentation/conf.py b/Documentation/conf.py
index 2bc91fcc6d1f..0a32d6b493e8 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -28,7 +28,7 @@ sys.path.insert(0, os.path.abspath('sphinx'))
 # Add any Sphinx extension module names here, as strings. They can be
 # extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
 # ones.
-extensions = ['sphinx.ext.imgmath', 'kernel-doc', 'rstFlatTable', 'kernel_include']
+extensions = ['sphinx.ext.pngmath', 'kernel-doc', 'rstFlatTable', 'kernel_include']
 
 # Add any paths that contain templates here, relative to this directory.
 templates_path = ['_templates']
diff --git a/Documentation/sphinx/parse-headers.pl b/Documentation/sphinx/parse-headers.pl
index 34bd9e2630b0..74089b0da798 100755
--- a/Documentation/sphinx/parse-headers.pl
+++ b/Documentation/sphinx/parse-headers.pl
@@ -220,7 +220,7 @@ $data =~ s/\n\s+\n/\n\n/g;
 #
 # Add escape codes for special characters
 #
-$data =~ s,([\_\`\*\<\>\&\\\\:\/\|]),\\$1,g;
+$data =~ s,([\_\`\*\<\>\&\\\\:\/\|\%\$\#\{\}\~\^]),\\$1,g;
 
 $data =~ s,DEPRECATED,**DEPRECATED**,g;
 

