Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:43174 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730706AbeG0PFj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 11:05:39 -0400
Subject: Re: [PATCH] mem2mem: Remove excessive try_run call
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        mchehab+samsung@kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media <linux-media@vger.kernel.org>, kernel@collabora.com
References: <20180612132251.28047-1-ezequiel@collabora.com>
 <CAAEAJfAWWsyj4Yt8KQsCxfWB528=Fuc6=8q5BSQv_Ln0QvCcEQ@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a315dc10-2ea6-2dc3-da64-f6cfd1b4f2c8@xs4all.nl>
Date: Fri, 27 Jul 2018 15:43:36 +0200
MIME-Version: 1.0
In-Reply-To: <CAAEAJfAWWsyj4Yt8KQsCxfWB528=Fuc6=8q5BSQv_Ln0QvCcEQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27/07/18 15:28, Ezequiel Garcia wrote:
> On 12 June 2018 at 10:22, Ezequiel Garcia <ezequiel@collabora.com> wrote:
>> If there is a schedulable job, v4l2_m2m_try_schedule() calls
>> v4l2_m2m_try_run(). This makes the unconditional v4l2_m2m_try_run()
>> called by v4l2_m2m_job_finish superfluous. Remove it.
>>
>> Fixes: 7f98639def42 ("V4L/DVB: add memory-to-memory device helper framework for videobuf")
>> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
>> ---
>>  drivers/media/v4l2-core/v4l2-mem2mem.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
>> index c4f963d96a79..5f9cd5b74cda 100644
>> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
>> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
>> @@ -339,7 +339,6 @@ void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
>>          * allow more than one job on the job_queue per instance, each has
>>          * to be scheduled separately after the previous one finishes. */
>>         v4l2_m2m_try_schedule(m2m_ctx);
>> -       v4l2_m2m_try_run(m2m_dev);
>>  }
>>  EXPORT_SYMBOL(v4l2_m2m_job_finish);
>>
> 
> Hi Mauro, Hans,
> 
> Please note that this patch (which is merged in Mauro's) introduces an issue
> in the following scenario:
> 
>  1) Context A schedules, queues and runs job A.
>  2) While the m2m device is running, context B schedules
>     and queues job B. Job B cannot run, because it has to
>     wait for job A.
>  3) Job A completes, calls v4l2_m2m_job_finish, and tries
>     to queue a job for context A, but since the context is
>     empty it won't do anything.
> 
> In this scenario, queued job B will never run.
> 
> The issue is fixed in https://patchwork.kernel.org/patch/10544487/
> 
> I don't know what's the best way to proceed here, pick the fix or simply
> drop this commit instead?
> 

It's best to fix it, but I did a quick review of that patch and I had a
few comments.

I'm not sure what is going on here, so if you can take another look?

If there is indeed a regression, them post the fix as a separate patch.
Fixes can of course always be applied, irrespective of the merge window.

Regards,

	Hans
