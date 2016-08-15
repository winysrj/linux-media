Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51007 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbcHOVXR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 17:23:17 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC v2 0/9]  Make PDF output for media book to work
Date: Mon, 15 Aug 2016 18:21:51 -0300
Message-Id: <cover.1471294965.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series fix the severe issues related to LaTeX output with media.
After applying it, "make pdfdocs" generates the Kernel documentation with
all books upstream, including the media books.

There are still some caveats, but the end result can be seen at:
	https://mchehab.fedorapeople.org/TheLinuxKernel.pdf

To help people testing it, I pushed the patches on this series, plus two patches
from Jani at:
	https://git.linuxtv.org/mchehab/experimental.git/log/?h=docs-next

This series contain:

1) 3 patches fixing LaTeX handling at Documentation/conf.py

Those patches use "xelatex" instead of "pdflatex", with fix support for
UTF-8 characters, needed by the media books. It also fixes the breakages
on LaTeX Sphinx output for notes inside tables. Finally, it allows rotating
some pages at the PDF output. This is needed in order to output very big
tables. Patches to rotate such tables are not in this series.

2) a patch that makes usage of Sphinx math extension;

3) One patch converting some GIF files to PNG (needed by pdflatex).
   Didn't check if xelatex needs it, but it is still a good idea to use PNG.

4) 3 fixup patches (that are actually independent of this series

5)  A hack that does two things:
    - comment out C blocks inside tables, as Sphinx 1.4.5 produces a broken
      LaTeX file if it sees such blocks;

    - Cleans the auto-generated rst files, as the escape codes there are meant
      to work with HTML, and not LaTeX. It is likely easy to fix the perl script to do
      the right thing here, but, as Markus is writing a Sphinx extension for it,
      let's discuss it uptream before doing rework.

PS.: The last patch are not meant to be merged. Merging the other ones should
be OK.

