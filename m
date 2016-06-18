Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:33011 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750879AbcFRM2j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2016 08:28:39 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id A7FB61800D7
	for <linux-media@vger.kernel.org>; Sat, 18 Jun 2016 14:28:34 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8 v4] Add HDMI CEC framework
Message-ID: <57653E72.7070500@xs4all.nl>
Date: Sat, 18 Jun 2016 14:28:34 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here is the pull request for the HDMI CEC framework. The code of this pull
request is identical to the v17 patch series.

The cec DocBook documentation is here:

https://hverkuil.home.xs4all.nl/cec.html#cec

The latest cec utilities are here:

http://git.linuxtv.org/hverkuil/v4l-utils.git/log/?h=cec-johan

Regards,

	Hans

The following changes since commit 0db5c79989de2c68d5abb7ba891bfdb3cd3b7e05:

  [media] media-devnode.h: Fix documentation (2016-06-16 08:14:56 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cec17

for you to fetch changes up to b632db2b7979e1d4d52d964a2dd82384b5ed0b2e:

  vivid: add CEC emulation (2016-06-18 13:59:27 +0200)

----------------------------------------------------------------
Hans Verkuil (13):
      input.h: add BUS_CEC type
      cec.txt: add CEC framework documentation
      DocBook/media: add CEC documentation
      cec-edid: add module for EDID CEC helper functions
      cec.h: add cec header
      cec-funcs.h: static inlines to pack/unpack CEC messages
      cec: add HDMI CEC framework
      cec/TODO: add TODO file so we know why this is still in staging
      cec: add compat32 ioctl support
      cec: adv7604: add cec support.
      cec: adv7842: add cec support
      cec: adv7511: add cec support.
      vivid: add CEC emulation

Kamil Debski (3):
      HID: add HDMI CEC specific keycodes
      rc: Add HDMI CEC protocol handling
      cec: s5p-cec: Add s5p-cec driver

 Documentation/DocBook/device-drivers.tmpl                    |    3 +
 Documentation/DocBook/media/Makefile                         |    2 +
 Documentation/DocBook/media/v4l/biblio.xml                   |   10 +
 Documentation/DocBook/media/v4l/cec-api.xml                  |   75 ++
 Documentation/DocBook/media/v4l/cec-func-close.xml           |   64 ++
 Documentation/DocBook/media/v4l/cec-func-ioctl.xml           |   78 ++
 Documentation/DocBook/media/v4l/cec-func-open.xml            |  104 ++
 Documentation/DocBook/media/v4l/cec-func-poll.xml            |   94 ++
 Documentation/DocBook/media/v4l/cec-ioc-adap-g-caps.xml      |  151 +++
 Documentation/DocBook/media/v4l/cec-ioc-adap-g-log-addrs.xml |  329 ++++++
 Documentation/DocBook/media/v4l/cec-ioc-adap-g-phys-addr.xml |   86 ++
 Documentation/DocBook/media/v4l/cec-ioc-dqevent.xml          |  195 ++++
 Documentation/DocBook/media/v4l/cec-ioc-g-mode.xml           |  255 +++++
 Documentation/DocBook/media/v4l/cec-ioc-receive.xml          |  265 +++++
 Documentation/DocBook/media_api.tmpl                         |    6 +-
 Documentation/cec.txt                                        |  267 +++++
 Documentation/devicetree/bindings/media/s5p-cec.txt          |   31 +
 Documentation/video4linux/vivid.txt                          |   36 +-
 MAINTAINERS                                                  |   23 +
 drivers/media/Kconfig                                        |    3 +
 drivers/media/Makefile                                       |    2 +
 drivers/media/cec-edid.c                                     |  139 +++
 drivers/media/i2c/Kconfig                                    |   27 +
 drivers/media/i2c/adv7511.c                                  |  401 ++++++-
 drivers/media/i2c/adv7604.c                                  |  332 +++++-
 drivers/media/i2c/adv7842.c                                  |  368 +++++--
 drivers/media/platform/Kconfig                               |   11 +
 drivers/media/platform/Makefile                              |    1 +
 drivers/media/platform/s5p-cec/Makefile                      |    2 +
 drivers/media/platform/s5p-cec/exynos_hdmi_cec.h             |   38 +
 drivers/media/platform/s5p-cec/exynos_hdmi_cecctrl.c         |  209 ++++
 drivers/media/platform/s5p-cec/regs-cec.h                    |   96 ++
 drivers/media/platform/s5p-cec/s5p_cec.c                     |  295 ++++++
 drivers/media/platform/s5p-cec/s5p_cec.h                     |   76 ++
 drivers/media/platform/vivid/Kconfig                         |    9 +
 drivers/media/platform/vivid/Makefile                        |    4 +
 drivers/media/platform/vivid/vivid-cec.c                     |  255 +++++
 drivers/media/platform/vivid/vivid-cec.h                     |   33 +
 drivers/media/platform/vivid/vivid-core.c                    |  118 ++-
 drivers/media/platform/vivid/vivid-core.h                    |   27 +
 drivers/media/platform/vivid/vivid-kthread-cap.c             |   13 +
 drivers/media/platform/vivid/vivid-vid-cap.c                 |   23 +-
 drivers/media/platform/vivid/vivid-vid-common.c              |    7 +
 drivers/media/rc/keymaps/Makefile                            |    1 +
 drivers/media/rc/keymaps/rc-cec.c                            |  182 ++++
 drivers/media/rc/rc-main.c                                   |    1 +
 drivers/staging/media/Kconfig                                |    2 +
 drivers/staging/media/Makefile                               |    1 +
 drivers/staging/media/cec/Kconfig                            |    8 +
 drivers/staging/media/cec/Makefile                           |    1 +
 drivers/staging/media/cec/TODO                               |   23 +
 drivers/staging/media/cec/cec.c                              | 2512 ++++++++++++++++++++++++++++++++++++++++++++
 fs/compat_ioctl.c                                            |   12 +
 include/linux/cec-funcs.h                                    | 1875 +++++++++++++++++++++++++++++++++
 include/linux/cec.h                                          |  987 +++++++++++++++++
 include/media/cec-edid.h                                     |  104 ++
 include/media/cec.h                                          |  236 +++++
 include/media/i2c/adv7511.h                                  |    6 +-
 include/media/rc-map.h                                       |    5 +-
 include/uapi/linux/input-event-codes.h                       |   31 +
 include/uapi/linux/input.h                                   |    1 +
 61 files changed, 10422 insertions(+), 129 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/cec-api.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-func-close.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-func-ioctl.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-func-open.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-func-poll.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-adap-g-caps.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-adap-g-log-addrs.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-adap-g-phys-addr.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-dqevent.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-mode.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-receive.xml
 create mode 100644 Documentation/cec.txt
 create mode 100644 Documentation/devicetree/bindings/media/s5p-cec.txt
 create mode 100644 drivers/media/cec-edid.c
 create mode 100644 drivers/media/platform/s5p-cec/Makefile
 create mode 100644 drivers/media/platform/s5p-cec/exynos_hdmi_cec.h
 create mode 100644 drivers/media/platform/s5p-cec/exynos_hdmi_cecctrl.c
 create mode 100644 drivers/media/platform/s5p-cec/regs-cec.h
 create mode 100644 drivers/media/platform/s5p-cec/s5p_cec.c
 create mode 100644 drivers/media/platform/s5p-cec/s5p_cec.h
 create mode 100644 drivers/media/platform/vivid/vivid-cec.c
 create mode 100644 drivers/media/platform/vivid/vivid-cec.h
 create mode 100644 drivers/media/rc/keymaps/rc-cec.c
 create mode 100644 drivers/staging/media/cec/Kconfig
 create mode 100644 drivers/staging/media/cec/Makefile
 create mode 100644 drivers/staging/media/cec/TODO
 create mode 100644 drivers/staging/media/cec/cec.c
 create mode 100644 include/linux/cec-funcs.h
 create mode 100644 include/linux/cec.h
 create mode 100644 include/media/cec-edid.h
 create mode 100644 include/media/cec.h
