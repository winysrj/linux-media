Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:51630 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751601AbdHQG4P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Aug 2017 02:56:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.14] cec: rename uAPI defines, fixes
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <7319f0bd-5882-345c-9143-c968e31e8933@xs4all.nl>
Date: Thu, 17 Aug 2017 08:56:11 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The second patch renames two CEC events in the public API. Since these were
introduced for 4.14, now is the time to do the rename before they become
part of the ABI. While working with and working on the cec-gpio driver to
debug CEC issues I realized that optionally being able to monitor the HDMI
HPD (hotplug detect) pin as well is very useful.

So besides monitoring the CEC pin it will also be possible to monitor the
HPD pin in the future. That means that the pin event has to tell with pin
has an event, CEC or HPD. Hence the rename while I still can.

The last patch is a fix for the irq handling in cec-pin.c which was broken.
This only affects the cec-gpio driver which isn't merged yet (expected for
4.15), but it is good to get this fixed now.

Regards,

	Hans

The following changes since commit ec0c3ec497cabbf3bfa03a9eb5edcc252190a4e0:

  media: ddbridge: split code into multiple files (2017-08-09 12:17:01 -0400)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cec-rename

for you to fetch changes up to 36fa912800ef8129b6c8c9caffb74a84ff5be36d:

  cec-pin: fix irq handling (2017-08-17 08:43:50 +0200)

----------------------------------------------------------------
Hans Verkuil (3):
      s5p-cec: use CEC_CAP_DEFAULTS
      cec: rename pin events/function
      cec-pin: fix irq handling

 Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst |  2 +-
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst     |  8 ++++----
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst      |  2 +-
 drivers/media/cec/cec-adap.c                         |  7 ++++---
 drivers/media/cec/cec-api.c                          |  4 ++--
 drivers/media/cec/cec-pin.c                          | 39 ++++++++++++++++++++++++---------------
 drivers/media/platform/s5p-cec/s5p_cec.c             |  7 ++-----
 include/media/cec-pin.h                              |  6 +++++-
 include/media/cec.h                                  |  9 +++++----
 include/uapi/linux/cec.h                             |  4 ++--
 10 files changed, 50 insertions(+), 38 deletions(-)
