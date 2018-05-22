Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:56407 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751024AbeEVIOy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 04:14:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCHv3 0/5] gspca: convert to vb2gspca: convert to vb2
Date: Tue, 22 May 2018 10:14:46 +0200
Message-Id: <20180522081451.94794-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The first patch fixes a bug in videobuf2-core.c: the finish memop
should not be called when vb2_buffer_done is called with state
QUEUED or REQUEUEING. Doing so leads to one finish too many and
an 'UNBALANCED' error is logged. Discovered since some of these
gspca webcams are flaky and fail during start_streaming.

The second patch converts the gspca driver to the vb2 framework.
It was much easier to do than I expected and it saved almost 600
lines of gspca driver code.

The third patch fixes v4l2-compliance warnings for g/s_parm.

The fourth patch clears relevant fields in v4l2_streamparm in
v4l_s_parm(). This was never done before since v4l2-compliance
didn't check this.

The final patch deletes the now unused v4l2_disable_ioctl_locking()
function.

Tested with many gspca webcams, and tested suspend/resume as well.

Regards,

	Hans

Changes since v2:

- Added first videobuf2-core.c patch
- Improve disconnect code to no longer destroy URBs, instead leave
  that to gspca_release(). This avoids a NULL pointer bug if the
  gspca subdriver was still processing URBs at disconnect time.
- A spinlock in gspca_frame_add() didn't disable irqs, which it
  should since it can be called from non-irq context.

Changes since v1:

- Re-added 'if (gspca_dev->present)' before the dq_callback call.
- Added Reviewed-by tags from Hans de Goede.

Hans Verkuil (5):
  videobuf2-core: don't call memop 'finish' when queueing
  gspca: convert to vb2
  gspca: fix g/s_parm handling
  v4l2-ioctl: clear fields in s_parm
  v4l2-ioctl: delete unused v4l2_disable_ioctl_locking

 .../media/common/videobuf2/videobuf2-core.c   |   9 +-
 drivers/media/usb/gspca/Kconfig               |   1 +
 drivers/media/usb/gspca/gspca.c               | 931 ++++--------------
 drivers/media/usb/gspca/gspca.h               |  38 +-
 drivers/media/usb/gspca/m5602/m5602_core.c    |   4 +-
 drivers/media/usb/gspca/ov534.c               |   1 -
 drivers/media/usb/gspca/topro.c               |   1 -
 drivers/media/usb/gspca/vc032x.c              |   2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c          |  19 +-
 include/media/v4l2-dev.h                      |  15 -
 10 files changed, 218 insertions(+), 803 deletions(-)

-- 
2.17.0
