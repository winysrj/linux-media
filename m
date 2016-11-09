Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-2.goneo.de ([85.220.129.34]:52393 "EHLO smtp2-2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753170AbcKIWMa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Nov 2016 17:12:30 -0500
Subject: Re: [Ksummit-discuss] Including images on Sphinx documents
To: Jani Nikula <jani.nikula@linux.intel.com>
References: <20161107075524.49d83697@vento.lan>
 <20161107170133.4jdeuqydthbbchaq@x>
 <A4091944-D727-45B5-AC24-FE3B2700298E@darmarit.de> <8737j0hpi0.fsf@intel.com>
 <DC27B5F7-D69E-4F22-B184-B7B029392959@darmarit.de> <87shr0g90r.fsf@intel.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        ksummit-discuss@lists.linuxfoundation.org,
        linux-doc@vger.kernel.org
From: Markus Heiser <markus.heiser@darmarit.de>
Message-ID: <a6b88e7d-9d6b-4dcc-3d2e-c09bdf366b40@darmarit.de>
Date: Wed, 9 Nov 2016 23:11:46 +0100
MIME-Version: 1.0
In-Reply-To: <87shr0g90r.fsf@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 09.11.2016 12:58, Jani Nikula wrote:
 > On Wed, 09 Nov 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:
 >> Am 09.11.2016 um 12:16 schrieb Jani Nikula <jani.nikula@linux.intel.com>:
 >>>> So I vote for :
 >>>>
 >>>>> 1) copy (or symlink) all rst files to Documentation/output (or to the
 >>>>> build dir specified via O= directive) and generate the *.pdf there,
 >>>>> and produce those converted images via Makefile.;
 >>>
 >>> We're supposed to solve problems, not create new ones.
 >>
 >> ... new ones? ...
 >
 > Handle in-tree builds without copying.
 >
 > Make dependency analysis with source rst and "intermediate" rst work.
 >
 > Make sure your copying gets the timestamps right.
 >
 > Make Sphinx dependency analysis look at the right copies depending on
 > in-tree vs. out-of-tree. Generally make sure it doesn't confuse Sphinx's
 > own dependency analysis.
 >
 > The stuff I didn't think of.

It might be easier than you think first.

 > Sure, it's all supposed to be basic Makefile stuff, but don't make the mistake
 > of thinking just one invocation of 'cp' will solve all the problems.

I act naif using 'cp -sa', see patch below.

 > It all adds to the complexity we were trying to avoid when dumping DocBook. It
 > adds to the complexity of debugging stuff. (And hey, there's still the one
 > rebuilding-stuff-for-no-reason issue open.)

And hey ;-) I wrote you [1], this is a bug in Sphinx. Yes, I haven't had time
to send a bugfix to Sphinx, but this won't even help us (bugfixes in Sphinx will
only apply on top).

 > If you want to keep the documentation build sane, try to avoid the Makefile
 > preprocessing.

I'am just the one helping Mauro to be productive, if he needs preprocessing I
implement proposals. I know that you fear preprocessing since it tend to
fall-back, what we had with DocBook's build process.  We discussed this already,
it might better you unify this with Mauro and the other who need preprocessing.

 > And same old story, if you fix this for real, even if as a Sphinx extension,
 > *other* people than kernel developers will be interested, and *we* don't have
 > to do so much ourselves.

I don't think so, this kind of parsing header files we have and the build of
content from MAINTAINERS, ABI, etc. is very kernel specific.

Anyway, back to my point 'copy (or symlink) all rst files'. Please take a look
at my patch below. Take in mind; its just a POC.

Could this POC persuade you, if so, I send a more elaborate RFC,
what do you think about?

[1] https://www.mail-archive.com/linux-doc@vger.kernel.org/msg07302.html

-- Markus --

 > BR,
 > Jani.
 >>
 >>>> IMO placing 'sourcedir' to O= is more sane since this marries the
 >>>> Linux Makefile concept (relative to $PWD) with the sphinx concept
 >>>> (in or below 'sourcedir').
 >>
 >> -- Markus --
 >

