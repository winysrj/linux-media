Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43773 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941740AbcIHMES (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>
Subject: [PATCH 00/47] Fix most of Sphinx warnings in nitpick mode
Date: Thu,  8 Sep 2016 09:03:22 -0300
Message-Id: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Before this patch series, there is ~400 warnings when building docs in nitpick mode.
That means ~400 broken links.

This patch series move the C references to use Sphinx C domain, instead of 
using :ref:, add more documentation to some V4L2 headers and fix several broken
links. After this series, only 21 errors remain, and they all seem to be due to the
lack of documentation that should be there:


 make cleandocs; make DOCBOOKS="" SPHINXOPTS="-j5" SPHINXDIRS=media SPHINX_CONF="conf_nitpick.py" htmldocs

./include/media/media-entity.h:1053: warning: No description found for parameter '...'
/devel/v4l/patchwork/Documentation/media/kapi/mc-core.rst:97: WARNING: c:func reference target not found: media_devnode_release
/devel/v4l/patchwork/Documentation/media/kapi/v4l2-dev.rst:166: WARNING: c:func reference target not found: vb2_ops_wait_prepare
/devel/v4l/patchwork/Documentation/media/kapi/v4l2-dev.rst:166: WARNING: c:func reference target not found: vb2_ops_wait_finish
/devel/v4l/patchwork/Documentation/media/kapi/v4l2-fh.rst:56: WARNING: c:type reference target not found: v4l2_m2m_ctx
./include/media/v4l2-flash-led-class.h:103: WARNING: c:type reference target not found: v4l2_flash_ops
./include/media/v4l2-mem2mem.h:25: WARNING: c:func reference target not found: v4l2_m2m_job_finish
./include/media/v4l2-mem2mem.h:36: WARNING: c:func reference target not found: v4l2_m2m_job_finish
./include/media/v4l2-mem2mem.h:168: WARNING: c:type reference target not found: v4l2_m2m_ctx
./include/media/v4l2-mem2mem.h:180: WARNING: c:type reference target not found: v4l2_m2m_ctx
./include/media/v4l2-mem2mem.h:194: WARNING: c:type reference target not found: v4l2_m2m_ctx
./include/media/v4l2-mem2mem.h:205: WARNING: c:type reference target not found: v4l2_m2m_ctx
./include/media/v4l2-mem2mem.h:216: WARNING: c:type reference target not found: v4l2_m2m_ctx
./include/media/v4l2-mem2mem.h:227: WARNING: c:type reference target not found: v4l2_m2m_ctx
./include/media/v4l2-mem2mem.h:240: WARNING: c:type reference target not found: v4l2_m2m_ctx
./include/media/v4l2-mem2mem.h:251: WARNING: c:type reference target not found: v4l2_m2m_ctx
./include/media/v4l2-subdev.h:424: WARNING: c:type reference target not found: v4l2_sliced_vbi_line
./include/media/v4l2-subdev.h:768: WARNING: c:type reference target not found: v4l2_dev
./include/media/videobuf2-core.h:349: WARNING: c:func reference target not found: vb2_wait_for_all_buffers
./include/media/videobuf2-core.h:355: WARNING: c:func reference target not found: vb2_buffer_done
./include/media/videobuf2-core.h:442: WARNING: c:func reference target not found: start_streaming
./include/media/videobuf2-core.h:592: WARNING: c:type reference target not found: vb2_thread_fnc

So, it seems to fix the issue of identifying the documentation gaps via nitpick mode.

Please notice that the first patch were already submitted, and Markus proposed to
fix it via the C domain override extension.

Yet, as it reduces 20 bogus warnings, I'm keeping in this series for the ones
that may want to test this patchset.

As usual, I'm placing those patches on my development tree:

    https://git.linuxtv.org//mchehab/experimental.git/log/?h=docs-next

    git//linuxtv.org/mchehab/experimental.git docs-next

Jon,

Please notice that patches 2 and 3 touches at Documentation/sphinx/parse-headers.pl.

If it is ok for you, I intend to merge those patches (except for patch 1)
on my tree, including the two patches that touch at the parse-headers.pl
script, as, currently, the only user for it is media. I'm also OK if you prefer
to merge patches 2 and 3 on your tree instead.

Regards,
Mauro

Mauro Carvalho Chehab (47):
  kernel-doc: ignore arguments on macro definitions
  docs-rst: parse-headers.pl: make debug a command line option
  docs-rst: parse-headers.pl: use the C domain for cross-references
  [media] conf_nitpick.py: add external vars to ignore list
  [media] dvb_ringbuffer.h: Document all functions
  [media] dtv-core.rst: move DTV ringbuffer notes to kAPI doc
  [media] dvb_ringbuffer.h: document the define macros
  [media] demux.h: Fix a few documentation issues
  [media] mc-core.rst: Fix cross-references to the source
  [media] demux.h: fix a documentation warning
  [media] docs-rst: improve the kAPI documentation for the mediactl
  [media] conf_nitpick.py: ignore external functions used on mediactl
  [media] rc-map.h: document structs/enums on it
  [media] v4l2-ctrls: document some extra data structures
  [media] docs-rst: convert uAPI structs to C domain
  [media] diff-v4l.rst: Fix V4L version 1 references
  [media] v4l2-ctrls.h: fix doc reference for prepare_ext_ctrls()
  [media] docs-rst: use C domain for enum references on uapi
  [media] v4l2-ctrls.h: Fix some c:type references
  [media] cec-ioc-dqevent.rst: fix some undefined references
  [media] v4l2-ioctl.h: document the remaining functions
  [media] v4l2-dev.rst: fix a broken c domain reference
  [media] v4l2-device.h: fix some doc tags
  [media] v4l2-dv-timings.h: let kernel-doc parte the typedef argument
  [media] v4l2-subdev.rst: get rid of legacy functions
  [media] v4l2-subdev.h: fix a doc nitpick warning
  [media] docs-rst exceptions: use C domain references for DVB headers
  [media] ca-get-cap.rst: add a table for struct ca_caps
  [media] ca-get-descr-info.rst: add doc for for struct ca_descr_info
  [media] ca-get-msg.rst: add a boilerplate for struct ca_msg
  [media] ca-get-slot-info.rst: document struct ca_slot_info
  [media] ca-set-pid.rst: document struct ca_pid
  [media] docs-rst: fix the remaining broken links for DVB CA API
  [media] fix broken references on dvb/video*rst
  [media] docs-rst: fix dmx bad cross-references
  [media] docs-rst: fix cec bad cross-references
  [media] docs-rst: simplify c:type: cross references
  [media] docs-rst: fix some broken struct references
  [media] fix clock_gettime cross-references
  [media] libv4l-introdution.rst: fix function definitions
  [media] libv4l-introduction.rst: improve crossr-references
  [media] hist-v4l2.rst: don't do refs to old structures
  [media] docs-rst: fix cross-references for videodev2.h
  [media] dev-sliced-vbi.rst: fix reference for v4l2_mpeg_vbi_ITV0
  [media] media-ioc-g-topology.rst: fix a c domain reference
  [media] docs-rst: fix two wrong :name: tags
  [media] rc-map.h: fix a Sphinx warning

 Documentation/media/audio.h.rst.exceptions         |   6 +-
 Documentation/media/ca.h.rst.exceptions            |  32 +-
 Documentation/media/cec.h.rst.exceptions           |   6 -
 Documentation/media/conf_nitpick.py                |  17 +-
 Documentation/media/dmx.h.rst.exceptions           |  85 ++--
 Documentation/media/frontend.h.rst.exceptions      |   8 +-
 Documentation/media/intro.rst                      |   2 +-
 Documentation/media/kapi/dtv-core.rst              |  38 +-
 Documentation/media/kapi/mc-core.rst               |  25 +-
 Documentation/media/kapi/v4l2-dev.rst              |   2 +-
 Documentation/media/kapi/v4l2-event.rst            |   6 +-
 Documentation/media/kapi/v4l2-subdev.rst           |  21 +-
 Documentation/media/net.h.rst.exceptions           |   4 +-
 Documentation/media/uapi/cec/cec-func-poll.rst     |   2 +-
 .../media/uapi/cec/cec-ioc-adap-g-caps.rst         |   4 +-
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    |  10 +-
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   |   8 +-
 Documentation/media/uapi/cec/cec-ioc-receive.rst   |  15 +-
 .../uapi/dvb/audio-bilingual-channel-select.rst    |   2 +-
 .../media/uapi/dvb/audio-channel-select.rst        |   2 +-
 .../media/uapi/dvb/audio-select-source.rst         |   2 +-
 .../media/uapi/dvb/audio-set-attributes.rst        |   2 +-
 Documentation/media/uapi/dvb/audio-set-karaoke.rst |   2 +-
 Documentation/media/uapi/dvb/audio-set-mixer.rst   |   2 +-
 Documentation/media/uapi/dvb/audio_data_types.rst  |  37 +-
 Documentation/media/uapi/dvb/ca-get-cap.rst        |  31 +-
 Documentation/media/uapi/dvb/ca-get-descr-info.rst |  25 +-
 Documentation/media/uapi/dvb/ca-get-msg.rst        |  35 +-
 Documentation/media/uapi/dvb/ca-get-slot-info.rst  |  86 +++-
 Documentation/media/uapi/dvb/ca-send-msg.rst       |   4 +-
 Documentation/media/uapi/dvb/ca-set-descr.rst      |   6 +-
 Documentation/media/uapi/dvb/ca-set-pid.rst        |  21 +-
 Documentation/media/uapi/dvb/ca_data_types.rst     |  12 +-
 Documentation/media/uapi/dvb/dmx-get-caps.rst      |   5 +-
 Documentation/media/uapi/dvb/dmx-set-source.rst    |   2 +-
 Documentation/media/uapi/dvb/dmx_types.rst         |  41 +-
 Documentation/media/uapi/dvb/dtv-fe-stats.rst      |   2 +-
 Documentation/media/uapi/dvb/dtv-properties.rst    |   2 +-
 Documentation/media/uapi/dvb/dtv-property.rst      |   2 +-
 Documentation/media/uapi/dvb/dtv-stats.rst         |   2 +-
 .../media/uapi/dvb/dvb-frontend-event.rst          |   2 +-
 .../media/uapi/dvb/dvb-frontend-parameters.rst     |  10 +-
 Documentation/media/uapi/dvb/dvbproperty.rst       |   2 +-
 Documentation/media/uapi/dvb/fe-bandwidth-t.rst    |   5 +-
 .../media/uapi/dvb/fe-diseqc-recv-slave-reply.rst  |   7 +-
 .../media/uapi/dvb/fe-diseqc-send-burst.rst        |   9 +-
 .../media/uapi/dvb/fe-diseqc-send-master-cmd.rst   |   6 +-
 Documentation/media/uapi/dvb/fe-get-info.rst       |  15 +-
 Documentation/media/uapi/dvb/fe-get-property.rst   |   2 +-
 Documentation/media/uapi/dvb/fe-read-status.rst    |   8 +-
 Documentation/media/uapi/dvb/fe-set-tone.rst       |   9 +-
 Documentation/media/uapi/dvb/fe-set-voltage.rst    |   4 +-
 Documentation/media/uapi/dvb/fe-type-t.rst         |   8 +-
 .../media/uapi/dvb/fe_property_parameters.rst      |  69 +--
 .../media/uapi/dvb/frontend-stat-properties.rst    |   2 +-
 Documentation/media/uapi/dvb/net-add-if.rst        |  12 +-
 Documentation/media/uapi/dvb/net-get-if.rst        |   6 +-
 Documentation/media/uapi/dvb/video-command.rst     |  30 ++
 Documentation/media/uapi/dvb/video-get-event.rst   |  17 +
 Documentation/media/uapi/dvb/video-get-navi.rst    |  10 +-
 Documentation/media/uapi/dvb/video-get-size.rst    |  10 +
 Documentation/media/uapi/dvb/video-get-status.rst  |  11 +
 .../media/uapi/dvb/video-select-source.rst         |  10 +
 .../media/uapi/dvb/video-set-attributes.rst        |  16 +
 .../media/uapi/dvb/video-set-display-format.rst    |   2 +-
 Documentation/media/uapi/dvb/video-set-format.rst  |   9 +
 .../media/uapi/dvb/video-set-highlight.rst         |  26 +-
 .../media/uapi/dvb/video-set-spu-palette.rst       |  10 +-
 Documentation/media/uapi/dvb/video-set-spu.rst     |  11 +-
 Documentation/media/uapi/dvb/video_types.rst       |  16 +-
 .../media/uapi/mediactl/media-ioc-device-info.rst  |   4 +-
 .../uapi/mediactl/media-ioc-enum-entities.rst      |   6 +-
 .../media/uapi/mediactl/media-ioc-enum-links.rst   |  22 +-
 .../media/uapi/mediactl/media-ioc-g-topology.rst   |  16 +-
 .../media/uapi/mediactl/media-ioc-setup-link.rst   |   4 +-
 Documentation/media/uapi/rc/lirc-read.rst          |   2 +-
 Documentation/media/uapi/v4l/audio.rst             |  12 +-
 Documentation/media/uapi/v4l/buffer.rst            |  60 +--
 Documentation/media/uapi/v4l/crop.rst              |  14 +-
 Documentation/media/uapi/v4l/dev-capture.rst       |  16 +-
 Documentation/media/uapi/v4l/dev-osd.rst           |  22 +-
 Documentation/media/uapi/v4l/dev-output.rst        |  16 +-
 Documentation/media/uapi/v4l/dev-overlay.rst       |  22 +-
 Documentation/media/uapi/v4l/dev-radio.rst         |   2 +-
 Documentation/media/uapi/v4l/dev-raw-vbi.rst       |  14 +-
 Documentation/media/uapi/v4l/dev-rds.rst           |  14 +-
 Documentation/media/uapi/v4l/dev-sdr.rst           |  12 +-
 Documentation/media/uapi/v4l/dev-sliced-vbi.rst    |  42 +-
 Documentation/media/uapi/v4l/dev-subdev.rst        |   4 +-
 Documentation/media/uapi/v4l/dev-touch.rst         |   2 +-
 Documentation/media/uapi/v4l/diff-v4l.rst          | 104 ++---
 Documentation/media/uapi/v4l/dmabuf.rst            |   8 +-
 Documentation/media/uapi/v4l/extended-controls.rst |  10 +-
 Documentation/media/uapi/v4l/field-order.rst       |  12 +-
 Documentation/media/uapi/v4l/format.rst            |   2 +-
 Documentation/media/uapi/v4l/func-mmap.rst         |   8 +-
 Documentation/media/uapi/v4l/func-munmap.rst       |   4 +-
 Documentation/media/uapi/v4l/func-poll.rst         |   2 +-
 Documentation/media/uapi/v4l/hist-v4l2.rst         | 178 ++++----
 .../media/uapi/v4l/libv4l-introduction.rst         |  77 ++--
 Documentation/media/uapi/v4l/mmap.rst              |  12 +-
 Documentation/media/uapi/v4l/pixfmt-002.rst        |  16 +-
 Documentation/media/uapi/v4l/pixfmt-003.rst        |  32 +-
 Documentation/media/uapi/v4l/pixfmt-006.rst        |  20 +-
 Documentation/media/uapi/v4l/pixfmt.rst            |   4 +-
 Documentation/media/uapi/v4l/planar-apis.rst       |  10 +-
 Documentation/media/uapi/v4l/rw.rst                |   2 +-
 Documentation/media/uapi/v4l/selection-api-005.rst |  10 +-
 Documentation/media/uapi/v4l/standard.rst          |   8 +-
 Documentation/media/uapi/v4l/streaming-par.rst     |   2 +-
 Documentation/media/uapi/v4l/subdev-formats.rst    |  12 +-
 Documentation/media/uapi/v4l/tuner.rst             |  14 +-
 Documentation/media/uapi/v4l/userp.rst             |   8 +-
 Documentation/media/uapi/v4l/v4l2.rst              |  12 +-
 Documentation/media/uapi/v4l/video.rst             |   2 +-
 .../media/uapi/v4l/vidioc-create-bufs.rst          |  10 +-
 Documentation/media/uapi/v4l/vidioc-cropcap.rst    |   8 +-
 .../media/uapi/v4l/vidioc-dbg-g-chip-info.rst      |   4 +-
 .../media/uapi/v4l/vidioc-dbg-g-register.rst       |   8 +-
 .../media/uapi/v4l/vidioc-decoder-cmd.rst          |   6 +-
 Documentation/media/uapi/v4l/vidioc-dqevent.rst    |  46 +-
 .../media/uapi/v4l/vidioc-dv-timings-cap.rst       |  10 +-
 .../media/uapi/v4l/vidioc-encoder-cmd.rst          |   4 +-
 .../media/uapi/v4l/vidioc-enum-dv-timings.rst      |  10 +-
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst   |   8 +-
 .../media/uapi/v4l/vidioc-enum-frameintervals.rst  |  18 +-
 .../media/uapi/v4l/vidioc-enum-framesizes.rst      |  14 +-
 .../media/uapi/v4l/vidioc-enum-freq-bands.rst      |  16 +-
 Documentation/media/uapi/v4l/vidioc-enumaudio.rst  |   4 +-
 .../media/uapi/v4l/vidioc-enumaudioout.rst         |   4 +-
 Documentation/media/uapi/v4l/vidioc-enuminput.rst  |   8 +-
 Documentation/media/uapi/v4l/vidioc-enumoutput.rst |   8 +-
 Documentation/media/uapi/v4l/vidioc-enumstd.rst    |  12 +-
 Documentation/media/uapi/v4l/vidioc-expbuf.rst     |  14 +-
 Documentation/media/uapi/v4l/vidioc-g-audio.rst    |   6 +-
 Documentation/media/uapi/v4l/vidioc-g-audioout.rst |   6 +-
 Documentation/media/uapi/v4l/vidioc-g-crop.rst     |  12 +-
 Documentation/media/uapi/v4l/vidioc-g-ctrl.rst     |  10 +-
 .../media/uapi/v4l/vidioc-g-dv-timings.rst         |  10 +-
 Documentation/media/uapi/v4l/vidioc-g-edid.rst     |   2 +-
 .../media/uapi/v4l/vidioc-g-enc-index.rst          |   8 +-
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst          |  26 +-
 Documentation/media/uapi/v4l/vidioc-g-fbuf.rst     |  22 +-
 Documentation/media/uapi/v4l/vidioc-g-fmt.rst      |  26 +-
 .../media/uapi/v4l/vidioc-g-frequency.rst          |  22 +-
 Documentation/media/uapi/v4l/vidioc-g-input.rst    |   2 +-
 Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst |   2 +-
 .../media/uapi/v4l/vidioc-g-modulator.rst          |  10 +-
 Documentation/media/uapi/v4l/vidioc-g-output.rst   |   2 +-
 Documentation/media/uapi/v4l/vidioc-g-parm.rst     |  24 +-
 Documentation/media/uapi/v4l/vidioc-g-priority.rst |   2 +-
 .../media/uapi/v4l/vidioc-g-selection.rst          |  30 +-
 .../media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst     |   6 +-
 Documentation/media/uapi/v4l/vidioc-g-std.rst      |   4 +-
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst    |  16 +-
 .../media/uapi/v4l/vidioc-prepare-buf.rst          |   2 +-
 Documentation/media/uapi/v4l/vidioc-qbuf.rst       |  20 +-
 .../media/uapi/v4l/vidioc-query-dv-timings.rst     |   2 +-
 Documentation/media/uapi/v4l/vidioc-querybuf.rst   |  14 +-
 Documentation/media/uapi/v4l/vidioc-querycap.rst   |  10 +-
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |  22 +-
 Documentation/media/uapi/v4l/vidioc-reqbufs.rst    |  10 +-
 .../media/uapi/v4l/vidioc-s-hw-freq-seek.rst       |  24 +-
 Documentation/media/uapi/v4l/vidioc-streamon.rst   |   2 +-
 .../uapi/v4l/vidioc-subdev-enum-frame-interval.rst |   9 +-
 .../uapi/v4l/vidioc-subdev-enum-frame-size.rst     |   6 +-
 .../uapi/v4l/vidioc-subdev-enum-mbus-code.rst      |   6 +-
 .../media/uapi/v4l/vidioc-subdev-g-crop.rst        |  10 +-
 .../media/uapi/v4l/vidioc-subdev-g-fmt.rst         |  12 +-
 .../uapi/v4l/vidioc-subdev-g-frame-interval.rst    |  10 +-
 .../media/uapi/v4l/vidioc-subdev-g-selection.rst   |   6 +-
 .../media/uapi/v4l/vidioc-subscribe-event.rst      |   2 +-
 Documentation/media/video.h.rst.exceptions         |  20 +-
 Documentation/media/videodev2.h.rst.exceptions     | 204 ++++-----
 Documentation/sphinx/parse-headers.pl              | 127 +++---
 drivers/media/dvb-core/demux.h                     |  44 +-
 drivers/media/dvb-core/dvb_ringbuffer.h            | 222 ++++++---
 include/media/media-device.h                       | 115 +++--
 include/media/media-devnode.h                      |   2 +-
 include/media/media-entity.h                       | 237 ++++++----
 include/media/rc-map.h                             |  94 +++-
 include/media/v4l2-ctrls.h                         |  61 ++-
 include/media/v4l2-dev.h                           |  12 +-
 include/media/v4l2-device.h                        |  54 +--
 include/media/v4l2-dv-timings.h                    |   4 +-
 include/media/v4l2-ioctl.h                         | 502 ++++++++++++---------
 include/media/v4l2-subdev.h                        |   2 +-
 include/uapi/linux/dvb/video.h                     |   3 +-
 scripts/kernel-doc                                 |   5 +-
 189 files changed, 2422 insertions(+), 1758 deletions(-)

-- 
2.7.4


