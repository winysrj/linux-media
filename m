Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44938 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbcGDLr0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:26 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 40/51] Documentation: linux_tv: remove trailing comments
Date: Mon,  4 Jul 2016 08:47:01 -0300
Message-Id: <63b5f9f755e9e0c9b2a773410fd8909332a821ea.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The conversion script added some comments at the end.
They point to the original DocBook files, with will be
removed after the manual fixes. So, they'll be pointing
to nowere. So, remove those comments.

They'll be forever stored at the Kernel tree. So, if
someone wants the references, it is just a matter of
looking at the backlog.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/audio.h.rst                           | 11 -----------
 Documentation/linux_tv/ca.h.rst                              | 11 -----------
 Documentation/linux_tv/dmx.h.rst                             | 11 -----------
 Documentation/linux_tv/frontend.h.rst                        | 11 -----------
 Documentation/linux_tv/index.rst                             | 12 ------------
 .../linux_tv/media/dvb/FE_DISHNETWORK_SEND_LEGACY_CMD.rst    |  9 ---------
 Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst            | 11 -----------
 Documentation/linux_tv/media/dvb/FE_GET_FRONTEND.rst         | 11 -----------
 Documentation/linux_tv/media/dvb/FE_READ_BER.rst             |  9 ---------
 Documentation/linux_tv/media/dvb/FE_READ_SIGNAL_STRENGTH.rst |  9 ---------
 Documentation/linux_tv/media/dvb/FE_READ_SNR.rst             |  9 ---------
 .../linux_tv/media/dvb/FE_READ_UNCORRECTED_BLOCKS.rst        |  9 ---------
 Documentation/linux_tv/media/dvb/FE_SET_FRONTEND.rst         | 11 -----------
 Documentation/linux_tv/media/dvb/audio.rst                   | 11 -----------
 Documentation/linux_tv/media/dvb/audio_data_types.rst        | 11 -----------
 Documentation/linux_tv/media/dvb/audio_function_calls.rst    | 11 -----------
 Documentation/linux_tv/media/dvb/audio_h.rst                 | 11 -----------
 Documentation/linux_tv/media/dvb/ca.rst                      | 11 -----------
 Documentation/linux_tv/media/dvb/ca_data_types.rst           | 11 -----------
 Documentation/linux_tv/media/dvb/ca_function_calls.rst       |  9 ---------
 Documentation/linux_tv/media/dvb/ca_h.rst                    | 11 -----------
 Documentation/linux_tv/media/dvb/demux.rst                   | 11 -----------
 Documentation/linux_tv/media/dvb/dmx_fcalls.rst              |  9 ---------
 Documentation/linux_tv/media/dvb/dmx_h.rst                   | 11 -----------
 Documentation/linux_tv/media/dvb/dmx_types.rst               | 11 -----------
 Documentation/linux_tv/media/dvb/dtv-fe-stats.rst            | 11 -----------
 Documentation/linux_tv/media/dvb/dtv-properties.rst          | 11 -----------
 Documentation/linux_tv/media/dvb/dtv-property.rst            | 11 -----------
 Documentation/linux_tv/media/dvb/dtv-stats.rst               | 11 -----------
 Documentation/linux_tv/media/dvb/dvb-fe-read-status.rst      |  9 ---------
 Documentation/linux_tv/media/dvb/dvb-frontend-event.rst      | 11 -----------
 Documentation/linux_tv/media/dvb/dvb-frontend-parameters.rst | 11 -----------
 Documentation/linux_tv/media/dvb/dvbapi.rst                  |  9 ---------
 Documentation/linux_tv/media/dvb/dvbproperty-006.rst         |  9 ---------
 Documentation/linux_tv/media/dvb/dvbproperty.rst             | 11 -----------
 Documentation/linux_tv/media/dvb/examples.rst                | 11 -----------
 Documentation/linux_tv/media/dvb/fe-bandwidth-t.rst          | 11 -----------
 .../linux_tv/media/dvb/fe-diseqc-recv-slave-reply.rst        | 11 -----------
 .../linux_tv/media/dvb/fe-diseqc-reset-overload.rst          |  9 ---------
 Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst    | 11 -----------
 .../linux_tv/media/dvb/fe-diseqc-send-master-cmd.rst         | 11 -----------
 .../linux_tv/media/dvb/fe-enable-high-lnb-voltage.rst        |  9 ---------
 Documentation/linux_tv/media/dvb/fe-get-info.rst             | 11 -----------
 Documentation/linux_tv/media/dvb/fe-get-property.rst         |  9 ---------
 Documentation/linux_tv/media/dvb/fe-read-status.rst          | 11 -----------
 .../linux_tv/media/dvb/fe-set-frontend-tune-mode.rst         |  9 ---------
 Documentation/linux_tv/media/dvb/fe-set-tone.rst             | 11 -----------
 Documentation/linux_tv/media/dvb/fe-set-voltage.rst          |  9 ---------
 Documentation/linux_tv/media/dvb/fe-type-t.rst               |  9 ---------
 Documentation/linux_tv/media/dvb/fe_property_parameters.rst  |  9 ---------
 .../linux_tv/media/dvb/frontend-property-cable-systems.rst   |  9 ---------
 .../media/dvb/frontend-property-satellite-systems.rst        |  9 ---------
 .../media/dvb/frontend-property-terrestrial-systems.rst      |  9 ---------
 .../linux_tv/media/dvb/frontend-stat-properties.rst          |  9 ---------
 Documentation/linux_tv/media/dvb/frontend.rst                | 11 -----------
 Documentation/linux_tv/media/dvb/frontend_f_close.rst        |  9 ---------
 Documentation/linux_tv/media/dvb/frontend_f_open.rst         |  9 ---------
 Documentation/linux_tv/media/dvb/frontend_fcalls.rst         | 11 -----------
 Documentation/linux_tv/media/dvb/frontend_h.rst              | 11 -----------
 Documentation/linux_tv/media/dvb/frontend_legacy_api.rst     | 11 -----------
 .../linux_tv/media/dvb/frontend_legacy_dvbv3_api.rst         | 11 -----------
 Documentation/linux_tv/media/dvb/intro.rst                   |  9 ---------
 Documentation/linux_tv/media/dvb/legacy_dvb_apis.rst         | 11 -----------
 Documentation/linux_tv/media/dvb/net.rst                     |  9 ---------
 Documentation/linux_tv/media/dvb/net_h.rst                   | 11 -----------
 Documentation/linux_tv/media/dvb/query-dvb-frontend-info.rst |  9 ---------
 Documentation/linux_tv/media/dvb/video.rst                   | 11 -----------
 Documentation/linux_tv/media/dvb/video_function_calls.rst    | 11 -----------
 Documentation/linux_tv/media/dvb/video_h.rst                 | 11 -----------
 Documentation/linux_tv/media/dvb/video_types.rst             | 11 -----------
 .../linux_tv/media/v4l/Remote_controllers_Intro.rst          |  9 ---------
 .../linux_tv/media/v4l/Remote_controllers_table_change.rst   | 11 -----------
 .../linux_tv/media/v4l/Remote_controllers_tables.rst         | 11 -----------
 Documentation/linux_tv/media/v4l/app-pri.rst                 |  9 ---------
 Documentation/linux_tv/media/v4l/async.rst                   |  9 ---------
 Documentation/linux_tv/media/v4l/audio.rst                   |  9 ---------
 Documentation/linux_tv/media/v4l/biblio.rst                  |  9 ---------
 Documentation/linux_tv/media/v4l/buffer.rst                  | 11 -----------
 Documentation/linux_tv/media/v4l/capture-example.rst         | 11 -----------
 Documentation/linux_tv/media/v4l/capture.c.rst               | 11 -----------
 Documentation/linux_tv/media/v4l/colorspaces.rst             |  9 ---------
 Documentation/linux_tv/media/v4l/common-defs.rst             | 11 -----------
 Documentation/linux_tv/media/v4l/common.rst                  | 11 -----------
 Documentation/linux_tv/media/v4l/compat.rst                  | 11 -----------
 Documentation/linux_tv/media/v4l/control.rst                 |  9 ---------
 Documentation/linux_tv/media/v4l/crop.rst                    |  9 ---------
 Documentation/linux_tv/media/v4l/depth-formats.rst           | 11 -----------
 Documentation/linux_tv/media/v4l/dev-capture.rst             |  9 ---------
 Documentation/linux_tv/media/v4l/dev-codec.rst               |  9 ---------
 Documentation/linux_tv/media/v4l/dev-effect.rst              |  9 ---------
 Documentation/linux_tv/media/v4l/dev-event.rst               |  9 ---------
 Documentation/linux_tv/media/v4l/dev-osd.rst                 |  9 ---------
 Documentation/linux_tv/media/v4l/dev-output.rst              |  9 ---------
 Documentation/linux_tv/media/v4l/dev-overlay.rst             |  9 ---------
 Documentation/linux_tv/media/v4l/dev-radio.rst               |  9 ---------
 Documentation/linux_tv/media/v4l/dev-raw-vbi.rst             |  9 ---------
 Documentation/linux_tv/media/v4l/dev-rds.rst                 | 11 -----------
 Documentation/linux_tv/media/v4l/dev-sdr.rst                 |  9 ---------
 Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst          |  9 ---------
 Documentation/linux_tv/media/v4l/dev-subdev.rst              | 11 -----------
 Documentation/linux_tv/media/v4l/dev-teletext.rst            |  9 ---------
 Documentation/linux_tv/media/v4l/devices.rst                 | 11 -----------
 Documentation/linux_tv/media/v4l/diff-v4l.rst                |  9 ---------
 Documentation/linux_tv/media/v4l/dmabuf.rst                  |  9 ---------
 Documentation/linux_tv/media/v4l/driver.rst                  |  9 ---------
 Documentation/linux_tv/media/v4l/dv-timings.rst              |  9 ---------
 Documentation/linux_tv/media/v4l/extended-controls.rst       |  9 ---------
 Documentation/linux_tv/media/v4l/fdl-appendix.rst            |  9 ---------
 Documentation/linux_tv/media/v4l/field-order.rst             | 11 -----------
 Documentation/linux_tv/media/v4l/format.rst                  |  9 ---------
 Documentation/linux_tv/media/v4l/func-close.rst              |  9 ---------
 Documentation/linux_tv/media/v4l/func-ioctl.rst              |  9 ---------
 Documentation/linux_tv/media/v4l/func-mmap.rst               |  9 ---------
 Documentation/linux_tv/media/v4l/func-munmap.rst             |  9 ---------
 Documentation/linux_tv/media/v4l/func-open.rst               |  9 ---------
 Documentation/linux_tv/media/v4l/func-poll.rst               |  9 ---------
 Documentation/linux_tv/media/v4l/func-read.rst               |  9 ---------
 Documentation/linux_tv/media/v4l/func-select.rst             |  9 ---------
 Documentation/linux_tv/media/v4l/func-write.rst              |  9 ---------
 Documentation/linux_tv/media/v4l/gen-errors.rst              |  9 ---------
 Documentation/linux_tv/media/v4l/hist-v4l2.rst               |  9 ---------
 Documentation/linux_tv/media/v4l/io.rst                      | 11 -----------
 Documentation/linux_tv/media/v4l/keytable.c.rst              | 11 -----------
 Documentation/linux_tv/media/v4l/libv4l-introduction.rst     |  9 ---------
 Documentation/linux_tv/media/v4l/libv4l.rst                  | 11 -----------
 Documentation/linux_tv/media/v4l/lirc_dev_intro.rst          |  9 ---------
 Documentation/linux_tv/media/v4l/lirc_device_interface.rst   | 11 -----------
 Documentation/linux_tv/media/v4l/lirc_ioctl.rst              |  9 ---------
 Documentation/linux_tv/media/v4l/lirc_read.rst               |  9 ---------
 Documentation/linux_tv/media/v4l/lirc_write.rst              |  9 ---------
 Documentation/linux_tv/media/v4l/media-controller-intro.rst  |  9 ---------
 Documentation/linux_tv/media/v4l/media-controller-model.rst  |  9 ---------
 Documentation/linux_tv/media/v4l/media-controller.rst        |  9 ---------
 Documentation/linux_tv/media/v4l/media-func-close.rst        |  9 ---------
 Documentation/linux_tv/media/v4l/media-func-ioctl.rst        |  9 ---------
 Documentation/linux_tv/media/v4l/media-func-open.rst         |  9 ---------
 Documentation/linux_tv/media/v4l/media-ioc-device-info.rst   |  9 ---------
 Documentation/linux_tv/media/v4l/media-ioc-enum-entities.rst |  9 ---------
 Documentation/linux_tv/media/v4l/media-ioc-enum-links.rst    |  9 ---------
 Documentation/linux_tv/media/v4l/media-ioc-g-topology.rst    |  9 ---------
 Documentation/linux_tv/media/v4l/media-ioc-setup-link.rst    |  9 ---------
 Documentation/linux_tv/media/v4l/media-types.rst             | 11 -----------
 Documentation/linux_tv/media/v4l/mmap.rst                    |  9 ---------
 Documentation/linux_tv/media/v4l/open.rst                    |  9 ---------
 Documentation/linux_tv/media/v4l/pixfmt-002.rst              | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-003.rst              | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-004.rst              |  9 ---------
 Documentation/linux_tv/media/v4l/pixfmt-006.rst              | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-007.rst              |  9 ---------
 Documentation/linux_tv/media/v4l/pixfmt-008.rst              |  9 ---------
 Documentation/linux_tv/media/v4l/pixfmt-013.rst              | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-grey.rst             | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-indexed.rst          | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-m420.rst             | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-nv12.rst             | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst            | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-nv12mt.rst           |  9 ---------
 Documentation/linux_tv/media/v4l/pixfmt-nv16.rst             | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst            | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-nv24.rst             | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-packed-rgb.rst       |  9 ---------
 Documentation/linux_tv/media/v4l/pixfmt-packed-yuv.rst       |  9 ---------
 Documentation/linux_tv/media/v4l/pixfmt-reserved.rst         | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-rgb.rst              | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-sbggr16.rst          | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-sbggr8.rst           | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-sdr-cs08.rst         | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-sdr-cs14le.rst       | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-sdr-cu08.rst         | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-sdr-cu16le.rst       | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-sdr-ru12le.rst       | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-sgbrg8.rst           | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-sgrbg8.rst           | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-srggb10.rst          | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-srggb10alaw8.rst     |  9 ---------
 Documentation/linux_tv/media/v4l/pixfmt-srggb10dpcm8.rst     |  9 ---------
 Documentation/linux_tv/media/v4l/pixfmt-srggb10p.rst         | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-srggb12.rst          | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-srggb8.rst           | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-uv8.rst              | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-uyvy.rst             | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-vyuy.rst             | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-y10.rst              | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-y10b.rst             | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-y12.rst              | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-y12i.rst             | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-y16-be.rst           | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-y16.rst              | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-y41p.rst             | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-y8i.rst              | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-yuv410.rst           | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-yuv411p.rst          | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-yuv420.rst           | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-yuv420m.rst          | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-yuv422m.rst          | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-yuv422p.rst          | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-yuv444m.rst          | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-yuyv.rst             | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-yvyu.rst             | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt-z16.rst              | 11 -----------
 Documentation/linux_tv/media/v4l/pixfmt.rst                  | 11 -----------
 Documentation/linux_tv/media/v4l/planar-apis.rst             |  9 ---------
 Documentation/linux_tv/media/v4l/querycap.rst                |  9 ---------
 Documentation/linux_tv/media/v4l/remote_controllers.rst      |  9 ---------
 .../linux_tv/media/v4l/remote_controllers_sysfs_nodes.rst    |  9 ---------
 Documentation/linux_tv/media/v4l/rw.rst                      |  9 ---------
 Documentation/linux_tv/media/v4l/sdr-formats.rst             | 11 -----------
 Documentation/linux_tv/media/v4l/selection-api-002.rst       |  9 ---------
 Documentation/linux_tv/media/v4l/selection-api-003.rst       |  9 ---------
 Documentation/linux_tv/media/v4l/selection-api-004.rst       |  9 ---------
 Documentation/linux_tv/media/v4l/selection-api-005.rst       |  9 ---------
 Documentation/linux_tv/media/v4l/selection-api-006.rst       | 11 -----------
 Documentation/linux_tv/media/v4l/selection-api.rst           | 11 -----------
 Documentation/linux_tv/media/v4l/selections-common.rst       | 11 -----------
 Documentation/linux_tv/media/v4l/standard.rst                |  9 ---------
 Documentation/linux_tv/media/v4l/streaming-par.rst           |  9 ---------
 Documentation/linux_tv/media/v4l/subdev-formats.rst          | 11 -----------
 Documentation/linux_tv/media/v4l/tuner.rst                   |  9 ---------
 Documentation/linux_tv/media/v4l/user-func.rst               | 11 -----------
 Documentation/linux_tv/media/v4l/userp.rst                   |  9 ---------
 Documentation/linux_tv/media/v4l/v4l2-selection-flags.rst    | 11 -----------
 Documentation/linux_tv/media/v4l/v4l2-selection-targets.rst  | 11 -----------
 Documentation/linux_tv/media/v4l/v4l2.rst                    |  9 ---------
 Documentation/linux_tv/media/v4l/v4l2grab-example.rst        | 11 -----------
 Documentation/linux_tv/media/v4l/v4l2grab.c.rst              | 11 -----------
 Documentation/linux_tv/media/v4l/video.rst                   | 11 -----------
 Documentation/linux_tv/media/v4l/videodev.rst                | 11 -----------
 Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst      |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-cropcap.rst          |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst  |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst   |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst      |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-dqevent.rst          |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst   |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst      |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst  |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst         |  9 ---------
 .../linux_tv/media/v4l/vidioc-enum-frameintervals.rst        |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst  |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst  |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst        |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst     |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-enuminput.rst        |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst       |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-enumstd.rst          |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-expbuf.rst           |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-g-audio.rst          |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst       |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-g-crop.rst           |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst           |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst     | 11 -----------
 Documentation/linux_tv/media/v4l/vidioc-g-edid.rst           |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst      |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst      |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst           |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst            |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst      |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-g-input.rst          |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-g-jpegcomp.rst       |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst      |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-g-output.rst         |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-g-parm.rst           |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-g-priority.rst       |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-g-selection.rst      |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-g-std.rst            |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst          |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-log-status.rst       |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-overlay.rst          |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst      |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-qbuf.rst             |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-querybuf.rst         |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-querycap.rst         |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst        |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-querystd.rst         |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst          |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst   |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-streamon.rst         |  9 ---------
 .../linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst |  9 ---------
 .../linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst     |  9 ---------
 .../linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst      |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst    |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-subdev-g-fmt.rst     |  9 ---------
 .../linux_tv/media/v4l/vidioc-subdev-g-frame-interval.rst    |  9 ---------
 .../linux_tv/media/v4l/vidioc-subdev-g-selection.rst         |  9 ---------
 Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst  |  9 ---------
 Documentation/linux_tv/media/v4l/yuv-formats.rst             | 11 -----------
 Documentation/linux_tv/net.h.rst                             | 11 -----------
 Documentation/linux_tv/video.h.rst                           | 11 -----------
 Documentation/linux_tv/videodev2.h.rst                       | 11 -----------
 scripts/kernel-doc                                           |  0
 292 files changed, 2876 deletions(-)
 mode change 100644 => 100755 scripts/kernel-doc

