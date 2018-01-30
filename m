Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:58809 "EHLO
        aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751360AbeA3MCt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 07:02:49 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Daniel Mentz <danielmentz@google.com>
From: Hans Verkuil <hansverk@cisco.com>
Subject: [GIT PULL FOR v4.16] v4l2-compat-ioctl32.c: remove set_fs(KERNEL_DS)
Message-ID: <bb60dfc8-097c-71ee-098d-02db67c63a8f@cisco.com>
Date: Tue, 30 Jan 2018 13:02:46 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series fixes a number of bugs and culminates in the removal
of the set_fs(KERNEL_DS) call in v4l2-compat-ioctl32.c.

See http://people.canonical.com/~ubuntu-security/cve/2017/CVE-2017-13166.html
for why this set_fs call is a bad idea.

In order to test this I used vivid and a 32-bit v4l2-compliance. The
advantage of vivid is that it implements almost all ioctls, and those
are all tested by v4l2-compliance. This ensures good test coverage.

Since I had to track down all failures that v4l2-compliance reported
in order to verify whether those were introduced by the final patch
or if those were pre-existing bugs, this series starts off with fixes
for bugs that v4l2-compliance found, mostly in v4l2-compat-ioctl32.c.
It is clear that v4l2-compat-ioctl32.c doesn't receive a lot of
testing.

There are also three patches that just clean up v4l2-compat-ioctl32.c
in order to simplify the final patch:

  v4l2-compat-ioctl32.c: fix the indentation
  v4l2-compat-ioctl32.c: move 'helper' functions to __get/put_v4l2_format32
  v4l2-compat-ioctl32.c: avoid sizeof(type)

No functional changes are introduced in these three patches.

Note the "fix ctrl_is_pointer" patch: we've discussed this in the past,
but now I really had to fix this.

It would be really nice if the next time someone finds a security risk
in V4L2 core code they would contact the V4L2 maintainers. We only heard
about this last week, while all the information about this CVE has been
out there for several months or so.

Backporting this will be a bit of a nightmare since v4l2-compat-ioctl32.c
changes frequently, so assuming we'll only backport this to lts kernels
then for each lts the patch series needs to be adapted. But let's get
this upstream first before looking at that.

This pull request has Cc's to stable to get this in for 4.15 (it should
apply cleanly for 4.15).

Regards,

	Hans

Changes since v2:
- Add remaining Acks from Sakari
- Fix two whitespace issues in v4l2-compat-ioctl32.c
- Added 'Fixes' tag.

Changes since v1:
- Incorporated all Sakari's comments
- Added the 'v4l2-ioctl.c: don't copy back the result for -ENOTTY' patch
  (suggested by Sakari).
- Added back the "Reported-by" tag for the last patch.
- Added "Co-Developed-by" tag for the last patch.
- Added "Cc: <stable@vger.kernel.org>      # for v4.15 and up" tags to
  this series.


The following changes since commit 4852fdca8818972d0ea5b5ce7114da628f9954a4:

  media: i2c: ov7740: use gpio/consumer.h instead of gpio.h (2018-01-23 08:13:02 -0500)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git compatcve2

for you to fetch changes up to 74e1562a58f58be57b0e75f744aa9b2e5b32a3f3:

  v4l2-compat-ioctl32.c: refactor, fix security bug in compat ioctl32 (2018-01-30 12:55:20 +0100)

----------------------------------------------------------------
Daniel Mentz (1):
      v4l2-compat-ioctl32.c: refactor, fix security bug in compat ioctl32

Hans Verkuil (12):
      vivid: fix module load error when enabling fb and no_error_inj=1
      v4l2-ioctl.c: use check_fmt for enum/g/s/try_fmt
      v4l2-ioctl.c: don't copy back the result for -ENOTTY
      v4l2-compat-ioctl32.c: add missing VIDIOC_PREPARE_BUF
      v4l2-compat-ioctl32.c: fix the indentation
      v4l2-compat-ioctl32.c: move 'helper' functions to __get/put_v4l2_format32
      v4l2-compat-ioctl32.c: avoid sizeof(type)
      v4l2-compat-ioctl32.c: copy m.userptr in put_v4l2_plane32
      v4l2-compat-ioctl32.c: fix ctrl_is_pointer
      v4l2-compat-ioctl32.c: copy clip list in put_v4l2_window32
      v4l2-compat-ioctl32.c: drop pr_info for unknown buffer type
      v4l2-compat-ioctl32.c: don't copy back the result for certain errors

 drivers/media/platform/vivid/vivid-core.h     |    1 +
 drivers/media/platform/vivid/vivid-ctrls.c    |   35 ++-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 1032 ++++++++++++++++++++++++++++++++++++-------------------------
 drivers/media/v4l2-core/v4l2-ioctl.c          |  145 ++++-----
 4 files changed, 695 insertions(+), 518 deletions(-)
