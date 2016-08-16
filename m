Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35258 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbcHPQrm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 12:47:42 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 0/9] Fix some issues at the media documentation to allow PDF build
Date: Tue, 16 Aug 2016 13:47:28 -0300
Message-Id: <cover.1471365031.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series fix several issues with the media build.

The first 4 patches are actually some random fixups that were noticed
while fixing the PDF build;

The next patch makes usage of Sphinx math expressions, to improve
readability of some formulas at pixfmt-007.rst, related to color space
conversions;

The 6th patch removes code blocks from tables, as Sphinx LaTeX output
for those blocks are broken. As the code there is really trivial, it doesn't
hurt much to just convert them into literals.

The 7th and 8th patch are actually two examples about how to improve
table outputs with LaTeX/PDF. The problem is that LaTeX requires explicit
markups to adjust the columns size. Also, Sphinx, by default, produce
portrait, single-paged tables. Manual work will be needed to fix all tables
and make them appear.

The last patch restores the build of the media documentation.

Please notice that there are some non-fatal issues related to the media
header files converted by parse-headers.pl. Those don't happen on
Sphinx 1.3.x. So, I suspect that this is actually due to some bug at the
Sphinx 1.4.x output, but I didn't try to investigate, as just ignoring them
seems to be OK (at least, visually, the output looked good on my eyes).

This series require my previous 9-patch docs-next series, with fix
bugs related to LaTeX handling.


I'm pushing the entire stuff of both series on my development tree, at:
	https://git.linuxtv.org//mchehab/experimental.git/log/?h=docs-next

The generated media PDF file is at:
	https://mchehab.fedorapeople.org/media.pdf

Mauro Carvalho Chehab (9):
  [media] pixfmt-nv12mt.rst: use PNG instead of GIF
  [media] vidioc-enumstd.rst: fix a broken reference
  [media] vidioc-enumstd.rst: remove bullets from sound carrier
  [media] docs-rst: better use the .. note:: tag
  [media] pixfmt-007.rst: use Sphinx math:: expressions
  [media] docs-rst: get rid of code-block inside tables
  [media] pixfmt-packed-rgb.rst: rotate a big table
  [media] vidioc-querycap.rst: Better format tables on PDF output
  docs-rst: add media documentation to PDF output

 Documentation/conf.py                              |   5 +
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
 Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst |   9 +-
 Documentation/media/uapi/v4l/pixfmt-sbggr16.rst    |   4 +-
 Documentation/media/uapi/v4l/pixfmt-y16-be.rst     |   4 +-
 Documentation/media/uapi/v4l/pixfmt-y16.rst        |   4 +-
 Documentation/media/uapi/v4l/standard.rst          |   4 +-
 Documentation/media/uapi/v4l/tuner.rst             |   4 +-
 Documentation/media/uapi/v4l/userp.rst             |   4 +-
 .../media/uapi/v4l/vidioc-dv-timings-cap.rst       |   4 +-
 .../media/uapi/v4l/vidioc-enum-dv-timings.rst      |   4 +-
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst   |  14 +-
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
 Documentation/media/uapi/v4l/vidioc-querycap.rst   |  22 +--
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |  16 +-
 Documentation/media/uapi/v4l/vidioc-querystd.rst   |   4 +-
 Documentation/media/uapi/v4l/vidioc-streamon.rst   |   4 +-
 .../media/uapi/v4l/vidioc-subscribe-event.rst      |   4 +-
 Documentation/media/v4l-drivers/bttv.rst           |   1 +
 65 files changed, 360 insertions(+), 162 deletions(-)
 delete mode 100644 Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt.gif
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt.png
 delete mode 100644 Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt_example.gif
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt_example.png

-- 
2.7.4


