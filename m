Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:36342 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751610AbdIRK0I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 06:26:08 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec-ioc-dqevent.rst: fix typo
Message-ID: <cc6d16bf-f717-52ff-bf57-0f2a0c6aab75@xs4all.nl>
Date: Mon, 18 Sep 2017 12:26:03 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The documentation talked about INITIAL_VALUE when the actual define is
INITIAL_STATE.

Fix this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Jonas Karlman <jonas@kwiboo.se>
---
diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index a5c821809cc6..4fe96e2adf4c 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -172,9 +172,9 @@ it is guaranteed that the state did change in between the two events.
     :stub-columns: 0
     :widths:       3 1 8

-    * .. _`CEC-EVENT-FL-INITIAL-VALUE`:
+    * .. _`CEC-EVENT-FL-INITIAL-STATE`:

-      - ``CEC_EVENT_FL_INITIAL_VALUE``
+      - ``CEC_EVENT_FL_INITIAL_STATE``
       - 1
       - Set for the initial events that are generated when the device is
 	opened. See the table above for which events do this. This allows
