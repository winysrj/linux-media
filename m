Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:52778 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751905AbdF3OfP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 10:35:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Eric Anholt <eric@anholt.net>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 03/12] cec: add adap_free op
Date: Fri, 30 Jun 2017 16:35:00 +0200
Message-Id: <20170630143509.56029-4-hverkuil@xs4all.nl>
In-Reply-To: <20170630143509.56029-1-hverkuil@xs4all.nl>
References: <20170630143509.56029-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is needed for CEC adapters that allocate resources that have
to be freed before the cec_adapter is deleted.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-core.c | 2 ++
 include/media/cec.h          | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index b516d599d6c4..2e5765344d07 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -374,6 +374,8 @@ void cec_delete_adapter(struct cec_adapter *adap)
 	kthread_stop(adap->kthread);
 	if (adap->kthread_config)
 		kthread_stop(adap->kthread_config);
+	if (adap->ops->adap_free)
+		adap->ops->adap_free(adap);
 #ifdef CONFIG_MEDIA_CEC_RC
 	rc_free_device(adap->rc);
 #endif
diff --git a/include/media/cec.h b/include/media/cec.h
index e1e60dbb66c3..37768203572d 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -114,6 +114,7 @@ struct cec_adap_ops {
 	int (*adap_transmit)(struct cec_adapter *adap, u8 attempts,
 			     u32 signal_free_time, struct cec_msg *msg);
 	void (*adap_status)(struct cec_adapter *adap, struct seq_file *file);
+	void (*adap_free)(struct cec_adapter *adap);
 
 	/* High-level CEC message callback */
 	int (*received)(struct cec_adapter *adap, struct cec_msg *msg);
-- 
2.11.0
