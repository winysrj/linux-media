Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37032 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728841AbeGYS2D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 14:28:03 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        paul.kocialkowski@bootlin.com, maxime.ripard@bootlin.com,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v2 0/5] Make sure .device_run is always called in non-atomic context
Date: Wed, 25 Jul 2018 14:15:11 -0300
Message-Id: <20180725171516.11210-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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

While working on this series, I found a bug recently introduced on
commit "media: mem2mem: Remove excessive try_run call". The first patch
fixes the bug.

In order to test the change, and make sure no regressions are
introduced, a kselftest test is added to stress the mem2mem framework.

Patches are based on v4.18-rc4 plus:

34dbb848d5e47 "media: mem2mem: Remove excessive try_run call"

Ezequiel Garcia (4):
  v4l2-mem2mem: Fix missing v4l2_m2m_try_run call
  v4l2-mem2mem: Avoid v4l2_m2m_prepare_buf from scheduling a job
  v4l2-mem2mem: Avoid calling .device_run in v4l2_m2m_job_finish
  selftests: media_tests: Add a memory-to-memory concurrent stress test

Sakari Ailus (1):
  v4l2-mem2mem: Simplify exiting the function in __v4l2_m2m_try_schedule

 drivers/media/v4l2-core/v4l2-mem2mem.c        | 104 +++++--
 tools/testing/selftests/media_tests/Makefile  |   4 +-
 .../selftests/media_tests/m2m_job_test.c      | 283 ++++++++++++++++++
 3 files changed, 362 insertions(+), 29 deletions(-)
 create mode 100644 tools/testing/selftests/media_tests/m2m_job_test.c

-- 
2.18.0
