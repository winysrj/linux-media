Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:38498 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751581AbcJFHUq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Oct 2016 03:20:46 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jani Nikula <jani.nikula@intel.com>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: [PATCH 4/4] doc-rst: remove the kernel-include directive
Date: Thu,  6 Oct 2016 09:20:20 +0200
Message-Id: <1475738420-8747-5-git-send-email-markus.heiser@darmarit.de>
In-Reply-To: <1475738420-8747-1-git-send-email-markus.heiser@darmarit.de>
References: <1475738420-8747-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

From: Markus Heiser <markus.heiser@darmarIT.de>

The kernel-include directive is no longer needed, so lets remove this
out-of-favor solution.

BTW: fixed a C&P typo in the Documentation/Makefile

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
---
 Documentation/Makefile.sphinx          |   2 +-
 Documentation/conf.py                  |   2 +-
 Documentation/sphinx/kernel_include.py | 190 ---------------------------------
 3 files changed, 2 insertions(+), 192 deletions(-)
 delete mode 100755 Documentation/sphinx/kernel_include.py

diff --git a/Documentation/Makefile.sphinx b/Documentation/Makefile.sphinx
index 2e033e4..36b8c41 100644
--- a/Documentation/Makefile.sphinx
+++ b/Documentation/Makefile.sphinx
@@ -51,7 +51,7 @@ loop_cmd = $(echo-cmd) $(cmd_$(1))
 # $5 reST source folder relative to $(srctree)/$(src),
 #    e.g. "media" for the linux-tv book-set at ./Documentation/media
 
-quiet_cmd_sphinx = SPHINX  $@ --> file://$(abspath $(BUILDDIR)/$3/$4);
+quiet_cmd_sphinx = SPHINX  $@ --> file://$(abspath $(BUILDDIR)/$3/$4)
       cmd_sphinx = \
 	BUILDDIR=$(abspath $(BUILDDIR)) SPHINX_CONF=$(abspath $(srctree)/$(src)/$5/$(SPHINX_CONF)) \
 	$(SPHINXBUILD) \
diff --git a/Documentation/conf.py b/Documentation/conf.py
index 64231e1..a165b53 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -34,7 +34,7 @@ from load_config import loadConfig
 # Add any Sphinx extension module names here, as strings. They can be
 # extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
 # ones.
-extensions = ['kernel-doc', 'rstFlatTable', 'kernel_include', 'cdomain', 'kernel_cmd']
+extensions = ['kernel-doc', 'rstFlatTable', 'cdomain', 'kernel_cmd']
 
 # The name of the math extension changed on Sphinx 1.4
 if minor > 3:
