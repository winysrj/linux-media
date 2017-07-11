Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:41705 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754784AbdGKGas (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 02:30:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 04/11] cec-core.rst: document the adap_free callback
Date: Tue, 11 Jul 2017 08:30:37 +0200
Message-Id: <20170711063044.29849-5-hverkuil@xs4all.nl>
In-Reply-To: <20170711063044.29849-1-hverkuil@xs4all.nl>
References: <20170711063044.29849-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document what this callback does.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/kapi/cec-core.rst | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/media/kapi/cec-core.rst b/Documentation/media/kapi/cec-core.rst
index 8a65c69ed071..bb066b2b26f8 100644
--- a/Documentation/media/kapi/cec-core.rst
+++ b/Documentation/media/kapi/cec-core.rst
@@ -107,6 +107,7 @@ your driver:
 		int (*adap_transmit)(struct cec_adapter *adap, u8 attempts,
 				      u32 signal_free_time, struct cec_msg *msg);
 		void (*adap_status)(struct cec_adapter *adap, struct seq_file *file);
+		void (*adap_free)(struct cec_adapter *adap);
 
 		/* High-level callbacks */
 		...
@@ -184,6 +185,14 @@ To log the current CEC hardware status:
 This optional callback can be used to show the status of the CEC hardware.
 The status is available through debugfs: cat /sys/kernel/debug/cec/cecX/status
 
+To free any resources when the adapter is deleted:
+
+.. c:function::
+	void (*adap_free)(struct cec_adapter *adap);
+
+This optional callback can be used to free any resources that might have been
+allocated by the driver. It's called from cec_delete_adapter.
+
 
 Your adapter driver will also have to react to events (typically interrupt
 driven) by calling into the framework in the following situations:
-- 
2.11.0
