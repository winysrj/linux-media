Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:34115 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757346Ab2CTN2V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 09:28:21 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, srinivas.kandagatla@st.com
Subject: [PATCH 3.3.0] [media] ir-raw: Check available elements in kfifo before adding.
Date: Tue, 20 Mar 2012 13:18:59 +0000
Message-Id: <1332249539-2482-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch adds an additional availability check in ir_raw_event_store
before adding an ir_raw_event into kfifo. The reason to do this is,
Kfifo_alloc allocates fifo of size rounded down to 2. Which in this
case makes sizeof ir_raw_event*MAX_IR_EVENT_SIZE = 6144 to 4096 bytes.
Then again 4096 is not perfectly divisable by sizeof ir_raw_event(12).
So before adding any element to kfifo checking howmany elements can be
inserted into fifo is safe.

This patch will make sure it inserts only sizeof(ev) into kfifo.

Without this patch ir_raw_event_thread will trigger a bug.

 kernel BUG at drivers/media/rc/ir-raw.c:65!
 Internal error: Oops - undefined instruction: 0 [#1] PREEMPT SMP
 Modules linked in:
 CPU: 0    Not tainted  (3.2.2_stm24_0208-b2000+ #31)
 PC is at ir_raw_event_thread+0xa4/0x10c
 LR is at ir_raw_event_thread+0xa4/0x10c
 pc : [<c01e0ef4>]    lr : [<c01e0ef4>]    psr: 60000013
 sp : df1d1f78  ip : df1d0000  fp : 00000004
 r10: 00000000  r9 : c041389c  r8 : c0413848
 r7 : df1d1f7c  r6 : df1b6ecc  r5 : df1b6ec0  r4 : df1d0000
 r3 : 0000000c  r2 : df1d1f6c  r1 : c0360798  r0 : 0000002f
 Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
 Control: 10c53c7d  Table: 5ece804a  DAC: 00000015
 Process rc0 (pid: 577, stack limit = 0xdf1d02f0)

This bug was identified as part of
https://bugzilla.stlinux.com/show_bug.cgi?id=17387 triage.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---

Hi All,
Recently we have noticed a kernel BUG at drivers/media/rc/ir-raw.c:65! 
which shows up very frequently and sometimes even crashes our ARM based board.
Digging a bit, found the reason for this is elements insertion into kfifo is 
not checking the available space in fifo before insertion.

If ir_raw_event_thread is expecting kfifo out to give atleast sizeof(ev) bytes, 
This patch will make sure it inserts only sizeof(ev) into kfifo.

This patch adds a check in ir_raw_event_store to fix this bug,
because kfifo_alloc always rounds the size to power of 2.
  
Thanks,
srini



 drivers/media/rc/ir-raw.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index 95e6309..863eee2 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -92,7 +92,9 @@ int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev)
 	IR_dprintk(2, "sample: (%05dus %s)\n",
 		   TO_US(ev->duration), TO_STR(ev->pulse));
 
-	if (kfifo_in(&dev->raw->kfifo, ev, sizeof(*ev)) != sizeof(*ev))
+	if (kfifo_avail(&dev->raw->kfifo) >= sizeof(*ev))
+		kfifo_in(&dev->raw->kfifo, ev, sizeof(*ev));
+	else
 		return -ENOMEM;
 
 	return 0;
-- 
1.6.3.3

