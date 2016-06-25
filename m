Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:49821 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751244AbcFYNGn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jun 2016 09:06:43 -0400
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 4376A180241
	for <linux-media@vger.kernel.org>; Sat, 25 Jun 2016 15:06:38 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCHv19 00/14] HDMI CEC framework
Date: Sat, 25 Jun 2016 15:06:24 +0200
Message-Id: <1466859998-17640-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Since I missed a bunch of review comment I needed to do a v19 patch series.

This is against the media_tree cec branch, as requested by Mauro.

In this patch series the cec.c source is split into three separate sources:
core framework module handling, adapter messaging code and public API code
(file ops).

The diff between the media_tree cec branch and this series, but without
the cec.c split, is here:

https://patchwork.linuxtv.org/patch/34808/

This makes it easier to see the actual functional changes. Otherwise the
cec.c split would make that very hard,

Regards,

	Hans

Hans Verkuil (13):
  DocBook/media: add CEC documentation
  cec-edid: add module for EDID CEC helper functions
  cec.h: add cec header
  cec-funcs.h: static inlines to pack/unpack CEC messages
  cec: add HDMI CEC framework (core)
  cec: add HDMI CEC framework (adapter)
  cec: add HDMI CEC framework (api)
  cec/TODO: add TODO file so we know why this is still in staging
  cec: add compat32 ioctl support
  cec: adv7604: add cec support.
  cec: adv7842: add cec support
  cec: adv7511: add cec support.
  vivid: add CEC emulation

Kamil Debski (1):
  cec: s5p-cec: Add s5p-cec driver

 Documentation/DocBook/device-drivers.tmpl          |    3 +
 Documentation/DocBook/media/Makefile               |    2 +
 Documentation/DocBook/media/v4l/biblio.xml         |   10 +
 Documentation/DocBook/media/v4l/cec-api.xml        |   75 +
 Documentation/DocBook/media/v4l/cec-func-close.xml |   64 +
 Documentation/DocBook/media/v4l/cec-func-ioctl.xml |   78 +
 Documentation/DocBook/media/v4l/cec-func-open.xml  |  104 ++
 Documentation/DocBook/media/v4l/cec-func-poll.xml  |   94 +
 .../DocBook/media/v4l/cec-ioc-adap-g-caps.xml      |  151 ++
 .../DocBook/media/v4l/cec-ioc-adap-g-log-addrs.xml |  329 ++++
 .../DocBook/media/v4l/cec-ioc-adap-g-phys-addr.xml |   86 +
 .../DocBook/media/v4l/cec-ioc-dqevent.xml          |  202 +++
 Documentation/DocBook/media/v4l/cec-ioc-g-mode.xml |  255 +++
 .../DocBook/media/v4l/cec-ioc-receive.xml          |  274 +++
 Documentation/DocBook/media_api.tmpl               |    6 +-
 .../devicetree/bindings/media/s5p-cec.txt          |   31 +
 Documentation/video4linux/vivid.txt                |   36 +-
 MAINTAINERS                                        |   23 +
 drivers/media/Kconfig                              |    3 +
 drivers/media/Makefile                             |    2 +
 drivers/media/cec-edid.c                           |  168 ++
 drivers/media/i2c/Kconfig                          |   24 +
 drivers/media/i2c/adv7511.c                        |  401 ++++-
 drivers/media/i2c/adv7604.c                        |  332 +++-
 drivers/media/i2c/adv7842.c                        |  368 +++-
 drivers/media/platform/Kconfig                     |   10 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/s5p-cec/Makefile            |    2 +
 drivers/media/platform/s5p-cec/exynos_hdmi_cec.h   |   38 +
 .../media/platform/s5p-cec/exynos_hdmi_cecctrl.c   |  209 +++
 drivers/media/platform/s5p-cec/regs-cec.h          |   96 +
 drivers/media/platform/s5p-cec/s5p_cec.c           |  295 +++
 drivers/media/platform/s5p-cec/s5p_cec.h           |   76 +
 drivers/media/platform/vivid/Kconfig               |    8 +
 drivers/media/platform/vivid/Makefile              |    4 +
 drivers/media/platform/vivid/vivid-cec.c           |  255 +++
 drivers/media/platform/vivid/vivid-cec.h           |   33 +
 drivers/media/platform/vivid/vivid-core.c          |  118 +-
 drivers/media/platform/vivid/vivid-core.h          |   27 +
 drivers/media/platform/vivid/vivid-kthread-cap.c   |   13 +
 drivers/media/platform/vivid/vivid-vid-cap.c       |   23 +-
 drivers/media/platform/vivid/vivid-vid-common.c    |    7 +
 drivers/staging/media/Kconfig                      |    2 +
 drivers/staging/media/Makefile                     |    1 +
 drivers/staging/media/cec/Kconfig                  |   14 +
 drivers/staging/media/cec/Makefile                 |    3 +
 drivers/staging/media/cec/TODO                     |   27 +
 drivers/staging/media/cec/cec-adap.c               | 1627 +++++++++++++++++
 drivers/staging/media/cec/cec-api.c                |  578 ++++++
 drivers/staging/media/cec/cec-core.c               |  409 +++++
 drivers/staging/media/cec/cec-priv.h               |   56 +
 fs/compat_ioctl.c                                  |   12 +
 include/linux/cec-funcs.h                          | 1881 ++++++++++++++++++++
 include/linux/cec.h                                |  993 +++++++++++
 include/media/cec-edid.h                           |  104 ++
 include/media/cec.h                                |  232 +++
 include/media/i2c/adv7511.h                        |    6 +-
 57 files changed, 10153 insertions(+), 128 deletions(-)
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
 create mode 100644 drivers/staging/media/cec/Kconfig
 create mode 100644 drivers/staging/media/cec/Makefile
 create mode 100644 drivers/staging/media/cec/TODO
 create mode 100644 drivers/staging/media/cec/cec-adap.c
 create mode 100644 drivers/staging/media/cec/cec-api.c
 create mode 100644 drivers/staging/media/cec/cec-core.c
 create mode 100644 drivers/staging/media/cec/cec-priv.h
 create mode 100644 include/linux/cec-funcs.h
 create mode 100644 include/linux/cec.h
 create mode 100644 include/media/cec-edid.h
 create mode 100644 include/media/cec.h

-- 
2.8.1

