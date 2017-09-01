Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48354
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752258AbdIATh7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 15:37:59 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Colin Ian King <colin.king@canonical.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 00/14] Another set of DVB documentation patches
Date: Fri,  1 Sep 2017 16:37:36 -0300
Message-Id: <cover.1504293108.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series should come after this series: 
	[PATCH v2 00/26] Improve DVB documentation and reduce its gap
	(with actually has 27 patches :-p )

It adds documentation for a dmx.h ioctl (DMX_GET_PES_PIDS) and do
a cleanup at the documentation, to make it more coherent with the other
media uAPI docs. In particular, it fixes the error codes for ioctls, removing
redundant and non-existing error codes.

It also fixes some random other problems I found while re-reading the
documentation.

Mauro Carvalho Chehab (14):
  media: dvb uapi docs: better organize header files
  media: gen-errors.rst: remove row number comments
  media: gen-errors.rst: document ENXIO error code
  media: dvb uAPI docs: adjust return value ioctl descriptions
  media: ca-fopen.rst: Fixes the device node name for CA
  media: dvb uAPI docs: Prefer use "Digital TV instead of "DVB"
  media: dmx-fread.rst: specify how DMX_CHECK_CRC works
  media: dvb-frontend-parameters.rst: fix the name of a struct
  media: dvbapi.rst: add an entry to DVB revision history
  media: dvb uAPI docs: minor editorial changes
  media: dmx-get-pes-pids.rst: document the ioctl
  media: dvbstb.svg: use dots for the optional parts of the hardware
  media: intro.rst: don't assume audio and video codecs to be MPEG2
  media: frontend.h: Avoid the term DVB when doesn't refer to a delivery
    system

 .../media/uapi/dvb/audio-channel-select.rst        |  2 +-
 Documentation/media/uapi/dvb/audio-fclose.rst      |  8 +--
 Documentation/media/uapi/dvb/audio-fopen.rst       |  8 +--
 Documentation/media/uapi/dvb/audio-fwrite.rst      |  8 +--
 Documentation/media/uapi/dvb/audio-set-av-sync.rst |  2 +-
 .../media/uapi/dvb/audio-set-bypass-mode.rst       |  6 +-
 Documentation/media/uapi/dvb/audio-set-mute.rst    |  2 +-
 Documentation/media/uapi/dvb/audio.rst             | 13 ++--
 Documentation/media/uapi/dvb/audio_h.rst           |  9 ---
 Documentation/media/uapi/dvb/ca-fclose.rst         | 21 +++---
 Documentation/media/uapi/dvb/ca-fopen.rst          | 71 +++++++-------------
 Documentation/media/uapi/dvb/ca-get-cap.rst        |  4 +-
 Documentation/media/uapi/dvb/ca-get-msg.rst        |  9 ++-
 Documentation/media/uapi/dvb/ca-get-slot-info.rst  | 10 ++-
 Documentation/media/uapi/dvb/ca-reset.rst          |  8 ++-
 Documentation/media/uapi/dvb/ca-send-msg.rst       |  8 ++-
 Documentation/media/uapi/dvb/ca-set-descr.rst      |  8 ++-
 Documentation/media/uapi/dvb/ca.rst                | 11 +--
 Documentation/media/uapi/dvb/ca_h.rst              |  9 ---
 Documentation/media/uapi/dvb/demux.rst             | 13 ++--
 Documentation/media/uapi/dvb/dmx-add-pid.rst       | 12 ++--
 Documentation/media/uapi/dvb/dmx-fclose.rst        | 26 ++++----
 Documentation/media/uapi/dvb/dmx-fopen.rst         | 66 ++++++++----------
 Documentation/media/uapi/dvb/dmx-fread.rst         | 78 +++++++++-------------
 Documentation/media/uapi/dvb/dmx-fwrite.rst        | 41 ++++++------
 Documentation/media/uapi/dvb/dmx-get-pes-pids.rst  | 30 +++++++--
 Documentation/media/uapi/dvb/dmx-get-stc.rst       | 28 +++++---
 Documentation/media/uapi/dvb/dmx-remove-pid.rst    | 12 ++--
 .../media/uapi/dvb/dmx-set-buffer-size.rst         | 11 ++-
 Documentation/media/uapi/dvb/dmx-set-filter.rst    | 13 ++--
 .../media/uapi/dvb/dmx-set-pes-filter.rst          | 12 +++-
 Documentation/media/uapi/dvb/dmx-start.rst         | 15 +++--
 Documentation/media/uapi/dvb/dmx-stop.rst          | 12 ++--
 Documentation/media/uapi/dvb/dmx_h.rst             |  9 ---
 .../media/uapi/dvb/dvb-fe-read-status.rst          |  2 +-
 .../media/uapi/dvb/dvb-frontend-parameters.rst     |  2 +-
 Documentation/media/uapi/dvb/dvbapi.rst            | 39 +++++++----
 Documentation/media/uapi/dvb/dvbproperty.rst       |  4 +-
 Documentation/media/uapi/dvb/dvbstb.svg            | 31 +++++----
 Documentation/media/uapi/dvb/examples.rst          |  4 +-
 .../media/uapi/dvb/fe-diseqc-recv-slave-reply.rst  |  8 ++-
 .../media/uapi/dvb/fe-diseqc-reset-overload.rst    | 10 ++-
 .../media/uapi/dvb/fe-diseqc-send-burst.rst        |  8 ++-
 .../media/uapi/dvb/fe-diseqc-send-master-cmd.rst   | 11 ++-
 .../uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst    |  8 ++-
 .../media/uapi/dvb/fe-enable-high-lnb-voltage.rst  |  8 ++-
 Documentation/media/uapi/dvb/fe-get-event.rst      |  9 ++-
 Documentation/media/uapi/dvb/fe-get-frontend.rst   | 10 +--
 Documentation/media/uapi/dvb/fe-get-info.rst       | 15 +++--
 Documentation/media/uapi/dvb/fe-get-property.rst   | 10 ++-
 Documentation/media/uapi/dvb/fe-read-ber.rst       |  8 ++-
 .../media/uapi/dvb/fe-read-signal-strength.rst     |  8 ++-
 Documentation/media/uapi/dvb/fe-read-snr.rst       |  8 ++-
 Documentation/media/uapi/dvb/fe-read-status.rst    | 10 ++-
 .../media/uapi/dvb/fe-read-uncorrected-blocks.rst  |  8 ++-
 .../media/uapi/dvb/fe-set-frontend-tune-mode.rst   | 12 ++--
 Documentation/media/uapi/dvb/fe-set-frontend.rst   | 15 +++--
 Documentation/media/uapi/dvb/fe-set-tone.rst       |  8 ++-
 Documentation/media/uapi/dvb/fe-set-voltage.rst    |  8 ++-
 Documentation/media/uapi/dvb/fe-type-t.rst         |  2 +-
 .../media/uapi/dvb/fe_property_parameters.rst      |  4 +-
 .../dvb/frontend-property-terrestrial-systems.rst  |  2 +-
 Documentation/media/uapi/dvb/frontend.rst          | 10 +--
 Documentation/media/uapi/dvb/frontend_f_close.rst  | 16 +++--
 Documentation/media/uapi/dvb/frontend_f_open.rst   | 44 +++++++-----
 Documentation/media/uapi/dvb/frontend_h.rst        |  9 ---
 .../media/uapi/dvb/frontend_legacy_dvbv3_api.rst   |  6 +-
 Documentation/media/uapi/dvb/headers.rst           | 21 ++++++
 Documentation/media/uapi/dvb/intro.rst             | 27 ++++----
 Documentation/media/uapi/dvb/legacy_dvb_apis.rst   |  6 +-
 Documentation/media/uapi/dvb/net-add-if.rst        | 10 ++-
 Documentation/media/uapi/dvb/net-get-if.rst        |  8 ++-
 Documentation/media/uapi/dvb/net-remove-if.rst     |  8 ++-
 Documentation/media/uapi/dvb/net.rst               | 13 ++--
 Documentation/media/uapi/dvb/net_h.rst             |  9 ---
 .../media/uapi/dvb/query-dvb-frontend-info.rst     |  4 +-
 Documentation/media/uapi/dvb/video-continue.rst    |  2 +-
 Documentation/media/uapi/dvb/video-freeze.rst      |  4 +-
 Documentation/media/uapi/dvb/video-get-event.rst   |  2 +-
 Documentation/media/uapi/dvb/video-play.rst        |  2 +-
 .../media/uapi/dvb/video-select-source.rst         |  2 +-
 Documentation/media/uapi/dvb/video-stop.rst        |  2 +-
 Documentation/media/uapi/dvb/video.rst             | 15 +++--
 Documentation/media/uapi/dvb/video_h.rst           |  9 ---
 Documentation/media/uapi/gen-errors.rst            | 49 +++++---------
 include/uapi/linux/dvb/frontend.h                  |  6 +-
 86 files changed, 630 insertions(+), 521 deletions(-)
 delete mode 100644 Documentation/media/uapi/dvb/audio_h.rst
 delete mode 100644 Documentation/media/uapi/dvb/ca_h.rst
 delete mode 100644 Documentation/media/uapi/dvb/dmx_h.rst
 delete mode 100644 Documentation/media/uapi/dvb/frontend_h.rst
 create mode 100644 Documentation/media/uapi/dvb/headers.rst
 delete mode 100644 Documentation/media/uapi/dvb/net_h.rst
 delete mode 100644 Documentation/media/uapi/dvb/video_h.rst

-- 
2.13.5
