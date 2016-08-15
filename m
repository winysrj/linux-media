Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43443 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbcHOQXu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 12:23:50 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Markus Heiser <markus.heiser@darmarit.de>,
	Jani Nikula <jani.nikula@intel.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC 0/5] Start changing media docs to build with PDF
Date: Mon, 15 Aug 2016 13:23:39 -0300
Message-Id: <cover.1471277426.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series are experimental patches that change some things at the media
books in order to make pdflatex to produce a valid document.

The first patch use Sphinx math extension. Please notice that it only works if
the rst2pdf extension is disabled, as otherwise Sphinx 1.4.x will complain about
duplicated math modules. So, it can only be applied if we give up using rst2pdf
or find the bug that prevents using it together with the math extension at the
Sphinx conf.py.

The other two patches fix some additional issues that are needed for the Latex
output to work. 

The forth patch is actually a bug fix, and should be merged upstream anyway.

The last patch is actually a HACK!!! should *never* be merged upstream as-is.

It is there to show that somehow, Sphinx LaTeX tables output is broken. On several
places where we add a note or an attention on a table row, the Latex output is
broken.  I suspect that the bug is actually when multiple lines are generated inside
a table row, but I don't know enough about LaTeX to be sure...

Anyway, this is just a PoC. I don't care enough about PDF output to try fixing
the issues at rst2pdf or at Sphinx LaTeX output (needed by pdflatex). Yet, I'd like
to see patch 1 applied, as the math expressions look a way better using LaTeX
math than before. Yet, if we do that, we'll end by needing the LaTeX big 
dependency chain.

Mauro Carvalho Chehab (5):
  [media] pixfmt-007.rst: use Sphinx math:: expressions
  [media] pixfmt-nv12mt.rst: use PNG instead of GIF
  [media] docs-rst: get rid of extra less or equal symbols
  [media] vidioc-enumstd.rst: fix a broken reference
  HACK!!!!

 Documentation/conf.py                              |   9 +-
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    |   2 +-
 Documentation/media/uapi/v4l/buffer.rst            |  15 +-
 Documentation/media/uapi/v4l/dev-overlay.rst       |   7 +-
 Documentation/media/uapi/v4l/pixfmt-007.rst        | 175 ++++++++++++++-------
 Documentation/media/uapi/v4l/pixfmt-nv12mt.rst     |   4 +-
 .../media/uapi/v4l/pixfmt-nv12mt_files/nv12mt.gif  | Bin 2108 -> 0 bytes
 .../media/uapi/v4l/pixfmt-nv12mt_files/nv12mt.png  | Bin 0 -> 1920 bytes
 .../v4l/pixfmt-nv12mt_files/nv12mt_example.gif     | Bin 6858 -> 0 bytes
 .../v4l/pixfmt-nv12mt_files/nv12mt_example.png     | Bin 0 -> 5261 bytes
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst   |  17 +-
 .../media/uapi/v4l/vidioc-enum-freq-bands.rst      |  14 +-
 Documentation/media/uapi/v4l/vidioc-enumstd.rst    |   2 +-
 13 files changed, 152 insertions(+), 93 deletions(-)
 delete mode 100644 Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt.gif
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt.png
 delete mode 100644 Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt_example.gif
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt_example.png

-- 
2.7.4


