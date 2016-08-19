Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43174 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754558AbcHSNFK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 09:05:10 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>
Subject: [PATCH 00/15] Fix (most of) the remaining issues with uAPI book and LaTeX
Date: Fri, 19 Aug 2016 10:04:50 -0300
Message-Id: <cover.1471611003.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series addresses (almost all) remaining issues of texts going
out of the page width.

There are just two places that need fixes:
	- Two big tables at Documentation/media/uapi/v4l/subdev-formats.rst;
	- some texts at Documentation/media/uapi/v4l/extended-controls.rst
	  with very long constants (like
	  V4L2_CID_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE)
	  that are linked to very long enum types.

Yet, as mentioned on the previous patch series, some tables don't look
nice. Basically, the flat-tables with cspan columns on it are not
formatted well in LaTeX output. The tables go out of the left margin on
several such cases. Yet, all text are at the visible area. So, the
document is readable on screen. Also, on such tables, texts with more
than one line on span cells are not left-margin justified, and their
size is not well calculated. So, usually, it uses more lines than what
would be needed.

Yet, the document output is OK for usage, IMHO.


Mauro Carvalho Chehab (15):
  [media] vidioc-dqevent.rst: adjust two table columns for LaTeX output
  [media] vidioc-dv-timings-cap.rst: Adjust LaTeX columns
  [media] vidioc-enumstd.rst: adjust video standards table
  [media] vidioc-g-sliced-vbi-cap.rst: make tables fit on LaTeX output
  [media] adjust some vidioc-*rst tables with wrong columns
  [media] vidioc-g-tuner.rst: improve documentation for tuner type
  [media] vidioc-g-tuner.rst: Fix tables to fit at LaTeX output
  [media] fix v4l2-selection-*.rst tables for LaTeX output
  [media] fe_property_parameters.rst: Adjust column sizes
  [media] adjust remaining tables at DVB uAPI documentation
  [media] media-types.rst: adjust tables to fit on LaTeX output
  [media] docs-rst: move cec kAPI documentation to the media book
  [media] cec-core: Convert it to ReST format
  [media] uapi/cec: adjust tables on LaTeX output
  [media] gen-errors.rst fix error table column limits

 Documentation/{cec.txt => media/kapi/cec-core.rst} | 145 +++++++++++++--------
 Documentation/media/media_kapi.rst                 |   1 +
 .../media/uapi/cec/cec-ioc-adap-g-caps.rst         |   4 +-
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    |   6 +-
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   |  23 ++--
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst    |   6 +-
 Documentation/media/uapi/cec/cec-ioc-receive.rst   |   6 +-
 Documentation/media/uapi/dvb/audio-fopen.rst       |   2 +
 Documentation/media/uapi/dvb/ca-fopen.rst          |   2 +
 Documentation/media/uapi/dvb/dmx-fread.rst         |   3 +-
 Documentation/media/uapi/dvb/dmx-fwrite.rst        |   2 +
 .../media/uapi/dvb/dmx-set-pes-filter.rst          |   2 +-
 Documentation/media/uapi/dvb/dmx-start.rst         |   2 +-
 Documentation/media/uapi/dvb/dmx_types.rst         |   1 +
 Documentation/media/uapi/dvb/fe-get-info.rst       |   1 +
 Documentation/media/uapi/dvb/fe-read-status.rst    |   1 +
 .../media/uapi/dvb/fe_property_parameters.rst      |   3 +
 Documentation/media/uapi/dvb/video-fopen.rst       |   2 +
 Documentation/media/uapi/gen-errors.rst            |   2 +-
 Documentation/media/uapi/mediactl/media-types.rst  |  14 +-
 .../media/uapi/v4l/v4l2-selection-flags.rst        |   1 +
 .../media/uapi/v4l/v4l2-selection-targets.rst      |   2 +
 Documentation/media/uapi/v4l/vidioc-dqevent.rst    |   8 +-
 .../media/uapi/v4l/vidioc-dv-timings-cap.rst       |  14 +-
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst   |   4 +-
 .../media/uapi/v4l/vidioc-enum-freq-bands.rst      |   5 +-
 Documentation/media/uapi/v4l/vidioc-enuminput.rst  |   2 +
 Documentation/media/uapi/v4l/vidioc-enumoutput.rst |   2 +-
 Documentation/media/uapi/v4l/vidioc-enumstd.rst    |  23 +++-
 .../media/uapi/v4l/vidioc-g-dv-timings.rst         |  11 +-
 .../media/uapi/v4l/vidioc-g-enc-index.rst          |   6 +-
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst          |  14 +-
 Documentation/media/uapi/v4l/vidioc-g-fbuf.rst     |   4 +
 Documentation/media/uapi/v4l/vidioc-g-fmt.rst      |   2 +
 Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst |   2 +-
 .../media/uapi/v4l/vidioc-g-modulator.rst          |  10 +-
 .../media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst     |  30 ++++-
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst    |  44 +++++--
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |  16 ++-
 39 files changed, 283 insertions(+), 145 deletions(-)
 rename Documentation/{cec.txt => media/kapi/cec-core.rst} (72%)

-- 
2.7.4