diff --git a/Documentation/linux_tv/audio.h.rst b/Documentation/linux_tv/audio.h.rst
index abf29027f8ea..1e76a866c01a 100644
--- a/Documentation/linux_tv/audio.h.rst
+++ b/Documentation/linux_tv/audio.h.rst
@@ -140,14 +140,3 @@ file: audio.h
     #define AUDIO_BILINGUAL_CHANNEL_SELECT _IO('o', 20)
 
     #endif /* _DVBAUDIO_H_ */
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/ca.h.rst b/Documentation/linux_tv/ca.h.rst
index b69ce287aa8c..0664c4bdd985 100644
--- a/Documentation/linux_tv/ca.h.rst
+++ b/Documentation/linux_tv/ca.h.rst
@@ -95,14 +95,3 @@ file: ca.h
     #define CA_SET_PID        _IOW('o', 135, ca_pid_t)
 
     #endif
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/dmx.h.rst b/Documentation/linux_tv/dmx.h.rst
index 9ced07899e57..4791554f82f9 100644
--- a/Documentation/linux_tv/dmx.h.rst
+++ b/Documentation/linux_tv/dmx.h.rst
@@ -160,14 +160,3 @@ file: dmx.h
     #define DMX_REMOVE_PID           _IOW('o', 52, __u16)
 
     #endif /* _UAPI_DVBDMX_H_ */
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/frontend.h.rst b/Documentation/linux_tv/frontend.h.rst
index 1b65b2037778..5c8f11a77c1e 100644
--- a/Documentation/linux_tv/frontend.h.rst
+++ b/Documentation/linux_tv/frontend.h.rst
@@ -607,14 +607,3 @@ file: frontend.h
     #define FE_DISHNETWORK_SEND_LEGACY_CMD _IO('o', 80) /* unsigned int */
 
     #endif /*_DVBFRONTEND_H_*/
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/index.rst b/Documentation/linux_tv/index.rst
index edb7d56e9b8f..821be82dcb23 100644
--- a/Documentation/linux_tv/index.rst
+++ b/Documentation/linux_tv/index.rst
@@ -75,18 +75,6 @@ etc, please mail to:
     media/v4l/gen-errors
     media/v4l/fdl-appendix
 
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
-
-
 .. only:: html
 
   Retrieval
diff --git a/Documentation/linux_tv/media/dvb/FE_DISHNETWORK_SEND_LEGACY_CMD.rst b/Documentation/linux_tv/media/dvb/FE_DISHNETWORK_SEND_LEGACY_CMD.rst
index a01cafad8d3c..890b5edb0350 100644
--- a/Documentation/linux_tv/media/dvb/FE_DISHNETWORK_SEND_LEGACY_CMD.rst
+++ b/Documentation/linux_tv/media/dvb/FE_DISHNETWORK_SEND_LEGACY_CMD.rst
@@ -44,12 +44,3 @@ RETURN VALUE
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst b/Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst
index 1951857cde65..08a090212f96 100644
--- a/Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst
+++ b/Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst
@@ -76,14 +76,3 @@ appropriately. The generic error codes are described at the
        -  ``EOVERFLOW``
 
        -  Overflow in event queue - one or more events were lost.
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/FE_GET_FRONTEND.rst b/Documentation/linux_tv/media/dvb/FE_GET_FRONTEND.rst
index 5bf39ff72bd7..ee73fb448ef8 100644
--- a/Documentation/linux_tv/media/dvb/FE_GET_FRONTEND.rst
+++ b/Documentation/linux_tv/media/dvb/FE_GET_FRONTEND.rst
@@ -64,14 +64,3 @@ appropriately. The generic error codes are described at the
        -  ``EINVAL``
 
        -  Maximum supported symbol rate reached.
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/FE_READ_BER.rst b/Documentation/linux_tv/media/dvb/FE_READ_BER.rst
index 935c0e50b0fd..218e2298615b 100644
--- a/Documentation/linux_tv/media/dvb/FE_READ_BER.rst
+++ b/Documentation/linux_tv/media/dvb/FE_READ_BER.rst
@@ -50,12 +50,3 @@ RETURN VALUE
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/FE_READ_SIGNAL_STRENGTH.rst b/Documentation/linux_tv/media/dvb/FE_READ_SIGNAL_STRENGTH.rst
index 01180e20e4d4..d2dd0fba5363 100644
--- a/Documentation/linux_tv/media/dvb/FE_READ_SIGNAL_STRENGTH.rst
+++ b/Documentation/linux_tv/media/dvb/FE_READ_SIGNAL_STRENGTH.rst
@@ -53,12 +53,3 @@ RETURN VALUE
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/FE_READ_SNR.rst b/Documentation/linux_tv/media/dvb/FE_READ_SNR.rst
index 0ccc7d71d8a4..2f9759a310f0 100644
--- a/Documentation/linux_tv/media/dvb/FE_READ_SNR.rst
+++ b/Documentation/linux_tv/media/dvb/FE_READ_SNR.rst
@@ -50,12 +50,3 @@ RETURN VALUE
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/FE_READ_UNCORRECTED_BLOCKS.rst b/Documentation/linux_tv/media/dvb/FE_READ_UNCORRECTED_BLOCKS.rst
index 3827c7b953e1..fa770d25b3de 100644
--- a/Documentation/linux_tv/media/dvb/FE_READ_UNCORRECTED_BLOCKS.rst
+++ b/Documentation/linux_tv/media/dvb/FE_READ_UNCORRECTED_BLOCKS.rst
@@ -55,12 +55,3 @@ RETURN VALUE
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/FE_SET_FRONTEND.rst b/Documentation/linux_tv/media/dvb/FE_SET_FRONTEND.rst
index 4cb393bbc2e1..794089897845 100644
--- a/Documentation/linux_tv/media/dvb/FE_SET_FRONTEND.rst
+++ b/Documentation/linux_tv/media/dvb/FE_SET_FRONTEND.rst
@@ -71,14 +71,3 @@ appropriately. The generic error codes are described at the
        -  ``EINVAL``
 
        -  Maximum supported symbol rate reached.
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/audio.rst b/Documentation/linux_tv/media/dvb/audio.rst
index d6b6f9edf3b3..155622185ea4 100644
--- a/Documentation/linux_tv/media/dvb/audio.rst
+++ b/Documentation/linux_tv/media/dvb/audio.rst
@@ -24,14 +24,3 @@ functionality.
 
     audio_data_types
     audio_function_calls
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/audio_data_types.rst b/Documentation/linux_tv/media/dvb/audio_data_types.rst
index b3f5aa0ac6e4..cf9216c91f2d 100644
--- a/Documentation/linux_tv/media/dvb/audio_data_types.rst
+++ b/Documentation/linux_tv/media/dvb/audio_data_types.rst
@@ -174,14 +174,3 @@ The following attributes can be set by a call to AUDIO_SET_ATTRIBUTES:
      /*    7- 6 Quantization / DRC (mpeg audio: 1=DRC exists)(lpcm: 0=16bit,  */
      /*    5- 4 Sample frequency fs (0=48kHz, 1=96kHz) */
      /*    2- 0 number of audio channels (n+1 channels) */
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/audio_function_calls.rst b/Documentation/linux_tv/media/dvb/audio_function_calls.rst
index d8abdd0e9417..b3408b7c4e91 100644
--- a/Documentation/linux_tv/media/dvb/audio_function_calls.rst
+++ b/Documentation/linux_tv/media/dvb/audio_function_calls.rst
@@ -1295,14 +1295,3 @@ appropriately. The generic error codes are described at the
        -  ``EINVAL``
 
        -  karaoke is not a valid or supported karaoke setting.
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/audio_h.rst b/Documentation/linux_tv/media/dvb/audio_h.rst
index 09a73a54ab00..bdd9a709a125 100644
--- a/Documentation/linux_tv/media/dvb/audio_h.rst
+++ b/Documentation/linux_tv/media/dvb/audio_h.rst
@@ -11,14 +11,3 @@ DVB Audio Header File
     :maxdepth: 1
 
     ../../audio.h
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/ca.rst b/Documentation/linux_tv/media/dvb/ca.rst
index bb01d93f0256..14b14abda1ae 100644
--- a/Documentation/linux_tv/media/dvb/ca.rst
+++ b/Documentation/linux_tv/media/dvb/ca.rst
@@ -16,14 +16,3 @@ application.
 
     ca_data_types
     ca_function_calls
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/ca_data_types.rst b/Documentation/linux_tv/media/dvb/ca_data_types.rst
index bb0cdfa7c9a6..ca17e146dac0 100644
--- a/Documentation/linux_tv/media/dvb/ca_data_types.rst
+++ b/Documentation/linux_tv/media/dvb/ca_data_types.rst
@@ -108,14 +108,3 @@ ca-pid
         unsigned int pid;
         int index;      /* -1 == disable*/
     } ca_pid_t;
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/ca_function_calls.rst b/Documentation/linux_tv/media/dvb/ca_function_calls.rst
index 83bce0420881..af110ba6496a 100644
--- a/Documentation/linux_tv/media/dvb/ca_function_calls.rst
+++ b/Documentation/linux_tv/media/dvb/ca_function_calls.rst
@@ -530,12 +530,3 @@ RETURN VALUE
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/ca_h.rst b/Documentation/linux_tv/media/dvb/ca_h.rst
index 229bfbca045b..a7d22154022b 100644
--- a/Documentation/linux_tv/media/dvb/ca_h.rst
+++ b/Documentation/linux_tv/media/dvb/ca_h.rst
@@ -11,14 +11,3 @@ DVB Conditional Access Header File
     :maxdepth: 1
 
     ../../ca.h
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/demux.rst b/Documentation/linux_tv/media/dvb/demux.rst
index 3bcee72c68fb..b12b5a2dac94 100644
--- a/Documentation/linux_tv/media/dvb/demux.rst
+++ b/Documentation/linux_tv/media/dvb/demux.rst
@@ -16,14 +16,3 @@ your application.
 
     dmx_types
     dmx_fcalls
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/dmx_fcalls.rst b/Documentation/linux_tv/media/dvb/dmx_fcalls.rst
index 4563c8f2a1b8..4612364fb2d8 100644
--- a/Documentation/linux_tv/media/dvb/dmx_fcalls.rst
+++ b/Documentation/linux_tv/media/dvb/dmx_fcalls.rst
@@ -1002,12 +1002,3 @@ RETURN VALUE
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/dmx_h.rst b/Documentation/linux_tv/media/dvb/dmx_h.rst
index 19e2691b7eab..baf129dd078b 100644
--- a/Documentation/linux_tv/media/dvb/dmx_h.rst
+++ b/Documentation/linux_tv/media/dvb/dmx_h.rst
@@ -11,14 +11,3 @@ DVB Demux Header File
     :maxdepth: 1
 
     ../../dmx.h
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/dmx_types.rst b/Documentation/linux_tv/media/dvb/dmx_types.rst
index 83859366b73e..05891946b2a7 100644
--- a/Documentation/linux_tv/media/dvb/dmx_types.rst
+++ b/Documentation/linux_tv/media/dvb/dmx_types.rst
@@ -240,14 +240,3 @@ enum dmx_source_t
         DMX_SOURCE_DVR2,
         DMX_SOURCE_DVR3
     } dmx_source_t;
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/dtv-fe-stats.rst b/Documentation/linux_tv/media/dvb/dtv-fe-stats.rst
index 17b26fa050f5..d169e318cfde 100644
--- a/Documentation/linux_tv/media/dvb/dtv-fe-stats.rst
+++ b/Documentation/linux_tv/media/dvb/dtv-fe-stats.rst
@@ -15,14 +15,3 @@ struct dtv_fe_stats
         __u8 len;
         struct dtv_stats stat[MAX_DTV_STATS];
     } __packed;
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/dtv-properties.rst b/Documentation/linux_tv/media/dvb/dtv-properties.rst
index b1b28342d09d..002553b7068b 100644
--- a/Documentation/linux_tv/media/dvb/dtv-properties.rst
+++ b/Documentation/linux_tv/media/dvb/dtv-properties.rst
@@ -13,14 +13,3 @@ struct dtv_properties
         __u32 num;
         struct dtv_property *props;
     };
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/dtv-property.rst b/Documentation/linux_tv/media/dvb/dtv-property.rst
index 4dff00eb610c..9fc8cef5a09b 100644
--- a/Documentation/linux_tv/media/dvb/dtv-property.rst
+++ b/Documentation/linux_tv/media/dvb/dtv-property.rst
@@ -29,14 +29,3 @@ struct dtv_property
 
     /* num of properties cannot exceed DTV_IOCTL_MAX_MSGS per ioctl */
     #define DTV_IOCTL_MAX_MSGS 64
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/dtv-stats.rst b/Documentation/linux_tv/media/dvb/dtv-stats.rst
index e70e5a5283ff..0f73205400ae 100644
--- a/Documentation/linux_tv/media/dvb/dtv-stats.rst
+++ b/Documentation/linux_tv/media/dvb/dtv-stats.rst
@@ -16,14 +16,3 @@ struct dtv_stats
             __s64 svalue;   /* for 1/1000 dB measures */
         };
     } __packed;
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/dvb-fe-read-status.rst b/Documentation/linux_tv/media/dvb/dvb-fe-read-status.rst
index e36cd134007e..1c708c5e6bc0 100644
--- a/Documentation/linux_tv/media/dvb/dvb-fe-read-status.rst
+++ b/Documentation/linux_tv/media/dvb/dvb-fe-read-status.rst
@@ -20,12 +20,3 @@ statistics require the demodulator to be fully locked (e. g. with
 FE_HAS_LOCK bit set). See
 :ref:`Frontend statistics indicators <frontend-stat-properties>` for
 more details.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/dvb-frontend-event.rst b/Documentation/linux_tv/media/dvb/dvb-frontend-event.rst
index 82965e4d7450..8ff83578b4da 100644
--- a/Documentation/linux_tv/media/dvb/dvb-frontend-event.rst
+++ b/Documentation/linux_tv/media/dvb/dvb-frontend-event.rst
@@ -13,14 +13,3 @@ frontend events
          fe_status_t status;
          struct dvb_frontend_parameters parameters;
      };
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/dvb-frontend-parameters.rst b/Documentation/linux_tv/media/dvb/dvb-frontend-parameters.rst
index 0a1766f68917..bb125b8c4b3b 100644
--- a/Documentation/linux_tv/media/dvb/dvb-frontend-parameters.rst
+++ b/Documentation/linux_tv/media/dvb/dvb-frontend-parameters.rst
@@ -117,14 +117,3 @@ DVB-T frontends are supported by the ``dvb_ofdm_parameters`` structure:
          fe_guard_interval_t guard_interval;
          fe_hierarchy_t      hierarchy_information;
      };
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/dvbapi.rst b/Documentation/linux_tv/media/dvb/dvbapi.rst
index daeeb4d64917..ad800404ae9f 100644
--- a/Documentation/linux_tv/media/dvb/dvbapi.rst
+++ b/Documentation/linux_tv/media/dvb/dvbapi.rst
@@ -86,12 +86,3 @@ original LaTex version.
 :revision: 1.0.0 / 2003-07-24 (*rjkm*)
 
 Initial revision on LaTEX.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/dvbproperty-006.rst b/Documentation/linux_tv/media/dvb/dvbproperty-006.rst
