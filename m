Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58612 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437223AbeKXFYQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Nov 2018 00:24:16 -0500
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Jian Xu Zheng <jian.xu.zheng@intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        linux-usb@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Yong Zhi <yong.zhi@intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Tian Shu Qiu <tian.shu.qiu@intel.com>,
        Antoine Jacquet <royale@zerezo.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mike Isely <isely@pobox.com>,
        Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH 0/6] Add license tags/texts to all media documentation files
Date: Fri, 23 Nov 2018 16:38:33 -0200
Message-Id: <cover.1542997584.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now, almost every file under Documentation/media don't contain any
licensing text. That's bad, specially uAPI documents  are licensed under GFDL[1].

[1] This is due to historical reasons: by the time they were written, it was
believed that the best license for documents would be GFDL.

Also, as Ben pointed, for a document under GFDL to be considered as free,
it requires to explicitly say that it doesn't contain invariant sections, in order
to be compliant with GFDL 1.1 explanation notes.

This series makes clear that no media document under GFDL contain 
invariant sections and add a proper license to each file. This was never
the intent, and we never had any patch proposing to make anything
invariant. So, the changes made by Ben is just to make it explicit.

>From my side, I'm OK with licensing all documentation material I have 
at the Kernel tree with dual-licenses: GPL or GFDL. So, I'm taking one
step further and doing such change on the *.svg files that I created myself
(instead of just converting from other formats).

Hopefully, other media authors will take it as an incentive to also dual-license
their work with under either GPL or GFDL.

>From now on, all new uAPI documents should be dual-licensed GPL/GFDL.
All other documents should be at least GPL.

Ben Hutchings (1):
  Documentation/media: uapi: Explicitly say there are no Invariant
    Sections

