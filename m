Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57207
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbcHPLGU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 07:06:20 -0400
Date: Tue, 16 Aug 2016 08:03:38 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC v2 3/9] docs-rst: Don't mangle with UTF-8 chars on
 LaTeX/PDF output
Message-ID: <20160816080338.56c6e5d1@vento.lan>
In-Reply-To: <20160816063605.6ef0ed27@vento.lan>
References: <cover.1471294965.git.mchehab@s-opensource.com>
	<5ceebc273ff089c275c753c78f6e6c6e732b4077.1471294965.git.mchehab@s-opensource.com>
	<4483E8C4-BBAC-4866-881D-3FBA5B85E834@darmarit.de>
	<20160816063605.6ef0ed27@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 16 Aug 2016 06:36:05 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> Em Tue, 16 Aug 2016 10:27:34 +0200
> Markus Heiser <markus.heiser@darmarit.de> escreveu:
> 
> > Am 15.08.2016 um 23:21 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> >   
> > > pdflatex doesn't accept using some UTF-8 chars, like
> > > "equal or less than" or "equal or greater than" chars. However,
> > > the media documents use them. So, we need to use XeLaTeX for
> > > conversion, and a font that accepts such characters.    
> > 
> > Right, we should use the XeLaTeX engine. But ...
> > 
> > Sphinx LaTeX output was/is developed for LaTeX, not for XeLaTeX.  
> 
> Yes, but official support for XeLaTeX was added for 1.5:
> 	https://github.com/agda/agda/commit/a6a437316c9b9d998e6d6d0a6a654a63422a4212
> 
> And the change there was really simple: it just adds it to the generated
> Makefile.
> 
> > E.g. in its defaults it uses "inputenc" and other stuff which
> > is not a part of XeLaTeX.
> > 
> > * https://github.com/sphinx-doc/sphinx/issues/894#issuecomment-220786426
> > 
> > This patch removes the "inputenc", thats right, but I think over
> > short/long term we will see more errors related to LaTeX/XeLaTeX
> > distinction.   
> 
> Actually, I don't expect troubles at long term, as it is now officially
> supported.
> 
> > And we will see that some conversion will break, depending
> > on the sphinx version we use (There might be some non XeLateX friendly 
> > changes in the sphinx-versions, since it is not tested with XeLaTeX).  
> 
> Yeah, we need to double-check backward compatibility, and eventually
> disable it on older versions.
> 
> I can't easily test version 1.3.x anymore, as Fedora 24 upgraded to
> Sphinx 1.4.4. The book builds fine on both 1.4.4 and 1.4.5.
> 
> I'll install a Debian Jessie LXC container and double-check if the build
> is fine with Sphinx version 1.2.x and check the package requirements.

Did some tests on Jessie. texlive required 219 packages there, 771MB.
The packages I installed there are:

	# 219 packages, 771MB - and includes some non-tex packages, that
	# are not present on the minimal LXC container install
	texlive-xetex

	# 24 packages, 7289kB
	python3-sphinx

	# 2 packages, 373kB
	python3-sphinx-rtd-theme

	# Build environment: 19 packages
	make gcc

	# Fonts
	ttf-dejavu

There are 2 issues there that are easy to solve, but would require some
extra logic. I added a quick hack to make them build with xelatex.
See enclosed. The issues are:

1) the name of the math extension changed from sphinx.ext.pngmath to
sphinx.ext.imgmath on Sphinx 1.4. I guess it should be possible to add
some logic at conf.py to change the include depending on the Sphinx
version;

2) the Latex auto-generated Makefile is hardcoded to use pdflatex. So,
I had to manually replace it to xelatex. One easy solution would be to
not use Make -C $BUILDDIR/latex, but to just call xelatex $BUILDDIR/$tex_name.

Also, documentation hits an error. using <q> or <r> makes it build, but
not sure what got missed there, as it has 1205 pages. I suspect that
only the index was broken.

The error happens during document output phase:

[1] [2] (./TheLinuxKernel.toc)
Adding blank page after the table of contents.
[1] [2] [1] [2]
Chapter 1.
[3] [4]
! Misplaced \omit.
\multispan ->\omit 
                   \@multispan 
l.407 \hline\end{tabulary}

It resembles this error:
	https://www.mail-archive.com/sphinx-dev@googlegroups.com/msg06083.html

So, I suspect it has nothing to do with xelatex, but it is, instead
some Spinx 1.2.x bug when generating cell span output in Latex.

It happened on this part of the LaTeX source code:

\begin{threeparttable}
\capstart\caption{table title}

\begin{tabulary}{\linewidth}{|L|L|L|L|}
\hline

head col 1
 & 
head col 2
 & 
head col 3
 & 
head col 4
\\
\hline
column 1
 & 
field 1.1
 &  \multicolumn{2}{l|}{
field 1.2 with autospan
}\\
\hline
column 2
 & 
field 2.1
 &  \multirow{2}{*}{ \multicolumn{2}{l|}{
  field 2.2 - 3.3
}}\\
\hline\phantomsection\label{kernel-documentation:last-row}
column 3
 &  & \\

\hline\end{tabulary}

\end{threeparttable}

\end{quote}

Btw, removing the media books and all latex options, using pdflatex
still doesn't build cleanly on 1.2.x:

Package inputenc Warning: inputenc package ignored with utf8 based engines.

)
! Undefined control sequence.
<recently read> \DeclareUnicodeCharacter 
                                         
l.5 \DeclareUnicodeCharacter
                            {00A0}{\nobreakspace}


Again, user has to use <q> or <r> to continue the build.

I'll try to install Ubuntu Xenial on a LXC container and repeat the test
there. Xenial seems to use Sphinx 1.3.6, according with:
	http://packages.ubuntu.com/search?keywords=python-sphinx

Btw, as now both latest version of Ubuntu and Fedora uses Sphinx
1.4.x, perhaps we could raise the bar and just require Sphinx > 1.4.

Thanks,
Mauro

Quick hack to make it build on Sphinx 1.2.3

diff --git a/Documentation/Makefile.sphinx b/Documentation/Makefile.sphinx
index 8aa4fffda860..ce764df3fad5 100644
--- a/Documentation/Makefile.sphinx
+++ b/Documentation/Makefile.sphinx
@@ -50,7 +50,7 @@ ifeq ($(HAVE_PDFLATEX),0)
 else # HAVE_PDFLATEX
 	$(call cmd,sphinx,latex)
 	(cd $(BUILDDIR); for i in *.rst; do echo >$$i; done)
-	$(Q)$(MAKE) PDFLATEX=xelatex -C $(BUILDDIR)/latex
+	(cd $(BUILDDIR)/latex; xelatex TheLinuxKernel.tex)
 endif # HAVE_PDFLATEX
 
 epubdocs:
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