index 4b89d607358c..3343a0f306fe 100644
--- a/Documentation/linux_tv/media/dvb/dvbproperty-006.rst
+++ b/Documentation/linux_tv/media/dvb/dvbproperty-006.rst
@@ -10,12 +10,3 @@ With one single ioctl, is possible to get/set up to 64 properties. The
 actual meaning of each property is described on the next sections.
 
 The available frontend property types are shown on the next section.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/dvbproperty.rst b/Documentation/linux_tv/media/dvb/dvbproperty.rst
index a68b17808bc2..34187964db38 100644
--- a/Documentation/linux_tv/media/dvb/dvbproperty.rst
+++ b/Documentation/linux_tv/media/dvb/dvbproperty.rst
@@ -109,14 +109,3 @@ read/write channel descriptor files.
     frontend-property-terrestrial-systems
     frontend-property-cable-systems
     frontend-property-satellite-systems
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/examples.rst b/Documentation/linux_tv/media/dvb/examples.rst
index b3a94dedcd39..0cad02acd1bd 100644
--- a/Documentation/linux_tv/media/dvb/examples.rst
+++ b/Documentation/linux_tv/media/dvb/examples.rst
@@ -378,14 +378,3 @@ recording.
          }
          return 0;
      }
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/fe-bandwidth-t.rst b/Documentation/linux_tv/media/dvb/fe-bandwidth-t.rst
index c6e56aba012a..f59d60c57bfd 100644
--- a/Documentation/linux_tv/media/dvb/fe-bandwidth-t.rst
+++ b/Documentation/linux_tv/media/dvb/fe-bandwidth-t.rst
@@ -75,14 +75,3 @@ Frontend bandwidth
           ``BANDWIDTH_10_MHZ``
 
        -  10 MHz
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/fe-diseqc-recv-slave-reply.rst b/Documentation/linux_tv/media/dvb/fe-diseqc-recv-slave-reply.rst
index 0f01584c8d4e..da860e50fde9 100644
--- a/Documentation/linux_tv/media/dvb/fe-diseqc-recv-slave-reply.rst
+++ b/Documentation/linux_tv/media/dvb/fe-diseqc-recv-slave-reply.rst
@@ -75,14 +75,3 @@ appropriately. The generic error codes are described at the
 
        -  Return from ioctl after timeout ms with errorcode when no message
           was received
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/fe-diseqc-reset-overload.rst b/Documentation/linux_tv/media/dvb/fe-diseqc-reset-overload.rst
index 50d0d651d270..2c64eab598b8 100644
--- a/Documentation/linux_tv/media/dvb/fe-diseqc-reset-overload.rst
+++ b/Documentation/linux_tv/media/dvb/fe-diseqc-reset-overload.rst
@@ -40,12 +40,3 @@ RETURN VALUE
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst b/Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst
index 34c787903eb1..f365238e5b78 100644
--- a/Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst
+++ b/Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst
@@ -80,14 +80,3 @@ enum fe_sec_mini_cmd
           ``SEC_MINI_B``
 
        -  Sends a mini-DiSEqC 22kHz '1' Data Burst to select satellite-B
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/fe-diseqc-send-master-cmd.rst b/Documentation/linux_tv/media/dvb/fe-diseqc-send-master-cmd.rst
index 7a85632e64b4..04c6cc8ae070 100644
--- a/Documentation/linux_tv/media/dvb/fe-diseqc-send-master-cmd.rst
+++ b/Documentation/linux_tv/media/dvb/fe-diseqc-send-master-cmd.rst
@@ -65,14 +65,3 @@ appropriately. The generic error codes are described at the
        -  msg_len
 
        -  Length of the DiSEqC message. Valid values are 3 to 6
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/fe-enable-high-lnb-voltage.rst b/Documentation/linux_tv/media/dvb/fe-enable-high-lnb-voltage.rst
index f2705a383d8c..669dbd6e79b8 100644
--- a/Documentation/linux_tv/media/dvb/fe-enable-high-lnb-voltage.rst
+++ b/Documentation/linux_tv/media/dvb/fe-enable-high-lnb-voltage.rst
@@ -47,12 +47,3 @@ RETURN VALUE
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/fe-get-info.rst b/Documentation/linux_tv/media/dvb/fe-get-info.rst
index d7990c80ef87..0880a11def86 100644
--- a/Documentation/linux_tv/media/dvb/fe-get-info.rst
+++ b/Documentation/linux_tv/media/dvb/fe-get-info.rst
@@ -421,14 +421,3 @@ supported only on some specific frontend types.
           ``FE_CAN_MUTE_TS``
 
        -  The frontend can stop spurious TS data output
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/fe-get-property.rst b/Documentation/linux_tv/media/dvb/fe-get-property.rst
index 5b73ee8e790b..0edc9291fc70 100644
--- a/Documentation/linux_tv/media/dvb/fe-get-property.rst
+++ b/Documentation/linux_tv/media/dvb/fe-get-property.rst
@@ -64,12 +64,3 @@ RETURN VALUE
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/fe-read-status.rst b/Documentation/linux_tv/media/dvb/fe-read-status.rst
index c032cda4e5a6..250fabc71c64 100644
--- a/Documentation/linux_tv/media/dvb/fe-read-status.rst
+++ b/Documentation/linux_tv/media/dvb/fe-read-status.rst
@@ -130,14 +130,3 @@ state changes of the frontend hardware. It is produced using the enum
 
        -  The frontend was reinitialized, application is recommended to
           reset DiSEqC, tone and parameters
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/fe-set-frontend-tune-mode.rst b/Documentation/linux_tv/media/dvb/fe-set-frontend-tune-mode.rst
index 82665279b840..aeecb947fa70 100644
--- a/Documentation/linux_tv/media/dvb/fe-set-frontend-tune-mode.rst
+++ b/Documentation/linux_tv/media/dvb/fe-set-frontend-tune-mode.rst
@@ -49,12 +49,3 @@ RETURN VALUE
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/fe-set-tone.rst b/Documentation/linux_tv/media/dvb/fe-set-tone.rst
index f98c4b3b8760..432797211f80 100644
--- a/Documentation/linux_tv/media/dvb/fe-set-tone.rst
+++ b/Documentation/linux_tv/media/dvb/fe-set-tone.rst
@@ -87,14 +87,3 @@ enum fe_sec_tone_mode
 
        -  Don't send a 22kHz tone to the antenna (except if the
           FE_DISEQC_* ioctls are called)
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/fe-set-voltage.rst b/Documentation/linux_tv/media/dvb/fe-set-voltage.rst
index eb4ab28b479a..63c5f401e808 100644
--- a/Documentation/linux_tv/media/dvb/fe-set-voltage.rst
+++ b/Documentation/linux_tv/media/dvb/fe-set-voltage.rst
@@ -57,12 +57,3 @@ RETURN VALUE
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/fe-type-t.rst b/Documentation/linux_tv/media/dvb/fe-type-t.rst
index 49fa8090010b..fcce8ef421ae 100644
--- a/Documentation/linux_tv/media/dvb/fe-type-t.rst
+++ b/Documentation/linux_tv/media/dvb/fe-type-t.rst
@@ -89,12 +89,3 @@ On devices that support multiple delivery systems, struct
 filled with the currently standard, as selected by the last call to
 :ref:`FE_SET_PROPERTY <FE_GET_PROPERTY>` using the
 :ref:`DTV_DELIVERY_SYSTEM <DTV-DELIVERY-SYSTEM>` property.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/fe_property_parameters.rst b/Documentation/linux_tv/media/dvb/fe_property_parameters.rst
index 788dbfef0061..e30ed6d71335 100644
--- a/Documentation/linux_tv/media/dvb/fe_property_parameters.rst
+++ b/Documentation/linux_tv/media/dvb/fe_property_parameters.rst
@@ -1965,12 +1965,3 @@ Possible values: 0, 1, LNA_AUTO
 1, LNA on
 
 use the special macro LNA_AUTO to set LNA auto
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/frontend-property-cable-systems.rst b/Documentation/linux_tv/media/dvb/frontend-property-cable-systems.rst
index 360966ef50cf..bf2328627af5 100644
--- a/Documentation/linux_tv/media/dvb/frontend-property-cable-systems.rst
+++ b/Documentation/linux_tv/media/dvb/frontend-property-cable-systems.rst
@@ -73,12 +73,3 @@ The following parameters are valid for DVB-C Annex B:
 
 In addition, the :ref:`DTV QoS statistics <frontend-stat-properties>`
 are also valid.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/frontend-property-satellite-systems.rst b/Documentation/linux_tv/media/dvb/frontend-property-satellite-systems.rst
index 1a204ac01afd..1f40399c68ff 100644
--- a/Documentation/linux_tv/media/dvb/frontend-property-satellite-systems.rst
+++ b/Documentation/linux_tv/media/dvb/frontend-property-satellite-systems.rst
@@ -101,12 +101,3 @@ The following parameters are valid for ISDB-S:
 -  :ref:`DTV_VOLTAGE <DTV-VOLTAGE>`
 
 -  :ref:`DTV_STREAM_ID <DTV-STREAM-ID>`
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/frontend-property-terrestrial-systems.rst b/Documentation/linux_tv/media/dvb/frontend-property-terrestrial-systems.rst
index 78026596f46f..dbc717cad9ee 100644
--- a/Documentation/linux_tv/media/dvb/frontend-property-terrestrial-systems.rst
+++ b/Documentation/linux_tv/media/dvb/frontend-property-terrestrial-systems.rst
@@ -292,12 +292,3 @@ The following parameters are valid for DTMB:
 
 In addition, the :ref:`DTV QoS statistics <frontend-stat-properties>`
 are also valid.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/frontend-stat-properties.rst b/Documentation/linux_tv/media/dvb/frontend-stat-properties.rst
index 7f3999db3e5d..0fc4aaa304ff 100644
--- a/Documentation/linux_tv/media/dvb/frontend-stat-properties.rst
+++ b/Documentation/linux_tv/media/dvb/frontend-stat-properties.rst
@@ -243,12 +243,3 @@ Possible scales for this metric are:
 
 -  ``FE_SCALE_COUNTER`` - Number of blocks counted while measuring
    :ref:`DTV_STAT_ERROR_BLOCK_COUNT <DTV-STAT-ERROR-BLOCK-COUNT>`.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/frontend.rst b/Documentation/linux_tv/media/dvb/frontend.rst
index 46be409e76b6..8c7e502bff1f 100644
--- a/Documentation/linux_tv/media/dvb/frontend.rst
+++ b/Documentation/linux_tv/media/dvb/frontend.rst
@@ -49,14 +49,3 @@ Horn (LNBf). It supports the DiSEqC and V-SEC protocols. The DiSEqC
     dvbproperty
     frontend_fcalls
     frontend_legacy_dvbv3_api
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/frontend_f_close.rst b/Documentation/linux_tv/media/dvb/frontend_f_close.rst
index faae1c7381e2..8ca7f723ffc3 100644
--- a/Documentation/linux_tv/media/dvb/frontend_f_close.rst
+++ b/Documentation/linux_tv/media/dvb/frontend_f_close.rst
@@ -44,12 +44,3 @@ set appropriately. Possible error codes:
 
 EBADF
     ``fd`` is not a valid open file descriptor.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/frontend_f_open.rst b/Documentation/linux_tv/media/dvb/frontend_f_open.rst
index bdc9a8139444..ba9fbb17f70d 100644
--- a/Documentation/linux_tv/media/dvb/frontend_f_open.rst
+++ b/Documentation/linux_tv/media/dvb/frontend_f_open.rst
@@ -97,12 +97,3 @@ ENFILE
 
 ENODEV
     The device got removed.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/frontend_fcalls.rst b/Documentation/linux_tv/media/dvb/frontend_fcalls.rst
index 8eae0e9461ab..b03f9cab6d5a 100644
--- a/Documentation/linux_tv/media/dvb/frontend_fcalls.rst
+++ b/Documentation/linux_tv/media/dvb/frontend_fcalls.rst
@@ -22,14 +22,3 @@ Frontend Function Calls
     fe-set-voltage
     fe-enable-high-lnb-voltage
     fe-set-frontend-tune-mode
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/frontend_h.rst b/Documentation/linux_tv/media/dvb/frontend_h.rst
index 3f616c6bd01d..7101d6ddd916 100644
--- a/Documentation/linux_tv/media/dvb/frontend_h.rst
+++ b/Documentation/linux_tv/media/dvb/frontend_h.rst
@@ -11,14 +11,3 @@ DVB Frontend Header File
     :maxdepth: 1
 
     ../../frontend.h
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/frontend_legacy_api.rst b/Documentation/linux_tv/media/dvb/frontend_legacy_api.rst
index dcc62d4a8516..fb17766d887e 100644
--- a/Documentation/linux_tv/media/dvb/frontend_legacy_api.rst
+++ b/Documentation/linux_tv/media/dvb/frontend_legacy_api.rst
@@ -36,14 +36,3 @@ recommended
     FE_GET_FRONTEND
     FE_GET_EVENT
     FE_DISHNETWORK_SEND_LEGACY_CMD
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/frontend_legacy_dvbv3_api.rst b/Documentation/linux_tv/media/dvb/frontend_legacy_dvbv3_api.rst
index 1dbff41f6a34..7d4a091b7d7f 100644
--- a/Documentation/linux_tv/media/dvb/frontend_legacy_dvbv3_api.rst
+++ b/Documentation/linux_tv/media/dvb/frontend_legacy_dvbv3_api.rst
@@ -16,14 +16,3 @@ applications.
     :maxdepth: 1
 
     frontend_legacy_api
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/intro.rst b/Documentation/linux_tv/media/dvb/intro.rst
index 0508f0d2c9db..338300b11aa4 100644
--- a/Documentation/linux_tv/media/dvb/intro.rst
+++ b/Documentation/linux_tv/media/dvb/intro.rst
@@ -193,12 +193,3 @@ partial path like:
 To enable applications to support different API version, an additional
 include file ``linux/dvb/version.h`` exists, which defines the constant
 ``DVB_API_VERSION``. This document describes ``DVB_API_VERSION 5.10``.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/legacy_dvb_apis.rst b/Documentation/linux_tv/media/dvb/legacy_dvb_apis.rst
index 15e0d88c2866..2957f5a988b0 100644
--- a/Documentation/linux_tv/media/dvb/legacy_dvb_apis.rst
+++ b/Documentation/linux_tv/media/dvb/legacy_dvb_apis.rst
@@ -18,14 +18,3 @@ Controller API
 
     video
     audio
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/net.rst b/Documentation/linux_tv/media/dvb/net.rst
index 830076fadda2..fd2eb6171f42 100644
--- a/Documentation/linux_tv/media/dvb/net.rst
+++ b/Documentation/linux_tv/media/dvb/net.rst
@@ -208,12 +208,3 @@ RETURN VALUE
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/net_h.rst b/Documentation/linux_tv/media/dvb/net_h.rst
index 357713b4a5ef..09560db4e1c0 100644
--- a/Documentation/linux_tv/media/dvb/net_h.rst
+++ b/Documentation/linux_tv/media/dvb/net_h.rst
@@ -11,14 +11,3 @@ DVB Network Header File
     :maxdepth: 1
 
     ../../net.h
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/query-dvb-frontend-info.rst b/Documentation/linux_tv/media/dvb/query-dvb-frontend-info.rst
index a3da1b8376bc..81cd9b92a36c 100644
--- a/Documentation/linux_tv/media/dvb/query-dvb-frontend-info.rst
+++ b/Documentation/linux_tv/media/dvb/query-dvb-frontend-info.rst
@@ -11,12 +11,3 @@ the frontend capabilities. This is done using
 :ref:`FE_GET_INFO`. This ioctl will enumerate the
 DVB API version and other characteristics about the frontend, and can be
 opened either in read only or read/write mode.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/video.rst b/Documentation/linux_tv/media/dvb/video.rst
