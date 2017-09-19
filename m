Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:48707 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750918AbdISHpx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 03:45:53 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.15] cec: doc fixes, cec-gpio driver
Message-ID: <d42b869e-edbd-90eb-4879-2b0eda73a724@xs4all.nl>
Date: Tue, 19 Sep 2017 09:45:48 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds two CEC documentation fixes and the new cec-gpio driver.

Regards,

	Hans

The following changes since commit 9a45bf28bc39ff6ed45a008f7201289c8e9e60a6:

  media: max2175: Propagate the real error on devm_clk_get() failure (2017-08-27 18:14:11 -0400)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cec-gpio2

for you to fetch changes up to 66470c5d932cf8f0ff86121cfdbe03186a190de0:

  MAINTAINERS: add cec-gpio entry (2017-09-19 09:43:59 +0200)

----------------------------------------------------------------
Hans Verkuil (7):
      cec-ioc-dqevent.rst: fix typo
      cec-core.rst/cec-ioc-receive.rst: clarify CEC_TX_STATUS_ERROR
      cec: add CEC_EVENT_PIN_HPD_LOW/HIGH events
      cec-ioc-dqevent.rst: document new CEC_EVENT_PIN_HPD_LOW/HIGH events
      dt-bindings: document the CEC GPIO bindings
      cec-gpio: add HDMI CEC GPIO driver
      MAINTAINERS: add cec-gpio entry

 Documentation/devicetree/bindings/media/cec-gpio.txt |  32 +++++++
 Documentation/media/cec.h.rst.exceptions             |   2 -
 Documentation/media/kapi/cec-core.rst                |   7 +-
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst     |  22 ++++-
 Documentation/media/uapi/cec/cec-ioc-receive.rst     |  10 +-
 MAINTAINERS                                          |   9 ++
 drivers/media/cec/cec-adap.c                         |  18 +++-
 drivers/media/cec/cec-api.c                          |  18 +++-
 drivers/media/cec/cec-core.c                         |   8 +-
 drivers/media/platform/Kconfig                       |  10 ++
 drivers/media/platform/Makefile                      |   2 +
 drivers/media/platform/cec-gpio/Makefile             |   1 +
 drivers/media/platform/cec-gpio/cec-gpio.c           | 236 +++++++++++++++++++++++++++++++++++++++++++++++
 include/media/cec-pin.h                              |   4 +
 include/media/cec.h                                  |  12 ++-
 include/uapi/linux/cec.h                             |   2 +
 16 files changed, 372 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/cec-gpio.txt
 create mode 100644 drivers/media/platform/cec-gpio/Makefile
 create mode 100644 drivers/media/platform/cec-gpio/cec-gpio.c
