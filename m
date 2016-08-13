Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:55974 "EHLO smtp3-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695AbcHMONe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Aug 2016 10:13:34 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jani Nikula <jani.nikula@intel.com>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH 1/7] doc-rst: generic way to build only sphinx sub-folders
Date: Sat, 13 Aug 2016 16:12:42 +0200
Message-Id: <1471097568-25990-2-git-send-email-markus.heiser@darmarit.de>
In-Reply-To: <1471097568-25990-1-git-send-email-markus.heiser@darmarit.de>
References: <1471097568-25990-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

Add a generic way to build only a reST sub-folder with or
without a individual *build-theme*.

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
 Documentation/DocBook/Makefile      |  7 ++++++
 Documentation/Makefile.sphinx       | 43 +++++++++++++++++++++++++++++++------
 Documentation/conf.py               |  7 ++++++
 Documentation/sphinx/load_config.py | 33 ++++++++++++++++++++++++++++
 4 files changed, 83 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/sphinx/load_config.py

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index 64460a8..a91c965 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -22,9 +22,15 @@ ifeq ($(DOCBOOKS),)
 # Skip DocBook build if the user explicitly requested no DOCBOOKS.
 .DEFAULT:
 	@echo "  SKIP    DocBook $@ target (DOCBOOKS=\"\" specified)."
+else
+ifneq ($(SPHINXDIRS),)
 
+# Skip DocBook build if the user explicitly requested a sphinx dir
+.DEFAULT:
+	@echo "  SKIP    DocBook $@ target (SPHINXDIRS specified)."
 else
 
+
 ###
 # The build process is as follows (targets):
 #              (xmldocs) [by docproc]
@@ -221,6 +227,7 @@ silent_gen_xml = :
 	   echo "</programlisting>")  > $@
 
 endif # DOCBOOKS=""
+endif # SPHINDIR=...
 
 ###
 # Help targets as used by the top-level makefile
diff --git a/Documentation/Makefile.sphinx b/Documentation/Makefile.sphinx
index fc29e08..ea0664c 100644
--- a/Documentation/Makefile.sphinx
+++ b/Documentation/Makefile.sphinx
@@ -5,6 +5,9 @@
 # You can set these variables from the command line.
 SPHINXBUILD   = sphinx-build
 SPHINXOPTS    =
