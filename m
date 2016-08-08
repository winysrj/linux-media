Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:52574 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbcHHNP0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Aug 2016 09:15:26 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/3] doc-rst: generic way to build only sphinx sub-folders
Date: Mon,  8 Aug 2016 15:14:58 +0200
Message-Id: <1470662100-6927-2-git-send-email-markus.heiser@darmarit.de>
In-Reply-To: <1470662100-6927-1-git-send-email-markus.heiser@darmarit.de>
References: <1470662100-6927-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

Remove the 'DOC_NITPIC_TARGETS' from main $(srctree)/Makefile and add a
more generic way to build only a reST sub-folder.

* control *sub-folders* by environment SPHINXDIRS
* control *build-theme* by environment SPHINX_CONF

Folders with a conf.py file, matching $(srctree)/Documentation/*/conf.py
can be build and distributed *stand-alone*. E.g. to compile only the
html of 'media' and 'gpu' folder use::

  make SPHINXDIRS="media gpu" htmldocs

To use an additional sphinx-build configuration (*build-theme*) set the
name of the configuration file to SPHINX_CONF. E.g. to compile only the
html of 'media' with the *nit-picking* build use::

  make SPHINXDIRS=media SPHINX_CONF=conf_nitpick.py htmldocs

With this, the Documentation/conf.py is read first and updated with the
configuration values from the Documentation/media/conf_nitpick.py.

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
---
 Documentation/DocBook/Makefile      |  2 +-
 Documentation/Makefile.sphinx       | 52 +++++++++++++++++++++++++++----------
 Documentation/sphinx/load_config.py | 20 +++++++++-----
 Makefile                            |  6 -----
 4 files changed, 53 insertions(+), 27 deletions(-)

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index c481df3..24fd36d 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -6,7 +6,7 @@
 # To add a new book the only step required is to add the book to the
 # list of DOCBOOKS.
 
-ifeq ($(IGNORE_DOCBOOKS),)
+ifeq ($(IGNORE_DOCBOOKS)$(SPHINXDIRS),)
 
 DOCBOOKS := z8530book.xml device-drivers.xml \
 	    kernel-hacking.xml kernel-locking.xml deviceiobook.xml \
diff --git a/Documentation/Makefile.sphinx b/Documentation/Makefile.sphinx
index bbd7cd4..1549237 100644
--- a/Documentation/Makefile.sphinx
+++ b/Documentation/Makefile.sphinx
@@ -5,9 +5,13 @@
 # You can set these variables from the command line.
 SPHINXBUILD   = sphinx-build
 SPHINXOPTS    =
+SPHINXDIRS    = .
+_SPHINXDIRS   = $(patsubst $(srctree)/Documentation/%/conf.py,%,$(wildcard $(srctree)/Documentation/*/conf.py))
+SPHINX_CONF   = conf.py
 PAPER         =
 BUILDDIR      = $(obj)/output
 
+
 # User-friendly check for sphinx-build
 HAVE_SPHINX := $(shell if which $(SPHINXBUILD) >/dev/null 2>&1; then echo 1; else echo 0; fi)
 
@@ -33,35 +37,50 @@ PAPEROPT_a4     = -D latex_paper_size=a4
 PAPEROPT_letter = -D latex_paper_size=letter
 KERNELDOC       = $(srctree)/scripts/kernel-doc
 KERNELDOC_CONF  = -D kerneldoc_srctree=$(srctree) -D kerneldoc_bin=$(KERNELDOC)
-ALLSPHINXOPTS   = -D version=$(KERNELVERSION) -D release=$(KERNELRELEASE) -d $(BUILDDIR)/.doctrees $(KERNELDOC_CONF) $(PAPEROPT_$(PAPER)) -c $(srctree)/$(src) $(SPHINXOPTS)
+ALLSPHINXOPTS   =  $(KERNELDOC_CONF) $(PAPEROPT_$(PAPER)) $(SPHINXOPTS)
 # the i18n builder cannot share the environment and doctrees with the others
 I18NSPHINXOPTS  = $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) .
 
