Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51082 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbcHFVAs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Aug 2016 17:00:48 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michal Marek <mmarek@suse.com>, linux-kbuild@vger.kernel.org
Subject: [PATCH 2/3] doc-rst: add an option to build media documentation in nitpick mode
Date: Sat,  6 Aug 2016 09:00:33 -0300
Message-Id: <5414f96c38d4b131ef1b240aea4a8f4f5f635159.1470484077.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1470484077.git.mchehab@s-opensource.com>
References: <cover.1470484077.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1470484077.git.mchehab@s-opensource.com>
References: <cover.1470484077.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While writing the media documentation, it is important to be able
to check if all symbols that are internal to the documentation were
cross-referenced, as this ensures that newer patches won't be
introducing documentation gaps.

So, add a way to build only the media documentation in nitpick
mode.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/Makefile.sphinx       | 10 ++++-
 Documentation/index.rst             |  5 +--
 Documentation/media/conf_nitpick.py | 85 +++++++++++++++++++++++++++++++++++++
 Documentation/media/index.rst       | 12 ++++++
 Makefile                            |  6 +++
 5 files changed, 112 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/media/conf_nitpick.py
 create mode 100644 Documentation/media/index.rst

diff --git a/Documentation/Makefile.sphinx b/Documentation/Makefile.sphinx
index b10b6c598ae2..bbd7cd46f4a9 100644
--- a/Documentation/Makefile.sphinx
+++ b/Documentation/Makefile.sphinx
@@ -33,12 +33,17 @@ PAPEROPT_a4     = -D latex_paper_size=a4
 PAPEROPT_letter = -D latex_paper_size=letter
 KERNELDOC       = $(srctree)/scripts/kernel-doc
 KERNELDOC_CONF  = -D kerneldoc_srctree=$(srctree) -D kerneldoc_bin=$(KERNELDOC)
-ALLSPHINXOPTS   = -D version=$(KERNELVERSION) -D release=$(KERNELRELEASE) -d $(BUILDDIR)/.doctrees $(KERNELDOC_CONF) $(PAPEROPT_$(PAPER)) -c $(srctree)/$(src) $(SPHINXOPTS) $(srctree)/$(src)
+ALLSPHINXOPTS   = -D version=$(KERNELVERSION) -D release=$(KERNELRELEASE) -d $(BUILDDIR)/.doctrees $(KERNELDOC_CONF) $(PAPEROPT_$(PAPER)) -c $(srctree)/$(src) $(SPHINXOPTS)
 # the i18n builder cannot share the environment and doctrees with the others
 I18NSPHINXOPTS  = $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) .
 
 quiet_cmd_sphinx = SPHINX  $@
-      cmd_sphinx = BUILDDIR=$(BUILDDIR) $(SPHINXBUILD) -b $2 $(ALLSPHINXOPTS) $(BUILDDIR)/$2
+      cmd_sphinx = BUILDDIR=$(BUILDDIR) $(SPHINXBUILD) -b $2 $(ALLSPHINXOPTS) $(srctree)/$(src)$3 $(BUILDDIR)/$2
+
+# Build only the media docs, in nitpick mode
+mediadocs:
+	$(MAKE) BUILDDIR=$(BUILDDIR) SPHINX_CONF=media/conf_nitpick.py -f $(srctree)/Documentation/media/Makefile htmldocs
+	$(call cmd,sphinx,html,/media)
 
 htmldocs:
 	$(MAKE) BUILDDIR=$(BUILDDIR) -f $(srctree)/Documentation/media/Makefile $@
@@ -70,6 +75,7 @@ cleandocs:
 dochelp:
 	@echo  ' Linux kernel internal documentation in different formats (Sphinx):'
 	@echo  '  htmldocs        - HTML'
+	@echo  '  mediadocs       - built only media books in HTML on nitpick mode'
 	@echo  '  pdfdocs         - PDF'
 	@echo  '  epubdocs        - EPUB'
 	@echo  '  xmldocs         - XML'
diff --git a/Documentation/index.rst b/Documentation/index.rst
index e0fc72963e87..02255c1806f6 100644
--- a/Documentation/index.rst
+++ b/Documentation/index.rst
@@ -14,10 +14,7 @@ Contents:
    :maxdepth: 2
 
    kernel-documentation
-   media/media_uapi
-   media/media_kapi
-   media/dvb-drivers/index
-   media/v4l-drivers/index
+   media/index
    gpu/index
 
 Indices and tables