index 9783e9f344f6..60d43fb7ce22 100644
--- a/Documentation/linux_tv/media/dvb/video.rst
+++ b/Documentation/linux_tv/media/dvb/video.rst
@@ -33,14 +33,3 @@ functionality.
 
     video_types
     video_function_calls
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/video_function_calls.rst b/Documentation/linux_tv/media/dvb/video_function_calls.rst
index 39eaecd8755a..b8ea77d1f239 100644
--- a/Documentation/linux_tv/media/dvb/video_function_calls.rst
+++ b/Documentation/linux_tv/media/dvb/video_function_calls.rst
@@ -1867,14 +1867,3 @@ appropriately. The generic error codes are described at the
        -  ``EINVAL``
 
        -  input is not a valid attribute setting.
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/video_h.rst b/Documentation/linux_tv/media/dvb/video_h.rst
index 348d20c3cab7..45c12d295523 100644
--- a/Documentation/linux_tv/media/dvb/video_h.rst
+++ b/Documentation/linux_tv/media/dvb/video_h.rst
@@ -11,14 +11,3 @@ DVB Video Header File
     :maxdepth: 1
 
     ../../video.h
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/dvb/video_types.rst b/Documentation/linux_tv/media/dvb/video_types.rst
index f57233825e42..1a73751ec080 100644
--- a/Documentation/linux_tv/media/dvb/video_types.rst
+++ b/Documentation/linux_tv/media/dvb/video_types.rst
@@ -377,14 +377,3 @@ The following attributes can be set by a call to VIDEO_SET_ATTRIBUTES:
      /*    5- 3 source resolution (0=720x480/576, 1=704x480/576, 2=352x480/57 */
      /*    2    source letterboxed (1=yes, 0=no) */
      /*    0    film/camera mode (0=camera, 1=film (625/50 only)) */
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/Remote_controllers_Intro.rst b/Documentation/linux_tv/media/v4l/Remote_controllers_Intro.rst
index 5e461ac39947..3707c29d37ed 100644
--- a/Documentation/linux_tv/media/v4l/Remote_controllers_Intro.rst
+++ b/Documentation/linux_tv/media/v4l/Remote_controllers_Intro.rst
@@ -22,12 +22,3 @@ conjunction with a wide variety of different IR remotes.
 In order to allow flexibility, the Remote Controller subsystem allows
 controlling the RC-specific attributes via
 :ref:`the sysfs class nodes <remote_controllers_sysfs_nodes>`.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/Remote_controllers_table_change.rst b/Documentation/linux_tv/media/v4l/Remote_controllers_table_change.rst
index a04cc2cbbbb3..d604896bca87 100644
--- a/Documentation/linux_tv/media/v4l/Remote_controllers_table_change.rst
+++ b/Documentation/linux_tv/media/v4l/Remote_controllers_table_change.rst
@@ -16,14 +16,3 @@ This program demonstrates how to replace the keymap tables.
     :maxdepth: 1
 
     keytable.c
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/Remote_controllers_tables.rst b/Documentation/linux_tv/media/v4l/Remote_controllers_tables.rst
index 2243d5b2dcd1..b02ff7706f80 100644
--- a/Documentation/linux_tv/media/v4l/Remote_controllers_tables.rst
+++ b/Documentation/linux_tv/media/v4l/Remote_controllers_tables.rst
@@ -755,14 +755,3 @@ at some cheaper IR's. Due to that, it is recommended to:
 
        -  On simpler IR's, without separate volume keys, you need to map
           RIGHT as ``KEY_VOLUMEUP``
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/app-pri.rst b/Documentation/linux_tv/media/v4l/app-pri.rst
index 8c4624dd50e2..a8c41a7ec396 100644
--- a/Documentation/linux_tv/media/v4l/app-pri.rst
+++ b/Documentation/linux_tv/media/v4l/app-pri.rst
@@ -28,12 +28,3 @@ different priority will usually call :ref:`VIDIOC_S_PRIORITY
 Ioctls changing driver properties, such as
 :ref:`VIDIOC_S_INPUT <VIDIOC_G_INPUT>`, return an ``EBUSY`` error code
 after another application obtained higher priority.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/async.rst b/Documentation/linux_tv/media/v4l/async.rst
index 82a56e88a54d..5affc0adb95b 100644
--- a/Documentation/linux_tv/media/v4l/async.rst
+++ b/Documentation/linux_tv/media/v4l/async.rst
@@ -7,12 +7,3 @@ Asynchronous I/O
 ****************
 
 This method is not defined yet.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/audio.rst b/Documentation/linux_tv/media/v4l/audio.rst
index bc2db0d8f389..d7574fa4f2cc 100644
--- a/Documentation/linux_tv/media/v4l/audio.rst
+++ b/Documentation/linux_tv/media/v4l/audio.rst
@@ -88,12 +88,3 @@ the :ref:`VIDIOC_QUERYCAP` ioctl.
    ``tuner`` field like struct :ref:`v4l2_input <v4l2-input>`, not
    only making the API more consistent but also permitting radio devices
    with multiple tuners.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/biblio.rst b/Documentation/linux_tv/media/v4l/biblio.rst
index 44dc7deb24b2..e911df972d40 100644
--- a/Documentation/linux_tv/media/v4l/biblio.rst
+++ b/Documentation/linux_tv/media/v4l/biblio.rst
@@ -379,12 +379,3 @@ colimg
 :title:     Color Imaging: Fundamentals and Applications
 
 :author:    Erik Reinhard et al.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/buffer.rst b/Documentation/linux_tv/media/v4l/buffer.rst
index 1c6c96c37155..98bb2a8dcdeb 100644
--- a/Documentation/linux_tv/media/v4l/buffer.rst
+++ b/Documentation/linux_tv/media/v4l/buffer.rst
@@ -953,14 +953,3 @@ The :ref:`struct v4l2_timecode <v4l2-timecode>` structure is designed to hold a
        -  0x0008
 
        -  8-bit ISO characters.
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/capture-example.rst b/Documentation/linux_tv/media/v4l/capture-example.rst
index 8d35e379cea7..ac1cd057e25b 100644
--- a/Documentation/linux_tv/media/v4l/capture-example.rst
+++ b/Documentation/linux_tv/media/v4l/capture-example.rst
@@ -11,14 +11,3 @@ Video Capture Example
     :maxdepth: 1
 
     capture.c
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/capture.c.rst b/Documentation/linux_tv/media/v4l/capture.c.rst
index 41e96c78a6dd..ff481e783c39 100644
--- a/Documentation/linux_tv/media/v4l/capture.c.rst
+++ b/Documentation/linux_tv/media/v4l/capture.c.rst
@@ -662,14 +662,3 @@ file: media/v4l/capture.c
             fprintf(stderr, "\\n");
             return 0;
     }
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/colorspaces.rst b/Documentation/linux_tv/media/v4l/colorspaces.rst
index 85d0b33b60a3..322eb94c1d44 100644
--- a/Documentation/linux_tv/media/v4l/colorspaces.rst
+++ b/Documentation/linux_tv/media/v4l/colorspaces.rst
@@ -161,12 +161,3 @@ website is an excellent resource, especially with respect to the
 mathematics behind colorspace conversions. The wikipedia
 `CIE 1931 colorspace <http://en.wikipedia.org/wiki/CIE_1931_color_space#CIE_xy_chromaticity_diagram_and_the_CIE_xyY_color_space>`__
 article is also very useful.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/common-defs.rst b/Documentation/linux_tv/media/v4l/common-defs.rst
index 3f90a8c6e28c..39058216b630 100644
--- a/Documentation/linux_tv/media/v4l/common-defs.rst
+++ b/Documentation/linux_tv/media/v4l/common-defs.rst
@@ -11,14 +11,3 @@ Common definitions for V4L2 and V4L2 subdev interfaces
     :maxdepth: 1
 
     selections-common
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/common.rst b/Documentation/linux_tv/media/v4l/common.rst
index 40d3feab5ab9..13f2ed3fc5a6 100644
--- a/Documentation/linux_tv/media/v4l/common.rst
+++ b/Documentation/linux_tv/media/v4l/common.rst
@@ -44,14 +44,3 @@ applicable to all devices.
     crop
     selection-api
     streaming-par
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/compat.rst b/Documentation/linux_tv/media/v4l/compat.rst
index 8a6d883ae6af..8b5e1cebd8f4 100644
--- a/Documentation/linux_tv/media/v4l/compat.rst
+++ b/Documentation/linux_tv/media/v4l/compat.rst
@@ -16,14 +16,3 @@ writers to port or update their code.
 
     diff-v4l
     hist-v4l2
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/control.rst b/Documentation/linux_tv/media/v4l/control.rst
index 4f64f1db6ec8..92abac784979 100644
--- a/Documentation/linux_tv/media/v4l/control.rst
+++ b/Documentation/linux_tv/media/v4l/control.rst
@@ -531,12 +531,3 @@ more menu type controls.
    instead of using :ref:`VIDIOC_QUERYCTRL` with
    the ``V4L2_CTRL_FLAG_NEXT_CTRL`` flag to enumerate all IDs, so
    support for ``V4L2_CID_PRIVATE_BASE`` is still around.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/crop.rst b/Documentation/linux_tv/media/v4l/crop.rst
index 16d0983ff9fb..ed43b36c51d8 100644
--- a/Documentation/linux_tv/media/v4l/crop.rst
+++ b/Documentation/linux_tv/media/v4l/crop.rst
@@ -292,12 +292,3 @@ change ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` for other types of device.
 
     dwidth = format.fmt.pix.width / aspect;
     dheight = format.fmt.pix.height;
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/depth-formats.rst b/Documentation/linux_tv/media/v4l/depth-formats.rst
index c363eaf741f5..82f183870aae 100644
--- a/Documentation/linux_tv/media/v4l/depth-formats.rst
+++ b/Documentation/linux_tv/media/v4l/depth-formats.rst
@@ -13,14 +13,3 @@ Depth data provides distance to points, mapped onto the image plane
     :maxdepth: 1
 
     pixfmt-z16
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/dev-capture.rst b/Documentation/linux_tv/media/v4l/dev-capture.rst
index 0e62dc026251..c927b7834b90 100644
--- a/Documentation/linux_tv/media/v4l/dev-capture.rst
+++ b/Documentation/linux_tv/media/v4l/dev-capture.rst
@@ -100,12 +100,3 @@ Reading Images
 A video capture device may support the :ref:`read() function <rw>`
 and/or streaming (:ref:`memory mapping <mmap>` or
 :ref:`user pointer <userp>`) I/O. See :ref:`io` for details.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/dev-codec.rst b/Documentation/linux_tv/media/v4l/dev-codec.rst
index 170954acc049..5e834d51309e 100644
--- a/Documentation/linux_tv/media/v4l/dev-codec.rst
+++ b/Documentation/linux_tv/media/v4l/dev-codec.rst
@@ -30,12 +30,3 @@ the codec and reprogram it whenever another file handler gets access.
 This is different from the usual video node behavior where the video
 properties are global to the device (i.e. changing something through one
 file handle is visible through another file handle).
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/dev-effect.rst b/Documentation/linux_tv/media/v4l/dev-effect.rst
index c0cdfe07ff4d..be4de3b0a025 100644
--- a/Documentation/linux_tv/media/v4l/dev-effect.rst
+++ b/Documentation/linux_tv/media/v4l/dev-effect.rst
@@ -20,12 +20,3 @@ data either with :ref:`read() <func-read>` and
 mechanism.
 
 [to do]
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/dev-event.rst b/Documentation/linux_tv/media/v4l/dev-event.rst
index 385a8a342903..a06ec4d65359 100644
--- a/Documentation/linux_tv/media/v4l/dev-event.rst
+++ b/Documentation/linux_tv/media/v4l/dev-event.rst
@@ -45,12 +45,3 @@ events:
    is lost, but only an intermediate step leading up to that
    information. See the documentation for the event you want to
    subscribe to whether this is applicable for that event or not.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/dev-osd.rst b/Documentation/linux_tv/media/v4l/dev-osd.rst
index 8b05e3f0587d..ebc2f77d0e97 100644
--- a/Documentation/linux_tv/media/v4l/dev-osd.rst
+++ b/Documentation/linux_tv/media/v4l/dev-osd.rst
@@ -143,12 +143,3 @@ Enabling Overlay
 
 There is no V4L2 ioctl to enable or disable the overlay, however the
 framebuffer interface of the driver may support the ``FBIOBLANK`` ioctl.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/dev-output.rst b/Documentation/linux_tv/media/v4l/dev-output.rst
index 5253498db95a..5063be7d4938 100644
--- a/Documentation/linux_tv/media/v4l/dev-output.rst
+++ b/Documentation/linux_tv/media/v4l/dev-output.rst
@@ -97,12 +97,3 @@ Writing Images
 A video output device may support the :ref:`write() function <rw>`
 and/or streaming (:ref:`memory mapping <mmap>` or
 :ref:`user pointer <userp>`) I/O. See :ref:`io` for details.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/dev-overlay.rst b/Documentation/linux_tv/media/v4l/dev-overlay.rst
index dd786b6fc936..97b41ecb9e78 100644
--- a/Documentation/linux_tv/media/v4l/dev-overlay.rst
+++ b/Documentation/linux_tv/media/v4l/dev-overlay.rst
@@ -317,12 +317,3 @@ To start or stop the frame buffer overlay applications call the
    because the application and graphics system are not aware these
    regions need to be refreshed. The driver should clip out more pixels
    or not write the image at all.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/dev-radio.rst b/Documentation/linux_tv/media/v4l/dev-radio.rst
index 55a56fb5d958..5ff7cded2591 100644
--- a/Documentation/linux_tv/media/v4l/dev-radio.rst
+++ b/Documentation/linux_tv/media/v4l/dev-radio.rst
@@ -50,12 +50,3 @@ depending on the selected frequency. The
 :ref:`VIDIOC_G_TUNER <VIDIOC_G_TUNER>` or
 :ref:`VIDIOC_G_MODULATOR <VIDIOC_G_MODULATOR>` ioctl reports the
 supported frequency range.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst b/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst
index 20942bf9232e..659196499b32 100644
--- a/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst
+++ b/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst
@@ -357,12 +357,3 @@ another process.
    Most VBI services transmit on both fields, but some have different
    semantics depending on the field number. These cannot be reliable
    decoded or encoded when ``V4L2_VBI_UNSYNC`` is set.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/dev-rds.rst b/Documentation/linux_tv/media/v4l/dev-rds.rst
index 223df4971405..87209fd691f5 100644
--- a/Documentation/linux_tv/media/v4l/dev-rds.rst
+++ b/Documentation/linux_tv/media/v4l/dev-rds.rst
@@ -253,14 +253,3 @@ RDS datastructures
        -  0x80
 
        -  An uncorrectable error occurred.
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/dev-sdr.rst b/Documentation/linux_tv/media/v4l/dev-sdr.rst
index 0cae31c93dd0..834488ab7147 100644
--- a/Documentation/linux_tv/media/v4l/dev-sdr.rst
+++ b/Documentation/linux_tv/media/v4l/dev-sdr.rst
@@ -118,12 +118,3 @@ data transfer, set by the driver in order to inform application.
 
 An SDR device may support :ref:`read/write <rw>` and/or streaming
 (:ref:`memory mapping <mmap>` or :ref:`user pointer <userp>`) I/O.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst b/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst
index 0b299b51aceb..4c14f39bbc80 100644
--- a/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst
+++ b/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst
@@ -793,12 +793,3 @@ number).
 .. [1]
    According to :ref:`ETS 300 706 <ets300706>` lines 6-22 of the first
    field and lines 5-22 of the second field may carry Teletext data.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/dev-subdev.rst b/Documentation/linux_tv/media/v4l/dev-subdev.rst
index 87a2cec37645..f40aa5187ba5 100644
--- a/Documentation/linux_tv/media/v4l/dev-subdev.rst
+++ b/Documentation/linux_tv/media/v4l/dev-subdev.rst
@@ -489,14 +489,3 @@ source pads.
     :maxdepth: 1
 
     subdev-formats
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/dev-teletext.rst b/Documentation/linux_tv/media/v4l/dev-teletext.rst
index 501e68077af2..2648f6b37ea3 100644
--- a/Documentation/linux_tv/media/v4l/dev-teletext.rst
+++ b/Documentation/linux_tv/media/v4l/dev-teletext.rst
@@ -32,12 +32,3 @@ Teletext API in kernel 2.6.37.
 
 Modern devices all use the :ref:`raw <raw-vbi>` or
 :ref:`sliced` VBI API.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/devices.rst b/Documentation/linux_tv/media/v4l/devices.rst
index dee6d10e2900..aed0ce11d1f8 100644
--- a/Documentation/linux_tv/media/v4l/devices.rst
+++ b/Documentation/linux_tv/media/v4l/devices.rst
@@ -24,14 +24,3 @@ Interfaces
     dev-sdr
     dev-event
     dev-subdev
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/diff-v4l.rst b/Documentation/linux_tv/media/v4l/diff-v4l.rst
index da4b391116b5..301e1475ca70 100644
--- a/Documentation/linux_tv/media/v4l/diff-v4l.rst
+++ b/Documentation/linux_tv/media/v4l/diff-v4l.rst
@@ -952,12 +952,3 @@ devices is documented in :ref:`extended-controls`.
 .. [9]
    Old driver versions used different values, eventually the custom
    ``BTTV_VBISIZE`` ioctl was added to query the correct values.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/dmabuf.rst b/Documentation/linux_tv/media/v4l/dmabuf.rst
index 6f4f0f03e91d..cd68f755c0e3 100644
--- a/Documentation/linux_tv/media/v4l/dmabuf.rst
+++ b/Documentation/linux_tv/media/v4l/dmabuf.rst
@@ -147,12 +147,3 @@ Drivers implementing DMABUF importing I/O must support the
 ``VIDIOC_REQBUFS``, ``VIDIOC_QBUF``, ``VIDIOC_DQBUF``,
 ``VIDIOC_STREAMON`` and ``VIDIOC_STREAMOFF`` ioctls, and the
 :c:func:`select()` and :c:func:`poll()` functions.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/driver.rst b/Documentation/linux_tv/media/v4l/driver.rst
index 7ed48861c6fe..2319b383f0a4 100644
--- a/Documentation/linux_tv/media/v4l/driver.rst
+++ b/Documentation/linux_tv/media/v4l/driver.rst
@@ -7,12 +7,3 @@ V4L2 Driver Programming
 ***********************
 
 to do
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/dv-timings.rst b/Documentation/linux_tv/media/v4l/dv-timings.rst
index cde46bc95c79..415a0c4e2ccb 100644
--- a/Documentation/linux_tv/media/v4l/dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/dv-timings.rst
@@ -36,12 +36,3 @@ the DV timings as seen by the video receiver applications use the
 Applications can make use of the :ref:`input-capabilities` and
 :ref:`output-capabilities` flags to determine whether the digital
 video ioctls can be used with the given input or output.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/extended-controls.rst b/Documentation/linux_tv/media/v4l/extended-controls.rst
index 413f6ca8eb60..ed10c9e274f5 100644
--- a/Documentation/linux_tv/media/v4l/extended-controls.rst
+++ b/Documentation/linux_tv/media/v4l/extended-controls.rst
@@ -4522,12 +4522,3 @@ RF_TUNER Control IDs
 .. [1]
    This control may be changed to a menu control in the future, if more
    options are required.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/fdl-appendix.rst b/Documentation/linux_tv/media/v4l/fdl-appendix.rst
index 9f3a494cf497..fd475180fed8 100644
--- a/Documentation/linux_tv/media/v4l/fdl-appendix.rst
+++ b/Documentation/linux_tv/media/v4l/fdl-appendix.rst
@@ -469,12 +469,3 @@ recommend releasing these examples in parallel under your choice of free
 software license, such as the
 `GNU General Public License <http://www.gnu.org/copyleft/gpl.html>`__,
 to permit their use in free software.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/field-order.rst b/Documentation/linux_tv/media/v4l/field-order.rst
