Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:56969 "EHLO smtp3-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbcHLOtG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2016 10:49:06 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jani Nikula <jani.nikula@intel.com>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/3] doc-rst: parseheaders directive
Date: Fri, 12 Aug 2016 16:48:41 +0200
Message-Id: <1471013324-18914-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

Hi Mauro, Jani,

this series imlpements a new directive ".. parseheaders::" as a replacement for
the media/Makefile, suggested by Jani [1].

The first patch adds a docutils.conf with "halt_level: severe". This first patch
is not needed for parseheaders, but I think stop make on build errors
(SEVERE-LEVEL) is somewhat we have been looked for.

My suggestion is, that you merge this and the *sphinx-sub-folder* patch in your
master and bring it to Jon, so that Jani can merge his PDF patch on top. I would
be great, to see these three patches in Jon's docs-next.

[1] http://www.spinics.net/lists/linux-media/msg104125.html

Thakns

  -- Markus--

Markus Heiser (3):
  doc-rst: add docutils config file
  doc-rst: parseheaders directive (inital)
  doc-rst: migrated media build to parseheaders directive

 Documentation/Makefile.sphinx                      |   1 -
 Documentation/conf.py                              |   2 +-
 Documentation/docutils.conf                        |   7 +
 Documentation/media/Makefile                       |  60 ---
 Documentation/media/audio.h.rst.exceptions         |  20 -
 Documentation/media/ca.h.rst.exceptions            |  24 -
 Documentation/media/cec.h.rst.exceptions           | 492 -------------------
 Documentation/media/dmx.h.rst.exceptions           |  63 ---
 Documentation/media/frontend.h.rst.exceptions      |  47 --
 Documentation/media/lirc.h.rst.exceptions          |  43 --
 Documentation/media/media.h.rst.exceptions         |  30 --
 Documentation/media/net.h.rst.exceptions           |  11 -
 Documentation/media/uapi/cec/cec-header.rst        |   4 +-
 Documentation/media/uapi/cec/cec.h.exceptions      | 492 +++++++++++++++++++
 Documentation/media/uapi/dvb/audio.h.exceptions    |  20 +
 Documentation/media/uapi/dvb/audio_h.rst           |   3 +-
 Documentation/media/uapi/dvb/ca.h.exceptions       |  24 +
 Documentation/media/uapi/dvb/ca_h.rst              |   3 +-
 Documentation/media/uapi/dvb/dmx.h.exceptions      |  63 +++
 Documentation/media/uapi/dvb/dmx_h.rst             |   3 +-
 Documentation/media/uapi/dvb/frontend.h.exceptions |  47 ++
 Documentation/media/uapi/dvb/frontend_h.rst        |   3 +-
 Documentation/media/uapi/dvb/net.h.exceptions      |  11 +
 Documentation/media/uapi/dvb/net_h.rst             |   3 +-
 Documentation/media/uapi/dvb/video.h.exceptions    |  40 ++
 Documentation/media/uapi/dvb/video_h.rst           |   3 +-
 Documentation/media/uapi/mediactl/media-header.rst |   4 +-
 .../media/uapi/mediactl/media.h.exceptions         |  30 ++
 Documentation/media/uapi/rc/lirc-header.rst        |   3 +-
 Documentation/media/uapi/rc/lirc.h.exceptions      |  43 ++
 Documentation/media/uapi/v4l/videodev.rst          |   3 +-
 .../media/uapi/v4l/videodev2.h.exceptions          | 535 +++++++++++++++++++++
 Documentation/media/video.h.rst.exceptions         |  40 --
 Documentation/media/videodev2.h.rst.exceptions     | 535 ---------------------
 Documentation/sphinx-static/theme_overrides.css    |   8 +
 Documentation/sphinx/parse-headers.pl              |  17 +-
 Documentation/sphinx/parseheaders.py               | 190 ++++++++
 37 files changed, 1538 insertions(+), 1389 deletions(-)
 create mode 100644 Documentation/docutils.conf
 delete mode 100644 Documentation/media/Makefile
 delete mode 100644 Documentation/media/audio.h.rst.exceptions
 delete mode 100644 Documentation/media/ca.h.rst.exceptions
 delete mode 100644 Documentation/media/cec.h.rst.exceptions
 delete mode 100644 Documentation/media/dmx.h.rst.exceptions
 delete mode 100644 Documentation/media/frontend.h.rst.exceptions
 delete mode 100644 Documentation/media/lirc.h.rst.exceptions
 delete mode 100644 Documentation/media/media.h.rst.exceptions
 delete mode 100644 Documentation/media/net.h.rst.exceptions
 create mode 100644 Documentation/media/uapi/cec/cec.h.exceptions
 create mode 100644 Documentation/media/uapi/dvb/audio.h.exceptions
 create mode 100644 Documentation/media/uapi/dvb/ca.h.exceptions
 create mode 100644 Documentation/media/uapi/dvb/dmx.h.exceptions
 create mode 100644 Documentation/media/uapi/dvb/frontend.h.exceptions
 create mode 100644 Documentation/media/uapi/dvb/net.h.exceptions
 create mode 100644 Documentation/media/uapi/dvb/video.h.exceptions
 create mode 100644 Documentation/media/uapi/mediactl/media.h.exceptions
 create mode 100644 Documentation/media/uapi/rc/lirc.h.exceptions
 create mode 100644 Documentation/media/uapi/v4l/videodev2.h.exceptions
 delete mode 100644 Documentation/media/video.h.rst.exceptions
 delete mode 100644 Documentation/media/videodev2.h.rst.exceptions
 create mode 100644 Documentation/sphinx/parseheaders.py

-- 
2.7.4

