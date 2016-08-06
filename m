Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57288
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbcHFUW2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Aug 2016 16:22:28 -0400
Date: Sat, 6 Aug 2016 17:22:20 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jani Nikula <jani.nikula@intel.com>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
	linux-media@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH] doc-rst: support *sphinx build themes*
Message-ID: <20160806172220.073270bc@recife.lan>
In-Reply-To: <87eg6126k2.fsf@intel.com>
References: <1470410047-9911-1-git-send-email-markus.heiser@darmarit.de>
	<87eg6126k2.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 06 Aug 2016 19:41:49 +0300
Jani Nikula <jani.nikula@intel.com> escreveu:

> On Fri, 05 Aug 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:
> > From: Markus Heiser <markus.heiser@darmarIT.de>
> >
> > Load an additional configuration file into conf.py namespace.
> >
> > The name of the configuration file is taken from the environment
> > SPHINX_CONF. The external configuration file extends (or overwrites) the
> > configuration values from the origin conf.py.  With this you are
> > able to maintain *build themes*.
> >
> > E.g. to create your own nit-picking *build theme*, create a file
> > Documentation/conf_nitpick.py::
> >
> >   nitpicky=True
> >   nitpick_ignore = [
> >       ("c:func", "clock_gettime"),
> >       ...
> >       ]
> >
> > and run make with SPHINX_CONF environment::
> >
> >   make SPHINX_CONF=conf_nitpick.py htmldocs  
> 
> I think I would try to accomplish this by using the -c option in
> SPHINXOPTS, and loading the main config file from the "special case"
> config file. I think it would be a more generic approach instead of a
> specific framework of our own. *shrug*.

Indeed this would be better if it works.

I tried that, using the enclosed patch, instead of my previous
approach:
	https://git.linuxtv.org/mchehab/experimental.git/commit/?h=docs-next&id=5414f96c38d4b131ef1b240aea4a8f4f5f635159

But I got several errors:


$ make V=1 SPHINXDIRS="./media" htmldocs
make -f ./scripts/Makefile.build obj=scripts/basic
rm -f .tmp_quiet_recordmcount
make -f ./scripts/Makefile.build obj=scripts build_docproc build_check-lc_ctype
make -f ./scripts/Makefile.build obj=Documentation -f ./Documentation/Makefile.sphinx htmldocs
make BUILDDIR=Documentation/output -f ./Documentation/media/Makefile htmldocs;
make[2]: Nothing to be done for 'htmldocs'.
  for i in ./media; do BUILDDIR=Documentation/output sphinx-build -b html -D version=4.7.0 -D release=4.7.0-rc6-00001-gf6a4b9bdcd7b-dirty -d Documentation/output/.doctrees -D kerneldoc_srctree=. -D kerneldoc_bin=./scripts/kernel-doc   -c ./Documentation/$i ./Documentation/$i Documentation/output/html; done
Running Sphinx v1.4.5
WARNING: unknown config value 'kerneldoc_bin' in override, ignoring
WARNING: unknown config value 'kerneldoc_srctree' in override, ignoring
loading pickled environment... not yet created
building [mo]: targets for 0 po files that are out of date
building [html]: targets for 483 source files that are out of date
updating environment: 483 added, 0 changed, 0 removed
reading sources... [100%] v4l-drivers/zr364xx                                                                                                                                                 

Sphinx error:
master file /devel/v4l/patchwork/Documentation/media/contents.rst not found
Documentation/Makefile.sphinx:48: recipe for target 'htmldocs' failed
make[1]: *** [htmldocs] Error 1
Makefile:1438: recipe for target 'htmldocs' failed
make: *** [htmldocs] Error 2

PS.: I'm not a python programmer... Probably I'm doing some
obvious mistake ;)

Thanks,
Mauro

doc-rst: Allow doing partial doc builds and be nitpick for media

PS: should be broken on two patches

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/Documentation/Makefile.sphinx b/Documentation/Makefile.sphinx
index bbd7cd46f4a9..f5f5d8f9edd3 100644
--- a/Documentation/Makefile.sphinx
+++ b/Documentation/Makefile.sphinx
@@ -5,6 +5,7 @@
 # You can set these variables from the command line.
 SPHINXBUILD   = sphinx-build
 SPHINXOPTS    =
+SPHINXDIRS    = .
 PAPER         =
 BUILDDIR      = $(obj)/output
 