index 0ab52df521a8..b9503e230fd9 100644
--- a/Documentation/linux_tv/media/v4l/field-order.rst
+++ b/Documentation/linux_tv/media/v4l/field-order.rst
@@ -197,14 +197,3 @@ should have the value ``V4L2_FIELD_ANY`` (0).
     :align:  center
 
     Field Order, Bottom Field First Transmitted
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/format.rst b/Documentation/linux_tv/media/v4l/format.rst
index e9b1201fe316..a29dd9466b8f 100644
--- a/Documentation/linux_tv/media/v4l/format.rst
+++ b/Documentation/linux_tv/media/v4l/format.rst
@@ -90,12 +90,3 @@ by all drivers exchanging image data with applications.
    (otherwise it could explicitly ask for them and need not enumerate)
    seems useless, but there are applications serving as proxy between
    drivers and the actual video applications for which this is useful.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/func-close.rst b/Documentation/linux_tv/media/v4l/func-close.rst
index 991a34a163af..fac5ec14a8e6 100644
--- a/Documentation/linux_tv/media/v4l/func-close.rst
+++ b/Documentation/linux_tv/media/v4l/func-close.rst
@@ -45,12 +45,3 @@ set appropriately. Possible error codes:
 
 EBADF
     ``fd`` is not a valid open file descriptor.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/func-ioctl.rst b/Documentation/linux_tv/media/v4l/func-ioctl.rst
index 26b072cfe850..d442d9b56dfb 100644
--- a/Documentation/linux_tv/media/v4l/func-ioctl.rst
+++ b/Documentation/linux_tv/media/v4l/func-ioctl.rst
@@ -58,12 +58,3 @@ appropriately. The generic error codes are described at the
 
 When an ioctl that takes an output or read/write parameter fails, the
 parameter remains unmodified.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/func-mmap.rst b/Documentation/linux_tv/media/v4l/func-mmap.rst
index 51502a906c3c..a0be2d9b5421 100644
--- a/Documentation/linux_tv/media/v4l/func-mmap.rst
+++ b/Documentation/linux_tv/media/v4l/func-mmap.rst
@@ -130,12 +130,3 @@ EINVAL
 ENOMEM
     Not enough physical or virtual memory was available to complete the
     request.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/func-munmap.rst b/Documentation/linux_tv/media/v4l/func-munmap.rst
index 80f9ecd92774..1f9831795db7 100644
--- a/Documentation/linux_tv/media/v4l/func-munmap.rst
+++ b/Documentation/linux_tv/media/v4l/func-munmap.rst
@@ -54,12 +54,3 @@ On success :c:func:`munmap()` returns 0, on failure -1 and the
 EINVAL
     The ``start`` or ``length`` is incorrect, or no buffers have been
     mapped yet.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/func-open.rst b/Documentation/linux_tv/media/v4l/func-open.rst
index dcfce511e273..c021772a9dee 100644
--- a/Documentation/linux_tv/media/v4l/func-open.rst
+++ b/Documentation/linux_tv/media/v4l/func-open.rst
@@ -79,12 +79,3 @@ EMFILE
 ENFILE
     The limit on the total number of files open on the system has been
     reached.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/func-poll.rst b/Documentation/linux_tv/media/v4l/func-poll.rst
index 3e96d9b0ce38..bfbcec2bb0cd 100644
--- a/Documentation/linux_tv/media/v4l/func-poll.rst
+++ b/Documentation/linux_tv/media/v4l/func-poll.rst
@@ -107,12 +107,3 @@ EINTR
 
 EINVAL
     The ``nfds`` argument is greater than ``OPEN_MAX``.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/func-read.rst b/Documentation/linux_tv/media/v4l/func-read.rst
index 4a4f3e86fd13..9238ecddec72 100644
--- a/Documentation/linux_tv/media/v4l/func-read.rst
+++ b/Documentation/linux_tv/media/v4l/func-read.rst
@@ -127,12 +127,3 @@ EIO
 EINVAL
     The :c:func:`read()` function is not supported by this driver, not
     on this device, or generally not on this type of device.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/func-select.rst b/Documentation/linux_tv/media/v4l/func-select.rst
index de5583c4ffb3..5f2ff6a5e00c 100644
--- a/Documentation/linux_tv/media/v4l/func-select.rst
+++ b/Documentation/linux_tv/media/v4l/func-select.rst
@@ -97,12 +97,3 @@ EINVAL
    The Linux kernel implements :c:func:`select()` like the
    :ref:`poll() <func-poll>` function, but :c:func:`select()` cannot
    return a ``POLLERR``.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/func-write.rst b/Documentation/linux_tv/media/v4l/func-write.rst
index 402beed3231c..fee5fe004c0a 100644
--- a/Documentation/linux_tv/media/v4l/func-write.rst
+++ b/Documentation/linux_tv/media/v4l/func-write.rst
@@ -78,12 +78,3 @@ EIO
 EINVAL
     The :c:func:`write()` function is not supported by this driver,
     not on this device, or generally not on this type of device.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/gen-errors.rst b/Documentation/linux_tv/media/v4l/gen-errors.rst
index ad119579e9ea..500a2f73ffd9 100644
--- a/Documentation/linux_tv/media/v4l/gen-errors.rst
+++ b/Documentation/linux_tv/media/v4l/gen-errors.rst
@@ -98,12 +98,3 @@ errors.
 
 Note 2: Request-specific error codes are listed in the individual
 requests descriptions.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/hist-v4l2.rst b/Documentation/linux_tv/media/v4l/hist-v4l2.rst
index 6e9706f791de..88f813ad38c6 100644
--- a/Documentation/linux_tv/media/v4l/hist-v4l2.rst
+++ b/Documentation/linux_tv/media/v4l/hist-v4l2.rst
@@ -1478,12 +1478,3 @@ should not be implemented in new drivers.
 
 .. [1]
    This is not implemented in XFree86.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/io.rst b/Documentation/linux_tv/media/v4l/io.rst
index 77d13fdd1c28..e68342606ed3 100644
--- a/Documentation/linux_tv/media/v4l/io.rst
+++ b/Documentation/linux_tv/media/v4l/io.rst
@@ -49,14 +49,3 @@ The following sections describe the various I/O methods in more detail.
     async
     buffer
     field-order
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/keytable.c.rst b/Documentation/linux_tv/media/v4l/keytable.c.rst
index c69833ca2fb7..f8d9c4b71f06 100644
--- a/Documentation/linux_tv/media/v4l/keytable.c.rst
+++ b/Documentation/linux_tv/media/v4l/keytable.c.rst
@@ -174,14 +174,3 @@ file: media/v4l/keytable.c
             }
             return 0;
     }
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/libv4l-introduction.rst b/Documentation/linux_tv/media/v4l/libv4l-introduction.rst
index d189316dc1da..4b261d95c672 100644
--- a/Documentation/linux_tv/media/v4l/libv4l-introduction.rst
+++ b/Documentation/linux_tv/media/v4l/libv4l-introduction.rst
@@ -167,12 +167,3 @@ API.
 
 It allows usage of binary legacy applications that still don't use
 libv4l.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/libv4l.rst b/Documentation/linux_tv/media/v4l/libv4l.rst
index a88c52812f14..332c1d42688b 100644
--- a/Documentation/linux_tv/media/v4l/libv4l.rst
+++ b/Documentation/linux_tv/media/v4l/libv4l.rst
@@ -11,14 +11,3 @@ Libv4l Userspace Library
     :maxdepth: 1
 
     libv4l-introduction
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/lirc_dev_intro.rst b/Documentation/linux_tv/media/v4l/lirc_dev_intro.rst
index 10d4d9a96b15..520660114f99 100644
--- a/Documentation/linux_tv/media/v4l/lirc_dev_intro.rst
+++ b/Documentation/linux_tv/media/v4l/lirc_dev_intro.rst
@@ -26,12 +26,3 @@ What you should see for a chardev:
     $ ls -l /dev/lirc*
 
     crw-rw---- 1 root root 248, 0 Jul 2 22:20 /dev/lirc0
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/lirc_device_interface.rst b/Documentation/linux_tv/media/v4l/lirc_device_interface.rst
index 7f7bb6815013..a0c27ed5ad73 100644
--- a/Documentation/linux_tv/media/v4l/lirc_device_interface.rst
+++ b/Documentation/linux_tv/media/v4l/lirc_device_interface.rst
@@ -13,14 +13,3 @@ LIRC Device Interface
     lirc_read
     lirc_write
     lirc_ioctl
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/lirc_ioctl.rst b/Documentation/linux_tv/media/v4l/lirc_ioctl.rst
index 947c3bf9ae07..916d064476f1 100644
--- a/Documentation/linux_tv/media/v4l/lirc_ioctl.rst
+++ b/Documentation/linux_tv/media/v4l/lirc_ioctl.rst
@@ -154,12 +154,3 @@ Return Value
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/lirc_read.rst b/Documentation/linux_tv/media/v4l/lirc_read.rst
index eb2387521862..b0b76c3d1d9a 100644
--- a/Documentation/linux_tv/media/v4l/lirc_read.rst
+++ b/Documentation/linux_tv/media/v4l/lirc_read.rst
@@ -17,12 +17,3 @@ chardev.
 See also
 `http://www.lirc.org/html/technical.html <http://www.lirc.org/html/technical.html>`__
 for more info.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/lirc_write.rst b/Documentation/linux_tv/media/v4l/lirc_write.rst
index 234c8f43613e..d19cb486ecc9 100644
--- a/Documentation/linux_tv/media/v4l/lirc_write.rst
+++ b/Documentation/linux_tv/media/v4l/lirc_write.rst
@@ -12,12 +12,3 @@ The data must start and end with a pulse, therefore, the data must
 always include an uneven number of samples. The write function must
 block until the data has been transmitted by the hardware. If more data
 is provided than the hardware can send, the driver returns ``EINVAL``.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/media-controller-intro.rst b/Documentation/linux_tv/media/v4l/media-controller-intro.rst
index e7e0d5cfe9ca..3e776c0d8276 100644
--- a/Documentation/linux_tv/media/v4l/media-controller-intro.rst
+++ b/Documentation/linux_tv/media/v4l/media-controller-intro.rst
@@ -31,12 +31,3 @@ applications really require based on limited information, thereby
 implementing policies that belong to userspace.
 
 The media controller API aims at solving those problems.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/media-controller-model.rst b/Documentation/linux_tv/media/v4l/media-controller-model.rst
index c9abb8e14302..7be58aecb882 100644
--- a/Documentation/linux_tv/media/v4l/media-controller-model.rst
+++ b/Documentation/linux_tv/media/v4l/media-controller-model.rst
@@ -33,12 +33,3 @@ are:
 
 -  An **interface link** is a point-to-point bidirectional control
    connection between a Linux Kernel interface and an entity.m
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/media-controller.rst b/Documentation/linux_tv/media/v4l/media-controller.rst
index 4fd39178ccd7..49fb76cafcab 100644
--- a/Documentation/linux_tv/media/v4l/media-controller.rst
+++ b/Documentation/linux_tv/media/v4l/media-controller.rst
@@ -55,12 +55,3 @@ Revision and Copyright
 :revision: 1.0.0 / 2010-11-10 (*lp*)
 
 Initial revision
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/media-func-close.rst b/Documentation/linux_tv/media/v4l/media-func-close.rst
index e142ee73d15d..959bfa0cb6a8 100644
--- a/Documentation/linux_tv/media/v4l/media-func-close.rst
+++ b/Documentation/linux_tv/media/v4l/media-func-close.rst
@@ -43,12 +43,3 @@ Return Value
 
 EBADF
     ``fd`` is not a valid open file descriptor.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/media-func-ioctl.rst b/Documentation/linux_tv/media/v4l/media-func-ioctl.rst
index 7a5c01d6cb4a..d7a3a01771ec 100644
--- a/Documentation/linux_tv/media/v4l/media-func-ioctl.rst
+++ b/Documentation/linux_tv/media/v4l/media-func-ioctl.rst
@@ -63,12 +63,3 @@ descriptions.
 
 When an ioctl that takes an output or read/write parameter fails, the
 parameter remains unmodified.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/media-func-open.rst b/Documentation/linux_tv/media/v4l/media-func-open.rst
index 573292ac9a94..fc731060a726 100644
--- a/Documentation/linux_tv/media/v4l/media-func-open.rst
+++ b/Documentation/linux_tv/media/v4l/media-func-open.rst
@@ -65,12 +65,3 @@ ENOMEM
 
 ENXIO
     No device corresponding to this device special file exists.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/media-ioc-device-info.rst b/Documentation/linux_tv/media/v4l/media-ioc-device-info.rst
index 230f9fd9b4fb..aca9c8aa736a 100644
--- a/Documentation/linux_tv/media/v4l/media-ioc-device-info.rst
+++ b/Documentation/linux_tv/media/v4l/media-ioc-device-info.rst
@@ -138,12 +138,3 @@ Return Value
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/media-ioc-enum-entities.rst b/Documentation/linux_tv/media/v4l/media-ioc-enum-entities.rst
index 6d2deba8dea8..8fe1f1966640 100644
--- a/Documentation/linux_tv/media/v4l/media-ioc-enum-entities.rst
+++ b/Documentation/linux_tv/media/v4l/media-ioc-enum-entities.rst
@@ -193,12 +193,3 @@ appropriately. The generic error codes are described at the
 EINVAL
     The struct :ref:`media_entity_desc <media-entity-desc>` ``id``
     references a non-existing entity.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/media-ioc-enum-links.rst b/Documentation/linux_tv/media/v4l/media-ioc-enum-links.rst
index f3a4e41b3696..b0d4a946e151 100644
--- a/Documentation/linux_tv/media/v4l/media-ioc-enum-links.rst
+++ b/Documentation/linux_tv/media/v4l/media-ioc-enum-links.rst
@@ -169,12 +169,3 @@ appropriately. The generic error codes are described at the
 EINVAL
     The struct :ref:`media_links_enum <media-links-enum>` ``id``
     references a non-existing entity.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/media-ioc-g-topology.rst b/Documentation/linux_tv/media/v4l/media-ioc-g-topology.rst
index f22310319264..6d530dc2a92c 100644
--- a/Documentation/linux_tv/media/v4l/media-ioc-g-topology.rst
+++ b/Documentation/linux_tv/media/v4l/media-ioc-g-topology.rst
@@ -425,12 +425,3 @@ ENOSPC
     last time this ioctl was called. Userspace should usually free the
     area for the pointers, zero the struct elements and call this ioctl
     again.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/media-ioc-setup-link.rst b/Documentation/linux_tv/media/v4l/media-ioc-setup-link.rst
