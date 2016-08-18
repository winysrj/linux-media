Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35603 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754302AbcHSDo4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Aug 2016 23:44:56 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Markus Heiser <markus.heiser@darmarit.de>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 00/20] First part of LaTeX build fixes for the media book
Date: Thu, 18 Aug 2016 13:15:29 -0300
Message-Id: <cover.1471532122.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This one fix most of the issues with LaTeX output for the media book at
the V4L2 book, before "Function Reference". So, up to page 181 of a 969
pages document.

There are still some things that I was not able to fix on this set:

- the ".. notes::" tag inside a table column are getting the wrong size.
This should be fixable by rewriting a LaTeX code at conf.py, but I was
unable to do that, as I'm not familiar with LaTeX syntax. Tried some
things, but gave up as it was taking a lot of time. So, I just moved on
to other things;

- The Sphinx ReST tables are incomplete for LaTeX. There are several
missing features:

1) All LaTeX tables with a line bigger than \columwidth require an extra
tag to describe column widthes (.. tabularcolumns::). Without that, it
will assume that all columns are the same. The :widths: parameter of
flat-table is silently ignored;

2) LaTex tables bigger than one page explicitly require a tag (..
cssclass:: longtable). Without that, the table will avance 'till the end
of the page;

3) Too wide tables require to use LaTeX adjustbox extension. As Sphinx
doesn't have support for it, the code should add a hack (via .. raw::
latex)

4) I got two tables where the latex tag (.. raw:: latex) didn't work. No
idea why.

