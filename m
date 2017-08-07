Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:60761 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752149AbdHGHmQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Aug 2017 03:42:16 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.14] cec: little improvements
Message-ID: <36c64ff0-2e75-8e6e-62b8-437aae526c6a@xs4all.nl>
Date: Mon, 7 Aug 2017 09:42:13 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Better logging, better documentation, add a convenience define.

Regards,

	Hans

The following changes since commit da48c948c263c9d87dfc64566b3373a858cc8aa2:

  media: fix warning on v4l2_subdev_call() result interpreted as bool (2017-07-26 13:43:17 -0400)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.14f

for you to fetch changes up to b52870ca523e37c424f0267694101905b6256bb8:

  cec-api: log the reason for the -EINVAL in cec_s_mode (2017-08-07 09:31:15 +0200)

----------------------------------------------------------------
Hans Verkuil (6):
      cec-funcs.h: cec_ops_report_features: set *dev_features to NULL
      media/cec.h: add CEC_CAP_DEFAULTS
      adv*/vivid/pulse8/rainshadow: cec: use CEC_CAP_DEFAULTS
      cec-ioc-adap-g-log-addrs.rst: fix wrong quotes
      cec-ioc-g-mode.rst: improve description of message, processing
      cec-api: log the reason for the -EINVAL in cec_s_mode

 Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst |  2 +-
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst           | 61 ++++++++++++++++++++++++++++------------------
 drivers/media/cec/cec-api.c                               | 25 ++++++++++++++-----
 drivers/media/i2c/adv7511.c                               |  3 +--
 drivers/media/i2c/adv7604.c                               |  3 +--
 drivers/media/i2c/adv7842.c                               |  3 +--
 drivers/media/platform/vivid/vivid-cec.c                  |  3 +--
 drivers/media/usb/pulse8-cec/pulse8-cec.c                 |  3 +--
 drivers/media/usb/rainshadow-cec/rainshadow-cec.c         |  3 +--
 include/media/cec.h                                       |  3 +++
 include/uapi/linux/cec-funcs.h                            |  1 +
 11 files changed, 67 insertions(+), 43 deletions(-)