-quiet_cmd_sphinx = SPHINX  $@
-      cmd_sphinx = BUILDDIR=$(BUILDDIR) $(SPHINXBUILD) -b $2 $(ALLSPHINXOPTS) $(srctree)/$(src)$3 $(BUILDDIR)/$2
-
-# Build only the media docs, in nitpick mode
-mediadocs:
-	$(MAKE) BUILDDIR=$(BUILDDIR) SPHINX_CONF=media/conf_nitpick.py -f $(srctree)/Documentation/media/Makefile htmldocs
-	$(call cmd,sphinx,html,/media)
+# commands; the 'cmd' from scripts/Kbuild.include is not *loopable*
+loop_cmd = $(echo-cmd) $(cmd_$(1))
+
+# $2 sphinx builder e.g. "html"
+# $3 name of the build subfolder / e.g. "media", used as:
+#    * dest folder relative to $(BUILDDIR) and
+#    * cache folder relative to $(BUILDDIR)/.doctrees
+# $4 dest subfolder e.g. "man" for man pages at media/man
+# $5 reST source folder relative to $(srctree)/$(src),
+#    e.g. "media" for the linux-tv book-set at ./Documentation/media
+
+quiet_cmd_sphinx = SPHINX  $@ --> file://$(abspath $(BUILDDIR)/$3/$4);
+      cmd_sphinx = BUILDDIR=$(abspath $(BUILDDIR)) SPHINX_CONF=$(abspath $(srctree)/$(src)/$5/$(SPHINX_CONF)) \
+	$(SPHINXBUILD) \
+	-b $2 \
+	-c $(abspath $(srctree)/$(src)) \
+	-d $(abspath $(BUILDDIR)/.doctrees/$3) \
+	-D version=$(KERNELVERSION) -D release=$(KERNELRELEASE) \
+	$(ALLSPHINXOPTS) \
+	$(abspath $(srctree)/$(src)/$5) \
+	$(abspath $(BUILDDIR)/$3/$4);
 
 htmldocs:
-	$(MAKE) BUILDDIR=$(BUILDDIR) -f $(srctree)/Documentation/media/Makefile $@
-	$(call cmd,sphinx,html)
+	$(MAKE) BUILDDIR=$(abspath $(BUILDDIR)) -f $(srctree)/Documentation/media/Makefile $@
+	@$(foreach var,$(SPHINXDIRS),$(call loop_cmd,sphinx,html,$(var),,$(var)))
+
 
 pdfdocs:
 ifeq ($(HAVE_RST2PDF),0)
 	$(warning The Python 'rst2pdf' module was not found. Make sure you have the module installed to produce PDF output.)
 	@echo "  SKIP    Sphinx $@ target."
 else # HAVE_RST2PDF
-	$(call cmd,sphinx,pdf)
+	@$(foreach var,$(SPHINXDIRS),$(call loop_cmd,sphinx,pdf,$(var),pdf,$(var)))
 endif # HAVE_RST2PDF
 
 epubdocs:
-	$(call cmd,sphinx,epub)
+	@$(foreach var,$(SPHINXDIRS),$(call loop_cmd,sphinx,epub,$(var),epub,$(var)))
 
 xmldocs:
-	$(call cmd,sphinx,xml)
+	@$(foreach var,$(SPHINXDIRS),$(call loop_cmd,sphinx,xml,$(var),xml,$(var)))
 
 # no-ops for the Sphinx toolchain
 sgmldocs:
@@ -75,10 +94,15 @@ cleandocs:
 dochelp:
 	@echo  ' Linux kernel internal documentation in different formats (Sphinx):'
 	@echo  '  htmldocs        - HTML'
-	@echo  '  mediadocs       - built only media books in HTML on nitpick mode'
 	@echo  '  pdfdocs         - PDF'
 	@echo  '  epubdocs        - EPUB'
 	@echo  '  xmldocs         - XML'
 	@echo  '  cleandocs       - clean all generated files'
+	@echo
+	@echo  '  make SPHINXDIRS="s1 s2" [target] Generate only docs of folder s1, s2'
+	@echo  '  valid values for SPHINXDIRS are: $(_SPHINXDIRS)'
+	@echo
+	@echo  '  make SPHINX_CONF={conf-file} [target] use *additional* sphinx-build'
+	@echo  '  configuration. This is e.g. useful to build with nit-picking config.'
 
 endif # HAVE_SPHINX
diff --git a/Documentation/sphinx/load_config.py b/Documentation/sphinx/load_config.py
index 44bdd22..88e5e4a 100644
--- a/Documentation/sphinx/load_config.py
+++ b/Documentation/sphinx/load_config.py
@@ -2,6 +2,7 @@
 # pylint: disable=R0903, C0330, R0914, R0912, E0401
 
 import os
+import sys
 from sphinx.util.pycompat import execfile_
 
 # ------------------------------------------------------------------------------
@@ -16,10 +17,17 @@ def loadConfig(namespace):
     maintain *build themes*.  """
 
     config_file = os.environ.get("SPHINX_CONF", None)
-    if config_file is not None and os.path.exists(config_file):
+    if (config_file is not None
+        and os.path.normpath(namespace["__file__"]) != os.path.normpath(config_file) ):
         config_file = os.path.abspath(config_file)
-        config = namespace.copy()
-        config['__file__'] = config_file
-        execfile_(config_file, config)
-        del config['__file__']
-        namespace.update(config)
+
+        if os.path.isfile(config_file):
+            sys.stdout.write("load additional sphinx-config: %s\n" % config_file)
+            config = namespace.copy()
+            config['__file__'] = config_file
+            execfile_(config_file, config)
+            del config['__file__']
+            namespace.update(config)
+        else:
+            sys.stderr.write("WARNING: additional sphinx-config not found: %s\n" % config_file)
+
diff --git a/Makefile b/Makefile
index 08ef6c1..3560355 100644
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
-- 
2.7.4

