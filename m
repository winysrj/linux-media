Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:43096 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751277AbdGQIOc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 04:14:32 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.14] CEC patches
Message-ID: <8cef1fc3-6f55-3fbf-77d2-af0f10541cd2@xs4all.nl>
Date: Mon, 17 Jul 2017 10:14:30 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patch series adds a bunch of little improvements but most importantly
it adds the low-level CEC pin support for hardware that just polls/drives the
CEC pin and needs software to handle the low-level CEC bus protocol.

This will be used by the AllWinner A10 drm driver:

	https://patchwork.linuxtv.org/patch/42411/

That driver will be merged for 4.14 via the drm subsystem.

It will also be used by the upcoming cec-gpio driver:

	https://patchwork.linuxtv.org/patch/42213/

But that isn't ready yet. It may or may not be finished in time for 4.14, we'll see.

This low-level CEC pin support code will also be used in the future to
implement error injection of the CEC bus, but the API for that needs to be
reworked quite a bit.

Regards,

	Hans

The following changes since commit 2748e76ddb2967c4030171342ebdd3faa6a5e8e8:

  media: staging: cxd2099: Activate cxd2099 buffer mode (2017-06-26 08:19:13 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cec

for you to fetch changes up to b966b609a0f48f7a9bccd0d4db6b4d0b1d13c285:

  pulse8-cec/rainshadow-cec: make adapter name unique (2017-07-17 09:36:01 +0200)

----------------------------------------------------------------
Hans Verkuil (17):
      cec: clear all cec_log_addrs fields
      cec: only increase the seqnr if CEC_TRANSMIT would return 0
      cec: improve transmit timeout logging
      cec: add *_ts variants for transmit_done/received_msg
      cec: add adap_free op
      cec-core.rst: document the adap_free callback
      linux/cec.h: add pin monitoring API support
      cec: rework the cec event handling
      cec: document the new CEC pin capability, events and mode
      cec: add core support for low-level CEC pin monitoring
      cec-pin: add low-level pin hardware support
      cec-core.rst: include cec-pin.h and cec-notifier.h
      cec: be smarter about detecting the number of attempts made
      pulse8-cec.rst: add documentation for the pulse8-cec driver
      cec: move cec_register_cec_notifier to cec-notifier.h
      cec: drop senseless message
      pulse8-cec/rainshadow-cec: make adapter name unique

 Documentation/media/cec-drivers/index.rst                 |  32 ++
 Documentation/media/cec-drivers/pulse8-cec.rst            |  11 +
 Documentation/media/index.rst                             |   1 +
 Documentation/media/kapi/cec-core.rst                     |  40 +++
 Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst      |   7 +
 Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst |   4 +-
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst          |  20 ++
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst           |  19 +-
 MAINTAINERS                                               |   1 +
 drivers/media/Kconfig                                     |   3 +
 drivers/media/cec/Makefile                                |   4 +
 drivers/media/cec/cec-adap.c                              | 223 ++++++++-----
 drivers/media/cec/cec-api.c                               |  73 ++++-
 drivers/media/cec/cec-core.c                              |   7 +-
 drivers/media/cec/cec-pin.c                               | 794 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/usb/pulse8-cec/pulse8-cec.c                 |   2 +-
 drivers/media/usb/rainshadow-cec/rainshadow-cec.c         |   2 +-
 include/media/cec-notifier.h                              |  12 +
 include/media/cec-pin.h                                   | 183 +++++++++++
 include/media/cec.h                                       |  69 +++-
 include/uapi/linux/cec.h                                  |   8 +-
 21 files changed, 1400 insertions(+), 115 deletions(-)
 create mode 100644 Documentation/media/cec-drivers/index.rst
 create mode 100644 Documentation/media/cec-drivers/pulse8-cec.rst
 create mode 100644 drivers/media/cec/cec-pin.c
 create mode 100644 include/media/cec-pin.h