+SPHINXDIRS    = .
+_SPHINXDIRS   = $(patsubst $(srctree)/Documentation/%/conf.py,%,$(wildcard $(srctree)/Documentation/*/conf.py))
+SPHINX_CONF   = conf.py
 PAPER         =
 BUILDDIR      = $(obj)/output
 
@@ -33,30 +36,50 @@ PAPEROPT_a4     = -D latex_paper_size=a4
 PAPEROPT_letter = -D latex_paper_size=letter
 KERNELDOC       = $(srctree)/scripts/kernel-doc
 KERNELDOC_CONF  = -D kerneldoc_srctree=$(srctree) -D kerneldoc_bin=$(KERNELDOC)
-ALLSPHINXOPTS   = -D version=$(KERNELVERSION) -D release=$(KERNELRELEASE) -d $(BUILDDIR)/.doctrees $(KERNELDOC_CONF) $(PAPEROPT_$(PAPER)) -c $(srctree)/$(src) $(SPHINXOPTS) $(srctree)/$(src)
+ALLSPHINXOPTS   =  $(KERNELDOC_CONF) $(PAPEROPT_$(PAPER)) $(SPHINXOPTS)
 # the i18n builder cannot share the environment and doctrees with the others
 I18NSPHINXOPTS  = $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) .
 
-quiet_cmd_sphinx = SPHINX  $@
-      cmd_sphinx = $(MAKE) BUILDDIR=$(BUILDDIR) $(build)=Documentation/media all; BUILDDIR=$(BUILDDIR) $(SPHINXBUILD) -b $2 $(ALLSPHINXOPTS) $(BUILDDIR)/$2
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
+      cmd_sphinx = $(MAKE) BUILDDIR=$(abspath $(BUILDDIR)) $(build)=Documentation/media all;\
+	BUILDDIR=$(abspath $(BUILDDIR)) SPHINX_CONF=$(abspath $(srctree)/$(src)/$5/$(SPHINX_CONF)) \
+	$(SPHINXBUILD) \
+	-b $2 \
+	-c $(abspath $(srctree)/$(src)) \
+	-d $(abspath $(BUILDDIR)/.doctrees/$3) \
+	-D version=$(KERNELVERSION) -D release=$(KERNELRELEASE) \
+	$(ALLSPHINXOPTS) \
+	$(abspath $(srctree)/$(src)/$5) \
+	$(abspath $(BUILDDIR)/$3/$4);
 
 htmldocs:
-	$(call cmd,sphinx,html)
+	@$(foreach var,$(SPHINXDIRS),$(call loop_cmd,sphinx,html,$(var),,$(var)))
 
 pdfdocs:
 ifeq ($(HAVE_PDFLATEX),0)
 	$(warning The 'pdflatex' command was not found. Make sure you have it installed and in PATH to produce PDF output.)
 	@echo "  SKIP    Sphinx $@ target."
 else # HAVE_PDFLATEX
-	$(call cmd,sphinx,latex)
+	@$(call loop_cmd,sphinx,latex,.,latex,.))
 	$(Q)$(MAKE) -C $(BUILDDIR)/latex
 endif # HAVE_PDFLATEX
 
 epubdocs:
-	$(call cmd,sphinx,epub)
+	@$(foreach var,$(SPHINXDIRS),$(call loop_cmd,sphinx,epub,$(var),epub,$(var)))
 
 xmldocs:
-	$(call cmd,sphinx,xml)
+	@$(foreach var,$(SPHINXDIRS),$(call loop_cmd,sphinx,xml,$(var),xml,$(var)))
 
 # no-ops for the Sphinx toolchain
 sgmldocs:
@@ -76,3 +99,9 @@ dochelp:
 	@echo  '  epubdocs        - EPUB'
 	@echo  '  xmldocs         - XML'
 	@echo  '  cleandocs       - clean all generated files'
+	@echo
+	@echo  '  make SPHINXDIRS="s1 s2" [target] Generate only docs of folder s1, s2'
+	@echo  '  valid values for SPHINXDIRS are: $(_SPHINXDIRS)'
+	@echo
+	@echo  '  make SPHINX_CONF={conf-file} [target] use *additional* sphinx-build'
+	@echo  '  configuration. This is e.g. useful to build with nit-picking config.'
diff --git a/Documentation/conf.py b/Documentation/conf.py
index b198147..5c06b01 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -19,6 +19,7 @@ import os
 # add these directories to sys.path here. If the directory is relative to the
 # documentation root, use os.path.abspath to make it absolute, like shown here.
 sys.path.insert(0, os.path.abspath('sphinx'))
+from load_config import loadConfig
 
 # -- General configuration ------------------------------------------------
 
@@ -421,3 +422,9 @@ pdf_documents = [
 # line arguments.
 kerneldoc_bin = '../scripts/kernel-doc'
 kerneldoc_srctree = '..'
+
+# ------------------------------------------------------------------------------
+# Since loadConfig overwrites settings from the global namespace, it has to be
+# the last statement in the conf.py file
+# ------------------------------------------------------------------------------
+loadConfig(globals())
diff --git a/Documentation/sphinx/load_config.py b/Documentation/sphinx/load_config.py
new file mode 100644
index 0000000..88e5e4a
--- /dev/null
+++ b/Documentation/sphinx/load_config.py
@@ -0,0 +1,33 @@
+# -*- coding: utf-8; mode: python -*-
+# pylint: disable=R0903, C0330, R0914, R0912, E0401
+
+import os
+import sys
+from sphinx.util.pycompat import execfile_
+
+# ------------------------------------------------------------------------------
+def loadConfig(namespace):
+# ------------------------------------------------------------------------------
+
+    u"""Load an additional configuration file into *namespace*.
+
+    The name of the configuration file is taken from the environment
+    ``SPHINX_CONF``. The external configuration file extends (or overwrites) the
+    configuration values from the origin ``conf.py``.  With this you are able to
+    maintain *build themes*.  """
+
+    config_file = os.environ.get("SPHINX_CONF", None)
+    if (config_file is not None
+        and os.path.normpath(namespace["__file__"]) != os.path.normpath(config_file) ):
+        config_file = os.path.abspath(config_file)
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
-- 
2.7.4

