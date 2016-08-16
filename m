Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49454 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbcHPQZv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 12:25:51 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/9] Prepare Sphinx to build media PDF books
Date: Tue, 16 Aug 2016 13:25:34 -0300
Message-Id: <cover.1471364025.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series fix Sphinx to allow it to build the media documentation as a PDF
file.

The first patch is actually a bug fix: one of the previous patch broke compilation
for PDF as a hole, as it added an extra parenthesis to a function call.

The second patch just removes a left over code for rst2pdf.

The other patches change from "pdflatex" to "xelatex" and address several
issues that prevent building the media books.

Jon,

I think this patch series belong to docs-next. Feel free to merge them there, if
you agree. There's one extra patch that touches Documentation/conf.py,
re-adding the media book to the PDF build, but IMHO this one would be better
to be merged via the media tree, after the fixes inside the media documentation
to fix the build.

I'm sending the media-specific patches on a separate patch series, meant to
be merged via the media tree.

As on the previous experimental patch series, I'm pushing the entire stuff
on my development tree, at:
	https://git.linuxtv.org//mchehab/experimental.git/log/?h=docs-next

The generated PDF file is at:
	https://mchehab.fedorapeople.org/media.pdf

Please notice that lots of tables are broken. Fixing them would require manual
work, as we'll need to add tags to specify the column size via tabularcolumns,
long tables should use the cssclass:: longtable, and very wide tables will need
to be rotated and size-adjusted.

Anyway, at least *some* PDF support for media books are now possible.


Mauro Carvalho Chehab (9):
  docs-rst: fix a breakage when building PDF documents
  docs-rst: remove a rst2pdf left over code
  docs-rst: allow generating some LaTeX pages in landscape
  docs-rst: improve output for .. notes:: on LaTeX
  docs-rst: Don't mangle with UTF-8 chars on LaTeX/PDF output
  docs-rst: better adjust margins and font size
  docs-rst: parse-heraders.pl: escape LaTeX characters
  docs-rst: Don't go to interactive mode on errors
  docs-rst: enable the Sphinx math extension

 Documentation/Makefile.sphinx         |  8 ++---
 Documentation/conf.py                 | 66 +++++++++++++++++++++++++++++------
 Documentation/sphinx/parse-headers.pl |  2 +-
 3 files changed, 60 insertions(+), 16 deletions(-)

-- 
2.7.4


