Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:58013 "EHLO smtp3-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbcHMONc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Aug 2016 10:13:32 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jani Nikula <jani.nikula@intel.com>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH 0/7] doc-rst: sphinx sub-folders & parseheaders directive
Date: Sat, 13 Aug 2016 16:12:41 +0200
Message-Id: <1471097568-25990-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

Hi Jon, Mauro, and Jani,

this series is a consolidation on Jon's docs-next branch. It merges the "sphinx
sub-folders" patch [1] and the "parseheaders directive" patch [2] on top of
Jon's docs-next.

In sense of consolidation, it also includes:

*  doc-rst: add media/conf_nitpick.py

   Adds media/conf_nitpick.py from mchehab/docs-next [3].

*  doc-rst: migrated media build to parseheaders directive

   Remove the media-Makefile and migrate the ".. kernel-include::"
   directive to the new ".. parse-header::" directive.

[1] https://www.mail-archive.com/linux-media@vger.kernel.org/msg101050.html
[2] https://www.mail-archive.com/linux-media@vger.kernel.org/msg101242.html
[3] git.linuxtv.org/mchehab/experimental.git

Thanks,

-- Markus --

Markus Heiser (7):
  doc-rst: generic way to build only sphinx sub-folders
  doc-rst: add stand-alone conf.py to media folder
  doc-rst: add media/conf_nitpick.py
  doc-rst: add stand-alone conf.py to gpu folder
  doc-rst: add docutils config file
  doc-rst: parseheaders directive (inital)
  doc-rst: migrated media build to parseheaders directive

 Documentation/DocBook/Makefile                     |   7 +
 Documentation/Makefile.sphinx                      |  43 +-
 Documentation/conf.py                              |   9 +-
 Documentation/docutils.conf                        |   7 +
 Documentation/gpu/conf.py                          |   3 +
 Documentation/index.rst                            |   7 +-
 Documentation/media/Makefile                       |  61 ---
 Documentation/media/audio.h.rst.exceptions         |  20 -
 Documentation/media/ca.h.rst.exceptions            |  24 -
 Documentation/media/cec.h.rst.exceptions           | 492 -------------------
 Documentation/media/conf.py                        |   3 +
 Documentation/media/conf_nitpick.py                |  93 ++++
 Documentation/media/dmx.h.rst.exceptions           |  63 ---
 Documentation/media/frontend.h.rst.exceptions      |  47 --
 Documentation/media/index.rst                      |  12 +
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
 Documentation/sphinx/load_config.py                |  33 ++
 Documentation/sphinx/parse-headers.pl              |  17 +-
 Documentation/sphinx/parseheaders.py               | 190 ++++++++
 44 files changed, 1733 insertions(+), 1402 deletions(-)
 create mode 100644 Documentation/docutils.conf
 create mode 100644 Documentation/gpu/conf.py
 delete mode 100644 Documentation/media/Makefile
 delete mode 100644 Documentation/media/audio.h.rst.exceptions
 delete mode 100644 Documentation/media/ca.h.rst.exceptions
 delete mode 100644 Documentation/media/cec.h.rst.exceptions
 create mode 100644 Documentation/media/conf.py
 create mode 100644 Documentation/media/conf_nitpick.py
 delete mode 100644 Documentation/media/dmx.h.rst.exceptions
 delete mode 100644 Documentation/media/frontend.h.rst.exceptions
 create mode 100644 Documentation/media/index.rst
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
 create mode 100644 Documentation/sphinx/load_config.py
 create mode 100644 Documentation/sphinx/parseheaders.py

-- 
2.7.4

