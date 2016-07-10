Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:43413 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753677AbcGJNLc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 09:11:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: lars@opdenkamp.eu, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/5] cec: add check if adapter is unregistered.
Date: Sun, 10 Jul 2016 15:11:17 +0200
Message-Id: <1468156281-25731-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1468156281-25731-1-git-send-email-hverkuil@xs4all.nl>
References: <1468156281-25731-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

CEC USB dongles can be unplugged at any time, and at that point they will
be unregistered. Make sure that any attempt afterwards to set the physical
or logical addresses will be ignored.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/cec/cec-adap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index 7df6187..2cd656b 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -1104,7 +1104,7 @@ static void cec_claim_log_addrs(struct cec_adapter *adap, bool block)
  */
 void __cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block)
 {
-	if (phys_addr == adap->phys_addr)
+	if (phys_addr == adap->phys_addr || adap->devnode.unregistered)
 		return;
 
 	if (phys_addr == CEC_PHYS_ADDR_INVALID ||
@@ -1158,6 +1158,9 @@ int __cec_s_log_addrs(struct cec_adapter *adap,
 	u16 type_mask = 0;
 	int i;
 
+	if (adap->devnode.unregistered)
+		return -ENODEV;
+
 	if (!log_addrs || log_addrs->num_log_addrs == 0) {
 		adap->log_addrs.num_log_addrs = 0;
 		cec_adap_unconfigure(adap);
-- 
2.8.1

