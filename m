Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50296 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729763AbeHBWlt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2018 18:41:49 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        paul.kocialkowski@bootlin.com, maxime.ripard@bootlin.com,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v4 0/6] Make sure .device_run is always called in non-atomic context
Date: Thu,  2 Aug 2018 17:48:44 -0300
Message-Id: <20180802204850.31633-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4:
  * Add patches and 1 and 2, to make q_lock mandatory,
    in other words, require output and capture locks to match.
  * Add WARN_ON if the lock is not held in v4l2_m2m_try_schedule,
    and also document the requirement.
  * Add a comment explaining why the job is scheduled.

This series goal is to avoid drivers from having ad-hoc code
to call .device_run in non-atomic context. Currently, .device_run
can be called via v4l2_m2m_job_finish(), potentially running
in interrupt context.

This series will be useful for the upcoming Request API, where drivers
typically require .device_run to be called in non-atomic context for
v4l2_ctrl_request_setup() calls.

The solution is to add a per-device worker that is scheduled
by v4l2_m2m_job_finish, which replaces drivers having a threaded interrupt
or similar.

This change allows v4l2_m2m_job_finish() to be called in interrupt
context, separating .device_run and v4l2_m2m_job_finish() contexts.

It's worth mentioning that v4l2_m2m_cancel_job() doesn't need
to flush or cancel the new worker, because the job_spinlock
synchronizes both and also because the core prevents simultaneous
jobs. Either v4l2_m2m_cancel_job() will wait for the worker, or the
worker will be unable to run a new job.

Testing
-------

In order to test the change, and make sure no regressions are
introduced, a kselftest test is added to stress the mem2mem framework.

Note that this series rework the kselftest media_tests target.
Those tests that need hardware and human intervention are now
marked as _EXTENDED, and a frontend script is added to run those
tests that can run without hardware or human intervention.

This will allow the media_tests target to be included in
automatic regression testing setups.

Hopefully, we will be able to introduce more and more automatic
regression tests. Currently, our self-test run looks like:

    $ make TARGETS=media_tests kselftest 
    make[1]: Entering directory '/home/zeta/repos/builds/virtme-x86_64'
    make[3]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
    make[3]: Nothing to be done for 'all'.
    make[3]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
    TAP version 13
    selftests: media_tests: m2m_job_test.sh
    ========================================
    -------------------
    running media tests
    -------------------
    media_device : no video4linux drivers loaded, vim2m is needed
    not ok 1..1 selftests: media_tests: m2m_job_test.sh [SKIP]
    make[1]: Leaving directory '/home/zeta/repos/builds/virtme-x86_64'

Ezequiel Garcia (5):
  mem2mem: Require capture and output mutexes to match
  v4l2-ioctl.c: simplify locking for m2m devices
  v4l2-mem2mem: Avoid v4l2_m2m_prepare_buf from scheduling a job
  v4l2-mem2mem: Avoid calling .device_run in v4l2_m2m_job_finish
  selftests: media_tests: Add a memory-to-memory concurrent stress test

Sakari Ailus (1):
  v4l2-mem2mem: Simplify exiting the function in __v4l2_m2m_try_schedule

 drivers/media/v4l2-core/v4l2-ioctl.c          |  47 +--
 drivers/media/v4l2-core/v4l2-mem2mem.c        |  94 ++++--
 .../testing/selftests/media_tests/.gitignore  |   1 +
 tools/testing/selftests/media_tests/Makefile  |   5 +-
 .../selftests/media_tests/m2m_job_test.c      | 287 ++++++++++++++++++
 .../selftests/media_tests/m2m_job_test.sh     |  32 ++
 6 files changed, 389 insertions(+), 77 deletions(-)
 create mode 100644 tools/testing/selftests/media_tests/m2m_job_test.c
 create mode 100755 tools/testing/selftests/media_tests/m2m_job_test.sh

-- 
2.18.0
