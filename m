Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:38470 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751202AbcJFHUp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Oct 2016 03:20:45 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jani Nikula <jani.nikula@intel.com>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: [PATCH 0/4] reST-directive kernel-cmd / include contentent from scripts
Date: Thu,  6 Oct 2016 09:20:16 +0200
Message-Id: <1475738420-8747-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

Hi Jon, Mauro, and Jani,

with this series a reST-directive kernel-cmd is introduced. The kernel-cmd
directive includes contend from the stdout of a command-line (@mchehab asked
for).

Including content from a command's stdout is a more general solution for other
workarounds like the "kernel_include + parseheaders" solution. This series also
migrates the kernel-include uses to kernel-cmd directives and drops the Makefile
in the media sub-folder. With the last patch, the (no longer needed)
kernel-include directive is removed.

-- Markus --

Markus Heiser (4):
  doc-rst: reST-directive kernel-cmd / include contentent from scripts
  doc-rst: customize RTD theme; literal-block
  doc-rst: migrated media build kernel-cmd directive
  doc-rst: remove the kernel-include directive

 Documentation/Makefile.sphinx                      |   4 +-
 Documentation/conf.py                              |   2 +-
 Documentation/media/Makefile                       |  61 ---
 Documentation/media/audio.h.rst.exceptions         |  20 -
 Documentation/media/ca.h.rst.exceptions            |  24 -
 Documentation/media/cec.h.rst.exceptions           | 492 -------------------
 Documentation/media/dmx.h.rst.exceptions           |  63 ---
 Documentation/media/frontend.h.rst.exceptions      |  47 --
 Documentation/media/lirc.h.rst.exceptions          |  43 --
 Documentation/media/media.h.rst.exceptions         |  30 --
 Documentation/media/net.h.rst.exceptions           |  11 -
 Documentation/media/uapi/cec/cec-header.rst        |   3 +-
 Documentation/media/uapi/cec/cec.h.exceptions      | 492 +++++++++++++++++++
 Documentation/media/uapi/dvb/audio.h.exceptions    |  20 +
 Documentation/media/uapi/dvb/audio_h.rst           |   2 +-
 Documentation/media/uapi/dvb/ca.h.exceptions       |  24 +
 Documentation/media/uapi/dvb/ca_h.rst              |   2 +-
 Documentation/media/uapi/dvb/dmx.h.exceptions      |  63 +++
 Documentation/media/uapi/dvb/dmx_h.rst             |   2 +-
 Documentation/media/uapi/dvb/frontend.h.exceptions |  47 ++
 Documentation/media/uapi/dvb/frontend_h.rst        |   2 +-
 Documentation/media/uapi/dvb/net.h.exceptions      |  11 +
 Documentation/media/uapi/dvb/net_h.rst             |   2 +-
 Documentation/media/uapi/dvb/video.h.exceptions    |  40 ++
 Documentation/media/uapi/dvb/video_h.rst           |   2 +-
 Documentation/media/uapi/mediactl/media-header.rst |   3 +-
 .../media/uapi/mediactl/media.h.exceptions         |  30 ++
 Documentation/media/uapi/rc/lirc-header.rst        |   2 +-
 Documentation/media/uapi/rc/lirc.h.exceptions      |  43 ++
 Documentation/media/uapi/v4l/videodev.rst          |   2 +-
 .../media/uapi/v4l/videodev2.h.exceptions          | 535 +++++++++++++++++++++
 Documentation/media/video.h.rst.exceptions         |  40 --
 Documentation/media/videodev2.h.rst.exceptions     | 535 ---------------------
 Documentation/sphinx-static/theme_overrides.css    |   7 +
 Documentation/sphinx/kernel_cmd.py                 | 206 ++++++++
 Documentation/sphinx/kernel_include.py             | 190 --------
 Documentation/sphinx/parse-headers.pl              |  17 +-
 37 files changed, 1538 insertions(+), 1581 deletions(-)
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
 create mode 100644 Documentation/sphinx/kernel_cmd.py
 delete mode 100755 Documentation/sphinx/kernel_include.py

-- 
2.7.4

