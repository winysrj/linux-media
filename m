Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35471 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754794AbcHVJFM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 05:05:12 -0400
Received: by mail-wm0-f67.google.com with SMTP id i5so12450654wmg.2
        for <linux-media@vger.kernel.org>; Mon, 22 Aug 2016 02:05:11 -0700 (PDT)
From: Johan Fjeldtvedt <jaffe1@gmail.com>
To: linux-media@vger.kernel.org
Cc: Johan Fjeldtvedt <jaffe1@gmail.com>
Subject: [PATCHv2 1/4] cec: allow configuration both from within driver and from user space
Date: Mon, 22 Aug 2016 11:04:51 +0200
Message-Id: <1471856694-14182-2-git-send-email-jaffe1@gmail.com>
In-Reply-To: <1471856694-14182-1-git-send-email-jaffe1@gmail.com>
References: <1471856694-14182-1-git-send-email-jaffe1@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It makes sense for adapters such as the Pulse-Eight to be configurable
both from within the driver and from user space, so remove the
requirement that drivers only can call cec_s_log_addrs or
cec_s_phys_addr if they don't expose those capabilities to user space.

Signed-off-by: Johan Fjeldtvedt <jaffe1@gmail.com>
---
 drivers/staging/media/cec/cec-adap.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index b2393bb..608e3e7 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -1153,8 +1153,6 @@ void cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block)
 	if (IS_ERR_OR_NULL(adap))
 		return;
 
-	if (WARN_ON(adap->capabilities & CEC_CAP_PHYS_ADDR))
-		return;
 	mutex_lock(&adap->lock);
 	__cec_s_phys_addr(adap, phys_addr, block);
 	mutex_unlock(&adap->lock);
@@ -1295,8 +1293,6 @@ int cec_s_log_addrs(struct cec_adapter *adap,
 {
 	int err;
 
-	if (WARN_ON(adap->capabilities & CEC_CAP_LOG_ADDRS))
-		return -EINVAL;
 	mutex_lock(&adap->lock);
 	err = __cec_s_log_addrs(adap, log_addrs, block);
 	mutex_unlock(&adap->lock);
-- 
2.7.4

