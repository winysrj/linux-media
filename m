Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:59964 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753028AbcKBMqi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Nov 2016 08:46:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 00/11] cec/pulse8-cec: move out of staging
Date: Wed,  2 Nov 2016 13:46:24 +0100
Message-Id: <20161102124635.11989-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series makes the final changes so that the cec framework
and the pulse8-cec driver can be moved out of staging.

The first patch fixes a pulse8-cec bug, the second removes the
spurious 'row' comments in the cec documentation using Laurent's script
(Thanks Laurent!).

The next patch adds a flag to enable the passthrough of remote control
keys to the rc subsystem. This is a userspace change since until now this
was always on. I decided that it is safer that this is enabled via an
opt-in flag so the caller can think about whether this is really what
they want.

Patch four adds a new flag that can force replies to a CEC_TRANSMIT to
be sent to followers as well. Depending on how the application is set
up this flag may be needed.

The fifth patch implements filtering for erroneous messages: messages
that are too short, or have the wrong transmit mode (broadcast where
directed is needed or vice versa) are ignored. This is only done for
the CEC messages specified in the spec, unknown messages are passed
on. This filtering is required by the CEC specification.

The next patch handles a corner case where one message can have two
different replies.

Then support for CDC-Only devices is added, which was a previously
not-very-well supported corner case.

The last four patches move the cec framework and pulse8-cec driver
out of staging.

Regards,

	Hans


Hans Verkuil (11):
  pulse8-cec: set all_device_types when restoring config
  cec rst: convert tables and drop the 'row' comments
  cec: add flag to cec_log_addrs to enable RC passthrough
  cec: add CEC_MSG_FL_REPLY_TO_FOLLOWERS
  cec: filter invalid messages
  cec: accept two replies for CEC_MSG_INITIATE_ARC.
  cec: add proper support for CDC-Only CEC devices
  cec: move the CEC framework out of staging and to media
  pulse8-cec: move out of staging
  s5p-cec/st-cec: update TODOs
  MAINTAINERS: update paths

 .../media/uapi/cec/cec-ioc-adap-g-caps.rst         | 156 +++----
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    | 487 ++++++++-------------
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   | 182 +++-----
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst    | 317 ++++++--------
 Documentation/media/uapi/cec/cec-ioc-receive.rst   | 418 ++++++++----------
 MAINTAINERS                                        |  10 +-
 drivers/media/Kconfig                              |  16 +
 drivers/media/Makefile                             |   4 +
 drivers/{staging => }/media/cec/Makefile           |   2 +-
 drivers/{staging => }/media/cec/cec-adap.c         | 212 ++++++++-
 drivers/{staging => }/media/cec/cec-api.c          |  11 +-
 drivers/{staging => }/media/cec/cec-core.c         |   0
 drivers/{staging => }/media/cec/cec-priv.h         |   0
 drivers/media/i2c/Kconfig                          |   6 +-
 drivers/media/platform/vivid/Kconfig               |   2 +-
 drivers/media/usb/Kconfig                          |   5 +
 drivers/media/usb/Makefile                         |   1 +
 .../media => media/usb}/pulse8-cec/Kconfig         |   2 +-
 .../media => media/usb}/pulse8-cec/Makefile        |   0
 .../media => media/usb}/pulse8-cec/pulse8-cec.c    |   8 +
 drivers/staging/media/Kconfig                      |   4 -
 drivers/staging/media/Makefile                     |   2 -
 drivers/staging/media/cec/Kconfig                  |  12 -
 drivers/staging/media/cec/TODO                     |  32 --
 drivers/staging/media/pulse8-cec/TODO              |  52 ---
 drivers/staging/media/s5p-cec/Kconfig              |   2 +-
 drivers/staging/media/s5p-cec/TODO                 |  12 +-
 drivers/staging/media/st-cec/Kconfig               |   2 +-
 drivers/staging/media/st-cec/TODO                  |   7 +
 include/media/cec.h                                |   2 +-
 include/uapi/linux/Kbuild                          |   2 +
 include/{ => uapi}/linux/cec-funcs.h               |   6 -
 include/{ => uapi}/linux/cec.h                     |  65 ++-
 33 files changed, 951 insertions(+), 1088 deletions(-)
 rename drivers/{staging => }/media/cec/Makefile (70%)
 rename drivers/{staging => }/media/cec/cec-adap.c (86%)
 rename drivers/{staging => }/media/cec/cec-api.c (97%)
 rename drivers/{staging => }/media/cec/cec-core.c (100%)
 rename drivers/{staging => }/media/cec/cec-priv.h (100%)
 rename drivers/{staging/media => media/usb}/pulse8-cec/Kconfig (86%)
 rename drivers/{staging/media => media/usb}/pulse8-cec/Makefile (100%)
 rename drivers/{staging/media => media/usb}/pulse8-cec/pulse8-cec.c (97%)
 delete mode 100644 drivers/staging/media/cec/Kconfig
 delete mode 100644 drivers/staging/media/cec/TODO
 delete mode 100644 drivers/staging/media/pulse8-cec/TODO
 create mode 100644 drivers/staging/media/st-cec/TODO
 rename include/{ => uapi}/linux/cec-funcs.h (99%)
 rename include/{ => uapi}/linux/cec.h (94%)

-- 
2.10.1

