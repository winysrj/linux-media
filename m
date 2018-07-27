Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:34128 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730088AbeG0OuE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 10:50:04 -0400
Received: by mail-pl0-f67.google.com with SMTP id f6-v6so2337908plo.1
        for <linux-media@vger.kernel.org>; Fri, 27 Jul 2018 06:28:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180612132251.28047-1-ezequiel@collabora.com>
References: <20180612132251.28047-1-ezequiel@collabora.com>
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date: Fri, 27 Jul 2018 10:28:07 -0300
Message-ID: <CAAEAJfAWWsyj4Yt8KQsCxfWB528=Fuc6=8q5BSQv_Ln0QvCcEQ@mail.gmail.com>
Subject: Re: [PATCH] mem2mem: Remove excessive try_run call
To: Ezequiel Garcia <ezequiel@collabora.com>,
        mchehab+samsung@kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media <linux-media@vger.kernel.org>, kernel@collabora.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12 June 2018 at 10:22, Ezequiel Garcia <ezequiel@collabora.com> wrote:
> If there is a schedulable job, v4l2_m2m_try_schedule() calls
> v4l2_m2m_try_run(). This makes the unconditional v4l2_m2m_try_run()
> called by v4l2_m2m_job_finish superfluous. Remove it.
>
> Fixes: 7f98639def42 ("V4L/DVB: add memory-to-memory device helper framewo=
rk for videobuf")
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  drivers/media/v4l2-core/v4l2-mem2mem.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-=
core/v4l2-mem2mem.c
> index c4f963d96a79..5f9cd5b74cda 100644
> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
> @@ -339,7 +339,6 @@ void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev=
,
>          * allow more than one job on the job_queue per instance, each ha=
s
>          * to be scheduled separately after the previous one finishes. */
>         v4l2_m2m_try_schedule(m2m_ctx);
> -       v4l2_m2m_try_run(m2m_dev);
>  }
>  EXPORT_SYMBOL(v4l2_m2m_job_finish);
>

Hi Mauro, Hans,

Please note that this patch (which is merged in Mauro's) introduces an issu=
e
in the following scenario:

 1) Context A schedules, queues and runs job A.
 2) While the m2m device is running, context B schedules
    and queues job B. Job B cannot run, because it has to
    wait for job A.
 3) Job A completes, calls v4l2_m2m_job_finish, and tries
    to queue a job for context A, but since the context is
    empty it won't do anything.

In this scenario, queued job B will never run.

The issue is fixed in https://patchwork.kernel.org/patch/10544487/

I don't know what's the best way to proceed here, pick the fix or simply
drop this commit instead?
--=20
Ezequiel Garc=C3=ADa, VanguardiaSur
www.vanguardiasur.com.ar
