Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:44857 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751437AbdB0OYy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 09:24:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/9] cec: return -EPERM when no LAs are configured
Date: Mon, 27 Feb 2017 15:20:37 +0100
Message-Id: <20170227142042.37085-5-hverkuil@xs4all.nl>
In-Reply-To: <20170227142042.37085-1-hverkuil@xs4all.nl>
References: <20170227142042.37085-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The CEC_TRANSMIT ioctl now returns -EPERM if an attempt is made to
transmit a message for an unconfigured adapter (i.e. userspace
never called CEC_ADAP_S_LOG_ADDRS).

This differentiates this case from when LAs are configured, but no
physical address is set. In that case -ENONET is returned.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-api.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/cec/cec-api.c b/drivers/media/cec/cec-api.c
index 627cdf7b12d1..cea350ea2a52 100644
--- a/drivers/media/cec/cec-api.c
+++ b/drivers/media/cec/cec-api.c
@@ -198,7 +198,9 @@ static long cec_transmit(struct cec_adapter *adap, struct cec_fh *fh,
 		return -EINVAL;
 
 	mutex_lock(&adap->lock);
-	if (adap->is_configuring)
+	if (adap->log_addrs.num_log_addrs == 0)
+		err = -EPERM;
+	else if (adap->is_configuring)
 		err = -ENONET;
 	else if (!adap->is_configured && (msg.msg[0] != 0xf0 || msg.reply))
 		err = -ENONET;
-- 
2.11.0