5) Now, several tables have several tags to initialize a table:

	.. raw:: latex

	    \newline\newline\begin{adjustbox}{width=\columnwidth}

	.. tabularcolumns:: |p{7.6cm}|p{1.6cm}|p{0.7cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5
cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|

	.. _v4l2-mbus-pixelcode-bayer:

	.. cssclass: longtable

	.. flat-table:: Bayer Formats
...

The order where those things happen matter. if the order gets wrong, the
tag won't do what it was expected to do.

If I got it right, cssclass should happen just before flat-table. If the
table has a tag, it should be after tabularcolumns. The raw::latex seems
to happen before all other tags.

There are also some troubles with Sphinx build system related to PDF
generation:

- It doesn't honour SPHINXDIRS when building PDF/LaTeX files;

- Sometimes, the flat-table extension crashes, when the ":widths:" or
".. tabularcolumns::" doesn't match the size of a table. When this
happens, it produces an incomplete LaTeX file until removing the
contents of Documentation/output.

I'll continue working on the LaTeX output fixups. I'll later check how
to solve the huge amount of warnings it outputs.

-

That's said, IMHO, the LaTeX/PDF output is very nice, as we can have
everything into a single file, and the output is great, IMHO.

Once the tables are resized with adjustbox, it is even easier to read
than HTML, as we can see the entire table altogether without needing
to scroll on the big ones.


Markus,

It would be great if you could look on the above issues for us and see
what could be done to improve it.


Mauro Carvalho Chehab (20):
  [media] docs-rst: re-generate typical_media_device.pdf
  [media] docs-rst: add tabularcolumns to all tables
  [media] control.rst: Fix table width
  [media] extended-controls.rst: fix table sizes
  [media] docs-rst: add column hints for pixfmt-002 and pixfmt-006
  [media] pixfmt-packed-rgb.rst: Fix cell spans
  [media] pixfmt-packed-rgb.rst: adjust tables to fit in LaTeX
  [media] pixfmt-packed-yuv.rst: adjust tables to fit in LaTeX
  [media] docs-rst: remove width hints from pixfmt byte order tables
  [media] buffer.rst: Adjust table columns for LaTeX output
  [media] dev-overlay.rst: don't ident a note
  [media] dev-raw-vbi.rst: add a footnote for the count limits
  [media] dev-raw-vbi.rst: adjust table columns for LaTeX output
  [media] docs-rst: re-generate vbi_525.pdf and vbi_625.pdf
  [media] dev-sliced-vbi.rst: use a footnote for VBI images
  [media] dev-sliced-vbi.rst: Adjust tables on LaTeX output
  [media] dev-rds.rst: adjust table dimentions for LaTeX
  [media] dev-subdev.rst: make table fully visible on LaTeX
  [media] subdev-formats.rst: adjust most of the tables to fill in page
  [media] diff-v4l.rst: Make capabilities table fit in LaTeX

 .../media/media_api_files/typical_media_device.pdf |  Bin 134268 -> 52895 bytes
 .../media/uapi/cec/cec-ioc-adap-g-caps.rst         |    4 +
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    |   10 +
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   |   10 +
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst    |    6 +
 Documentation/media/uapi/cec/cec-ioc-receive.rst   |    6 +
 .../media/uapi/dvb/fe-diseqc-recv-slave-reply.rst  |    2 +
 .../media/uapi/dvb/fe-diseqc-send-master-cmd.rst   |    2 +
 Documentation/media/uapi/dvb/fe-get-info.rst       |    2 +
 Documentation/media/uapi/dvb/fe-type-t.rst         |    2 +
 Documentation/media/uapi/gen-errors.rst            |    2 +
 .../media/uapi/mediactl/media-ioc-device-info.rst  |    2 +
 .../uapi/mediactl/media-ioc-enum-entities.rst      |    2 +
 .../media/uapi/mediactl/media-ioc-enum-links.rst   |    6 +
 .../media/uapi/mediactl/media-ioc-g-topology.rst   |   12 +
 Documentation/media/uapi/rc/rc-tables.rst          |    2 +
 Documentation/media/uapi/v4l/buffer.rst            |   28 +-
 Documentation/media/uapi/v4l/control.rst           |    4 +-
 Documentation/media/uapi/v4l/dev-overlay.rst       |   10 +-
 Documentation/media/uapi/v4l/dev-raw-vbi.rst       |   16 +-
 .../media/uapi/v4l/dev-raw-vbi_files/vbi_525.pdf   |  Bin 3395 -> 3706 bytes
 .../media/uapi/v4l/dev-raw-vbi_files/vbi_625.pdf   |  Bin 3683 -> 3996 bytes
 Documentation/media/uapi/v4l/dev-rds.rst           |    6 +
 Documentation/media/uapi/v4l/dev-sdr.rst           |    2 +
 Documentation/media/uapi/v4l/dev-sliced-vbi.rst    |   50 +-
 Documentation/media/uapi/v4l/dev-subdev.rst        |    9 +
 Documentation/media/uapi/v4l/diff-v4l.rst          |    4 +-
 Documentation/media/uapi/v4l/extended-controls.rst |   63 +-
 Documentation/media/uapi/v4l/field-order.rst       |    2 +
 Documentation/media/uapi/v4l/pixfmt-002.rst        |    4 +
 Documentation/media/uapi/v4l/pixfmt-003.rst        |    4 +
 Documentation/media/uapi/v4l/pixfmt-006.rst        |    5 +
 Documentation/media/uapi/v4l/pixfmt-007.rst        |   18 +
 Documentation/media/uapi/v4l/pixfmt-013.rst        |    2 +
 Documentation/media/uapi/v4l/pixfmt-grey.rst       |    5 -
 Documentation/media/uapi/v4l/pixfmt-m420.rst       |    4 -
 Documentation/media/uapi/v4l/pixfmt-nv12.rst       |    4 -
 Documentation/media/uapi/v4l/pixfmt-nv12m.rst      |    3 -
 Documentation/media/uapi/v4l/pixfmt-nv12mt.rst     |    2 -
 Documentation/media/uapi/v4l/pixfmt-nv16.rst       |    5 -
 Documentation/media/uapi/v4l/pixfmt-nv16m.rst      |    5 -
 Documentation/media/uapi/v4l/pixfmt-nv24.rst       |    5 -
 Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst |  115 +-
 Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst |   26 +-
 Documentation/media/uapi/v4l/pixfmt-reserved.rst   |    4 +
 Documentation/media/uapi/v4l/pixfmt-sbggr16.rst    |    6 -
 Documentation/media/uapi/v4l/pixfmt-sbggr8.rst     |    4 -
 Documentation/media/uapi/v4l/pixfmt-sdr-cs08.rst   |    5 -
 Documentation/media/uapi/v4l/pixfmt-sdr-cs14le.rst |    5 -
 Documentation/media/uapi/v4l/pixfmt-sdr-cu08.rst   |    6 -
 Documentation/media/uapi/v4l/pixfmt-sdr-cu16le.rst |    4 -
 Documentation/media/uapi/v4l/pixfmt-sdr-ru12le.rst |    3 +-
 Documentation/media/uapi/v4l/pixfmt-sgbrg8.rst     |    3 +-
 Documentation/media/uapi/v4l/pixfmt-sgrbg8.rst     |    3 +-
 Documentation/media/uapi/v4l/pixfmt-srggb10.rst    |    3 +-
 .../media/uapi/v4l/pixfmt-srggb10alaw8.rst         |    2 -
 Documentation/media/uapi/v4l/pixfmt-srggb10p.rst   |   12 +-
 Documentation/media/uapi/v4l/pixfmt-srggb12.rst    |    3 +-
 Documentation/media/uapi/v4l/pixfmt-srggb8.rst     |    3 +-
 Documentation/media/uapi/v4l/pixfmt-uv8.rst        |    3 +-
 Documentation/media/uapi/v4l/pixfmt-uyvy.rst       |    3 +-
 Documentation/media/uapi/v4l/pixfmt-vyuy.rst       |    3 +-
 Documentation/media/uapi/v4l/pixfmt-y10.rst        |    3 +-
 Documentation/media/uapi/v4l/pixfmt-y10b.rst       |    6 -
 Documentation/media/uapi/v4l/pixfmt-y12.rst        |    3 +-
 Documentation/media/uapi/v4l/pixfmt-y12i.rst       |    3 -
 Documentation/media/uapi/v4l/pixfmt-y16-be.rst     |    3 +-
 Documentation/media/uapi/v4l/pixfmt-y16.rst        |    3 +-
 Documentation/media/uapi/v4l/pixfmt-y41p.rst       |    3 +-
 Documentation/media/uapi/v4l/pixfmt-y8i.rst        |    3 +-
 Documentation/media/uapi/v4l/pixfmt-yuv410.rst     |    3 +-
 Documentation/media/uapi/v4l/pixfmt-yuv411p.rst    |    3 +-
 Documentation/media/uapi/v4l/pixfmt-yuv420.rst     |    3 +-
 Documentation/media/uapi/v4l/pixfmt-yuv420m.rst    |    3 +-
 Documentation/media/uapi/v4l/pixfmt-yuv422m.rst    |    3 +-
 Documentation/media/uapi/v4l/pixfmt-yuv422p.rst    |    3 +-
 Documentation/media/uapi/v4l/pixfmt-yuv444m.rst    |    3 +-
 Documentation/media/uapi/v4l/pixfmt-yuyv.rst       |    3 +-
 Documentation/media/uapi/v4l/pixfmt-yvyu.rst       |    3 +-
 Documentation/media/uapi/v4l/pixfmt-z16.rst        |    3 +-
 Documentation/media/uapi/v4l/subdev-formats.rst    | 5577 ++++++++++----------
 .../media/uapi/v4l/vidioc-create-bufs.rst          |    2 +
 Documentation/media/uapi/v4l/vidioc-cropcap.rst    |    4 +
 .../media/uapi/v4l/vidioc-dbg-g-chip-info.rst      |    6 +
 .../media/uapi/v4l/vidioc-dbg-g-register.rst       |    4 +
 .../media/uapi/v4l/vidioc-decoder-cmd.rst          |    4 +
 Documentation/media/uapi/v4l/vidioc-dqevent.rst    |   18 +
 .../media/uapi/v4l/vidioc-dv-timings-cap.rst       |    4 +
 .../media/uapi/v4l/vidioc-encoder-cmd.rst          |    6 +
 .../media/uapi/v4l/vidioc-enum-dv-timings.rst      |    2 +
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst   |    4 +
 .../media/uapi/v4l/vidioc-enum-frameintervals.rst  |    4 +
 .../media/uapi/v4l/vidioc-enum-framesizes.rst      |    6 +
 .../media/uapi/v4l/vidioc-enum-freq-bands.rst      |    4 +
 Documentation/media/uapi/v4l/vidioc-enuminput.rst  |    6 +
 Documentation/media/uapi/v4l/vidioc-enumoutput.rst |    6 +
 Documentation/media/uapi/v4l/vidioc-enumstd.rst    |    6 +
 Documentation/media/uapi/v4l/vidioc-expbuf.rst     |    2 +
 Documentation/media/uapi/v4l/vidioc-g-audio.rst    |    6 +
 Documentation/media/uapi/v4l/vidioc-g-audioout.rst |    2 +
 Documentation/media/uapi/v4l/vidioc-g-crop.rst     |    2 +
 Documentation/media/uapi/v4l/vidioc-g-ctrl.rst     |    2 +
 .../media/uapi/v4l/vidioc-g-dv-timings.rst         |    6 +
 Documentation/media/uapi/v4l/vidioc-g-edid.rst     |    2 +
 .../media/uapi/v4l/vidioc-g-enc-index.rst          |    6 +
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst          |    6 +
 Documentation/media/uapi/v4l/vidioc-g-fbuf.rst     |    6 +
 .../media/uapi/v4l/vidioc-g-frequency.rst          |    2 +
 Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst |    4 +
 .../media/uapi/v4l/vidioc-g-modulator.rst          |    4 +
 Documentation/media/uapi/v4l/vidioc-g-parm.rst     |   10 +
 Documentation/media/uapi/v4l/vidioc-g-priority.rst |    2 +
 .../media/uapi/v4l/vidioc-g-selection.rst          |    2 +
 .../media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst     |    4 +
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst    |    8 +
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |   10 +
 Documentation/media/uapi/v4l/vidioc-reqbufs.rst    |    2 +
 .../media/uapi/v4l/vidioc-s-hw-freq-seek.rst       |    2 +
 .../uapi/v4l/vidioc-subdev-enum-frame-interval.rst |    2 +
 .../uapi/v4l/vidioc-subdev-enum-frame-size.rst     |    2 +
 .../uapi/v4l/vidioc-subdev-enum-mbus-code.rst      |    2 +
 .../media/uapi/v4l/vidioc-subdev-g-crop.rst        |    2 +
 .../media/uapi/v4l/vidioc-subdev-g-fmt.rst         |    4 +
 .../uapi/v4l/vidioc-subdev-g-frame-interval.rst    |    2 +
 .../media/uapi/v4l/vidioc-subdev-g-selection.rst   |    2 +
 .../media/uapi/v4l/vidioc-subscribe-event.rst      |    4 +
 126 files changed, 3375 insertions(+), 3001 deletions(-)

--
2.7.4


