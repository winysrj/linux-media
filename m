Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51338 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbbE1Vto (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:49:44 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 00/35] Improve DVB frontend API documentation
Date: Thu, 28 May 2015 18:49:03 -0300
Message-Id: <cover.1432844837.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the first series of patches that will improve the DVB
documentation.

Our DocBook was a conversion from a past LaTex documentation that
had some parts updated to cover what's there at DVBv5 API and got
merged with V4L2, media controller and remote controllers documentation
to provide a consistent document about the media infrastructure API.

Yet, it doesn't follow the same format as other parts of the document.

This patch series rewrite lots of code inside the DVB frontend API
documentation (with is the biggest chapter). It also moves the DVBv3
legacy stuff into a separate xml file, after the non-legacy stuff.

This should hopefully make clearer to the readers what's the
recommended ioctls and what's deprecated.

This work is not complete yet: there are still some structures that
are docummented on both frontend.xml and dvbproperty.xml, but, as we
have already 35 patches, let me flush what I have so far.

Mauro Carvalho Chehab (35):
  DocBook: Update DVB supported standards at introduction
  DocBook: add a note about the ALSA API
  DocBook: add drawing with a typical media device
  DocBook: fix emphasis at the DVB documentation
  DocBook: Improve DVB frontend description
  DocBook: move DVBv3 frontend bits to a separate section
  dvb: split enum from typedefs at frontend.h
  DocBook: reformat FE_GET_INFO ioctl documentation
  DocBook: move FE_GET_INFO to a separate xml file
  DocBook: improve documentation for FE_READ_STATUS
  DocBook: move DVB properties to happen earlier at the document
  DocBook: rewrite FE_GET_PROPERTY/FE_SET_PROPERTY to use the std way
  DocBook: fix xref to the FE open() function
  DocBook: Merge FE_SET_PROPERTY/FE_GET_PROPERTY ioctl description
  DocBook: Improve the description of the properties API
  DocBook: Add xref links for DTV propeties
  DocBook: Improve xref check for undocumented ioctls
  DocBook: remove duplicated ioctl from v4l2-subdev
  DocBook: Fix false positive undefined ioctl references
  DocBook: Rename ioctl xml files
  DocBook: move FE_GET_PROPERTY to its own xml file
  DocBook: reformat FE_SET_FRONTEND_TUNE_MODE ioctl
  DocBook: reformat FE_ENABLE_HIGH_LNB_VOLTAGE ioctl
  DocBook: better document FE_SET_VOLTAGE ioctl
  DocBook: better document FE_SET_TONE ioctl
  DocBook: better document FE_DISEQC_SEND_BURST ioctl
  DocBook: better document FE_DISEQC_RECV_SLAVE_REPLY
  DocBook: better document FE_DISEQC_SEND_MASTER_CMD
  DocBook: better document FE_DISEQC_RESET_OVERLOAD
  DocBook: better organize the function descriptions for frontend
  DocBook: fix FE_READ_STATUS argument description
  DocBook: Provide a high-level description for DVB frontend
  DocBook: add a proper description for dvb_frontend_info.fe_type
  DocBook: Better document enum fe_modulation
  DocBook: some fixes at FE_GET_INFO

 Documentation/DocBook/media/Makefile               |   33 +-
 Documentation/DocBook/media/dvb/audio.xml          |    6 +-
 Documentation/DocBook/media/dvb/ca.xml             |    4 +-
 Documentation/DocBook/media/dvb/demux.xml          |   10 +-
 Documentation/DocBook/media/dvb/dvbproperty.xml    |  227 ++--
 .../media/dvb/fe-diseqc-recv-slave-reply.xml       |   78 ++
 .../DocBook/media/dvb/fe-diseqc-reset-overload.xml |   51 +
 .../DocBook/media/dvb/fe-diseqc-send-burst.xml     |   86 ++
 .../media/dvb/fe-diseqc-send-master-cmd.xml        |   72 ++
 .../media/dvb/fe-enable-high-lnb-voltage.xml       |   61 +
 Documentation/DocBook/media/dvb/fe-get-info.xml    |  266 ++++
 .../DocBook/media/dvb/fe-get-property.xml          |   81 ++
 Documentation/DocBook/media/dvb/fe-read-status.xml |  107 ++
 .../media/dvb/fe-set-frontend-tune-mode.xml        |   64 +
 Documentation/DocBook/media/dvb/fe-set-tone.xml    |   88 ++
 Documentation/DocBook/media/dvb/fe-set-voltage.xml |   94 ++
 Documentation/DocBook/media/dvb/frontend.xml       | 1351 +-------------------
 .../DocBook/media/dvb/frontend_legacy_api.xml      |  613 +++++++++
 Documentation/DocBook/media/dvb/intro.xml          |   26 +-
 Documentation/DocBook/media/dvb/kdapi.xml          |    4 +-
 Documentation/DocBook/media/dvb/net.xml            |    4 +-
 Documentation/DocBook/media/dvb/video.xml          |   10 +-
 .../DocBook/media/typical_media_device.svg         |   28 +
 .../DocBook/media/v4l/vidioc-g-dv-timings.xml      |    4 +-
 Documentation/DocBook/media/v4l/vidioc-g-edid.xml  |    4 +-
 .../DocBook/media/v4l/vidioc-query-dv-timings.xml  |    3 +-
 .../DocBook/media/v4l/vidioc-subscribe-event.xml   |    3 +-
 Documentation/DocBook/media_api.tmpl               |   25 +-
 include/uapi/linux/dvb/frontend.h                  |   36 +-
 29 files changed, 1974 insertions(+), 1465 deletions(-)
 create mode 100644 Documentation/DocBook/media/dvb/fe-diseqc-recv-slave-reply.xml
 create mode 100644 Documentation/DocBook/media/dvb/fe-diseqc-reset-overload.xml
 create mode 100644 Documentation/DocBook/media/dvb/fe-diseqc-send-burst.xml
 create mode 100644 Documentation/DocBook/media/dvb/fe-diseqc-send-master-cmd.xml
 create mode 100644 Documentation/DocBook/media/dvb/fe-enable-high-lnb-voltage.xml
 create mode 100644 Documentation/DocBook/media/dvb/fe-get-info.xml
 create mode 100644 Documentation/DocBook/media/dvb/fe-get-property.xml
 create mode 100644 Documentation/DocBook/media/dvb/fe-read-status.xml
 create mode 100644 Documentation/DocBook/media/dvb/fe-set-frontend-tune-mode.xml
 create mode 100644 Documentation/DocBook/media/dvb/fe-set-tone.xml
 create mode 100644 Documentation/DocBook/media/dvb/fe-set-voltage.xml
 create mode 100644 Documentation/DocBook/media/dvb/frontend_legacy_api.xml
 create mode 100644 Documentation/DocBook/media/typical_media_device.svg

-- 
2.4.1

