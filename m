Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:39375 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750807AbdGaJOI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Jul 2017 05:14:08 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.14] Various fixes
Message-ID: <a8d1881c-77c2-b469-f416-37f47aee0523@xs4all.nl>
Date: Mon, 31 Jul 2017 11:14:04 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit da48c948c263c9d87dfc64566b3373a858cc8aa2:

  media: fix warning on v4l2_subdev_call() result interpreted as bool (2017-07-26 13:43:17 -0400)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.14d

for you to fetch changes up to 478a2d07c23760c82bdbb8bfaa71050c9256c553:

  coda: reduce iram size to leave space for suspend to ram (2017-07-31 10:53:19 +0200)

----------------------------------------------------------------
Arnd Bergmann (1):
      staging/imx: remove confusing IS_ERR_OR_NULL usage

Hirokazu Honda (1):
      vb2: core: Lower the log level of debug outputs

Jan Luebbe (1):
      coda: reduce iram size to leave space for suspend to ram

Philipp Zabel (1):
      coda: fix decoder sequence init escape flag

kbuild test robot (1):
      i2c: fix semicolon.cocci warnings

 drivers/media/i2c/ov5670.c                  |  2 +-
 drivers/media/platform/coda/coda-bit.c      | 13 +++++--------
 drivers/media/platform/coda/coda-common.c   |  2 +-
 drivers/media/v4l2-core/videobuf2-core.c    | 10 +++++-----
 drivers/staging/media/imx/imx-ic-prpencvf.c | 41 ++++++++++++++++++++++-------------------
 drivers/staging/media/imx/imx-media-csi.c   | 30 ++++++++++++++++++------------
 drivers/staging/media/imx/imx-media-dev.c   |  4 ++--
 drivers/staging/media/imx/imx-media-of.c    | 50 ++++++++++++++++++++++++++++----------------------
 drivers/staging/media/imx/imx-media-vdic.c  | 37 ++++++++++++++++++++-----------------
 9 files changed, 102 insertions(+), 87 deletions(-)