index 5b9c44e4ee77..135fa782dcd2 100644
--- a/Documentation/linux_tv/media/v4l/media-ioc-setup-link.rst
+++ b/Documentation/linux_tv/media/v4l/media-ioc-setup-link.rst
@@ -64,12 +64,3 @@ EINVAL
     The struct :ref:`media_link_desc <media-link-desc>` references a
     non-existing link, or the link is immutable and an attempt to modify
     its configuration was made.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/media-types.rst b/Documentation/linux_tv/media/v4l/media-types.rst
index 50dec2b6cb3a..6a2d001babc2 100644
--- a/Documentation/linux_tv/media/v4l/media-types.rst
+++ b/Documentation/linux_tv/media/v4l/media-types.rst
@@ -420,14 +420,3 @@ must be set for every pad.
 
           ``MEDIA_LNK_FL_INTERFACE_LINK`` if the link is between an
           interface and an entity
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/mmap.rst b/Documentation/linux_tv/media/v4l/mmap.rst
index 5f7450ff16c2..5769ed36872f 100644
--- a/Documentation/linux_tv/media/v4l/mmap.rst
+++ b/Documentation/linux_tv/media/v4l/mmap.rst
@@ -275,12 +275,3 @@ the :c:func:`mmap()`, :c:func:`munmap()`, :c:func:`select()` and
    At the driver level :c:func:`select()` and :c:func:`poll()` are
    the same, and :c:func:`select()` is too important to be optional.
    The rest should be evident.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/open.rst b/Documentation/linux_tv/media/v4l/open.rst
index 83f406957cf4..c349575efc03 100644
--- a/Documentation/linux_tv/media/v4l/open.rst
+++ b/Documentation/linux_tv/media/v4l/open.rst
@@ -155,12 +155,3 @@ sections.
 .. [3]
    Drivers could recognize the ``O_EXCL`` open flag. Presently this is
    not required, so applications cannot know if it really works.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-002.rst b/Documentation/linux_tv/media/v4l/pixfmt-002.rst
index a0c8c2298bdd..1645d07eeedb 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-002.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-002.rst
@@ -194,14 +194,3 @@ Single-planar format structure
        -  This information supplements the ``colorspace`` and must be set by
           the driver for capture streams and by the application for output
           streams, see :ref:`colorspaces`.
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-003.rst b/Documentation/linux_tv/media/v4l/pixfmt-003.rst
index cc8ef6137618..5abbfdf23289 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-003.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-003.rst
@@ -164,14 +164,3 @@ describing all planes of that format.
 
        -  Reserved for future extensions. Should be zeroed by drivers and
           applications.
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-004.rst b/Documentation/linux_tv/media/v4l/pixfmt-004.rst
index 86d4975a95c9..4bc116aa8193 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-004.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-004.rst
@@ -49,12 +49,3 @@ memory buffer, but it can also be placed in two or three separate
 buffers, with Y component in one buffer and CbCr components in another
 in the 2-planar version or with each component in its own buffer in the
 3-planar case. Those sub-buffers are referred to as "*planes*".
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-006.rst b/Documentation/linux_tv/media/v4l/pixfmt-006.rst
index 89a990745111..19e6a85b3400 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-006.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-006.rst
@@ -278,14 +278,3 @@ R'G'B' quantization.
        -  Use the limited range quantization encoding. I.e. the range [0…1]
           is mapped to [16…235]. Cb and Cr are mapped from [-0.5…0.5] to
           [16…240].
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-007.rst b/Documentation/linux_tv/media/v4l/pixfmt-007.rst
index 7caceea855a0..5e39cda6147a 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-007.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-007.rst
@@ -892,12 +892,3 @@ will have to set that information explicitly. Effectively
 ``V4L2_COLORSPACE_JPEG`` can be considered to be an abbreviation for
 ``V4L2_COLORSPACE_SRGB``, ``V4L2_YCBCR_ENC_601`` and
 ``V4L2_QUANTIZATION_FULL_RANGE``.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-008.rst b/Documentation/linux_tv/media/v4l/pixfmt-008.rst
