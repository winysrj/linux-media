Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:58396 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751250AbdHEK21 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 5 Aug 2017 06:28:27 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec-ioc-adap-g-log-addrs.rst: fix wrong quotes
Message-ID: <27795657-4e58-74d2-c3a7-be72c28a31cd@xs4all.nl>
Date: Sat, 5 Aug 2017 12:28:25 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

`CEC_LOG_ADDRS_FL_CDC_ONLY` should be ``CEC_LOG_ADDRS_FL_CDC_ONLY``.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
index 91cecc4d69cb..b25e003a04d7 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
@@ -175,7 +175,7 @@ logical address types are already defined will return with error ``EBUSY``.
 	to avoid trivial snooping of the keystrokes.
     * .. _`CEC-LOG-ADDRS-FL-CDC-ONLY`:

-      - `CEC_LOG_ADDRS_FL_CDC_ONLY`
+      - ``CEC_LOG_ADDRS_FL_CDC_ONLY``
       - 4
       - If this flag is set, then the device is CDC-Only. CDC-Only CEC devices
 	are CEC devices that can only handle CDC messages.
-- 
2.13.2
