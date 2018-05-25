Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:41793 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935951AbeEYIRQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 04:17:16 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.18] gspca: convert to vb2
Message-ID: <a0b25549-b50b-3800-c4af-66b4fa3bc4da@xs4all.nl>
Date: Fri, 25 May 2018 10:17:14 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series converts gspca to vb2. It also fixes a vb2 bug found
while testing this, and it zeroes some fields for g/s_parm (they were
never tested in v4l2-compliance, so nobody noticed before).

Finally v4l2_disable_ioctl_locking() can now be removed since gspca no
longer needs it.

Tested with my (very large, thanks to Hans de Goede!) collection of gspca
webcams.

Regards,

	Hans

The following changes since commit 8ed8bba70b4355b1ba029b151ade84475dd12991:

  media: imx274: remove non-indexed pointers from mode_table (2018-05-17 06:22:08 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git gspca

for you to fetch changes up to 0946167e1f90a78928612c95cafad1cdf0868a15:

  gspca: Kill all URBs before releasing any of them (2018-05-25 10:10:43 +0200)

----------------------------------------------------------------
Ezequiel Garcia (1):
      gspca: Kill all URBs before releasing any of them

Hans Verkuil (5):
      videobuf2-core: don't call memop 'finish' when queueing
      gspca: convert to vb2
      v4l2-ioctl: clear fields in s_parm
      v4l2-ioctl: delete unused v4l2_disable_ioctl_locking
      gspca: fix g/s_parm handling

 drivers/media/common/videobuf2/videobuf2-core.c |   9 +-
 drivers/media/usb/gspca/Kconfig                 |   1 +
 drivers/media/usb/gspca/gspca.c                 | 946 +++++++++++--------------------------------------------
 drivers/media/usb/gspca/gspca.h                 |  38 +--
 drivers/media/usb/gspca/m5602/m5602_core.c      |   4 +-
 drivers/media/usb/gspca/ov534.c                 |   1 -
 drivers/media/usb/gspca/topro.c                 |   1 -
 drivers/media/usb/gspca/vc032x.c                |   2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c            |  19 +-
 include/media/v4l2-dev.h                        |  15 -
 10 files changed, 229 insertions(+), 807 deletions(-)