diff --git a/Documentation/Makefile.sphinx b/Documentation/Makefile.sphinx
index ec0c77d..8e904c1 100644
--- a/Documentation/Makefile.sphinx
+++ b/Documentation/Makefile.sphinx
@@ -13,6 +13,10 @@ BUILDDIR      = $(obj)/output
  PDFLATEX      = xelatex
  LATEXOPTS     = -interaction=batchmode

+ifdef SPHINXDIRS
+else
+endif
+
  # User-friendly check for sphinx-build
  HAVE_SPHINX := $(shell if which $(SPHINXBUILD) >/dev/null 2>&1; then echo 1; else echo 0; fi)

@@ -50,30 +54,38 @@ loop_cmd = $(echo-cmd) $(cmd_$(1))
  #    * dest folder relative to $(BUILDDIR) and
  #    * cache folder relative to $(BUILDDIR)/.doctrees
  # $4 dest subfolder e.g. "man" for man pages at media/man
-# $5 reST source folder relative to $(srctree)/$(src),
+# $5 reST source folder relative to $(obj),
  #    e.g. "media" for the linux-tv book-set at ./Documentation/media

  quiet_cmd_sphinx = SPHINX  $@ --> file://$(abspath $(BUILDDIR)/$3/$4)
-      cmd_sphinx = $(MAKE) BUILDDIR=$(abspath $(BUILDDIR)) $(build)=Documentation/media all;\
-	BUILDDIR=$(abspath $(BUILDDIR)) SPHINX_CONF=$(abspath $(srctree)/$(src)/$5/$(SPHINX_CONF)) \
+      cmd_sphinx = $(MAKE) BUILDDIR=$(BUILDDIR) $(build)=Documentation/media all;\
+	BUILDDIR=$(BUILDDIR) SPHINX_CONF=$(obj)/$5/$(SPHINX_CONF) \
  	$(SPHINXBUILD) \
  	-b $2 \
-	-c $(abspath $(srctree)/$(src)) \
-	-d $(abspath $(BUILDDIR)/.doctrees/$3) \
+	-c $(obj) \
+	-d $(obj)/.doctrees/$3 \
  	-D version=$(KERNELVERSION) -D release=$(KERNELRELEASE) \
  	$(ALLSPHINXOPTS) \
-	$(abspath $(srctree)/$(src)/$5) \
-	$(abspath $(BUILDDIR)/$3/$4);
-
-htmldocs:
+	$(obj)/$5 \
+	$(BUILDDIR)/$3/$4;
+
+ifdef O
+sync:
+	rm -rf $(objtree)/$(obj)
+	cp -sa $(srctree)/$(obj) $(objtree)
+else
+sync:
+endif
+
+htmldocs: sync
  	@$(foreach var,$(SPHINXDIRS),$(call loop_cmd,sphinx,html,$(var),,$(var)))

-latexdocs:
+latexdocs: sync
  	@$(foreach var,$(SPHINXDIRS),$(call loop_cmd,sphinx,latex,$(var),latex,$(var)))

  ifeq ($(HAVE_PDFLATEX),0)

-pdfdocs:
+pdfdocs: sync
  	$(warning The '$(PDFLATEX)' command was not found. Make sure you have it installed and in PATH to produce PDF output.)
  	@echo "  SKIP    Sphinx $@ target."

@@ -84,10 +96,10 @@ pdfdocs: latexdocs

  endif # HAVE_PDFLATEX

-epubdocs:
+epubdocs: sync
  	@$(foreach var,$(SPHINXDIRS),$(call loop_cmd,sphinx,epub,$(var),epub,$(var)))

-xmldocs:
+xmldocs: sync
  	@$(foreach var,$(SPHINXDIRS),$(call loop_cmd,sphinx,xml,$(var),xml,$(var)))

  # no-ops for the Sphinx toolchain
@@ -98,6 +110,7 @@ installmandocs:

  cleandocs:
  	$(Q)rm -rf $(BUILDDIR)
+	$(Q)rm -rf $(obj)/.doctrees

  endif # HAVE_SPHINX

