Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:57402 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbeGLPxg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Jul 2018 11:53:36 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        paul.kocialkowski@bootlin.com, maxime.ripard@bootlin.com,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 0/2] Make sure .device_run is always called in non-atomic context
Date: Thu, 12 Jul 2018 12:43:20 -0300
Message-Id: <20180712154322.30237-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series goal is avoiding drivers from having ad-hoc code
to call .device_run in non-atomic context. Currently, .device_run
can be called via v4l2_m2m_job_finish(), potentially running
in interrupt context.

This is needed for the upcoming Request API, where drivers typically
require .device_run to be called in non-atomic context for
v4l2_ctrl_request_setup() calls.

The solution is quite simple, instead of drivers having a threaded interrupt
or similar, the mem2mem core has a per-context worker that is scheduled
by v4l2_m2m_job_finish.

This change allows v4l2_m2m_job_finish() to be called in interrupt
context, separating .device_run and v4l2_m2m_job_finish() contexts.

It's worth mentioning that v4l2_m2m_cancel_job() doesn't need
to flush or cancel the new worker, because the job_spinlock
synchronizes both and also because the core prevents simultaneous
jobs. Either v4l2_m2m_cancel_job() will wait for the worker, or the
worker will be unable to run a new job.

Paul, Maxime: This should avoid the threaded interrupt in the Cedrus
driver. Please, take a look and let me know how it goes.

Patches are based on v4.18-rc4 plus:

c1dbb540e35e "v4l2-mem2mem: Simplify exiting the function in v4l2_m2m_try_schedule"
be3d3b78573b "media: mem2mem: Remove excessive try_run call"

Ezequiel Garcia (2):
  v4l2-core: Simplify v4l2_m2m_try_{schedule,run}
  v4l2-mem2mem: Avoid calling .device_run in v4l2_m2m_job_finish

 drivers/media/v4l2-core/v4l2-mem2mem.c | 58 ++++++++++----------------
 include/media/v4l2-mem2mem.h           |  2 +
 2 files changed, 25 insertions(+), 35 deletions(-)

-- 
2.18.0.rc2
