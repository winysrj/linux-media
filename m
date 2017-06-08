Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:45820 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751445AbdFHSiH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Jun 2017 14:38:07 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media/cec.h: use IS_REACHABLE instead of IS_ENABLED
Message-ID: <24323dd2-ca79-5938-d823-43ab9ef04bd5@xs4all.nl>
Date: Thu, 8 Jun 2017 20:37:44 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix messages like this:

adv7842.c:(.text+0x2edadd): undefined reference to `cec_unregister_adapter'

when CEC_CORE=m but the driver including media/cec.h is built-in. In that case
the static inlines provided in media/cec.h should be used by that driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/include/media/cec.h b/include/media/cec.h
index bfa88d4d67e1..201f060978da 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -206,7 +206,7 @@ static inline bool cec_is_sink(const struct cec_adapter *adap)
 #define cec_phys_addr_exp(pa) \
 	((pa) >> 12), ((pa) >> 8) & 0xf, ((pa) >> 4) & 0xf, (pa) & 0xf

-#if IS_ENABLED(CONFIG_CEC_CORE)
+#if IS_REACHABLE(CONFIG_CEC_CORE)
 struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 		void *priv, const char *name, u32 caps, u8 available_las);
 int cec_register_adapter(struct cec_adapter *adap, struct device *parent);
