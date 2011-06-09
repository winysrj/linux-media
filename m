Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:38390 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754996Ab1FIUyr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jun 2011 16:54:47 -0400
References: <1307634716-10809-1-git-send-email-jarod@redhat.com>
In-Reply-To: <1307634716-10809-1-git-send-email-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] [media] lirc_zilog: fix spinning rx thread
From: Andy Walls <awalls@md.metrocast.net>
Date: Thu, 09 Jun 2011 16:48:17 -0400
To: Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org
CC: stable@kernel.org
Message-ID: <b50028f0-25ff-4da9-aeb5-0536495cc9a7@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Jarod Wilson <jarod@redhat.com> wrote:

>We were calling schedule_timeout with the rx thread's task state still
>at TASK_RUNNING, which it shouldn't be. Make sure we call
>set_current_state(TASK_INTERRUPTIBLE) *before* schedule_timeout, and
>we're all good here. I believe this problem was mistakenly introduced
>in
>commit 5bd6b0464b68d429bc8a3fe6595d19c39dfc4d95, and I'm not sure how I
>missed it before, as I swear I tested the patchset that was included
>in,
>but alas, stuff happens...
>
>CC: Andy Walls <awalls@md.metrocast.net>
>CC: stable@kernel.org
>Signed-off-by: Jarod Wilson <jarod@redhat.com>
>---
> drivers/staging/lirc/lirc_zilog.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/staging/lirc/lirc_zilog.c
>b/drivers/staging/lirc/lirc_zilog.c
>index dd6a57c..4e051f6 100644
>--- a/drivers/staging/lirc/lirc_zilog.c
>+++ b/drivers/staging/lirc/lirc_zilog.c
>@@ -475,14 +475,14 @@ static int lirc_thread(void *arg)
> 	dprintk("poll thread started\n");
> 
> 	while (!kthread_should_stop()) {
>+		set_current_state(TASK_INTERRUPTIBLE);
>+
> 		/* if device not opened, we can sleep half a second */
> 		if (atomic_read(&ir->open_count) == 0) {
> 			schedule_timeout(HZ/2);
> 			continue;
> 		}
> 
>-		set_current_state(TASK_INTERRUPTIBLE);
>-
> 		/*
> 		 * This is ~113*2 + 24 + jitter (2*repeat gap + code length).
> 		 * We use this interval as the chip resets every time you poll
>-- 
>1.7.1
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Acked-by: Andy Walls <awalls@md.metrocast.net>
