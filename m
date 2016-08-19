Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42937 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754011AbcHSU2A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 16:28:00 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jani Nikula <jani.nikula@intel.com>, linux-doc@vger.kernel.org
Subject: [PATCH 0/6] Convert media uAPI to c domain
Date: Fri, 19 Aug 2016 17:27:47 -0300
Message-Id: <cover.1471636893.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those patches make usage of the new c-domain override extension
written by Markus. They allow stopping abusing of the cpp domain to
allow "overriding" the ioctl function, and converts all syscall documentation
at the media uAPI book to c domain.

Mauro Carvalho Chehab (6):
  [media] docs-next: stop abusing on the cpp domain
  [media] docs-rst: Convert V4L2 uAPI to use C function references
  [media] docs-rst: Convert DVB uAPI to use C function references
  [media] docs-rst: Convert CEC uAPI to use C function references
  [media] docs-rst: Convert LIRC uAPI to use C function references
  [media] docs-rst: Convert MC uAPI to use C function references

 Documentation/media/conf_nitpick.py                | 33 +++++++-------
 Documentation/media/kapi/dtv-core.rst              |  2 +-
 Documentation/media/kapi/v4l2-dev.rst              |  4 +-
 Documentation/media/kapi/v4l2-fh.rst               |  4 +-
 Documentation/media/kapi/v4l2-subdev.rst           |  2 +-
 Documentation/media/uapi/cec/cec-func-close.rst    |  5 +-
 Documentation/media/uapi/cec/cec-func-ioctl.rst    |  7 +--
 Documentation/media/uapi/cec/cec-func-open.rst     |  3 +-
 Documentation/media/uapi/cec/cec-func-poll.rst     | 12 ++++-
 .../media/uapi/cec/cec-ioc-adap-g-caps.rst         |  6 +--
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    | 12 ++---
 .../media/uapi/cec/cec-ioc-adap-g-phys-addr.rst    | 13 +++---
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   |  7 +--
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst    | 13 +++---
 Documentation/media/uapi/cec/cec-ioc-receive.rst   | 13 +++---
 .../uapi/dvb/audio-bilingual-channel-select.rst    | 15 ++----
 .../media/uapi/dvb/audio-channel-select.rst        | 14 ++----
 .../media/uapi/dvb/audio-clear-buffer.rst          | 12 ++---
 Documentation/media/uapi/dvb/audio-continue.rst    | 11 ++---
 Documentation/media/uapi/dvb/audio-fclose.rst      |  4 +-
 Documentation/media/uapi/dvb/audio-fopen.rst       |  4 +-
 Documentation/media/uapi/dvb/audio-fwrite.rst      |  4 +-
 .../media/uapi/dvb/audio-get-capabilities.rst      | 14 ++----
 Documentation/media/uapi/dvb/audio-get-pts.rst     | 14 ++----
 Documentation/media/uapi/dvb/audio-get-status.rst  | 14 ++----
 Documentation/media/uapi/dvb/audio-pause.rst       | 11 ++---
 Documentation/media/uapi/dvb/audio-play.rst        | 11 ++---
 .../media/uapi/dvb/audio-select-source.rst         | 14 ++----
 .../media/uapi/dvb/audio-set-attributes.rst        | 16 +++----
 Documentation/media/uapi/dvb/audio-set-av-sync.rst | 24 +++-------
 .../media/uapi/dvb/audio-set-bypass-mode.rst       | 25 +++-------
 Documentation/media/uapi/dvb/audio-set-ext-id.rst  | 15 ++----
 Documentation/media/uapi/dvb/audio-set-id.rst      | 15 ++----
 Documentation/media/uapi/dvb/audio-set-karaoke.rst | 14 ++----
 Documentation/media/uapi/dvb/audio-set-mixer.rst   | 15 ++----
 Documentation/media/uapi/dvb/audio-set-mute.rst    | 24 +++-------
 .../media/uapi/dvb/audio-set-streamtype.rst        | 14 ++----
 Documentation/media/uapi/dvb/audio-stop.rst        | 11 ++---
 Documentation/media/uapi/dvb/ca-fclose.rst         | 18 ++------
 Documentation/media/uapi/dvb/ca-fopen.rst          | 53 ++++++++--------------
 Documentation/media/uapi/dvb/ca-get-cap.rst        | 30 +++---------
 Documentation/media/uapi/dvb/ca-get-descr-info.rst | 31 +++----------
 Documentation/media/uapi/dvb/ca-get-msg.rst        | 30 +++---------
 Documentation/media/uapi/dvb/ca-get-slot-info.rst  | 30 +++---------
 Documentation/media/uapi/dvb/ca-reset.rst          | 24 ++--------
 Documentation/media/uapi/dvb/ca-send-msg.rst       | 30 +++---------
 Documentation/media/uapi/dvb/ca-set-descr.rst      | 30 +++---------
 Documentation/media/uapi/dvb/ca-set-pid.rst        | 30 +++---------
 Documentation/media/uapi/dvb/dmx-add-pid.rst       | 28 +++---------
 Documentation/media/uapi/dvb/dmx-fclose.rst        | 16 ++-----
 Documentation/media/uapi/dvb/dmx-fopen.rst         | 49 ++++++++------------
 Documentation/media/uapi/dvb/dmx-fread.rst         | 31 ++++---------
 Documentation/media/uapi/dvb/dmx-fwrite.rst        | 32 ++++---------
 Documentation/media/uapi/dvb/dmx-get-caps.rst      | 31 +++----------
 Documentation/media/uapi/dvb/dmx-get-event.rst     | 28 +++---------
 Documentation/media/uapi/dvb/dmx-get-pes-pids.rst  | 31 +++----------
 Documentation/media/uapi/dvb/dmx-get-stc.rst       | 31 +++----------
 Documentation/media/uapi/dvb/dmx-remove-pid.rst    | 28 +++---------
 .../media/uapi/dvb/dmx-set-buffer-size.rst         | 29 +++---------
 Documentation/media/uapi/dvb/dmx-set-filter.rst    | 28 +++---------
 .../media/uapi/dvb/dmx-set-pes-filter.rst          | 27 +++--------
 Documentation/media/uapi/dvb/dmx-set-source.rst    | 29 +++---------
 Documentation/media/uapi/dvb/dmx-start.rst         | 22 ++-------
 Documentation/media/uapi/dvb/dmx-stop.rst          | 22 ++-------
 .../media/uapi/dvb/fe-diseqc-recv-slave-reply.rst  |  6 +--
 .../media/uapi/dvb/fe-diseqc-reset-overload.rst    |  7 +--
 .../media/uapi/dvb/fe-diseqc-send-burst.rst        |  6 +--
 .../media/uapi/dvb/fe-diseqc-send-master-cmd.rst   |  6 +--
 .../uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst    | 16 +++----
 .../media/uapi/dvb/fe-enable-high-lnb-voltage.rst  |  6 +--
 Documentation/media/uapi/dvb/fe-get-event.rst      | 35 ++++----------
 Documentation/media/uapi/dvb/fe-get-frontend.rst   | 30 ++++--------
 Documentation/media/uapi/dvb/fe-get-info.rst       |  6 +--
 Documentation/media/uapi/dvb/fe-get-property.rst   |  9 ++--
 Documentation/media/uapi/dvb/fe-read-ber.rst       | 30 ++++--------
 .../media/uapi/dvb/fe-read-signal-strength.rst     | 31 +++----------
 Documentation/media/uapi/dvb/fe-read-snr.rst       | 29 +++---------
 Documentation/media/uapi/dvb/fe-read-status.rst    |  6 +--
 .../media/uapi/dvb/fe-read-uncorrected-blocks.rst  | 31 +++----------
 .../media/uapi/dvb/fe-set-frontend-tune-mode.rst   |  6 +--
 Documentation/media/uapi/dvb/fe-set-frontend.rst   | 31 ++++---------
 Documentation/media/uapi/dvb/fe-set-tone.rst       |  6 +--
 Documentation/media/uapi/dvb/fe-set-voltage.rst    |  6 +--
 Documentation/media/uapi/dvb/frontend_f_close.rst  |  6 +--
 Documentation/media/uapi/dvb/frontend_f_open.rst   |  4 +-
 Documentation/media/uapi/dvb/net-add-if.rst        |  6 +--
 Documentation/media/uapi/dvb/net-get-if.rst        |  6 +--
 Documentation/media/uapi/dvb/net-remove-if.rst     |  6 +--
 .../media/uapi/dvb/video-clear-buffer.rst          |  4 +-
 Documentation/media/uapi/dvb/video-command.rst     |  4 +-
 Documentation/media/uapi/dvb/video-continue.rst    |  4 +-
 .../media/uapi/dvb/video-fast-forward.rst          |  4 +-
 Documentation/media/uapi/dvb/video-fclose.rst      |  3 +-
 Documentation/media/uapi/dvb/video-fopen.rst       |  3 +-
 Documentation/media/uapi/dvb/video-freeze.rst      |  4 +-
 Documentation/media/uapi/dvb/video-fwrite.rst      |  3 +-
 .../media/uapi/dvb/video-get-capabilities.rst      |  4 +-
 Documentation/media/uapi/dvb/video-get-event.rst   |  4 +-
 .../media/uapi/dvb/video-get-frame-count.rst       |  4 +-
 .../media/uapi/dvb/video-get-frame-rate.rst        |  4 +-
 Documentation/media/uapi/dvb/video-get-navi.rst    |  4 +-
 Documentation/media/uapi/dvb/video-get-pts.rst     |  4 +-
 Documentation/media/uapi/dvb/video-get-size.rst    |  4 +-
 Documentation/media/uapi/dvb/video-get-status.rst  |  4 +-
 Documentation/media/uapi/dvb/video-play.rst        |  4 +-
 .../media/uapi/dvb/video-select-source.rst         |  4 +-
 .../media/uapi/dvb/video-set-attributes.rst        |  4 +-
 Documentation/media/uapi/dvb/video-set-blank.rst   |  4 +-
 .../media/uapi/dvb/video-set-display-format.rst    |  4 +-
 Documentation/media/uapi/dvb/video-set-format.rst  |  4 +-
 .../media/uapi/dvb/video-set-highlight.rst         |  4 +-
 Documentation/media/uapi/dvb/video-set-id.rst      |  4 +-
 .../media/uapi/dvb/video-set-spu-palette.rst       |  4 +-
 Documentation/media/uapi/dvb/video-set-spu.rst     |  4 +-
 .../media/uapi/dvb/video-set-streamtype.rst        |  4 +-
 Documentation/media/uapi/dvb/video-set-system.rst  |  4 +-
 Documentation/media/uapi/dvb/video-slowmotion.rst  |  4 +-
 .../media/uapi/dvb/video-stillpicture.rst          |  4 +-
 Documentation/media/uapi/dvb/video-stop.rst        |  4 +-
 Documentation/media/uapi/dvb/video-try-command.rst |  4 +-
 .../media/uapi/mediactl/media-func-close.rst       |  6 +--
 .../media/uapi/mediactl/media-func-ioctl.rst       |  6 +--
 .../media/uapi/mediactl/media-func-open.rst        |  4 +-
 .../media/uapi/mediactl/media-ioc-device-info.rst  |  6 +--
 .../uapi/mediactl/media-ioc-enum-entities.rst      |  6 +--
 .../media/uapi/mediactl/media-ioc-enum-links.rst   |  6 +--
 .../media/uapi/mediactl/media-ioc-g-topology.rst   |  6 +--
 .../media/uapi/mediactl/media-ioc-setup-link.rst   |  6 +--
 Documentation/media/uapi/rc/lirc-get-features.rst  |  6 +--
 Documentation/media/uapi/rc/lirc-get-length.rst    |  6 +--
 Documentation/media/uapi/rc/lirc-get-rec-mode.rst  | 11 +++--
 .../media/uapi/rc/lirc-get-rec-resolution.rst      |  6 +--
 Documentation/media/uapi/rc/lirc-get-send-mode.rst |  9 ++--
 Documentation/media/uapi/rc/lirc-get-timeout.rst   |  9 ++--
 Documentation/media/uapi/rc/lirc-read.rst          |  7 ++-
 .../uapi/rc/lirc-set-measure-carrier-mode.rst      |  6 +--
 .../media/uapi/rc/lirc-set-rec-carrier-range.rst   |  6 +--
 .../media/uapi/rc/lirc-set-rec-carrier.rst         |  6 +--
 .../media/uapi/rc/lirc-set-rec-timeout-reports.rst |  6 +--
 .../media/uapi/rc/lirc-set-rec-timeout.rst         |  6 +--
 .../media/uapi/rc/lirc-set-send-carrier.rst        |  6 +--
 .../media/uapi/rc/lirc-set-send-duty-cycle.rst     |  6 +--
 .../media/uapi/rc/lirc-set-transmitter-mask.rst    |  6 +--
 .../media/uapi/rc/lirc-set-wideband-receiver.rst   |  6 +--
 Documentation/media/uapi/rc/lirc-write.rst         |  8 ++--
 Documentation/media/uapi/v4l/func-close.rst        |  4 +-
 Documentation/media/uapi/v4l/func-ioctl.rst        |  4 +-
 Documentation/media/uapi/v4l/func-mmap.rst         |  4 +-
 Documentation/media/uapi/v4l/func-munmap.rst       |  4 +-
 Documentation/media/uapi/v4l/func-open.rst         |  4 +-
 Documentation/media/uapi/v4l/func-poll.rst         |  4 +-
 Documentation/media/uapi/v4l/func-read.rst         |  8 ++--
 Documentation/media/uapi/v4l/func-select.rst       | 18 +++++++-
 Documentation/media/uapi/v4l/func-write.rst        |  8 ++--
 .../media/uapi/v4l/vidioc-create-bufs.rst          |  6 +--
 Documentation/media/uapi/v4l/vidioc-cropcap.rst    |  6 +--
 .../media/uapi/v4l/vidioc-dbg-g-chip-info.rst      |  6 +--
 .../media/uapi/v4l/vidioc-dbg-g-register.rst       |  9 ++--
 .../media/uapi/v4l/vidioc-decoder-cmd.rst          | 11 +++--
 Documentation/media/uapi/v4l/vidioc-dqevent.rst    |  6 +--
 .../media/uapi/v4l/vidioc-dv-timings-cap.rst       |  9 ++--
 .../media/uapi/v4l/vidioc-encoder-cmd.rst          |  9 ++--
 .../media/uapi/v4l/vidioc-enum-dv-timings.rst      |  9 ++--
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst   |  6 +--
 .../media/uapi/v4l/vidioc-enum-frameintervals.rst  |  6 +--
 .../media/uapi/v4l/vidioc-enum-framesizes.rst      |  6 +--
 .../media/uapi/v4l/vidioc-enum-freq-bands.rst      |  6 +--
 Documentation/media/uapi/v4l/vidioc-enumaudio.rst  |  6 +--
 .../media/uapi/v4l/vidioc-enumaudioout.rst         |  6 +--
 Documentation/media/uapi/v4l/vidioc-enuminput.rst  |  6 +--
 Documentation/media/uapi/v4l/vidioc-enumoutput.rst |  6 +--
 Documentation/media/uapi/v4l/vidioc-enumstd.rst    |  6 +--
 Documentation/media/uapi/v4l/vidioc-expbuf.rst     |  6 +--
 Documentation/media/uapi/v4l/vidioc-g-audio.rst    |  9 ++--
 Documentation/media/uapi/v4l/vidioc-g-audioout.rst |  9 ++--
 Documentation/media/uapi/v4l/vidioc-g-crop.rst     |  9 ++--
 Documentation/media/uapi/v4l/vidioc-g-ctrl.rst     |  9 ++--
 .../media/uapi/v4l/vidioc-g-dv-timings.rst         | 16 +++++--
 Documentation/media/uapi/v4l/vidioc-g-edid.rst     | 17 +++++--
 .../media/uapi/v4l/vidioc-g-enc-index.rst          |  6 +--
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst          | 15 ++++--
 Documentation/media/uapi/v4l/vidioc-g-fbuf.rst     |  9 ++--
 Documentation/media/uapi/v4l/vidioc-g-fmt.rst      | 11 +++--
 .../media/uapi/v4l/vidioc-g-frequency.rst          |  9 ++--
 Documentation/media/uapi/v4l/vidioc-g-input.rst    |  9 ++--
 Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst |  9 ++--
 .../media/uapi/v4l/vidioc-g-modulator.rst          |  9 ++--
 Documentation/media/uapi/v4l/vidioc-g-output.rst   |  9 ++--
 Documentation/media/uapi/v4l/vidioc-g-parm.rst     |  9 ++--
 Documentation/media/uapi/v4l/vidioc-g-priority.rst |  9 ++--
 .../media/uapi/v4l/vidioc-g-selection.rst          |  7 ++-
 .../media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst     |  6 +--
 Documentation/media/uapi/v4l/vidioc-g-std.rst      |  9 ++--
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst    |  9 ++--
 Documentation/media/uapi/v4l/vidioc-log-status.rst |  5 +-
 Documentation/media/uapi/v4l/vidioc-overlay.rst    |  6 +--
 .../media/uapi/v4l/vidioc-prepare-buf.rst          |  6 +--
 Documentation/media/uapi/v4l/vidioc-qbuf.rst       |  9 ++--
 .../media/uapi/v4l/vidioc-query-dv-timings.rst     |  9 ++--
 Documentation/media/uapi/v4l/vidioc-querybuf.rst   |  6 +--
 Documentation/media/uapi/v4l/vidioc-querycap.rst   |  6 +--
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst  | 12 ++---
 Documentation/media/uapi/v4l/vidioc-querystd.rst   |  6 +--
 Documentation/media/uapi/v4l/vidioc-reqbufs.rst    |  6 +--
 .../media/uapi/v4l/vidioc-s-hw-freq-seek.rst       |  6 +--
 Documentation/media/uapi/v4l/vidioc-streamon.rst   |  9 ++--
 .../uapi/v4l/vidioc-subdev-enum-frame-interval.rst |  6 +--
 .../uapi/v4l/vidioc-subdev-enum-frame-size.rst     |  6 +--
 .../uapi/v4l/vidioc-subdev-enum-mbus-code.rst      |  6 +--
 .../media/uapi/v4l/vidioc-subdev-g-crop.rst        |  9 ++--
 .../media/uapi/v4l/vidioc-subdev-g-fmt.rst         |  9 ++--
 .../uapi/v4l/vidioc-subdev-g-frame-interval.rst    | 10 ++--
 .../media/uapi/v4l/vidioc-subdev-g-selection.rst   |  9 ++--
 .../media/uapi/v4l/vidioc-subscribe-event.rst      |  9 ++--
 214 files changed, 896 insertions(+), 1484 deletions(-)

-- 
2.7.4