Mauro Carvalho Chehab (9):
  docs-rst: allow generating some LaTeX pages in landscape
  docs-rst: improve output for .. notes:: on LaTeX
  docs-rst: Don't mangle with UTF-8 chars on LaTeX/PDF output
  [media] pixfmt-007.rst: use Sphinx math:: expressions
  [media] pixfmt-nv12mt.rst: use PNG instead of GIF
  [media] vidioc-enumstd.rst: fix a broken reference
  [media] vidioc-enumstd.rst: remove bullets from sound carrier
  [media] docs-rst: better use the .. note:: tag
  HACK: make pdfdocs build with media books

 Documentation/Makefile.sphinx                      |   7 +-
 Documentation/conf.py                              |  56 ++++--
 Documentation/media/uapi/cec/cec-func-close.rst    |   4 +-
 Documentation/media/uapi/cec/cec-func-ioctl.rst    |   4 +-
 Documentation/media/uapi/cec/cec-func-open.rst     |   4 +-
 Documentation/media/uapi/cec/cec-func-poll.rst     |   4 +-
 Documentation/media/uapi/cec/cec-intro.rst         |   4 +-
 .../media/uapi/cec/cec-ioc-adap-g-caps.rst         |   4 +-
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    |   4 +-
 .../media/uapi/cec/cec-ioc-adap-g-phys-addr.rst    |   4 +-
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   |   4 +-
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst    |   4 +-
 Documentation/media/uapi/cec/cec-ioc-receive.rst   |   4 +-
 .../media/uapi/dvb/dvb-fe-read-status.rst          |   4 +-
 Documentation/media/uapi/dvb/dvbapi.rst            |   4 +-
 Documentation/media/uapi/dvb/dvbproperty.rst       |   4 +-
 Documentation/media/uapi/dvb/examples.rst          |   4 +-
 Documentation/media/uapi/dvb/fe-get-info.rst       |   4 +-
 Documentation/media/uapi/dvb/fe-read-status.rst    |   4 +-
 Documentation/media/uapi/dvb/frontend.rst          |   4 +-
 .../media/uapi/rc/lirc-set-wideband-receiver.rst   |   4 +-
 Documentation/media/uapi/v4l/audio.rst             |   4 +-
 Documentation/media/uapi/v4l/buffer.rst            |  13 +-
 Documentation/media/uapi/v4l/crop.rst              |  12 +-
 Documentation/media/uapi/v4l/dev-codec.rst         |   4 +-
 Documentation/media/uapi/v4l/dev-osd.rst           |   4 +-
 Documentation/media/uapi/v4l/dev-overlay.rst       |   8 +-
 Documentation/media/uapi/v4l/dev-rds.rst           |   4 +-
 Documentation/media/uapi/v4l/extended-controls.rst |   4 +-
 Documentation/media/uapi/v4l/func-mmap.rst         |   4 +-
 Documentation/media/uapi/v4l/pixfmt-006.rst        |   4 +-
 Documentation/media/uapi/v4l/pixfmt-007.rst        | 187 ++++++++++++++-------
 Documentation/media/uapi/v4l/pixfmt-nv12mt.rst     |   4 +-
 .../media/uapi/v4l/pixfmt-nv12mt_files/nv12mt.gif  | Bin 2108 -> 0 bytes
 .../media/uapi/v4l/pixfmt-nv12mt_files/nv12mt.png  | Bin 0 -> 1920 bytes
 .../v4l/pixfmt-nv12mt_files/nv12mt_example.gif     | Bin 6858 -> 0 bytes
 .../v4l/pixfmt-nv12mt_files/nv12mt_example.png     | Bin 0 -> 5261 bytes
 Documentation/media/uapi/v4l/pixfmt-sbggr16.rst    |   4 +-
 Documentation/media/uapi/v4l/pixfmt-y16-be.rst     |   4 +-
 Documentation/media/uapi/v4l/pixfmt-y16.rst        |   4 +-
 Documentation/media/uapi/v4l/standard.rst          |   4 +-
 Documentation/media/uapi/v4l/tuner.rst             |   4 +-
 Documentation/media/uapi/v4l/userp.rst             |   4 +-
 .../media/uapi/v4l/vidioc-dv-timings-cap.rst       |   4 +-
 .../media/uapi/v4l/vidioc-enum-dv-timings.rst      |   4 +-
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst   |  17 +-
 .../media/uapi/v4l/vidioc-enum-frameintervals.rst  |   4 +-
 .../media/uapi/v4l/vidioc-enum-framesizes.rst      |   4 +-
 .../media/uapi/v4l/vidioc-enum-freq-bands.rst      |   4 +-
 .../media/uapi/v4l/vidioc-enumaudioout.rst         |   4 +-
 Documentation/media/uapi/v4l/vidioc-enumstd.rst    |  27 ++-
 Documentation/media/uapi/v4l/vidioc-g-audioout.rst |   4 +-
 Documentation/media/uapi/v4l/vidioc-g-edid.rst     |   4 +-
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst          |   8 +-
 .../media/uapi/v4l/vidioc-g-modulator.rst          |   4 +-
 .../media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst     |   4 +-
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst    |   8 +-
 Documentation/media/uapi/v4l/vidioc-qbuf.rst       |   4 +-
 .../media/uapi/v4l/vidioc-query-dv-timings.rst     |   4 +-
 Documentation/media/uapi/v4l/vidioc-querycap.rst   |  20 +--
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |  16 +-
 Documentation/media/uapi/v4l/vidioc-querystd.rst   |   4 +-
 Documentation/media/uapi/v4l/vidioc-streamon.rst   |   4 +-
 .../media/uapi/v4l/vidioc-subscribe-event.rst      |   4 +-
 Documentation/media/v4l-drivers/bttv.rst           |   1 +
 65 files changed, 396 insertions(+), 176 deletions(-)
 delete mode 100644 Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt.gif
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt.png
 delete mode 100644 Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt_example.gif
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt_example.png

-- 
2.7.4