index ef3daf1a5487..4bec79784bdd 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-008.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-008.rst
@@ -30,12 +30,3 @@ Transfer function:
 Inverse Transfer function:
     L = (max(L':sup:`1/m2` - c1, 0) / (c2 - c3 *
     L'\ :sup:`1/m2`))\ :sup:`1/m1`
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-013.rst b/Documentation/linux_tv/media/v4l/pixfmt-013.rst
index b3cb7c48eb74..1f27e081a874 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-013.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-013.rst
@@ -127,14 +127,3 @@ Compressed Formats
        -  'VP80'
 
        -  VP8 video elementary stream.
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-grey.rst b/Documentation/linux_tv/media/v4l/pixfmt-grey.rst
index 7a9bfe0ec53a..e1e19d558d59 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-grey.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-grey.rst
@@ -76,14 +76,3 @@ Each cell is one byte.
        -  Y'\ :sub:`32`
 
        -  Y'\ :sub:`33`
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-indexed.rst b/Documentation/linux_tv/media/v4l/pixfmt-indexed.rst
index a85b9832035e..dccf96b3d9c4 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-indexed.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-indexed.rst
@@ -71,14 +71,3 @@ the palette, this must be done with ioctls of the Linux framebuffer API.
        -  i\ :sub:`1`
 
        -  i\ :sub:`0`
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-m420.rst b/Documentation/linux_tv/media/v4l/pixfmt-m420.rst
index 553618ab62cf..4434ee1b1be9 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-m420.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-m420.rst
@@ -225,14 +225,3 @@ Each cell is one byte.
 
        -  
        -  Y
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv12.rst b/Documentation/linux_tv/media/v4l/pixfmt-nv12.rst
index ffbc9390e5bb..df26d495c892 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-nv12.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-nv12.rst
@@ -228,14 +228,3 @@ Each cell is one byte.
 
        -  
        -  Y
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst b/Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst
index 4a181af07724..c7db4038609a 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst
@@ -243,14 +243,3 @@ Each cell is one byte.
 
        -  
        -  Y
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv12mt.rst b/Documentation/linux_tv/media/v4l/pixfmt-nv12mt.rst
index 8b0b4d1812a0..6198941bb814 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-nv12mt.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-nv12mt.rst
@@ -60,12 +60,3 @@ interleaved. Height of the buffer is aligned to 32.
 
 Memory layout of macroblocks of ``V4L2_PIX_FMT_NV12MT`` format in most
 extreme case.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv16.rst b/Documentation/linux_tv/media/v4l/pixfmt-nv16.rst
index 4c3c638dec33..a82f46c77d2d 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-nv16.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-nv16.rst
@@ -277,14 +277,3 @@ Each cell is one byte.
        -  C
 
        -  
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst b/Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst
index e250f2c0bc7a..f6a82defe492 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst
@@ -284,14 +284,3 @@ Each cell is one byte.
        -  C
 
        -  
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv24.rst b/Documentation/linux_tv/media/v4l/pixfmt-nv24.rst
index 5b9716079c25..c0a8ddfd6963 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-nv24.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-nv24.rst
@@ -169,14 +169,3 @@ Each cell is one byte.
        -  Cb\ :sub:`33`
 
        -  Cr\ :sub:`33`
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-packed-rgb.rst b/Documentation/linux_tv/media/v4l/pixfmt-packed-rgb.rst
index 2b4a6c725d4c..517a5b42151c 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-packed-rgb.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-packed-rgb.rst
@@ -1468,12 +1468,3 @@ A test utility to determine which RGB formats a driver actually supports
 is available from the LinuxTV v4l-dvb repository. See
 `https://linuxtv.org/repo/ <https://linuxtv.org/repo/>`__ for access
 instructions.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-packed-yuv.rst b/Documentation/linux_tv/media/v4l/pixfmt-packed-yuv.rst
index 095871a50436..70d0ad54bd22 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-packed-yuv.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-packed-yuv.rst
@@ -314,12 +314,3 @@ Bit 7 is the most significant bit. The value of a = alpha bits is
 undefined when reading from the driver, ignored when writing to the
 driver, except when alpha blending has been negotiated for a
 :ref:`Video Overlay <overlay>` or :ref:`Video Output Overlay <osd>`.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-reserved.rst b/Documentation/linux_tv/media/v4l/pixfmt-reserved.rst
index 072f2843c137..73301b512b1a 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-reserved.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-reserved.rst
@@ -358,14 +358,3 @@ please make a proposal on the linux-media mailing list.
           by RGBA values (128, 192, 255, 128), the same pixel described with
           premultiplied colors would be described by RGBA values (64, 96,
           128, 128)
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-rgb.rst b/Documentation/linux_tv/media/v4l/pixfmt-rgb.rst
index aa607332af25..4b3651cc0a96 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-rgb.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-rgb.rst
@@ -21,14 +21,3 @@ RGB Formats
     pixfmt-srggb10alaw8
     pixfmt-srggb10dpcm8
     pixfmt-srggb12
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sbggr16.rst b/Documentation/linux_tv/media/v4l/pixfmt-sbggr16.rst
index 9c1cf6d76bb6..742816ad4d41 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-sbggr16.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-sbggr16.rst
@@ -112,14 +112,3 @@ Each cell is one byte.
        -  R\ :sub:`33low`
 
        -  R\ :sub:`33high`
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sbggr8.rst b/Documentation/linux_tv/media/v4l/pixfmt-sbggr8.rst
index 85d6d1f6e6d9..9a8e7d27e660 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-sbggr8.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-sbggr8.rst
@@ -80,14 +80,3 @@ Each cell is one byte.
        -  G\ :sub:`32`
 
        -  R\ :sub:`33`
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sdr-cs08.rst b/Documentation/linux_tv/media/v4l/pixfmt-sdr-cs08.rst
index e75129d83def..201901d3f4c5 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-sdr-cs08.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-sdr-cs08.rst
@@ -42,14 +42,3 @@ Each cell is one byte.
        -  start + 1:
 
        -  Q'\ :sub:`0`
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sdr-cs14le.rst b/Documentation/linux_tv/media/v4l/pixfmt-sdr-cs14le.rst
index cc94ffd90444..c7e471fe722f 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-sdr-cs14le.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-sdr-cs14le.rst
@@ -47,14 +47,3 @@ Each cell is one byte.
        -  Q'\ :sub:`0[7:0]`
 
        -  Q'\ :sub:`0[13:8]`
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sdr-cu08.rst b/Documentation/linux_tv/media/v4l/pixfmt-sdr-cu08.rst
index 95c7b40b2d72..f97559ebcab5 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-sdr-cu08.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-sdr-cu08.rst
@@ -42,14 +42,3 @@ Each cell is one byte.
        -  start + 1:
 
        -  Q'\ :sub:`0`
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sdr-cu16le.rst b/Documentation/linux_tv/media/v4l/pixfmt-sdr-cu16le.rst
index cc9891dd9c4b..ee73006bdb23 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-sdr-cu16le.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-sdr-cu16le.rst
@@ -46,14 +46,3 @@ Each cell is one byte.
        -  Q'\ :sub:`0[7:0]`
 
        -  Q'\ :sub:`0[15:8]`
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sdr-ru12le.rst b/Documentation/linux_tv/media/v4l/pixfmt-sdr-ru12le.rst
index 8bcead790b3e..7147e6cfe6d9 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-sdr-ru12le.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-sdr-ru12le.rst
@@ -37,14 +37,3 @@ Each cell is one byte.
        -  I'\ :sub:`0[7:0]`
 
        -  I'\ :sub:`0[11:8]`
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sgbrg8.rst b/Documentation/linux_tv/media/v4l/pixfmt-sgbrg8.rst
index efcd5269815f..8d783f332eaa 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-sgbrg8.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-sgbrg8.rst
@@ -80,14 +80,3 @@ Each cell is one byte.
        -  R\ :sub:`32`
 
        -  G\ :sub:`33`
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sgrbg8.rst b/Documentation/linux_tv/media/v4l/pixfmt-sgrbg8.rst
index fd7506f17a2c..04b93d9335a6 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-sgrbg8.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-sgrbg8.rst
@@ -80,14 +80,3 @@ Each cell is one byte.
        -  B\ :sub:`32`
 
        -  G\ :sub:`33`
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-srggb10.rst b/Documentation/linux_tv/media/v4l/pixfmt-srggb10.rst
index b8b2b7c3cd91..2ad8ef04ad32 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-srggb10.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-srggb10.rst
@@ -116,14 +116,3 @@ Each cell is one byte, high 6 bits in high bytes are 0.
        -  R\ :sub:`33low`
 
        -  R\ :sub:`33high`
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-srggb10alaw8.rst b/Documentation/linux_tv/media/v4l/pixfmt-srggb10alaw8.rst
index 045c7a91203a..4e221629bcb3 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-srggb10alaw8.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-srggb10alaw8.rst
@@ -21,12 +21,3 @@ These four pixel formats are raw sRGB / Bayer formats with 10 bits per
 color compressed to 8 bits each, using the A-LAW algorithm. Each color
 component consumes 8 bits of memory. In other respects this format is
 similar to :ref:`V4L2-PIX-FMT-SRGGB8`.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-srggb10dpcm8.rst b/Documentation/linux_tv/media/v4l/pixfmt-srggb10dpcm8.rst
index 03a27c43be21..23e7db7333ba 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-srggb10dpcm8.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-srggb10dpcm8.rst
@@ -22,12 +22,3 @@ colour compressed to 8 bits each, using DPCM compression. DPCM,
 differential pulse-code modulation, is lossy. Each colour component
 consumes 8 bits of memory. In other respects this format is similar to
 :ref:`V4L2-PIX-FMT-SRGGB10`.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-srggb10p.rst b/Documentation/linux_tv/media/v4l/pixfmt-srggb10p.rst
index 503dd3050e02..fe2908e37d06 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-srggb10p.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-srggb10p.rst
@@ -99,14 +99,3 @@ Each cell is one byte.
 
        -  G\ :sub:`30low`\ (bits 7--6) R\ :sub:`31low`\ (bits 5--4)
           G\ :sub:`32low`\ (bits 3--2) R\ :sub:`33low`\ (bits 1--0)
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-srggb12.rst b/Documentation/linux_tv/media/v4l/pixfmt-srggb12.rst
index fa10223104d7..fa2efa33be66 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-srggb12.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-srggb12.rst
@@ -116,14 +116,3 @@ Each cell is one byte, high 6 bits in high bytes are 0.
        -  R\ :sub:`33low`
 
        -  R\ :sub:`33high`
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-srggb8.rst b/Documentation/linux_tv/media/v4l/pixfmt-srggb8.rst
index b208ea5a2f66..eb3f6b5e39ca 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-srggb8.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-srggb8.rst
@@ -80,14 +80,3 @@ Each cell is one byte.
        -  G\ :sub:`32`
 
        -  B\ :sub:`33`
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-uv8.rst b/Documentation/linux_tv/media/v4l/pixfmt-uv8.rst
index 6e126e905ec8..033cedf85f57 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-uv8.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-uv8.rst
@@ -75,14 +75,3 @@ Each cell is one byte.
        -  Cb\ :sub:`31`
 
        -  Cr\ :sub:`31`
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-uyvy.rst b/Documentation/linux_tv/media/v4l/pixfmt-uyvy.rst
index fcdfb36c58c2..1184dd629d21 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-uyvy.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-uyvy.rst
@@ -203,14 +203,3 @@ Each cell is one byte.
        -  C
 
        -  Y
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-vyuy.rst b/Documentation/linux_tv/media/v4l/pixfmt-vyuy.rst
index b086bed774b2..7e25aee4f968 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-vyuy.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-vyuy.rst
@@ -203,14 +203,3 @@ Each cell is one byte.
        -  C
 
        -  Y
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-y10.rst b/Documentation/linux_tv/media/v4l/pixfmt-y10.rst
index 000dc5536cb4..bb3f3229d8e5 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-y10.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-y10.rst
@@ -109,14 +109,3 @@ Each cell is one byte.
        -  Y'\ :sub:`33low`
 
        -  Y'\ :sub:`33high`
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-y10b.rst b/Documentation/linux_tv/media/v4l/pixfmt-y10b.rst
index 83b7080643d5..5b50cd61e654 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-y10b.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-y10b.rst
@@ -43,14 +43,3 @@ pixels.
        -  Y'\ :sub:`02[5:0]`\ Y'\ :sub:`03[9:8]`
 
        -  Y'\ :sub:`03[7:0]`
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-y12.rst b/Documentation/linux_tv/media/v4l/pixfmt-y12.rst
index 66c16aa8b3d5..24c59c911fee 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-y12.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-y12.rst
@@ -109,14 +109,3 @@ Each cell is one byte.
        -  Y'\ :sub:`33low`
 
        -  Y'\ :sub:`33high`
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-y12i.rst b/Documentation/linux_tv/media/v4l/pixfmt-y12i.rst
index 18fffaef7f31..82a39faaad08 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-y12i.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-y12i.rst
@@ -46,14 +46,3 @@ interleaved pixel.
        -  Y'\ :sub:`0right[3:0]`\ Y'\ :sub:`0left[11:8]`
 
        -  Y'\ :sub:`0right[11:4]`
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-y16-be.rst b/Documentation/linux_tv/media/v4l/pixfmt-y16-be.rst
index 05fef3841ed7..6dcd9251659d 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-y16-be.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-y16-be.rst
@@ -110,14 +110,3 @@ Each cell is one byte.
        -  Y'\ :sub:`33high`
 
        -  Y'\ :sub:`33low`
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-y16.rst b/Documentation/linux_tv/media/v4l/pixfmt-y16.rst
index b3c766feb4c6..cc1565f37db8 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-y16.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-y16.rst
@@ -110,14 +110,3 @@ Each cell is one byte.
        -  Y'\ :sub:`33low`
 
        -  Y'\ :sub:`33high`
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-y41p.rst b/Documentation/linux_tv/media/v4l/pixfmt-y41p.rst
index d050d27e7ea1..bb10de3da994 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-y41p.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-y41p.rst
@@ -300,14 +300,3 @@ Each cell is one byte.
 
        -  
        -  Y
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-y8i.rst b/Documentation/linux_tv/media/v4l/pixfmt-y8i.rst
index 69ec8d7e8a06..3f3dbf18357f 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-y8i.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-y8i.rst
@@ -110,14 +110,3 @@ Each cell is one byte.
        -  Y'\ :sub:`33left`
 
        -  Y'\ :sub:`33right`
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv410.rst b/Documentation/linux_tv/media/v4l/pixfmt-yuv410.rst
index f56902f6faed..642c20a038b6 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-yuv410.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-yuv410.rst
@@ -206,14 +206,3 @@ Each cell is one byte.
 
        -  
        -  Y
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv411p.rst b/Documentation/linux_tv/media/v4l/pixfmt-yuv411p.rst
index bf4fa56b8efb..0fe1cacf7b7a 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-yuv411p.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-yuv411p.rst
@@ -224,14 +224,3 @@ Each cell is one byte.
 
        -  
        -  Y
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv420.rst b/Documentation/linux_tv/media/v4l/pixfmt-yuv420.rst
index 0dd7e4632dd9..106afed50125 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-yuv420.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-yuv420.rst
@@ -238,14 +238,3 @@ Each cell is one byte.
 
        -  
        -  Y
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv420m.rst b/Documentation/linux_tv/media/v4l/pixfmt-yuv420m.rst
index 5f918d0d1498..dc3d395a5731 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-yuv420m.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-yuv420m.rst
@@ -252,14 +252,3 @@ Each cell is one byte.
 
        -  
        -  Y
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv422m.rst b/Documentation/linux_tv/media/v4l/pixfmt-yuv422m.rst
index 625d4ccf73d9..d8e438857e14 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-yuv422m.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-yuv422m.rst
@@ -261,14 +261,3 @@ Each cell is one byte.
        -  C
 
        -  Y
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv422p.rst b/Documentation/linux_tv/media/v4l/pixfmt-yuv422p.rst
index d21794b48496..a7934540f69a 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-yuv422p.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-yuv422p.rst
@@ -244,14 +244,3 @@ Each cell is one byte.
        -  C
 
        -  Y
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv444m.rst b/Documentation/linux_tv/media/v4l/pixfmt-yuv444m.rst
index 3d25c5e0ca00..c70e74631d4d 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-yuv444m.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-yuv444m.rst
@@ -281,14 +281,3 @@ Each cell is one byte.
 
        -  
        -  YC
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuyv.rst b/Documentation/linux_tv/media/v4l/pixfmt-yuyv.rst
index 2fed9b3c87c3..9f01ae03bd10 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-yuyv.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-yuyv.rst
@@ -204,14 +204,3 @@ Each cell is one byte.
        -  C
 
        -  Y
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yvyu.rst b/Documentation/linux_tv/media/v4l/pixfmt-yvyu.rst
index 40eb6eda9fb1..45e3dcd7d222 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-yvyu.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-yvyu.rst
@@ -203,14 +203,3 @@ Each cell is one byte.
        -  C
 
        -  Y
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-z16.rst b/Documentation/linux_tv/media/v4l/pixfmt-z16.rst
index 25badab393ce..8804dd5cc1c0 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-z16.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-z16.rst
@@ -110,14 +110,3 @@ Each cell is one byte.
        -  Z\ :sub:`33low`
 
        -  Z\ :sub:`33high`
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/pixfmt.rst b/Documentation/linux_tv/media/v4l/pixfmt.rst
index 417796d39f00..81222a99f7ce 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt.rst
@@ -33,14 +33,3 @@ see also :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>`.)
     pixfmt-013
     sdr-formats
     pixfmt-reserved
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/planar-apis.rst b/Documentation/linux_tv/media/v4l/planar-apis.rst
index db1e63bd691e..5fe2e1188230 100644
--- a/Documentation/linux_tv/media/v4l/planar-apis.rst
+++ b/Documentation/linux_tv/media/v4l/planar-apis.rst
@@ -59,12 +59,3 @@ Calls that distinguish between single and multi-planar APIs
 
 :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>`
     Will allocate multi-planar buffers as requested.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/querycap.rst b/Documentation/linux_tv/media/v4l/querycap.rst
index f3fa6cb6befe..c19cce7a816f 100644
--- a/Documentation/linux_tv/media/v4l/querycap.rst
+++ b/Documentation/linux_tv/media/v4l/querycap.rst
@@ -32,12 +32,3 @@ specific applications to reliably identify the driver.
 
 All V4L2 drivers must support :ref:`VIDIOC_QUERYCAP`.
 Applications should always call this ioctl after opening the device.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/remote_controllers.rst b/Documentation/linux_tv/media/v4l/remote_controllers.rst
index 07add9452be2..4b36e992f59a 100644
--- a/Documentation/linux_tv/media/v4l/remote_controllers.rst
+++ b/Documentation/linux_tv/media/v4l/remote_controllers.rst
@@ -42,12 +42,3 @@ Added the interface description and the RC sysfs class description.
 :revision: 1.0 / 2009-09-06 (*mcc*)
 
 Initial revision
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/remote_controllers_sysfs_nodes.rst b/Documentation/linux_tv/media/v4l/remote_controllers_sysfs_nodes.rst
index 03d2d422d4c0..6fb944fe21fd 100644
--- a/Documentation/linux_tv/media/v4l/remote_controllers_sysfs_nodes.rst
+++ b/Documentation/linux_tv/media/v4l/remote_controllers_sysfs_nodes.rst
@@ -141,12 +141,3 @@ scancodes which match the filter will wake the system from e.g. suspend
 to RAM or power off. Otherwise the write will fail with an error.
 
 This value may be reset to 0 if the wakeup protocol is altered.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/rw.rst b/Documentation/linux_tv/media/v4l/rw.rst
index beab37eccb1a..9dc58651ef02 100644
--- a/Documentation/linux_tv/media/v4l/rw.rst
+++ b/Documentation/linux_tv/media/v4l/rw.rst
@@ -45,12 +45,3 @@ driver must also support the :ref:`select() <func-select>` and
 .. [2]
    At the driver level :c:func:`select()` and :c:func:`poll()` are
    the same, and :c:func:`select()` is too important to be optional.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/sdr-formats.rst b/Documentation/linux_tv/media/v4l/sdr-formats.rst
index 78c373c5b678..f863c08f1add 100644
--- a/Documentation/linux_tv/media/v4l/sdr-formats.rst
+++ b/Documentation/linux_tv/media/v4l/sdr-formats.rst
@@ -17,14 +17,3 @@ These formats are used for :ref:`SDR <sdr>` interface only.
     pixfmt-sdr-cs08
     pixfmt-sdr-cs14le
     pixfmt-sdr-ru12le
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/selection-api-002.rst b/Documentation/linux_tv/media/v4l/selection-api-002.rst
index d1b2bc3d22e5..09ca93f91bf7 100644
--- a/Documentation/linux_tv/media/v4l/selection-api-002.rst
+++ b/Documentation/linux_tv/media/v4l/selection-api-002.rst
@@ -26,12 +26,3 @@ Rectangles for all cropping and composing targets are defined even if
 the device does supports neither cropping nor composing. Their size and
 position will be fixed in such a case. If the device does not support
 scaling then the cropping and composing rectangles have the same size.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/selection-api-003.rst b/Documentation/linux_tv/media/v4l/selection-api-003.rst
index 9769d87407aa..15cb3b79f12c 100644
--- a/Documentation/linux_tv/media/v4l/selection-api-003.rst
+++ b/Documentation/linux_tv/media/v4l/selection-api-003.rst
@@ -18,12 +18,3 @@ Selection targets
 
 
 See :ref:`v4l2-selection-targets` for more information.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/selection-api-004.rst b/Documentation/linux_tv/media/v4l/selection-api-004.rst
index 1a8f4d09bff1..d782cd5b2117 100644
--- a/Documentation/linux_tv/media/v4l/selection-api-004.rst
+++ b/Documentation/linux_tv/media/v4l/selection-api-004.rst
@@ -135,12 +135,3 @@ and the height of rectangles obtained using ``V4L2_SEL_TGT_CROP`` and
 ``V4L2_SEL_TGT_COMPOSE`` targets. If these are not equal then the
 scaling is applied. The application can compute the scaling ratios using
 these values.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/selection-api-005.rst b/Documentation/linux_tv/media/v4l/selection-api-005.rst
index 78448023a79a..94731a13efdb 100644
--- a/Documentation/linux_tv/media/v4l/selection-api-005.rst
+++ b/Documentation/linux_tv/media/v4l/selection-api-005.rst
@@ -32,12 +32,3 @@ struct :ref:`v4l2_selection <v4l2-selection>` provides a lot of place
 for future extensions. Driver developers are encouraged to implement
 only selection API. The former cropping API would be simulated using the
 new one.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/selection-api-006.rst b/Documentation/linux_tv/media/v4l/selection-api-006.rst
index a7c04879cb5d..54b769e2fd73 100644
--- a/Documentation/linux_tv/media/v4l/selection-api-006.rst
+++ b/Documentation/linux_tv/media/v4l/selection-api-006.rst
@@ -79,14 +79,3 @@ for other devices
         /* computing scaling factors */
         hscale = (double)compose.r.width / crop.r.width;
         vscale = (double)compose.r.height / crop.r.height;
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/selection-api.rst b/Documentation/linux_tv/media/v4l/selection-api.rst
index 1cc3b41b8435..81ea52d785b9 100644
--- a/Documentation/linux_tv/media/v4l/selection-api.rst
+++ b/Documentation/linux_tv/media/v4l/selection-api.rst
@@ -14,14 +14,3 @@ API for cropping, composing and scaling
     selection-api-004
     selection-api-005
     selection-api-006
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/selections-common.rst b/Documentation/linux_tv/media/v4l/selections-common.rst
index 93efdc398fa9..69dbce4e6e47 100644
--- a/Documentation/linux_tv/media/v4l/selections-common.rst
+++ b/Documentation/linux_tv/media/v4l/selections-common.rst
@@ -21,14 +21,3 @@ on the two APIs.
 
     v4l2-selection-targets
     v4l2-selection-flags
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/standard.rst b/Documentation/linux_tv/media/v4l/standard.rst
index 67e295daa054..49135e260acc 100644
--- a/Documentation/linux_tv/media/v4l/standard.rst
+++ b/Documentation/linux_tv/media/v4l/standard.rst
@@ -177,12 +177,3 @@ standard ioctls can be used with the given input or output.
    Some users are already confused by technical terms PAL, NTSC and
    SECAM. There is no point asking them to distinguish between B, G, D,
    or K when the software or hardware can do that automatically.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/streaming-par.rst b/Documentation/linux_tv/media/v4l/streaming-par.rst
index 643bad8cfc1a..b07b0f0b35d4 100644
--- a/Documentation/linux_tv/media/v4l/streaming-par.rst
+++ b/Documentation/linux_tv/media/v4l/streaming-par.rst
@@ -31,12 +31,3 @@ devices.
 
 These ioctls are optional, drivers need not implement them. If so, they
 return the ``EINVAL`` error code.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/subdev-formats.rst b/Documentation/linux_tv/media/v4l/subdev-formats.rst
index a13c0cba3df0..02a4b20fb1e8 100644
--- a/Documentation/linux_tv/media/v4l/subdev-formats.rst
+++ b/Documentation/linux_tv/media/v4l/subdev-formats.rst
@@ -11688,14 +11688,3 @@ formats.
 
        -  Interleaved raw UYVY and JPEG image format with embedded meta-data
           used by Samsung S3C73MX camera sensors.
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/tuner.rst b/Documentation/linux_tv/media/v4l/tuner.rst
index 9c98e4f64c85..23d0e00aefdd 100644
--- a/Documentation/linux_tv/media/v4l/tuner.rst
+++ b/Documentation/linux_tv/media/v4l/tuner.rst
@@ -80,12 +80,3 @@ a pointer to a struct :ref:`v4l2_frequency <v4l2-frequency>`. These
 ioctls are used for TV and radio devices alike. Drivers must support
 both ioctls when the tuner or modulator ioctls are supported, or when
 the device is a radio device.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/user-func.rst b/Documentation/linux_tv/media/v4l/user-func.rst
index daa6fd465d30..3e0413b83a33 100644
--- a/Documentation/linux_tv/media/v4l/user-func.rst
+++ b/Documentation/linux_tv/media/v4l/user-func.rst
@@ -79,14 +79,3 @@ Function Reference
     func-read
     func-select
     func-write
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/userp.rst b/Documentation/linux_tv/media/v4l/userp.rst
index 23ef4b71444d..3f4df1fd984d 100644
--- a/Documentation/linux_tv/media/v4l/userp.rst
+++ b/Documentation/linux_tv/media/v4l/userp.rst
@@ -112,12 +112,3 @@ Drivers implementing user pointer I/O must support the
    At the driver level :c:func:`select()` and :c:func:`poll()` are
    the same, and :c:func:`select()` is too important to be optional.
    The rest should be evident.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/v4l2-selection-flags.rst b/Documentation/linux_tv/media/v4l/v4l2-selection-flags.rst
index d72d3fb0d057..6c3531fd0017 100644
--- a/Documentation/linux_tv/media/v4l/v4l2-selection-flags.rst
+++ b/Documentation/linux_tv/media/v4l/v4l2-selection-flags.rst
@@ -69,14 +69,3 @@ Selection flags
        -  No
 
        -  Yes
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/v4l2-selection-targets.rst b/Documentation/linux_tv/media/v4l/v4l2-selection-targets.rst
index 781c4c713394..e9dcff094c77 100644
--- a/Documentation/linux_tv/media/v4l/v4l2-selection-targets.rst
+++ b/Documentation/linux_tv/media/v4l/v4l2-selection-targets.rst
@@ -133,14 +133,3 @@ of the two interfaces they are used.
        -  Yes
 
        -  No
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/v4l2.rst b/Documentation/linux_tv/media/v4l/v4l2.rst
index c9ba2859ebe5..9284446e3cfa 100644
--- a/Documentation/linux_tv/media/v4l/v4l2.rst
+++ b/Documentation/linux_tv/media/v4l/v4l2.rst
@@ -391,12 +391,3 @@ Second draft, with corrections pointed out by Gerd Knorr.
 
 First draft, based on documentation by Bill Dirks and discussions on the
 V4L mailing list.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/v4l2grab-example.rst b/Documentation/linux_tv/media/v4l/v4l2grab-example.rst
index 8b933d7a341a..c240f0513bee 100644
--- a/Documentation/linux_tv/media/v4l/v4l2grab-example.rst
+++ b/Documentation/linux_tv/media/v4l/v4l2grab-example.rst
@@ -15,14 +15,3 @@ with any V4L2 driver.
     :maxdepth: 1
 
     v4l2grab.c
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/v4l2grab.c.rst b/Documentation/linux_tv/media/v4l/v4l2grab.c.rst
index 6934294e61d9..817cad406c6f 100644
--- a/Documentation/linux_tv/media/v4l/v4l2grab.c.rst
+++ b/Documentation/linux_tv/media/v4l/v4l2grab.c.rst
@@ -167,14 +167,3 @@ file: media/v4l/v4l2grab.c
 
             return 0;
     }
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/video.rst b/Documentation/linux_tv/media/v4l/video.rst
index b8ecc774719c..b3c2b1d59f24 100644
--- a/Documentation/linux_tv/media/v4l/video.rst
+++ b/Documentation/linux_tv/media/v4l/video.rst
@@ -61,14 +61,3 @@ all the output ioctls when the device has one or more outputs.
         perror("VIDIOC_S_INPUT");
         exit(EXIT_FAILURE);
     }
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/videodev.rst b/Documentation/linux_tv/media/v4l/videodev.rst
index 4d1f26a90a68..4826416b2ab4 100644
--- a/Documentation/linux_tv/media/v4l/videodev.rst
+++ b/Documentation/linux_tv/media/v4l/videodev.rst
@@ -11,14 +11,3 @@ Video For Linux Two Header File
     :maxdepth: 1
 
     ../../videodev2.h
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst b/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
index efd9629e099e..0535758fec14 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
@@ -143,12 +143,3 @@ ENOMEM
 EINVAL
     The buffer type (``format.type`` field), requested I/O method
     (``memory``) or format (``format`` field) is not valid.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-cropcap.rst b/Documentation/linux_tv/media/v4l/vidioc-cropcap.rst
index 22c4268ea54f..8391fc19126f 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-cropcap.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-cropcap.rst
@@ -164,12 +164,3 @@ appropriately. The generic error codes are described at the
 EINVAL
     The struct :ref:`v4l2_cropcap <v4l2-cropcap>` ``type`` is
     invalid.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst b/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst
index 7fc1e6b3e892..da8bd46288dc 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst
@@ -201,12 +201,3 @@ appropriately. The generic error codes are described at the
 
 EINVAL
     The ``match_type`` is invalid or no device could be matched.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst b/Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst
index 2c5afc9a4012..c1b21f3f73f0 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst
@@ -207,12 +207,3 @@ appropriately. The generic error codes are described at the
 EPERM
     Insufficient permissions. Root privileges are required to execute
     these ioctls.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst b/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst
index 3fd1da8c1132..5f7be4ee8a51 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst
@@ -269,12 +269,3 @@ EINVAL
 EPERM
     The application sent a PAUSE or RESUME command when the decoder was
     not running.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dqevent.rst b/Documentation/linux_tv/media/v4l/vidioc-dqevent.rst
index 509f0df19746..ed37e07bbdc8 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-dqevent.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-dqevent.rst
@@ -570,12 +570,3 @@ Return Value
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst b/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst
index dbfc5e92faf3..e852b6194f4a 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst
@@ -248,12 +248,3 @@ Return Value
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst b/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst
index b62b508c83a7..cd7cc4bfd756 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst
@@ -193,12 +193,3 @@ EINVAL
 EPERM
     The application sent a PAUSE or RESUME command when the encoder was
     not running.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst
index a3deae4844f5..1ff64c497ff1 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst
@@ -117,12 +117,3 @@ EINVAL
 
 ENODATA
     Digital video presets are not supported for this input or output.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst
index a8b162ed85a0..79162755ea75 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst
@@ -161,12 +161,3 @@ appropriately. The generic error codes are described at the
 EINVAL
     The struct :ref:`v4l2_fmtdesc <v4l2-fmtdesc>` ``type`` is not
     supported or the ``index`` is out of bounds.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst
index 24acbd928b9c..f7e41225e6b6 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst
@@ -271,12 +271,3 @@ Return Value
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst
index 1d2969220857..ef9bcdee0635 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst
@@ -288,12 +288,3 @@ Return Value
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst
index bc0826bec1cb..5e4a6d4a8640 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst
@@ -187,12 +187,3 @@ appropriately. The generic error codes are described at the
 EINVAL
     The ``tuner`` or ``index`` is out of bounds or the ``type`` field is
     wrong.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst b/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst
index 51d783734107..9573e54271fc 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst
@@ -52,12 +52,3 @@ appropriately. The generic error codes are described at the
 
 EINVAL
     The number of the audio input is out of bounds.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst b/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst
index 660bcee62fcf..82ffb3194ed3 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst
@@ -55,12 +55,3 @@ appropriately. The generic error codes are described at the
 
 EINVAL
     The number of the audio output is out of bounds.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst b/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst
index 7344777e3514..b67cae1bcafd 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst
@@ -364,12 +364,3 @@ appropriately. The generic error codes are described at the
 EINVAL
     The struct :ref:`v4l2_input <v4l2-input>` ``index`` is out of
     bounds.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst b/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst
index de0952353ad0..8dc5f8ee2eb5 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst
@@ -219,12 +219,3 @@ appropriately. The generic error codes are described at the
 EINVAL
     The struct :ref:`v4l2_output <v4l2-output>` ``index`` is out of
     bounds.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst b/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
index 0f4433cefc49..098251b8be30 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
@@ -439,12 +439,3 @@ ENODATA
    may be used in addition to the main sound carrier. It is modulated in
    differentially encoded QPSK with a 728 kbit/s sound and data
    multiplexer capable of carrying two sound channels. (NICAM system)
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst b/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst
index 04216a0d658e..a1f62a33739f 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst
@@ -194,12 +194,3 @@ appropriately. The generic error codes are described at the
 EINVAL
     A queue is not in MMAP mode or DMABUF exporting is not supported or
     ``flags`` or ``type`` or ``index`` or ``plane`` fields are invalid.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst b/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
index abf441a04673..5ec052165642 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
@@ -160,12 +160,3 @@ appropriately. The generic error codes are described at the
 EINVAL
     No audio inputs combine with the current video input, or the number
     of the selected audio input is out of bounds or it does not combine.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst b/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst
index 6bfd5b1d5428..a2a492fccaed 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst
@@ -120,12 +120,3 @@ EINVAL
     No audio outputs combine with the current video output, or the
     number of the selected audio output is out of bounds or it does not
     combine.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst b/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
index aba0dc9b4390..1610c3fc1d93 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
@@ -111,12 +111,3 @@ Return Value
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst b/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
index 77a5d1aca78a..db1e7b252147 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
@@ -103,12 +103,3 @@ EBUSY
 
 EACCES
     Attempt to set a read-only control or to get a write-only control.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst b/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
index 2b2e154a2d1f..bd3d898acd53 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
@@ -416,14 +416,3 @@ EBUSY
           R'G'B' values use limited range (i.e. 16-235) as opposed to full
           range (i.e. 0-255). All formats defined in CEA-861 except for the
           640x480p59.94 format are CE formats.
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst b/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
index 26332ceb8b94..5a72bed87cbb 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
@@ -158,12 +158,3 @@ appropriately. The generic error codes are described at the
 
 ``E2BIG``
     The EDID data you provided is more than the hardware can handle.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst b/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst
index 35df295e1809..864a347e6b1a 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst
@@ -207,12 +207,3 @@ Return Value
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst b/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
index d12021c6fbb8..a85778172265 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
@@ -487,12 +487,3 @@ ENOSPC
 EACCES
     Attempt to try or set a read-only control or to get a write-only
     control.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst b/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
index e52361001bb9..32ce2738d598 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
@@ -498,12 +498,3 @@ EINVAL
    offset instead. If you encounter problems please discuss on the
    linux-media mailing list:
    `https://linuxtv.org/lists.php <https://linuxtv.org/lists.php>`__.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst b/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
index 869c7cc08035..684793a47267 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
@@ -187,12 +187,3 @@ appropriately. The generic error codes are described at the
 EINVAL
     The struct :ref:`v4l2_format <v4l2-format>` ``type`` field is
     invalid or the requested buffer type not supported.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst b/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst
index 40ef31938f79..c5f6846b498c 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst
@@ -121,12 +121,3 @@ EINVAL
 
 EBUSY
     A hardware seek is in progress.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-input.rst b/Documentation/linux_tv/media/v4l/vidioc-g-input.rst
index 1c14f7dcffeb..aae135ea2a77 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-input.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-input.rst
@@ -59,12 +59,3 @@ appropriately. The generic error codes are described at the
 
 EINVAL
     The number of the video input is out of bounds.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-jpegcomp.rst b/Documentation/linux_tv/media/v4l/vidioc-g-jpegcomp.rst
index b2da34012df6..0adc8b2e2aac 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-jpegcomp.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-jpegcomp.rst
@@ -180,12 +180,3 @@ Return Value
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst b/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst
index 2342e036850b..8b213e858b39 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst
@@ -253,12 +253,3 @@ appropriately. The generic error codes are described at the
 EINVAL
     The struct :ref:`v4l2_modulator <v4l2-modulator>` ``index`` is
     out of bounds.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-output.rst b/Documentation/linux_tv/media/v4l/vidioc-g-output.rst
index 03defa561e5b..cd0646eb7539 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-output.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-output.rst
@@ -61,12 +61,3 @@ appropriately. The generic error codes are described at the
 EINVAL
     The number of the video output is out of bounds, or there are no
     video outputs at all.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst b/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
index 73974cd938b8..0f96b95ebc0e 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
@@ -347,12 +347,3 @@ Return Value
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst b/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst
index b241970c8aee..f3fedd201c6d 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst
@@ -115,12 +115,3 @@ EINVAL
 
 EBUSY
     Another application already requested higher priority.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-selection.rst b/Documentation/linux_tv/media/v4l/vidioc-g-selection.rst
index 1159b012a0a1..337ad78d9a7c 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-selection.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-selection.rst
@@ -207,12 +207,3 @@ ERANGE
 EBUSY
     It is not possible to apply change of the selection rectangle at the
     moment. Usually because streaming is in progress.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst b/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst
index ac08f606fdd8..f5052093a77a 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst
@@ -273,12 +273,3 @@ appropriately. The generic error codes are described at the
 
 EINVAL
     The value in the ``type`` field is wrong.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-std.rst b/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
index 8cacecfb8c97..e1e3bb7fa726 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
@@ -65,12 +65,3 @@ EINVAL
 
 ENODATA
     Standard video timings are not supported for this input or output.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst b/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst
index c5f947811746..57a14811773c 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst
@@ -713,12 +713,3 @@ EINVAL
    future drivers should produce only the primary language in this mode.
    Applications should request ``MODE_LANG1_LANG2`` to record both
    languages or a stereo signal.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-log-status.rst b/Documentation/linux_tv/media/v4l/vidioc-log-status.rst
index af89f8f2dca6..afff82efe392 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-log-status.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-log-status.rst
@@ -37,12 +37,3 @@ Return Value
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-overlay.rst b/Documentation/linux_tv/media/v4l/vidioc-overlay.rst
index 990907643869..41ddeea5537f 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-overlay.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-overlay.rst
@@ -51,12 +51,3 @@ appropriately. The generic error codes are described at the
 EINVAL
     The overlay parameters have not been set up. See :ref:`overlay`
     for the necessary steps.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst b/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst
index bf31aaaf6c76..2c88d3cedecf 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst
@@ -58,12 +58,3 @@ EINVAL
     The buffer ``type`` is not supported, or the ``index`` is out of
     bounds, or no buffers have been allocated yet, or the ``userptr`` or
     ``length`` are invalid.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst b/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst
index b51db1311e9f..88179f8019fa 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst
@@ -147,12 +147,3 @@ EPIPE
     ``VIDIOC_DQBUF`` returns this on an empty capture queue for mem2mem
     codecs if a buffer with the ``V4L2_BUF_FLAG_LAST`` was already
     dequeued and no new buffers are expected to become available.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst b/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst
index 0c01ed49065f..6a37b6503399 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst
@@ -80,12 +80,3 @@ ENOLCK
 ERANGE
     Timings were found, but they are out of range of the hardware
     capabilities.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst b/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst
index 11c9c59688ae..2fae7021b511 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst
@@ -77,12 +77,3 @@ appropriately. The generic error codes are described at the
 EINVAL
     The buffer ``type`` is not supported, or the ``index`` is out of
     bounds.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-querycap.rst b/Documentation/linux_tv/media/v4l/vidioc-querycap.rst
index 0776232be520..a4091b482d75 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-querycap.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-querycap.rst
@@ -431,12 +431,3 @@ appropriately. The generic error codes are described at the
    The struct :ref:`v4l2_framebuffer <v4l2-framebuffer>` lacks an
    enum :ref:`v4l2_buf_type <v4l2-buf-type>` field, therefore the
    type of overlay is implied by the driver capabilities.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst b/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
index 2c8ef053a1ab..7869ca7a04c3 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
@@ -779,12 +779,3 @@ EACCES
    controls after hardware detection without the trouble of reordering
    control arrays and indices (``EINVAL`` cannot be used to skip private
    controls because it would prematurely end the enumeration).
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-querystd.rst b/Documentation/linux_tv/media/v4l/vidioc-querystd.rst
index de2fe176fc6d..8d6769f2b5c6 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-querystd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-querystd.rst
@@ -62,12 +62,3 @@ appropriately. The generic error codes are described at the
 
 ENODATA
     Standard video timings are not supported for this input or output.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst b/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst
index 065ea275c0df..b5a470935ce6 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst
@@ -122,12 +122,3 @@ appropriately. The generic error codes are described at the
 EINVAL
     The buffer type (``type`` field) or the requested I/O method
     (``memory``) is not supported.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst b/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst
index 68c96236806d..4789c5b74a0a 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst
@@ -176,12 +176,3 @@ ENODATA
 
 EBUSY
     Another hardware seek is already in progress.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-streamon.rst b/Documentation/linux_tv/media/v4l/vidioc-streamon.rst
index 960c5965c7a6..c3ea38c6cb5b 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-streamon.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-streamon.rst
@@ -100,12 +100,3 @@ EPIPE
 ENOLINK
     The driver implements Media Controller interface and the pipeline
     link configuration is invalid.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst
index 8c5298175ba5..d332897b30e8 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst
@@ -150,12 +150,3 @@ EINVAL
     ``pad`` references a non-existing pad, one of the ``code``,
     ``width`` or ``height`` fields are invalid for the given pad or the
     ``index`` field is out of bounds.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst
index 5ddb766f4a16..0f901d815ca5 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst
@@ -159,12 +159,3 @@ EINVAL
     :ref:`v4l2_subdev_frame_size_enum <v4l2-subdev-frame-size-enum>`
     ``pad`` references a non-existing pad, the ``code`` is invalid for
     the given pad or the ``index`` field is out of bounds.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst
index 13d466c2a4e1..bc8e07912d81 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst
@@ -112,12 +112,3 @@ EINVAL
     :ref:`v4l2_subdev_mbus_code_enum <v4l2-subdev-mbus-code-enum>`
     ``pad`` references a non-existing pad, or the ``index`` field is out
     of bounds.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst
index 88416ba28d86..a4cc5f8ebf5b 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst
@@ -134,12 +134,3 @@ EINVAL
     references a non-existing pad, the ``which`` field references a
     non-existing format, or cropping is not supported on the given
     subdev pad.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-fmt.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-fmt.rst
index b4d109943fd2..6afa4fccb9ba 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-fmt.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-fmt.rst
@@ -170,12 +170,3 @@ Return Value
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-frame-interval.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-frame-interval.rst
index 9504e8b5de8a..3c45d4b28f43 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-frame-interval.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-frame-interval.rst
@@ -120,12 +120,3 @@ EINVAL
     :ref:`v4l2_subdev_frame_interval <v4l2-subdev-frame-interval>`
     ``pad`` references a non-existing pad, or the pad doesn't support
     frame intervals.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-selection.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-selection.rst
index d95b5431004c..738131619a4d 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-selection.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-selection.rst
@@ -142,12 +142,3 @@ EINVAL
     ``pad`` references a non-existing pad, the ``which`` field
     references a non-existing format, or the selection target is not
     supported on the given subdev pad.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst b/Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst
index a127622d47b8..8323386c93f8 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst
@@ -133,12 +133,3 @@ Return Value
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/yuv-formats.rst b/Documentation/linux_tv/media/v4l/yuv-formats.rst
index 2592d5b8527d..3334ea445657 100644
--- a/Documentation/linux_tv/media/v4l/yuv-formats.rst
+++ b/Documentation/linux_tv/media/v4l/yuv-formats.rst
@@ -53,14 +53,3 @@ to brightness information.
     pixfmt-nv16m
     pixfmt-nv24
     pixfmt-m420
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/net.h.rst b/Documentation/linux_tv/net.h.rst
index c0a0e9310333..4b01cefdb0b7 100644
--- a/Documentation/linux_tv/net.h.rst
+++ b/Documentation/linux_tv/net.h.rst
@@ -57,14 +57,3 @@ file: net.h
 
 
     #endif /*_DVBNET_H_*/
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/video.h.rst b/Documentation/linux_tv/video.h.rst
index b332a02b8fd6..4be16680ba01 100644
--- a/Documentation/linux_tv/video.h.rst
+++ b/Documentation/linux_tv/video.h.rst
@@ -278,14 +278,3 @@ file: video.h
     #define VIDEO_TRY_COMMAND          _IOWR('o', 60, struct video_command)
 
     #endif /* _UAPI_DVBVIDEO_H_ */
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/videodev2.h.rst b/Documentation/linux_tv/videodev2.h.rst
index 78f19aff04a7..bd433ab201cc 100644
--- a/Documentation/linux_tv/videodev2.h.rst
+++ b/Documentation/linux_tv/videodev2.h.rst
@@ -2298,14 +2298,3 @@ file: videodev2.h
     #define BASE_VIDIOC_PRIVATE     192             /* 192-255 are private */
 
     #endif /* _UAPI__LINUX_VIDEODEV2_H */
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/scripts/kernel-doc b/scripts/kernel-doc
old mode 100644
new mode 100755
-- 
2.7.4


