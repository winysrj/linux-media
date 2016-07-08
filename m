Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52226 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824AbcGHOoi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 10:44:38 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] doc_rst: rename the media Sphinx suff to Documentation/media
Date: Fri,  8 Jul 2016 11:44:24 -0300
Message-Id: <1467989064-10832-1-git-send-email-mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The name of the subsystem is "media", and not "linux_tv". Also,
as we plan to add other stuff there in the future, let's
rename also the media uAPI book to media_uapi, to make it
clearer.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/Makefile.sphinx                               |   2 +-
 Documentation/index.rst                                     |   2 +-
 Documentation/{linux_tv => media}/Makefile                  |   2 +-
 Documentation/{linux_tv => media}/audio.h.rst.exceptions    |   0
 Documentation/{linux_tv => media}/ca.h.rst.exceptions       |   0
 Documentation/{linux_tv => media}/dmx.h.rst.exceptions      |   0
 Documentation/{linux_tv => media}/frontend.h.rst.exceptions |   0
 .../media_api_files/typical_media_device.pdf                | Bin
 .../media_api_files/typical_media_device.svg                |   0
 Documentation/{linux_tv/index.rst => media/media_uapi.rst}  |  12 ++++++------
 Documentation/{linux_tv => media}/net.h.rst.exceptions      |   0
 .../uapi}/dvb/audio-bilingual-channel-select.rst            |   0
 .../media => media/uapi}/dvb/audio-channel-select.rst       |   0
 .../media => media/uapi}/dvb/audio-clear-buffer.rst         |   0
 .../{linux_tv/media => media/uapi}/dvb/audio-continue.rst   |   0
 .../{linux_tv/media => media/uapi}/dvb/audio-fclose.rst     |   0
 .../{linux_tv/media => media/uapi}/dvb/audio-fopen.rst      |   0
 .../{linux_tv/media => media/uapi}/dvb/audio-fwrite.rst     |   0
 .../media => media/uapi}/dvb/audio-get-capabilities.rst     |   0
 .../{linux_tv/media => media/uapi}/dvb/audio-get-pts.rst    |   0
 .../{linux_tv/media => media/uapi}/dvb/audio-get-status.rst |   0
 .../{linux_tv/media => media/uapi}/dvb/audio-pause.rst      |   0
 .../{linux_tv/media => media/uapi}/dvb/audio-play.rst       |   0
 .../media => media/uapi}/dvb/audio-select-source.rst        |   0
 .../media => media/uapi}/dvb/audio-set-attributes.rst       |   0
 .../media => media/uapi}/dvb/audio-set-av-sync.rst          |   0
 .../media => media/uapi}/dvb/audio-set-bypass-mode.rst      |   0
 .../{linux_tv/media => media/uapi}/dvb/audio-set-ext-id.rst |   0
 .../{linux_tv/media => media/uapi}/dvb/audio-set-id.rst     |   0
 .../media => media/uapi}/dvb/audio-set-karaoke.rst          |   0
 .../{linux_tv/media => media/uapi}/dvb/audio-set-mixer.rst  |   0
 .../{linux_tv/media => media/uapi}/dvb/audio-set-mute.rst   |   0
 .../media => media/uapi}/dvb/audio-set-streamtype.rst       |   0
 .../{linux_tv/media => media/uapi}/dvb/audio-stop.rst       |   0
 Documentation/{linux_tv/media => media/uapi}/dvb/audio.rst  |   0
 .../{linux_tv/media => media/uapi}/dvb/audio_data_types.rst |   0
 .../media => media/uapi}/dvb/audio_function_calls.rst       |   0
 .../{linux_tv/media => media/uapi}/dvb/audio_h.rst          |   0
 .../{linux_tv/media => media/uapi}/dvb/ca-fclose.rst        |   0
 .../{linux_tv/media => media/uapi}/dvb/ca-fopen.rst         |   0
 .../{linux_tv/media => media/uapi}/dvb/ca-get-cap.rst       |   0
 .../media => media/uapi}/dvb/ca-get-descr-info.rst          |   0
 .../{linux_tv/media => media/uapi}/dvb/ca-get-msg.rst       |   0
 .../{linux_tv/media => media/uapi}/dvb/ca-get-slot-info.rst |   0
 .../{linux_tv/media => media/uapi}/dvb/ca-reset.rst         |   0
 .../{linux_tv/media => media/uapi}/dvb/ca-send-msg.rst      |   0
 .../{linux_tv/media => media/uapi}/dvb/ca-set-descr.rst     |   0
 .../{linux_tv/media => media/uapi}/dvb/ca-set-pid.rst       |   0
 Documentation/{linux_tv/media => media/uapi}/dvb/ca.rst     |   0
 .../{linux_tv/media => media/uapi}/dvb/ca_data_types.rst    |   0
 .../media => media/uapi}/dvb/ca_function_calls.rst          |   0
 Documentation/{linux_tv/media => media/uapi}/dvb/ca_h.rst   |   0
 Documentation/{linux_tv/media => media/uapi}/dvb/demux.rst  |   0
 .../{linux_tv/media => media/uapi}/dvb/dmx-add-pid.rst      |   0
 .../{linux_tv/media => media/uapi}/dvb/dmx-fclose.rst       |   0
 .../{linux_tv/media => media/uapi}/dvb/dmx-fopen.rst        |   0
 .../{linux_tv/media => media/uapi}/dvb/dmx-fread.rst        |   0
 .../{linux_tv/media => media/uapi}/dvb/dmx-fwrite.rst       |   0
 .../{linux_tv/media => media/uapi}/dvb/dmx-get-caps.rst     |   0
 .../{linux_tv/media => media/uapi}/dvb/dmx-get-event.rst    |   0
 .../{linux_tv/media => media/uapi}/dvb/dmx-get-pes-pids.rst |   0
 .../{linux_tv/media => media/uapi}/dvb/dmx-get-stc.rst      |   0
 .../{linux_tv/media => media/uapi}/dvb/dmx-remove-pid.rst   |   0
 .../media => media/uapi}/dvb/dmx-set-buffer-size.rst        |   0
 .../{linux_tv/media => media/uapi}/dvb/dmx-set-filter.rst   |   0
 .../media => media/uapi}/dvb/dmx-set-pes-filter.rst         |   0
 .../{linux_tv/media => media/uapi}/dvb/dmx-set-source.rst   |   0
 .../{linux_tv/media => media/uapi}/dvb/dmx-start.rst        |   0
 .../{linux_tv/media => media/uapi}/dvb/dmx-stop.rst         |   0
 .../{linux_tv/media => media/uapi}/dvb/dmx_fcalls.rst       |   0
 Documentation/{linux_tv/media => media/uapi}/dvb/dmx_h.rst  |   0
 .../{linux_tv/media => media/uapi}/dvb/dmx_types.rst        |   0
 .../{linux_tv/media => media/uapi}/dvb/dtv-fe-stats.rst     |   0
 .../{linux_tv/media => media/uapi}/dvb/dtv-properties.rst   |   0
 .../{linux_tv/media => media/uapi}/dvb/dtv-property.rst     |   0
 .../{linux_tv/media => media/uapi}/dvb/dtv-stats.rst        |   0
 .../media => media/uapi}/dvb/dvb-fe-read-status.rst         |   0
 .../media => media/uapi}/dvb/dvb-frontend-event.rst         |   0
 .../media => media/uapi}/dvb/dvb-frontend-parameters.rst    |   0
 Documentation/{linux_tv/media => media/uapi}/dvb/dvbapi.rst |   0
 .../{linux_tv/media => media/uapi}/dvb/dvbproperty-006.rst  |   0
 .../{linux_tv/media => media/uapi}/dvb/dvbproperty.rst      |   0
 .../{linux_tv/media => media/uapi}/dvb/examples.rst         |   0
 .../{linux_tv/media => media/uapi}/dvb/fe-bandwidth-t.rst   |   0
 .../media => media/uapi}/dvb/fe-diseqc-recv-slave-reply.rst |   0
 .../media => media/uapi}/dvb/fe-diseqc-reset-overload.rst   |   0
 .../media => media/uapi}/dvb/fe-diseqc-send-burst.rst       |   0
 .../media => media/uapi}/dvb/fe-diseqc-send-master-cmd.rst  |   0
 .../uapi}/dvb/fe-dishnetwork-send-legacy-cmd.rst            |   0
 .../media => media/uapi}/dvb/fe-enable-high-lnb-voltage.rst |   0
 .../{linux_tv/media => media/uapi}/dvb/fe-get-event.rst     |   0
 .../{linux_tv/media => media/uapi}/dvb/fe-get-frontend.rst  |   0
 .../{linux_tv/media => media/uapi}/dvb/fe-get-info.rst      |   0
 .../{linux_tv/media => media/uapi}/dvb/fe-get-property.rst  |   0
 .../{linux_tv/media => media/uapi}/dvb/fe-read-ber.rst      |   0
 .../media => media/uapi}/dvb/fe-read-signal-strength.rst    |   0
 .../{linux_tv/media => media/uapi}/dvb/fe-read-snr.rst      |   0
 .../{linux_tv/media => media/uapi}/dvb/fe-read-status.rst   |   0
 .../media => media/uapi}/dvb/fe-read-uncorrected-blocks.rst |   0
 .../media => media/uapi}/dvb/fe-set-frontend-tune-mode.rst  |   0
 .../{linux_tv/media => media/uapi}/dvb/fe-set-frontend.rst  |   0
 .../{linux_tv/media => media/uapi}/dvb/fe-set-tone.rst      |   0
 .../{linux_tv/media => media/uapi}/dvb/fe-set-voltage.rst   |   0
 .../{linux_tv/media => media/uapi}/dvb/fe-type-t.rst        |   0
 .../media => media/uapi}/dvb/fe_property_parameters.rst     |   0
 .../uapi}/dvb/frontend-property-cable-systems.rst           |   0
 .../uapi}/dvb/frontend-property-satellite-systems.rst       |   0
 .../uapi}/dvb/frontend-property-terrestrial-systems.rst     |   0
 .../media => media/uapi}/dvb/frontend-stat-properties.rst   |   0
 .../{linux_tv/media => media/uapi}/dvb/frontend.rst         |   0
 .../{linux_tv/media => media/uapi}/dvb/frontend_f_close.rst |   0
 .../{linux_tv/media => media/uapi}/dvb/frontend_f_open.rst  |   0
 .../{linux_tv/media => media/uapi}/dvb/frontend_fcalls.rst  |   0
 .../{linux_tv/media => media/uapi}/dvb/frontend_h.rst       |   0
 .../media => media/uapi}/dvb/frontend_legacy_api.rst        |   0
 .../media => media/uapi}/dvb/frontend_legacy_dvbv3_api.rst  |   0
 Documentation/{linux_tv/media => media/uapi}/dvb/intro.rst  |   0
 .../media => media/uapi}/dvb/intro_files/dvbstb.pdf         | Bin
 .../media => media/uapi}/dvb/intro_files/dvbstb.png         | Bin
 .../{linux_tv/media => media/uapi}/dvb/legacy_dvb_apis.rst  |   0
 .../{linux_tv/media => media/uapi}/dvb/net-add-if.rst       |   0
 .../{linux_tv/media => media/uapi}/dvb/net-get-if.rst       |   0
 .../{linux_tv/media => media/uapi}/dvb/net-remove-if.rst    |   0
 Documentation/{linux_tv/media => media/uapi}/dvb/net.rst    |   0
 Documentation/{linux_tv/media => media/uapi}/dvb/net_h.rst  |   0
 .../media => media/uapi}/dvb/query-dvb-frontend-info.rst    |   0
 .../media => media/uapi}/dvb/video-clear-buffer.rst         |   0
 .../{linux_tv/media => media/uapi}/dvb/video-command.rst    |   0
 .../{linux_tv/media => media/uapi}/dvb/video-continue.rst   |   0
 .../media => media/uapi}/dvb/video-fast-forward.rst         |   0
 .../{linux_tv/media => media/uapi}/dvb/video-fclose.rst     |   0
 .../{linux_tv/media => media/uapi}/dvb/video-fopen.rst      |   0
 .../{linux_tv/media => media/uapi}/dvb/video-freeze.rst     |   0
 .../{linux_tv/media => media/uapi}/dvb/video-fwrite.rst     |   0
 .../media => media/uapi}/dvb/video-get-capabilities.rst     |   0
 .../{linux_tv/media => media/uapi}/dvb/video-get-event.rst  |   0
 .../media => media/uapi}/dvb/video-get-frame-count.rst      |   0
 .../media => media/uapi}/dvb/video-get-frame-rate.rst       |   0
 .../{linux_tv/media => media/uapi}/dvb/video-get-navi.rst   |   0
 .../{linux_tv/media => media/uapi}/dvb/video-get-pts.rst    |   0
 .../{linux_tv/media => media/uapi}/dvb/video-get-size.rst   |   0
 .../{linux_tv/media => media/uapi}/dvb/video-get-status.rst |   0
 .../{linux_tv/media => media/uapi}/dvb/video-play.rst       |   0
 .../media => media/uapi}/dvb/video-select-source.rst        |   0
 .../media => media/uapi}/dvb/video-set-attributes.rst       |   0
 .../{linux_tv/media => media/uapi}/dvb/video-set-blank.rst  |   0
 .../media => media/uapi}/dvb/video-set-display-format.rst   |   0
 .../{linux_tv/media => media/uapi}/dvb/video-set-format.rst |   0
 .../media => media/uapi}/dvb/video-set-highlight.rst        |   0
 .../{linux_tv/media => media/uapi}/dvb/video-set-id.rst     |   0
 .../media => media/uapi}/dvb/video-set-spu-palette.rst      |   0
 .../{linux_tv/media => media/uapi}/dvb/video-set-spu.rst    |   0
 .../media => media/uapi}/dvb/video-set-streamtype.rst       |   0
 .../{linux_tv/media => media/uapi}/dvb/video-set-system.rst |   0
 .../{linux_tv/media => media/uapi}/dvb/video-slowmotion.rst |   0
 .../media => media/uapi}/dvb/video-stillpicture.rst         |   0
 .../{linux_tv/media => media/uapi}/dvb/video-stop.rst       |   0
 .../media => media/uapi}/dvb/video-try-command.rst          |   0
 Documentation/{linux_tv/media => media/uapi}/dvb/video.rst  |   0
 .../media => media/uapi}/dvb/video_function_calls.rst       |   0
 .../{linux_tv/media => media/uapi}/dvb/video_h.rst          |   0
 .../{linux_tv/media => media/uapi}/dvb/video_types.rst      |   0
 .../{linux_tv/media => media/uapi}/fdl-appendix.rst         |   0
 Documentation/{linux_tv/media => media/uapi}/gen-errors.rst |   0
 .../uapi}/mediactl/media-controller-intro.rst               |   0
 .../uapi}/mediactl/media-controller-model.rst               |   0
 .../media => media/uapi}/mediactl/media-controller.rst      |   0
 .../media => media/uapi}/mediactl/media-func-close.rst      |   0
 .../media => media/uapi}/mediactl/media-func-ioctl.rst      |   0
 .../media => media/uapi}/mediactl/media-func-open.rst       |   0
 .../media => media/uapi}/mediactl/media-ioc-device-info.rst |   0
 .../uapi}/mediactl/media-ioc-enum-entities.rst              |   0
 .../media => media/uapi}/mediactl/media-ioc-enum-links.rst  |   0
 .../media => media/uapi}/mediactl/media-ioc-g-topology.rst  |   0
 .../media => media/uapi}/mediactl/media-ioc-setup-link.rst  |   0
 .../{linux_tv/media => media/uapi}/mediactl/media-types.rst |   0
 .../media => media/uapi}/rc/Remote_controllers_Intro.rst    |   0
 .../uapi}/rc/Remote_controllers_table_change.rst            |   0
 .../media => media/uapi}/rc/Remote_controllers_tables.rst   |   0
 .../{linux_tv/media => media/uapi}/rc/keytable.c.rst        |   4 ++--
 .../{linux_tv/media => media/uapi}/rc/lirc_dev_intro.rst    |   0
 .../media => media/uapi}/rc/lirc_device_interface.rst       |   0
 .../{linux_tv/media => media/uapi}/rc/lirc_ioctl.rst        |   0
 .../{linux_tv/media => media/uapi}/rc/lirc_read.rst         |   0
 .../{linux_tv/media => media/uapi}/rc/lirc_write.rst        |   0
 .../media => media/uapi}/rc/remote_controllers.rst          |   0
 .../uapi}/rc/remote_controllers_sysfs_nodes.rst             |   0
 .../{linux_tv/media => media/uapi}/v4l/app-pri.rst          |   0
 Documentation/{linux_tv/media => media/uapi}/v4l/async.rst  |   0
 Documentation/{linux_tv/media => media/uapi}/v4l/audio.rst  |   0
 Documentation/{linux_tv/media => media/uapi}/v4l/biblio.rst |   0
 Documentation/{linux_tv/media => media/uapi}/v4l/buffer.rst |   0
 .../{linux_tv/media => media/uapi}/v4l/capture-example.rst  |   0
 .../{linux_tv/media => media/uapi}/v4l/capture.c.rst        |   0
 .../{linux_tv/media => media/uapi}/v4l/colorspaces.rst      |   0
 .../{linux_tv/media => media/uapi}/v4l/common-defs.rst      |   0
 Documentation/{linux_tv/media => media/uapi}/v4l/common.rst |   0
 Documentation/{linux_tv/media => media/uapi}/v4l/compat.rst |   0
 .../{linux_tv/media => media/uapi}/v4l/control.rst          |   0
 Documentation/{linux_tv/media => media/uapi}/v4l/crop.rst   |   0
 .../{linux_tv/media => media/uapi}/v4l/crop_files/crop.gif  | Bin
 .../{linux_tv/media => media/uapi}/v4l/crop_files/crop.pdf  | Bin
 .../{linux_tv/media => media/uapi}/v4l/depth-formats.rst    |   0
 .../{linux_tv/media => media/uapi}/v4l/dev-capture.rst      |   0
 .../{linux_tv/media => media/uapi}/v4l/dev-codec.rst        |   0
 .../{linux_tv/media => media/uapi}/v4l/dev-effect.rst       |   0
 .../{linux_tv/media => media/uapi}/v4l/dev-event.rst        |   0
 .../{linux_tv/media => media/uapi}/v4l/dev-osd.rst          |   0
 .../{linux_tv/media => media/uapi}/v4l/dev-output.rst       |   0
 .../{linux_tv/media => media/uapi}/v4l/dev-overlay.rst      |   0
 .../{linux_tv/media => media/uapi}/v4l/dev-radio.rst        |   0
 .../{linux_tv/media => media/uapi}/v4l/dev-raw-vbi.rst      |   0
 .../media => media/uapi}/v4l/dev-raw-vbi_files/vbi_525.gif  | Bin
 .../media => media/uapi}/v4l/dev-raw-vbi_files/vbi_525.pdf  | Bin
 .../media => media/uapi}/v4l/dev-raw-vbi_files/vbi_625.gif  | Bin
 .../media => media/uapi}/v4l/dev-raw-vbi_files/vbi_625.pdf  | Bin
 .../uapi}/v4l/dev-raw-vbi_files/vbi_hsync.gif               | Bin
 .../uapi}/v4l/dev-raw-vbi_files/vbi_hsync.pdf               | Bin
 .../{linux_tv/media => media/uapi}/v4l/dev-rds.rst          |   0
 .../{linux_tv/media => media/uapi}/v4l/dev-sdr.rst          |   0
 .../{linux_tv/media => media/uapi}/v4l/dev-sliced-vbi.rst   |   0
 .../{linux_tv/media => media/uapi}/v4l/dev-subdev.rst       |   0
 .../media => media/uapi}/v4l/dev-subdev_files/pipeline.pdf  | Bin
 .../media => media/uapi}/v4l/dev-subdev_files/pipeline.png  | Bin
 .../v4l/dev-subdev_files/subdev-image-processing-crop.pdf   | Bin
 .../v4l/dev-subdev_files/subdev-image-processing-crop.svg   |   0
 .../v4l/dev-subdev_files/subdev-image-processing-full.pdf   | Bin
 .../v4l/dev-subdev_files/subdev-image-processing-full.svg   |   0
 .../subdev-image-processing-scaling-multi-source.pdf        | Bin
 .../subdev-image-processing-scaling-multi-source.svg        |   0
 .../{linux_tv/media => media/uapi}/v4l/dev-teletext.rst     |   0
 .../{linux_tv/media => media/uapi}/v4l/devices.rst          |   0
 .../{linux_tv/media => media/uapi}/v4l/diff-v4l.rst         |   0
 Documentation/{linux_tv/media => media/uapi}/v4l/dmabuf.rst |   0
 Documentation/{linux_tv/media => media/uapi}/v4l/driver.rst |   0
 .../{linux_tv/media => media/uapi}/v4l/dv-timings.rst       |   0
 .../media => media/uapi}/v4l/extended-controls.rst          |   0
 .../{linux_tv/media => media/uapi}/v4l/field-order.rst      |   0
 .../uapi}/v4l/field-order_files/fieldseq_bt.gif             | Bin
 .../uapi}/v4l/field-order_files/fieldseq_bt.pdf             | Bin
 .../uapi}/v4l/field-order_files/fieldseq_tb.gif             | Bin
 .../uapi}/v4l/field-order_files/fieldseq_tb.pdf             | Bin
 Documentation/{linux_tv/media => media/uapi}/v4l/format.rst |   0
 .../{linux_tv/media => media/uapi}/v4l/func-close.rst       |   0
 .../{linux_tv/media => media/uapi}/v4l/func-ioctl.rst       |   0
 .../{linux_tv/media => media/uapi}/v4l/func-mmap.rst        |   0
 .../{linux_tv/media => media/uapi}/v4l/func-munmap.rst      |   0
 .../{linux_tv/media => media/uapi}/v4l/func-open.rst        |   0
 .../{linux_tv/media => media/uapi}/v4l/func-poll.rst        |   0
 .../{linux_tv/media => media/uapi}/v4l/func-read.rst        |   0
 .../{linux_tv/media => media/uapi}/v4l/func-select.rst      |   0
 .../{linux_tv/media => media/uapi}/v4l/func-write.rst       |   0
 .../{linux_tv/media => media/uapi}/v4l/hist-v4l2.rst        |   0
 Documentation/{linux_tv/media => media/uapi}/v4l/io.rst     |   0
 .../media => media/uapi}/v4l/libv4l-introduction.rst        |   0
 Documentation/{linux_tv/media => media/uapi}/v4l/libv4l.rst |   0
 Documentation/{linux_tv/media => media/uapi}/v4l/mmap.rst   |   0
 Documentation/{linux_tv/media => media/uapi}/v4l/open.rst   |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-002.rst       |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-003.rst       |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-004.rst       |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-006.rst       |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-007.rst       |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-008.rst       |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-013.rst       |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-grey.rst      |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-indexed.rst   |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-m420.rst      |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-nv12.rst      |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-nv12m.rst     |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-nv12mt.rst    |   0
 .../media => media/uapi}/v4l/pixfmt-nv12mt_files/nv12mt.gif | Bin
 .../uapi}/v4l/pixfmt-nv12mt_files/nv12mt_example.gif        | Bin
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-nv16.rst      |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-nv16m.rst     |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-nv24.rst      |   0
 .../media => media/uapi}/v4l/pixfmt-packed-rgb.rst          |   0
 .../media => media/uapi}/v4l/pixfmt-packed-yuv.rst          |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-reserved.rst  |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-rgb.rst       |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-sbggr16.rst   |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-sbggr8.rst    |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-sdr-cs08.rst  |   0
 .../media => media/uapi}/v4l/pixfmt-sdr-cs14le.rst          |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-sdr-cu08.rst  |   0
 .../media => media/uapi}/v4l/pixfmt-sdr-cu16le.rst          |   0
 .../media => media/uapi}/v4l/pixfmt-sdr-ru12le.rst          |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-sgbrg8.rst    |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-sgrbg8.rst    |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-srggb10.rst   |   0
 .../media => media/uapi}/v4l/pixfmt-srggb10alaw8.rst        |   0
 .../media => media/uapi}/v4l/pixfmt-srggb10dpcm8.rst        |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-srggb10p.rst  |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-srggb12.rst   |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-srggb8.rst    |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-uv8.rst       |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-uyvy.rst      |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-vyuy.rst      |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-y10.rst       |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-y10b.rst      |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-y12.rst       |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-y12i.rst      |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-y16-be.rst    |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-y16.rst       |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-y41p.rst      |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-y8i.rst       |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-yuv410.rst    |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-yuv411p.rst   |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-yuv420.rst    |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-yuv420m.rst   |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-yuv422m.rst   |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-yuv422p.rst   |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-yuv444m.rst   |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-yuyv.rst      |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-yvyu.rst      |   0
 .../{linux_tv/media => media/uapi}/v4l/pixfmt-z16.rst       |   0
 Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt.rst |   0
 .../{linux_tv/media => media/uapi}/v4l/planar-apis.rst      |   0
 .../{linux_tv/media => media/uapi}/v4l/querycap.rst         |   0
 Documentation/{linux_tv/media => media/uapi}/v4l/rw.rst     |   0
 .../{linux_tv/media => media/uapi}/v4l/sdr-formats.rst      |   0
 .../media => media/uapi}/v4l/selection-api-002.rst          |   0
 .../media => media/uapi}/v4l/selection-api-003.rst          |   0
 .../uapi}/v4l/selection-api-003_files/selection.png         | Bin
 .../media => media/uapi}/v4l/selection-api-004.rst          |   0
 .../media => media/uapi}/v4l/selection-api-005.rst          |   0
 .../media => media/uapi}/v4l/selection-api-006.rst          |   0
 .../{linux_tv/media => media/uapi}/v4l/selection-api.rst    |   0
 .../media => media/uapi}/v4l/selections-common.rst          |   0
 .../{linux_tv/media => media/uapi}/v4l/standard.rst         |   0
 .../{linux_tv/media => media/uapi}/v4l/streaming-par.rst    |   0
 .../{linux_tv/media => media/uapi}/v4l/subdev-formats.rst   |   0
 .../media => media/uapi}/v4l/subdev-formats_files/bayer.png | Bin
 Documentation/{linux_tv/media => media/uapi}/v4l/tuner.rst  |   0
 .../{linux_tv/media => media/uapi}/v4l/user-func.rst        |   0
 Documentation/{linux_tv/media => media/uapi}/v4l/userp.rst  |   0
 .../media => media/uapi}/v4l/v4l2-selection-flags.rst       |   0
 .../media => media/uapi}/v4l/v4l2-selection-targets.rst     |   0
 Documentation/{linux_tv/media => media/uapi}/v4l/v4l2.rst   |   0
 .../{linux_tv/media => media/uapi}/v4l/v4l2grab-example.rst |   0
 .../{linux_tv/media => media/uapi}/v4l/v4l2grab.c.rst       |   0
 Documentation/{linux_tv/media => media/uapi}/v4l/video.rst  |   0
 .../{linux_tv/media => media/uapi}/v4l/videodev.rst         |   0
 .../media => media/uapi}/v4l/vidioc-create-bufs.rst         |   0
 .../{linux_tv/media => media/uapi}/v4l/vidioc-cropcap.rst   |   0
 .../media => media/uapi}/v4l/vidioc-dbg-g-chip-info.rst     |   0
 .../media => media/uapi}/v4l/vidioc-dbg-g-register.rst      |   0
 .../media => media/uapi}/v4l/vidioc-decoder-cmd.rst         |   0
 .../{linux_tv/media => media/uapi}/v4l/vidioc-dqevent.rst   |   0
 .../media => media/uapi}/v4l/vidioc-dv-timings-cap.rst      |   0
 .../media => media/uapi}/v4l/vidioc-encoder-cmd.rst         |   0
 .../media => media/uapi}/v4l/vidioc-enum-dv-timings.rst     |   0
 .../{linux_tv/media => media/uapi}/v4l/vidioc-enum-fmt.rst  |   0
 .../media => media/uapi}/v4l/vidioc-enum-frameintervals.rst |   0
 .../media => media/uapi}/v4l/vidioc-enum-framesizes.rst     |   0
 .../media => media/uapi}/v4l/vidioc-enum-freq-bands.rst     |   0
 .../{linux_tv/media => media/uapi}/v4l/vidioc-enumaudio.rst |   0
 .../media => media/uapi}/v4l/vidioc-enumaudioout.rst        |   0
 .../{linux_tv/media => media/uapi}/v4l/vidioc-enuminput.rst |   0
 .../media => media/uapi}/v4l/vidioc-enumoutput.rst          |   0
 .../{linux_tv/media => media/uapi}/v4l/vidioc-enumstd.rst   |   0
 .../{linux_tv/media => media/uapi}/v4l/vidioc-expbuf.rst    |   0
 .../{linux_tv/media => media/uapi}/v4l/vidioc-g-audio.rst   |   0
 .../media => media/uapi}/v4l/vidioc-g-audioout.rst          |   0
 .../{linux_tv/media => media/uapi}/v4l/vidioc-g-crop.rst    |   0
 .../{linux_tv/media => media/uapi}/v4l/vidioc-g-ctrl.rst    |   0
 .../media => media/uapi}/v4l/vidioc-g-dv-timings.rst        |   0
 .../{linux_tv/media => media/uapi}/v4l/vidioc-g-edid.rst    |   0
 .../media => media/uapi}/v4l/vidioc-g-enc-index.rst         |   0
 .../media => media/uapi}/v4l/vidioc-g-ext-ctrls.rst         |   0
 .../{linux_tv/media => media/uapi}/v4l/vidioc-g-fbuf.rst    |   0
 .../{linux_tv/media => media/uapi}/v4l/vidioc-g-fmt.rst     |   0
 .../media => media/uapi}/v4l/vidioc-g-frequency.rst         |   0
 .../{linux_tv/media => media/uapi}/v4l/vidioc-g-input.rst   |   0
 .../media => media/uapi}/v4l/vidioc-g-jpegcomp.rst          |   0
 .../media => media/uapi}/v4l/vidioc-g-modulator.rst         |   0
 .../{linux_tv/media => media/uapi}/v4l/vidioc-g-output.rst  |   0
 .../{linux_tv/media => media/uapi}/v4l/vidioc-g-parm.rst    |   0
 .../media => media/uapi}/v4l/vidioc-g-priority.rst          |   0
 .../media => media/uapi}/v4l/vidioc-g-selection.rst         |   0
 .../uapi}/v4l/vidioc-g-selection_files/constraints.png      | Bin
 .../media => media/uapi}/v4l/vidioc-g-sliced-vbi-cap.rst    |   0
 .../{linux_tv/media => media/uapi}/v4l/vidioc-g-std.rst     |   0
 .../{linux_tv/media => media/uapi}/v4l/vidioc-g-tuner.rst   |   0
 .../media => media/uapi}/v4l/vidioc-log-status.rst          |   0
 .../{linux_tv/media => media/uapi}/v4l/vidioc-overlay.rst   |   0
 .../media => media/uapi}/v4l/vidioc-prepare-buf.rst         |   0
 .../{linux_tv/media => media/uapi}/v4l/vidioc-qbuf.rst      |   0
 .../media => media/uapi}/v4l/vidioc-query-dv-timings.rst    |   0
 .../{linux_tv/media => media/uapi}/v4l/vidioc-querybuf.rst  |   0
 .../{linux_tv/media => media/uapi}/v4l/vidioc-querycap.rst  |   0
 .../{linux_tv/media => media/uapi}/v4l/vidioc-queryctrl.rst |   0
 .../{linux_tv/media => media/uapi}/v4l/vidioc-querystd.rst  |   0
 .../{linux_tv/media => media/uapi}/v4l/vidioc-reqbufs.rst   |   0
 .../media => media/uapi}/v4l/vidioc-s-hw-freq-seek.rst      |   0
 .../{linux_tv/media => media/uapi}/v4l/vidioc-streamon.rst  |   0
 .../uapi}/v4l/vidioc-subdev-enum-frame-interval.rst         |   0
 .../uapi}/v4l/vidioc-subdev-enum-frame-size.rst             |   0
 .../uapi}/v4l/vidioc-subdev-enum-mbus-code.rst              |   0
 .../media => media/uapi}/v4l/vidioc-subdev-g-crop.rst       |   0
 .../media => media/uapi}/v4l/vidioc-subdev-g-fmt.rst        |   0
 .../uapi}/v4l/vidioc-subdev-g-frame-interval.rst            |   0
 .../media => media/uapi}/v4l/vidioc-subdev-g-selection.rst  |   0
 .../media => media/uapi}/v4l/vidioc-subscribe-event.rst     |   0
 .../{linux_tv/media => media/uapi}/v4l/yuv-formats.rst      |   0
 Documentation/{linux_tv => media}/video.h.rst.exceptions    |   0
 .../{linux_tv => media}/videodev2.h.rst.exceptions          |   0
 407 files changed, 11 insertions(+), 11 deletions(-)
 rename Documentation/{linux_tv => media}/Makefile (97%)
 rename Documentation/{linux_tv => media}/audio.h.rst.exceptions (100%)
 rename Documentation/{linux_tv => media}/ca.h.rst.exceptions (100%)
 rename Documentation/{linux_tv => media}/dmx.h.rst.exceptions (100%)
 rename Documentation/{linux_tv => media}/frontend.h.rst.exceptions (100%)
 rename Documentation/{linux_tv => media}/media_api_files/typical_media_device.pdf (100%)
 rename Documentation/{linux_tv => media}/media_api_files/typical_media_device.svg (100%)
 rename Documentation/{linux_tv/index.rst => media/media_uapi.rst} (93%)
 rename Documentation/{linux_tv => media}/net.h.rst.exceptions (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/audio-bilingual-channel-select.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/audio-channel-select.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/audio-clear-buffer.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/audio-continue.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/audio-fclose.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/audio-fopen.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/audio-fwrite.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/audio-get-capabilities.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/audio-get-pts.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/audio-get-status.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/audio-pause.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/audio-play.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/audio-select-source.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/audio-set-attributes.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/audio-set-av-sync.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/audio-set-bypass-mode.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/audio-set-ext-id.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/audio-set-id.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/audio-set-karaoke.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/audio-set-mixer.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/audio-set-mute.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/audio-set-streamtype.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/audio-stop.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/audio.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/audio_data_types.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/audio_function_calls.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/audio_h.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/ca-fclose.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/ca-fopen.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/ca-get-cap.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/ca-get-descr-info.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/ca-get-msg.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/ca-get-slot-info.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/ca-reset.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/ca-send-msg.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/ca-set-descr.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/ca-set-pid.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/ca.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/ca_data_types.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/ca_function_calls.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/ca_h.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/demux.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dmx-add-pid.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dmx-fclose.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dmx-fopen.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dmx-fread.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dmx-fwrite.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dmx-get-caps.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dmx-get-event.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dmx-get-pes-pids.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dmx-get-stc.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dmx-remove-pid.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dmx-set-buffer-size.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dmx-set-filter.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dmx-set-pes-filter.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dmx-set-source.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dmx-start.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dmx-stop.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dmx_fcalls.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dmx_h.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dmx_types.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dtv-fe-stats.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dtv-properties.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dtv-property.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dtv-stats.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dvb-fe-read-status.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dvb-frontend-event.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dvb-frontend-parameters.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dvbapi.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dvbproperty-006.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/dvbproperty.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/examples.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/fe-bandwidth-t.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/fe-diseqc-recv-slave-reply.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/fe-diseqc-reset-overload.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/fe-diseqc-send-burst.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/fe-diseqc-send-master-cmd.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/fe-dishnetwork-send-legacy-cmd.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/fe-enable-high-lnb-voltage.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/fe-get-event.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/fe-get-frontend.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/fe-get-info.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/fe-get-property.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/fe-read-ber.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/fe-read-signal-strength.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/fe-read-snr.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/fe-read-status.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/fe-read-uncorrected-blocks.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/fe-set-frontend-tune-mode.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/fe-set-frontend.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/fe-set-tone.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/fe-set-voltage.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/fe-type-t.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/fe_property_parameters.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/frontend-property-cable-systems.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/frontend-property-satellite-systems.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/frontend-property-terrestrial-systems.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/frontend-stat-properties.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/frontend.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/frontend_f_close.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/frontend_f_open.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/frontend_fcalls.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/frontend_h.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/frontend_legacy_api.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/frontend_legacy_dvbv3_api.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/intro.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/intro_files/dvbstb.pdf (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/intro_files/dvbstb.png (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/legacy_dvb_apis.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/net-add-if.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/net-get-if.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/net-remove-if.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/net.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/net_h.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/query-dvb-frontend-info.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-clear-buffer.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-command.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-continue.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-fast-forward.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-fclose.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-fopen.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-freeze.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-fwrite.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-get-capabilities.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-get-event.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-get-frame-count.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-get-frame-rate.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-get-navi.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-get-pts.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-get-size.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-get-status.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-play.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-select-source.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-set-attributes.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-set-blank.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-set-display-format.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-set-format.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-set-highlight.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-set-id.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-set-spu-palette.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-set-spu.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-set-streamtype.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-set-system.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-slowmotion.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-stillpicture.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-stop.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video-try-command.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video_function_calls.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video_h.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/dvb/video_types.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/fdl-appendix.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/gen-errors.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/mediactl/media-controller-intro.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/mediactl/media-controller-model.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/mediactl/media-controller.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/mediactl/media-func-close.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/mediactl/media-func-ioctl.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/mediactl/media-func-open.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/mediactl/media-ioc-device-info.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/mediactl/media-ioc-enum-entities.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/mediactl/media-ioc-enum-links.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/mediactl/media-ioc-g-topology.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/mediactl/media-ioc-setup-link.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/mediactl/media-types.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/rc/Remote_controllers_Intro.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/rc/Remote_controllers_table_change.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/rc/Remote_controllers_tables.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/rc/keytable.c.rst (98%)
 rename Documentation/{linux_tv/media => media/uapi}/rc/lirc_dev_intro.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/rc/lirc_device_interface.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/rc/lirc_ioctl.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/rc/lirc_read.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/rc/lirc_write.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/rc/remote_controllers.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/rc/remote_controllers_sysfs_nodes.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/app-pri.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/async.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/audio.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/biblio.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/buffer.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/capture-example.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/capture.c.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/colorspaces.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/common-defs.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/common.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/compat.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/control.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/crop.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/crop_files/crop.gif (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/crop_files/crop.pdf (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/depth-formats.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dev-capture.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dev-codec.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dev-effect.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dev-event.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dev-osd.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dev-output.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dev-overlay.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dev-radio.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dev-raw-vbi.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dev-raw-vbi_files/vbi_525.gif (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dev-raw-vbi_files/vbi_525.pdf (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dev-raw-vbi_files/vbi_625.gif (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dev-raw-vbi_files/vbi_625.pdf (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dev-raw-vbi_files/vbi_hsync.gif (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dev-raw-vbi_files/vbi_hsync.pdf (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dev-rds.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dev-sdr.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dev-sliced-vbi.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dev-subdev.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dev-subdev_files/pipeline.pdf (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dev-subdev_files/pipeline.png (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dev-subdev_files/subdev-image-processing-crop.pdf (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dev-subdev_files/subdev-image-processing-crop.svg (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dev-subdev_files/subdev-image-processing-full.pdf (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dev-subdev_files/subdev-image-processing-full.svg (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dev-subdev_files/subdev-image-processing-scaling-multi-source.pdf (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dev-subdev_files/subdev-image-processing-scaling-multi-source.svg (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dev-teletext.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/devices.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/diff-v4l.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dmabuf.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/driver.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/dv-timings.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/extended-controls.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/field-order.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/field-order_files/fieldseq_bt.gif (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/field-order_files/fieldseq_bt.pdf (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/field-order_files/fieldseq_tb.gif (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/field-order_files/fieldseq_tb.pdf (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/format.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/func-close.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/func-ioctl.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/func-mmap.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/func-munmap.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/func-open.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/func-poll.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/func-read.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/func-select.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/func-write.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/hist-v4l2.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/io.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/libv4l-introduction.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/libv4l.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/mmap.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/open.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-002.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-003.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-004.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-006.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-007.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-008.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-013.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-grey.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-indexed.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-m420.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-nv12.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-nv12m.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-nv12mt.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-nv12mt_files/nv12mt.gif (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-nv12mt_files/nv12mt_example.gif (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-nv16.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-nv16m.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-nv24.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-packed-rgb.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-packed-yuv.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-reserved.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-rgb.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-sbggr16.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-sbggr8.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-sdr-cs08.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-sdr-cs14le.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-sdr-cu08.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-sdr-cu16le.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-sdr-ru12le.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-sgbrg8.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-sgrbg8.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-srggb10.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-srggb10alaw8.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-srggb10dpcm8.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-srggb10p.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-srggb12.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-srggb8.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-uv8.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-uyvy.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-vyuy.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-y10.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-y10b.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-y12.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-y12i.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-y16-be.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-y16.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-y41p.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-y8i.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-yuv410.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-yuv411p.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-yuv420.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-yuv420m.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-yuv422m.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-yuv422p.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-yuv444m.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-yuyv.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-yvyu.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt-z16.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/pixfmt.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/planar-apis.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/querycap.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/rw.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/sdr-formats.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/selection-api-002.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/selection-api-003.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/selection-api-003_files/selection.png (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/selection-api-004.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/selection-api-005.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/selection-api-006.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/selection-api.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/selections-common.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/standard.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/streaming-par.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/subdev-formats.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/subdev-formats_files/bayer.png (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/tuner.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/user-func.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/userp.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/v4l2-selection-flags.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/v4l2-selection-targets.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/v4l2.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/v4l2grab-example.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/v4l2grab.c.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/video.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/videodev.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-create-bufs.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-cropcap.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-dbg-g-chip-info.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-dbg-g-register.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-decoder-cmd.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-dqevent.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-dv-timings-cap.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-encoder-cmd.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-enum-dv-timings.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-enum-fmt.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-enum-frameintervals.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-enum-framesizes.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-enum-freq-bands.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-enumaudio.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-enumaudioout.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-enuminput.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-enumoutput.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-enumstd.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-expbuf.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-g-audio.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-g-audioout.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-g-crop.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-g-ctrl.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-g-dv-timings.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-g-edid.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-g-enc-index.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-g-ext-ctrls.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-g-fbuf.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-g-fmt.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-g-frequency.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-g-input.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-g-jpegcomp.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-g-modulator.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-g-output.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-g-parm.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-g-priority.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-g-selection.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-g-selection_files/constraints.png (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-g-sliced-vbi-cap.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-g-std.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-g-tuner.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-log-status.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-overlay.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-prepare-buf.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-qbuf.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-query-dv-timings.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-querybuf.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-querycap.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-queryctrl.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-querystd.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-reqbufs.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-s-hw-freq-seek.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-streamon.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-subdev-enum-frame-interval.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-subdev-enum-frame-size.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-subdev-enum-mbus-code.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-subdev-g-crop.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-subdev-g-fmt.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-subdev-g-frame-interval.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-subdev-g-selection.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/vidioc-subscribe-event.rst (100%)
 rename Documentation/{linux_tv/media => media/uapi}/v4l/yuv-formats.rst (100%)
 rename Documentation/{linux_tv => media}/video.h.rst.exceptions (100%)
 rename Documentation/{linux_tv => media}/videodev2.h.rst.exceptions (100%)

diff --git a/Documentation/Makefile.sphinx b/Documentation/Makefile.sphinx
index 5aa2161fc3df..4c87a41e8ca8 100644
--- a/Documentation/Makefile.sphinx
+++ b/Documentation/Makefile.sphinx
@@ -35,7 +35,7 @@ quiet_cmd_sphinx = SPHINX  $@
       cmd_sphinx = BUILDDIR=$(BUILDDIR) $(SPHINXBUILD) -b $2 $(ALLSPHINXOPTS) $(BUILDDIR)/$2
 
 htmldocs:
-	$(MAKE) BUILDDIR=$(BUILDDIR) -f $(srctree)/Documentation/linux_tv/Makefile $@
+	$(MAKE) BUILDDIR=$(BUILDDIR) -f $(srctree)/Documentation/media/Makefile $@
 	$(call cmd,sphinx,html)
 
 pdfdocs:
diff --git a/Documentation/index.rst b/Documentation/index.rst
index 8bc7bf4e6041..ad07716c73f4 100644
--- a/Documentation/index.rst
+++ b/Documentation/index.rst
@@ -14,7 +14,7 @@ Contents:
    :maxdepth: 2
 
    kernel-documentation
-   linux_tv/index
+   media/media_uapi
 
 Indices and tables
 ==================
diff --git a/Documentation/linux_tv/Makefile b/Documentation/media/Makefile
similarity index 97%
rename from Documentation/linux_tv/Makefile
rename to Documentation/media/Makefile
index 688e37d7b232..0efd91e9998b 100644
--- a/Documentation/linux_tv/Makefile
+++ b/Documentation/media/Makefile
@@ -2,7 +2,7 @@
 
 PARSER = $(srctree)/Documentation/sphinx/parse-headers.pl
 UAPI = $(srctree)/include/uapi/linux
-SRC_DIR=$(srctree)/Documentation/linux_tv
+SRC_DIR=$(srctree)/Documentation/media
 
 FILES = audio.h.rst ca.h.rst dmx.h.rst frontend.h.rst net.h.rst video.h.rst \
 	  videodev2.h.rst
diff --git a/Documentation/linux_tv/audio.h.rst.exceptions b/Documentation/media/audio.h.rst.exceptions
similarity index 100%
rename from Documentation/linux_tv/audio.h.rst.exceptions
rename to Documentation/media/audio.h.rst.exceptions
diff --git a/Documentation/linux_tv/ca.h.rst.exceptions b/Documentation/media/ca.h.rst.exceptions
similarity index 100%
rename from Documentation/linux_tv/ca.h.rst.exceptions
rename to Documentation/media/ca.h.rst.exceptions
diff --git a/Documentation/linux_tv/dmx.h.rst.exceptions b/Documentation/media/dmx.h.rst.exceptions
similarity index 100%
rename from Documentation/linux_tv/dmx.h.rst.exceptions
rename to Documentation/media/dmx.h.rst.exceptions
diff --git a/Documentation/linux_tv/frontend.h.rst.exceptions b/Documentation/media/frontend.h.rst.exceptions
similarity index 100%
rename from Documentation/linux_tv/frontend.h.rst.exceptions
rename to Documentation/media/frontend.h.rst.exceptions
diff --git a/Documentation/linux_tv/media_api_files/typical_media_device.pdf b/Documentation/media/media_api_files/typical_media_device.pdf
similarity index 100%
rename from Documentation/linux_tv/media_api_files/typical_media_device.pdf
rename to Documentation/media/media_api_files/typical_media_device.pdf
diff --git a/Documentation/linux_tv/media_api_files/typical_media_device.svg b/Documentation/media/media_api_files/typical_media_device.svg
similarity index 100%
rename from Documentation/linux_tv/media_api_files/typical_media_device.svg
rename to Documentation/media/media_api_files/typical_media_device.svg
diff --git a/Documentation/linux_tv/index.rst b/Documentation/media/media_uapi.rst
similarity index 93%
rename from Documentation/linux_tv/index.rst
rename to Documentation/media/media_uapi.rst
index 67b3ef6ec3d7..8211cc963b56 100644
--- a/Documentation/linux_tv/index.rst
+++ b/Documentation/media/media_uapi.rst
@@ -68,12 +68,12 @@ etc, please mail to:
 .. toctree::
     :maxdepth: 1
 
-    media/v4l/v4l2
-    media/dvb/dvbapi
-    media/rc/remote_controllers
-    media/mediactl/media-controller
-    media/gen-errors
-    media/fdl-appendix
+    uapi/v4l/v4l2
+    uapi/dvb/dvbapi
+    uapi/rc/remote_controllers
+    uapi/mediactl/media-controller
+    uapi/gen-errors
+    uapi/fdl-appendix
 
 .. only:: html
 
diff --git a/Documentation/linux_tv/net.h.rst.exceptions b/Documentation/media/net.h.rst.exceptions
similarity index 100%
rename from Documentation/linux_tv/net.h.rst.exceptions
rename to Documentation/media/net.h.rst.exceptions
diff --git a/Documentation/linux_tv/media/dvb/audio-bilingual-channel-select.rst b/Documentation/media/uapi/dvb/audio-bilingual-channel-select.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/audio-bilingual-channel-select.rst
rename to Documentation/media/uapi/dvb/audio-bilingual-channel-select.rst
diff --git a/Documentation/linux_tv/media/dvb/audio-channel-select.rst b/Documentation/media/uapi/dvb/audio-channel-select.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/audio-channel-select.rst
rename to Documentation/media/uapi/dvb/audio-channel-select.rst
diff --git a/Documentation/linux_tv/media/dvb/audio-clear-buffer.rst b/Documentation/media/uapi/dvb/audio-clear-buffer.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/audio-clear-buffer.rst
rename to Documentation/media/uapi/dvb/audio-clear-buffer.rst
diff --git a/Documentation/linux_tv/media/dvb/audio-continue.rst b/Documentation/media/uapi/dvb/audio-continue.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/audio-continue.rst
rename to Documentation/media/uapi/dvb/audio-continue.rst
diff --git a/Documentation/linux_tv/media/dvb/audio-fclose.rst b/Documentation/media/uapi/dvb/audio-fclose.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/audio-fclose.rst
rename to Documentation/media/uapi/dvb/audio-fclose.rst
diff --git a/Documentation/linux_tv/media/dvb/audio-fopen.rst b/Documentation/media/uapi/dvb/audio-fopen.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/audio-fopen.rst
rename to Documentation/media/uapi/dvb/audio-fopen.rst
diff --git a/Documentation/linux_tv/media/dvb/audio-fwrite.rst b/Documentation/media/uapi/dvb/audio-fwrite.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/audio-fwrite.rst
rename to Documentation/media/uapi/dvb/audio-fwrite.rst
diff --git a/Documentation/linux_tv/media/dvb/audio-get-capabilities.rst b/Documentation/media/uapi/dvb/audio-get-capabilities.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/audio-get-capabilities.rst
rename to Documentation/media/uapi/dvb/audio-get-capabilities.rst
diff --git a/Documentation/linux_tv/media/dvb/audio-get-pts.rst b/Documentation/media/uapi/dvb/audio-get-pts.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/audio-get-pts.rst
rename to Documentation/media/uapi/dvb/audio-get-pts.rst
diff --git a/Documentation/linux_tv/media/dvb/audio-get-status.rst b/Documentation/media/uapi/dvb/audio-get-status.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/audio-get-status.rst
rename to Documentation/media/uapi/dvb/audio-get-status.rst
diff --git a/Documentation/linux_tv/media/dvb/audio-pause.rst b/Documentation/media/uapi/dvb/audio-pause.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/audio-pause.rst
rename to Documentation/media/uapi/dvb/audio-pause.rst
diff --git a/Documentation/linux_tv/media/dvb/audio-play.rst b/Documentation/media/uapi/dvb/audio-play.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/audio-play.rst
rename to Documentation/media/uapi/dvb/audio-play.rst
diff --git a/Documentation/linux_tv/media/dvb/audio-select-source.rst b/Documentation/media/uapi/dvb/audio-select-source.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/audio-select-source.rst
rename to Documentation/media/uapi/dvb/audio-select-source.rst
diff --git a/Documentation/linux_tv/media/dvb/audio-set-attributes.rst b/Documentation/media/uapi/dvb/audio-set-attributes.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/audio-set-attributes.rst
rename to Documentation/media/uapi/dvb/audio-set-attributes.rst
diff --git a/Documentation/linux_tv/media/dvb/audio-set-av-sync.rst b/Documentation/media/uapi/dvb/audio-set-av-sync.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/audio-set-av-sync.rst
rename to Documentation/media/uapi/dvb/audio-set-av-sync.rst
diff --git a/Documentation/linux_tv/media/dvb/audio-set-bypass-mode.rst b/Documentation/media/uapi/dvb/audio-set-bypass-mode.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/audio-set-bypass-mode.rst
rename to Documentation/media/uapi/dvb/audio-set-bypass-mode.rst
diff --git a/Documentation/linux_tv/media/dvb/audio-set-ext-id.rst b/Documentation/media/uapi/dvb/audio-set-ext-id.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/audio-set-ext-id.rst
rename to Documentation/media/uapi/dvb/audio-set-ext-id.rst
diff --git a/Documentation/linux_tv/media/dvb/audio-set-id.rst b/Documentation/media/uapi/dvb/audio-set-id.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/audio-set-id.rst
rename to Documentation/media/uapi/dvb/audio-set-id.rst
diff --git a/Documentation/linux_tv/media/dvb/audio-set-karaoke.rst b/Documentation/media/uapi/dvb/audio-set-karaoke.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/audio-set-karaoke.rst
rename to Documentation/media/uapi/dvb/audio-set-karaoke.rst
diff --git a/Documentation/linux_tv/media/dvb/audio-set-mixer.rst b/Documentation/media/uapi/dvb/audio-set-mixer.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/audio-set-mixer.rst
rename to Documentation/media/uapi/dvb/audio-set-mixer.rst
diff --git a/Documentation/linux_tv/media/dvb/audio-set-mute.rst b/Documentation/media/uapi/dvb/audio-set-mute.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/audio-set-mute.rst
rename to Documentation/media/uapi/dvb/audio-set-mute.rst
diff --git a/Documentation/linux_tv/media/dvb/audio-set-streamtype.rst b/Documentation/media/uapi/dvb/audio-set-streamtype.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/audio-set-streamtype.rst
rename to Documentation/media/uapi/dvb/audio-set-streamtype.rst
diff --git a/Documentation/linux_tv/media/dvb/audio-stop.rst b/Documentation/media/uapi/dvb/audio-stop.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/audio-stop.rst
rename to Documentation/media/uapi/dvb/audio-stop.rst
diff --git a/Documentation/linux_tv/media/dvb/audio.rst b/Documentation/media/uapi/dvb/audio.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/audio.rst
rename to Documentation/media/uapi/dvb/audio.rst
diff --git a/Documentation/linux_tv/media/dvb/audio_data_types.rst b/Documentation/media/uapi/dvb/audio_data_types.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/audio_data_types.rst
rename to Documentation/media/uapi/dvb/audio_data_types.rst
diff --git a/Documentation/linux_tv/media/dvb/audio_function_calls.rst b/Documentation/media/uapi/dvb/audio_function_calls.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/audio_function_calls.rst
rename to Documentation/media/uapi/dvb/audio_function_calls.rst
diff --git a/Documentation/linux_tv/media/dvb/audio_h.rst b/Documentation/media/uapi/dvb/audio_h.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/audio_h.rst
rename to Documentation/media/uapi/dvb/audio_h.rst
diff --git a/Documentation/linux_tv/media/dvb/ca-fclose.rst b/Documentation/media/uapi/dvb/ca-fclose.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/ca-fclose.rst
rename to Documentation/media/uapi/dvb/ca-fclose.rst
diff --git a/Documentation/linux_tv/media/dvb/ca-fopen.rst b/Documentation/media/uapi/dvb/ca-fopen.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/ca-fopen.rst
rename to Documentation/media/uapi/dvb/ca-fopen.rst
diff --git a/Documentation/linux_tv/media/dvb/ca-get-cap.rst b/Documentation/media/uapi/dvb/ca-get-cap.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/ca-get-cap.rst
rename to Documentation/media/uapi/dvb/ca-get-cap.rst
diff --git a/Documentation/linux_tv/media/dvb/ca-get-descr-info.rst b/Documentation/media/uapi/dvb/ca-get-descr-info.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/ca-get-descr-info.rst
rename to Documentation/media/uapi/dvb/ca-get-descr-info.rst
diff --git a/Documentation/linux_tv/media/dvb/ca-get-msg.rst b/Documentation/media/uapi/dvb/ca-get-msg.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/ca-get-msg.rst
rename to Documentation/media/uapi/dvb/ca-get-msg.rst
diff --git a/Documentation/linux_tv/media/dvb/ca-get-slot-info.rst b/Documentation/media/uapi/dvb/ca-get-slot-info.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/ca-get-slot-info.rst
rename to Documentation/media/uapi/dvb/ca-get-slot-info.rst
diff --git a/Documentation/linux_tv/media/dvb/ca-reset.rst b/Documentation/media/uapi/dvb/ca-reset.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/ca-reset.rst
rename to Documentation/media/uapi/dvb/ca-reset.rst
diff --git a/Documentation/linux_tv/media/dvb/ca-send-msg.rst b/Documentation/media/uapi/dvb/ca-send-msg.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/ca-send-msg.rst
rename to Documentation/media/uapi/dvb/ca-send-msg.rst
diff --git a/Documentation/linux_tv/media/dvb/ca-set-descr.rst b/Documentation/media/uapi/dvb/ca-set-descr.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/ca-set-descr.rst
rename to Documentation/media/uapi/dvb/ca-set-descr.rst
diff --git a/Documentation/linux_tv/media/dvb/ca-set-pid.rst b/Documentation/media/uapi/dvb/ca-set-pid.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/ca-set-pid.rst
rename to Documentation/media/uapi/dvb/ca-set-pid.rst
diff --git a/Documentation/linux_tv/media/dvb/ca.rst b/Documentation/media/uapi/dvb/ca.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/ca.rst
rename to Documentation/media/uapi/dvb/ca.rst
diff --git a/Documentation/linux_tv/media/dvb/ca_data_types.rst b/Documentation/media/uapi/dvb/ca_data_types.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/ca_data_types.rst
rename to Documentation/media/uapi/dvb/ca_data_types.rst
diff --git a/Documentation/linux_tv/media/dvb/ca_function_calls.rst b/Documentation/media/uapi/dvb/ca_function_calls.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/ca_function_calls.rst
rename to Documentation/media/uapi/dvb/ca_function_calls.rst
diff --git a/Documentation/linux_tv/media/dvb/ca_h.rst b/Documentation/media/uapi/dvb/ca_h.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/ca_h.rst
rename to Documentation/media/uapi/dvb/ca_h.rst
diff --git a/Documentation/linux_tv/media/dvb/demux.rst b/Documentation/media/uapi/dvb/demux.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/demux.rst
rename to Documentation/media/uapi/dvb/demux.rst
diff --git a/Documentation/linux_tv/media/dvb/dmx-add-pid.rst b/Documentation/media/uapi/dvb/dmx-add-pid.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dmx-add-pid.rst
rename to Documentation/media/uapi/dvb/dmx-add-pid.rst
diff --git a/Documentation/linux_tv/media/dvb/dmx-fclose.rst b/Documentation/media/uapi/dvb/dmx-fclose.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dmx-fclose.rst
rename to Documentation/media/uapi/dvb/dmx-fclose.rst
diff --git a/Documentation/linux_tv/media/dvb/dmx-fopen.rst b/Documentation/media/uapi/dvb/dmx-fopen.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dmx-fopen.rst
rename to Documentation/media/uapi/dvb/dmx-fopen.rst
diff --git a/Documentation/linux_tv/media/dvb/dmx-fread.rst b/Documentation/media/uapi/dvb/dmx-fread.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dmx-fread.rst
rename to Documentation/media/uapi/dvb/dmx-fread.rst
diff --git a/Documentation/linux_tv/media/dvb/dmx-fwrite.rst b/Documentation/media/uapi/dvb/dmx-fwrite.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dmx-fwrite.rst
rename to Documentation/media/uapi/dvb/dmx-fwrite.rst
diff --git a/Documentation/linux_tv/media/dvb/dmx-get-caps.rst b/Documentation/media/uapi/dvb/dmx-get-caps.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dmx-get-caps.rst
rename to Documentation/media/uapi/dvb/dmx-get-caps.rst
diff --git a/Documentation/linux_tv/media/dvb/dmx-get-event.rst b/Documentation/media/uapi/dvb/dmx-get-event.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dmx-get-event.rst
rename to Documentation/media/uapi/dvb/dmx-get-event.rst
diff --git a/Documentation/linux_tv/media/dvb/dmx-get-pes-pids.rst b/Documentation/media/uapi/dvb/dmx-get-pes-pids.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dmx-get-pes-pids.rst
rename to Documentation/media/uapi/dvb/dmx-get-pes-pids.rst
diff --git a/Documentation/linux_tv/media/dvb/dmx-get-stc.rst b/Documentation/media/uapi/dvb/dmx-get-stc.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dmx-get-stc.rst
rename to Documentation/media/uapi/dvb/dmx-get-stc.rst
diff --git a/Documentation/linux_tv/media/dvb/dmx-remove-pid.rst b/Documentation/media/uapi/dvb/dmx-remove-pid.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dmx-remove-pid.rst
rename to Documentation/media/uapi/dvb/dmx-remove-pid.rst
diff --git a/Documentation/linux_tv/media/dvb/dmx-set-buffer-size.rst b/Documentation/media/uapi/dvb/dmx-set-buffer-size.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dmx-set-buffer-size.rst
rename to Documentation/media/uapi/dvb/dmx-set-buffer-size.rst
diff --git a/Documentation/linux_tv/media/dvb/dmx-set-filter.rst b/Documentation/media/uapi/dvb/dmx-set-filter.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dmx-set-filter.rst
rename to Documentation/media/uapi/dvb/dmx-set-filter.rst
diff --git a/Documentation/linux_tv/media/dvb/dmx-set-pes-filter.rst b/Documentation/media/uapi/dvb/dmx-set-pes-filter.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dmx-set-pes-filter.rst
rename to Documentation/media/uapi/dvb/dmx-set-pes-filter.rst
diff --git a/Documentation/linux_tv/media/dvb/dmx-set-source.rst b/Documentation/media/uapi/dvb/dmx-set-source.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dmx-set-source.rst
rename to Documentation/media/uapi/dvb/dmx-set-source.rst
diff --git a/Documentation/linux_tv/media/dvb/dmx-start.rst b/Documentation/media/uapi/dvb/dmx-start.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dmx-start.rst
rename to Documentation/media/uapi/dvb/dmx-start.rst
diff --git a/Documentation/linux_tv/media/dvb/dmx-stop.rst b/Documentation/media/uapi/dvb/dmx-stop.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dmx-stop.rst
rename to Documentation/media/uapi/dvb/dmx-stop.rst
diff --git a/Documentation/linux_tv/media/dvb/dmx_fcalls.rst b/Documentation/media/uapi/dvb/dmx_fcalls.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dmx_fcalls.rst
rename to Documentation/media/uapi/dvb/dmx_fcalls.rst
diff --git a/Documentation/linux_tv/media/dvb/dmx_h.rst b/Documentation/media/uapi/dvb/dmx_h.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dmx_h.rst
rename to Documentation/media/uapi/dvb/dmx_h.rst
diff --git a/Documentation/linux_tv/media/dvb/dmx_types.rst b/Documentation/media/uapi/dvb/dmx_types.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dmx_types.rst
rename to Documentation/media/uapi/dvb/dmx_types.rst
diff --git a/Documentation/linux_tv/media/dvb/dtv-fe-stats.rst b/Documentation/media/uapi/dvb/dtv-fe-stats.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dtv-fe-stats.rst
rename to Documentation/media/uapi/dvb/dtv-fe-stats.rst
diff --git a/Documentation/linux_tv/media/dvb/dtv-properties.rst b/Documentation/media/uapi/dvb/dtv-properties.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dtv-properties.rst
rename to Documentation/media/uapi/dvb/dtv-properties.rst
diff --git a/Documentation/linux_tv/media/dvb/dtv-property.rst b/Documentation/media/uapi/dvb/dtv-property.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dtv-property.rst
rename to Documentation/media/uapi/dvb/dtv-property.rst
diff --git a/Documentation/linux_tv/media/dvb/dtv-stats.rst b/Documentation/media/uapi/dvb/dtv-stats.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dtv-stats.rst
rename to Documentation/media/uapi/dvb/dtv-stats.rst
diff --git a/Documentation/linux_tv/media/dvb/dvb-fe-read-status.rst b/Documentation/media/uapi/dvb/dvb-fe-read-status.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dvb-fe-read-status.rst
rename to Documentation/media/uapi/dvb/dvb-fe-read-status.rst
diff --git a/Documentation/linux_tv/media/dvb/dvb-frontend-event.rst b/Documentation/media/uapi/dvb/dvb-frontend-event.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dvb-frontend-event.rst
rename to Documentation/media/uapi/dvb/dvb-frontend-event.rst
diff --git a/Documentation/linux_tv/media/dvb/dvb-frontend-parameters.rst b/Documentation/media/uapi/dvb/dvb-frontend-parameters.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dvb-frontend-parameters.rst
rename to Documentation/media/uapi/dvb/dvb-frontend-parameters.rst
diff --git a/Documentation/linux_tv/media/dvb/dvbapi.rst b/Documentation/media/uapi/dvb/dvbapi.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dvbapi.rst
rename to Documentation/media/uapi/dvb/dvbapi.rst
diff --git a/Documentation/linux_tv/media/dvb/dvbproperty-006.rst b/Documentation/media/uapi/dvb/dvbproperty-006.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dvbproperty-006.rst
rename to Documentation/media/uapi/dvb/dvbproperty-006.rst
diff --git a/Documentation/linux_tv/media/dvb/dvbproperty.rst b/Documentation/media/uapi/dvb/dvbproperty.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/dvbproperty.rst
rename to Documentation/media/uapi/dvb/dvbproperty.rst
diff --git a/Documentation/linux_tv/media/dvb/examples.rst b/Documentation/media/uapi/dvb/examples.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/examples.rst
rename to Documentation/media/uapi/dvb/examples.rst
diff --git a/Documentation/linux_tv/media/dvb/fe-bandwidth-t.rst b/Documentation/media/uapi/dvb/fe-bandwidth-t.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/fe-bandwidth-t.rst
rename to Documentation/media/uapi/dvb/fe-bandwidth-t.rst
diff --git a/Documentation/linux_tv/media/dvb/fe-diseqc-recv-slave-reply.rst b/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/fe-diseqc-recv-slave-reply.rst
rename to Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
diff --git a/Documentation/linux_tv/media/dvb/fe-diseqc-reset-overload.rst b/Documentation/media/uapi/dvb/fe-diseqc-reset-overload.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/fe-diseqc-reset-overload.rst
rename to Documentation/media/uapi/dvb/fe-diseqc-reset-overload.rst
diff --git a/Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst b/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst
rename to Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst
diff --git a/Documentation/linux_tv/media/dvb/fe-diseqc-send-master-cmd.rst b/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/fe-diseqc-send-master-cmd.rst
rename to Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
diff --git a/Documentation/linux_tv/media/dvb/fe-dishnetwork-send-legacy-cmd.rst b/Documentation/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/fe-dishnetwork-send-legacy-cmd.rst
rename to Documentation/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst
diff --git a/Documentation/linux_tv/media/dvb/fe-enable-high-lnb-voltage.rst b/Documentation/media/uapi/dvb/fe-enable-high-lnb-voltage.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/fe-enable-high-lnb-voltage.rst
rename to Documentation/media/uapi/dvb/fe-enable-high-lnb-voltage.rst
diff --git a/Documentation/linux_tv/media/dvb/fe-get-event.rst b/Documentation/media/uapi/dvb/fe-get-event.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/fe-get-event.rst
rename to Documentation/media/uapi/dvb/fe-get-event.rst
diff --git a/Documentation/linux_tv/media/dvb/fe-get-frontend.rst b/Documentation/media/uapi/dvb/fe-get-frontend.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/fe-get-frontend.rst
rename to Documentation/media/uapi/dvb/fe-get-frontend.rst
diff --git a/Documentation/linux_tv/media/dvb/fe-get-info.rst b/Documentation/media/uapi/dvb/fe-get-info.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/fe-get-info.rst
rename to Documentation/media/uapi/dvb/fe-get-info.rst
diff --git a/Documentation/linux_tv/media/dvb/fe-get-property.rst b/Documentation/media/uapi/dvb/fe-get-property.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/fe-get-property.rst
rename to Documentation/media/uapi/dvb/fe-get-property.rst
diff --git a/Documentation/linux_tv/media/dvb/fe-read-ber.rst b/Documentation/media/uapi/dvb/fe-read-ber.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/fe-read-ber.rst
rename to Documentation/media/uapi/dvb/fe-read-ber.rst
diff --git a/Documentation/linux_tv/media/dvb/fe-read-signal-strength.rst b/Documentation/media/uapi/dvb/fe-read-signal-strength.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/fe-read-signal-strength.rst
rename to Documentation/media/uapi/dvb/fe-read-signal-strength.rst
diff --git a/Documentation/linux_tv/media/dvb/fe-read-snr.rst b/Documentation/media/uapi/dvb/fe-read-snr.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/fe-read-snr.rst
rename to Documentation/media/uapi/dvb/fe-read-snr.rst
diff --git a/Documentation/linux_tv/media/dvb/fe-read-status.rst b/Documentation/media/uapi/dvb/fe-read-status.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/fe-read-status.rst
rename to Documentation/media/uapi/dvb/fe-read-status.rst
diff --git a/Documentation/linux_tv/media/dvb/fe-read-uncorrected-blocks.rst b/Documentation/media/uapi/dvb/fe-read-uncorrected-blocks.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/fe-read-uncorrected-blocks.rst
rename to Documentation/media/uapi/dvb/fe-read-uncorrected-blocks.rst
diff --git a/Documentation/linux_tv/media/dvb/fe-set-frontend-tune-mode.rst b/Documentation/media/uapi/dvb/fe-set-frontend-tune-mode.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/fe-set-frontend-tune-mode.rst
rename to Documentation/media/uapi/dvb/fe-set-frontend-tune-mode.rst
diff --git a/Documentation/linux_tv/media/dvb/fe-set-frontend.rst b/Documentation/media/uapi/dvb/fe-set-frontend.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/fe-set-frontend.rst
rename to Documentation/media/uapi/dvb/fe-set-frontend.rst
diff --git a/Documentation/linux_tv/media/dvb/fe-set-tone.rst b/Documentation/media/uapi/dvb/fe-set-tone.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/fe-set-tone.rst
rename to Documentation/media/uapi/dvb/fe-set-tone.rst
diff --git a/Documentation/linux_tv/media/dvb/fe-set-voltage.rst b/Documentation/media/uapi/dvb/fe-set-voltage.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/fe-set-voltage.rst
rename to Documentation/media/uapi/dvb/fe-set-voltage.rst
diff --git a/Documentation/linux_tv/media/dvb/fe-type-t.rst b/Documentation/media/uapi/dvb/fe-type-t.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/fe-type-t.rst
rename to Documentation/media/uapi/dvb/fe-type-t.rst
diff --git a/Documentation/linux_tv/media/dvb/fe_property_parameters.rst b/Documentation/media/uapi/dvb/fe_property_parameters.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/fe_property_parameters.rst
rename to Documentation/media/uapi/dvb/fe_property_parameters.rst
diff --git a/Documentation/linux_tv/media/dvb/frontend-property-cable-systems.rst b/Documentation/media/uapi/dvb/frontend-property-cable-systems.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/frontend-property-cable-systems.rst
rename to Documentation/media/uapi/dvb/frontend-property-cable-systems.rst
diff --git a/Documentation/linux_tv/media/dvb/frontend-property-satellite-systems.rst b/Documentation/media/uapi/dvb/frontend-property-satellite-systems.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/frontend-property-satellite-systems.rst
rename to Documentation/media/uapi/dvb/frontend-property-satellite-systems.rst
diff --git a/Documentation/linux_tv/media/dvb/frontend-property-terrestrial-systems.rst b/Documentation/media/uapi/dvb/frontend-property-terrestrial-systems.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/frontend-property-terrestrial-systems.rst
rename to Documentation/media/uapi/dvb/frontend-property-terrestrial-systems.rst
diff --git a/Documentation/linux_tv/media/dvb/frontend-stat-properties.rst b/Documentation/media/uapi/dvb/frontend-stat-properties.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/frontend-stat-properties.rst
rename to Documentation/media/uapi/dvb/frontend-stat-properties.rst
diff --git a/Documentation/linux_tv/media/dvb/frontend.rst b/Documentation/media/uapi/dvb/frontend.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/frontend.rst
rename to Documentation/media/uapi/dvb/frontend.rst
diff --git a/Documentation/linux_tv/media/dvb/frontend_f_close.rst b/Documentation/media/uapi/dvb/frontend_f_close.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/frontend_f_close.rst
rename to Documentation/media/uapi/dvb/frontend_f_close.rst
diff --git a/Documentation/linux_tv/media/dvb/frontend_f_open.rst b/Documentation/media/uapi/dvb/frontend_f_open.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/frontend_f_open.rst
rename to Documentation/media/uapi/dvb/frontend_f_open.rst
diff --git a/Documentation/linux_tv/media/dvb/frontend_fcalls.rst b/Documentation/media/uapi/dvb/frontend_fcalls.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/frontend_fcalls.rst
rename to Documentation/media/uapi/dvb/frontend_fcalls.rst
diff --git a/Documentation/linux_tv/media/dvb/frontend_h.rst b/Documentation/media/uapi/dvb/frontend_h.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/frontend_h.rst
rename to Documentation/media/uapi/dvb/frontend_h.rst
diff --git a/Documentation/linux_tv/media/dvb/frontend_legacy_api.rst b/Documentation/media/uapi/dvb/frontend_legacy_api.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/frontend_legacy_api.rst
rename to Documentation/media/uapi/dvb/frontend_legacy_api.rst
diff --git a/Documentation/linux_tv/media/dvb/frontend_legacy_dvbv3_api.rst b/Documentation/media/uapi/dvb/frontend_legacy_dvbv3_api.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/frontend_legacy_dvbv3_api.rst
rename to Documentation/media/uapi/dvb/frontend_legacy_dvbv3_api.rst
diff --git a/Documentation/linux_tv/media/dvb/intro.rst b/Documentation/media/uapi/dvb/intro.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/intro.rst
rename to Documentation/media/uapi/dvb/intro.rst
diff --git a/Documentation/linux_tv/media/dvb/intro_files/dvbstb.pdf b/Documentation/media/uapi/dvb/intro_files/dvbstb.pdf
similarity index 100%
rename from Documentation/linux_tv/media/dvb/intro_files/dvbstb.pdf
rename to Documentation/media/uapi/dvb/intro_files/dvbstb.pdf
diff --git a/Documentation/linux_tv/media/dvb/intro_files/dvbstb.png b/Documentation/media/uapi/dvb/intro_files/dvbstb.png
similarity index 100%
rename from Documentation/linux_tv/media/dvb/intro_files/dvbstb.png
rename to Documentation/media/uapi/dvb/intro_files/dvbstb.png
diff --git a/Documentation/linux_tv/media/dvb/legacy_dvb_apis.rst b/Documentation/media/uapi/dvb/legacy_dvb_apis.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/legacy_dvb_apis.rst
rename to Documentation/media/uapi/dvb/legacy_dvb_apis.rst
diff --git a/Documentation/linux_tv/media/dvb/net-add-if.rst b/Documentation/media/uapi/dvb/net-add-if.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/net-add-if.rst
rename to Documentation/media/uapi/dvb/net-add-if.rst
diff --git a/Documentation/linux_tv/media/dvb/net-get-if.rst b/Documentation/media/uapi/dvb/net-get-if.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/net-get-if.rst
rename to Documentation/media/uapi/dvb/net-get-if.rst
diff --git a/Documentation/linux_tv/media/dvb/net-remove-if.rst b/Documentation/media/uapi/dvb/net-remove-if.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/net-remove-if.rst
rename to Documentation/media/uapi/dvb/net-remove-if.rst
diff --git a/Documentation/linux_tv/media/dvb/net.rst b/Documentation/media/uapi/dvb/net.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/net.rst
rename to Documentation/media/uapi/dvb/net.rst
diff --git a/Documentation/linux_tv/media/dvb/net_h.rst b/Documentation/media/uapi/dvb/net_h.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/net_h.rst
rename to Documentation/media/uapi/dvb/net_h.rst
diff --git a/Documentation/linux_tv/media/dvb/query-dvb-frontend-info.rst b/Documentation/media/uapi/dvb/query-dvb-frontend-info.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/query-dvb-frontend-info.rst
rename to Documentation/media/uapi/dvb/query-dvb-frontend-info.rst
diff --git a/Documentation/linux_tv/media/dvb/video-clear-buffer.rst b/Documentation/media/uapi/dvb/video-clear-buffer.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-clear-buffer.rst
rename to Documentation/media/uapi/dvb/video-clear-buffer.rst
diff --git a/Documentation/linux_tv/media/dvb/video-command.rst b/Documentation/media/uapi/dvb/video-command.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-command.rst
rename to Documentation/media/uapi/dvb/video-command.rst
diff --git a/Documentation/linux_tv/media/dvb/video-continue.rst b/Documentation/media/uapi/dvb/video-continue.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-continue.rst
rename to Documentation/media/uapi/dvb/video-continue.rst
diff --git a/Documentation/linux_tv/media/dvb/video-fast-forward.rst b/Documentation/media/uapi/dvb/video-fast-forward.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-fast-forward.rst
rename to Documentation/media/uapi/dvb/video-fast-forward.rst
diff --git a/Documentation/linux_tv/media/dvb/video-fclose.rst b/Documentation/media/uapi/dvb/video-fclose.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-fclose.rst
rename to Documentation/media/uapi/dvb/video-fclose.rst
diff --git a/Documentation/linux_tv/media/dvb/video-fopen.rst b/Documentation/media/uapi/dvb/video-fopen.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-fopen.rst
rename to Documentation/media/uapi/dvb/video-fopen.rst
diff --git a/Documentation/linux_tv/media/dvb/video-freeze.rst b/Documentation/media/uapi/dvb/video-freeze.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-freeze.rst
rename to Documentation/media/uapi/dvb/video-freeze.rst
diff --git a/Documentation/linux_tv/media/dvb/video-fwrite.rst b/Documentation/media/uapi/dvb/video-fwrite.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-fwrite.rst
rename to Documentation/media/uapi/dvb/video-fwrite.rst
diff --git a/Documentation/linux_tv/media/dvb/video-get-capabilities.rst b/Documentation/media/uapi/dvb/video-get-capabilities.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-get-capabilities.rst
rename to Documentation/media/uapi/dvb/video-get-capabilities.rst
diff --git a/Documentation/linux_tv/media/dvb/video-get-event.rst b/Documentation/media/uapi/dvb/video-get-event.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-get-event.rst
rename to Documentation/media/uapi/dvb/video-get-event.rst
diff --git a/Documentation/linux_tv/media/dvb/video-get-frame-count.rst b/Documentation/media/uapi/dvb/video-get-frame-count.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-get-frame-count.rst
rename to Documentation/media/uapi/dvb/video-get-frame-count.rst
diff --git a/Documentation/linux_tv/media/dvb/video-get-frame-rate.rst b/Documentation/media/uapi/dvb/video-get-frame-rate.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-get-frame-rate.rst
rename to Documentation/media/uapi/dvb/video-get-frame-rate.rst
diff --git a/Documentation/linux_tv/media/dvb/video-get-navi.rst b/Documentation/media/uapi/dvb/video-get-navi.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-get-navi.rst
rename to Documentation/media/uapi/dvb/video-get-navi.rst
diff --git a/Documentation/linux_tv/media/dvb/video-get-pts.rst b/Documentation/media/uapi/dvb/video-get-pts.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-get-pts.rst
rename to Documentation/media/uapi/dvb/video-get-pts.rst
diff --git a/Documentation/linux_tv/media/dvb/video-get-size.rst b/Documentation/media/uapi/dvb/video-get-size.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-get-size.rst
rename to Documentation/media/uapi/dvb/video-get-size.rst
diff --git a/Documentation/linux_tv/media/dvb/video-get-status.rst b/Documentation/media/uapi/dvb/video-get-status.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-get-status.rst
rename to Documentation/media/uapi/dvb/video-get-status.rst
diff --git a/Documentation/linux_tv/media/dvb/video-play.rst b/Documentation/media/uapi/dvb/video-play.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-play.rst
rename to Documentation/media/uapi/dvb/video-play.rst
diff --git a/Documentation/linux_tv/media/dvb/video-select-source.rst b/Documentation/media/uapi/dvb/video-select-source.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-select-source.rst
rename to Documentation/media/uapi/dvb/video-select-source.rst
diff --git a/Documentation/linux_tv/media/dvb/video-set-attributes.rst b/Documentation/media/uapi/dvb/video-set-attributes.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-set-attributes.rst
rename to Documentation/media/uapi/dvb/video-set-attributes.rst
diff --git a/Documentation/linux_tv/media/dvb/video-set-blank.rst b/Documentation/media/uapi/dvb/video-set-blank.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-set-blank.rst
rename to Documentation/media/uapi/dvb/video-set-blank.rst
diff --git a/Documentation/linux_tv/media/dvb/video-set-display-format.rst b/Documentation/media/uapi/dvb/video-set-display-format.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-set-display-format.rst
rename to Documentation/media/uapi/dvb/video-set-display-format.rst
diff --git a/Documentation/linux_tv/media/dvb/video-set-format.rst b/Documentation/media/uapi/dvb/video-set-format.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-set-format.rst
rename to Documentation/media/uapi/dvb/video-set-format.rst
diff --git a/Documentation/linux_tv/media/dvb/video-set-highlight.rst b/Documentation/media/uapi/dvb/video-set-highlight.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-set-highlight.rst
rename to Documentation/media/uapi/dvb/video-set-highlight.rst
diff --git a/Documentation/linux_tv/media/dvb/video-set-id.rst b/Documentation/media/uapi/dvb/video-set-id.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-set-id.rst
rename to Documentation/media/uapi/dvb/video-set-id.rst
diff --git a/Documentation/linux_tv/media/dvb/video-set-spu-palette.rst b/Documentation/media/uapi/dvb/video-set-spu-palette.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-set-spu-palette.rst
rename to Documentation/media/uapi/dvb/video-set-spu-palette.rst
diff --git a/Documentation/linux_tv/media/dvb/video-set-spu.rst b/Documentation/media/uapi/dvb/video-set-spu.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-set-spu.rst
rename to Documentation/media/uapi/dvb/video-set-spu.rst
diff --git a/Documentation/linux_tv/media/dvb/video-set-streamtype.rst b/Documentation/media/uapi/dvb/video-set-streamtype.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-set-streamtype.rst
rename to Documentation/media/uapi/dvb/video-set-streamtype.rst
diff --git a/Documentation/linux_tv/media/dvb/video-set-system.rst b/Documentation/media/uapi/dvb/video-set-system.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-set-system.rst
rename to Documentation/media/uapi/dvb/video-set-system.rst
diff --git a/Documentation/linux_tv/media/dvb/video-slowmotion.rst b/Documentation/media/uapi/dvb/video-slowmotion.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-slowmotion.rst
rename to Documentation/media/uapi/dvb/video-slowmotion.rst
diff --git a/Documentation/linux_tv/media/dvb/video-stillpicture.rst b/Documentation/media/uapi/dvb/video-stillpicture.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-stillpicture.rst
rename to Documentation/media/uapi/dvb/video-stillpicture.rst
diff --git a/Documentation/linux_tv/media/dvb/video-stop.rst b/Documentation/media/uapi/dvb/video-stop.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-stop.rst
rename to Documentation/media/uapi/dvb/video-stop.rst
diff --git a/Documentation/linux_tv/media/dvb/video-try-command.rst b/Documentation/media/uapi/dvb/video-try-command.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video-try-command.rst
rename to Documentation/media/uapi/dvb/video-try-command.rst
diff --git a/Documentation/linux_tv/media/dvb/video.rst b/Documentation/media/uapi/dvb/video.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video.rst
rename to Documentation/media/uapi/dvb/video.rst
diff --git a/Documentation/linux_tv/media/dvb/video_function_calls.rst b/Documentation/media/uapi/dvb/video_function_calls.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video_function_calls.rst
rename to Documentation/media/uapi/dvb/video_function_calls.rst
diff --git a/Documentation/linux_tv/media/dvb/video_h.rst b/Documentation/media/uapi/dvb/video_h.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video_h.rst
rename to Documentation/media/uapi/dvb/video_h.rst
diff --git a/Documentation/linux_tv/media/dvb/video_types.rst b/Documentation/media/uapi/dvb/video_types.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/video_types.rst
rename to Documentation/media/uapi/dvb/video_types.rst
diff --git a/Documentation/linux_tv/media/fdl-appendix.rst b/Documentation/media/uapi/fdl-appendix.rst
similarity index 100%
rename from Documentation/linux_tv/media/fdl-appendix.rst
rename to Documentation/media/uapi/fdl-appendix.rst
diff --git a/Documentation/linux_tv/media/gen-errors.rst b/Documentation/media/uapi/gen-errors.rst
similarity index 100%
rename from Documentation/linux_tv/media/gen-errors.rst
rename to Documentation/media/uapi/gen-errors.rst
diff --git a/Documentation/linux_tv/media/mediactl/media-controller-intro.rst b/Documentation/media/uapi/mediactl/media-controller-intro.rst
similarity index 100%
rename from Documentation/linux_tv/media/mediactl/media-controller-intro.rst
rename to Documentation/media/uapi/mediactl/media-controller-intro.rst
diff --git a/Documentation/linux_tv/media/mediactl/media-controller-model.rst b/Documentation/media/uapi/mediactl/media-controller-model.rst
similarity index 100%
rename from Documentation/linux_tv/media/mediactl/media-controller-model.rst
rename to Documentation/media/uapi/mediactl/media-controller-model.rst
diff --git a/Documentation/linux_tv/media/mediactl/media-controller.rst b/Documentation/media/uapi/mediactl/media-controller.rst
similarity index 100%
rename from Documentation/linux_tv/media/mediactl/media-controller.rst
rename to Documentation/media/uapi/mediactl/media-controller.rst
diff --git a/Documentation/linux_tv/media/mediactl/media-func-close.rst b/Documentation/media/uapi/mediactl/media-func-close.rst
similarity index 100%
rename from Documentation/linux_tv/media/mediactl/media-func-close.rst
rename to Documentation/media/uapi/mediactl/media-func-close.rst
diff --git a/Documentation/linux_tv/media/mediactl/media-func-ioctl.rst b/Documentation/media/uapi/mediactl/media-func-ioctl.rst
similarity index 100%
rename from Documentation/linux_tv/media/mediactl/media-func-ioctl.rst
rename to Documentation/media/uapi/mediactl/media-func-ioctl.rst
diff --git a/Documentation/linux_tv/media/mediactl/media-func-open.rst b/Documentation/media/uapi/mediactl/media-func-open.rst
similarity index 100%
rename from Documentation/linux_tv/media/mediactl/media-func-open.rst
rename to Documentation/media/uapi/mediactl/media-func-open.rst
diff --git a/Documentation/linux_tv/media/mediactl/media-ioc-device-info.rst b/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
similarity index 100%
rename from Documentation/linux_tv/media/mediactl/media-ioc-device-info.rst
rename to Documentation/media/uapi/mediactl/media-ioc-device-info.rst
diff --git a/Documentation/linux_tv/media/mediactl/media-ioc-enum-entities.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
similarity index 100%
rename from Documentation/linux_tv/media/mediactl/media-ioc-enum-entities.rst
rename to Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
diff --git a/Documentation/linux_tv/media/mediactl/media-ioc-enum-links.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
similarity index 100%
rename from Documentation/linux_tv/media/mediactl/media-ioc-enum-links.rst
rename to Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
diff --git a/Documentation/linux_tv/media/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
similarity index 100%
rename from Documentation/linux_tv/media/mediactl/media-ioc-g-topology.rst
rename to Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
diff --git a/Documentation/linux_tv/media/mediactl/media-ioc-setup-link.rst b/Documentation/media/uapi/mediactl/media-ioc-setup-link.rst
similarity index 100%
rename from Documentation/linux_tv/media/mediactl/media-ioc-setup-link.rst
rename to Documentation/media/uapi/mediactl/media-ioc-setup-link.rst
diff --git a/Documentation/linux_tv/media/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
similarity index 100%
rename from Documentation/linux_tv/media/mediactl/media-types.rst
rename to Documentation/media/uapi/mediactl/media-types.rst
diff --git a/Documentation/linux_tv/media/rc/Remote_controllers_Intro.rst b/Documentation/media/uapi/rc/Remote_controllers_Intro.rst
similarity index 100%
rename from Documentation/linux_tv/media/rc/Remote_controllers_Intro.rst
rename to Documentation/media/uapi/rc/Remote_controllers_Intro.rst
diff --git a/Documentation/linux_tv/media/rc/Remote_controllers_table_change.rst b/Documentation/media/uapi/rc/Remote_controllers_table_change.rst
similarity index 100%
rename from Documentation/linux_tv/media/rc/Remote_controllers_table_change.rst
rename to Documentation/media/uapi/rc/Remote_controllers_table_change.rst
diff --git a/Documentation/linux_tv/media/rc/Remote_controllers_tables.rst b/Documentation/media/uapi/rc/Remote_controllers_tables.rst
similarity index 100%
rename from Documentation/linux_tv/media/rc/Remote_controllers_tables.rst
rename to Documentation/media/uapi/rc/Remote_controllers_tables.rst
diff --git a/Documentation/linux_tv/media/rc/keytable.c.rst b/Documentation/media/uapi/rc/keytable.c.rst
similarity index 98%
rename from Documentation/linux_tv/media/rc/keytable.c.rst
rename to Documentation/media/uapi/rc/keytable.c.rst
index 5718ffa011d4..e6ce1e3f5a78 100644
--- a/Documentation/linux_tv/media/rc/keytable.c.rst
+++ b/Documentation/media/uapi/rc/keytable.c.rst
@@ -1,7 +1,7 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-file: media/v4l/keytable.c
-==========================
+file: uapi/v4l/keytable.c
+=========================
 
 .. code-block:: c
 
diff --git a/Documentation/linux_tv/media/rc/lirc_dev_intro.rst b/Documentation/media/uapi/rc/lirc_dev_intro.rst
similarity index 100%
rename from Documentation/linux_tv/media/rc/lirc_dev_intro.rst
rename to Documentation/media/uapi/rc/lirc_dev_intro.rst
diff --git a/Documentation/linux_tv/media/rc/lirc_device_interface.rst b/Documentation/media/uapi/rc/lirc_device_interface.rst
similarity index 100%
rename from Documentation/linux_tv/media/rc/lirc_device_interface.rst
rename to Documentation/media/uapi/rc/lirc_device_interface.rst
diff --git a/Documentation/linux_tv/media/rc/lirc_ioctl.rst b/Documentation/media/uapi/rc/lirc_ioctl.rst
similarity index 100%
rename from Documentation/linux_tv/media/rc/lirc_ioctl.rst
rename to Documentation/media/uapi/rc/lirc_ioctl.rst
diff --git a/Documentation/linux_tv/media/rc/lirc_read.rst b/Documentation/media/uapi/rc/lirc_read.rst
similarity index 100%
rename from Documentation/linux_tv/media/rc/lirc_read.rst
rename to Documentation/media/uapi/rc/lirc_read.rst
diff --git a/Documentation/linux_tv/media/rc/lirc_write.rst b/Documentation/media/uapi/rc/lirc_write.rst
similarity index 100%
rename from Documentation/linux_tv/media/rc/lirc_write.rst
rename to Documentation/media/uapi/rc/lirc_write.rst
diff --git a/Documentation/linux_tv/media/rc/remote_controllers.rst b/Documentation/media/uapi/rc/remote_controllers.rst
similarity index 100%
rename from Documentation/linux_tv/media/rc/remote_controllers.rst
rename to Documentation/media/uapi/rc/remote_controllers.rst
diff --git a/Documentation/linux_tv/media/rc/remote_controllers_sysfs_nodes.rst b/Documentation/media/uapi/rc/remote_controllers_sysfs_nodes.rst
similarity index 100%
rename from Documentation/linux_tv/media/rc/remote_controllers_sysfs_nodes.rst
rename to Documentation/media/uapi/rc/remote_controllers_sysfs_nodes.rst
diff --git a/Documentation/linux_tv/media/v4l/app-pri.rst b/Documentation/media/uapi/v4l/app-pri.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/app-pri.rst
rename to Documentation/media/uapi/v4l/app-pri.rst
diff --git a/Documentation/linux_tv/media/v4l/async.rst b/Documentation/media/uapi/v4l/async.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/async.rst
rename to Documentation/media/uapi/v4l/async.rst
diff --git a/Documentation/linux_tv/media/v4l/audio.rst b/Documentation/media/uapi/v4l/audio.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/audio.rst
rename to Documentation/media/uapi/v4l/audio.rst
diff --git a/Documentation/linux_tv/media/v4l/biblio.rst b/Documentation/media/uapi/v4l/biblio.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/biblio.rst
rename to Documentation/media/uapi/v4l/biblio.rst
diff --git a/Documentation/linux_tv/media/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/buffer.rst
rename to Documentation/media/uapi/v4l/buffer.rst
diff --git a/Documentation/linux_tv/media/v4l/capture-example.rst b/Documentation/media/uapi/v4l/capture-example.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/capture-example.rst
rename to Documentation/media/uapi/v4l/capture-example.rst
diff --git a/Documentation/linux_tv/media/v4l/capture.c.rst b/Documentation/media/uapi/v4l/capture.c.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/capture.c.rst
rename to Documentation/media/uapi/v4l/capture.c.rst
diff --git a/Documentation/linux_tv/media/v4l/colorspaces.rst b/Documentation/media/uapi/v4l/colorspaces.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/colorspaces.rst
rename to Documentation/media/uapi/v4l/colorspaces.rst
diff --git a/Documentation/linux_tv/media/v4l/common-defs.rst b/Documentation/media/uapi/v4l/common-defs.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/common-defs.rst
rename to Documentation/media/uapi/v4l/common-defs.rst
diff --git a/Documentation/linux_tv/media/v4l/common.rst b/Documentation/media/uapi/v4l/common.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/common.rst
rename to Documentation/media/uapi/v4l/common.rst
diff --git a/Documentation/linux_tv/media/v4l/compat.rst b/Documentation/media/uapi/v4l/compat.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/compat.rst
rename to Documentation/media/uapi/v4l/compat.rst
diff --git a/Documentation/linux_tv/media/v4l/control.rst b/Documentation/media/uapi/v4l/control.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/control.rst
rename to Documentation/media/uapi/v4l/control.rst
diff --git a/Documentation/linux_tv/media/v4l/crop.rst b/Documentation/media/uapi/v4l/crop.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/crop.rst
rename to Documentation/media/uapi/v4l/crop.rst
diff --git a/Documentation/linux_tv/media/v4l/crop_files/crop.gif b/Documentation/media/uapi/v4l/crop_files/crop.gif
similarity index 100%
rename from Documentation/linux_tv/media/v4l/crop_files/crop.gif
rename to Documentation/media/uapi/v4l/crop_files/crop.gif
diff --git a/Documentation/linux_tv/media/v4l/crop_files/crop.pdf b/Documentation/media/uapi/v4l/crop_files/crop.pdf
similarity index 100%
rename from Documentation/linux_tv/media/v4l/crop_files/crop.pdf
rename to Documentation/media/uapi/v4l/crop_files/crop.pdf
diff --git a/Documentation/linux_tv/media/v4l/depth-formats.rst b/Documentation/media/uapi/v4l/depth-formats.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/depth-formats.rst
rename to Documentation/media/uapi/v4l/depth-formats.rst
diff --git a/Documentation/linux_tv/media/v4l/dev-capture.rst b/Documentation/media/uapi/v4l/dev-capture.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dev-capture.rst
rename to Documentation/media/uapi/v4l/dev-capture.rst
diff --git a/Documentation/linux_tv/media/v4l/dev-codec.rst b/Documentation/media/uapi/v4l/dev-codec.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dev-codec.rst
rename to Documentation/media/uapi/v4l/dev-codec.rst
diff --git a/Documentation/linux_tv/media/v4l/dev-effect.rst b/Documentation/media/uapi/v4l/dev-effect.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dev-effect.rst
rename to Documentation/media/uapi/v4l/dev-effect.rst
diff --git a/Documentation/linux_tv/media/v4l/dev-event.rst b/Documentation/media/uapi/v4l/dev-event.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dev-event.rst
rename to Documentation/media/uapi/v4l/dev-event.rst
diff --git a/Documentation/linux_tv/media/v4l/dev-osd.rst b/Documentation/media/uapi/v4l/dev-osd.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dev-osd.rst
rename to Documentation/media/uapi/v4l/dev-osd.rst
diff --git a/Documentation/linux_tv/media/v4l/dev-output.rst b/Documentation/media/uapi/v4l/dev-output.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dev-output.rst
rename to Documentation/media/uapi/v4l/dev-output.rst
diff --git a/Documentation/linux_tv/media/v4l/dev-overlay.rst b/Documentation/media/uapi/v4l/dev-overlay.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dev-overlay.rst
rename to Documentation/media/uapi/v4l/dev-overlay.rst
diff --git a/Documentation/linux_tv/media/v4l/dev-radio.rst b/Documentation/media/uapi/v4l/dev-radio.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dev-radio.rst
rename to Documentation/media/uapi/v4l/dev-radio.rst
diff --git a/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst b/Documentation/media/uapi/v4l/dev-raw-vbi.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dev-raw-vbi.rst
rename to Documentation/media/uapi/v4l/dev-raw-vbi.rst
diff --git a/Documentation/linux_tv/media/v4l/dev-raw-vbi_files/vbi_525.gif b/Documentation/media/uapi/v4l/dev-raw-vbi_files/vbi_525.gif
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dev-raw-vbi_files/vbi_525.gif
rename to Documentation/media/uapi/v4l/dev-raw-vbi_files/vbi_525.gif
diff --git a/Documentation/linux_tv/media/v4l/dev-raw-vbi_files/vbi_525.pdf b/Documentation/media/uapi/v4l/dev-raw-vbi_files/vbi_525.pdf
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dev-raw-vbi_files/vbi_525.pdf
rename to Documentation/media/uapi/v4l/dev-raw-vbi_files/vbi_525.pdf
diff --git a/Documentation/linux_tv/media/v4l/dev-raw-vbi_files/vbi_625.gif b/Documentation/media/uapi/v4l/dev-raw-vbi_files/vbi_625.gif
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dev-raw-vbi_files/vbi_625.gif
rename to Documentation/media/uapi/v4l/dev-raw-vbi_files/vbi_625.gif
diff --git a/Documentation/linux_tv/media/v4l/dev-raw-vbi_files/vbi_625.pdf b/Documentation/media/uapi/v4l/dev-raw-vbi_files/vbi_625.pdf
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dev-raw-vbi_files/vbi_625.pdf
rename to Documentation/media/uapi/v4l/dev-raw-vbi_files/vbi_625.pdf
diff --git a/Documentation/linux_tv/media/v4l/dev-raw-vbi_files/vbi_hsync.gif b/Documentation/media/uapi/v4l/dev-raw-vbi_files/vbi_hsync.gif
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dev-raw-vbi_files/vbi_hsync.gif
rename to Documentation/media/uapi/v4l/dev-raw-vbi_files/vbi_hsync.gif
diff --git a/Documentation/linux_tv/media/v4l/dev-raw-vbi_files/vbi_hsync.pdf b/Documentation/media/uapi/v4l/dev-raw-vbi_files/vbi_hsync.pdf
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dev-raw-vbi_files/vbi_hsync.pdf
rename to Documentation/media/uapi/v4l/dev-raw-vbi_files/vbi_hsync.pdf
diff --git a/Documentation/linux_tv/media/v4l/dev-rds.rst b/Documentation/media/uapi/v4l/dev-rds.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dev-rds.rst
rename to Documentation/media/uapi/v4l/dev-rds.rst
diff --git a/Documentation/linux_tv/media/v4l/dev-sdr.rst b/Documentation/media/uapi/v4l/dev-sdr.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dev-sdr.rst
rename to Documentation/media/uapi/v4l/dev-sdr.rst
diff --git a/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst b/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst
rename to Documentation/media/uapi/v4l/dev-sliced-vbi.rst
diff --git a/Documentation/linux_tv/media/v4l/dev-subdev.rst b/Documentation/media/uapi/v4l/dev-subdev.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dev-subdev.rst
rename to Documentation/media/uapi/v4l/dev-subdev.rst
diff --git a/Documentation/linux_tv/media/v4l/dev-subdev_files/pipeline.pdf b/Documentation/media/uapi/v4l/dev-subdev_files/pipeline.pdf
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dev-subdev_files/pipeline.pdf
rename to Documentation/media/uapi/v4l/dev-subdev_files/pipeline.pdf
diff --git a/Documentation/linux_tv/media/v4l/dev-subdev_files/pipeline.png b/Documentation/media/uapi/v4l/dev-subdev_files/pipeline.png
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dev-subdev_files/pipeline.png
rename to Documentation/media/uapi/v4l/dev-subdev_files/pipeline.png
diff --git a/Documentation/linux_tv/media/v4l/dev-subdev_files/subdev-image-processing-crop.pdf b/Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-crop.pdf
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dev-subdev_files/subdev-image-processing-crop.pdf
rename to Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-crop.pdf
diff --git a/Documentation/linux_tv/media/v4l/dev-subdev_files/subdev-image-processing-crop.svg b/Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-crop.svg
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dev-subdev_files/subdev-image-processing-crop.svg
rename to Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-crop.svg
diff --git a/Documentation/linux_tv/media/v4l/dev-subdev_files/subdev-image-processing-full.pdf b/Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-full.pdf
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dev-subdev_files/subdev-image-processing-full.pdf
rename to Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-full.pdf
diff --git a/Documentation/linux_tv/media/v4l/dev-subdev_files/subdev-image-processing-full.svg b/Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-full.svg
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dev-subdev_files/subdev-image-processing-full.svg
rename to Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-full.svg
diff --git a/Documentation/linux_tv/media/v4l/dev-subdev_files/subdev-image-processing-scaling-multi-source.pdf b/Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-scaling-multi-source.pdf
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dev-subdev_files/subdev-image-processing-scaling-multi-source.pdf
rename to Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-scaling-multi-source.pdf
diff --git a/Documentation/linux_tv/media/v4l/dev-subdev_files/subdev-image-processing-scaling-multi-source.svg b/Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-scaling-multi-source.svg
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dev-subdev_files/subdev-image-processing-scaling-multi-source.svg
rename to Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-scaling-multi-source.svg
diff --git a/Documentation/linux_tv/media/v4l/dev-teletext.rst b/Documentation/media/uapi/v4l/dev-teletext.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dev-teletext.rst
rename to Documentation/media/uapi/v4l/dev-teletext.rst
diff --git a/Documentation/linux_tv/media/v4l/devices.rst b/Documentation/media/uapi/v4l/devices.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/devices.rst
rename to Documentation/media/uapi/v4l/devices.rst
diff --git a/Documentation/linux_tv/media/v4l/diff-v4l.rst b/Documentation/media/uapi/v4l/diff-v4l.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/diff-v4l.rst
rename to Documentation/media/uapi/v4l/diff-v4l.rst
diff --git a/Documentation/linux_tv/media/v4l/dmabuf.rst b/Documentation/media/uapi/v4l/dmabuf.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dmabuf.rst
rename to Documentation/media/uapi/v4l/dmabuf.rst
diff --git a/Documentation/linux_tv/media/v4l/driver.rst b/Documentation/media/uapi/v4l/driver.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/driver.rst
rename to Documentation/media/uapi/v4l/driver.rst
diff --git a/Documentation/linux_tv/media/v4l/dv-timings.rst b/Documentation/media/uapi/v4l/dv-timings.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/dv-timings.rst
rename to Documentation/media/uapi/v4l/dv-timings.rst
diff --git a/Documentation/linux_tv/media/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/extended-controls.rst
rename to Documentation/media/uapi/v4l/extended-controls.rst
diff --git a/Documentation/linux_tv/media/v4l/field-order.rst b/Documentation/media/uapi/v4l/field-order.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/field-order.rst
rename to Documentation/media/uapi/v4l/field-order.rst
diff --git a/Documentation/linux_tv/media/v4l/field-order_files/fieldseq_bt.gif b/Documentation/media/uapi/v4l/field-order_files/fieldseq_bt.gif
similarity index 100%
rename from Documentation/linux_tv/media/v4l/field-order_files/fieldseq_bt.gif
rename to Documentation/media/uapi/v4l/field-order_files/fieldseq_bt.gif
diff --git a/Documentation/linux_tv/media/v4l/field-order_files/fieldseq_bt.pdf b/Documentation/media/uapi/v4l/field-order_files/fieldseq_bt.pdf
similarity index 100%
rename from Documentation/linux_tv/media/v4l/field-order_files/fieldseq_bt.pdf
rename to Documentation/media/uapi/v4l/field-order_files/fieldseq_bt.pdf
diff --git a/Documentation/linux_tv/media/v4l/field-order_files/fieldseq_tb.gif b/Documentation/media/uapi/v4l/field-order_files/fieldseq_tb.gif
similarity index 100%
rename from Documentation/linux_tv/media/v4l/field-order_files/fieldseq_tb.gif
rename to Documentation/media/uapi/v4l/field-order_files/fieldseq_tb.gif
diff --git a/Documentation/linux_tv/media/v4l/field-order_files/fieldseq_tb.pdf b/Documentation/media/uapi/v4l/field-order_files/fieldseq_tb.pdf
similarity index 100%
rename from Documentation/linux_tv/media/v4l/field-order_files/fieldseq_tb.pdf
rename to Documentation/media/uapi/v4l/field-order_files/fieldseq_tb.pdf
diff --git a/Documentation/linux_tv/media/v4l/format.rst b/Documentation/media/uapi/v4l/format.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/format.rst
rename to Documentation/media/uapi/v4l/format.rst
diff --git a/Documentation/linux_tv/media/v4l/func-close.rst b/Documentation/media/uapi/v4l/func-close.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/func-close.rst
rename to Documentation/media/uapi/v4l/func-close.rst
diff --git a/Documentation/linux_tv/media/v4l/func-ioctl.rst b/Documentation/media/uapi/v4l/func-ioctl.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/func-ioctl.rst
rename to Documentation/media/uapi/v4l/func-ioctl.rst
diff --git a/Documentation/linux_tv/media/v4l/func-mmap.rst b/Documentation/media/uapi/v4l/func-mmap.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/func-mmap.rst
rename to Documentation/media/uapi/v4l/func-mmap.rst
diff --git a/Documentation/linux_tv/media/v4l/func-munmap.rst b/Documentation/media/uapi/v4l/func-munmap.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/func-munmap.rst
rename to Documentation/media/uapi/v4l/func-munmap.rst
diff --git a/Documentation/linux_tv/media/v4l/func-open.rst b/Documentation/media/uapi/v4l/func-open.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/func-open.rst
rename to Documentation/media/uapi/v4l/func-open.rst
diff --git a/Documentation/linux_tv/media/v4l/func-poll.rst b/Documentation/media/uapi/v4l/func-poll.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/func-poll.rst
rename to Documentation/media/uapi/v4l/func-poll.rst
diff --git a/Documentation/linux_tv/media/v4l/func-read.rst b/Documentation/media/uapi/v4l/func-read.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/func-read.rst
rename to Documentation/media/uapi/v4l/func-read.rst
diff --git a/Documentation/linux_tv/media/v4l/func-select.rst b/Documentation/media/uapi/v4l/func-select.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/func-select.rst
rename to Documentation/media/uapi/v4l/func-select.rst
diff --git a/Documentation/linux_tv/media/v4l/func-write.rst b/Documentation/media/uapi/v4l/func-write.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/func-write.rst
rename to Documentation/media/uapi/v4l/func-write.rst
diff --git a/Documentation/linux_tv/media/v4l/hist-v4l2.rst b/Documentation/media/uapi/v4l/hist-v4l2.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/hist-v4l2.rst
rename to Documentation/media/uapi/v4l/hist-v4l2.rst
diff --git a/Documentation/linux_tv/media/v4l/io.rst b/Documentation/media/uapi/v4l/io.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/io.rst
rename to Documentation/media/uapi/v4l/io.rst
diff --git a/Documentation/linux_tv/media/v4l/libv4l-introduction.rst b/Documentation/media/uapi/v4l/libv4l-introduction.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/libv4l-introduction.rst
rename to Documentation/media/uapi/v4l/libv4l-introduction.rst
diff --git a/Documentation/linux_tv/media/v4l/libv4l.rst b/Documentation/media/uapi/v4l/libv4l.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/libv4l.rst
rename to Documentation/media/uapi/v4l/libv4l.rst
diff --git a/Documentation/linux_tv/media/v4l/mmap.rst b/Documentation/media/uapi/v4l/mmap.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/mmap.rst
rename to Documentation/media/uapi/v4l/mmap.rst
diff --git a/Documentation/linux_tv/media/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/open.rst
rename to Documentation/media/uapi/v4l/open.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-002.rst b/Documentation/media/uapi/v4l/pixfmt-002.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-002.rst
rename to Documentation/media/uapi/v4l/pixfmt-002.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-003.rst b/Documentation/media/uapi/v4l/pixfmt-003.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-003.rst
rename to Documentation/media/uapi/v4l/pixfmt-003.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-004.rst b/Documentation/media/uapi/v4l/pixfmt-004.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-004.rst
rename to Documentation/media/uapi/v4l/pixfmt-004.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-006.rst b/Documentation/media/uapi/v4l/pixfmt-006.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-006.rst
rename to Documentation/media/uapi/v4l/pixfmt-006.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-007.rst b/Documentation/media/uapi/v4l/pixfmt-007.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-007.rst
rename to Documentation/media/uapi/v4l/pixfmt-007.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-008.rst b/Documentation/media/uapi/v4l/pixfmt-008.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-008.rst
rename to Documentation/media/uapi/v4l/pixfmt-008.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-013.rst b/Documentation/media/uapi/v4l/pixfmt-013.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-013.rst
rename to Documentation/media/uapi/v4l/pixfmt-013.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-grey.rst b/Documentation/media/uapi/v4l/pixfmt-grey.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-grey.rst
rename to Documentation/media/uapi/v4l/pixfmt-grey.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-indexed.rst b/Documentation/media/uapi/v4l/pixfmt-indexed.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-indexed.rst
rename to Documentation/media/uapi/v4l/pixfmt-indexed.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-m420.rst b/Documentation/media/uapi/v4l/pixfmt-m420.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-m420.rst
rename to Documentation/media/uapi/v4l/pixfmt-m420.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv12.rst b/Documentation/media/uapi/v4l/pixfmt-nv12.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-nv12.rst
rename to Documentation/media/uapi/v4l/pixfmt-nv12.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst b/Documentation/media/uapi/v4l/pixfmt-nv12m.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst
rename to Documentation/media/uapi/v4l/pixfmt-nv12m.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv12mt.rst b/Documentation/media/uapi/v4l/pixfmt-nv12mt.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-nv12mt.rst
rename to Documentation/media/uapi/v4l/pixfmt-nv12mt.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv12mt_files/nv12mt.gif b/Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt.gif
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-nv12mt_files/nv12mt.gif
rename to Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt.gif
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv12mt_files/nv12mt_example.gif b/Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt_example.gif
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-nv12mt_files/nv12mt_example.gif
rename to Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt_example.gif
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv16.rst b/Documentation/media/uapi/v4l/pixfmt-nv16.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-nv16.rst
rename to Documentation/media/uapi/v4l/pixfmt-nv16.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst b/Documentation/media/uapi/v4l/pixfmt-nv16m.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst
rename to Documentation/media/uapi/v4l/pixfmt-nv16m.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv24.rst b/Documentation/media/uapi/v4l/pixfmt-nv24.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-nv24.rst
rename to Documentation/media/uapi/v4l/pixfmt-nv24.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-packed-rgb.rst b/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-packed-rgb.rst
rename to Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-packed-yuv.rst b/Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-packed-yuv.rst
rename to Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-reserved.rst b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-reserved.rst
rename to Documentation/media/uapi/v4l/pixfmt-reserved.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-rgb.rst b/Documentation/media/uapi/v4l/pixfmt-rgb.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-rgb.rst
rename to Documentation/media/uapi/v4l/pixfmt-rgb.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sbggr16.rst b/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-sbggr16.rst
rename to Documentation/media/uapi/v4l/pixfmt-sbggr16.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sbggr8.rst b/Documentation/media/uapi/v4l/pixfmt-sbggr8.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-sbggr8.rst
rename to Documentation/media/uapi/v4l/pixfmt-sbggr8.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sdr-cs08.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-cs08.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-sdr-cs08.rst
rename to Documentation/media/uapi/v4l/pixfmt-sdr-cs08.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sdr-cs14le.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-cs14le.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-sdr-cs14le.rst
rename to Documentation/media/uapi/v4l/pixfmt-sdr-cs14le.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sdr-cu08.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-cu08.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-sdr-cu08.rst
rename to Documentation/media/uapi/v4l/pixfmt-sdr-cu08.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sdr-cu16le.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-cu16le.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-sdr-cu16le.rst
rename to Documentation/media/uapi/v4l/pixfmt-sdr-cu16le.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sdr-ru12le.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-ru12le.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-sdr-ru12le.rst
rename to Documentation/media/uapi/v4l/pixfmt-sdr-ru12le.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sgbrg8.rst b/Documentation/media/uapi/v4l/pixfmt-sgbrg8.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-sgbrg8.rst
rename to Documentation/media/uapi/v4l/pixfmt-sgbrg8.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sgrbg8.rst b/Documentation/media/uapi/v4l/pixfmt-sgrbg8.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-sgrbg8.rst
rename to Documentation/media/uapi/v4l/pixfmt-sgrbg8.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-srggb10.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-srggb10.rst
rename to Documentation/media/uapi/v4l/pixfmt-srggb10.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-srggb10alaw8.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10alaw8.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-srggb10alaw8.rst
rename to Documentation/media/uapi/v4l/pixfmt-srggb10alaw8.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-srggb10dpcm8.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10dpcm8.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-srggb10dpcm8.rst
rename to Documentation/media/uapi/v4l/pixfmt-srggb10dpcm8.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-srggb10p.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-srggb10p.rst
rename to Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-srggb12.rst b/Documentation/media/uapi/v4l/pixfmt-srggb12.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-srggb12.rst
rename to Documentation/media/uapi/v4l/pixfmt-srggb12.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-srggb8.rst b/Documentation/media/uapi/v4l/pixfmt-srggb8.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-srggb8.rst
rename to Documentation/media/uapi/v4l/pixfmt-srggb8.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-uv8.rst b/Documentation/media/uapi/v4l/pixfmt-uv8.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-uv8.rst
rename to Documentation/media/uapi/v4l/pixfmt-uv8.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-uyvy.rst b/Documentation/media/uapi/v4l/pixfmt-uyvy.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-uyvy.rst
rename to Documentation/media/uapi/v4l/pixfmt-uyvy.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-vyuy.rst b/Documentation/media/uapi/v4l/pixfmt-vyuy.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-vyuy.rst
rename to Documentation/media/uapi/v4l/pixfmt-vyuy.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-y10.rst b/Documentation/media/uapi/v4l/pixfmt-y10.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-y10.rst
rename to Documentation/media/uapi/v4l/pixfmt-y10.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-y10b.rst b/Documentation/media/uapi/v4l/pixfmt-y10b.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-y10b.rst
rename to Documentation/media/uapi/v4l/pixfmt-y10b.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-y12.rst b/Documentation/media/uapi/v4l/pixfmt-y12.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-y12.rst
rename to Documentation/media/uapi/v4l/pixfmt-y12.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-y12i.rst b/Documentation/media/uapi/v4l/pixfmt-y12i.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-y12i.rst
rename to Documentation/media/uapi/v4l/pixfmt-y12i.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-y16-be.rst b/Documentation/media/uapi/v4l/pixfmt-y16-be.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-y16-be.rst
rename to Documentation/media/uapi/v4l/pixfmt-y16-be.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-y16.rst b/Documentation/media/uapi/v4l/pixfmt-y16.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-y16.rst
rename to Documentation/media/uapi/v4l/pixfmt-y16.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-y41p.rst b/Documentation/media/uapi/v4l/pixfmt-y41p.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-y41p.rst
rename to Documentation/media/uapi/v4l/pixfmt-y41p.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-y8i.rst b/Documentation/media/uapi/v4l/pixfmt-y8i.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-y8i.rst
rename to Documentation/media/uapi/v4l/pixfmt-y8i.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv410.rst b/Documentation/media/uapi/v4l/pixfmt-yuv410.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-yuv410.rst
rename to Documentation/media/uapi/v4l/pixfmt-yuv410.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv411p.rst b/Documentation/media/uapi/v4l/pixfmt-yuv411p.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-yuv411p.rst
rename to Documentation/media/uapi/v4l/pixfmt-yuv411p.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv420.rst b/Documentation/media/uapi/v4l/pixfmt-yuv420.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-yuv420.rst
rename to Documentation/media/uapi/v4l/pixfmt-yuv420.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv420m.rst b/Documentation/media/uapi/v4l/pixfmt-yuv420m.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-yuv420m.rst
rename to Documentation/media/uapi/v4l/pixfmt-yuv420m.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv422m.rst b/Documentation/media/uapi/v4l/pixfmt-yuv422m.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-yuv422m.rst
rename to Documentation/media/uapi/v4l/pixfmt-yuv422m.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv422p.rst b/Documentation/media/uapi/v4l/pixfmt-yuv422p.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-yuv422p.rst
rename to Documentation/media/uapi/v4l/pixfmt-yuv422p.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv444m.rst b/Documentation/media/uapi/v4l/pixfmt-yuv444m.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-yuv444m.rst
rename to Documentation/media/uapi/v4l/pixfmt-yuv444m.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuyv.rst b/Documentation/media/uapi/v4l/pixfmt-yuyv.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-yuyv.rst
rename to Documentation/media/uapi/v4l/pixfmt-yuyv.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yvyu.rst b/Documentation/media/uapi/v4l/pixfmt-yvyu.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-yvyu.rst
rename to Documentation/media/uapi/v4l/pixfmt-yvyu.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-z16.rst b/Documentation/media/uapi/v4l/pixfmt-z16.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt-z16.rst
rename to Documentation/media/uapi/v4l/pixfmt-z16.rst
diff --git a/Documentation/linux_tv/media/v4l/pixfmt.rst b/Documentation/media/uapi/v4l/pixfmt.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/pixfmt.rst
rename to Documentation/media/uapi/v4l/pixfmt.rst
diff --git a/Documentation/linux_tv/media/v4l/planar-apis.rst b/Documentation/media/uapi/v4l/planar-apis.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/planar-apis.rst
rename to Documentation/media/uapi/v4l/planar-apis.rst
diff --git a/Documentation/linux_tv/media/v4l/querycap.rst b/Documentation/media/uapi/v4l/querycap.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/querycap.rst
rename to Documentation/media/uapi/v4l/querycap.rst
diff --git a/Documentation/linux_tv/media/v4l/rw.rst b/Documentation/media/uapi/v4l/rw.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/rw.rst
rename to Documentation/media/uapi/v4l/rw.rst
diff --git a/Documentation/linux_tv/media/v4l/sdr-formats.rst b/Documentation/media/uapi/v4l/sdr-formats.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/sdr-formats.rst
rename to Documentation/media/uapi/v4l/sdr-formats.rst
diff --git a/Documentation/linux_tv/media/v4l/selection-api-002.rst b/Documentation/media/uapi/v4l/selection-api-002.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/selection-api-002.rst
rename to Documentation/media/uapi/v4l/selection-api-002.rst
diff --git a/Documentation/linux_tv/media/v4l/selection-api-003.rst b/Documentation/media/uapi/v4l/selection-api-003.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/selection-api-003.rst
rename to Documentation/media/uapi/v4l/selection-api-003.rst
diff --git a/Documentation/linux_tv/media/v4l/selection-api-003_files/selection.png b/Documentation/media/uapi/v4l/selection-api-003_files/selection.png
similarity index 100%
rename from Documentation/linux_tv/media/v4l/selection-api-003_files/selection.png
rename to Documentation/media/uapi/v4l/selection-api-003_files/selection.png
diff --git a/Documentation/linux_tv/media/v4l/selection-api-004.rst b/Documentation/media/uapi/v4l/selection-api-004.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/selection-api-004.rst
rename to Documentation/media/uapi/v4l/selection-api-004.rst
diff --git a/Documentation/linux_tv/media/v4l/selection-api-005.rst b/Documentation/media/uapi/v4l/selection-api-005.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/selection-api-005.rst
rename to Documentation/media/uapi/v4l/selection-api-005.rst
diff --git a/Documentation/linux_tv/media/v4l/selection-api-006.rst b/Documentation/media/uapi/v4l/selection-api-006.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/selection-api-006.rst
rename to Documentation/media/uapi/v4l/selection-api-006.rst
diff --git a/Documentation/linux_tv/media/v4l/selection-api.rst b/Documentation/media/uapi/v4l/selection-api.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/selection-api.rst
rename to Documentation/media/uapi/v4l/selection-api.rst
diff --git a/Documentation/linux_tv/media/v4l/selections-common.rst b/Documentation/media/uapi/v4l/selections-common.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/selections-common.rst
rename to Documentation/media/uapi/v4l/selections-common.rst
diff --git a/Documentation/linux_tv/media/v4l/standard.rst b/Documentation/media/uapi/v4l/standard.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/standard.rst
rename to Documentation/media/uapi/v4l/standard.rst
diff --git a/Documentation/linux_tv/media/v4l/streaming-par.rst b/Documentation/media/uapi/v4l/streaming-par.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/streaming-par.rst
rename to Documentation/media/uapi/v4l/streaming-par.rst
diff --git a/Documentation/linux_tv/media/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/subdev-formats.rst
rename to Documentation/media/uapi/v4l/subdev-formats.rst
diff --git a/Documentation/linux_tv/media/v4l/subdev-formats_files/bayer.png b/Documentation/media/uapi/v4l/subdev-formats_files/bayer.png
similarity index 100%
rename from Documentation/linux_tv/media/v4l/subdev-formats_files/bayer.png
rename to Documentation/media/uapi/v4l/subdev-formats_files/bayer.png
diff --git a/Documentation/linux_tv/media/v4l/tuner.rst b/Documentation/media/uapi/v4l/tuner.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/tuner.rst
rename to Documentation/media/uapi/v4l/tuner.rst
diff --git a/Documentation/linux_tv/media/v4l/user-func.rst b/Documentation/media/uapi/v4l/user-func.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/user-func.rst
rename to Documentation/media/uapi/v4l/user-func.rst
diff --git a/Documentation/linux_tv/media/v4l/userp.rst b/Documentation/media/uapi/v4l/userp.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/userp.rst
rename to Documentation/media/uapi/v4l/userp.rst
diff --git a/Documentation/linux_tv/media/v4l/v4l2-selection-flags.rst b/Documentation/media/uapi/v4l/v4l2-selection-flags.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/v4l2-selection-flags.rst
rename to Documentation/media/uapi/v4l/v4l2-selection-flags.rst
diff --git a/Documentation/linux_tv/media/v4l/v4l2-selection-targets.rst b/Documentation/media/uapi/v4l/v4l2-selection-targets.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/v4l2-selection-targets.rst
rename to Documentation/media/uapi/v4l/v4l2-selection-targets.rst
diff --git a/Documentation/linux_tv/media/v4l/v4l2.rst b/Documentation/media/uapi/v4l/v4l2.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/v4l2.rst
rename to Documentation/media/uapi/v4l/v4l2.rst
diff --git a/Documentation/linux_tv/media/v4l/v4l2grab-example.rst b/Documentation/media/uapi/v4l/v4l2grab-example.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/v4l2grab-example.rst
rename to Documentation/media/uapi/v4l/v4l2grab-example.rst
diff --git a/Documentation/linux_tv/media/v4l/v4l2grab.c.rst b/Documentation/media/uapi/v4l/v4l2grab.c.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/v4l2grab.c.rst
rename to Documentation/media/uapi/v4l/v4l2grab.c.rst
diff --git a/Documentation/linux_tv/media/v4l/video.rst b/Documentation/media/uapi/v4l/video.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/video.rst
rename to Documentation/media/uapi/v4l/video.rst
diff --git a/Documentation/linux_tv/media/v4l/videodev.rst b/Documentation/media/uapi/v4l/videodev.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/videodev.rst
rename to Documentation/media/uapi/v4l/videodev.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst b/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
rename to Documentation/media/uapi/v4l/vidioc-create-bufs.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-cropcap.rst b/Documentation/media/uapi/v4l/vidioc-cropcap.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-cropcap.rst
rename to Documentation/media/uapi/v4l/vidioc-cropcap.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst b/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst
rename to Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst b/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst
rename to Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst b/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst
rename to Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dqevent.rst b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-dqevent.rst
rename to Documentation/media/uapi/v4l/vidioc-dqevent.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst b/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst
rename to Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst b/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst
rename to Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst
rename to Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst
rename to Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst b/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst
rename to Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst b/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst
rename to Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst b/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst
rename to Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst b/Documentation/media/uapi/v4l/vidioc-enumaudio.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst
rename to Documentation/media/uapi/v4l/vidioc-enumaudio.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst b/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst
rename to Documentation/media/uapi/v4l/vidioc-enumaudioout.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-enuminput.rst
rename to Documentation/media/uapi/v4l/vidioc-enuminput.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst b/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst
rename to Documentation/media/uapi/v4l/vidioc-enumoutput.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
rename to Documentation/media/uapi/v4l/vidioc-enumstd.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst b/Documentation/media/uapi/v4l/vidioc-expbuf.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-expbuf.rst
rename to Documentation/media/uapi/v4l/vidioc-expbuf.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst b/Documentation/media/uapi/v4l/vidioc-g-audio.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
rename to Documentation/media/uapi/v4l/vidioc-g-audio.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst b/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst
rename to Documentation/media/uapi/v4l/vidioc-g-audioout.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst b/Documentation/media/uapi/v4l/vidioc-g-crop.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
rename to Documentation/media/uapi/v4l/vidioc-g-crop.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst b/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
rename to Documentation/media/uapi/v4l/vidioc-g-ctrl.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
rename to Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst b/Documentation/media/uapi/v4l/vidioc-g-edid.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
rename to Documentation/media/uapi/v4l/vidioc-g-edid.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst b/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst
rename to Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
rename to Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst b/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
rename to Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
rename to Documentation/media/uapi/v4l/vidioc-g-fmt.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst b/Documentation/media/uapi/v4l/vidioc-g-frequency.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst
rename to Documentation/media/uapi/v4l/vidioc-g-frequency.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-input.rst b/Documentation/media/uapi/v4l/vidioc-g-input.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-g-input.rst
rename to Documentation/media/uapi/v4l/vidioc-g-input.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-jpegcomp.rst b/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-g-jpegcomp.rst
rename to Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst b/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst
rename to Documentation/media/uapi/v4l/vidioc-g-modulator.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-output.rst b/Documentation/media/uapi/v4l/vidioc-g-output.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-g-output.rst
rename to Documentation/media/uapi/v4l/vidioc-g-output.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
rename to Documentation/media/uapi/v4l/vidioc-g-parm.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst b/Documentation/media/uapi/v4l/vidioc-g-priority.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-g-priority.rst
rename to Documentation/media/uapi/v4l/vidioc-g-priority.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-selection.rst b/Documentation/media/uapi/v4l/vidioc-g-selection.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-g-selection.rst
rename to Documentation/media/uapi/v4l/vidioc-g-selection.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-selection_files/constraints.png b/Documentation/media/uapi/v4l/vidioc-g-selection_files/constraints.png
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-g-selection_files/constraints.png
rename to Documentation/media/uapi/v4l/vidioc-g-selection_files/constraints.png
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst b/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst
rename to Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-std.rst b/Documentation/media/uapi/v4l/vidioc-g-std.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-g-std.rst
rename to Documentation/media/uapi/v4l/vidioc-g-std.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst
rename to Documentation/media/uapi/v4l/vidioc-g-tuner.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-log-status.rst b/Documentation/media/uapi/v4l/vidioc-log-status.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-log-status.rst
rename to Documentation/media/uapi/v4l/vidioc-log-status.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-overlay.rst b/Documentation/media/uapi/v4l/vidioc-overlay.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-overlay.rst
rename to Documentation/media/uapi/v4l/vidioc-overlay.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst b/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst
rename to Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-qbuf.rst
rename to Documentation/media/uapi/v4l/vidioc-qbuf.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst
rename to Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst b/Documentation/media/uapi/v4l/vidioc-querybuf.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-querybuf.rst
rename to Documentation/media/uapi/v4l/vidioc-querybuf.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-querycap.rst
rename to Documentation/media/uapi/v4l/vidioc-querycap.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
rename to Documentation/media/uapi/v4l/vidioc-queryctrl.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-querystd.rst b/Documentation/media/uapi/v4l/vidioc-querystd.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-querystd.rst
rename to Documentation/media/uapi/v4l/vidioc-querystd.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst
rename to Documentation/media/uapi/v4l/vidioc-reqbufs.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst b/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst
rename to Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-streamon.rst b/Documentation/media/uapi/v4l/vidioc-streamon.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-streamon.rst
rename to Documentation/media/uapi/v4l/vidioc-streamon.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst
rename to Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst
rename to Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst
rename to Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst
rename to Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-fmt.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-subdev-g-fmt.rst
rename to Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-frame-interval.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-subdev-g-frame-interval.rst
rename to Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-selection.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-subdev-g-selection.rst
rename to Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst b/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst
rename to Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
diff --git a/Documentation/linux_tv/media/v4l/yuv-formats.rst b/Documentation/media/uapi/v4l/yuv-formats.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/yuv-formats.rst
rename to Documentation/media/uapi/v4l/yuv-formats.rst
diff --git a/Documentation/linux_tv/video.h.rst.exceptions b/Documentation/media/video.h.rst.exceptions
similarity index 100%
rename from Documentation/linux_tv/video.h.rst.exceptions
rename to Documentation/media/video.h.rst.exceptions
diff --git a/Documentation/linux_tv/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
similarity index 100%
rename from Documentation/linux_tv/videodev2.h.rst.exceptions
rename to Documentation/media/videodev2.h.rst.exceptions
-- 
2.7.4

