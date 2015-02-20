Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay107.isp.belgacom.be ([195.238.20.134]:8656 "EHLO
	mailrelay107.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932166AbbBTSNI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2015 13:13:08 -0500
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Fabian Frederick <fabf@skynet.be>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 4/7 linux-next] saa7146: replace current->state by set_current_state()
Date: Fri, 20 Feb 2015 19:12:54 +0100
Message-Id: <1424455977-21903-4-git-send-email-fabf@skynet.be>
In-Reply-To: <1424455977-21903-1-git-send-email-fabf@skynet.be>
References: <1424455977-21903-1-git-send-email-fabf@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use helper functions to access current->state.
Direct assignments are prone to races and therefore buggy.

current->state = TASK_RUNNING can be replaced by __set_current_state()

Thanks to Peter Zijlstra for the exact definition of the problem.

Suggested-By: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/media/common/saa7146/saa7146_vbi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/saa7146/saa7146_vbi.c b/drivers/media/common/saa7146/saa7146_vbi.c
index 1e71e37..2da9957 100644
--- a/drivers/media/common/saa7146/saa7146_vbi.c
+++ b/drivers/media/common/saa7146/saa7146_vbi.c
@@ -95,7 +95,7 @@ static int vbi_workaround(struct saa7146_dev *dev)
 
 		/* prepare to wait to be woken up by the irq-handler */
 		add_wait_queue(&vv->vbi_wq, &wait);
-		current->state = TASK_INTERRUPTIBLE;
+		set_current_state(TASK_INTERRUPTIBLE);
 
 		/* start rps1 to enable workaround */
 		saa7146_write(dev, RPS_ADDR1, dev->d_rps1.dma_handle);
@@ -106,7 +106,7 @@ static int vbi_workaround(struct saa7146_dev *dev)
 		DEB_VBI("brs bug workaround %d/1\n", i);
 
 		remove_wait_queue(&vv->vbi_wq, &wait);
-		current->state = TASK_RUNNING;
+		__set_current_state(TASK_RUNNING);
 
 		/* disable rps1 irqs */
 		SAA7146_IER_DISABLE(dev,MASK_28);
-- 
2.1.0

