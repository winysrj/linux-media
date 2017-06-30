Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:54645 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751840AbdF3OfP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 10:35:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Eric Anholt <eric@anholt.net>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 04/12] cec-core.rst: document the adap_free callback
Date: Fri, 30 Jun 2017 16:35:01 +0200
Message-Id: <20170630143509.56029-5-hverkuil@xs4all.nl>
In-Reply-To: <20170630143509.56029-1-hverkuil@xs4all.nl>
References: <20170630143509.56029-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document what this callback does.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/kapi/cec-core.rst | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/kapi/cec-core.rst b/Documentation/media/kapi/cec-core.rst
index 8a65c69ed071..6ea2c9c80182 100644
--- a/Documentation/media/kapi/cec-core.rst
+++ b/Documentation/media/kapi/cec-core.rst
@@ -107,6 +107,7 @@ your driver:
 		int (*adap_transmit)(struct cec_adapter *adap, u8 attempts,
 				      u32 signal_free_time, struct cec_msg *msg);
 		void (*adap_status)(struct cec_adapter *adap, struct seq_file *file);
+		void (*adap_free)(struct cec_adapter *adap);
 
 		/* High-level callbacks */
 		...
@@ -181,8 +182,13 @@ To log the current CEC hardware status:
 .. c:function::
 	void (*adap_status)(struct cec_adapter *adap, struct seq_file *file);
 
-This optional callback can be used to show the status of the CEC hardware.
-The status is available through debugfs: cat /sys/kernel/debug/cec/cecX/status
+To free any resources when the adapter is deleted:
+
+.. c:function::
+	void (*adap_free)(struct cec_adapter *adap);
+
+This optional callback can be used to free any resources that might have been
+allocated by the driver. It's called from cec_delete_adapter.
 
 
 Your adapter driver will also have to react to events (typically interrupt
-- 
2.11.0
