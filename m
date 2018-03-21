Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:54373 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752527AbeCUSyZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Mar 2018 14:54:25 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL v2 FOR v4.17] cec: add error injection support + other
 improvements
Message-ID: <c64f5e92-6334-5a97-7964-21faaef283ed@xs4all.nl>
Date: Wed, 21 Mar 2018 19:54:21 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Same as the previous git pull except for moving and slightly editing the
CEC Pin Error Injection documentation and adding debugfs-cec-error-inj.

Regards,

	Hans

The following changes since commit 3f127ce11353fd1071cae9b65bc13add6aec6b90:

  media: em28xx-cards: fix em28xx_duplicate_dev() (2018-03-08 06:06:51 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cec

for you to fetch changes up to 6bf7995896c4b428f05825ec0c827c3089cdf97b:

  debugfs-cec-error-inj: document CEC error inj debugfs ABI (2018-03-21 19:52:09 +0100)

----------------------------------------------------------------
Hans Verkuil (9):
      cec: add core error injection support
      cec-core.rst: document the error injection ops
      cec-pin: create cec_pin_start_timer() function
      cec-pin-error-inj: parse/show error injection
      cec-pin: add error injection support
      cec-pin: improve status log
      cec: improve CEC pin event handling
      cec-pin-error-inj.rst: document CEC Pin Error Injection
      debugfs-cec-error-inj: document CEC error inj debugfs ABI

 Documentation/ABI/testing/debugfs-cec-error-inj    |  40 +++
 Documentation/media/kapi/cec-core.rst              |  72 +++++-
 Documentation/media/uapi/cec/cec-api.rst           |   1 +
 Documentation/media/uapi/cec/cec-pin-error-inj.rst | 325 ++++++++++++++++++++++++
 MAINTAINERS                                        |   1 +
 drivers/media/cec/Kconfig                          |   6 +
 drivers/media/cec/Makefile                         |   4 +
 drivers/media/cec/cec-adap.c                       |   8 +-
 drivers/media/cec/cec-core.c                       |  58 +++++
 drivers/media/cec/cec-pin-error-inj.c              | 342 +++++++++++++++++++++++++
 drivers/media/cec/cec-pin-priv.h                   | 134 +++++++++-
 drivers/media/cec/cec-pin.c                        | 664 +++++++++++++++++++++++++++++++++++++++++++------
 drivers/media/platform/vivid/vivid-cec.c           |   8 +-
 include/media/cec.h                                |  12 +-
 14 files changed, 1583 insertions(+), 92 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-cec-error-inj
 create mode 100644 Documentation/media/uapi/cec/cec-pin-error-inj.rst
 create mode 100644 drivers/media/cec/cec-pin-error-inj.c
