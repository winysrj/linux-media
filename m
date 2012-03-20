Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:55791 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754710Ab2CTSO6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 14:14:58 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, srinivas.kandagatla@st.com
Subject: [PATCH 3.3.0] ir-raw: remove BUG_ON in ir_raw_event_thread.
Date: Tue, 20 Mar 2012 18:05:40 +0000
Message-Id: <1332266740-27609-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch removes BUG_ON in ir_raw_event_thread which IMO is a
over-kill, and this kills the ir_raw_event_thread too. With a bit of
additional logic in this patch, we nomore need to kill this thread.
Other disadvantage of having a BUG-ON is,
wake_up_process(dev->raw->thread) called on dead thread via
ir_raw_event_handle will result in total lockup in SMP system.

Advantage of this patch is ir-raw event thread is left in a usable state
even if the fifo does not have enough bytes.

This patch sets the thread into TASK_INTERRUPTIBLE if raw-fifo has less
then sizeof(struct ir_raw_event) bytes.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---

Hi All, 
BUG-ON in ir_raw_event_thread on an SMP system will put the system in an 
un-usable state, because..

BUG-ON actually kill the ir-raw-event kernel thread and my driver is 
calling wake_up_process on a dead thread via ir_raw_event_handle from 
interrupt context, which is why the system is left unusable.

However, my patch simplifies code in ir_raw_event_thread and remove BUG_ON 
forever.

BUG_ON in this thread is a bit of over kill in my opinion, as the thread is 
not is not in a very bad state, that it has to be killed.

Thanks,
srini


 drivers/media/rc/ir-raw.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index 95e6309..a820251 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -46,9 +46,9 @@ static int ir_raw_event_thread(void *data)
 	while (!kthread_should_stop()) {
 
 		spin_lock_irq(&raw->lock);
-		retval = kfifo_out(&raw->kfifo, &ev, sizeof(ev));
+		retval = kfifo_len(&raw->kfifo);
 
-		if (!retval) {
+		if (retval < sizeof(ev)) {
 			set_current_state(TASK_INTERRUPTIBLE);
 
 			if (kthread_should_stop())
@@ -59,11 +59,9 @@ static int ir_raw_event_thread(void *data)
 			continue;
 		}
 
+		retval = kfifo_out(&raw->kfifo, &ev, sizeof(ev));
 		spin_unlock_irq(&raw->lock);
 
-
-		BUG_ON(retval != sizeof(ev));
-
 		mutex_lock(&ir_raw_handler_lock);
 		list_for_each_entry(handler, &ir_raw_handler_list, list)
 			handler->decode(raw->dev, ev);
-- 
1.6.3.3