Mauro Carvalho Chehab (5):
  media: remove text encoding from rst files
  media: add SPDX header to media uAPI files
  media: svg files: dual-licence some files with GPL and GFDL
  media: docs: brainless mass add SPDX headers to all media files
  media: pixfmt-meta-d4xx.rst: Add a license to it

 Documentation/media/.gitignore                |  2 ++
 Documentation/media/Makefile                  |  2 ++
 Documentation/media/audio.h.rst.exceptions    |  2 ++
 Documentation/media/ca.h.rst.exceptions       |  2 ++
 Documentation/media/cec-drivers/index.rst     |  2 +-
 .../media/cec-drivers/pulse8-cec.rst          |  2 ++
 Documentation/media/cec.h.rst.exceptions      |  2 ++
 Documentation/media/conf.py                   |  2 ++
 Documentation/media/conf_nitpick.py           |  2 ++
 Documentation/media/dmx.h.rst.exceptions      |  2 ++
 Documentation/media/dvb-drivers/avermedia.rst |  2 ++
 Documentation/media/dvb-drivers/bt8xx.rst     |  2 ++
 Documentation/media/dvb-drivers/cards.rst     |  2 ++
 Documentation/media/dvb-drivers/ci.rst        |  2 ++
 .../media/dvb-drivers/contributors.rst        |  2 ++
 Documentation/media/dvb-drivers/dvb-usb.rst   |  2 ++
 Documentation/media/dvb-drivers/faq.rst       |  2 ++
 Documentation/media/dvb-drivers/frontends.rst |  2 ++
 Documentation/media/dvb-drivers/index.rst     |  2 +-
 Documentation/media/dvb-drivers/intro.rst     |  2 ++
 Documentation/media/dvb-drivers/lmedm04.rst   |  2 ++
 .../media/dvb-drivers/opera-firmware.rst      |  2 ++
 Documentation/media/dvb-drivers/technisat.rst |  2 ++
 Documentation/media/dvb-drivers/ttusb-dec.rst |  2 ++
 Documentation/media/dvb-drivers/udev.rst      |  2 ++
 Documentation/media/frontend.h.rst.exceptions |  2 ++
 Documentation/media/index.rst                 |  2 ++
 Documentation/media/intro.rst                 |  2 +-
 Documentation/media/kapi/cec-core.rst         |  2 ++
 Documentation/media/kapi/csi2.rst             |  2 ++
 Documentation/media/kapi/dtv-ca.rst           |  2 ++
 Documentation/media/kapi/dtv-common.rst       |  2 ++
 Documentation/media/kapi/dtv-core.rst         |  2 ++
 Documentation/media/kapi/dtv-demux.rst        |  2 ++
 Documentation/media/kapi/dtv-frontend.rst     |  2 ++
 Documentation/media/kapi/dtv-net.rst          |  2 ++
 Documentation/media/kapi/mc-core.rst          |  2 ++
 Documentation/media/kapi/rc-core.rst          |  2 ++
 Documentation/media/kapi/v4l2-async.rst       |  2 ++
 Documentation/media/kapi/v4l2-clocks.rst      |  2 ++
 Documentation/media/kapi/v4l2-common.rst      |  2 ++
 Documentation/media/kapi/v4l2-controls.rst    |  2 ++
 Documentation/media/kapi/v4l2-core.rst        |  2 ++
 Documentation/media/kapi/v4l2-dev.rst         |  2 ++
 Documentation/media/kapi/v4l2-device.rst      |  2 ++
 Documentation/media/kapi/v4l2-dv-timings.rst  |  2 ++
 Documentation/media/kapi/v4l2-event.rst       |  1 +
 Documentation/media/kapi/v4l2-fh.rst          |  2 ++
 .../media/kapi/v4l2-flash-led-class.rst       |  2 ++
 Documentation/media/kapi/v4l2-fwnode.rst      |  2 ++
 Documentation/media/kapi/v4l2-intro.rst       |  2 ++
 Documentation/media/kapi/v4l2-mc.rst          |  2 ++
 Documentation/media/kapi/v4l2-mediabus.rst    |  2 ++
 Documentation/media/kapi/v4l2-mem2mem.rst     |  2 ++
 Documentation/media/kapi/v4l2-rect.rst        |  2 ++
 Documentation/media/kapi/v4l2-subdev.rst      |  2 ++
 Documentation/media/kapi/v4l2-tuner.rst       |  2 ++
 Documentation/media/kapi/v4l2-tveeprom.rst    |  2 ++
 Documentation/media/kapi/v4l2-videobuf.rst    |  2 ++
 Documentation/media/kapi/v4l2-videobuf2.rst   |  2 ++
 Documentation/media/lirc.h.rst.exceptions     |  2 ++
 Documentation/media/media.h.rst.exceptions    |  2 ++
 Documentation/media/media_kapi.rst            |  2 +-
 Documentation/media/media_uapi.rst            |  8 +++---
 Documentation/media/net.h.rst.exceptions      |  2 ++
 Documentation/media/typical_media_device.svg  | 10 +++++++
 Documentation/media/uapi/cec/cec-api.rst      |  9 ++++++-
 .../media/uapi/cec/cec-func-close.rst         |  9 ++++++-
 .../media/uapi/cec/cec-func-ioctl.rst         |  9 ++++++-
 .../media/uapi/cec/cec-func-open.rst          |  9 ++++++-
 .../media/uapi/cec/cec-func-poll.rst          |  9 ++++++-
 Documentation/media/uapi/cec/cec-funcs.rst    |  9 +++++++
 Documentation/media/uapi/cec/cec-header.rst   |  9 ++++++-
 Documentation/media/uapi/cec/cec-intro.rst    |  9 +++++++
 .../media/uapi/cec/cec-ioc-adap-g-caps.rst    |  9 ++++++-
 .../uapi/cec/cec-ioc-adap-g-log-addrs.rst     |  9 ++++++-
 .../uapi/cec/cec-ioc-adap-g-phys-addr.rst     |  9 ++++++-
 .../media/uapi/cec/cec-ioc-dqevent.rst        |  9 ++++++-
 .../media/uapi/cec/cec-ioc-g-mode.rst         |  9 ++++++-
 .../media/uapi/cec/cec-ioc-receive.rst        |  9 ++++++-
 .../media/uapi/cec/cec-pin-error-inj.rst      |  9 +++++++
 .../dvb/audio-bilingual-channel-select.rst    |  9 ++++++-
 .../media/uapi/dvb/audio-channel-select.rst   |  9 ++++++-
 .../media/uapi/dvb/audio-clear-buffer.rst     |  9 ++++++-
 .../media/uapi/dvb/audio-continue.rst         |  9 ++++++-
 Documentation/media/uapi/dvb/audio-fclose.rst |  9 ++++++-
 Documentation/media/uapi/dvb/audio-fopen.rst  |  9 ++++++-
 Documentation/media/uapi/dvb/audio-fwrite.rst |  9 ++++++-
 .../media/uapi/dvb/audio-get-capabilities.rst |  9 ++++++-
 .../media/uapi/dvb/audio-get-status.rst       |  9 ++++++-
 Documentation/media/uapi/dvb/audio-pause.rst  |  9 ++++++-
 Documentation/media/uapi/dvb/audio-play.rst   |  9 ++++++-
 .../media/uapi/dvb/audio-select-source.rst    |  9 ++++++-
 .../media/uapi/dvb/audio-set-av-sync.rst      |  9 ++++++-
 .../media/uapi/dvb/audio-set-bypass-mode.rst  |  9 ++++++-
 Documentation/media/uapi/dvb/audio-set-id.rst |  9 ++++++-
 .../media/uapi/dvb/audio-set-mixer.rst        |  9 ++++++-
 .../media/uapi/dvb/audio-set-mute.rst         |  9 ++++++-
 .../media/uapi/dvb/audio-set-streamtype.rst   |  9 ++++++-
 Documentation/media/uapi/dvb/audio-stop.rst   |  9 ++++++-
 Documentation/media/uapi/dvb/audio.rst        |  9 ++++++-
 .../media/uapi/dvb/audio_data_types.rst       |  9 ++++++-
 .../media/uapi/dvb/audio_function_calls.rst   |  9 ++++++-
 Documentation/media/uapi/dvb/ca-fclose.rst    |  9 ++++++-
 Documentation/media/uapi/dvb/ca-fopen.rst     |  9 ++++++-
 Documentation/media/uapi/dvb/ca-get-cap.rst   |  9 ++++++-
 .../media/uapi/dvb/ca-get-descr-info.rst      |  9 ++++++-
 Documentation/media/uapi/dvb/ca-get-msg.rst   |  9 ++++++-
 .../media/uapi/dvb/ca-get-slot-info.rst       |  9 ++++++-
 Documentation/media/uapi/dvb/ca-reset.rst     |  9 ++++++-
 Documentation/media/uapi/dvb/ca-send-msg.rst  |  9 ++++++-
 Documentation/media/uapi/dvb/ca-set-descr.rst |  9 ++++++-
 Documentation/media/uapi/dvb/ca.rst           |  9 ++++++-
 .../media/uapi/dvb/ca_data_types.rst          |  9 ++++++-
 .../media/uapi/dvb/ca_function_calls.rst      |  9 ++++++-
 Documentation/media/uapi/dvb/demux.rst        |  9 ++++++-
 Documentation/media/uapi/dvb/dmx-add-pid.rst  |  9 ++++++-
 Documentation/media/uapi/dvb/dmx-expbuf.rst   |  9 +++++++
 Documentation/media/uapi/dvb/dmx-fclose.rst   |  9 ++++++-
 Documentation/media/uapi/dvb/dmx-fopen.rst    |  9 ++++++-
 Documentation/media/uapi/dvb/dmx-fread.rst    |  9 ++++++-
 Documentation/media/uapi/dvb/dmx-fwrite.rst   |  9 ++++++-
 .../media/uapi/dvb/dmx-get-pes-pids.rst       |  9 ++++++-
 Documentation/media/uapi/dvb/dmx-get-stc.rst  |  9 ++++++-
 Documentation/media/uapi/dvb/dmx-mmap.rst     |  9 +++++++
 Documentation/media/uapi/dvb/dmx-munmap.rst   |  9 +++++++
 Documentation/media/uapi/dvb/dmx-qbuf.rst     |  9 +++++++
 Documentation/media/uapi/dvb/dmx-querybuf.rst |  9 +++++++
 .../media/uapi/dvb/dmx-remove-pid.rst         |  9 ++++++-
 Documentation/media/uapi/dvb/dmx-reqbufs.rst  |  9 +++++++
 .../media/uapi/dvb/dmx-set-buffer-size.rst    |  9 ++++++-
 .../media/uapi/dvb/dmx-set-filter.rst         |  9 ++++++-
 .../media/uapi/dvb/dmx-set-pes-filter.rst     |  9 ++++++-
 Documentation/media/uapi/dvb/dmx-start.rst    |  9 ++++++-
 Documentation/media/uapi/dvb/dmx-stop.rst     |  9 ++++++-
 Documentation/media/uapi/dvb/dmx_fcalls.rst   |  9 ++++++-
 Documentation/media/uapi/dvb/dmx_types.rst    |  9 ++++++-
 .../media/uapi/dvb/dvb-fe-read-status.rst     |  9 ++++++-
 .../media/uapi/dvb/dvb-frontend-event.rst     |  9 ++++++-
 .../uapi/dvb/dvb-frontend-parameters.rst      |  9 ++++++-
 Documentation/media/uapi/dvb/dvbapi.rst       |  9 ++++++-
 Documentation/media/uapi/dvb/dvbproperty.rst  |  9 ++++++-
 Documentation/media/uapi/dvb/dvbstb.svg       | 27 +++++++++++++++++++
 Documentation/media/uapi/dvb/examples.rst     |  9 ++++++-
 .../media/uapi/dvb/fe-bandwidth-t.rst         |  9 ++++++-
 .../uapi/dvb/fe-diseqc-recv-slave-reply.rst   |  9 ++++++-
 .../uapi/dvb/fe-diseqc-reset-overload.rst     |  9 ++++++-
 .../media/uapi/dvb/fe-diseqc-send-burst.rst   |  9 ++++++-
 .../uapi/dvb/fe-diseqc-send-master-cmd.rst    |  9 ++++++-
 .../dvb/fe-dishnetwork-send-legacy-cmd.rst    |  9 ++++++-
 .../uapi/dvb/fe-enable-high-lnb-voltage.rst   |  9 ++++++-
 Documentation/media/uapi/dvb/fe-get-event.rst |  9 ++++++-
 .../media/uapi/dvb/fe-get-frontend.rst        |  9 ++++++-
 Documentation/media/uapi/dvb/fe-get-info.rst  |  9 ++++++-
 .../media/uapi/dvb/fe-get-property.rst        |  9 ++++++-
 Documentation/media/uapi/dvb/fe-read-ber.rst  |  9 ++++++-
 .../uapi/dvb/fe-read-signal-strength.rst      |  9 ++++++-
 Documentation/media/uapi/dvb/fe-read-snr.rst  |  9 ++++++-
 .../media/uapi/dvb/fe-read-status.rst         |  9 ++++++-
 .../uapi/dvb/fe-read-uncorrected-blocks.rst   |  9 ++++++-
 .../uapi/dvb/fe-set-frontend-tune-mode.rst    |  9 ++++++-
 .../media/uapi/dvb/fe-set-frontend.rst        |  9 ++++++-
 Documentation/media/uapi/dvb/fe-set-tone.rst  |  9 ++++++-
 .../media/uapi/dvb/fe-set-voltage.rst         |  9 ++++++-
 Documentation/media/uapi/dvb/fe-type-t.rst    |  9 ++++++-
 .../media/uapi/dvb/fe_property_parameters.rst |  9 ++++++-
 .../media/uapi/dvb/frontend-header.rst        |  9 +++++++
 .../dvb/frontend-property-cable-systems.rst   |  9 ++++++-
 .../frontend-property-satellite-systems.rst   |  9 ++++++-
 .../frontend-property-terrestrial-systems.rst |  9 ++++++-
 .../uapi/dvb/frontend-stat-properties.rst     |  9 ++++++-
 Documentation/media/uapi/dvb/frontend.rst     |  9 ++++++-
 .../media/uapi/dvb/frontend_f_close.rst       |  9 ++++++-
 .../media/uapi/dvb/frontend_f_open.rst        |  9 ++++++-
 .../media/uapi/dvb/frontend_fcalls.rst        |  9 ++++++-
 .../media/uapi/dvb/frontend_legacy_api.rst    |  9 ++++++-
 .../uapi/dvb/frontend_legacy_dvbv3_api.rst    |  9 ++++++-
 Documentation/media/uapi/dvb/headers.rst      |  9 +++++++
 Documentation/media/uapi/dvb/intro.rst        |  9 ++++++-
 .../media/uapi/dvb/legacy_dvb_apis.rst        |  9 ++++++-
 Documentation/media/uapi/dvb/net-add-if.rst   |  9 ++++++-
 Documentation/media/uapi/dvb/net-get-if.rst   |  9 ++++++-
 .../media/uapi/dvb/net-remove-if.rst          |  9 ++++++-
 Documentation/media/uapi/dvb/net-types.rst    |  9 ++++++-
 Documentation/media/uapi/dvb/net.rst          |  9 ++++++-
 .../uapi/dvb/query-dvb-frontend-info.rst      |  9 ++++++-
 .../media/uapi/dvb/video-clear-buffer.rst     |  9 ++++++-
 .../media/uapi/dvb/video-command.rst          |  9 ++++++-
 .../media/uapi/dvb/video-continue.rst         |  9 ++++++-
 .../media/uapi/dvb/video-fast-forward.rst     |  9 ++++++-
 Documentation/media/uapi/dvb/video-fclose.rst |  9 ++++++-
 Documentation/media/uapi/dvb/video-fopen.rst  |  9 ++++++-
 Documentation/media/uapi/dvb/video-freeze.rst |  9 ++++++-
 Documentation/media/uapi/dvb/video-fwrite.rst |  9 ++++++-
 .../media/uapi/dvb/video-get-capabilities.rst |  9 ++++++-
 .../media/uapi/dvb/video-get-event.rst        |  9 ++++++-
 .../media/uapi/dvb/video-get-frame-count.rst  |  9 ++++++-
 .../media/uapi/dvb/video-get-pts.rst          |  9 ++++++-
 .../media/uapi/dvb/video-get-size.rst         |  9 ++++++-
 .../media/uapi/dvb/video-get-status.rst       |  9 ++++++-
 Documentation/media/uapi/dvb/video-play.rst   |  9 ++++++-
 .../media/uapi/dvb/video-select-source.rst    |  9 ++++++-
 .../media/uapi/dvb/video-set-blank.rst        |  9 ++++++-
 .../uapi/dvb/video-set-display-format.rst     |  9 ++++++-
 .../media/uapi/dvb/video-set-format.rst       |  9 ++++++-
 .../media/uapi/dvb/video-set-streamtype.rst   |  9 ++++++-
 .../media/uapi/dvb/video-slowmotion.rst       |  9 ++++++-
 .../media/uapi/dvb/video-stillpicture.rst     |  9 ++++++-
 Documentation/media/uapi/dvb/video-stop.rst   |  9 ++++++-
 .../media/uapi/dvb/video-try-command.rst      |  9 ++++++-
 Documentation/media/uapi/dvb/video.rst        |  9 ++++++-
 .../media/uapi/dvb/video_function_calls.rst   |  9 ++++++-
 Documentation/media/uapi/dvb/video_types.rst  |  9 ++++++-
 Documentation/media/uapi/fdl-appendix.rst     |  9 ++++++-
 Documentation/media/uapi/gen-errors.rst       |  9 ++++++-
 .../uapi/mediactl/media-controller-intro.rst  |  9 ++++++-
 .../uapi/mediactl/media-controller-model.rst  |  9 ++++++-
 .../media/uapi/mediactl/media-controller.rst  |  9 ++++++-
 .../media/uapi/mediactl/media-func-close.rst  |  9 ++++++-
 .../media/uapi/mediactl/media-func-ioctl.rst  |  9 ++++++-
 .../media/uapi/mediactl/media-func-open.rst   |  9 ++++++-
 .../media/uapi/mediactl/media-funcs.rst       |  9 +++++++
 .../media/uapi/mediactl/media-header.rst      |  9 ++++++-
 .../uapi/mediactl/media-ioc-device-info.rst   |  9 ++++++-
 .../uapi/mediactl/media-ioc-enum-entities.rst |  9 ++++++-
 .../uapi/mediactl/media-ioc-enum-links.rst    |  9 ++++++-
 .../uapi/mediactl/media-ioc-g-topology.rst    |  9 ++++++-
 .../uapi/mediactl/media-ioc-setup-link.rst    |  9 ++++++-
 .../media/uapi/mediactl/media-types.rst       |  9 ++++++-
 Documentation/media/uapi/rc/keytable.c.rst    |  9 ++++++-
 .../media/uapi/rc/lirc-dev-intro.rst          |  9 ++++++-
 Documentation/media/uapi/rc/lirc-dev.rst      |  9 ++++++-
 Documentation/media/uapi/rc/lirc-func.rst     |  9 ++++++-
 .../media/uapi/rc/lirc-get-features.rst       |  9 ++++++-
 .../media/uapi/rc/lirc-get-rec-mode.rst       |  9 ++++++-
 .../media/uapi/rc/lirc-get-rec-resolution.rst |  9 ++++++-
 .../media/uapi/rc/lirc-get-send-mode.rst      |  9 ++++++-
 .../media/uapi/rc/lirc-get-timeout.rst        |  9 ++++++-
 Documentation/media/uapi/rc/lirc-header.rst   |  9 ++++++-
 Documentation/media/uapi/rc/lirc-read.rst     |  9 ++++++-
 .../uapi/rc/lirc-set-measure-carrier-mode.rst |  9 ++++++-
 .../uapi/rc/lirc-set-rec-carrier-range.rst    |  9 ++++++-
 .../media/uapi/rc/lirc-set-rec-carrier.rst    |  9 ++++++-
 .../uapi/rc/lirc-set-rec-timeout-reports.rst  |  9 ++++++-
 .../media/uapi/rc/lirc-set-rec-timeout.rst    |  9 ++++++-
 .../media/uapi/rc/lirc-set-send-carrier.rst   |  9 ++++++-
 .../uapi/rc/lirc-set-send-duty-cycle.rst      |  9 ++++++-
 .../uapi/rc/lirc-set-transmitter-mask.rst     |  9 ++++++-
 .../uapi/rc/lirc-set-wideband-receiver.rst    |  9 ++++++-
 Documentation/media/uapi/rc/lirc-write.rst    |  9 ++++++-
 Documentation/media/uapi/rc/rc-intro.rst      |  9 ++++++-
 .../media/uapi/rc/rc-sysfs-nodes.rst          |  9 ++++++-
 .../media/uapi/rc/rc-table-change.rst         |  9 ++++++-
 Documentation/media/uapi/rc/rc-tables.rst     |  9 ++++++-
 .../media/uapi/rc/remote_controllers.rst      |  9 ++++++-
 Documentation/media/uapi/v4l/app-pri.rst      |  9 ++++++-
 Documentation/media/uapi/v4l/async.rst        |  9 ++++++-
 Documentation/media/uapi/v4l/audio.rst        |  9 ++++++-
 Documentation/media/uapi/v4l/bayer.svg        | 27 +++++++++++++++++++
 Documentation/media/uapi/v4l/biblio.rst       |  9 ++++++-
 Documentation/media/uapi/v4l/buffer.rst       |  9 ++++++-
 .../media/uapi/v4l/capture-example.rst        |  9 ++++++-
 Documentation/media/uapi/v4l/capture.c.rst    |  9 ++++++-
 .../media/uapi/v4l/colorspaces-defs.rst       |  9 ++++++-
 .../media/uapi/v4l/colorspaces-details.rst    |  9 ++++++-
 Documentation/media/uapi/v4l/colorspaces.rst  |  9 ++++++-
 Documentation/media/uapi/v4l/common-defs.rst  |  9 ++++++-
 Documentation/media/uapi/v4l/common.rst       |  9 ++++++-
 Documentation/media/uapi/v4l/compat.rst       |  9 ++++++-
 Documentation/media/uapi/v4l/constraints.svg  | 27 +++++++++++++++++++
 Documentation/media/uapi/v4l/control.rst      |  9 ++++++-
 Documentation/media/uapi/v4l/crop.rst         |  9 ++++++-
 Documentation/media/uapi/v4l/crop.svg         | 10 ++++++-
 .../media/uapi/v4l/depth-formats.rst          |  9 ++++++-
 Documentation/media/uapi/v4l/dev-capture.rst  |  9 ++++++-
 Documentation/media/uapi/v4l/dev-codec.rst    |  9 ++++++-
 Documentation/media/uapi/v4l/dev-effect.rst   |  9 ++++++-
 Documentation/media/uapi/v4l/dev-event.rst    |  9 ++++++-
 Documentation/media/uapi/v4l/dev-meta.rst     |  9 ++++++-
 Documentation/media/uapi/v4l/dev-osd.rst      |  9 ++++++-
 Documentation/media/uapi/v4l/dev-output.rst   |  9 ++++++-
 Documentation/media/uapi/v4l/dev-overlay.rst  |  9 ++++++-
 Documentation/media/uapi/v4l/dev-radio.rst    |  9 ++++++-
 Documentation/media/uapi/v4l/dev-raw-vbi.rst  |  9 ++++++-
 Documentation/media/uapi/v4l/dev-rds.rst      |  9 ++++++-
 Documentation/media/uapi/v4l/dev-sdr.rst      |  9 ++++++-
 .../media/uapi/v4l/dev-sliced-vbi.rst         |  9 ++++++-
 Documentation/media/uapi/v4l/dev-subdev.rst   |  9 ++++++-
 Documentation/media/uapi/v4l/dev-teletext.rst |  9 ++++++-
 Documentation/media/uapi/v4l/dev-touch.rst    |  9 ++++++-
 Documentation/media/uapi/v4l/devices.rst      |  9 ++++++-
 Documentation/media/uapi/v4l/diff-v4l.rst     |  9 ++++++-
 Documentation/media/uapi/v4l/dmabuf.rst       |  9 ++++++-
 Documentation/media/uapi/v4l/dv-timings.rst   |  9 ++++++-
 .../media/uapi/v4l/extended-controls.rst      |  9 ++++++-
 Documentation/media/uapi/v4l/field-order.rst  |  9 ++++++-
 Documentation/media/uapi/v4l/fieldseq_bt.svg  | 12 +++++++--
 Documentation/media/uapi/v4l/fieldseq_tb.svg  | 12 +++++++--
 Documentation/media/uapi/v4l/format.rst       |  9 ++++++-
 Documentation/media/uapi/v4l/func-close.rst   |  9 ++++++-
 Documentation/media/uapi/v4l/func-ioctl.rst   |  9 ++++++-
 Documentation/media/uapi/v4l/func-mmap.rst    |  9 ++++++-
 Documentation/media/uapi/v4l/func-munmap.rst  |  9 ++++++-
 Documentation/media/uapi/v4l/func-open.rst    |  9 ++++++-
 Documentation/media/uapi/v4l/func-poll.rst    |  9 ++++++-
 Documentation/media/uapi/v4l/func-read.rst    |  9 ++++++-
 Documentation/media/uapi/v4l/func-select.rst  |  9 ++++++-
 Documentation/media/uapi/v4l/func-write.rst   |  9 ++++++-
 Documentation/media/uapi/v4l/hist-v4l2.rst    |  9 ++++++-
 Documentation/media/uapi/v4l/hsv-formats.rst  |  9 ++++++-
 Documentation/media/uapi/v4l/io.rst           |  9 ++++++-
 .../media/uapi/v4l/libv4l-introduction.rst    |  9 ++++++-
 Documentation/media/uapi/v4l/libv4l.rst       |  9 ++++++-
 Documentation/media/uapi/v4l/meta-formats.rst |  9 ++++++-
 Documentation/media/uapi/v4l/mmap.rst         |  9 ++++++-
 Documentation/media/uapi/v4l/nv12mt.svg       | 27 +++++++++++++++++++
 .../media/uapi/v4l/nv12mt_example.svg         | 27 +++++++++++++++++++
 Documentation/media/uapi/v4l/open.rst         |  9 ++++++-
 Documentation/media/uapi/v4l/pipeline.dot     |  2 ++
 .../media/uapi/v4l/pixfmt-compressed.rst      |  9 ++++++-
 Documentation/media/uapi/v4l/pixfmt-grey.rst  |  9 ++++++-
 .../media/uapi/v4l/pixfmt-indexed.rst         |  9 ++++++-
 Documentation/media/uapi/v4l/pixfmt-intro.rst |  9 ++++++-
 Documentation/media/uapi/v4l/pixfmt-inzi.rst  |  9 ++++++-
 Documentation/media/uapi/v4l/pixfmt-m420.rst  |  9 ++++++-
 .../media/uapi/v4l/pixfmt-meta-d4xx.rst       |  9 ++++++-
 .../media/uapi/v4l/pixfmt-meta-uvc.rst        |  9 ++++++-
 .../media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst   |  9 ++++++-
 .../media/uapi/v4l/pixfmt-meta-vsp1-hgt.rst   |  9 ++++++-
 Documentation/media/uapi/v4l/pixfmt-nv12.rst  |  9 ++++++-
 Documentation/media/uapi/v4l/pixfmt-nv12m.rst |  9 ++++++-
 .../media/uapi/v4l/pixfmt-nv12mt.rst          |  9 ++++++-
 Documentation/media/uapi/v4l/pixfmt-nv16.rst  |  9 ++++++-
 Documentation/media/uapi/v4l/pixfmt-nv16m.rst |  9 ++++++-
 Documentation/media/uapi/v4l/pixfmt-nv24.rst  |  9 ++++++-
 .../media/uapi/v4l/pixfmt-packed-hsv.rst      |  9 ++++++-
 .../media/uapi/v4l/pixfmt-packed-rgb.rst      |  9 ++++++-
 .../media/uapi/v4l/pixfmt-packed-yuv.rst      |  9 ++++++-
 .../media/uapi/v4l/pixfmt-reserved.rst        |  9 ++++++-
 Documentation/media/uapi/v4l/pixfmt-rgb.rst   |  9 ++++++-
 .../media/uapi/v4l/pixfmt-sdr-cs08.rst        |  9 ++++++-
 .../media/uapi/v4l/pixfmt-sdr-cs14le.rst      |  9 ++++++-
 .../media/uapi/v4l/pixfmt-sdr-cu08.rst        |  9 ++++++-
 .../media/uapi/v4l/pixfmt-sdr-cu16le.rst      |  9 ++++++-
 .../media/uapi/v4l/pixfmt-sdr-pcu16be.rst     |  9 ++++++-
 .../media/uapi/v4l/pixfmt-sdr-pcu18be.rst     |  9 ++++++-
 .../media/uapi/v4l/pixfmt-sdr-pcu20be.rst     | 10 ++++++-
 .../media/uapi/v4l/pixfmt-sdr-ru12le.rst      |  9 ++++++-
 .../media/uapi/v4l/pixfmt-srggb10-ipu3.rst    |  9 ++++++-
 .../media/uapi/v4l/pixfmt-srggb10.rst         |  9 ++++++-
 .../media/uapi/v4l/pixfmt-srggb10alaw8.rst    |  9 ++++++-
 .../media/uapi/v4l/pixfmt-srggb10dpcm8.rst    |  9 ++++++-
 .../media/uapi/v4l/pixfmt-srggb10p.rst        |  9 ++++++-
 .../media/uapi/v4l/pixfmt-srggb12.rst         |  9 ++++++-
 .../media/uapi/v4l/pixfmt-srggb12p.rst        |  9 ++++++-
 .../media/uapi/v4l/pixfmt-srggb14p.rst        |  9 ++++++-
 .../media/uapi/v4l/pixfmt-srggb16.rst         |  9 ++++++-
 .../media/uapi/v4l/pixfmt-srggb8.rst          |  9 ++++++-
 .../media/uapi/v4l/pixfmt-tch-td08.rst        |  9 ++++++-
 .../media/uapi/v4l/pixfmt-tch-td16.rst        |  9 ++++++-
 .../media/uapi/v4l/pixfmt-tch-tu08.rst        |  9 ++++++-
 .../media/uapi/v4l/pixfmt-tch-tu16.rst        |  9 ++++++-
 Documentation/media/uapi/v4l/pixfmt-uv8.rst   |  9 ++++++-
 Documentation/media/uapi/v4l/pixfmt-uyvy.rst  |  9 ++++++-
 .../media/uapi/v4l/pixfmt-v4l2-mplane.rst     |  9 ++++++-
 Documentation/media/uapi/v4l/pixfmt-v4l2.rst  |  9 ++++++-
 Documentation/media/uapi/v4l/pixfmt-vyuy.rst  |  9 ++++++-
 Documentation/media/uapi/v4l/pixfmt-y10.rst   |  9 ++++++-
 Documentation/media/uapi/v4l/pixfmt-y10b.rst  |  9 ++++++-
 Documentation/media/uapi/v4l/pixfmt-y10p.rst  |  9 ++++++-
 Documentation/media/uapi/v4l/pixfmt-y12.rst   |  9 ++++++-
 Documentation/media/uapi/v4l/pixfmt-y12i.rst  |  9 ++++++-
 .../media/uapi/v4l/pixfmt-y16-be.rst          |  9 ++++++-
 Documentation/media/uapi/v4l/pixfmt-y16.rst   |  9 ++++++-
 Documentation/media/uapi/v4l/pixfmt-y41p.rst  |  9 ++++++-
 Documentation/media/uapi/v4l/pixfmt-y8i.rst   |  9 ++++++-
 .../media/uapi/v4l/pixfmt-yuv410.rst          |  9 ++++++-
 .../media/uapi/v4l/pixfmt-yuv411p.rst         |  9 ++++++-
 .../media/uapi/v4l/pixfmt-yuv420.rst          |  9 ++++++-
 .../media/uapi/v4l/pixfmt-yuv420m.rst         |  9 ++++++-
 .../media/uapi/v4l/pixfmt-yuv422m.rst         |  9 ++++++-
 .../media/uapi/v4l/pixfmt-yuv422p.rst         |  9 ++++++-
 .../media/uapi/v4l/pixfmt-yuv444m.rst         |  9 ++++++-
 Documentation/media/uapi/v4l/pixfmt-yuyv.rst  |  9 ++++++-
 Documentation/media/uapi/v4l/pixfmt-yvyu.rst  |  9 ++++++-
 Documentation/media/uapi/v4l/pixfmt-z16.rst   |  9 ++++++-
 Documentation/media/uapi/v4l/pixfmt.rst       |  9 ++++++-
 Documentation/media/uapi/v4l/planar-apis.rst  |  9 ++++++-
 Documentation/media/uapi/v4l/querycap.rst     |  9 ++++++-
 Documentation/media/uapi/v4l/rw.rst           |  9 ++++++-
 Documentation/media/uapi/v4l/sdr-formats.rst  |  9 ++++++-
 .../uapi/v4l/selection-api-configuration.rst  |  9 ++++++-
 .../media/uapi/v4l/selection-api-examples.rst |  9 ++++++-
 .../media/uapi/v4l/selection-api-intro.rst    |  9 ++++++-
 .../media/uapi/v4l/selection-api-targets.rst  |  9 ++++++-
 .../uapi/v4l/selection-api-vs-crop-api.rst    |  9 ++++++-
 .../media/uapi/v4l/selection-api.rst          |  9 ++++++-
 Documentation/media/uapi/v4l/selection.svg    | 27 +++++++++++++++++++
 .../media/uapi/v4l/selections-common.rst      |  9 ++++++-
 Documentation/media/uapi/v4l/standard.rst     |  9 ++++++-
 .../media/uapi/v4l/streaming-par.rst          |  9 ++++++-
 .../media/uapi/v4l/subdev-formats.rst         |  9 ++++++-
 .../uapi/v4l/subdev-image-processing-crop.svg | 10 +++++++
 .../uapi/v4l/subdev-image-processing-full.svg | 10 +++++++
 ...-image-processing-scaling-multi-source.svg | 10 +++++++
 Documentation/media/uapi/v4l/tch-formats.rst  |  9 ++++++-
 Documentation/media/uapi/v4l/tuner.rst        |  9 ++++++-
 Documentation/media/uapi/v4l/user-func.rst    |  9 ++++++-
 Documentation/media/uapi/v4l/userp.rst        |  9 ++++++-
 .../media/uapi/v4l/v4l2-selection-flags.rst   |  9 ++++++-
 .../media/uapi/v4l/v4l2-selection-targets.rst |  9 ++++++-
 Documentation/media/uapi/v4l/v4l2.rst         |  9 ++++++-
 .../media/uapi/v4l/v4l2grab-example.rst       |  9 ++++++-
 Documentation/media/uapi/v4l/v4l2grab.c.rst   |  9 ++++++-
 Documentation/media/uapi/v4l/vbi_525.svg      | 12 +++++++--
 Documentation/media/uapi/v4l/vbi_625.svg      | 12 +++++++--
 Documentation/media/uapi/v4l/vbi_hsync.svg    | 12 +++++++--
 Documentation/media/uapi/v4l/video.rst        |  9 ++++++-
 Documentation/media/uapi/v4l/videodev.rst     |  9 ++++++-
 .../media/uapi/v4l/vidioc-create-bufs.rst     |  9 ++++++-
 .../media/uapi/v4l/vidioc-cropcap.rst         |  9 ++++++-
 .../media/uapi/v4l/vidioc-dbg-g-chip-info.rst |  9 ++++++-
 .../media/uapi/v4l/vidioc-dbg-g-register.rst  |  9 ++++++-
 .../media/uapi/v4l/vidioc-decoder-cmd.rst     |  9 ++++++-
 .../media/uapi/v4l/vidioc-dqevent.rst         |  9 ++++++-
 .../media/uapi/v4l/vidioc-dv-timings-cap.rst  |  9 ++++++-
 .../media/uapi/v4l/vidioc-encoder-cmd.rst     |  9 ++++++-
 .../media/uapi/v4l/vidioc-enum-dv-timings.rst |  9 ++++++-
 .../media/uapi/v4l/vidioc-enum-fmt.rst        |  9 ++++++-
 .../uapi/v4l/vidioc-enum-frameintervals.rst   |  9 ++++++-
 .../media/uapi/v4l/vidioc-enum-framesizes.rst |  9 ++++++-
 .../media/uapi/v4l/vidioc-enum-freq-bands.rst |  9 ++++++-
 .../media/uapi/v4l/vidioc-enumaudio.rst       |  9 ++++++-
 .../media/uapi/v4l/vidioc-enumaudioout.rst    |  9 ++++++-
 .../media/uapi/v4l/vidioc-enuminput.rst       |  9 ++++++-
 .../media/uapi/v4l/vidioc-enumoutput.rst      |  9 ++++++-
 .../media/uapi/v4l/vidioc-enumstd.rst         |  9 ++++++-
 .../media/uapi/v4l/vidioc-expbuf.rst          |  9 ++++++-
 .../media/uapi/v4l/vidioc-g-audio.rst         |  9 ++++++-
 .../media/uapi/v4l/vidioc-g-audioout.rst      |  9 ++++++-
 .../media/uapi/v4l/vidioc-g-crop.rst          |  9 ++++++-
 .../media/uapi/v4l/vidioc-g-ctrl.rst          |  9 ++++++-
 .../media/uapi/v4l/vidioc-g-dv-timings.rst    |  9 ++++++-
 .../media/uapi/v4l/vidioc-g-edid.rst          |  9 ++++++-
 .../media/uapi/v4l/vidioc-g-enc-index.rst     |  9 ++++++-
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst     |  9 ++++++-
 .../media/uapi/v4l/vidioc-g-fbuf.rst          |  9 ++++++-
 Documentation/media/uapi/v4l/vidioc-g-fmt.rst |  9 ++++++-
 .../media/uapi/v4l/vidioc-g-frequency.rst     |  9 ++++++-
 .../media/uapi/v4l/vidioc-g-input.rst         |  9 ++++++-
 .../media/uapi/v4l/vidioc-g-jpegcomp.rst      |  9 ++++++-
 .../media/uapi/v4l/vidioc-g-modulator.rst     |  9 ++++++-
 .../media/uapi/v4l/vidioc-g-output.rst        |  9 ++++++-
 .../media/uapi/v4l/vidioc-g-parm.rst          |  9 ++++++-
 .../media/uapi/v4l/vidioc-g-priority.rst      |  9 ++++++-
 .../media/uapi/v4l/vidioc-g-selection.rst     |  9 ++++++-
 .../uapi/v4l/vidioc-g-sliced-vbi-cap.rst      |  9 ++++++-
 Documentation/media/uapi/v4l/vidioc-g-std.rst |  9 ++++++-
 .../media/uapi/v4l/vidioc-g-tuner.rst         |  9 ++++++-
 .../media/uapi/v4l/vidioc-log-status.rst      |  9 ++++++-
 .../media/uapi/v4l/vidioc-overlay.rst         |  9 ++++++-
 .../media/uapi/v4l/vidioc-prepare-buf.rst     |  9 ++++++-
 Documentation/media/uapi/v4l/vidioc-qbuf.rst  |  9 ++++++-
 .../uapi/v4l/vidioc-query-dv-timings.rst      |  9 ++++++-
 .../media/uapi/v4l/vidioc-querybuf.rst        |  9 ++++++-
 .../media/uapi/v4l/vidioc-querycap.rst        |  9 ++++++-
 .../media/uapi/v4l/vidioc-queryctrl.rst       |  9 ++++++-
 .../media/uapi/v4l/vidioc-querystd.rst        |  9 ++++++-
 .../media/uapi/v4l/vidioc-reqbufs.rst         |  9 ++++++-
 .../media/uapi/v4l/vidioc-s-hw-freq-seek.rst  |  9 ++++++-
 .../media/uapi/v4l/vidioc-streamon.rst        |  9 ++++++-
 .../v4l/vidioc-subdev-enum-frame-interval.rst |  9 ++++++-
 .../v4l/vidioc-subdev-enum-frame-size.rst     |  9 ++++++-
 .../uapi/v4l/vidioc-subdev-enum-mbus-code.rst |  9 ++++++-
 .../media/uapi/v4l/vidioc-subdev-g-crop.rst   |  9 ++++++-
 .../media/uapi/v4l/vidioc-subdev-g-fmt.rst    |  9 ++++++-
 .../v4l/vidioc-subdev-g-frame-interval.rst    |  9 ++++++-
 .../uapi/v4l/vidioc-subdev-g-selection.rst    |  9 ++++++-
 .../media/uapi/v4l/vidioc-subscribe-event.rst |  9 ++++++-
 Documentation/media/uapi/v4l/yuv-formats.rst  |  9 ++++++-
 .../media/v4l-drivers/au0828-cardlist.rst     |  2 ++
 .../media/v4l-drivers/bttv-cardlist.rst       |  2 ++
 Documentation/media/v4l-drivers/bttv.rst      |  2 ++
 Documentation/media/v4l-drivers/cafe_ccic.rst |  2 ++
 Documentation/media/v4l-drivers/cardlist.rst  |  2 ++
 Documentation/media/v4l-drivers/cpia2.rst     |  2 ++
 Documentation/media/v4l-drivers/cx18.rst      |  2 ++
 Documentation/media/v4l-drivers/cx2341x.rst   |  2 ++
 .../media/v4l-drivers/cx23885-cardlist.rst    |  2 ++
 .../media/v4l-drivers/cx88-cardlist.rst       |  2 ++
 Documentation/media/v4l-drivers/cx88.rst      |  2 ++
 .../media/v4l-drivers/davinci-vpbe.rst        |  2 ++
 .../media/v4l-drivers/em28xx-cardlist.rst     |  2 ++
 Documentation/media/v4l-drivers/fimc.rst      |  2 ++
 Documentation/media/v4l-drivers/fourcc.rst    |  2 ++
 .../media/v4l-drivers/gspca-cardlist.rst      |  2 ++
 Documentation/media/v4l-drivers/imx.rst       |  2 ++
 Documentation/media/v4l-drivers/index.rst     |  2 +-
 .../media/v4l-drivers/ivtv-cardlist.rst       |  2 ++
 Documentation/media/v4l-drivers/ivtv.rst      |  1 +
 Documentation/media/v4l-drivers/max2175.rst   |  2 ++
 Documentation/media/v4l-drivers/meye.rst      |  2 ++
 Documentation/media/v4l-drivers/omap3isp.rst  |  2 ++
 .../media/v4l-drivers/omap4_camera.rst        |  2 ++
 Documentation/media/v4l-drivers/philips.rst   |  2 ++
 Documentation/media/v4l-drivers/pvrusb2.rst   |  2 ++
 .../media/v4l-drivers/pxa_camera.rst          |  2 ++
 .../media/v4l-drivers/qcom_camss.rst          |  2 ++
 .../v4l-drivers/qcom_camss_8x96_graph.dot     |  2 ++
 .../media/v4l-drivers/qcom_camss_graph.dot    |  2 ++
 .../media/v4l-drivers/radiotrack.rst          |  2 ++
 Documentation/media/v4l-drivers/rcar-fdp1.rst |  2 ++
 .../media/v4l-drivers/saa7134-cardlist.rst    |  2 ++
 Documentation/media/v4l-drivers/saa7134.rst   |  2 ++
 .../media/v4l-drivers/saa7164-cardlist.rst    |  2 ++
 .../v4l-drivers/sh_mobile_ceu_camera.rst      |  2 ++
 Documentation/media/v4l-drivers/si470x.rst    |  2 ++
 Documentation/media/v4l-drivers/si4713.rst    |  2 ++
 Documentation/media/v4l-drivers/si476x.rst    |  2 ++
 .../media/v4l-drivers/soc-camera.rst          |  2 ++
 .../media/v4l-drivers/tm6000-cardlist.rst     |  2 ++
 .../media/v4l-drivers/tuner-cardlist.rst      |  2 ++
 Documentation/media/v4l-drivers/tuners.rst    |  2 ++
 .../media/v4l-drivers/usbvision-cardlist.rst  |  2 ++
 Documentation/media/v4l-drivers/uvcvideo.rst  |  2 ++
 .../media/v4l-drivers/v4l-with-ir.rst         |  2 ++
 Documentation/media/v4l-drivers/vivid.rst     |  2 ++
 Documentation/media/v4l-drivers/zoran.rst     |  2 ++
 Documentation/media/v4l-drivers/zr364xx.rst   |  2 ++
 Documentation/media/video.h.rst.exceptions    |  2 ++
 .../media/videodev2.h.rst.exceptions          |  2 ++
 531 files changed, 3687 insertions(+), 406 deletions(-)

-- 
2.19.1