@@ -33,17 +34,15 @@ PAPEROPT_a4     = -D latex_paper_size=a4
 PAPEROPT_letter = -D latex_paper_size=letter
 KERNELDOC       = $(srctree)/scripts/kernel-doc
 KERNELDOC_CONF  = -D kerneldoc_srctree=$(srctree) -D kerneldoc_bin=$(KERNELDOC)
-ALLSPHINXOPTS   = -D version=$(KERNELVERSION) -D release=$(KERNELRELEASE) -d $(BUILDDIR)/.doctrees $(KERNELDOC_CONF) $(PAPEROPT_$(PAPER)) -c $(srctree)/$(src) $(SPHINXOPTS)
+ALLSPHINXOPTS   = -D version=$(KERNELVERSION) -D release=$(KERNELRELEASE) -d $(BUILDDIR)/.doctrees $(KERNELDOC_CONF) $(PAPEROPT_$(PAPER)) $(SPHINXOPTS)
 # the i18n builder cannot share the environment and doctrees with the others
 I18NSPHINXOPTS  = $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) .
 
 quiet_cmd_sphinx = SPHINX  $@
-      cmd_sphinx = BUILDDIR=$(BUILDDIR) $(SPHINXBUILD) -b $2 $(ALLSPHINXOPTS) $(srctree)/$(src)$3 $(BUILDDIR)/$2
-
-# Build only the media docs, in nitpick mode
-mediadocs:
-	$(MAKE) BUILDDIR=$(BUILDDIR) SPHINX_CONF=media/conf_nitpick.py -f $(srctree)/Documentation/media/Makefile htmldocs
-	$(call cmd,sphinx,html,/media)
+      cmd_sphinx = \
+		for i in $(SPHINXDIRS); do \
+			BUILDDIR=$(BUILDDIR) $(SPHINXBUILD) -b $2 $(ALLSPHINXOPTS) -c $(srctree)/$(src)/$$i $(srctree)/$(src)/$$i $(BUILDDIR)/$2; \
+		done
 
 htmldocs:
 	$(MAKE) BUILDDIR=$(BUILDDIR) -f $(srctree)/Documentation/media/Makefile $@
@@ -75,7 +74,6 @@ cleandocs:
 dochelp:
 	@echo  ' Linux kernel internal documentation in different formats (Sphinx):'
 	@echo  '  htmldocs        - HTML'
-	@echo  '  mediadocs       - built only media books in HTML on nitpick mode'
 	@echo  '  pdfdocs         - PDF'
 	@echo  '  epubdocs        - EPUB'
 	@echo  '  xmldocs         - XML'
diff --git a/Documentation/media/conf.py b/Documentation/media/conf.py
index 78d776c2223a..178e7f2eac39 100644
--- a/Documentation/media/conf.py
+++ b/Documentation/media/conf.py
@@ -2,16 +2,18 @@
 # pylint: disable=R0903, C0330, R0914, R0912, E0401
 
 import os
-from sphinx.util.pycompat import execfile_
+import sys
 
-config_file = "../conf.py"
-if config_file is not None and os.path.exists(config_file):
-	config_file = os.path.abspath(config_file)
-	config = namespace.copy()
-	config['__file__'] = config_file
-	execfile_(config_file, config)
-	del config['__file__']
-	namespace.update(config)
+def loadConfig(namespace):
+
+    config_file = os.environ.get("../conf.py", None)
+    if config_file is not None and os.path.exists(config_file):
+        config_file = os.path.abspath(config_file)
+        config = namespace.copy()
+        config['__file__'] = config_file
+        execfile_(config_file, config)
+        del config['__file__']
+        namespace.update(config)
 
 loadConfig(globals())
 
diff --git a/Makefile b/Makefile
index 08ef6c1a807b..35603556023e 100644
--- a/Makefile
+++ b/Makefile
@@ -1439,12 +1439,6 @@ $(DOC_TARGETS): scripts_basic FORCE
 	$(Q)$(MAKE) $(build)=Documentation -f $(srctree)/Documentation/Makefile.sphinx $@
 	$(Q)$(MAKE) $(build)=Documentation/DocBook $@
 
-DOC_NITPIC_TARGETS := mediadocs
-PHONY += $(DOC_NITPIC_TARGETS)
-$(DOC_NITPIC_TARGETS): scripts_basic FORCE
-	$(Q)$(MAKE) $(build)=scripts build_docproc build_check-lc_ctype
-	$(Q)$(MAKE) $(build)=Documentation -f $(srctree)/Documentation/Makefile.sphinx $@
-
 else # KBUILD_EXTMOD
 
 ###

