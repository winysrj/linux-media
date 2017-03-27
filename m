Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:45450 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753100AbdC0JyA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 05:54:00 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Jose Abreu <Jose.Abreu@synopsys.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec-core.rst: document the new cec_get_drvdata() helper
Message-ID: <119266d8-95c9-4bcf-114e-a5bfdb4144e3@xs4all.nl>
Date: Mon, 27 Mar 2017 11:53:00 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the new cec_get_drvdata() helper function.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/kapi/cec-core.rst b/Documentation/media/kapi/cec-core.rst
index 81c6d8e93774..8ea3a783f968 100644
--- a/Documentation/media/kapi/cec-core.rst
+++ b/Documentation/media/kapi/cec-core.rst
@@ -51,6 +51,7 @@ ops:

 priv:
 	will be stored in adap->priv and can be used by the adapter ops.
+	Use cec_get_drvdata(adap) to get the priv pointer.

 name:
 	the name of the CEC adapter. Note: this name will be copied.
@@ -65,6 +66,10 @@ available_las:
 	the number of simultaneous logical addresses that this
 	adapter can handle. Must be 1 <= available_las <= CEC_MAX_LOG_ADDRS.

+To obtain the priv pointer use this helper function:
+
+.. c:function::
+	void *cec_get_drvdata(const struct cec_adapter *adap);

 To register the /dev/cecX device node and the remote control device (if
 CEC_CAP_RC is set) you call:
