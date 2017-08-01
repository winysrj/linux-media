Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:55788 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751612AbdHALxg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 1 Aug 2017 07:53:36 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec-funcs.h: cec_ops_report_features: set *dev_features to
 NULL
Message-ID: <00e6e778-b475-3281-6b21-028a251d16c5@xs4all.nl>
Date: Tue, 1 Aug 2017 13:53:30 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

gcc can get confused by this code and it thinks dev_features can be
returned uninitialized. So initialize to NULL at the beginning to shut up
the warning.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/include/uapi/linux/cec-funcs.h b/include/uapi/linux/cec-funcs.h
index c451eec42a83..270b251a3d9b 100644
--- a/include/uapi/linux/cec-funcs.h
+++ b/include/uapi/linux/cec-funcs.h
@@ -895,6 +895,7 @@ static inline void cec_ops_report_features(const struct cec_msg *msg,
 	*cec_version = msg->msg[2];
 	*all_device_types = msg->msg[3];
 	*rc_profile = p;
+	*dev_features = NULL;
 	while (p < &msg->msg[14] && (*p & CEC_OP_FEAT_EXT))
 		p++;
 	if (!(*p & CEC_OP_FEAT_EXT)) {
