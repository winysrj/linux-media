Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58590 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437208AbeKXFYQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Nov 2018 00:24:16 -0500
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Tian Shu Qiu <tian.shu.qiu@intel.com>,
        Jian Xu Zheng <jian.xu.zheng@intel.com>,
        Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH 2/6] media: remove text encoding from rst files
Date: Fri, 23 Nov 2018 16:38:35 -0200
Message-Id: <852e14b4dd808e47258ccb83ef88c90ca9f03629.1542997584.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1542997584.git.mchehab+samsung@kernel.org>
References: <cover.1542997584.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is not needed there. Also, the same UTF-8 encoding should
be used on all documents.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/media/cec-drivers/index.rst                       | 2 --
 Documentation/media/dvb-drivers/index.rst                       | 2 --
 Documentation/media/intro.rst                                   | 2 --
 Documentation/media/kapi/v4l2-event.rst                         | 1 -
 Documentation/media/media_kapi.rst                              | 2 --
 Documentation/media/media_uapi.rst                              | 2 --
 Documentation/media/uapi/cec/cec-api.rst                        | 2 --
 Documentation/media/uapi/cec/cec-func-close.rst                 | 2 --
 Documentation/media/uapi/cec/cec-func-ioctl.rst                 | 2 --
 Documentation/media/uapi/cec/cec-func-open.rst                  | 2 --
 Documentation/media/uapi/cec/cec-func-poll.rst                  | 2 --
 Documentation/media/uapi/cec/cec-header.rst                     | 2 --
 Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst            | 2 --
 Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst       | 2 --
 Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst       | 2 --
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst                | 2 --
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst                 | 2 --
 Documentation/media/uapi/cec/cec-ioc-receive.rst                | 2 --
 Documentation/media/uapi/dvb/audio-bilingual-channel-select.rst | 2 --
 Documentation/media/uapi/dvb/audio-channel-select.rst           | 2 --
 Documentation/media/uapi/dvb/audio-clear-buffer.rst             | 2 --
 Documentation/media/uapi/dvb/audio-continue.rst                 | 2 --
 Documentation/media/uapi/dvb/audio-fclose.rst                   | 2 --
 Documentation/media/uapi/dvb/audio-fopen.rst                    | 2 --
 Documentation/media/uapi/dvb/audio-fwrite.rst                   | 2 --
 Documentation/media/uapi/dvb/audio-get-capabilities.rst         | 2 --
 Documentation/media/uapi/dvb/audio-get-status.rst               | 2 --
 Documentation/media/uapi/dvb/audio-pause.rst                    | 2 --
 Documentation/media/uapi/dvb/audio-play.rst                     | 2 --
 Documentation/media/uapi/dvb/audio-select-source.rst            | 2 --
 Documentation/media/uapi/dvb/audio-set-av-sync.rst              | 2 --
 Documentation/media/uapi/dvb/audio-set-bypass-mode.rst          | 2 --
 Documentation/media/uapi/dvb/audio-set-id.rst                   | 2 --
 Documentation/media/uapi/dvb/audio-set-mixer.rst                | 2 --
 Documentation/media/uapi/dvb/audio-set-mute.rst                 | 2 --
 Documentation/media/uapi/dvb/audio-set-streamtype.rst           | 2 --
 Documentation/media/uapi/dvb/audio-stop.rst                     | 2 --
 Documentation/media/uapi/dvb/audio.rst                          | 2 --
 Documentation/media/uapi/dvb/audio_data_types.rst               | 2 --
 Documentation/media/uapi/dvb/audio_function_calls.rst           | 2 --
 Documentation/media/uapi/dvb/ca-fclose.rst                      | 2 --
 Documentation/media/uapi/dvb/ca-fopen.rst                       | 2 --
 Documentation/media/uapi/dvb/ca-get-cap.rst                     | 2 --
 Documentation/media/uapi/dvb/ca-get-descr-info.rst              | 2 --
 Documentation/media/uapi/dvb/ca-get-msg.rst                     | 2 --
 Documentation/media/uapi/dvb/ca-get-slot-info.rst               | 2 --
 Documentation/media/uapi/dvb/ca-reset.rst                       | 2 --
 Documentation/media/uapi/dvb/ca-send-msg.rst                    | 2 --
 Documentation/media/uapi/dvb/ca-set-descr.rst                   | 2 --
 Documentation/media/uapi/dvb/ca.rst                             | 2 --
 Documentation/media/uapi/dvb/ca_data_types.rst                  | 2 --
 Documentation/media/uapi/dvb/ca_function_calls.rst              | 2 --
 Documentation/media/uapi/dvb/demux.rst                          | 2 --
 Documentation/media/uapi/dvb/dmx-add-pid.rst                    | 2 --
 Documentation/media/uapi/dvb/dmx-fclose.rst                     | 2 --
 Documentation/media/uapi/dvb/dmx-fopen.rst                      | 2 --
 Documentation/media/uapi/dvb/dmx-fread.rst                      | 2 --
 Documentation/media/uapi/dvb/dmx-fwrite.rst                     | 2 --
 Documentation/media/uapi/dvb/dmx-get-pes-pids.rst               | 2 --
 Documentation/media/uapi/dvb/dmx-get-stc.rst                    | 2 --
 Documentation/media/uapi/dvb/dmx-remove-pid.rst                 | 2 --
 Documentation/media/uapi/dvb/dmx-set-buffer-size.rst            | 2 --
 Documentation/media/uapi/dvb/dmx-set-filter.rst                 | 2 --
 Documentation/media/uapi/dvb/dmx-set-pes-filter.rst             | 2 --
 Documentation/media/uapi/dvb/dmx-start.rst                      | 2 --
 Documentation/media/uapi/dvb/dmx-stop.rst                       | 2 --
 Documentation/media/uapi/dvb/dmx_fcalls.rst                     | 2 --
 Documentation/media/uapi/dvb/dmx_types.rst                      | 2 --
 Documentation/media/uapi/dvb/dvb-fe-read-status.rst             | 2 --
 Documentation/media/uapi/dvb/dvb-frontend-event.rst             | 2 --
 Documentation/media/uapi/dvb/dvb-frontend-parameters.rst        | 2 --
 Documentation/media/uapi/dvb/dvbapi.rst                         | 2 --
 Documentation/media/uapi/dvb/dvbproperty.rst                    | 2 --
 Documentation/media/uapi/dvb/examples.rst                       | 2 --
 Documentation/media/uapi/dvb/fe-bandwidth-t.rst                 | 2 --
 Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst     | 2 --
 Documentation/media/uapi/dvb/fe-diseqc-reset-overload.rst       | 2 --
 Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst           | 2 --
 Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst      | 2 --
 Documentation/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst | 2 --
 Documentation/media/uapi/dvb/fe-enable-high-lnb-voltage.rst     | 2 --
 Documentation/media/uapi/dvb/fe-get-event.rst                   | 2 --
 Documentation/media/uapi/dvb/fe-get-frontend.rst                | 2 --
 Documentation/media/uapi/dvb/fe-get-info.rst                    | 2 --
 Documentation/media/uapi/dvb/fe-get-property.rst                | 2 --
 Documentation/media/uapi/dvb/fe-read-ber.rst                    | 2 --
 Documentation/media/uapi/dvb/fe-read-signal-strength.rst        | 2 --
 Documentation/media/uapi/dvb/fe-read-snr.rst                    | 2 --
 Documentation/media/uapi/dvb/fe-read-status.rst                 | 2 --
 Documentation/media/uapi/dvb/fe-read-uncorrected-blocks.rst     | 2 --
 Documentation/media/uapi/dvb/fe-set-frontend-tune-mode.rst      | 2 --
 Documentation/media/uapi/dvb/fe-set-frontend.rst                | 2 --
 Documentation/media/uapi/dvb/fe-set-tone.rst                    | 2 --
 Documentation/media/uapi/dvb/fe-set-voltage.rst                 | 2 --
 Documentation/media/uapi/dvb/fe-type-t.rst                      | 2 --
 Documentation/media/uapi/dvb/fe_property_parameters.rst         | 2 --
 .../media/uapi/dvb/frontend-property-cable-systems.rst          | 2 --
 .../media/uapi/dvb/frontend-property-satellite-systems.rst      | 2 --
 .../media/uapi/dvb/frontend-property-terrestrial-systems.rst    | 2 --
 Documentation/media/uapi/dvb/frontend-stat-properties.rst       | 2 --
 Documentation/media/uapi/dvb/frontend.rst                       | 2 --
 Documentation/media/uapi/dvb/frontend_f_close.rst               | 2 --
 Documentation/media/uapi/dvb/frontend_f_open.rst                | 2 --
 Documentation/media/uapi/dvb/frontend_fcalls.rst                | 2 --
 Documentation/media/uapi/dvb/frontend_legacy_api.rst            | 2 --
 Documentation/media/uapi/dvb/frontend_legacy_dvbv3_api.rst      | 2 --
 Documentation/media/uapi/dvb/intro.rst                          | 2 --
 Documentation/media/uapi/dvb/legacy_dvb_apis.rst                | 2 --
 Documentation/media/uapi/dvb/net-add-if.rst                     | 2 --
 Documentation/media/uapi/dvb/net-get-if.rst                     | 2 --
 Documentation/media/uapi/dvb/net-remove-if.rst                  | 2 --
 Documentation/media/uapi/dvb/net-types.rst                      | 2 --
 Documentation/media/uapi/dvb/net.rst                            | 2 --
 Documentation/media/uapi/dvb/query-dvb-frontend-info.rst        | 2 --
 Documentation/media/uapi/dvb/video-clear-buffer.rst             | 2 --
 Documentation/media/uapi/dvb/video-command.rst                  | 2 --
 Documentation/media/uapi/dvb/video-continue.rst                 | 2 --
 Documentation/media/uapi/dvb/video-fast-forward.rst             | 2 --
 Documentation/media/uapi/dvb/video-fclose.rst                   | 2 --
 Documentation/media/uapi/dvb/video-fopen.rst                    | 2 --
 Documentation/media/uapi/dvb/video-freeze.rst                   | 2 --
 Documentation/media/uapi/dvb/video-fwrite.rst                   | 2 --
 Documentation/media/uapi/dvb/video-get-capabilities.rst         | 2 --
 Documentation/media/uapi/dvb/video-get-event.rst                | 2 --
 Documentation/media/uapi/dvb/video-get-frame-count.rst          | 2 --
 Documentation/media/uapi/dvb/video-get-pts.rst                  | 2 --
 Documentation/media/uapi/dvb/video-get-size.rst                 | 2 --
 Documentation/media/uapi/dvb/video-get-status.rst               | 2 --
 Documentation/media/uapi/dvb/video-play.rst                     | 2 --
 Documentation/media/uapi/dvb/video-select-source.rst            | 2 --
 Documentation/media/uapi/dvb/video-set-blank.rst                | 2 --
 Documentation/media/uapi/dvb/video-set-display-format.rst       | 2 --
 Documentation/media/uapi/dvb/video-set-format.rst               | 2 --
 Documentation/media/uapi/dvb/video-set-streamtype.rst           | 2 --
 Documentation/media/uapi/dvb/video-slowmotion.rst               | 2 --
 Documentation/media/uapi/dvb/video-stillpicture.rst             | 2 --
 Documentation/media/uapi/dvb/video-stop.rst                     | 2 --
 Documentation/media/uapi/dvb/video-try-command.rst              | 2 --
 Documentation/media/uapi/dvb/video.rst                          | 2 --
 Documentation/media/uapi/dvb/video_function_calls.rst           | 2 --
 Documentation/media/uapi/dvb/video_types.rst                    | 2 --
 Documentation/media/uapi/fdl-appendix.rst                       | 2 --
 Documentation/media/uapi/gen-errors.rst                         | 2 --
 Documentation/media/uapi/mediactl/media-controller-intro.rst    | 2 --
 Documentation/media/uapi/mediactl/media-controller-model.rst    | 2 --
 Documentation/media/uapi/mediactl/media-controller.rst          | 2 --
 Documentation/media/uapi/mediactl/media-func-close.rst          | 2 --
 Documentation/media/uapi/mediactl/media-func-ioctl.rst          | 2 --
 Documentation/media/uapi/mediactl/media-func-open.rst           | 2 --
 Documentation/media/uapi/mediactl/media-header.rst              | 2 --
 Documentation/media/uapi/mediactl/media-ioc-device-info.rst     | 2 --
 Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst   | 2 --
 Documentation/media/uapi/mediactl/media-ioc-enum-links.rst      | 2 --
 Documentation/media/uapi/mediactl/media-ioc-g-topology.rst      | 2 --
 Documentation/media/uapi/mediactl/media-ioc-setup-link.rst      | 2 --
 Documentation/media/uapi/mediactl/media-types.rst               | 2 --
 Documentation/media/uapi/rc/keytable.c.rst                      | 2 --
 Documentation/media/uapi/rc/lirc-dev-intro.rst                  | 2 --
 Documentation/media/uapi/rc/lirc-dev.rst                        | 2 --
 Documentation/media/uapi/rc/lirc-func.rst                       | 2 --
 Documentation/media/uapi/rc/lirc-get-features.rst               | 2 --
 Documentation/media/uapi/rc/lirc-get-rec-mode.rst               | 2 --
 Documentation/media/uapi/rc/lirc-get-rec-resolution.rst         | 2 --
 Documentation/media/uapi/rc/lirc-get-send-mode.rst              | 2 --
 Documentation/media/uapi/rc/lirc-get-timeout.rst                | 2 --
 Documentation/media/uapi/rc/lirc-header.rst                     | 2 --
 Documentation/media/uapi/rc/lirc-read.rst                       | 2 --
 Documentation/media/uapi/rc/lirc-set-measure-carrier-mode.rst   | 2 --
 Documentation/media/uapi/rc/lirc-set-rec-carrier-range.rst      | 2 --
 Documentation/media/uapi/rc/lirc-set-rec-carrier.rst            | 2 --
 Documentation/media/uapi/rc/lirc-set-rec-timeout-reports.rst    | 2 --
 Documentation/media/uapi/rc/lirc-set-rec-timeout.rst            | 2 --
 Documentation/media/uapi/rc/lirc-set-send-carrier.rst           | 2 --
 Documentation/media/uapi/rc/lirc-set-send-duty-cycle.rst        | 2 --
 Documentation/media/uapi/rc/lirc-set-transmitter-mask.rst       | 2 --
 Documentation/media/uapi/rc/lirc-set-wideband-receiver.rst      | 2 --
 Documentation/media/uapi/rc/lirc-write.rst                      | 2 --
 Documentation/media/uapi/rc/rc-intro.rst                        | 2 --
 Documentation/media/uapi/rc/rc-sysfs-nodes.rst                  | 2 --
 Documentation/media/uapi/rc/rc-table-change.rst                 | 2 --
 Documentation/media/uapi/rc/rc-tables.rst                       | 2 --
 Documentation/media/uapi/rc/remote_controllers.rst              | 2 --
 Documentation/media/uapi/v4l/app-pri.rst                        | 2 --
 Documentation/media/uapi/v4l/async.rst                          | 2 --
 Documentation/media/uapi/v4l/audio.rst                          | 2 --
 Documentation/media/uapi/v4l/biblio.rst                         | 2 --
 Documentation/media/uapi/v4l/buffer.rst                         | 2 --
 Documentation/media/uapi/v4l/capture-example.rst                | 2 --
 Documentation/media/uapi/v4l/capture.c.rst                      | 2 --
 Documentation/media/uapi/v4l/colorspaces-defs.rst               | 2 --
 Documentation/media/uapi/v4l/colorspaces-details.rst            | 2 --
 Documentation/media/uapi/v4l/colorspaces.rst                    | 2 --
 Documentation/media/uapi/v4l/common-defs.rst                    | 2 --
 Documentation/media/uapi/v4l/common.rst                         | 2 --
 Documentation/media/uapi/v4l/compat.rst                         | 2 --
 Documentation/media/uapi/v4l/control.rst                        | 2 --
 Documentation/media/uapi/v4l/crop.rst                           | 2 --
 Documentation/media/uapi/v4l/depth-formats.rst                  | 2 --
 Documentation/media/uapi/v4l/dev-capture.rst                    | 2 --
 Documentation/media/uapi/v4l/dev-codec.rst                      | 2 --
 Documentation/media/uapi/v4l/dev-effect.rst                     | 2 --
 Documentation/media/uapi/v4l/dev-event.rst                      | 2 --
 Documentation/media/uapi/v4l/dev-meta.rst                       | 2 --
 Documentation/media/uapi/v4l/dev-osd.rst                        | 2 --
 Documentation/media/uapi/v4l/dev-output.rst                     | 2 --
 Documentation/media/uapi/v4l/dev-overlay.rst                    | 2 --
 Documentation/media/uapi/v4l/dev-radio.rst                      | 2 --
 Documentation/media/uapi/v4l/dev-raw-vbi.rst                    | 2 --
 Documentation/media/uapi/v4l/dev-rds.rst                        | 2 --
 Documentation/media/uapi/v4l/dev-sdr.rst                        | 2 --
 Documentation/media/uapi/v4l/dev-sliced-vbi.rst                 | 2 --
 Documentation/media/uapi/v4l/dev-subdev.rst                     | 2 --
 Documentation/media/uapi/v4l/dev-teletext.rst                   | 2 --
 Documentation/media/uapi/v4l/dev-touch.rst                      | 2 --
 Documentation/media/uapi/v4l/devices.rst                        | 2 --
 Documentation/media/uapi/v4l/diff-v4l.rst                       | 2 --
 Documentation/media/uapi/v4l/dmabuf.rst                         | 2 --
 Documentation/media/uapi/v4l/dv-timings.rst                     | 2 --
 Documentation/media/uapi/v4l/extended-controls.rst              | 2 --
 Documentation/media/uapi/v4l/field-order.rst                    | 2 --
 Documentation/media/uapi/v4l/format.rst                         | 2 --
 Documentation/media/uapi/v4l/func-close.rst                     | 2 --
 Documentation/media/uapi/v4l/func-ioctl.rst                     | 2 --
 Documentation/media/uapi/v4l/func-mmap.rst                      | 2 --
 Documentation/media/uapi/v4l/func-munmap.rst                    | 2 --
 Documentation/media/uapi/v4l/func-open.rst                      | 2 --
 Documentation/media/uapi/v4l/func-poll.rst                      | 2 --
 Documentation/media/uapi/v4l/func-read.rst                      | 2 --
 Documentation/media/uapi/v4l/func-select.rst                    | 2 --
 Documentation/media/uapi/v4l/func-write.rst                     | 2 --
 Documentation/media/uapi/v4l/hist-v4l2.rst                      | 2 --
 Documentation/media/uapi/v4l/hsv-formats.rst                    | 2 --
 Documentation/media/uapi/v4l/io.rst                             | 2 --
 Documentation/media/uapi/v4l/libv4l-introduction.rst            | 2 --
 Documentation/media/uapi/v4l/libv4l.rst                         | 2 --
 Documentation/media/uapi/v4l/meta-formats.rst                   | 2 --
 Documentation/media/uapi/v4l/mmap.rst                           | 2 --
 Documentation/media/uapi/v4l/open.rst                           | 2 --
 Documentation/media/uapi/v4l/pixfmt-compressed.rst              | 2 --
 Documentation/media/uapi/v4l/pixfmt-grey.rst                    | 2 --
 Documentation/media/uapi/v4l/pixfmt-indexed.rst                 | 2 --
 Documentation/media/uapi/v4l/pixfmt-intro.rst                   | 2 --
 Documentation/media/uapi/v4l/pixfmt-inzi.rst                    | 2 --
 Documentation/media/uapi/v4l/pixfmt-m420.rst                    | 2 --
 Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst                | 2 --
 Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst           | 2 --
 Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgt.rst           | 2 --
 Documentation/media/uapi/v4l/pixfmt-nv12.rst                    | 2 --
 Documentation/media/uapi/v4l/pixfmt-nv12m.rst                   | 2 --
 Documentation/media/uapi/v4l/pixfmt-nv12mt.rst                  | 2 --
 Documentation/media/uapi/v4l/pixfmt-nv16.rst                    | 2 --
 Documentation/media/uapi/v4l/pixfmt-nv16m.rst                   | 2 --
 Documentation/media/uapi/v4l/pixfmt-nv24.rst                    | 2 --
 Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst              | 2 --
 Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst              | 2 --
 Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst              | 2 --
 Documentation/media/uapi/v4l/pixfmt-reserved.rst                | 2 --
 Documentation/media/uapi/v4l/pixfmt-rgb.rst                     | 2 --
 Documentation/media/uapi/v4l/pixfmt-sdr-cs08.rst                | 2 --
 Documentation/media/uapi/v4l/pixfmt-sdr-cs14le.rst              | 2 --
 Documentation/media/uapi/v4l/pixfmt-sdr-cu08.rst                | 2 --
 Documentation/media/uapi/v4l/pixfmt-sdr-cu16le.rst              | 2 --
 Documentation/media/uapi/v4l/pixfmt-sdr-pcu16be.rst             | 2 --
 Documentation/media/uapi/v4l/pixfmt-sdr-pcu18be.rst             | 2 --
 Documentation/media/uapi/v4l/pixfmt-sdr-pcu20be.rst             | 1 -
 Documentation/media/uapi/v4l/pixfmt-sdr-ru12le.rst              | 2 --
 Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst            | 2 --
 Documentation/media/uapi/v4l/pixfmt-srggb10.rst                 | 2 --
 Documentation/media/uapi/v4l/pixfmt-srggb10alaw8.rst            | 2 --
 Documentation/media/uapi/v4l/pixfmt-srggb10dpcm8.rst            | 2 --
 Documentation/media/uapi/v4l/pixfmt-srggb10p.rst                | 2 --
 Documentation/media/uapi/v4l/pixfmt-srggb12.rst                 | 2 --
 Documentation/media/uapi/v4l/pixfmt-srggb12p.rst                | 2 --
 Documentation/media/uapi/v4l/pixfmt-srggb14p.rst                | 2 --
 Documentation/media/uapi/v4l/pixfmt-srggb16.rst                 | 2 --
 Documentation/media/uapi/v4l/pixfmt-srggb8.rst                  | 2 --
 Documentation/media/uapi/v4l/pixfmt-tch-td08.rst                | 2 --
 Documentation/media/uapi/v4l/pixfmt-tch-td16.rst                | 2 --
 Documentation/media/uapi/v4l/pixfmt-tch-tu08.rst                | 2 --
 Documentation/media/uapi/v4l/pixfmt-tch-tu16.rst                | 2 --
 Documentation/media/uapi/v4l/pixfmt-uv8.rst                     | 2 --
 Documentation/media/uapi/v4l/pixfmt-uyvy.rst                    | 2 --
 Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst             | 2 --
 Documentation/media/uapi/v4l/pixfmt-v4l2.rst                    | 2 --
 Documentation/media/uapi/v4l/pixfmt-vyuy.rst                    | 2 --
 Documentation/media/uapi/v4l/pixfmt-y10.rst                     | 2 --
 Documentation/media/uapi/v4l/pixfmt-y10b.rst                    | 2 --
 Documentation/media/uapi/v4l/pixfmt-y10p.rst                    | 2 --
 Documentation/media/uapi/v4l/pixfmt-y12.rst                     | 2 --
 Documentation/media/uapi/v4l/pixfmt-y12i.rst                    | 2 --
 Documentation/media/uapi/v4l/pixfmt-y16-be.rst                  | 2 --
 Documentation/media/uapi/v4l/pixfmt-y16.rst                     | 2 --
 Documentation/media/uapi/v4l/pixfmt-y41p.rst                    | 2 --
 Documentation/media/uapi/v4l/pixfmt-y8i.rst                     | 2 --
 Documentation/media/uapi/v4l/pixfmt-yuv410.rst                  | 2 --
 Documentation/media/uapi/v4l/pixfmt-yuv411p.rst                 | 2 --
 Documentation/media/uapi/v4l/pixfmt-yuv420.rst                  | 2 --
 Documentation/media/uapi/v4l/pixfmt-yuv420m.rst                 | 2 --
 Documentation/media/uapi/v4l/pixfmt-yuv422m.rst                 | 2 --
 Documentation/media/uapi/v4l/pixfmt-yuv422p.rst                 | 2 --
 Documentation/media/uapi/v4l/pixfmt-yuv444m.rst                 | 2 --
 Documentation/media/uapi/v4l/pixfmt-yuyv.rst                    | 2 --
 Documentation/media/uapi/v4l/pixfmt-yvyu.rst                    | 2 --
 Documentation/media/uapi/v4l/pixfmt-z16.rst                     | 2 --
 Documentation/media/uapi/v4l/pixfmt.rst                         | 2 --
 Documentation/media/uapi/v4l/planar-apis.rst                    | 2 --
 Documentation/media/uapi/v4l/querycap.rst                       | 2 --
 Documentation/media/uapi/v4l/rw.rst                             | 2 --
 Documentation/media/uapi/v4l/sdr-formats.rst                    | 2 --
 Documentation/media/uapi/v4l/selection-api-configuration.rst    | 2 --
 Documentation/media/uapi/v4l/selection-api-examples.rst         | 2 --
 Documentation/media/uapi/v4l/selection-api-intro.rst            | 2 --
 Documentation/media/uapi/v4l/selection-api-targets.rst          | 2 --
 Documentation/media/uapi/v4l/selection-api-vs-crop-api.rst      | 2 --
 Documentation/media/uapi/v4l/selection-api.rst                  | 2 --
 Documentation/media/uapi/v4l/selections-common.rst              | 2 --
 Documentation/media/uapi/v4l/standard.rst                       | 2 --
 Documentation/media/uapi/v4l/streaming-par.rst                  | 2 --
 Documentation/media/uapi/v4l/subdev-formats.rst                 | 2 --
 Documentation/media/uapi/v4l/tch-formats.rst                    | 2 --
 Documentation/media/uapi/v4l/tuner.rst                          | 2 --
 Documentation/media/uapi/v4l/user-func.rst                      | 2 --
 Documentation/media/uapi/v4l/userp.rst                          | 2 --
 Documentation/media/uapi/v4l/v4l2-selection-flags.rst           | 2 --
 Documentation/media/uapi/v4l/v4l2-selection-targets.rst         | 2 --
 Documentation/media/uapi/v4l/v4l2.rst                           | 2 --
 Documentation/media/uapi/v4l/v4l2grab-example.rst               | 2 --
 Documentation/media/uapi/v4l/v4l2grab.c.rst                     | 2 --
 Documentation/media/uapi/v4l/video.rst                          | 2 --
 Documentation/media/uapi/v4l/videodev.rst                       | 2 --
 Documentation/media/uapi/v4l/vidioc-create-bufs.rst             | 2 --
 Documentation/media/uapi/v4l/vidioc-cropcap.rst                 | 2 --
 Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst         | 2 --
 Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst          | 2 --
 Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst             | 2 --
 Documentation/media/uapi/v4l/vidioc-dqevent.rst                 | 2 --
 Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst          | 2 --
 Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst             | 2 --
 Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst         | 2 --
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst                | 2 --
 Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst     | 2 --
 Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst         | 2 --
 Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst         | 2 --
 Documentation/media/uapi/v4l/vidioc-enumaudio.rst               | 2 --
 Documentation/media/uapi/v4l/vidioc-enumaudioout.rst            | 2 --
 Documentation/media/uapi/v4l/vidioc-enuminput.rst               | 2 --
 Documentation/media/uapi/v4l/vidioc-enumoutput.rst              | 2 --
 Documentation/media/uapi/v4l/vidioc-enumstd.rst                 | 2 --
 Documentation/media/uapi/v4l/vidioc-expbuf.rst                  | 2 --
 Documentation/media/uapi/v4l/vidioc-g-audio.rst                 | 2 --
 Documentation/media/uapi/v4l/vidioc-g-audioout.rst              | 2 --
 Documentation/media/uapi/v4l/vidioc-g-crop.rst                  | 2 --
 Documentation/media/uapi/v4l/vidioc-g-ctrl.rst                  | 2 --
 Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst            | 2 --
 Documentation/media/uapi/v4l/vidioc-g-edid.rst                  | 2 --
 Documentation/media/uapi/v4l/vidioc-g-enc-index.rst             | 2 --
 Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst             | 2 --
 Documentation/media/uapi/v4l/vidioc-g-fbuf.rst                  | 2 --
 Documentation/media/uapi/v4l/vidioc-g-fmt.rst                   | 2 --
 Documentation/media/uapi/v4l/vidioc-g-frequency.rst             | 2 --
 Documentation/media/uapi/v4l/vidioc-g-input.rst                 | 2 --
 Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst              | 2 --
 Documentation/media/uapi/v4l/vidioc-g-modulator.rst             | 2 --
 Documentation/media/uapi/v4l/vidioc-g-output.rst                | 2 --
 Documentation/media/uapi/v4l/vidioc-g-parm.rst                  | 2 --
 Documentation/media/uapi/v4l/vidioc-g-priority.rst              | 2 --
 Documentation/media/uapi/v4l/vidioc-g-selection.rst             | 2 --
 Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst        | 2 --
 Documentation/media/uapi/v4l/vidioc-g-std.rst                   | 2 --
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst                 | 2 --
 Documentation/media/uapi/v4l/vidioc-log-status.rst              | 2 --
 Documentation/media/uapi/v4l/vidioc-overlay.rst                 | 2 --
 Documentation/media/uapi/v4l/vidioc-prepare-buf.rst             | 2 --
 Documentation/media/uapi/v4l/vidioc-qbuf.rst                    | 2 --
 Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst        | 2 --
 Documentation/media/uapi/v4l/vidioc-querybuf.rst                | 2 --
 Documentation/media/uapi/v4l/vidioc-querycap.rst                | 2 --
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst               | 2 --
 Documentation/media/uapi/v4l/vidioc-querystd.rst                | 2 --
 Documentation/media/uapi/v4l/vidioc-reqbufs.rst                 | 2 --
 Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst          | 2 --
 Documentation/media/uapi/v4l/vidioc-streamon.rst                | 2 --
 .../media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst        | 2 --
 Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst  | 2 --
 Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst   | 2 --
 Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst           | 2 --
 Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst            | 2 --
 Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst | 2 --
 Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst      | 2 --
 Documentation/media/uapi/v4l/vidioc-subscribe-event.rst         | 2 --
 Documentation/media/uapi/v4l/yuv-formats.rst                    | 2 --
 Documentation/media/v4l-drivers/index.rst                       | 2 --
 Documentation/media/v4l-drivers/ivtv.rst                        | 1 -
 393 files changed, 783 deletions(-)

diff --git a/Documentation/media/cec-drivers/index.rst b/Documentation/media/cec-drivers/index.rst
index 7ef204823422..463e5210b686 100644
--- a/Documentation/media/cec-drivers/index.rst
+++ b/Documentation/media/cec-drivers/index.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. include:: <isonum.txt>
 
 .. _cec-drivers:
diff --git a/Documentation/media/dvb-drivers/index.rst b/Documentation/media/dvb-drivers/index.rst
index 314e127d82e3..7c2795bf1587 100644
--- a/Documentation/media/dvb-drivers/index.rst
+++ b/Documentation/media/dvb-drivers/index.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. include:: <isonum.txt>
 
 ##############################################
diff --git a/Documentation/media/intro.rst b/Documentation/media/intro.rst
index 9ce2e23a0236..f8960214741f 100644
--- a/Documentation/media/intro.rst
+++ b/Documentation/media/intro.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 ============
 Introduction
 ============
diff --git a/Documentation/media/kapi/v4l2-event.rst b/Documentation/media/kapi/v4l2-event.rst
index 5c7e31224ddc..b22ccbccdbd1 100644
--- a/Documentation/media/kapi/v4l2-event.rst
+++ b/Documentation/media/kapi/v4l2-event.rst
@@ -1,4 +1,3 @@
-
 V4L2 events
 -----------
 
diff --git a/Documentation/media/media_kapi.rst b/Documentation/media/media_kapi.rst
index 83da736fad72..5e28289ee79e 100644
--- a/Documentation/media/media_kapi.rst
+++ b/Documentation/media/media_kapi.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. include:: <isonum.txt>
 
 ===================================
diff --git a/Documentation/media/media_uapi.rst b/Documentation/media/media_uapi.rst
index 5198ff24a094..bff90d20d3f8 100644
--- a/Documentation/media/media_uapi.rst
+++ b/Documentation/media/media_uapi.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. include:: <isonum.txt>
 
 ########################################
diff --git a/Documentation/media/uapi/cec/cec-api.rst b/Documentation/media/uapi/cec/cec-api.rst
index 1e2cf498ba30..5029794418c5 100644
--- a/Documentation/media/uapi/cec/cec-api.rst
+++ b/Documentation/media/uapi/cec/cec-api.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. include:: <isonum.txt>
 
 .. _cec:
diff --git a/Documentation/media/uapi/cec/cec-func-close.rst b/Documentation/media/uapi/cec/cec-func-close.rst
index 334358dfa72e..81625941b4a0 100644
--- a/Documentation/media/uapi/cec/cec-func-close.rst
+++ b/Documentation/media/uapi/cec/cec-func-close.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _cec-func-close:
 
 ***********
diff --git a/Documentation/media/uapi/cec/cec-func-ioctl.rst b/Documentation/media/uapi/cec/cec-func-ioctl.rst
index e2b6260b0086..112d46f9146d 100644
--- a/Documentation/media/uapi/cec/cec-func-ioctl.rst
+++ b/Documentation/media/uapi/cec/cec-func-ioctl.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _cec-func-ioctl:
 
 ***********
diff --git a/Documentation/media/uapi/cec/cec-func-open.rst b/Documentation/media/uapi/cec/cec-func-open.rst
index 5d6663a649bd..517479134e8f 100644
--- a/Documentation/media/uapi/cec/cec-func-open.rst
+++ b/Documentation/media/uapi/cec/cec-func-open.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _cec-func-open:
 
 **********
diff --git a/Documentation/media/uapi/cec/cec-func-poll.rst b/Documentation/media/uapi/cec/cec-func-poll.rst
index c698c969635c..af9c7e7d97de 100644
--- a/Documentation/media/uapi/cec/cec-func-poll.rst
+++ b/Documentation/media/uapi/cec/cec-func-poll.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _cec-func-poll:
 
 **********
diff --git a/Documentation/media/uapi/cec/cec-header.rst b/Documentation/media/uapi/cec/cec-header.rst
index d5a9a2828274..546cbd5856ed 100644
--- a/Documentation/media/uapi/cec/cec-header.rst
+++ b/Documentation/media/uapi/cec/cec-header.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _cec_header:
 
 ***************
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
index 6c1f6efb822e..55be13d08d68 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _CEC_ADAP_G_CAPS:
 
 *********************
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
index 84f431a022ad..48e489f87a76 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _CEC_ADAP_LOG_ADDRS:
 .. _CEC_ADAP_G_LOG_ADDRS:
 .. _CEC_ADAP_S_LOG_ADDRS:
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
index 9e49d4be35d5..b856475d8781 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _CEC_ADAP_PHYS_ADDR:
 .. _CEC_ADAP_G_PHYS_ADDR:
 .. _CEC_ADAP_S_PHYS_ADDR:
diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index 8d5633e6ae04..43551561a934 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _CEC_DQEVENT:
 
 *****************
diff --git a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
index 508e2e325683..4b297a2d8be3 100644
--- a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _CEC_MODE:
 .. _CEC_G_MODE:
 .. _CEC_S_MODE:
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index b25e48afaa08..a112915da9c7 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _CEC_TRANSMIT:
 .. _CEC_RECEIVE:
 
diff --git a/Documentation/media/uapi/dvb/audio-bilingual-channel-select.rst b/Documentation/media/uapi/dvb/audio-bilingual-channel-select.rst
index 1279bd21dbd0..fde098b9b320 100644
--- a/Documentation/media/uapi/dvb/audio-bilingual-channel-select.rst
+++ b/Documentation/media/uapi/dvb/audio-bilingual-channel-select.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _AUDIO_BILINGUAL_CHANNEL_SELECT:
 
 ==============================
diff --git a/Documentation/media/uapi/dvb/audio-channel-select.rst b/Documentation/media/uapi/dvb/audio-channel-select.rst
index 8cab3d7abff5..549f250f0d80 100644
--- a/Documentation/media/uapi/dvb/audio-channel-select.rst
+++ b/Documentation/media/uapi/dvb/audio-channel-select.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _AUDIO_CHANNEL_SELECT:
 
 ====================
diff --git a/Documentation/media/uapi/dvb/audio-clear-buffer.rst b/Documentation/media/uapi/dvb/audio-clear-buffer.rst
index f6bed67cb070..80ece2a96633 100644
--- a/Documentation/media/uapi/dvb/audio-clear-buffer.rst
+++ b/Documentation/media/uapi/dvb/audio-clear-buffer.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _AUDIO_CLEAR_BUFFER:
 
 ==================
diff --git a/Documentation/media/uapi/dvb/audio-continue.rst b/Documentation/media/uapi/dvb/audio-continue.rst
index ca587869306e..e54d4bb76c2f 100644
--- a/Documentation/media/uapi/dvb/audio-continue.rst
+++ b/Documentation/media/uapi/dvb/audio-continue.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _AUDIO_CONTINUE:
 
 ==============
diff --git a/Documentation/media/uapi/dvb/audio-fclose.rst b/Documentation/media/uapi/dvb/audio-fclose.rst
index 58d351a3af4b..1ea460f4dfa9 100644
--- a/Documentation/media/uapi/dvb/audio-fclose.rst
+++ b/Documentation/media/uapi/dvb/audio-fclose.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _audio_fclose:
 
 ========================
diff --git a/Documentation/media/uapi/dvb/audio-fopen.rst b/Documentation/media/uapi/dvb/audio-fopen.rst
index 4a174640bf11..d0a617349be8 100644
--- a/Documentation/media/uapi/dvb/audio-fopen.rst
+++ b/Documentation/media/uapi/dvb/audio-fopen.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _audio_fopen:
 
 =======================
diff --git a/Documentation/media/uapi/dvb/audio-fwrite.rst b/Documentation/media/uapi/dvb/audio-fwrite.rst
index 4980ae7953ef..692ddd3512f2 100644
--- a/Documentation/media/uapi/dvb/audio-fwrite.rst
+++ b/Documentation/media/uapi/dvb/audio-fwrite.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _audio_fwrite:
 
 =========================
diff --git a/Documentation/media/uapi/dvb/audio-get-capabilities.rst b/Documentation/media/uapi/dvb/audio-get-capabilities.rst
index 0d867f189c22..301aeb84069a 100644
--- a/Documentation/media/uapi/dvb/audio-get-capabilities.rst
+++ b/Documentation/media/uapi/dvb/audio-get-capabilities.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _AUDIO_GET_CAPABILITIES:
 
 ======================
diff --git a/Documentation/media/uapi/dvb/audio-get-status.rst b/Documentation/media/uapi/dvb/audio-get-status.rst
index 857b058325f1..07f35cd76397 100644
--- a/Documentation/media/uapi/dvb/audio-get-status.rst
+++ b/Documentation/media/uapi/dvb/audio-get-status.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _AUDIO_GET_STATUS:
 
 ================
diff --git a/Documentation/media/uapi/dvb/audio-pause.rst b/Documentation/media/uapi/dvb/audio-pause.rst
index c7310dffbff2..81eecd738afe 100644
--- a/Documentation/media/uapi/dvb/audio-pause.rst
+++ b/Documentation/media/uapi/dvb/audio-pause.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _AUDIO_PAUSE:
 
 ===========
diff --git a/Documentation/media/uapi/dvb/audio-play.rst b/Documentation/media/uapi/dvb/audio-play.rst
index 943b5eec9f28..4719c9158848 100644
--- a/Documentation/media/uapi/dvb/audio-play.rst
+++ b/Documentation/media/uapi/dvb/audio-play.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _AUDIO_PLAY:
 
 ==========
diff --git a/Documentation/media/uapi/dvb/audio-select-source.rst b/Documentation/media/uapi/dvb/audio-select-source.rst
index c0434a0bd324..7b5985680f2b 100644
--- a/Documentation/media/uapi/dvb/audio-select-source.rst
+++ b/Documentation/media/uapi/dvb/audio-select-source.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _AUDIO_SELECT_SOURCE:
 
 ===================
diff --git a/Documentation/media/uapi/dvb/audio-set-av-sync.rst b/Documentation/media/uapi/dvb/audio-set-av-sync.rst
index cf621f3a3037..1cded0388336 100644
--- a/Documentation/media/uapi/dvb/audio-set-av-sync.rst
+++ b/Documentation/media/uapi/dvb/audio-set-av-sync.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _AUDIO_SET_AV_SYNC:
 
 =================
diff --git a/Documentation/media/uapi/dvb/audio-set-bypass-mode.rst b/Documentation/media/uapi/dvb/audio-set-bypass-mode.rst
index f0db1fbdb066..a43037ef0d74 100644
--- a/Documentation/media/uapi/dvb/audio-set-bypass-mode.rst
+++ b/Documentation/media/uapi/dvb/audio-set-bypass-mode.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _AUDIO_SET_BYPASS_MODE:
 
 =====================
diff --git a/Documentation/media/uapi/dvb/audio-set-id.rst b/Documentation/media/uapi/dvb/audio-set-id.rst
index 8b1081d24473..faec0ff3b5d5 100644
--- a/Documentation/media/uapi/dvb/audio-set-id.rst
+++ b/Documentation/media/uapi/dvb/audio-set-id.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _AUDIO_SET_ID:
 
 ============
diff --git a/Documentation/media/uapi/dvb/audio-set-mixer.rst b/Documentation/media/uapi/dvb/audio-set-mixer.rst
index 248aab8c8909..dfb88352e99a 100644
--- a/Documentation/media/uapi/dvb/audio-set-mixer.rst
+++ b/Documentation/media/uapi/dvb/audio-set-mixer.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _AUDIO_SET_MIXER:
 
 ===============
diff --git a/Documentation/media/uapi/dvb/audio-set-mute.rst b/Documentation/media/uapi/dvb/audio-set-mute.rst
index 0af105a8ddcc..94dc88678a6f 100644
--- a/Documentation/media/uapi/dvb/audio-set-mute.rst
+++ b/Documentation/media/uapi/dvb/audio-set-mute.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _AUDIO_SET_MUTE:
 
 ==============
diff --git a/Documentation/media/uapi/dvb/audio-set-streamtype.rst b/Documentation/media/uapi/dvb/audio-set-streamtype.rst
index 46c0362ac71d..997f1ff2f053 100644
--- a/Documentation/media/uapi/dvb/audio-set-streamtype.rst
+++ b/Documentation/media/uapi/dvb/audio-set-streamtype.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _AUDIO_SET_STREAMTYPE:
 
 ====================
diff --git a/Documentation/media/uapi/dvb/audio-stop.rst b/Documentation/media/uapi/dvb/audio-stop.rst
index dd6c3b6826ec..bacf9ecc7282 100644
--- a/Documentation/media/uapi/dvb/audio-stop.rst
+++ b/Documentation/media/uapi/dvb/audio-stop.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _AUDIO_STOP:
 
 ==========
diff --git a/Documentation/media/uapi/dvb/audio.rst b/Documentation/media/uapi/dvb/audio.rst
index e9f9e589c486..4454cf1530f6 100644
--- a/Documentation/media/uapi/dvb/audio.rst
+++ b/Documentation/media/uapi/dvb/audio.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _dvb_audio:
 
 #######################
diff --git a/Documentation/media/uapi/dvb/audio_data_types.rst b/Documentation/media/uapi/dvb/audio_data_types.rst
index 5bffa2c98a24..686a32cfdd1a 100644
--- a/Documentation/media/uapi/dvb/audio_data_types.rst
+++ b/Documentation/media/uapi/dvb/audio_data_types.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _audio_data_types:
 
 ****************
diff --git a/Documentation/media/uapi/dvb/audio_function_calls.rst b/Documentation/media/uapi/dvb/audio_function_calls.rst
index 7dba16285dab..6aa9a593e003 100644
--- a/Documentation/media/uapi/dvb/audio_function_calls.rst
+++ b/Documentation/media/uapi/dvb/audio_function_calls.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _audio_function_calls:
 
 ********************
diff --git a/Documentation/media/uapi/dvb/ca-fclose.rst b/Documentation/media/uapi/dvb/ca-fclose.rst
index e84bbfcfa184..7f1adda05744 100644
--- a/Documentation/media/uapi/dvb/ca-fclose.rst
+++ b/Documentation/media/uapi/dvb/ca-fclose.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _ca_fclose:
 
 =====================
diff --git a/Documentation/media/uapi/dvb/ca-fopen.rst b/Documentation/media/uapi/dvb/ca-fopen.rst
index 056c71b53a70..080232062dce 100644
--- a/Documentation/media/uapi/dvb/ca-fopen.rst
+++ b/Documentation/media/uapi/dvb/ca-fopen.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _ca_fopen:
 
 ====================
diff --git a/Documentation/media/uapi/dvb/ca-get-cap.rst b/Documentation/media/uapi/dvb/ca-get-cap.rst
index d2d5c1355396..dfaaaa8b9ad4 100644
--- a/Documentation/media/uapi/dvb/ca-get-cap.rst
+++ b/Documentation/media/uapi/dvb/ca-get-cap.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _CA_GET_CAP:
 
 ==========
diff --git a/Documentation/media/uapi/dvb/ca-get-descr-info.rst b/Documentation/media/uapi/dvb/ca-get-descr-info.rst
index e564fbb8d524..0b76e782eb68 100644
--- a/Documentation/media/uapi/dvb/ca-get-descr-info.rst
+++ b/Documentation/media/uapi/dvb/ca-get-descr-info.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _CA_GET_DESCR_INFO:
 
 =================
diff --git a/Documentation/media/uapi/dvb/ca-get-msg.rst b/Documentation/media/uapi/dvb/ca-get-msg.rst
index ceeda623ce93..311e4d4e7f0e 100644
--- a/Documentation/media/uapi/dvb/ca-get-msg.rst
+++ b/Documentation/media/uapi/dvb/ca-get-msg.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _CA_GET_MSG:
 
 ==========
diff --git a/Documentation/media/uapi/dvb/ca-get-slot-info.rst b/Documentation/media/uapi/dvb/ca-get-slot-info.rst
index 1a1d6f0c71b9..561b7834558e 100644
--- a/Documentation/media/uapi/dvb/ca-get-slot-info.rst
+++ b/Documentation/media/uapi/dvb/ca-get-slot-info.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _CA_GET_SLOT_INFO:
 
 ================
diff --git a/Documentation/media/uapi/dvb/ca-reset.rst b/Documentation/media/uapi/dvb/ca-reset.rst
index 29788325f90e..b14475c6d397 100644
--- a/Documentation/media/uapi/dvb/ca-reset.rst
+++ b/Documentation/media/uapi/dvb/ca-reset.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _CA_RESET:
 
 ========
diff --git a/Documentation/media/uapi/dvb/ca-send-msg.rst b/Documentation/media/uapi/dvb/ca-send-msg.rst
index 9e91287b7bbc..a07332894aaf 100644
--- a/Documentation/media/uapi/dvb/ca-send-msg.rst
+++ b/Documentation/media/uapi/dvb/ca-send-msg.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _CA_SEND_MSG:
 
 ===========
diff --git a/Documentation/media/uapi/dvb/ca-set-descr.rst b/Documentation/media/uapi/dvb/ca-set-descr.rst
index a6c47205ffd8..8674b5578db5 100644
--- a/Documentation/media/uapi/dvb/ca-set-descr.rst
+++ b/Documentation/media/uapi/dvb/ca-set-descr.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _CA_SET_DESCR:
 
 ============
diff --git a/Documentation/media/uapi/dvb/ca.rst b/Documentation/media/uapi/dvb/ca.rst
index deac72d89e93..7d2240e6b6bc 100644
--- a/Documentation/media/uapi/dvb/ca.rst
+++ b/Documentation/media/uapi/dvb/ca.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _dvb_ca:
 
 ####################
diff --git a/Documentation/media/uapi/dvb/ca_data_types.rst b/Documentation/media/uapi/dvb/ca_data_types.rst
index ac7cbd76ddd5..0f8af427fe6e 100644
--- a/Documentation/media/uapi/dvb/ca_data_types.rst
+++ b/Documentation/media/uapi/dvb/ca_data_types.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _ca_data_types:
 
 *************
diff --git a/Documentation/media/uapi/dvb/ca_function_calls.rst b/Documentation/media/uapi/dvb/ca_function_calls.rst
index 87d697851e82..8ca3cef14320 100644
--- a/Documentation/media/uapi/dvb/ca_function_calls.rst
+++ b/Documentation/media/uapi/dvb/ca_function_calls.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _ca_function_calls:
 
 *****************
diff --git a/Documentation/media/uapi/dvb/demux.rst b/Documentation/media/uapi/dvb/demux.rst
index 45c3d6405c46..5efe0500a09b 100644
--- a/Documentation/media/uapi/dvb/demux.rst
+++ b/Documentation/media/uapi/dvb/demux.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _dvb_demux:
 
 #######################
diff --git a/Documentation/media/uapi/dvb/dmx-add-pid.rst b/Documentation/media/uapi/dvb/dmx-add-pid.rst
index 4d5632dfb43e..56f500f4c198 100644
--- a/Documentation/media/uapi/dvb/dmx-add-pid.rst
+++ b/Documentation/media/uapi/dvb/dmx-add-pid.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _DMX_ADD_PID:
 
 ===========
diff --git a/Documentation/media/uapi/dvb/dmx-fclose.rst b/Documentation/media/uapi/dvb/dmx-fclose.rst
index 578e929f4bde..551c3e11ca12 100644
--- a/Documentation/media/uapi/dvb/dmx-fclose.rst
+++ b/Documentation/media/uapi/dvb/dmx-fclose.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _dmx_fclose:
 
 ========================
diff --git a/Documentation/media/uapi/dvb/dmx-fopen.rst b/Documentation/media/uapi/dvb/dmx-fopen.rst
index 55628a18ba67..6e72de049ef4 100644
--- a/Documentation/media/uapi/dvb/dmx-fopen.rst
+++ b/Documentation/media/uapi/dvb/dmx-fopen.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _dmx_fopen:
 
 =======================
diff --git a/Documentation/media/uapi/dvb/dmx-fread.rst b/Documentation/media/uapi/dvb/dmx-fread.rst
index 488bdc4ba178..29978b74f25e 100644
--- a/Documentation/media/uapi/dvb/dmx-fread.rst
+++ b/Documentation/media/uapi/dvb/dmx-fread.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _dmx_fread:
 
 =======================
diff --git a/Documentation/media/uapi/dvb/dmx-fwrite.rst b/Documentation/media/uapi/dvb/dmx-fwrite.rst
index 519e5733e53b..5266f8dc528a 100644
--- a/Documentation/media/uapi/dvb/dmx-fwrite.rst
+++ b/Documentation/media/uapi/dvb/dmx-fwrite.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _dmx_fwrite:
 
 ========================
diff --git a/Documentation/media/uapi/dvb/dmx-get-pes-pids.rst b/Documentation/media/uapi/dvb/dmx-get-pes-pids.rst
index fbdbc12869d1..152110157c6d 100644
--- a/Documentation/media/uapi/dvb/dmx-get-pes-pids.rst
+++ b/Documentation/media/uapi/dvb/dmx-get-pes-pids.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _DMX_GET_PES_PIDS:
 
 ================
diff --git a/Documentation/media/uapi/dvb/dmx-get-stc.rst b/Documentation/media/uapi/dvb/dmx-get-stc.rst
index 604031f7904b..6b6c4d0a65e2 100644
--- a/Documentation/media/uapi/dvb/dmx-get-stc.rst
+++ b/Documentation/media/uapi/dvb/dmx-get-stc.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _DMX_GET_STC:
 
 ===========
diff --git a/Documentation/media/uapi/dvb/dmx-remove-pid.rst b/Documentation/media/uapi/dvb/dmx-remove-pid.rst
index 456cc2ded2c0..31434a67fd54 100644
--- a/Documentation/media/uapi/dvb/dmx-remove-pid.rst
+++ b/Documentation/media/uapi/dvb/dmx-remove-pid.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _DMX_REMOVE_PID:
 
 ==============
diff --git a/Documentation/media/uapi/dvb/dmx-set-buffer-size.rst b/Documentation/media/uapi/dvb/dmx-set-buffer-size.rst
index 74fd076a9b90..93837860cdb7 100644
--- a/Documentation/media/uapi/dvb/dmx-set-buffer-size.rst
+++ b/Documentation/media/uapi/dvb/dmx-set-buffer-size.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _DMX_SET_BUFFER_SIZE:
 
 ===================
diff --git a/Documentation/media/uapi/dvb/dmx-set-filter.rst b/Documentation/media/uapi/dvb/dmx-set-filter.rst
index 88594b8d3846..d3a127ade77d 100644
--- a/Documentation/media/uapi/dvb/dmx-set-filter.rst
+++ b/Documentation/media/uapi/dvb/dmx-set-filter.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _DMX_SET_FILTER:
 
 ==============
diff --git a/Documentation/media/uapi/dvb/dmx-set-pes-filter.rst b/Documentation/media/uapi/dvb/dmx-set-pes-filter.rst
index d70e7bf96a41..807bb3d32aac 100644
--- a/Documentation/media/uapi/dvb/dmx-set-pes-filter.rst
+++ b/Documentation/media/uapi/dvb/dmx-set-pes-filter.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _DMX_SET_PES_FILTER:
 
 ==================
diff --git a/Documentation/media/uapi/dvb/dmx-start.rst b/Documentation/media/uapi/dvb/dmx-start.rst
index 36700e775296..3ab20eccfaf2 100644
--- a/Documentation/media/uapi/dvb/dmx-start.rst
+++ b/Documentation/media/uapi/dvb/dmx-start.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _DMX_START:
 
 =========
diff --git a/Documentation/media/uapi/dvb/dmx-stop.rst b/Documentation/media/uapi/dvb/dmx-stop.rst
index 6d9c927bcd5f..ed6c67fa8be0 100644
--- a/Documentation/media/uapi/dvb/dmx-stop.rst
+++ b/Documentation/media/uapi/dvb/dmx-stop.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _DMX_STOP:
 
 ========
diff --git a/Documentation/media/uapi/dvb/dmx_fcalls.rst b/Documentation/media/uapi/dvb/dmx_fcalls.rst
index 4c391cf2554f..fbca4ac86423 100644
--- a/Documentation/media/uapi/dvb/dmx_fcalls.rst
+++ b/Documentation/media/uapi/dvb/dmx_fcalls.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _dmx_fcalls:
 
 ********************
diff --git a/Documentation/media/uapi/dvb/dmx_types.rst b/Documentation/media/uapi/dvb/dmx_types.rst
index 2a023a4f516c..9edc0bf47052 100644
--- a/Documentation/media/uapi/dvb/dmx_types.rst
+++ b/Documentation/media/uapi/dvb/dmx_types.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _dmx_types:
 
 ****************
diff --git a/Documentation/media/uapi/dvb/dvb-fe-read-status.rst b/Documentation/media/uapi/dvb/dvb-fe-read-status.rst
index 212f032cad8b..c8caa46b7095 100644
--- a/Documentation/media/uapi/dvb/dvb-fe-read-status.rst
+++ b/Documentation/media/uapi/dvb/dvb-fe-read-status.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _dvb-fe-read-status:
 
 ***************************************
diff --git a/Documentation/media/uapi/dvb/dvb-frontend-event.rst b/Documentation/media/uapi/dvb/dvb-frontend-event.rst
index 2088bc6cacd8..8caf9c77866a 100644
--- a/Documentation/media/uapi/dvb/dvb-frontend-event.rst
+++ b/Documentation/media/uapi/dvb/dvb-frontend-event.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. c:type:: dvb_frontend_event
 
 ***************
diff --git a/Documentation/media/uapi/dvb/dvb-frontend-parameters.rst b/Documentation/media/uapi/dvb/dvb-frontend-parameters.rst
index b152166f8fa7..f2d9e5e88633 100644
--- a/Documentation/media/uapi/dvb/dvb-frontend-parameters.rst
+++ b/Documentation/media/uapi/dvb/dvb-frontend-parameters.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. c:type:: dvb_frontend_parameters
 
 *******************
diff --git a/Documentation/media/uapi/dvb/dvbapi.rst b/Documentation/media/uapi/dvb/dvbapi.rst
index 89ddca38626f..0cd1e1581bcb 100644
--- a/Documentation/media/uapi/dvb/dvbapi.rst
+++ b/Documentation/media/uapi/dvb/dvbapi.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. include:: <isonum.txt>
 
 .. _dvbapi:
diff --git a/Documentation/media/uapi/dvb/dvbproperty.rst b/Documentation/media/uapi/dvb/dvbproperty.rst
index 1a56c1724e59..6a8fd0206a15 100644
--- a/Documentation/media/uapi/dvb/dvbproperty.rst
+++ b/Documentation/media/uapi/dvb/dvbproperty.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _frontend-properties:
 
 **************
diff --git a/Documentation/media/uapi/dvb/examples.rst b/Documentation/media/uapi/dvb/examples.rst
index 16dd90fa9e94..8683038d5a73 100644
--- a/Documentation/media/uapi/dvb/examples.rst
+++ b/Documentation/media/uapi/dvb/examples.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _dvb_examples:
 
 ********
diff --git a/Documentation/media/uapi/dvb/fe-bandwidth-t.rst b/Documentation/media/uapi/dvb/fe-bandwidth-t.rst
index 70256180e9b3..54eec48ad436 100644
--- a/Documentation/media/uapi/dvb/fe-bandwidth-t.rst
+++ b/Documentation/media/uapi/dvb/fe-bandwidth-t.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 ******************
 Frontend bandwidth
 ******************
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst b/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
index f220ee351e15..5fa88c86b21b 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _FE_DISEQC_RECV_SLAVE_REPLY:
 
 ********************************
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-reset-overload.rst b/Documentation/media/uapi/dvb/fe-diseqc-reset-overload.rst
index 78476c1c7bf5..f83704ecb2ae 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-reset-overload.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-reset-overload.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _FE_DISEQC_RESET_OVERLOAD:
 
 ******************************
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst b/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst
index a7e05914efae..6add070ce7ba 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _FE_DISEQC_SEND_BURST:
 
 **************************
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst b/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
index 6bd3994edfc2..afbeffcbe241 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _FE_DISEQC_SEND_MASTER_CMD:
 
 *******************************
diff --git a/Documentation/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst b/Documentation/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst
index dcf2d20d460f..89af07f359fb 100644
--- a/Documentation/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst
+++ b/Documentation/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _FE_DISHNETWORK_SEND_LEGACY_CMD:
 
 ******************************
diff --git a/Documentation/media/uapi/dvb/fe-enable-high-lnb-voltage.rst b/Documentation/media/uapi/dvb/fe-enable-high-lnb-voltage.rst
index b20cb360fe37..fca97340dc60 100644
--- a/Documentation/media/uapi/dvb/fe-enable-high-lnb-voltage.rst
+++ b/Documentation/media/uapi/dvb/fe-enable-high-lnb-voltage.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _FE_ENABLE_HIGH_LNB_VOLTAGE:
 
 ********************************
diff --git a/Documentation/media/uapi/dvb/fe-get-event.rst b/Documentation/media/uapi/dvb/fe-get-event.rst
index 505db94bf183..8d2b34a20b6a 100644
--- a/Documentation/media/uapi/dvb/fe-get-event.rst
+++ b/Documentation/media/uapi/dvb/fe-get-event.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _FE_GET_EVENT:
 
 ************
diff --git a/Documentation/media/uapi/dvb/fe-get-frontend.rst b/Documentation/media/uapi/dvb/fe-get-frontend.rst
index 5db552cedd70..f607c1b6ba29 100644
--- a/Documentation/media/uapi/dvb/fe-get-frontend.rst
+++ b/Documentation/media/uapi/dvb/fe-get-frontend.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _FE_GET_FRONTEND:
 
 ***************
diff --git a/Documentation/media/uapi/dvb/fe-get-info.rst b/Documentation/media/uapi/dvb/fe-get-info.rst
index 49307c0abfee..8b23081ef7cf 100644
--- a/Documentation/media/uapi/dvb/fe-get-info.rst
+++ b/Documentation/media/uapi/dvb/fe-get-info.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _FE_GET_INFO:
 
 *****************
diff --git a/Documentation/media/uapi/dvb/fe-get-property.rst b/Documentation/media/uapi/dvb/fe-get-property.rst
index b69741d9cedf..3a188441089c 100644
--- a/Documentation/media/uapi/dvb/fe-get-property.rst
+++ b/Documentation/media/uapi/dvb/fe-get-property.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _FE_GET_PROPERTY:
 
 **************************************
diff --git a/Documentation/media/uapi/dvb/fe-read-ber.rst b/Documentation/media/uapi/dvb/fe-read-ber.rst
index 1e6a79567a4c..eb18ae96731a 100644
--- a/Documentation/media/uapi/dvb/fe-read-ber.rst
+++ b/Documentation/media/uapi/dvb/fe-read-ber.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _FE_READ_BER:
 
 ***********
diff --git a/Documentation/media/uapi/dvb/fe-read-signal-strength.rst b/Documentation/media/uapi/dvb/fe-read-signal-strength.rst
index 198f6dfb53a1..49690a55e5fb 100644
--- a/Documentation/media/uapi/dvb/fe-read-signal-strength.rst
+++ b/Documentation/media/uapi/dvb/fe-read-signal-strength.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _FE_READ_SIGNAL_STRENGTH:
 
 ***********************
diff --git a/Documentation/media/uapi/dvb/fe-read-snr.rst b/Documentation/media/uapi/dvb/fe-read-snr.rst
index 6db22c043512..b97e4cec907f 100644
--- a/Documentation/media/uapi/dvb/fe-read-snr.rst
+++ b/Documentation/media/uapi/dvb/fe-read-snr.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _FE_READ_SNR:
 
 ***********
diff --git a/Documentation/media/uapi/dvb/fe-read-status.rst b/Documentation/media/uapi/dvb/fe-read-status.rst
index 4adb52f084ff..02c7731b33d6 100644
--- a/Documentation/media/uapi/dvb/fe-read-status.rst
+++ b/Documentation/media/uapi/dvb/fe-read-status.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _FE_READ_STATUS:
 
 ********************
diff --git a/Documentation/media/uapi/dvb/fe-read-uncorrected-blocks.rst b/Documentation/media/uapi/dvb/fe-read-uncorrected-blocks.rst
index f2c688bcacb3..cb0e8308503b 100644
--- a/Documentation/media/uapi/dvb/fe-read-uncorrected-blocks.rst
+++ b/Documentation/media/uapi/dvb/fe-read-uncorrected-blocks.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _FE_READ_UNCORRECTED_BLOCKS:
 
 **************************
diff --git a/Documentation/media/uapi/dvb/fe-set-frontend-tune-mode.rst b/Documentation/media/uapi/dvb/fe-set-frontend-tune-mode.rst
index 3c4bc179b313..c5c5a1842514 100644
--- a/Documentation/media/uapi/dvb/fe-set-frontend-tune-mode.rst
+++ b/Documentation/media/uapi/dvb/fe-set-frontend-tune-mode.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _FE_SET_FRONTEND_TUNE_MODE:
 
 *******************************
diff --git a/Documentation/media/uapi/dvb/fe-set-frontend.rst b/Documentation/media/uapi/dvb/fe-set-frontend.rst
index 4f3dcf338254..ffe310698ddc 100644
--- a/Documentation/media/uapi/dvb/fe-set-frontend.rst
+++ b/Documentation/media/uapi/dvb/fe-set-frontend.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _FE_SET_FRONTEND:
 
 ***************
diff --git a/Documentation/media/uapi/dvb/fe-set-tone.rst b/Documentation/media/uapi/dvb/fe-set-tone.rst
index 758efa11014c..d7ac6491c8d3 100644
--- a/Documentation/media/uapi/dvb/fe-set-tone.rst
+++ b/Documentation/media/uapi/dvb/fe-set-tone.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _FE_SET_TONE:
 
 *****************
diff --git a/Documentation/media/uapi/dvb/fe-set-voltage.rst b/Documentation/media/uapi/dvb/fe-set-voltage.rst
index 38d4485290a0..6281c4ba0b7a 100644
--- a/Documentation/media/uapi/dvb/fe-set-voltage.rst
+++ b/Documentation/media/uapi/dvb/fe-set-voltage.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _FE_SET_VOLTAGE:
 
 ********************
diff --git a/Documentation/media/uapi/dvb/fe-type-t.rst b/Documentation/media/uapi/dvb/fe-type-t.rst
index dee32ae104d7..3a32aa4c7cd9 100644
--- a/Documentation/media/uapi/dvb/fe-type-t.rst
+++ b/Documentation/media/uapi/dvb/fe-type-t.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 *************
 Frontend type
 *************
diff --git a/Documentation/media/uapi/dvb/fe_property_parameters.rst b/Documentation/media/uapi/dvb/fe_property_parameters.rst
index 3524dcae4604..973b05caadb1 100644
--- a/Documentation/media/uapi/dvb/fe_property_parameters.rst
+++ b/Documentation/media/uapi/dvb/fe_property_parameters.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _fe_property_parameters:
 
 ******************************
diff --git a/Documentation/media/uapi/dvb/frontend-property-cable-systems.rst b/Documentation/media/uapi/dvb/frontend-property-cable-systems.rst
index bf2328627af5..d2bb83ee0178 100644
--- a/Documentation/media/uapi/dvb/frontend-property-cable-systems.rst
+++ b/Documentation/media/uapi/dvb/frontend-property-cable-systems.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _frontend-property-cable-systems:
 
 *****************************************
diff --git a/Documentation/media/uapi/dvb/frontend-property-satellite-systems.rst b/Documentation/media/uapi/dvb/frontend-property-satellite-systems.rst
index 2929e6999a7a..15bbea45b1be 100644
--- a/Documentation/media/uapi/dvb/frontend-property-satellite-systems.rst
+++ b/Documentation/media/uapi/dvb/frontend-property-satellite-systems.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _frontend-property-satellite-systems:
 
 *********************************************
diff --git a/Documentation/media/uapi/dvb/frontend-property-terrestrial-systems.rst b/Documentation/media/uapi/dvb/frontend-property-terrestrial-systems.rst
index 0beb5cb3d729..70eea284e3c6 100644
--- a/Documentation/media/uapi/dvb/frontend-property-terrestrial-systems.rst
+++ b/Documentation/media/uapi/dvb/frontend-property-terrestrial-systems.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _frontend-property-terrestrial-systems:
 
 ***********************************************
diff --git a/Documentation/media/uapi/dvb/frontend-stat-properties.rst b/Documentation/media/uapi/dvb/frontend-stat-properties.rst
index e73754fd0631..fc55b1086d40 100644
--- a/Documentation/media/uapi/dvb/frontend-stat-properties.rst
+++ b/Documentation/media/uapi/dvb/frontend-stat-properties.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _frontend-stat-properties:
 
 ******************************
diff --git a/Documentation/media/uapi/dvb/frontend.rst b/Documentation/media/uapi/dvb/frontend.rst
index 4967c48d46ce..b528c8fd6f63 100644
--- a/Documentation/media/uapi/dvb/frontend.rst
+++ b/Documentation/media/uapi/dvb/frontend.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _dvb_frontend:
 
 #######################
diff --git a/Documentation/media/uapi/dvb/frontend_f_close.rst b/Documentation/media/uapi/dvb/frontend_f_close.rst
index 67958d73cf34..3990c5aff1ac 100644
--- a/Documentation/media/uapi/dvb/frontend_f_close.rst
+++ b/Documentation/media/uapi/dvb/frontend_f_close.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _frontend_f_close:
 
 ***************************
diff --git a/Documentation/media/uapi/dvb/frontend_f_open.rst b/Documentation/media/uapi/dvb/frontend_f_open.rst
index 8e8cb466c24b..8e6fdeaa1e2e 100644
--- a/Documentation/media/uapi/dvb/frontend_f_open.rst
+++ b/Documentation/media/uapi/dvb/frontend_f_open.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _frontend_f_open:
 
 ***************************
diff --git a/Documentation/media/uapi/dvb/frontend_fcalls.rst b/Documentation/media/uapi/dvb/frontend_fcalls.rst
index b03f9cab6d5a..0c652f945f95 100644
--- a/Documentation/media/uapi/dvb/frontend_fcalls.rst
+++ b/Documentation/media/uapi/dvb/frontend_fcalls.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _frontend_fcalls:
 
 #######################
diff --git a/Documentation/media/uapi/dvb/frontend_legacy_api.rst b/Documentation/media/uapi/dvb/frontend_legacy_api.rst
index 759833d3eaa4..e4e85be5ea22 100644
--- a/Documentation/media/uapi/dvb/frontend_legacy_api.rst
+++ b/Documentation/media/uapi/dvb/frontend_legacy_api.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _frontend_legacy_types:
 
 Frontend Legacy Data Types
diff --git a/Documentation/media/uapi/dvb/frontend_legacy_dvbv3_api.rst b/Documentation/media/uapi/dvb/frontend_legacy_dvbv3_api.rst
index a4d5319cb76b..d52121272570 100644
--- a/Documentation/media/uapi/dvb/frontend_legacy_dvbv3_api.rst
+++ b/Documentation/media/uapi/dvb/frontend_legacy_dvbv3_api.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _frontend_legacy_dvbv3_api:
 
 ***********************************************
diff --git a/Documentation/media/uapi/dvb/intro.rst b/Documentation/media/uapi/dvb/intro.rst
index 79b4d0e4e920..c62023f76427 100644
--- a/Documentation/media/uapi/dvb/intro.rst
+++ b/Documentation/media/uapi/dvb/intro.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _dvb_introdution:
 
 ************
diff --git a/Documentation/media/uapi/dvb/legacy_dvb_apis.rst b/Documentation/media/uapi/dvb/legacy_dvb_apis.rst
index e1b2c9c7b620..8f14296036eb 100644
--- a/Documentation/media/uapi/dvb/legacy_dvb_apis.rst
+++ b/Documentation/media/uapi/dvb/legacy_dvb_apis.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _legacy_dvb_apis:
 
 ***************************
diff --git a/Documentation/media/uapi/dvb/net-add-if.rst b/Documentation/media/uapi/dvb/net-add-if.rst
index 6749b70246c5..f0c3b897aae4 100644
--- a/Documentation/media/uapi/dvb/net-add-if.rst
+++ b/Documentation/media/uapi/dvb/net-add-if.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _NET_ADD_IF:
 
 ****************
diff --git a/Documentation/media/uapi/dvb/net-get-if.rst b/Documentation/media/uapi/dvb/net-get-if.rst
index 3733b34da9db..d30e70920ae4 100644
--- a/Documentation/media/uapi/dvb/net-get-if.rst
+++ b/Documentation/media/uapi/dvb/net-get-if.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _NET_GET_IF:
 
 ****************
diff --git a/Documentation/media/uapi/dvb/net-remove-if.rst b/Documentation/media/uapi/dvb/net-remove-if.rst
index 4ebe07a6b79a..0975765fa624 100644
--- a/Documentation/media/uapi/dvb/net-remove-if.rst
+++ b/Documentation/media/uapi/dvb/net-remove-if.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _NET_REMOVE_IF:
 
 *******************
diff --git a/Documentation/media/uapi/dvb/net-types.rst b/Documentation/media/uapi/dvb/net-types.rst
index 8fa3292eaa42..b65111dfd4c0 100644
--- a/Documentation/media/uapi/dvb/net-types.rst
+++ b/Documentation/media/uapi/dvb/net-types.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _net_types:
 
 **************
diff --git a/Documentation/media/uapi/dvb/net.rst b/Documentation/media/uapi/dvb/net.rst
index e0cd4e402627..392b923f3e26 100644
--- a/Documentation/media/uapi/dvb/net.rst
+++ b/Documentation/media/uapi/dvb/net.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _net:
 
 ######################
diff --git a/Documentation/media/uapi/dvb/query-dvb-frontend-info.rst b/Documentation/media/uapi/dvb/query-dvb-frontend-info.rst
index 51ec0b04b496..2bb3909b4165 100644
--- a/Documentation/media/uapi/dvb/query-dvb-frontend-info.rst
+++ b/Documentation/media/uapi/dvb/query-dvb-frontend-info.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _query-dvb-frontend-info:
 
 *****************************
diff --git a/Documentation/media/uapi/dvb/video-clear-buffer.rst b/Documentation/media/uapi/dvb/video-clear-buffer.rst
index 2e51a78a69f1..e576eef4232d 100644
--- a/Documentation/media/uapi/dvb/video-clear-buffer.rst
+++ b/Documentation/media/uapi/dvb/video-clear-buffer.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDEO_CLEAR_BUFFER:
 
 ==================
diff --git a/Documentation/media/uapi/dvb/video-command.rst b/Documentation/media/uapi/dvb/video-command.rst
index 536d0fdd8399..fd17b5396b02 100644
--- a/Documentation/media/uapi/dvb/video-command.rst
+++ b/Documentation/media/uapi/dvb/video-command.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDEO_COMMAND:
 
 =============
diff --git a/Documentation/media/uapi/dvb/video-continue.rst b/Documentation/media/uapi/dvb/video-continue.rst
index e65e600be632..e63a2c26ead1 100644
--- a/Documentation/media/uapi/dvb/video-continue.rst
+++ b/Documentation/media/uapi/dvb/video-continue.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDEO_CONTINUE:
 
 ==============
diff --git a/Documentation/media/uapi/dvb/video-fast-forward.rst b/Documentation/media/uapi/dvb/video-fast-forward.rst
index 70a53e110335..da6d76f918fa 100644
--- a/Documentation/media/uapi/dvb/video-fast-forward.rst
+++ b/Documentation/media/uapi/dvb/video-fast-forward.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDEO_FAST_FORWARD:
 
 ==================
diff --git a/Documentation/media/uapi/dvb/video-fclose.rst b/Documentation/media/uapi/dvb/video-fclose.rst
index 8a997ae6f6a7..cf569f45ce46 100644
--- a/Documentation/media/uapi/dvb/video-fclose.rst
+++ b/Documentation/media/uapi/dvb/video-fclose.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _video_fclose:
 
 =================
diff --git a/Documentation/media/uapi/dvb/video-fopen.rst b/Documentation/media/uapi/dvb/video-fopen.rst
index 203a2c56f10a..4565126892aa 100644
--- a/Documentation/media/uapi/dvb/video-fopen.rst
+++ b/Documentation/media/uapi/dvb/video-fopen.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _video_fopen:
 
 ================
diff --git a/Documentation/media/uapi/dvb/video-freeze.rst b/Documentation/media/uapi/dvb/video-freeze.rst
index 5a28bdc8badd..5f85ab59d041 100644
--- a/Documentation/media/uapi/dvb/video-freeze.rst
+++ b/Documentation/media/uapi/dvb/video-freeze.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDEO_FREEZE:
 
 ============
diff --git a/Documentation/media/uapi/dvb/video-fwrite.rst b/Documentation/media/uapi/dvb/video-fwrite.rst
index cfe7c57dcfc7..ab0948faaf92 100644
--- a/Documentation/media/uapi/dvb/video-fwrite.rst
+++ b/Documentation/media/uapi/dvb/video-fwrite.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _video_fwrite:
 
 =================
diff --git a/Documentation/media/uapi/dvb/video-get-capabilities.rst b/Documentation/media/uapi/dvb/video-get-capabilities.rst
index 6987f659a1ad..0c6ce95dbd42 100644
--- a/Documentation/media/uapi/dvb/video-get-capabilities.rst
+++ b/Documentation/media/uapi/dvb/video-get-capabilities.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDEO_GET_CAPABILITIES:
 
 ======================
diff --git a/Documentation/media/uapi/dvb/video-get-event.rst b/Documentation/media/uapi/dvb/video-get-event.rst
index b4f53616db9a..9baa2bd41785 100644
--- a/Documentation/media/uapi/dvb/video-get-event.rst
+++ b/Documentation/media/uapi/dvb/video-get-event.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDEO_GET_EVENT:
 
 ===============
diff --git a/Documentation/media/uapi/dvb/video-get-frame-count.rst b/Documentation/media/uapi/dvb/video-get-frame-count.rst
index 0ffe22cd6108..abb1e9819b4f 100644
--- a/Documentation/media/uapi/dvb/video-get-frame-count.rst
+++ b/Documentation/media/uapi/dvb/video-get-frame-count.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDEO_GET_FRAME_COUNT:
 
 =====================
diff --git a/Documentation/media/uapi/dvb/video-get-pts.rst b/Documentation/media/uapi/dvb/video-get-pts.rst
index c73f86f1d35b..604feefd1db5 100644
--- a/Documentation/media/uapi/dvb/video-get-pts.rst
+++ b/Documentation/media/uapi/dvb/video-get-pts.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDEO_GET_PTS:
 
 =============
diff --git a/Documentation/media/uapi/dvb/video-get-size.rst b/Documentation/media/uapi/dvb/video-get-size.rst
index d077fe2305a0..e54bb336cda9 100644
--- a/Documentation/media/uapi/dvb/video-get-size.rst
+++ b/Documentation/media/uapi/dvb/video-get-size.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDEO_GET_SIZE:
 
 ==============
diff --git a/Documentation/media/uapi/dvb/video-get-status.rst b/Documentation/media/uapi/dvb/video-get-status.rst
index ed6ea19827a6..fb66b8e85ee4 100644
--- a/Documentation/media/uapi/dvb/video-get-status.rst
+++ b/Documentation/media/uapi/dvb/video-get-status.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDEO_GET_STATUS:
 
 ================
diff --git a/Documentation/media/uapi/dvb/video-play.rst b/Documentation/media/uapi/dvb/video-play.rst
index 2124120aec22..deb94407f40a 100644
--- a/Documentation/media/uapi/dvb/video-play.rst
+++ b/Documentation/media/uapi/dvb/video-play.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDEO_PLAY:
 
 ==========
diff --git a/Documentation/media/uapi/dvb/video-select-source.rst b/Documentation/media/uapi/dvb/video-select-source.rst
index cde6542723ca..ff6720d54778 100644
--- a/Documentation/media/uapi/dvb/video-select-source.rst
+++ b/Documentation/media/uapi/dvb/video-select-source.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDEO_SELECT_SOURCE:
 
 ===================
diff --git a/Documentation/media/uapi/dvb/video-set-blank.rst b/Documentation/media/uapi/dvb/video-set-blank.rst
index 3858c69496a5..38a06ac72a0f 100644
--- a/Documentation/media/uapi/dvb/video-set-blank.rst
+++ b/Documentation/media/uapi/dvb/video-set-blank.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDEO_SET_BLANK:
 
 ===============
diff --git a/Documentation/media/uapi/dvb/video-set-display-format.rst b/Documentation/media/uapi/dvb/video-set-display-format.rst
index 2ef7401781be..1c575431304e 100644
--- a/Documentation/media/uapi/dvb/video-set-display-format.rst
+++ b/Documentation/media/uapi/dvb/video-set-display-format.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDEO_SET_DISPLAY_FORMAT:
 
 ========================
diff --git a/Documentation/media/uapi/dvb/video-set-format.rst b/Documentation/media/uapi/dvb/video-set-format.rst
index 4239a4e365bb..2b2b6d42a0ee 100644
--- a/Documentation/media/uapi/dvb/video-set-format.rst
+++ b/Documentation/media/uapi/dvb/video-set-format.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDEO_SET_FORMAT:
 
 ================
diff --git a/Documentation/media/uapi/dvb/video-set-streamtype.rst b/Documentation/media/uapi/dvb/video-set-streamtype.rst
index 02a3c2e4e67c..a31b0e32d13a 100644
--- a/Documentation/media/uapi/dvb/video-set-streamtype.rst
+++ b/Documentation/media/uapi/dvb/video-set-streamtype.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDEO_SET_STREAMTYPE:
 
 ====================
diff --git a/Documentation/media/uapi/dvb/video-slowmotion.rst b/Documentation/media/uapi/dvb/video-slowmotion.rst
index bd3d1a4070d9..632cec3af57e 100644
--- a/Documentation/media/uapi/dvb/video-slowmotion.rst
+++ b/Documentation/media/uapi/dvb/video-slowmotion.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDEO_SLOWMOTION:
 
 ================
diff --git a/Documentation/media/uapi/dvb/video-stillpicture.rst b/Documentation/media/uapi/dvb/video-stillpicture.rst
index 6f943f5e27bd..acd63e097b87 100644
--- a/Documentation/media/uapi/dvb/video-stillpicture.rst
+++ b/Documentation/media/uapi/dvb/video-stillpicture.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDEO_STILLPICTURE:
 
 ==================
diff --git a/Documentation/media/uapi/dvb/video-stop.rst b/Documentation/media/uapi/dvb/video-stop.rst
index 474309ad31c2..128935c9c651 100644
--- a/Documentation/media/uapi/dvb/video-stop.rst
+++ b/Documentation/media/uapi/dvb/video-stop.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDEO_STOP:
 
 ==========
diff --git a/Documentation/media/uapi/dvb/video-try-command.rst b/Documentation/media/uapi/dvb/video-try-command.rst
index 008e6a9ab696..c6dabb8f2ab2 100644
--- a/Documentation/media/uapi/dvb/video-try-command.rst
+++ b/Documentation/media/uapi/dvb/video-try-command.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDEO_TRY_COMMAND:
 
 =================
diff --git a/Documentation/media/uapi/dvb/video.rst b/Documentation/media/uapi/dvb/video.rst
index e7d68cd0cf23..fce55c7b3799 100644
--- a/Documentation/media/uapi/dvb/video.rst
+++ b/Documentation/media/uapi/dvb/video.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _dvb_video:
 
 #######################
diff --git a/Documentation/media/uapi/dvb/video_function_calls.rst b/Documentation/media/uapi/dvb/video_function_calls.rst
index a4222b6cd2d3..9b65cf375392 100644
--- a/Documentation/media/uapi/dvb/video_function_calls.rst
+++ b/Documentation/media/uapi/dvb/video_function_calls.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _video_function_calls:
 
 ********************
diff --git a/Documentation/media/uapi/dvb/video_types.rst b/Documentation/media/uapi/dvb/video_types.rst
index a0942171596c..a0855096263a 100644
--- a/Documentation/media/uapi/dvb/video_types.rst
+++ b/Documentation/media/uapi/dvb/video_types.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _video_types:
 
 ****************
diff --git a/Documentation/media/uapi/fdl-appendix.rst b/Documentation/media/uapi/fdl-appendix.rst
index fd475180fed8..a0e4199a8963 100644
--- a/Documentation/media/uapi/fdl-appendix.rst
+++ b/Documentation/media/uapi/fdl-appendix.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _fdl:
 
 ******************************
diff --git a/Documentation/media/uapi/gen-errors.rst b/Documentation/media/uapi/gen-errors.rst
index 689d3b101ede..fc109c7dfd9f 100644
--- a/Documentation/media/uapi/gen-errors.rst
+++ b/Documentation/media/uapi/gen-errors.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _gen_errors:
 
 *******************
diff --git a/Documentation/media/uapi/mediactl/media-controller-intro.rst b/Documentation/media/uapi/mediactl/media-controller-intro.rst
index 3e776c0d8276..71151556abba 100644
--- a/Documentation/media/uapi/mediactl/media-controller-intro.rst
+++ b/Documentation/media/uapi/mediactl/media-controller-intro.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _media-controller-intro:
 
 Introduction
diff --git a/Documentation/media/uapi/mediactl/media-controller-model.rst b/Documentation/media/uapi/mediactl/media-controller-model.rst
index 558273cf9570..d6fe93921ec9 100644
--- a/Documentation/media/uapi/mediactl/media-controller-model.rst
+++ b/Documentation/media/uapi/mediactl/media-controller-model.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _media-controller-model:
 
 Media device model
diff --git a/Documentation/media/uapi/mediactl/media-controller.rst b/Documentation/media/uapi/mediactl/media-controller.rst
index 66aff38cd499..be3da0001831 100644
--- a/Documentation/media/uapi/mediactl/media-controller.rst
+++ b/Documentation/media/uapi/mediactl/media-controller.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. include:: <isonum.txt>
 
 .. _media_controller:
diff --git a/Documentation/media/uapi/mediactl/media-func-close.rst b/Documentation/media/uapi/mediactl/media-func-close.rst
index a8f5203afe4b..7a9b2997a10e 100644
--- a/Documentation/media/uapi/mediactl/media-func-close.rst
+++ b/Documentation/media/uapi/mediactl/media-func-close.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _media-func-close:
 
 *************
diff --git a/Documentation/media/uapi/mediactl/media-func-ioctl.rst b/Documentation/media/uapi/mediactl/media-func-ioctl.rst
index fe072b7c8765..846bea9f5e5b 100644
--- a/Documentation/media/uapi/mediactl/media-func-ioctl.rst
+++ b/Documentation/media/uapi/mediactl/media-func-ioctl.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _media-func-ioctl:
 
 *************
diff --git a/Documentation/media/uapi/mediactl/media-func-open.rst b/Documentation/media/uapi/mediactl/media-func-open.rst
index 32f53016a9e5..e4c82f697c04 100644
--- a/Documentation/media/uapi/mediactl/media-func-open.rst
+++ b/Documentation/media/uapi/mediactl/media-func-open.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _media-func-open:
 
 ************
diff --git a/Documentation/media/uapi/mediactl/media-header.rst b/Documentation/media/uapi/mediactl/media-header.rst
index 96f7b0155e5a..b9b9e09a6142 100644
--- a/Documentation/media/uapi/mediactl/media-header.rst
+++ b/Documentation/media/uapi/mediactl/media-header.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _media_header:
 
 ****************************
diff --git a/Documentation/media/uapi/mediactl/media-ioc-device-info.rst b/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
index c6f224e404b7..bcffa8c1c825 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _media_ioc_device_info:
 
 ***************************
diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
index 02738640e34e..585c42814848 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _media_ioc_enum_entities:
 
 *****************************
diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
index b89aaae373df..ef1a0ac70dd1 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _media_ioc_enum_links:
 
 **************************
diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
index 4e1c59238371..54cc2bb9edf6 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _media_ioc_g_topology:
 
 **************************
diff --git a/Documentation/media/uapi/mediactl/media-ioc-setup-link.rst b/Documentation/media/uapi/mediactl/media-ioc-setup-link.rst
index e345e7dc9ad7..d049bfbef281 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-setup-link.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-setup-link.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _media_ioc_setup_link:
 
 **************************
diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
index e4c57c8f4553..d558e0009ac1 100644
--- a/Documentation/media/uapi/mediactl/media-types.rst
+++ b/Documentation/media/uapi/mediactl/media-types.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _media-controller-types:
 
 Types and flags used to represent the media graph elements
diff --git a/Documentation/media/uapi/rc/keytable.c.rst b/Documentation/media/uapi/rc/keytable.c.rst
index 217237f93b37..d21190d85dd9 100644
--- a/Documentation/media/uapi/rc/keytable.c.rst
+++ b/Documentation/media/uapi/rc/keytable.c.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 file: uapi/v4l/keytable.c
 =========================
 
diff --git a/Documentation/media/uapi/rc/lirc-dev-intro.rst b/Documentation/media/uapi/rc/lirc-dev-intro.rst
index 11516c8bff62..c9f28540a3ed 100644
--- a/Documentation/media/uapi/rc/lirc-dev-intro.rst
+++ b/Documentation/media/uapi/rc/lirc-dev-intro.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _lirc_dev_intro:
 
 ************
diff --git a/Documentation/media/uapi/rc/lirc-dev.rst b/Documentation/media/uapi/rc/lirc-dev.rst
index 03cde25f5859..2acaed70ff31 100644
--- a/Documentation/media/uapi/rc/lirc-dev.rst
+++ b/Documentation/media/uapi/rc/lirc-dev.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _lirc_dev:
 
 LIRC Device Interface
diff --git a/Documentation/media/uapi/rc/lirc-func.rst b/Documentation/media/uapi/rc/lirc-func.rst
index ddb4620de294..57b2d8f8097c 100644
--- a/Documentation/media/uapi/rc/lirc-func.rst
+++ b/Documentation/media/uapi/rc/lirc-func.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _lirc_func:
 
 LIRC Function Reference
diff --git a/Documentation/media/uapi/rc/lirc-get-features.rst b/Documentation/media/uapi/rc/lirc-get-features.rst
index 889a8807037b..3b7c96367d72 100644
--- a/Documentation/media/uapi/rc/lirc-get-features.rst
+++ b/Documentation/media/uapi/rc/lirc-get-features.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _lirc_get_features:
 
 ***********************
diff --git a/Documentation/media/uapi/rc/lirc-get-rec-mode.rst b/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
index 2722118484fa..cd4f734ef7ae 100644
--- a/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
+++ b/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _lirc_get_rec_mode:
 .. _lirc_set_rec_mode:
 
diff --git a/Documentation/media/uapi/rc/lirc-get-rec-resolution.rst b/Documentation/media/uapi/rc/lirc-get-rec-resolution.rst
index 6e016edc2bc4..2cae9f003e75 100644
--- a/Documentation/media/uapi/rc/lirc-get-rec-resolution.rst
+++ b/Documentation/media/uapi/rc/lirc-get-rec-resolution.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _lirc_get_rec_resolution:
 
 *****************************
diff --git a/Documentation/media/uapi/rc/lirc-get-send-mode.rst b/Documentation/media/uapi/rc/lirc-get-send-mode.rst
index c44e61a79ad1..45ed5c64989b 100644
--- a/Documentation/media/uapi/rc/lirc-get-send-mode.rst
+++ b/Documentation/media/uapi/rc/lirc-get-send-mode.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _lirc_get_send_mode:
 .. _lirc_set_send_mode:
 
diff --git a/Documentation/media/uapi/rc/lirc-get-timeout.rst b/Documentation/media/uapi/rc/lirc-get-timeout.rst
index c94bc5dcaa8e..714fbe23f475 100644
--- a/Documentation/media/uapi/rc/lirc-get-timeout.rst
+++ b/Documentation/media/uapi/rc/lirc-get-timeout.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _lirc_get_min_timeout:
 .. _lirc_get_max_timeout:
 
diff --git a/Documentation/media/uapi/rc/lirc-header.rst b/Documentation/media/uapi/rc/lirc-header.rst
index 487fe00e5517..1022c9de003f 100644
--- a/Documentation/media/uapi/rc/lirc-header.rst
+++ b/Documentation/media/uapi/rc/lirc-header.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _lirc_header:
 
 ****************
diff --git a/Documentation/media/uapi/rc/lirc-read.rst b/Documentation/media/uapi/rc/lirc-read.rst
index c024aaffb8ad..906caa099f1c 100644
--- a/Documentation/media/uapi/rc/lirc-read.rst
+++ b/Documentation/media/uapi/rc/lirc-read.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _lirc-read:
 
 ***********
diff --git a/Documentation/media/uapi/rc/lirc-set-measure-carrier-mode.rst b/Documentation/media/uapi/rc/lirc-set-measure-carrier-mode.rst
index 6307b5715595..14d1e3edbfa7 100644
--- a/Documentation/media/uapi/rc/lirc-set-measure-carrier-mode.rst
+++ b/Documentation/media/uapi/rc/lirc-set-measure-carrier-mode.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _lirc_set_measure_carrier_mode:
 
 ***********************************
diff --git a/Documentation/media/uapi/rc/lirc-set-rec-carrier-range.rst b/Documentation/media/uapi/rc/lirc-set-rec-carrier-range.rst
index a89246806c4b..87566930f535 100644
--- a/Documentation/media/uapi/rc/lirc-set-rec-carrier-range.rst
+++ b/Documentation/media/uapi/rc/lirc-set-rec-carrier-range.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _lirc_set_rec_carrier_range:
 
 ********************************
diff --git a/Documentation/media/uapi/rc/lirc-set-rec-carrier.rst b/Documentation/media/uapi/rc/lirc-set-rec-carrier.rst
index a411c0330818..f0aefbadd794 100644
--- a/Documentation/media/uapi/rc/lirc-set-rec-carrier.rst
+++ b/Documentation/media/uapi/rc/lirc-set-rec-carrier.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _lirc_set_rec_carrier:
 
 **************************
diff --git a/Documentation/media/uapi/rc/lirc-set-rec-timeout-reports.rst b/Documentation/media/uapi/rc/lirc-set-rec-timeout-reports.rst
index 86353e602695..3b8c28a894f0 100644
--- a/Documentation/media/uapi/rc/lirc-set-rec-timeout-reports.rst
+++ b/Documentation/media/uapi/rc/lirc-set-rec-timeout-reports.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _lirc_set_rec_timeout_reports:
 
 **********************************
diff --git a/Documentation/media/uapi/rc/lirc-set-rec-timeout.rst b/Documentation/media/uapi/rc/lirc-set-rec-timeout.rst
index a833a6a4c25a..1af13b348034 100644
--- a/Documentation/media/uapi/rc/lirc-set-rec-timeout.rst
+++ b/Documentation/media/uapi/rc/lirc-set-rec-timeout.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _lirc_set_rec_timeout:
 .. _lirc_get_rec_timeout:
 
diff --git a/Documentation/media/uapi/rc/lirc-set-send-carrier.rst b/Documentation/media/uapi/rc/lirc-set-send-carrier.rst
index 42c8cfb42df5..14e779db3ed3 100644
--- a/Documentation/media/uapi/rc/lirc-set-send-carrier.rst
+++ b/Documentation/media/uapi/rc/lirc-set-send-carrier.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _lirc_set_send_carrier:
 
 ***************************
diff --git a/Documentation/media/uapi/rc/lirc-set-send-duty-cycle.rst b/Documentation/media/uapi/rc/lirc-set-send-duty-cycle.rst
index 20d07c2a37a5..08438747d608 100644
--- a/Documentation/media/uapi/rc/lirc-set-send-duty-cycle.rst
+++ b/Documentation/media/uapi/rc/lirc-set-send-duty-cycle.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _lirc_set_send_duty_cycle:
 
 ******************************
diff --git a/Documentation/media/uapi/rc/lirc-set-transmitter-mask.rst b/Documentation/media/uapi/rc/lirc-set-transmitter-mask.rst
index 69b7ad8c2afb..2a74b7d58bf2 100644
--- a/Documentation/media/uapi/rc/lirc-set-transmitter-mask.rst
+++ b/Documentation/media/uapi/rc/lirc-set-transmitter-mask.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _lirc_set_transmitter_mask:
 
 *******************************
diff --git a/Documentation/media/uapi/rc/lirc-set-wideband-receiver.rst b/Documentation/media/uapi/rc/lirc-set-wideband-receiver.rst
index 0415c6a54f23..63b4eeaec9e0 100644
--- a/Documentation/media/uapi/rc/lirc-set-wideband-receiver.rst
+++ b/Documentation/media/uapi/rc/lirc-set-wideband-receiver.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _lirc_set_wideband_receiver:
 
 ********************************
diff --git a/Documentation/media/uapi/rc/lirc-write.rst b/Documentation/media/uapi/rc/lirc-write.rst
index d4566b0a2015..4d3e66ca6ee3 100644
--- a/Documentation/media/uapi/rc/lirc-write.rst
+++ b/Documentation/media/uapi/rc/lirc-write.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _lirc-write:
 
 ************
diff --git a/Documentation/media/uapi/rc/rc-intro.rst b/Documentation/media/uapi/rc/rc-intro.rst
index 3707c29d37ed..5046cc282d62 100644
--- a/Documentation/media/uapi/rc/rc-intro.rst
+++ b/Documentation/media/uapi/rc/rc-intro.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _Remote_controllers_Intro:
 
 ************
diff --git a/Documentation/media/uapi/rc/rc-sysfs-nodes.rst b/Documentation/media/uapi/rc/rc-sysfs-nodes.rst
index 2d01358d5504..634c4fcd08af 100644
--- a/Documentation/media/uapi/rc/rc-sysfs-nodes.rst
+++ b/Documentation/media/uapi/rc/rc-sysfs-nodes.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _remote_controllers_sysfs_nodes:
 
 *******************************
diff --git a/Documentation/media/uapi/rc/rc-table-change.rst b/Documentation/media/uapi/rc/rc-table-change.rst
index d604896bca87..b3605cb0e4b2 100644
--- a/Documentation/media/uapi/rc/rc-table-change.rst
+++ b/Documentation/media/uapi/rc/rc-table-change.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _Remote_controllers_table_change:
 
 *******************************************
diff --git a/Documentation/media/uapi/rc/rc-tables.rst b/Documentation/media/uapi/rc/rc-tables.rst
index c8ae9479f842..d4d842b8834c 100644
--- a/Documentation/media/uapi/rc/rc-tables.rst
+++ b/Documentation/media/uapi/rc/rc-tables.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _Remote_controllers_tables:
 
 ************************
diff --git a/Documentation/media/uapi/rc/remote_controllers.rst b/Documentation/media/uapi/rc/remote_controllers.rst
index 46a8acb82125..985b3aedaefe 100644
--- a/Documentation/media/uapi/rc/remote_controllers.rst
+++ b/Documentation/media/uapi/rc/remote_controllers.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. include:: <isonum.txt>
 
 .. _remote_controllers:
diff --git a/Documentation/media/uapi/v4l/app-pri.rst b/Documentation/media/uapi/v4l/app-pri.rst
index e03929ebe899..7619c81fdd3f 100644
--- a/Documentation/media/uapi/v4l/app-pri.rst
+++ b/Documentation/media/uapi/v4l/app-pri.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _app-pri:
 
 ********************
diff --git a/Documentation/media/uapi/v4l/async.rst b/Documentation/media/uapi/v4l/async.rst
index 5affc0adb95b..d81508f42010 100644
--- a/Documentation/media/uapi/v4l/async.rst
+++ b/Documentation/media/uapi/v4l/async.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _async:
 
 ****************
diff --git a/Documentation/media/uapi/v4l/audio.rst b/Documentation/media/uapi/v4l/audio.rst
index 725a61b59cb1..3c9dda00a5e5 100644
--- a/Documentation/media/uapi/v4l/audio.rst
+++ b/Documentation/media/uapi/v4l/audio.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _audio:
 
 ************************
diff --git a/Documentation/media/uapi/v4l/biblio.rst b/Documentation/media/uapi/v4l/biblio.rst
index 386d6cf83e9c..41f449371f38 100644
--- a/Documentation/media/uapi/v4l/biblio.rst
+++ b/Documentation/media/uapi/v4l/biblio.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 **********
 References
 **********
diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index 2e266d32470a..360eeb2e5a29 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _buffer:
 
 *******
diff --git a/Documentation/media/uapi/v4l/capture-example.rst b/Documentation/media/uapi/v4l/capture-example.rst
index ac1cd057e25b..208cad3d1c89 100644
--- a/Documentation/media/uapi/v4l/capture-example.rst
+++ b/Documentation/media/uapi/v4l/capture-example.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _capture-example:
 
 *********************
diff --git a/Documentation/media/uapi/v4l/capture.c.rst b/Documentation/media/uapi/v4l/capture.c.rst
index 56525a0fb2fa..08f507aee9f0 100644
--- a/Documentation/media/uapi/v4l/capture.c.rst
+++ b/Documentation/media/uapi/v4l/capture.c.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 file: media/v4l/capture.c
 =========================
 
diff --git a/Documentation/media/uapi/v4l/colorspaces-defs.rst b/Documentation/media/uapi/v4l/colorspaces-defs.rst
index f24615544792..3ed71a0bf9f5 100644
--- a/Documentation/media/uapi/v4l/colorspaces-defs.rst
+++ b/Documentation/media/uapi/v4l/colorspaces-defs.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 ****************************
 Defining Colorspaces in V4L2
 ****************************
diff --git a/Documentation/media/uapi/v4l/colorspaces-details.rst b/Documentation/media/uapi/v4l/colorspaces-details.rst
index 09fabf4cd412..b4c89f009698 100644
--- a/Documentation/media/uapi/v4l/colorspaces-details.rst
+++ b/Documentation/media/uapi/v4l/colorspaces-details.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 ********************************
 Detailed Colorspace Descriptions
 ********************************
diff --git a/Documentation/media/uapi/v4l/colorspaces.rst b/Documentation/media/uapi/v4l/colorspaces.rst
index 322eb94c1d44..6efc8327d0ee 100644
--- a/Documentation/media/uapi/v4l/colorspaces.rst
+++ b/Documentation/media/uapi/v4l/colorspaces.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _colorspaces:
 
 ***********
diff --git a/Documentation/media/uapi/v4l/common-defs.rst b/Documentation/media/uapi/v4l/common-defs.rst
index 39058216b630..3c162ca5ba0d 100644
--- a/Documentation/media/uapi/v4l/common-defs.rst
+++ b/Documentation/media/uapi/v4l/common-defs.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _common-defs:
 
 ******************************************************
diff --git a/Documentation/media/uapi/v4l/common.rst b/Documentation/media/uapi/v4l/common.rst
index 5f93e71122ef..61d1daddde61 100644
--- a/Documentation/media/uapi/v4l/common.rst
+++ b/Documentation/media/uapi/v4l/common.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _common:
 
 ###################
diff --git a/Documentation/media/uapi/v4l/compat.rst b/Documentation/media/uapi/v4l/compat.rst
index 8b5e1cebd8f4..0329bd197e4b 100644
--- a/Documentation/media/uapi/v4l/compat.rst
+++ b/Documentation/media/uapi/v4l/compat.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _compat:
 
 *******
diff --git a/Documentation/media/uapi/v4l/control.rst b/Documentation/media/uapi/v4l/control.rst
index c1e6adbe83d7..8bffd3082b17 100644
--- a/Documentation/media/uapi/v4l/control.rst
+++ b/Documentation/media/uapi/v4l/control.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _control:
 
 *************
diff --git a/Documentation/media/uapi/v4l/crop.rst b/Documentation/media/uapi/v4l/crop.rst
index 45e8a895a320..3783288cc545 100644
--- a/Documentation/media/uapi/v4l/crop.rst
+++ b/Documentation/media/uapi/v4l/crop.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _crop:
 
 *****************************************************
diff --git a/Documentation/media/uapi/v4l/depth-formats.rst b/Documentation/media/uapi/v4l/depth-formats.rst
index d1641e9687a6..63a2e64c5a92 100644
--- a/Documentation/media/uapi/v4l/depth-formats.rst
+++ b/Documentation/media/uapi/v4l/depth-formats.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _depth-formats:
 
 *************
diff --git a/Documentation/media/uapi/v4l/dev-capture.rst b/Documentation/media/uapi/v4l/dev-capture.rst
index 09949ac54be4..004e3805b922 100644
--- a/Documentation/media/uapi/v4l/dev-capture.rst
+++ b/Documentation/media/uapi/v4l/dev-capture.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _capture:
 
 ***********************
diff --git a/Documentation/media/uapi/v4l/dev-codec.rst b/Documentation/media/uapi/v4l/dev-codec.rst
index c61e938bd8dc..a50cdfe1309c 100644
--- a/Documentation/media/uapi/v4l/dev-codec.rst
+++ b/Documentation/media/uapi/v4l/dev-codec.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _codec:
 
 ***************
diff --git a/Documentation/media/uapi/v4l/dev-effect.rst b/Documentation/media/uapi/v4l/dev-effect.rst
index b946cc9e1064..bff730f7883b 100644
--- a/Documentation/media/uapi/v4l/dev-effect.rst
+++ b/Documentation/media/uapi/v4l/dev-effect.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _effect:
 
 ************************
diff --git a/Documentation/media/uapi/v4l/dev-event.rst b/Documentation/media/uapi/v4l/dev-event.rst
index a06ec4d65359..42e87bdb5f3e 100644
--- a/Documentation/media/uapi/v4l/dev-event.rst
+++ b/Documentation/media/uapi/v4l/dev-event.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _event:
 
 ***************
diff --git a/Documentation/media/uapi/v4l/dev-meta.rst b/Documentation/media/uapi/v4l/dev-meta.rst
index b65dc078abeb..d95981a90111 100644
--- a/Documentation/media/uapi/v4l/dev-meta.rst
+++ b/Documentation/media/uapi/v4l/dev-meta.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _metadata:
 
 ******************
diff --git a/Documentation/media/uapi/v4l/dev-osd.rst b/Documentation/media/uapi/v4l/dev-osd.rst
index 71da85ed7e4b..ba8be764fc09 100644
--- a/Documentation/media/uapi/v4l/dev-osd.rst
+++ b/Documentation/media/uapi/v4l/dev-osd.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _osd:
 
 ******************************
diff --git a/Documentation/media/uapi/v4l/dev-output.rst b/Documentation/media/uapi/v4l/dev-output.rst
index 342eb4931f5c..9d6ab2160d1e 100644
--- a/Documentation/media/uapi/v4l/dev-output.rst
+++ b/Documentation/media/uapi/v4l/dev-output.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _output:
 
 **********************
diff --git a/Documentation/media/uapi/v4l/dev-overlay.rst b/Documentation/media/uapi/v4l/dev-overlay.rst
index 9be14b55e305..eed0599a96e5 100644
--- a/Documentation/media/uapi/v4l/dev-overlay.rst
+++ b/Documentation/media/uapi/v4l/dev-overlay.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _overlay:
 
 ***********************
diff --git a/Documentation/media/uapi/v4l/dev-radio.rst b/Documentation/media/uapi/v4l/dev-radio.rst
index 2b5b836574eb..6d73fcd83f65 100644
--- a/Documentation/media/uapi/v4l/dev-radio.rst
+++ b/Documentation/media/uapi/v4l/dev-radio.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _radio:
 
 ***************
diff --git a/Documentation/media/uapi/v4l/dev-raw-vbi.rst b/Documentation/media/uapi/v4l/dev-raw-vbi.rst
index 2e6878b624f6..cab18cda3ef8 100644
--- a/Documentation/media/uapi/v4l/dev-raw-vbi.rst
+++ b/Documentation/media/uapi/v4l/dev-raw-vbi.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _raw-vbi:
 
 **********************
diff --git a/Documentation/media/uapi/v4l/dev-rds.rst b/Documentation/media/uapi/v4l/dev-rds.rst
index 9c4e39dd66bd..4a1b9f41a317 100644
--- a/Documentation/media/uapi/v4l/dev-rds.rst
+++ b/Documentation/media/uapi/v4l/dev-rds.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _rds:
 
 *************
diff --git a/Documentation/media/uapi/v4l/dev-sdr.rst b/Documentation/media/uapi/v4l/dev-sdr.rst
index b3e828d8cb1f..b33c10c0dc1f 100644
--- a/Documentation/media/uapi/v4l/dev-sdr.rst
+++ b/Documentation/media/uapi/v4l/dev-sdr.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _sdr:
 
 **************************************
diff --git a/Documentation/media/uapi/v4l/dev-sliced-vbi.rst b/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
index d311a6866b3b..03d5b2bf40b4 100644
--- a/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
+++ b/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _sliced:
 
 *************************
diff --git a/Documentation/media/uapi/v4l/dev-subdev.rst b/Documentation/media/uapi/v4l/dev-subdev.rst
index d20d945803a7..807579700342 100644
--- a/Documentation/media/uapi/v4l/dev-subdev.rst
+++ b/Documentation/media/uapi/v4l/dev-subdev.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _subdev:
 
 ********************
diff --git a/Documentation/media/uapi/v4l/dev-teletext.rst b/Documentation/media/uapi/v4l/dev-teletext.rst
index 436c7393759a..8f977937d7c3 100644
--- a/Documentation/media/uapi/v4l/dev-teletext.rst
+++ b/Documentation/media/uapi/v4l/dev-teletext.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _ttx:
 
 ******************
diff --git a/Documentation/media/uapi/v4l/dev-touch.rst b/Documentation/media/uapi/v4l/dev-touch.rst
index 98797f255ce0..7b9ad7bbc804 100644
--- a/Documentation/media/uapi/v4l/dev-touch.rst
+++ b/Documentation/media/uapi/v4l/dev-touch.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _touch:
 
 *************
diff --git a/Documentation/media/uapi/v4l/devices.rst b/Documentation/media/uapi/v4l/devices.rst
index fb7f8c26cf09..b5eff6cc2039 100644
--- a/Documentation/media/uapi/v4l/devices.rst
+++ b/Documentation/media/uapi/v4l/devices.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _devices:
 
 **********
diff --git a/Documentation/media/uapi/v4l/diff-v4l.rst b/Documentation/media/uapi/v4l/diff-v4l.rst
index 8209eeb63dd2..7dca46442a0e 100644
--- a/Documentation/media/uapi/v4l/diff-v4l.rst
+++ b/Documentation/media/uapi/v4l/diff-v4l.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _diff-v4l:
 
 ********************************
diff --git a/Documentation/media/uapi/v4l/dmabuf.rst b/Documentation/media/uapi/v4l/dmabuf.rst
index 4e980a7e9c9c..b55683f64571 100644
--- a/Documentation/media/uapi/v4l/dmabuf.rst
+++ b/Documentation/media/uapi/v4l/dmabuf.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _dmabuf:
 
 ************************************
diff --git a/Documentation/media/uapi/v4l/dv-timings.rst b/Documentation/media/uapi/v4l/dv-timings.rst
index 415a0c4e2ccb..c626a9dceb8d 100644
--- a/Documentation/media/uapi/v4l/dv-timings.rst
+++ b/Documentation/media/uapi/v4l/dv-timings.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _dv-timings:
 
 **************************
diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 65a1d873196b..80107718a7c7 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _extended-controls:
 
 *****************
diff --git a/Documentation/media/uapi/v4l/field-order.rst b/Documentation/media/uapi/v4l/field-order.rst
index 5f3f82cbfa34..badbcfab0757 100644
--- a/Documentation/media/uapi/v4l/field-order.rst
+++ b/Documentation/media/uapi/v4l/field-order.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _field-order:
 
 ***********
diff --git a/Documentation/media/uapi/v4l/format.rst b/Documentation/media/uapi/v4l/format.rst
index dc8ccd8bf982..4c47c766a820 100644
--- a/Documentation/media/uapi/v4l/format.rst
+++ b/Documentation/media/uapi/v4l/format.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _format:
 
 ************
diff --git a/Documentation/media/uapi/v4l/func-close.rst b/Documentation/media/uapi/v4l/func-close.rst
index e85a6744eb91..70342fa92962 100644
--- a/Documentation/media/uapi/v4l/func-close.rst
+++ b/Documentation/media/uapi/v4l/func-close.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _func-close:
 
 ************
diff --git a/Documentation/media/uapi/v4l/func-ioctl.rst b/Documentation/media/uapi/v4l/func-ioctl.rst
index ebfbe92f0478..bff78d9ec23a 100644
--- a/Documentation/media/uapi/v4l/func-ioctl.rst
+++ b/Documentation/media/uapi/v4l/func-ioctl.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _func-ioctl:
 
 ************
diff --git a/Documentation/media/uapi/v4l/func-mmap.rst b/Documentation/media/uapi/v4l/func-mmap.rst
index 6d2ce539bd72..5b37c82ace2e 100644
--- a/Documentation/media/uapi/v4l/func-mmap.rst
+++ b/Documentation/media/uapi/v4l/func-mmap.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _func-mmap:
 
 ***********
diff --git a/Documentation/media/uapi/v4l/func-munmap.rst b/Documentation/media/uapi/v4l/func-munmap.rst
index c2f4043d7d2b..fc8b12fd8274 100644
--- a/Documentation/media/uapi/v4l/func-munmap.rst
+++ b/Documentation/media/uapi/v4l/func-munmap.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _func-munmap:
 
 *************
diff --git a/Documentation/media/uapi/v4l/func-open.rst b/Documentation/media/uapi/v4l/func-open.rst
index deea34cc778b..98fd6211e508 100644
--- a/Documentation/media/uapi/v4l/func-open.rst
+++ b/Documentation/media/uapi/v4l/func-open.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _func-open:
 
 ***********
diff --git a/Documentation/media/uapi/v4l/func-poll.rst b/Documentation/media/uapi/v4l/func-poll.rst
index 967fe8920729..e874118c3fae 100644
--- a/Documentation/media/uapi/v4l/func-poll.rst
+++ b/Documentation/media/uapi/v4l/func-poll.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _func-poll:
 
 ***********
diff --git a/Documentation/media/uapi/v4l/func-read.rst b/Documentation/media/uapi/v4l/func-read.rst
index ae38c2d59d49..65b40d9678aa 100644
--- a/Documentation/media/uapi/v4l/func-read.rst
+++ b/Documentation/media/uapi/v4l/func-read.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _func-read:
 
 ***********
diff --git a/Documentation/media/uapi/v4l/func-select.rst b/Documentation/media/uapi/v4l/func-select.rst
index 002dedba2666..fe918ad7c83f 100644
--- a/Documentation/media/uapi/v4l/func-select.rst
+++ b/Documentation/media/uapi/v4l/func-select.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _func-select:
 
 *************
diff --git a/Documentation/media/uapi/v4l/func-write.rst b/Documentation/media/uapi/v4l/func-write.rst
index 938f33f85455..8dac16d5a772 100644
--- a/Documentation/media/uapi/v4l/func-write.rst
+++ b/Documentation/media/uapi/v4l/func-write.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _func-write:
 
 ************
diff --git a/Documentation/media/uapi/v4l/hist-v4l2.rst b/Documentation/media/uapi/v4l/hist-v4l2.rst
index 058b5db95c32..eb06d6ad4231 100644
--- a/Documentation/media/uapi/v4l/hist-v4l2.rst
+++ b/Documentation/media/uapi/v4l/hist-v4l2.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _hist-v4l2:
 
 ***********************
diff --git a/Documentation/media/uapi/v4l/hsv-formats.rst b/Documentation/media/uapi/v4l/hsv-formats.rst
index f0f2615eaa95..09fc059fcc48 100644
--- a/Documentation/media/uapi/v4l/hsv-formats.rst
+++ b/Documentation/media/uapi/v4l/hsv-formats.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _hsv-formats:
 
 ***********
diff --git a/Documentation/media/uapi/v4l/io.rst b/Documentation/media/uapi/v4l/io.rst
index 94b38a10ee65..23c9bb169133 100644
--- a/Documentation/media/uapi/v4l/io.rst
+++ b/Documentation/media/uapi/v4l/io.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _io:
 
 ############
diff --git a/Documentation/media/uapi/v4l/libv4l-introduction.rst b/Documentation/media/uapi/v4l/libv4l-introduction.rst
index ccc3c4d2fc0f..06b3a616a6d4 100644
--- a/Documentation/media/uapi/v4l/libv4l-introduction.rst
+++ b/Documentation/media/uapi/v4l/libv4l-introduction.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _libv4l-introduction:
 
 ************
diff --git a/Documentation/media/uapi/v4l/libv4l.rst b/Documentation/media/uapi/v4l/libv4l.rst
index 332c1d42688b..6871749fed3a 100644
--- a/Documentation/media/uapi/v4l/libv4l.rst
+++ b/Documentation/media/uapi/v4l/libv4l.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _libv4l:
 
 ************************
diff --git a/Documentation/media/uapi/v4l/meta-formats.rst b/Documentation/media/uapi/v4l/meta-formats.rst
index cf971d5ad9ea..e20d5c36fc07 100644
--- a/Documentation/media/uapi/v4l/meta-formats.rst
+++ b/Documentation/media/uapi/v4l/meta-formats.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _meta-formats:
 
 ****************
diff --git a/Documentation/media/uapi/v4l/mmap.rst b/Documentation/media/uapi/v4l/mmap.rst
index 0f0968799e69..298805b7b045 100644
--- a/Documentation/media/uapi/v4l/mmap.rst
+++ b/Documentation/media/uapi/v4l/mmap.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _mmap:
 
 ******************************
diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
index 251a788d80f1..fe3b202e0171 100644
--- a/Documentation/media/uapi/v4l/open.rst
+++ b/Documentation/media/uapi/v4l/open.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _open:
 
 ***************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-compressed.rst b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
index ba0f6c49d9bf..afc6a7f13297 100644
--- a/Documentation/media/uapi/v4l/pixfmt-compressed.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 ******************
 Compressed Formats
 ******************
diff --git a/Documentation/media/uapi/v4l/pixfmt-grey.rst b/Documentation/media/uapi/v4l/pixfmt-grey.rst
index dad813819d3e..982afdfdbaab 100644
--- a/Documentation/media/uapi/v4l/pixfmt-grey.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-grey.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-GREY:
 
 **************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-indexed.rst b/Documentation/media/uapi/v4l/pixfmt-indexed.rst
index 6edac54dad74..90c6af10839e 100644
--- a/Documentation/media/uapi/v4l/pixfmt-indexed.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-indexed.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _pixfmt-indexed:
 
 **************
diff --git a/Documentation/media/uapi/v4l/pixfmt-intro.rst b/Documentation/media/uapi/v4l/pixfmt-intro.rst
index 4bc116aa8193..acb191b90386 100644
--- a/Documentation/media/uapi/v4l/pixfmt-intro.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-intro.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 **********************
 Standard Image Formats
 **********************
diff --git a/Documentation/media/uapi/v4l/pixfmt-inzi.rst b/Documentation/media/uapi/v4l/pixfmt-inzi.rst
index 75272f80bc8a..eb838a44a2a2 100644
--- a/Documentation/media/uapi/v4l/pixfmt-inzi.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-inzi.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-INZI:
 
 **************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-m420.rst b/Documentation/media/uapi/v4l/pixfmt-m420.rst
index 6703f4079c3e..37c2fd1d5de6 100644
--- a/Documentation/media/uapi/v4l/pixfmt-m420.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-m420.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-M420:
 
 **************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst b/Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst
index b5165dc090c2..44e84f1e9b7d 100644
--- a/Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _v4l2-meta-fmt-uvc:
 
 *******************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst b/Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst
index 67796594fd48..fe8eb9554db2 100644
--- a/Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _v4l2-meta-fmt-vsp1-hgo:
 
 *******************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgt.rst b/Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgt.rst
index fb9f79466319..8da08b0e9d90 100644
--- a/Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgt.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgt.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _v4l2-meta-fmt-vsp1-hgt:
 
 *******************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv12.rst b/Documentation/media/uapi/v4l/pixfmt-nv12.rst
index 2776b41377d5..18002313a1d1 100644
--- a/Documentation/media/uapi/v4l/pixfmt-nv12.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-nv12.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-NV12:
 .. _V4L2-PIX-FMT-NV21:
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv12m.rst b/Documentation/media/uapi/v4l/pixfmt-nv12m.rst
index c1a2779f604c..74dccce46c5e 100644
--- a/Documentation/media/uapi/v4l/pixfmt-nv12m.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-nv12m.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-NV12M:
 .. _v4l2-pix-fmt-nv12mt-16x16:
 .. _V4L2-PIX-FMT-NV21M:
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv12mt.rst b/Documentation/media/uapi/v4l/pixfmt-nv12mt.rst
index 172a3825604e..4dc4d898ed5b 100644
--- a/Documentation/media/uapi/v4l/pixfmt-nv12mt.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-nv12mt.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-NV12MT:
 
 ****************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv16.rst b/Documentation/media/uapi/v4l/pixfmt-nv16.rst
index f0fdad3006cf..4ad5627795dc 100644
--- a/Documentation/media/uapi/v4l/pixfmt-nv16.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-nv16.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-NV16:
 .. _V4L2-PIX-FMT-NV61:
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv16m.rst b/Documentation/media/uapi/v4l/pixfmt-nv16m.rst
index c45f036763e7..676db0e785ca 100644
--- a/Documentation/media/uapi/v4l/pixfmt-nv16m.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-nv16m.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-NV16M:
 .. _v4l2-pix-fmt-nv61m:
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv24.rst b/Documentation/media/uapi/v4l/pixfmt-nv24.rst
index bda973e86227..05ee406dd34a 100644
--- a/Documentation/media/uapi/v4l/pixfmt-nv24.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-nv24.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-NV24:
 .. _V4L2-PIX-FMT-NV42:
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst b/Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst
index 8edf65c80660..cb74db18a383 100644
--- a/Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _packed-hsv:
 
 ******************
diff --git a/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst b/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
index 4938d9655a41..0c2a6f6c37e5 100644
--- a/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _packed-rgb:
 
 ******************
diff --git a/Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst b/Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst
index d7644b411ccc..0afeb2fb31a6 100644
--- a/Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _packed-yuv:
 
 ******************
diff --git a/Documentation/media/uapi/v4l/pixfmt-reserved.rst b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
index 0c399858bda2..cba9f59cf1d7 100644
--- a/Documentation/media/uapi/v4l/pixfmt-reserved.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _pixfmt-reserved:
 
 ***************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-rgb.rst b/Documentation/media/uapi/v4l/pixfmt-rgb.rst
index 1f9a7e3a07c9..8897f595e37b 100644
--- a/Documentation/media/uapi/v4l/pixfmt-rgb.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-rgb.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _pixfmt-rgb:
 
 ***********
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-cs08.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-cs08.rst
index 179894f6f8fb..3b8cd4b06740 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sdr-cs08.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sdr-cs08.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _v4l2-sdr-fmt-cs8:
 
 *************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-cs14le.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-cs14le.rst
index 5cf7d387447c..d86c2a288b75 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sdr-cs14le.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sdr-cs14le.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-SDR-FMT-CS14LE:
 
 ****************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-cu08.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-cu08.rst
index fd915b7629b7..ff22047be811 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sdr-cu08.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sdr-cu08.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _v4l2-sdr-fmt-cu8:
 
 *************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-cu16le.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-cu16le.rst
index 8922f5b35457..12105c551a3a 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sdr-cu16le.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sdr-cu16le.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-SDR-FMT-CU16LE:
 
 ****************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-pcu16be.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-pcu16be.rst
index 2de1b1a0f517..c66ea0a090ec 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sdr-pcu16be.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sdr-pcu16be.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-SDR-FMT-PCU16BE:
 
 ******************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-pcu18be.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-pcu18be.rst
index da8b26bf6b95..eb5da64752e4 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sdr-pcu18be.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sdr-pcu18be.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-SDR-FMT-PCU18BE:
 
 ******************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-pcu20be.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-pcu20be.rst
index 5499eed39477..f8a58675eeb2 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sdr-pcu20be.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sdr-pcu20be.rst
@@ -1,4 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
 .. _V4L2-SDR-FMT-PCU20BE:
 
 ******************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-ru12le.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-ru12le.rst
index 5e383382802f..ead3d36bd7a0 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sdr-ru12le.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sdr-ru12le.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-SDR-FMT-RU12LE:
 
 ****************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
index 99cde5077519..d29d340bdb7f 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _v4l2-pix-fmt-ipu3-sbggr10:
 .. _v4l2-pix-fmt-ipu3-sgbrg10:
 .. _v4l2-pix-fmt-ipu3-sgrbg10:
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10.rst
index af2538ce34e5..2926da860dc5 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb10.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb10.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-SRGGB10:
 .. _v4l2-pix-fmt-sbggr10:
 .. _v4l2-pix-fmt-sgbrg10:
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10alaw8.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10alaw8.rst
index c44e093514de..e8e6321d0fee 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb10alaw8.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb10alaw8.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-SBGGR10ALAW8:
 .. _v4l2-pix-fmt-sgbrg10alaw8:
 .. _v4l2-pix-fmt-sgrbg10alaw8:
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10dpcm8.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10dpcm8.rst
index 5e041d02eff0..c557bf640561 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb10dpcm8.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb10dpcm8.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-SBGGR10DPCM8:
 .. _v4l2-pix-fmt-sgbrg10dpcm8:
 .. _v4l2-pix-fmt-sgrbg10dpcm8:
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
index d9e07a4b8b31..da6404e33e91 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-SRGGB10P:
 .. _v4l2-pix-fmt-sbggr10p:
 .. _v4l2-pix-fmt-sgbrg10p:
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb12.rst b/Documentation/media/uapi/v4l/pixfmt-srggb12.rst
index 15041e568a0a..dd7ef3112ff9 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb12.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb12.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-SRGGB12:
 .. _v4l2-pix-fmt-sbggr12:
 .. _v4l2-pix-fmt-sgbrg12:
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb12p.rst b/Documentation/media/uapi/v4l/pixfmt-srggb12p.rst
index 59918a7913fe..51fef798d8f9 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb12p.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb12p.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-SRGGB12P:
 .. _v4l2-pix-fmt-sbggr12p:
 .. _v4l2-pix-fmt-sgbrg12p:
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb14p.rst b/Documentation/media/uapi/v4l/pixfmt-srggb14p.rst
index 88d20c0e4282..344e6bc85d90 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb14p.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb14p.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-SRGGB14P:
 .. _v4l2-pix-fmt-sbggr14p:
 .. _v4l2-pix-fmt-sgbrg14p:
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb16.rst b/Documentation/media/uapi/v4l/pixfmt-srggb16.rst
index d407b2b2050f..dc8a8d269094 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb16.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb16.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-SRGGB16:
 .. _v4l2-pix-fmt-sbggr16:
 .. _v4l2-pix-fmt-sgbrg16:
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb8.rst b/Documentation/media/uapi/v4l/pixfmt-srggb8.rst
index 5ac25a634d30..fcd2bf38f0c7 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb8.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb8.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-SRGGB8:
 .. _v4l2-pix-fmt-sbggr8:
 .. _v4l2-pix-fmt-sgbrg8:
diff --git a/Documentation/media/uapi/v4l/pixfmt-tch-td08.rst b/Documentation/media/uapi/v4l/pixfmt-tch-td08.rst
index 07834cd1249e..f00ccb6bb920 100644
--- a/Documentation/media/uapi/v4l/pixfmt-tch-td08.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-tch-td08.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-TCH-FMT-DELTA-TD08:
 
 ********************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-tch-td16.rst b/Documentation/media/uapi/v4l/pixfmt-tch-td16.rst
index 29ebcf40a989..449b7cb0c597 100644
--- a/Documentation/media/uapi/v4l/pixfmt-tch-td16.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-tch-td16.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-TCH-FMT-DELTA-TD16:
 
 ********************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-tch-tu08.rst b/Documentation/media/uapi/v4l/pixfmt-tch-tu08.rst
index e7fb7ddd191b..072c3a5e98d7 100644
--- a/Documentation/media/uapi/v4l/pixfmt-tch-tu08.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-tch-tu08.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-TCH-FMT-TU08:
 
 **************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-tch-tu16.rst b/Documentation/media/uapi/v4l/pixfmt-tch-tu16.rst
index 1588fcc3f1e7..2f2e04ef569e 100644
--- a/Documentation/media/uapi/v4l/pixfmt-tch-tu16.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-tch-tu16.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-TCH-FMT-TU16:
 
 ********************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-uv8.rst b/Documentation/media/uapi/v4l/pixfmt-uv8.rst
index c449231b51bb..7408053582af 100644
--- a/Documentation/media/uapi/v4l/pixfmt-uv8.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-uv8.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-UV8:
 
 ************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-uyvy.rst b/Documentation/media/uapi/v4l/pixfmt-uyvy.rst
index ecdc2d94c209..a3f80fd52ccd 100644
--- a/Documentation/media/uapi/v4l/pixfmt-uyvy.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-uyvy.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-UYVY:
 
 **************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst b/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst
index ef52f637d8e9..e7e9181a9b6b 100644
--- a/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 ******************************
 Multi-planar format structures
 ******************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-v4l2.rst b/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
index 826f2305da01..4e3b26cdd3c2 100644
--- a/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 ******************************
 Single-planar format structure
 ******************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-vyuy.rst b/Documentation/media/uapi/v4l/pixfmt-vyuy.rst
index 670c339c1714..f2914e105cf9 100644
--- a/Documentation/media/uapi/v4l/pixfmt-vyuy.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-vyuy.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-VYUY:
 
 **************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-y10.rst b/Documentation/media/uapi/v4l/pixfmt-y10.rst
index 89e22899cd81..ba3fb597d402 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y10.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y10.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-Y10:
 
 *************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-y10b.rst b/Documentation/media/uapi/v4l/pixfmt-y10b.rst
index 9feddf3ae07b..e7a688c42770 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y10b.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y10b.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-Y10BPACK:
 
 ******************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-y10p.rst b/Documentation/media/uapi/v4l/pixfmt-y10p.rst
index 13b571306915..90a7d33b1eb1 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y10p.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y10p.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-Y10P:
 
 ******************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-y12.rst b/Documentation/media/uapi/v4l/pixfmt-y12.rst
index 0f230713290b..f5ce710666f5 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y12.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y12.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-Y12:
 
 *************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-y12i.rst b/Documentation/media/uapi/v4l/pixfmt-y12i.rst
index bb39a2463564..cdde4cda1508 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y12i.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y12i.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-Y12I:
 
 **************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-y16-be.rst b/Documentation/media/uapi/v4l/pixfmt-y16-be.rst
index 54ce35ef84b7..5ed99caade6d 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y16-be.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y16-be.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-Y16-BE:
 
 ****************************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-y16.rst b/Documentation/media/uapi/v4l/pixfmt-y16.rst
index bcbd52de3aca..027318eb9ea6 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y16.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y16.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-Y16:
 
 *************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-y41p.rst b/Documentation/media/uapi/v4l/pixfmt-y41p.rst
index e1fe548807a4..abb84cc29bb1 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y41p.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y41p.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-Y41P:
 
 **************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-y8i.rst b/Documentation/media/uapi/v4l/pixfmt-y8i.rst
index fd8ed23dd342..4d1e82ab3884 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y8i.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y8i.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-Y8I:
 
 *************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv410.rst b/Documentation/media/uapi/v4l/pixfmt-yuv410.rst
index b51a0d1c6108..61d33dbde3ef 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuv410.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuv410.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-YVU410:
 .. _v4l2-pix-fmt-yuv410:
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv411p.rst b/Documentation/media/uapi/v4l/pixfmt-yuv411p.rst
index 2582341972db..2c4b93ea9299 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuv411p.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuv411p.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-YUV411P:
 
 *****************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv420.rst b/Documentation/media/uapi/v4l/pixfmt-yuv420.rst
index a9b85c4b1dbc..78d9addfaf04 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuv420.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuv420.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-YVU420:
 .. _V4L2-PIX-FMT-YUV420:
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv420m.rst b/Documentation/media/uapi/v4l/pixfmt-yuv420m.rst
index 32c68c33f2b1..5dca80fc2bac 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuv420m.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuv420m.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-YUV420M:
 .. _v4l2-pix-fmt-yvu420m:
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv422m.rst b/Documentation/media/uapi/v4l/pixfmt-yuv422m.rst
index 9e7028c4967c..3bf9c2b5c0ef 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuv422m.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuv422m.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-YUV422M:
 .. _v4l2-pix-fmt-yvu422m:
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv422p.rst b/Documentation/media/uapi/v4l/pixfmt-yuv422p.rst
index a96f836c7fa5..9a66a9dcbb3f 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuv422p.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuv422p.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-YUV422P:
 
 *****************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv444m.rst b/Documentation/media/uapi/v4l/pixfmt-yuv444m.rst
index 8605bfaee112..f5c4374caf71 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuv444m.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuv444m.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-YUV444M:
 .. _v4l2-pix-fmt-yvu444m:
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuyv.rst b/Documentation/media/uapi/v4l/pixfmt-yuyv.rst
index 53e876d053fb..edb2253f91ed 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuyv.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuyv.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-YUYV:
 
 **************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-yvyu.rst b/Documentation/media/uapi/v4l/pixfmt-yvyu.rst
index b9c31746e565..880800589c98 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yvyu.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yvyu.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-YVYU:
 
 **************************
diff --git a/Documentation/media/uapi/v4l/pixfmt-z16.rst b/Documentation/media/uapi/v4l/pixfmt-z16.rst
index eb713a9bccae..28152dca6fb6 100644
--- a/Documentation/media/uapi/v4l/pixfmt-z16.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-z16.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _V4L2-PIX-FMT-Z16:
 
 *************************
diff --git a/Documentation/media/uapi/v4l/pixfmt.rst b/Documentation/media/uapi/v4l/pixfmt.rst
index 2aa449e2da67..57df88e066e4 100644
--- a/Documentation/media/uapi/v4l/pixfmt.rst
+++ b/Documentation/media/uapi/v4l/pixfmt.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _pixfmt:
 
 #############
diff --git a/Documentation/media/uapi/v4l/planar-apis.rst b/Documentation/media/uapi/v4l/planar-apis.rst
index 4e059fb44153..b6b6014c3992 100644
--- a/Documentation/media/uapi/v4l/planar-apis.rst
+++ b/Documentation/media/uapi/v4l/planar-apis.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _planar-apis:
 
 *****************************
diff --git a/Documentation/media/uapi/v4l/querycap.rst b/Documentation/media/uapi/v4l/querycap.rst
index c19cce7a816f..bb29bbdfb240 100644
--- a/Documentation/media/uapi/v4l/querycap.rst
+++ b/Documentation/media/uapi/v4l/querycap.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _querycap:
 
 *********************
diff --git a/Documentation/media/uapi/v4l/rw.rst b/Documentation/media/uapi/v4l/rw.rst
index 91596c0cc2f3..644f703926d2 100644
--- a/Documentation/media/uapi/v4l/rw.rst
+++ b/Documentation/media/uapi/v4l/rw.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _rw:
 
 **********
diff --git a/Documentation/media/uapi/v4l/sdr-formats.rst b/Documentation/media/uapi/v4l/sdr-formats.rst
index 2037f5bad727..d729ba2ffba7 100644
--- a/Documentation/media/uapi/v4l/sdr-formats.rst
+++ b/Documentation/media/uapi/v4l/sdr-formats.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _sdr-formats:
 
 ***********
diff --git a/Documentation/media/uapi/v4l/selection-api-configuration.rst b/Documentation/media/uapi/v4l/selection-api-configuration.rst
index 0a4ddc2d71db..47e7266351be 100644
--- a/Documentation/media/uapi/v4l/selection-api-configuration.rst
+++ b/Documentation/media/uapi/v4l/selection-api-configuration.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 *************
 Configuration
 *************
diff --git a/Documentation/media/uapi/v4l/selection-api-examples.rst b/Documentation/media/uapi/v4l/selection-api-examples.rst
index 67e0e9aed9e8..dbc369317245 100644
--- a/Documentation/media/uapi/v4l/selection-api-examples.rst
+++ b/Documentation/media/uapi/v4l/selection-api-examples.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 ********
 Examples
 ********
diff --git a/Documentation/media/uapi/v4l/selection-api-intro.rst b/Documentation/media/uapi/v4l/selection-api-intro.rst
index 09ca93f91bf7..2b034df8d2c3 100644
--- a/Documentation/media/uapi/v4l/selection-api-intro.rst
+++ b/Documentation/media/uapi/v4l/selection-api-intro.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 ************
 Introduction
 ************
diff --git a/Documentation/media/uapi/v4l/selection-api-targets.rst b/Documentation/media/uapi/v4l/selection-api-targets.rst
index bf7e76dfbdf9..33c965dfce59 100644
--- a/Documentation/media/uapi/v4l/selection-api-targets.rst
+++ b/Documentation/media/uapi/v4l/selection-api-targets.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 *****************
 Selection targets
 *****************
diff --git a/Documentation/media/uapi/v4l/selection-api-vs-crop-api.rst b/Documentation/media/uapi/v4l/selection-api-vs-crop-api.rst
index e7455fb1e572..fe933ec3f376 100644
--- a/Documentation/media/uapi/v4l/selection-api-vs-crop-api.rst
+++ b/Documentation/media/uapi/v4l/selection-api-vs-crop-api.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _selection-vs-crop:
 
 ********************************
diff --git a/Documentation/media/uapi/v4l/selection-api.rst b/Documentation/media/uapi/v4l/selection-api.rst
index 390233f704a3..894132cfce1c 100644
--- a/Documentation/media/uapi/v4l/selection-api.rst
+++ b/Documentation/media/uapi/v4l/selection-api.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _selection-api:
 
 Cropping, composing and scaling -- the SELECTION API
diff --git a/Documentation/media/uapi/v4l/selections-common.rst b/Documentation/media/uapi/v4l/selections-common.rst
index 69dbce4e6e47..46d5d1ea44eb 100644
--- a/Documentation/media/uapi/v4l/selections-common.rst
+++ b/Documentation/media/uapi/v4l/selections-common.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _v4l2-selections-common:
 
 Common selection definitions
diff --git a/Documentation/media/uapi/v4l/standard.rst b/Documentation/media/uapi/v4l/standard.rst
index 75a14895aed7..8ef590f385ea 100644
--- a/Documentation/media/uapi/v4l/standard.rst
+++ b/Documentation/media/uapi/v4l/standard.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _standard:
 
 ***************
diff --git a/Documentation/media/uapi/v4l/streaming-par.rst b/Documentation/media/uapi/v4l/streaming-par.rst
index f9b93c53f75c..952a1493012f 100644
--- a/Documentation/media/uapi/v4l/streaming-par.rst
+++ b/Documentation/media/uapi/v4l/streaming-par.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _streaming-par:
 
 ********************
diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
index 8e73fcfc6900..442e011a3f20 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _v4l2-mbus-format:
 
 Media Bus Formats
diff --git a/Documentation/media/uapi/v4l/tch-formats.rst b/Documentation/media/uapi/v4l/tch-formats.rst
index dbaabf33a5b8..1ff8e2602e6a 100644
--- a/Documentation/media/uapi/v4l/tch-formats.rst
+++ b/Documentation/media/uapi/v4l/tch-formats.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _tch-formats:
 
 *************
diff --git a/Documentation/media/uapi/v4l/tuner.rst b/Documentation/media/uapi/v4l/tuner.rst
index 178a0aea4d3a..6b2fe6f993c4 100644
--- a/Documentation/media/uapi/v4l/tuner.rst
+++ b/Documentation/media/uapi/v4l/tuner.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _tuner:
 
 *********************
diff --git a/Documentation/media/uapi/v4l/user-func.rst b/Documentation/media/uapi/v4l/user-func.rst
index 3e0413b83a33..a90f7d76c0f1 100644
--- a/Documentation/media/uapi/v4l/user-func.rst
+++ b/Documentation/media/uapi/v4l/user-func.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _user-func:
 
 ******************
diff --git a/Documentation/media/uapi/v4l/userp.rst b/Documentation/media/uapi/v4l/userp.rst
index e25715a2c6fa..20a8c410b421 100644
--- a/Documentation/media/uapi/v4l/userp.rst
+++ b/Documentation/media/uapi/v4l/userp.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _userp:
 
 *****************************
diff --git a/Documentation/media/uapi/v4l/v4l2-selection-flags.rst b/Documentation/media/uapi/v4l/v4l2-selection-flags.rst
index 1f9a03851d0f..af30c8a276b0 100644
--- a/Documentation/media/uapi/v4l/v4l2-selection-flags.rst
+++ b/Documentation/media/uapi/v4l/v4l2-selection-flags.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _v4l2-selection-flags:
 
 ***************
diff --git a/Documentation/media/uapi/v4l/v4l2-selection-targets.rst b/Documentation/media/uapi/v4l/v4l2-selection-targets.rst
index bee31611947e..7db3f1535d68 100644
--- a/Documentation/media/uapi/v4l/v4l2-selection-targets.rst
+++ b/Documentation/media/uapi/v4l/v4l2-selection-targets.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _v4l2-selection-targets:
 
 *****************
diff --git a/Documentation/media/uapi/v4l/v4l2.rst b/Documentation/media/uapi/v4l/v4l2.rst
index b89e5621ae69..b20d56d4d141 100644
--- a/Documentation/media/uapi/v4l/v4l2.rst
+++ b/Documentation/media/uapi/v4l/v4l2.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. include:: <isonum.txt>
 .. _v4l2spec:
 
diff --git a/Documentation/media/uapi/v4l/v4l2grab-example.rst b/Documentation/media/uapi/v4l/v4l2grab-example.rst
index c240f0513bee..68d2abf66268 100644
--- a/Documentation/media/uapi/v4l/v4l2grab-example.rst
+++ b/Documentation/media/uapi/v4l/v4l2grab-example.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _v4l2grab-example:
 
 **********************************
diff --git a/Documentation/media/uapi/v4l/v4l2grab.c.rst b/Documentation/media/uapi/v4l/v4l2grab.c.rst
index f0d0ab6abd41..8c5b7e7cc71a 100644
--- a/Documentation/media/uapi/v4l/v4l2grab.c.rst
+++ b/Documentation/media/uapi/v4l/v4l2grab.c.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 file: media/v4l/v4l2grab.c
 ==========================
 
diff --git a/Documentation/media/uapi/v4l/video.rst b/Documentation/media/uapi/v4l/video.rst
index 054af871c217..c00a6a77e96a 100644
--- a/Documentation/media/uapi/v4l/video.rst
+++ b/Documentation/media/uapi/v4l/video.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _video:
 
 ************************
diff --git a/Documentation/media/uapi/v4l/videodev.rst b/Documentation/media/uapi/v4l/videodev.rst
index b9ee4672d639..3d01bf17aa19 100644
--- a/Documentation/media/uapi/v4l/videodev.rst
+++ b/Documentation/media/uapi/v4l/videodev.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _videodev:
 
 *******************************
diff --git a/Documentation/media/uapi/v4l/vidioc-create-bufs.rst b/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
index eadf6f757fbf..cb6858666b88 100644
--- a/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
+++ b/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_CREATE_BUFS:
 
 ************************
diff --git a/Documentation/media/uapi/v4l/vidioc-cropcap.rst b/Documentation/media/uapi/v4l/vidioc-cropcap.rst
index 0a7b8287fd38..a3f3fbaff350 100644
--- a/Documentation/media/uapi/v4l/vidioc-cropcap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-cropcap.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_CROPCAP:
 
 ********************
diff --git a/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst b/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
index 7709852282c2..9b6f4861de58 100644
--- a/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_DBG_G_CHIP_INFO:
 
 ****************************
diff --git a/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst b/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
index f4e8dd5f7889..e66f7fed1546 100644
--- a/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_DBG_G_REGISTER:
 
 **************************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst b/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
index 85c916b0ce07..668711ea445a 100644
--- a/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_DECODER_CMD:
 
 ************************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-dqevent.rst b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
index 04416b6943c0..80b6753dc20b 100644
--- a/Documentation/media/uapi/v4l/vidioc-dqevent.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_DQEVENT:
 
 ********************
diff --git a/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst b/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
index 63ead6b7a115..2cf99be150a3 100644
--- a/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_DV_TIMINGS_CAP:
 
 *********************************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst b/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst
index 5ae8c933b1b9..6e2c34ef469e 100644
--- a/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_ENCODER_CMD:
 
 ************************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
index 63dca65f49e4..f880b7abc4b7 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_ENUM_DV_TIMINGS:
 
 ***********************************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
index 33d4b51a7d16..5af2ce50163e 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_ENUM_FMT:
 
 *********************
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst b/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
index fea7dc3c879d..eb9dd8547c0e 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_ENUM_FRAMEINTERVALS:
 
 ********************************
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst b/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
index 6de117f163e0..65f49fea9a0d 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_ENUM_FRAMESIZES:
 
 ****************************
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst b/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
index 195cf45f3c32..40a62a0fc830 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_ENUM_FREQ_BANDS:
 
 ****************************
diff --git a/Documentation/media/uapi/v4l/vidioc-enumaudio.rst b/Documentation/media/uapi/v4l/vidioc-enumaudio.rst
index 8e5193e8696f..c8dcaf92714c 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumaudio.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumaudio.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_ENUMAUDIO:
 
 **********************
diff --git a/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst b/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst
index 6d2b4f6e78b0..172fad045596 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_ENUMAUDOUT:
 
 ***********************
diff --git a/Documentation/media/uapi/v4l/vidioc-enuminput.rst b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
index 0350069a56c5..cf2f9cb0cbc3 100644
--- a/Documentation/media/uapi/v4l/vidioc-enuminput.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_ENUMINPUT:
 
 **********************
diff --git a/Documentation/media/uapi/v4l/vidioc-enumoutput.rst b/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
index 697dcd186ae3..51bfe5b243a8 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_ENUMOUTPUT:
 
 ***********************
diff --git a/Documentation/media/uapi/v4l/vidioc-enumstd.rst b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
index 2644a62acd4b..e183eabca18e 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumstd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_ENUMSTD:
 
 *******************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-expbuf.rst b/Documentation/media/uapi/v4l/vidioc-expbuf.rst
index 226e83eb28a9..c3128f26d544 100644
--- a/Documentation/media/uapi/v4l/vidioc-expbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-expbuf.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_EXPBUF:
 
 *******************
diff --git a/Documentation/media/uapi/v4l/vidioc-g-audio.rst b/Documentation/media/uapi/v4l/vidioc-g-audio.rst
index 290851f99386..7753bf234a5f 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-audio.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-audio.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_G_AUDIO:
 
 ************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-g-audioout.rst b/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
index 1c98af33ee70..8e23daddd1bb 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_G_AUDOUT:
 
 **************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-g-crop.rst b/Documentation/media/uapi/v4l/vidioc-g-crop.rst
index b95ba6743cbd..e83365c7440c 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-crop.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-crop.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_G_CROP:
 
 **********************************
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst b/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst
index 299b9aabbac2..a0065c682328 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_G_CTRL:
 
 **********************************
diff --git a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
index 35cba2c8d459..a938cb50f346 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_G_DV_TIMINGS:
 
 **********************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-g-edid.rst b/Documentation/media/uapi/v4l/vidioc-g-edid.rst
index acab90f06e5a..212d8ffd8d2e 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-edid.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-edid.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_G_EDID:
 
 ******************************************************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst b/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
index 9dfe64fc21a4..7c0252cc53e7 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_G_ENC_INDEX:
 
 ************************
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
index d9930fe776cf..454e669d19a4 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_G_EXT_CTRLS:
 
 ******************************************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst b/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
index fc73bf0f6052..2860c0062e85 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_G_FBUF:
 
 **********************************
diff --git a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
index 9ea494a8faca..bc0b95ae1a85 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_G_FMT:
 
 ************************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-g-frequency.rst b/Documentation/media/uapi/v4l/vidioc-g-frequency.rst
index c1cccb144660..59b04b64317d 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-frequency.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-frequency.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_G_FREQUENCY:
 
 ********************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-g-input.rst b/Documentation/media/uapi/v4l/vidioc-g-input.rst
index 1dcef44eef02..178ecfede48d 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-input.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-input.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_G_INPUT:
 
 ************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst b/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
index a1773ea9543e..274f1d638b8c 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_G_JPEGCOMP:
 
 ******************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-g-modulator.rst b/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
index a47b6a15cfbe..94331754bf4c 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_G_MODULATOR:
 
 ********************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-g-output.rst b/Documentation/media/uapi/v4l/vidioc-g-output.rst
index 3e0093f66834..f8acc0e5a9dd 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-output.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-output.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_G_OUTPUT:
 
 **************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-g-parm.rst b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
index c31585a7701b..2bf6cf589fbe 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-parm.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_G_PARM:
 
 **********************************
diff --git a/Documentation/media/uapi/v4l/vidioc-g-priority.rst b/Documentation/media/uapi/v4l/vidioc-g-priority.rst
index c28996b4a45c..73698674a7ae 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-priority.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-priority.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_G_PRIORITY:
 
 ******************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-g-selection.rst b/Documentation/media/uapi/v4l/vidioc-g-selection.rst
index f1d9df029e0d..4a73d8c91756 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-selection.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-selection.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_G_SELECTION:
 
 ********************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst b/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
index a9633cae76c5..523c65b9a6b3 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_G_SLICED_VBI_CAP:
 
 *****************************
diff --git a/Documentation/media/uapi/v4l/vidioc-g-std.rst b/Documentation/media/uapi/v4l/vidioc-g-std.rst
index 8d94f0404df2..ba344989e0a5 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-std.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-std.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_G_STD:
 
 **************************************************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
index acdd15901a51..e7be22aec60f 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_G_TUNER:
 
 ************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-log-status.rst b/Documentation/media/uapi/v4l/vidioc-log-status.rst
index bbeb7b5f516b..b3871cf58b1e 100644
--- a/Documentation/media/uapi/v4l/vidioc-log-status.rst
+++ b/Documentation/media/uapi/v4l/vidioc-log-status.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_LOG_STATUS:
 
 ***********************
diff --git a/Documentation/media/uapi/v4l/vidioc-overlay.rst b/Documentation/media/uapi/v4l/vidioc-overlay.rst
index 1383e3db25fc..673e3d32ec4a 100644
--- a/Documentation/media/uapi/v4l/vidioc-overlay.rst
+++ b/Documentation/media/uapi/v4l/vidioc-overlay.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_OVERLAY:
 
 ********************
diff --git a/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst b/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
index 49f9f4c181de..05da4a243d97 100644
--- a/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_PREPARE_BUF:
 
 ************************
diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
index 753b3b5946b1..cbe53b5c84cc 100644
--- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_QBUF:
 
 *******************************
diff --git a/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst
index 6c82eafd28bb..110d82e205b8 100644
--- a/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_QUERY_DV_TIMINGS:
 
 *****************************
diff --git a/Documentation/media/uapi/v4l/vidioc-querybuf.rst b/Documentation/media/uapi/v4l/vidioc-querybuf.rst
index dd54747fabc9..7db638d819bc 100644
--- a/Documentation/media/uapi/v4l/vidioc-querybuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querybuf.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_QUERYBUF:
 
 *********************
diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
index 66fb1b3d6e6e..6047197158f3 100644
--- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_QUERYCAP:
 
 *********************
diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
index 258f5813f281..7b29bb3b3028 100644
--- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_QUERYCTRL:
 
 *******************************************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-querystd.rst b/Documentation/media/uapi/v4l/vidioc-querystd.rst
index a8385cc74818..182c38afd440 100644
--- a/Documentation/media/uapi/v4l/vidioc-querystd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querystd.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_QUERYSTD:
 
 *********************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
index e62a15782790..068a518e4821 100644
--- a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
+++ b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_REQBUFS:
 
 ********************
diff --git a/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst b/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
index b318cb8e1df3..1062f0412a5d 100644
--- a/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
+++ b/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_S_HW_FREQ_SEEK:
 
 ***************************
diff --git a/Documentation/media/uapi/v4l/vidioc-streamon.rst b/Documentation/media/uapi/v4l/vidioc-streamon.rst
index e851a6961b78..09c89d48dd98 100644
--- a/Documentation/media/uapi/v4l/vidioc-streamon.rst
+++ b/Documentation/media/uapi/v4l/vidioc-streamon.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_STREAMON:
 
 ***************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
index 1bfe3865dcc2..bde5b6930f2e 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL:
 
 ***************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
index 33fdc3ac9316..0cd8657d7380 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_SUBDEV_ENUM_FRAME_SIZE:
 
 ***********************************
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst
index 4e4291798e4b..7a60d965b0a4 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_SUBDEV_ENUM_MBUS_CODE:
 
 **********************************
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
index 69b2ae8e7c15..e2aa7d03b222 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_SUBDEV_G_CROP:
 
 ************************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
index 81c5d331af9a..3dac78e39c39 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_SUBDEV_G_FMT:
 
 **********************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
index f889c20f231c..fa2892a4eccb 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_SUBDEV_G_FRAME_INTERVAL:
 
 ********************************************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
index b1d3dbbef42a..d13b86df08c5 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_SUBDEV_G_SELECTION:
 
 **********************************************************
diff --git a/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst b/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
index b521efa53ceb..394f026ea84e 100644
--- a/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _VIDIOC_SUBSCRIBE_EVENT:
 .. _VIDIOC_UNSUBSCRIBE_EVENT:
 
diff --git a/Documentation/media/uapi/v4l/yuv-formats.rst b/Documentation/media/uapi/v4l/yuv-formats.rst
index 9ab0592d08da..6534c4f42d73 100644
--- a/Documentation/media/uapi/v4l/yuv-formats.rst
+++ b/Documentation/media/uapi/v4l/yuv-formats.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. _yuv-formats:
 
 ***********
diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index 679238e786a7..a816cab8f2cb 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -1,5 +1,3 @@
-.. -*- coding: utf-8; mode: rst -*-
-
 .. include:: <isonum.txt>
 
 .. _v4l-drivers:
diff --git a/Documentation/media/v4l-drivers/ivtv.rst b/Documentation/media/v4l-drivers/ivtv.rst
index 3ba464c4f9bf..24fb3c5f0b66 100644
--- a/Documentation/media/v4l-drivers/ivtv.rst
+++ b/Documentation/media/v4l-drivers/ivtv.rst
@@ -1,4 +1,3 @@
-
 The ivtv driver
 ===============
 
-- 
2.19.1
