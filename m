Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:33571 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751505AbeA3K1F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 05:27:05 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Daniel Mentz <danielmentz@google.com>
Subject: [PATCHv2 00/13] v4l2-compat-ioctl32.c: remove set_fs(KERNEL_DS)
Date: Tue, 30 Jan 2018 11:26:48 +0100
Message-Id: <20180130102701.13664-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

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
out there for 6 months or so.

Backporting this will be a bit of a nightmare since v4l2-compat-ioctl32.c
changes frequently, so assuming we'll only backport this to lts kernels
then for each lts the patch series needs to be adapted. But let's get
this upstream first before looking at that.

Please review!

Regards,

	Hans

Changes since v1:
- Incorporated all Sakari's comments
- Added the 'v4l2-ioctl.c: don't copy back the result for -ENOTTY' patch
  (suggested by Sakari).
- Added back the "Reported-by" tag for the last patch.
- Added "Co-Developed-by" tag for the last patch.
- Added "Cc: <stable@vger.kernel.org>      # for v4.15 and up" tags to
  this series.

Note: I prefer to backport the whole series to older kernels. Although it
is just the last patch that is the real fix, it is very hard to verify
without using v4l2-compliance and vivid. And that requires the other fixes.

Daniel Mentz (1):
  v4l2-compat-ioctl32.c: refactor, fix security bug in compat ioctl32

Hans Verkuil (12):
  vivid: fix module load error when enabling fb and no_error_inj=1
  v4l2-ioctl.c: use check_fmt for enum/g/s/try_fmt
  v4l2-ioctl.c: don't copy back the result for -ENOTTY
  v4l2-compat-ioctl32.c: add missing VIDIOC_PREPARE_BUF
  v4l2-compat-ioctl32.c: fix the indentation
  v4l2-compat-ioctl32.c: move 'helper' functions to
    __get/put_v4l2_format32
  v4l2-compat-ioctl32.c: avoid sizeof(type)
  v4l2-compat-ioctl32.c: copy m.userptr in put_v4l2_plane32
  v4l2-compat-ioctl32.c: fix ctrl_is_pointer
  v4l2-compat-ioctl32.c: copy clip list in put_v4l2_window32
  v4l2-compat-ioctl32.c: drop pr_info for unknown buffer type
  v4l2-compat-ioctl32.c: don't copy back the result for certain errors

 drivers/media/platform/vivid/vivid-core.h     |    1 +
 drivers/media/platform/vivid/vivid-ctrls.c    |   35 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 1033 +++++++++++++++----------
 drivers/media/v4l2-core/v4l2-ioctl.c          |  145 ++--
 4 files changed, 696 insertions(+), 518 deletions(-)

-- 
2.15.1
