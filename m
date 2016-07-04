Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44691 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbcGDLrU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 00/51] First part of documentation fixups
Date: Mon,  4 Jul 2016 08:46:21 -0300
Message-Id: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series handle several fixups related to the DocBook->Sphinx conversion.

They all depend on the patches from:
	 https://github.com/return42/linux.git linux_tv_migration

I'm putting this series, based on media_tree + docs-next at this tree:
	https://git.linuxtv.org//mchehab/experimental.git/log/?h=docs-next

When I finish comparing DocBook and Sphinx versions, I'll be applying it on a
separate topic branch at media_tree.

The content is mostly fixups, although I"m also fixing a few random things to improve
documentation, when I notice the need. Just editorial changes.

Regards,
Mauro

Mauro Carvalho Chehab (51):
  Documentation: linuxt_tv: update the documentation year
  Documentation: some fixups at linux_tv/index.rst
  Documentation: v4l2.rst: Fix authors and revisions lists
  Documentation: querycap.rst: fix troubles on some references
  Documentation: linux_tv/index.rst: add xrefs for document divisions
  Documentation: app-pri.rst: Fix a bad reference
  Documentation: video.rst: use reference for VIDIOC_ENUMINPUT
  Documentation: v4l2.rst: numerate the V4L2 chapters
  Documentation: video.rst: Restore the captions for the examples
  Documentation: audio.rst: Fix some cross references
  Documentation: linux_tv: Replace reference names to match ioctls
  Documentation: linux_tv: simplify references
  Documentation: linux_tv: convert lots of consts to references
  Documentation: linux_tv: don't simplify VIDIOC_G_foo references
  Documentation: audio.rst: re-add captions for the examples
  Documentation: standard.rst: read the example captions
  Documentation: linux_tv: remove controls.rst
  Documentation: control.rst: read the example captions
  Documentation: control.rst: Fix missing reference for example 8
  Documentation: extended-controls.rst: use reference for VIDIOC_S_CTRL
  Documentation: vidioc-queryctl.rst: change the title of this chapter
  Documentation: linux_tv: supress lots of warnings
  Documentation: planar-apis.rst: fix some conversion troubles
  Documentation: crop.rst: fix conversion on this file
  Documentation: selection-api-005.rst: Fix ReST parsing
  Documentation: linux_tv: use Example x.y. instead of a single number
  Documentation: selection-api-006.rst: add missing captions
  Documentation: linux_tv: Error codes should be const
  Documentation: linux_tv: use references for structures
  Documentation: linux_tv: Fix remaining undefined references
  Documentation: pixfmt-007.rst: Fix formula parsing
  Documentation: fdl-appendix: Fix formatting issues
  Documentation: linux_tv: fix some warnings due to '*'
  Documentation: fe_property_parameters.rst: improve descriptions
  Documentation: vidioc-g-edid.rst remove a duplicate declaration
  Documentation: open.rst: fix some warnings
  Documentation: rw.rst fix a warning
  Documentation: extended-controls.rst: "count" is a constant
  Documentation: pixfmt-004.rst: Add an extra reference
  Documentation: linux_tv: remove trailing comments
  Documentation: pixfmt-y12i.rst: correct format conversion
  Documentation: pixfmt-uyvy.rst: remove an empty column
  Documentation: pixfmt-yvyu.rst: remove an empty column
  Documentation: pixfmt-vyuy.rst: remove an empty column
  Documentation: pixfmt-41p.rst: remove empty columns
  Documentation: pixfmt-yuv422m.rst: remove an empty column
  Documentation: pixfmt-yuv444m.rst: remove empty columns
  Documentation: pixfmt-yuv422p.rst: remove an empty column
  Documentation: pixfmt-yuv411p.rst: remove an empty column
  Documentation: pixfmt-nv12.rst: remove empty columns
  Documentation: pixfmt-nv12m.rst: fix conversion issues

 Documentation/linux_tv/audio.h.rst                 |  11 --
 Documentation/linux_tv/ca.h.rst                    |  11 --
 Documentation/linux_tv/conf.py                     |   2 +-
 Documentation/linux_tv/dmx.h.rst                   |  11 --
 Documentation/linux_tv/frontend.h.rst              |  11 --
 Documentation/linux_tv/index.rst                   |  47 ++-----
 .../media/dvb/FE_DISHNETWORK_SEND_LEGACY_CMD.rst   |  11 +-
 Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst  |  19 +--
 .../linux_tv/media/dvb/FE_GET_FRONTEND.rst         |  17 +--
 Documentation/linux_tv/media/dvb/FE_READ_BER.rst   |  13 +-
 .../linux_tv/media/dvb/FE_READ_SIGNAL_STRENGTH.rst |  13 +-
 Documentation/linux_tv/media/dvb/FE_READ_SNR.rst   |  13 +-
 .../media/dvb/FE_READ_UNCORRECTED_BLOCKS.rst       |  13 +-
 .../linux_tv/media/dvb/FE_SET_FRONTEND.rst         |  21 +--
 Documentation/linux_tv/media/dvb/audio.rst         |  11 --
 .../linux_tv/media/dvb/audio_data_types.rst        |  11 --
 .../linux_tv/media/dvb/audio_function_calls.rst    |  35 ++---
 Documentation/linux_tv/media/dvb/audio_h.rst       |  11 --
 Documentation/linux_tv/media/dvb/ca.rst            |  11 --
 Documentation/linux_tv/media/dvb/ca_data_types.rst |  11 --
 .../linux_tv/media/dvb/ca_function_calls.rst       |  19 +--
 Documentation/linux_tv/media/dvb/ca_h.rst          |  11 --
 Documentation/linux_tv/media/dvb/demux.rst         |  11 --
 Documentation/linux_tv/media/dvb/dmx_fcalls.rst    |  49 +++----
 Documentation/linux_tv/media/dvb/dmx_h.rst         |  11 --
 Documentation/linux_tv/media/dvb/dmx_types.rst     |  11 --
 Documentation/linux_tv/media/dvb/dtv-fe-stats.rst  |  11 --
 .../linux_tv/media/dvb/dtv-properties.rst          |  11 --
 Documentation/linux_tv/media/dvb/dtv-property.rst  |  11 --
 Documentation/linux_tv/media/dvb/dtv-stats.rst     |  11 --
 .../linux_tv/media/dvb/dvb-fe-read-status.rst      |  13 +-
 .../linux_tv/media/dvb/dvb-frontend-event.rst      |  11 --
 .../linux_tv/media/dvb/dvb-frontend-parameters.rst |  11 --
 Documentation/linux_tv/media/dvb/dvbapi.rst        |  15 +-
 .../linux_tv/media/dvb/dvbproperty-006.rst         |   9 --
 Documentation/linux_tv/media/dvb/dvbproperty.rst   |  11 --
 Documentation/linux_tv/media/dvb/examples.rst      |  11 --
 .../linux_tv/media/dvb/fe-bandwidth-t.rst          |  11 --
 .../media/dvb/fe-diseqc-recv-slave-reply.rst       |  13 +-
 .../media/dvb/fe-diseqc-reset-overload.rst         |  11 +-
 .../linux_tv/media/dvb/fe-diseqc-send-burst.rst    |  11 --
 .../media/dvb/fe-diseqc-send-master-cmd.rst        |  13 +-
 .../media/dvb/fe-enable-high-lnb-voltage.rst       |  11 +-
 Documentation/linux_tv/media/dvb/fe-get-info.rst   |  13 +-
 .../linux_tv/media/dvb/fe-get-property.rst         |  11 +-
 .../linux_tv/media/dvb/fe-read-status.rst          |  13 +-
 .../media/dvb/fe-set-frontend-tune-mode.rst        |  11 +-
 Documentation/linux_tv/media/dvb/fe-set-tone.rst   |  11 --
 .../linux_tv/media/dvb/fe-set-voltage.rst          |   9 --
 Documentation/linux_tv/media/dvb/fe-type-t.rst     |   9 --
 .../linux_tv/media/dvb/fe_property_parameters.rst  |  43 +++---
 .../media/dvb/frontend-property-cable-systems.rst  |   9 --
 .../dvb/frontend-property-satellite-systems.rst    |   9 --
 .../dvb/frontend-property-terrestrial-systems.rst  |   9 --
 .../media/dvb/frontend-stat-properties.rst         |  11 +-
 Documentation/linux_tv/media/dvb/frontend.rst      |  11 --
 .../linux_tv/media/dvb/frontend_f_close.rst        |  11 +-
 .../linux_tv/media/dvb/frontend_f_open.rst         |  15 +-
 .../linux_tv/media/dvb/frontend_fcalls.rst         |  11 --
 Documentation/linux_tv/media/dvb/frontend_h.rst    |  11 --
 .../linux_tv/media/dvb/frontend_legacy_api.rst     |  11 --
 .../media/dvb/frontend_legacy_dvbv3_api.rst        |  11 --
 Documentation/linux_tv/media/dvb/intro.rst         |   9 --
 .../linux_tv/media/dvb/intro_files/dvbstb.png      | Bin 22655 -> 22703 bytes
 .../linux_tv/media/dvb/legacy_dvb_apis.rst         |  11 --
 Documentation/linux_tv/media/dvb/net.rst           |  15 +-
 Documentation/linux_tv/media/dvb/net_h.rst         |  11 --
 .../linux_tv/media/dvb/query-dvb-frontend-info.rst |  11 +-
 Documentation/linux_tv/media/dvb/video.rst         |  11 --
 .../linux_tv/media/dvb/video_function_calls.rst    |  69 ++++------
 Documentation/linux_tv/media/dvb/video_h.rst       |  11 --
 Documentation/linux_tv/media/dvb/video_types.rst   |  11 --
 .../media/v4l/Remote_controllers_Intro.rst         |   9 --
 .../media/v4l/Remote_controllers_table_change.rst  |  11 --
 .../media/v4l/Remote_controllers_tables.rst        |  11 --
 Documentation/linux_tv/media/v4l/app-pri.rst       |  21 +--
 Documentation/linux_tv/media/v4l/async.rst         |   9 --
 Documentation/linux_tv/media/v4l/audio.rst         |  37 ++---
 Documentation/linux_tv/media/v4l/biblio.rst        |   9 --
 Documentation/linux_tv/media/v4l/buffer.rst        |  69 ++++------
 .../linux_tv/media/v4l/capture-example.rst         |  11 --
 Documentation/linux_tv/media/v4l/capture.c.rst     |  11 --
 Documentation/linux_tv/media/v4l/colorspaces.rst   |   9 --
 Documentation/linux_tv/media/v4l/common-defs.rst   |  11 --
 Documentation/linux_tv/media/v4l/common.rst        |  14 +-
 Documentation/linux_tv/media/v4l/compat.rst        |  11 --
 Documentation/linux_tv/media/v4l/control.rst       |  29 ++--
 Documentation/linux_tv/media/v4l/controls.rst      |  18 ---
 Documentation/linux_tv/media/v4l/crop.rst          | 130 +++++++++---------
 Documentation/linux_tv/media/v4l/depth-formats.rst |  11 --
 Documentation/linux_tv/media/v4l/dev-capture.rst   |  31 ++---
 Documentation/linux_tv/media/v4l/dev-codec.rst     |  11 +-
 Documentation/linux_tv/media/v4l/dev-effect.rst    |   9 --
 Documentation/linux_tv/media/v4l/dev-event.rst     |  13 +-
 Documentation/linux_tv/media/v4l/dev-osd.rst       |  27 ++--
 Documentation/linux_tv/media/v4l/dev-output.rst    |  29 ++--
 Documentation/linux_tv/media/v4l/dev-overlay.rst   |  63 ++++-----
 Documentation/linux_tv/media/v4l/dev-radio.rst     |  15 +-
 Documentation/linux_tv/media/v4l/dev-raw-vbi.rst   |  37 ++---
 Documentation/linux_tv/media/v4l/dev-rds.rst       |  15 +-
 Documentation/linux_tv/media/v4l/dev-sdr.rst       |  25 ++--
 .../linux_tv/media/v4l/dev-sliced-vbi.rst          |  61 ++++-----
 Documentation/linux_tv/media/v4l/dev-subdev.rst    |  35 ++---
 Documentation/linux_tv/media/v4l/dev-teletext.rst  |  11 +-
 Documentation/linux_tv/media/v4l/devices.rst       |  11 --
 Documentation/linux_tv/media/v4l/diff-v4l.rst      | 113 +++++++--------
 Documentation/linux_tv/media/v4l/dmabuf.rst        |  31 ++---
 Documentation/linux_tv/media/v4l/driver.rst        |   9 --
 Documentation/linux_tv/media/v4l/dv-timings.rst    |  19 +--
 .../linux_tv/media/v4l/extended-controls.rst       |  59 ++++----
 Documentation/linux_tv/media/v4l/fdl-appendix.rst  |  32 ++---
 Documentation/linux_tv/media/v4l/field-order.rst   |  17 +--
 .../media/v4l/field-order_files/fieldseq_tb.gif    | Bin 25323 -> 25339 bytes
 Documentation/linux_tv/media/v4l/format.rst        |  31 ++---
 Documentation/linux_tv/media/v4l/func-close.rst    |  11 +-
 Documentation/linux_tv/media/v4l/func-ioctl.rst    |  11 +-
 Documentation/linux_tv/media/v4l/func-mmap.rst     |  17 +--
 Documentation/linux_tv/media/v4l/func-munmap.rst   |  11 +-
 Documentation/linux_tv/media/v4l/func-open.rst     |  13 +-
 Documentation/linux_tv/media/v4l/func-poll.rst     |  25 ++--
 Documentation/linux_tv/media/v4l/func-read.rst     |  17 +--
 Documentation/linux_tv/media/v4l/func-select.rst   |  21 +--
 Documentation/linux_tv/media/v4l/func-write.rst    |  11 +-
 Documentation/linux_tv/media/v4l/gen-errors.rst    |  29 ++--
 Documentation/linux_tv/media/v4l/hist-v4l2.rst     | 152 ++++++++++-----------
 Documentation/linux_tv/media/v4l/io.rst            |  17 +--
 Documentation/linux_tv/media/v4l/keytable.c.rst    |  11 --
 .../linux_tv/media/v4l/libv4l-introduction.rst     |  43 +++---
 Documentation/linux_tv/media/v4l/libv4l.rst        |  11 --
 .../linux_tv/media/v4l/lirc_dev_intro.rst          |   9 --
 .../linux_tv/media/v4l/lirc_device_interface.rst   |  11 --
 Documentation/linux_tv/media/v4l/lirc_ioctl.rst    |   9 --
 Documentation/linux_tv/media/v4l/lirc_read.rst     |   9 --
 Documentation/linux_tv/media/v4l/lirc_write.rst    |  11 +-
 .../linux_tv/media/v4l/media-controller-intro.rst  |   9 --
 .../linux_tv/media/v4l/media-controller-model.rst  |   9 --
 .../linux_tv/media/v4l/media-controller.rst        |   9 --
 .../linux_tv/media/v4l/media-func-close.rst        |  11 +-
 .../linux_tv/media/v4l/media-func-ioctl.rst        |  11 +-
 .../linux_tv/media/v4l/media-func-open.rst         |  11 +-
 .../linux_tv/media/v4l/media-ioc-device-info.rst   |  11 +-
 .../linux_tv/media/v4l/media-ioc-enum-entities.rst |  13 +-
 .../linux_tv/media/v4l/media-ioc-enum-links.rst    |  11 +-
 .../linux_tv/media/v4l/media-ioc-g-topology.rst    |  11 +-
 .../linux_tv/media/v4l/media-ioc-setup-link.rst    |  17 +--
 Documentation/linux_tv/media/v4l/media-types.rst   |  11 --
 Documentation/linux_tv/media/v4l/mmap.rst          |  31 ++---
 Documentation/linux_tv/media/v4l/open.rst          |  25 +---
 Documentation/linux_tv/media/v4l/pixfmt-002.rst    |  15 +-
 Documentation/linux_tv/media/v4l/pixfmt-003.rst    |  17 +--
 Documentation/linux_tv/media/v4l/pixfmt-004.rst    |  21 +--
 Documentation/linux_tv/media/v4l/pixfmt-006.rst    |  11 --
 Documentation/linux_tv/media/v4l/pixfmt-007.rst    |  90 +++++++-----
 Documentation/linux_tv/media/v4l/pixfmt-008.rst    |   9 --
 Documentation/linux_tv/media/v4l/pixfmt-013.rst    |  15 +-
 Documentation/linux_tv/media/v4l/pixfmt-grey.rst   |  11 --
 .../linux_tv/media/v4l/pixfmt-indexed.rst          |  11 --
 Documentation/linux_tv/media/v4l/pixfmt-m420.rst   |  11 --
 Documentation/linux_tv/media/v4l/pixfmt-nv12.rst   |  24 +---
 Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst  |  24 +---
 Documentation/linux_tv/media/v4l/pixfmt-nv12mt.rst |   9 --
 Documentation/linux_tv/media/v4l/pixfmt-nv16.rst   |  11 --
 Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst  |  11 --
 Documentation/linux_tv/media/v4l/pixfmt-nv24.rst   |  11 --
 .../linux_tv/media/v4l/pixfmt-packed-rgb.rst       |  11 +-
 .../linux_tv/media/v4l/pixfmt-packed-yuv.rst       |   9 --
 .../linux_tv/media/v4l/pixfmt-reserved.rst         |  11 --
 Documentation/linux_tv/media/v4l/pixfmt-rgb.rst    |  11 --
 .../linux_tv/media/v4l/pixfmt-sbggr16.rst          |  11 --
 Documentation/linux_tv/media/v4l/pixfmt-sbggr8.rst |  11 --
 .../linux_tv/media/v4l/pixfmt-sdr-cs08.rst         |  11 --
 .../linux_tv/media/v4l/pixfmt-sdr-cs14le.rst       |  11 --
 .../linux_tv/media/v4l/pixfmt-sdr-cu08.rst         |  11 --
 .../linux_tv/media/v4l/pixfmt-sdr-cu16le.rst       |  11 --
 .../linux_tv/media/v4l/pixfmt-sdr-ru12le.rst       |  11 --
 Documentation/linux_tv/media/v4l/pixfmt-sgbrg8.rst |  11 --
 Documentation/linux_tv/media/v4l/pixfmt-sgrbg8.rst |  11 --
 .../linux_tv/media/v4l/pixfmt-srggb10.rst          |  11 --
 .../linux_tv/media/v4l/pixfmt-srggb10alaw8.rst     |   9 --
 .../linux_tv/media/v4l/pixfmt-srggb10dpcm8.rst     |  11 +-
 .../linux_tv/media/v4l/pixfmt-srggb10p.rst         |  11 --
 .../linux_tv/media/v4l/pixfmt-srggb12.rst          |  11 --
 Documentation/linux_tv/media/v4l/pixfmt-srggb8.rst |  11 --
 Documentation/linux_tv/media/v4l/pixfmt-uv8.rst    |  11 --
 Documentation/linux_tv/media/v4l/pixfmt-uyvy.rst   |  18 ---
 Documentation/linux_tv/media/v4l/pixfmt-vyuy.rst   |  20 ---
 Documentation/linux_tv/media/v4l/pixfmt-y10.rst    |  11 --
 Documentation/linux_tv/media/v4l/pixfmt-y10b.rst   |  11 --
 Documentation/linux_tv/media/v4l/pixfmt-y12.rst    |  11 --
 Documentation/linux_tv/media/v4l/pixfmt-y12i.rst   |  15 --
 Documentation/linux_tv/media/v4l/pixfmt-y16-be.rst |  11 --
 Documentation/linux_tv/media/v4l/pixfmt-y16.rst    |  11 --
 Documentation/linux_tv/media/v4l/pixfmt-y41p.rst   |  38 ------
 Documentation/linux_tv/media/v4l/pixfmt-y8i.rst    |  11 --
 Documentation/linux_tv/media/v4l/pixfmt-yuv410.rst |  11 --
 .../linux_tv/media/v4l/pixfmt-yuv411p.rst          |  23 ----
 Documentation/linux_tv/media/v4l/pixfmt-yuv420.rst |  12 +-
 .../linux_tv/media/v4l/pixfmt-yuv420m.rst          |  11 --
 .../linux_tv/media/v4l/pixfmt-yuv422m.rst          |  16 ---
 .../linux_tv/media/v4l/pixfmt-yuv422p.rst          |  16 ---
 .../linux_tv/media/v4l/pixfmt-yuv444m.rst          |  28 ----
 Documentation/linux_tv/media/v4l/pixfmt-yuyv.rst   |  11 --
 Documentation/linux_tv/media/v4l/pixfmt-yvyu.rst   |  20 ---
 Documentation/linux_tv/media/v4l/pixfmt-z16.rst    |  11 --
 Documentation/linux_tv/media/v4l/pixfmt.rst        |  19 +--
 Documentation/linux_tv/media/v4l/planar-apis.rst   |  23 +---
 Documentation/linux_tv/media/v4l/querycap.rst      |  29 ++--
 .../linux_tv/media/v4l/remote_controllers.rst      |   9 --
 .../media/v4l/remote_controllers_sysfs_nodes.rst   |  13 +-
 Documentation/linux_tv/media/v4l/rw.rst            |  17 +--
 Documentation/linux_tv/media/v4l/sdr-formats.rst   |  11 --
 .../linux_tv/media/v4l/selection-api-002.rst       |   9 --
 .../linux_tv/media/v4l/selection-api-003.rst       |   9 --
 .../linux_tv/media/v4l/selection-api-004.rst       |  15 +-
 .../linux_tv/media/v4l/selection-api-005.rst       |  20 +--
 .../linux_tv/media/v4l/selection-api-006.rst       |  14 +-
 Documentation/linux_tv/media/v4l/selection-api.rst |  11 --
 .../linux_tv/media/v4l/selections-common.rst       |  11 --
 Documentation/linux_tv/media/v4l/standard.rst      |  30 ++--
 Documentation/linux_tv/media/v4l/streaming-par.rst |  17 +--
 .../linux_tv/media/v4l/subdev-formats.rst          |  11 --
 Documentation/linux_tv/media/v4l/tuner.rst         |  37 ++---
 Documentation/linux_tv/media/v4l/user-func.rst     |  11 --
 Documentation/linux_tv/media/v4l/userp.rst         |  29 ++--
 .../linux_tv/media/v4l/v4l2-selection-flags.rst    |  11 --
 .../linux_tv/media/v4l/v4l2-selection-targets.rst  |  11 --
 Documentation/linux_tv/media/v4l/v4l2.rst          |  83 +++++------
 .../linux_tv/media/v4l/v4l2grab-example.rst        |  11 --
 Documentation/linux_tv/media/v4l/v4l2grab.c.rst    |  11 --
 Documentation/linux_tv/media/v4l/video.rst         |  30 ++--
 Documentation/linux_tv/media/v4l/videodev.rst      |  11 --
 .../linux_tv/media/v4l/vidioc-create-bufs.rst      |  27 ++--
 .../linux_tv/media/v4l/vidioc-cropcap.rst          |  15 +-
 .../linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst  |  19 +--
 .../linux_tv/media/v4l/vidioc-dbg-g-register.rst   |  21 +--
 .../linux_tv/media/v4l/vidioc-decoder-cmd.rst      |  25 ++--
 .../linux_tv/media/v4l/vidioc-dqevent.rst          |  19 +--
 .../linux_tv/media/v4l/vidioc-dv-timings-cap.rst   |  15 +-
 .../linux_tv/media/v4l/vidioc-encoder-cmd.rst      |  25 ++--
 .../linux_tv/media/v4l/vidioc-enum-dv-timings.rst  |  21 +--
 .../linux_tv/media/v4l/vidioc-enum-fmt.rst         |  19 +--
 .../media/v4l/vidioc-enum-frameintervals.rst       |  17 +--
 .../linux_tv/media/v4l/vidioc-enum-framesizes.rst  |  15 +-
 .../linux_tv/media/v4l/vidioc-enum-freq-bands.rst  |  15 +-
 .../linux_tv/media/v4l/vidioc-enumaudio.rst        |  21 +--
 .../linux_tv/media/v4l/vidioc-enumaudioout.rst     |  19 +--
 .../linux_tv/media/v4l/vidioc-enuminput.rst        |  19 +--
 .../linux_tv/media/v4l/vidioc-enumoutput.rst       |  17 +--
 .../linux_tv/media/v4l/vidioc-enumstd.rst          |  23 +---
 Documentation/linux_tv/media/v4l/vidioc-expbuf.rst |  25 ++--
 .../linux_tv/media/v4l/vidioc-g-audio.rst          |  23 +---
 .../linux_tv/media/v4l/vidioc-g-audioout.rst       |  21 +--
 Documentation/linux_tv/media/v4l/vidioc-g-crop.rst |  29 ++--
 Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst |  35 ++---
 .../linux_tv/media/v4l/vidioc-g-dv-timings.rst     |  27 ++--
 Documentation/linux_tv/media/v4l/vidioc-g-edid.rst |  39 ++----
 .../linux_tv/media/v4l/vidioc-g-enc-index.rst      |  19 +--
 .../linux_tv/media/v4l/vidioc-g-ext-ctrls.rst      |  51 +++----
 Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst |  51 +++----
 Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst  |  41 +++---
 .../linux_tv/media/v4l/vidioc-g-frequency.rst      |  21 +--
 .../linux_tv/media/v4l/vidioc-g-input.rst          |  21 +--
 .../linux_tv/media/v4l/vidioc-g-jpegcomp.rst       |  15 +-
 .../linux_tv/media/v4l/vidioc-g-modulator.rst      |  29 ++--
 .../linux_tv/media/v4l/vidioc-g-output.rst         |  21 +--
 Documentation/linux_tv/media/v4l/vidioc-g-parm.rst |  17 +--
 .../linux_tv/media/v4l/vidioc-g-priority.rst       |  15 +-
 .../linux_tv/media/v4l/vidioc-g-selection.rst      |  15 +-
 .../linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst |  19 +--
 Documentation/linux_tv/media/v4l/vidioc-g-std.rst  |  35 ++---
 .../linux_tv/media/v4l/vidioc-g-tuner.rst          |  31 ++---
 .../linux_tv/media/v4l/vidioc-log-status.rst       |  13 +-
 .../linux_tv/media/v4l/vidioc-overlay.rst          |  19 +--
 .../linux_tv/media/v4l/vidioc-prepare-buf.rst      |  19 +--
 Documentation/linux_tv/media/v4l/vidioc-qbuf.rst   |  31 ++---
 .../linux_tv/media/v4l/vidioc-query-dv-timings.rst |  25 ++--
 .../linux_tv/media/v4l/vidioc-querybuf.rst         |  21 +--
 .../linux_tv/media/v4l/vidioc-querycap.rst         |  17 +--
 .../linux_tv/media/v4l/vidioc-queryctrl.rst        |  59 ++++----
 .../linux_tv/media/v4l/vidioc-querystd.rst         |  19 +--
 .../linux_tv/media/v4l/vidioc-reqbufs.rst          |  21 +--
 .../linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst   |  19 +--
 .../linux_tv/media/v4l/vidioc-streamon.rst         |  19 +--
 .../v4l/vidioc-subdev-enum-frame-interval.rst      |  19 +--
 .../media/v4l/vidioc-subdev-enum-frame-size.rst    |  21 +--
 .../media/v4l/vidioc-subdev-enum-mbus-code.rst     |  21 +--
 .../linux_tv/media/v4l/vidioc-subdev-g-crop.rst    |  21 +--
 .../linux_tv/media/v4l/vidioc-subdev-g-fmt.rst     |  13 +-
 .../media/v4l/vidioc-subdev-g-frame-interval.rst   |  13 +-
 .../media/v4l/vidioc-subdev-g-selection.rst        |  15 +-
 .../linux_tv/media/v4l/vidioc-subscribe-event.rst  |  19 +--
 Documentation/linux_tv/media/v4l/yuv-formats.rst   |  11 --
 Documentation/linux_tv/net.h.rst                   |  11 --
 Documentation/linux_tv/video.h.rst                 |  11 --
 Documentation/linux_tv/videodev2.h.rst             |  11 --
 scripts/kernel-doc                                 |   2 +-
 296 files changed, 1294 insertions(+), 4256 deletions(-)
 delete mode 100644 Documentation/linux_tv/media/v4l/controls.rst

-- 
2.7.4


