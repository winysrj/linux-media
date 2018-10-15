Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:45426 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726469AbeJOR7C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Oct 2018 13:59:02 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for 4.20] cec: forgot to cancel delayed work
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <a57d9fdb-7aa6-a471-926a-13046d16bbd5@xs4all.nl>
Date: Mon, 15 Oct 2018 12:14:22 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the wait for completion was interrupted, then make sure to cancel
any delayed work.

This can only happen if a transmit is waiting for a reply, and you press
Ctrl-C or reboot/poweroff or something like that which interrupts the
thread waiting for the reply and then proceeds to delete the CEC message.

Since the delayed work wasn't canceled, once it would trigger it referred
to stale data and resulted in a kernel oops.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Fixes: 7ec2b3b941a6 ("cec: add new tx/rx status bits to detect aborts/timeouts")
---
diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 0c0d9107383e..31d1f4ab915e 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -844,6 +844,8 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 	 */
 	mutex_unlock(&adap->lock);
 	wait_for_completion_killable(&data->c);
+	if (!data->completed)
+		cancel_delayed_work_sync(&data->work);
 	mutex_lock(&adap->lock);

 	/* Cancel the transmit if it was interrupted */
