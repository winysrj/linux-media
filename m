Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55652 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729070AbeJSCEi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Oct 2018 22:04:38 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        paul.kocialkowski@bootlin.com, maxime.ripard@bootlin.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v5 0/5] Make sure .device_run is always called in non-atomic context
Date: Thu, 18 Oct 2018 15:02:19 -0300
Message-Id: <20181018180224.3392-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series goal is to avoid drivers from having ad-hoc code
to call .device_run in non-atomic context. Currently, .device_run
can be called via v4l2_m2m_job_finish(), not only running
in interrupt context, but also creating a nasty re-entrant
path into mem2mem drivers.

The proposed solution is to add a per-device worker that is scheduled
by v4l2_m2m_job_finish, which replaces drivers having a threaded interrupt
or similar.

This change allows v4l2_m2m_job_finish() to be called in interrupt
context, separating .device_run and v4l2_m2m_job_finish() contexts.

It's worth mentioning that v4l2_m2m_cancel_job() doesn't need
to flush or cancel the new worker, because the job_spinlock
synchronizes both and also because the core prevents simultaneous
jobs. Either v4l2_m2m_cancel_job() will wait for the worker, or the
worker will be unable to run a new job.

Patches apply on top of Request API and the Cedrus VPU
driver.

Tested with cedrus driver using v4l2-request-test and
vicodec driver using gstreamer.

Ezequiel Garcia (4):
  mem2mem: Require capture and output mutexes to match
  v4l2-ioctl.c: Simplify locking for m2m devices
  v4l2-mem2mem: Avoid calling .device_run in v4l2_m2m_job_finish
  media: cedrus: Get rid of interrupt bottom-half

Sakari Ailus (1):
  v4l2-mem2mem: Simplify exiting the function in __v4l2_m2m_try_schedule

 drivers/media/v4l2-core/v4l2-ioctl.c          | 47 +------------
 drivers/media/v4l2-core/v4l2-mem2mem.c        | 66 ++++++++++++-------
 .../staging/media/sunxi/cedrus/cedrus_hw.c    | 26 ++------
 3 files changed, 51 insertions(+), 88 deletions(-)

-- 
2.19.1
