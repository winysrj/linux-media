Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:39494 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729215AbeGSXwU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jul 2018 19:52:20 -0400
Message-ID: <29711fb3219f6c39ee6182e24ec4bc92be4d0c09.camel@collabora.com>
Subject: Re: [PATCH 2/2] v4l2-mem2mem: Avoid calling .device_run in
 v4l2_m2m_job_finish
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: kernel@collabora.com, paul.kocialkowski@bootlin.com,
        maxime.ripard@bootlin.com, Hans Verkuil <hans.verkuil@cisco.com>
Date: Thu, 19 Jul 2018 20:06:53 -0300
In-Reply-To: <2c6a3f3c-e936-2f12-303d-f2358bcbcc94@xs4all.nl>
References: <20180712154322.30237-1-ezequiel@collabora.com>
         <20180712154322.30237-3-ezequiel@collabora.com>
         <2c6a3f3c-e936-2f12-303d-f2358bcbcc94@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2018-07-18 at 12:21 +0200, Hans Verkuil wrote:
> On 12/07/18 17:43, Ezequiel Garcia wrote:
> > v4l2_m2m_job_finish() is typically called in interrupt context.
> > 
> > Some implementation of .device_run might sleep, and so it's
> > desirable to avoid calling it directly from
> > v4l2_m2m_job_finish(), thus avoiding .device_run from running
> > in interrupt context.
> > 
> > Implement a deferred context that gets scheduled by
> > v4l2_m2m_job_finish().
> > 
> > The worker calls v4l2_m2m_try_schedule(), which makes sure
> > a single job is running at the same time, so it's safe to
> > call it from different executions context.
> 
> I am not sure about this. I think that the only thing that needs to
> run in the work queue is the call to device_run. Everything else
> up to that point runs fine in interrupt context.
> 

Yes, I think you are right. I originally went for the safer path
of running v4l2_m2m_try_schedule in the worker, but I think
it works to run only .device_run.

So there will be two paths to .device_run:

  * qbuf/streamon which checks if a job is possible
    for this or any other m2m context, and then
    calls .device_run for the selected m2m context.

  * job_finish will check if there is a job possible,
    for this or any other m2m context, then
    select a context by setting the current context
    and setting TRANS_RUNNING, then schedule the worker.

Only one m2m context can be running at the same time, and
v4l2_m2m_cancel_job is called by v4l2_m2m_streamoff and
v4l2_m2m_ctx_release, guaranteeing we don't try to run
a job on a stopped/released m2m context.

> While we're on it: I see that v4l2_m2m_prepare_buf() also calls
> v4l2_m2m_try_schedule(): I don't think it should do that since
> prepare_buf does not actually queue a new buffer to the driver.
> 

Yes, you are right about that. I'll remove it.

Thanks for reviewing,
Eze