diff --git a/Documentation/media/conf_nitpick.py b/Documentation/media/conf_nitpick.py
new file mode 100644
index 000000000000..9034d7f19753
--- /dev/null
+++ b/Documentation/media/conf_nitpick.py
@@ -0,0 +1,85 @@
+nitpicky=True
+
+# It is possible to run Sphinx in nickpick mode with:
+#	make SPHINXOPTS=-n htmldocs
+# In such case, it will complain about lots of missing references that
+#	1) are just typedefs like: bool, __u32, etc;
+#	2) It will complain for things like: enum, NULL;
+#	3) It will complain for symbols that should be on different
+#	   books (but currently aren't ported to ReST)
+# The list below has a list of such symbols to be ignored in nitpick mode
+#
+nitpick_ignore = [
+	("c:func", "clock_gettime"),
+	("c:func", "close"),
+	("c:func", "container_of"),
+	("c:func", "determine_valid_ioctls"),
+	("c:func", "ERR_PTR"),
+	("c:func", "ioctl"),
+	("c:func", "IS_ERR"),
+	("c:func", "mmap"),
+	("c:func", "open"),
+	("c:func", "pci_name"),
+	("c:func", "poll"),
+	("c:func", "PTR_ERR"),
+	("c:func", "read"),
+	("c:func", "release"),
+	("c:func", "set"),
+	("c:func", "struct fd_set"),
+	("c:func", "struct pollfd"),
+	("c:func", "usb_make_path"),
+	("c:func", "write"),
+	("c:type", "atomic_t"),
+	("c:type", "bool"),
+	("c:type", "buf_queue"),
+	("c:type", "device"),
+	("c:type", "device_driver"),
+	("c:type", "device_node"),
+	("c:type", "enum"),
+	("c:type", "file"),
+	("c:type", "i2c_adapter"),
+	("c:type", "i2c_board_info"),
+	("c:type", "i2c_client"),
+	("c:type", "ktime_t"),
+	("c:type", "led_classdev_flash"),
+	("c:type", "list_head"),
+	("c:type", "lock_class_key"),
+	("c:type", "module"),
+	("c:type", "mutex"),
+	("c:type", "pci_dev"),
+	("c:type", "pdvbdev"),
+	("c:type", "poll_table_struct"),
+	("c:type", "s32"),
+	("c:type", "s64"),
+	("c:type", "sd"),
+	("c:type", "spi_board_info"),
+	("c:type", "spi_device"),
+	("c:type", "spi_master"),
+	("c:type", "struct fb_fix_screeninfo"),
+	("c:type", "struct pollfd"),
+	("c:type", "struct timeval"),
+	("c:type", "struct video_capability"),
+	("c:type", "u16"),
+	("c:type", "u32"),
+	("c:type", "u64"),
+	("c:type", "u8"),
+	("c:type", "union"),
+	("c:type", "usb_device"),
+
+	("cpp:type", "boolean"),
+	("cpp:type", "fd"),
+	("cpp:type", "fd_set"),
+	("cpp:type", "int16_t"),
+	("cpp:type", "NULL"),
+	("cpp:type", "off_t"),
+	("cpp:type", "pollfd"),
+	("cpp:type", "size_t"),
+	("cpp:type", "ssize_t"),
+	("cpp:type", "timeval"),
+	("cpp:type", "__u16"),
+	("cpp:type", "__u32"),
+	("cpp:type", "__u64"),
+	("cpp:type", "uint16_t"),
+	("cpp:type", "uint32_t"),
+	("cpp:type", "video_system_t"),
+]
diff --git a/Documentation/media/index.rst b/Documentation/media/index.rst
new file mode 100644
index 000000000000..e85c557eeea3
--- /dev/null
+++ b/Documentation/media/index.rst
@@ -0,0 +1,12 @@
+Linux Media Subsystem Documentation
+===================================
+
+Contents:
+
+.. toctree::
+   :maxdepth: 2
+
+   media_uapi
+   media_kapi
+   dvb-drivers/index
+   v4l-drivers/index
diff --git a/Makefile b/Makefile
index 35603556023e..08ef6c1a807b 100644
--- a/Makefile
+++ b/Makefile
@@ -1439,6 +1439,12 @@ $(DOC_TARGETS): scripts_basic FORCE
 	$(Q)$(MAKE) $(build)=Documentation -f $(srctree)/Documentation/Makefile.sphinx $@
 	$(Q)$(MAKE) $(build)=Documentation/DocBook $@
 
+DOC_NITPIC_TARGETS := mediadocs
+PHONY += $(DOC_NITPIC_TARGETS)
+$(DOC_NITPIC_TARGETS): scripts_basic FORCE
+	$(Q)$(MAKE) $(build)=scripts build_docproc build_check-lc_ctype
+	$(Q)$(MAKE) $(build)=Documentation -f $(srctree)/Documentation/Makefile.sphinx $@
+
 else # KBUILD_EXTMOD
 
 ###
-- 
2.7.4


