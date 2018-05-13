Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:46357 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750941AbeEMJrq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 May 2018 05:47:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCHv2 0/4] gspca: convert to vb2gspca: convert to vb2
Date: Sun, 13 May 2018 11:47:37 +0200
Message-Id: <20180513094741.25096-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The first patch converts the gspca driver to the vb2 framework.
It was much easier to do than I expected and it saved almost 600
lines of gspca driver code.

The second patch fixes v4l2-compliance warnings for g/s_parm.

The third patch clears relevant fields in v4l2_streamparm in
v4l_s_parm(). This was never done before since v4l2-compliance
didn't check this.

The final patch deletes the now unused v4l2_disable_ioctl_locking()
function.

Tested with three different gspca webcams, and tested suspend/resume
as well.

I'll test with a few more webcams next week and if those tests all
succeed then I'll post a pull request.

Regards,

	Hans

Changes since v1:

- Re-added 'if (gspca_dev->present)' before the dq_callback call.
- Added Reviewed-by tags from Hans de Goede.

Hans Verkuil (4):
  gspca: convert to vb2
  gspca: fix g/s_parm handling
  v4l2-ioctl: clear fields in s_parm
  v4l2-ioctl: delete unused v4l2_disable_ioctl_locking

 drivers/media/usb/gspca/Kconfig            |   1 +
 drivers/media/usb/gspca/gspca.c            | 925 ++++-----------------
 drivers/media/usb/gspca/gspca.h            |  38 +-
 drivers/media/usb/gspca/m5602/m5602_core.c |   4 +-
 drivers/media/usb/gspca/ov534.c            |   1 -
 drivers/media/usb/gspca/topro.c            |   1 -
 drivers/media/usb/gspca/vc032x.c           |   2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c       |  19 +-
 include/media/v4l2-dev.h                   |  15 -
 9 files changed, 210 insertions(+), 796 deletions(-)

-- 
2.17.0