diff --git a/Documentation/sphinx/kernel_include.py b/Documentation/sphinx/kernel_include.py
deleted file mode 100755
index f523aa6..0000000
--- a/Documentation/sphinx/kernel_include.py
+++ /dev/null
@@ -1,190 +0,0 @@
-#!/usr/bin/env python3
-# -*- coding: utf-8; mode: python -*-
-# pylint: disable=R0903, C0330, R0914, R0912, E0401
-
-u"""
-    kernel-include
-    ~~~~~~~~~~~~~~
-
-    Implementation of the ``kernel-include`` reST-directive.
-
-    :copyright:  Copyright (C) 2016  Markus Heiser
-    :license:    GPL Version 2, June 1991 see linux/COPYING for details.
-
-    The ``kernel-include`` reST-directive is a replacement for the ``include``
-    directive. The ``kernel-include`` directive expand environment variables in
-    the path name and allows to include files from arbitrary locations.
-
-    .. hint::
-
-      Including files from arbitrary locations (e.g. from ``/etc``) is a
-      security risk for builders. This is why the ``include`` directive from
-      docutils *prohibit* pathnames pointing to locations *above* the filesystem
-      tree where the reST document with the include directive is placed.
-
-    Substrings of the form $name or ${name} are replaced by the value of
-    environment variable name. Malformed variable names and references to
-    non-existing variables are left unchanged.
-"""
-
-# ==============================================================================
-# imports
-# ==============================================================================
-
-import os.path
-
-from docutils import io, nodes, statemachine
-from docutils.utils.error_reporting import SafeString, ErrorString
-from docutils.parsers.rst import directives
-from docutils.parsers.rst.directives.body import CodeBlock, NumberLines
-from docutils.parsers.rst.directives.misc import Include
-
-__version__  = '1.0'
-
-# ==============================================================================
-def setup(app):
-# ==============================================================================
-
-    app.add_directive("kernel-include", KernelInclude)
-    return dict(
-        version = __version__,
-        parallel_read_safe = True,
-        parallel_write_safe = True
-    )
-
-# ==============================================================================
-class KernelInclude(Include):
-# ==============================================================================
-
-    u"""KernelInclude (``kernel-include``) directive"""
-
-    def run(self):
-        path = os.path.realpath(
-            os.path.expandvars(self.arguments[0]))
-
-        # to get a bit security back, prohibit /etc:
-        if path.startswith(os.sep + "etc"):
-            raise self.severe(
-                'Problems with "%s" directive, prohibited path: %s'
-                % (self.name, path))
-
-        self.arguments[0] = path
-
-        #return super(KernelInclude, self).run() # won't work, see HINTs in _run()
-        return self._run()
-
-    def _run(self):
-        """Include a file as part of the content of this reST file."""
-
-        # HINT: I had to copy&paste the whole Include.run method. I'am not happy
-        # with this, but due to security reasons, the Include.run method does
-        # not allow absolute or relative pathnames pointing to locations *above*
-        # the filesystem tree where the reST document is placed.
-
-        if not self.state.document.settings.file_insertion_enabled:
-            raise self.warning('"%s" directive disabled.' % self.name)
-        source = self.state_machine.input_lines.source(
-            self.lineno - self.state_machine.input_offset - 1)
-        source_dir = os.path.dirname(os.path.abspath(source))
-        path = directives.path(self.arguments[0])
-        if path.startswith('<') and path.endswith('>'):
-            path = os.path.join(self.standard_include_path, path[1:-1])
-        path = os.path.normpath(os.path.join(source_dir, path))
-
-        # HINT: this is the only line I had to change / commented out:
-        #path = utils.relative_path(None, path)
-
-        path = nodes.reprunicode(path)
-        encoding = self.options.get(
-            'encoding', self.state.document.settings.input_encoding)
-        e_handler=self.state.document.settings.input_encoding_error_handler
-        tab_width = self.options.get(
-            'tab-width', self.state.document.settings.tab_width)
-        try:
-            self.state.document.settings.record_dependencies.add(path)
-            include_file = io.FileInput(source_path=path,
-                                        encoding=encoding,
-                                        error_handler=e_handler)
-        except UnicodeEncodeError as error:
-            raise self.severe('Problems with "%s" directive path:\n'
-                              'Cannot encode input file path "%s" '
-                              '(wrong locale?).' %
-                              (self.name, SafeString(path)))
-        except IOError as error:
-            raise self.severe('Problems with "%s" directive path:\n%s.' %
-                      (self.name, ErrorString(error)))
-        startline = self.options.get('start-line', None)
-        endline = self.options.get('end-line', None)
-        try:
-            if startline or (endline is not None):
-                lines = include_file.readlines()
-                rawtext = ''.join(lines[startline:endline])
-            else:
-                rawtext = include_file.read()
-        except UnicodeError as error:
-            raise self.severe('Problem with "%s" directive:\n%s' %
-                              (self.name, ErrorString(error)))
-        # start-after/end-before: no restrictions on newlines in match-text,
-        # and no restrictions on matching inside lines vs. line boundaries
-        after_text = self.options.get('start-after', None)
-        if after_text:
-            # skip content in rawtext before *and incl.* a matching text
-            after_index = rawtext.find(after_text)
-            if after_index < 0:
-                raise self.severe('Problem with "start-after" option of "%s" '
-                                  'directive:\nText not found.' % self.name)
-            rawtext = rawtext[after_index + len(after_text):]
-        before_text = self.options.get('end-before', None)
-        if before_text:
-            # skip content in rawtext after *and incl.* a matching text
-            before_index = rawtext.find(before_text)
-            if before_index < 0:
-                raise self.severe('Problem with "end-before" option of "%s" '
-                                  'directive:\nText not found.' % self.name)
-            rawtext = rawtext[:before_index]
-
-        include_lines = statemachine.string2lines(rawtext, tab_width,
-                                                  convert_whitespace=True)
-        if 'literal' in self.options:
-            # Convert tabs to spaces, if `tab_width` is positive.
-            if tab_width >= 0:
-                text = rawtext.expandtabs(tab_width)
-            else:
-                text = rawtext
-            literal_block = nodes.literal_block(rawtext, source=path,
-                                    classes=self.options.get('class', []))
-            literal_block.line = 1
-            self.add_name(literal_block)
-            if 'number-lines' in self.options:
-                try:
-                    startline = int(self.options['number-lines'] or 1)
-                except ValueError:
-                    raise self.error(':number-lines: with non-integer '
-                                     'start value')
-                endline = startline + len(include_lines)
-                if text.endswith('\n'):
-                    text = text[:-1]
-                tokens = NumberLines([([], text)], startline, endline)
-                for classes, value in tokens:
-                    if classes:
-                        literal_block += nodes.inline(value, value,
-                                                      classes=classes)
-                    else:
-                        literal_block += nodes.Text(value, value)
-            else:
-                literal_block += nodes.Text(text, text)
-            return [literal_block]
-        if 'code' in self.options:
-            self.options['source'] = path
-            codeblock = CodeBlock(self.name,
-                                  [self.options.pop('code')], # arguments
-                                  self.options,
-                                  include_lines, # content
-                                  self.lineno,
-                                  self.content_offset,
-                                  self.block_text,
-                                  self.state,
-                                  self.state_machine)
-            return codeblock.run()
-        self.state_machine.insert_input(include_lines, path)
-        return []
-- 
2.7.4

