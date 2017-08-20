Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:38845 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752879AbdHTLxZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 07:53:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/4] cec: ensure that adap_enable(false) is called from cec_delete_adapter()
Date: Sun, 20 Aug 2017 13:53:19 +0200
Message-Id: <20170820115319.26244-5-hverkuil@xs4all.nl>
In-Reply-To: <20170820115319.26244-1-hverkuil@xs4all.nl>
References: <20170820115319.26244-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

When the adapter is removed the cec_delete_adapter() call attempts
to set the physical address to INVALID by calling __cec_s_phys_addr()
and so disabling the adapter.

However, __cec_s_phys_addr checks if the device node was unregistered
and just returns in that case.

This means that the adap_enable callback is never called with 'false'
to disable the CEC adapter. Most drivers don't care, but some need
to do cleanup here.

Change the test so the adapter is correctly disabled, even when the
device node is unregistered.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
---
 drivers/media/cec/cec-adap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 8ac39ddf892c..491f3665de22 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1447,7 +1447,9 @@ static void cec_claim_log_addrs(struct cec_adapter *adap, bool block)
  */
 void __cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block)
 {
-	if (phys_addr == adap->phys_addr || adap->devnode.unregistered)
+	if (phys_addr == adap->phys_addr)
+		return;
+	if (phys_addr != CEC_PHYS_ADDR_INVALID && adap->devnode.unregistered)
 		return;
 
 	dprintk(1, "new physical address %x.%x.%x.%x\n",
-- 
2.14.1
