Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:44502 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751488AbeCIKUo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 05:20:44 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.17] cec: add error injection support + other
 improvements
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <fbe25809-f9e0-0f2a-4bb3-8b8158279a96@xs4all.nl>
Date: Fri, 9 Mar 2018 11:20:42 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This series adds support for CEC error injection via debugfs. It's fantastic
for verifying CEC implementations. We (Cisco) have been developing and testing
this for quite some time now and it has been incredibly useful for low-level
CEC verification. And cheap too :-)

See the section "Making a CEC debugger" here:

https://hverkuil.home.xs4all.nl/cec-status.txt

Patches 1-6 add the error injection support and documentation.

The 7th patch improves the status log for the CEC pin framework. It
now reports when and how many incorrect bits were received.

The final patch improves CEC pin event handling: increasing the size
of an internal FIFO (it was too small, sometimes causing events to be lost)
and correctly reporting to userspace when events were lost, ensuring that
userspace at least knows that this happened.

Regards,

	Hans

The following changes since commit 3f127ce11353fd1071cae9b65bc13add6aec6b90:

  media: em28xx-cards: fix em28xx_duplicate_dev() (2018-03-08 06:06:51 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cec

for you to fetch changes up to ca5b5b26973e7dca9f1f2f9babbd7afaaf1f9f04:

  cec: improve CEC pin event handling (2018-03-09 11:09:00 +0100)

----------------------------------------------------------------
Hans Verkuil (8):
      cec: add core error injection support
      cec-core.rst: document the error injection ops
      cec-pin: create cec_pin_start_timer() function
      cec-pin-error-inj: parse/show error injection
      cec-pin: add error injection support
      cec-pin-error-inj.rst: document CEC Pin Error Injection
      cec-pin: improve status log
      cec: improve CEC pin event handling

 Documentation/media/cec-drivers/cec-pin-error-inj.rst | 322 +++++++++++++++++++++++++++++
 Documentation/media/cec-drivers/index.rst             |   1 +
 Documentation/media/kapi/cec-core.rst                 |  72 ++++++-
 MAINTAINERS                                           |   1 +
 drivers/media/cec/Kconfig                             |   6 +
 drivers/media/cec/Makefile                            |   4 +
 drivers/media/cec/cec-adap.c                          |   8 +-
 drivers/media/cec/cec-core.c                          |  58 ++++++
 drivers/media/cec/cec-pin-error-inj.c                 | 342 +++++++++++++++++++++++++++++++
 drivers/media/cec/cec-pin-priv.h                      | 134 +++++++++++-
 drivers/media/cec/cec-pin.c                           | 664 +++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 drivers/media/platform/vivid/vivid-cec.c              |   8 +-
 include/media/cec.h                                   |  12 +-
 13 files changed, 1540 insertions(+), 92 deletions(-)
 create mode 100644 Documentation/media/cec-drivers/cec-pin-error-inj.rst
 create mode 100644 drivers/media/cec/cec-pin-error-inj.c
