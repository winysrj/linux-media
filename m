Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:49573 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751293AbcEaPZB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2016 11:25:01 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 77751180160
	for <linux-media@vger.kernel.org>; Tue, 31 May 2016 17:24:55 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8 v3] Add HDMI CEC framework
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <574DACC7.60502@xs4all.nl>
Date: Tue, 31 May 2016 17:24:55 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here is the pull request for the HDMI CEC framework. The code of this pull
request is identical to the v16 patch series:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg97057.html

plus these fixes:

https://patchwork.linuxtv.org/patch/34262/
https://patchwork.linuxtv.org/patch/34263/
https://patchwork.linuxtv.org/patch/34264/
https://patchwork.linuxtv.org/patch/34466/

and rebased to the latest media_tree master.

(I've marked my previous pull request as Superseded).

The cec DocBook documentation is here:

https://hverkuil.home.xs4all.nl/cec.html#cec

The cec utilities are here:

http://git.linuxtv.org/hverkuil/v4l-utils.git/log/?h=cec

To test with real hardware the easiest is to use a pandaboard. I posted
RFC patches for that here:

http://www.spinics.net/lists/linux-media/msg100046.html

Regards,

	Hans

The following changes since commit 6a2cf60b3e6341a3163d3cac3f4bede126c2e894:

  Merge tag 'v4.7-rc1' into patchwork (2016-05-30 18:16:14 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cec

for you to fetch changes up to e0f92239e0019de151b6c9ab2cbbc4b8435d9322:

  vivid: add CEC emulation (2016-05-31 17:18:39 +0200)

----------------------------------------------------------------
Hans Verkuil (10):
      input.h: add BUS_CEC type
      cec: add HDMI CEC framework
      cec/TODO: add TODO file so we know why this is still in staging
      cec: add compat32 ioctl support
      cec.txt: add CEC framework documentation
      DocBook/media: add CEC documentation
      cec: adv7604: add cec support.
      cec: adv7842: add cec support
      cec: adv7511: add cec support.
      vivid: add CEC emulation

Kamil Debski (3):
      HID: add HDMI CEC specific keycodes
      rc: Add HDMI CEC protocol handling
      cec: s5p-cec: Add s5p-cec driver

 Documentation/DocBook/device-drivers.tmpl                    |    4 +
 Documentation/DocBook/media/Makefile                         |    2 +
 Documentation/DocBook/media/v4l/biblio.xml                   |   10 +
 Documentation/DocBook/media/v4l/cec-api.xml                  |   72 ++
 Documentation/DocBook/media/v4l/cec-func-close.xml           |   59 ++
 Documentation/DocBook/media/v4l/cec-func-ioctl.xml           |   73 ++
 Documentation/DocBook/media/v4l/cec-func-open.xml            |   94 ++
 Documentation/DocBook/media/v4l/cec-func-poll.xml            |   89 ++
 Documentation/DocBook/media/v4l/cec-ioc-adap-g-caps.xml      |  140 +++
 Documentation/DocBook/media/v4l/cec-ioc-adap-g-log-addrs.xml |  324 ++++++
 Documentation/DocBook/media/v4l/cec-ioc-adap-g-phys-addr.xml |   82 ++
 Documentation/DocBook/media/v4l/cec-ioc-dqevent.xml          |  190 ++++
 Documentation/DocBook/media/v4l/cec-ioc-g-mode.xml           |  245 +++++
 Documentation/DocBook/media/v4l/cec-ioc-receive.xml          |  260 +++++
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
 drivers/media/platform/vivid/vivid-cec.c                     |  254 +++++
 drivers/media/platform/vivid/vivid-cec.h                     |   33 +
 drivers/media/platform/vivid/vivid-core.c                    |  119 ++-
 drivers/media/platform/vivid/vivid-core.h                    |   27 +
 drivers/media/platform/vivid/vivid-kthread-cap.c             |   11 +
 drivers/media/platform/vivid/vivid-vid-cap.c                 |   23 +-
 drivers/media/platform/vivid/vivid-vid-common.c              |    7 +
 drivers/media/rc/keymaps/Makefile                            |    1 +
 drivers/media/rc/keymaps/rc-cec.c                            |  174 +++
 drivers/media/rc/rc-main.c                                   |    1 +
 drivers/staging/media/Kconfig                                |    2 +
 drivers/staging/media/Makefile                               |    1 +
 drivers/staging/media/cec/Kconfig                            |    8 +
 drivers/staging/media/cec/Makefile                           |    1 +
 drivers/staging/media/cec/TODO                               |   13 +
 drivers/staging/media/cec/cec.c                              | 2500 ++++++++++++++++++++++++++++++++++++++++++++
 fs/compat_ioctl.c                                            |   12 +
 include/linux/cec-funcs.h                                    | 1871 +++++++++++++++++++++++++++++++++
 include/linux/cec.h                                          |  985 +++++++++++++++++
 include/media/cec-edid.h                                     |  103 ++
 include/media/cec.h                                          |  236 +++++
 include/media/i2c/adv7511.h                                  |    6 +-
 include/media/rc-map.h                                       |    5 +-
 include/uapi/linux/input-event-codes.h                       |   30 +
 include/uapi/linux/input.h                                   |    1 +
 61 files changed, 10315 insertions(+), 129 deletions(-)
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
