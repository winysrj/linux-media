Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52789 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932541AbcKPSKz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 13:10:55 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH] [media] cec-ioc-adap-g-log-addrs.rst: describe CEC_LOG_ADDRS_FL_CDC_ONLY
Date: Wed, 16 Nov 2016 16:10:40 -0200
Message-Id: <71334ae42d6b450efeac656dbb254bcf787f5ac7.1479319838.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CEC_LOG_ADDRS_FL_CDC_ONLY flag is missing at the documentation,
causing this warning:
	Documentation/output/cec.h.rst:6: WARNING: undefined label: cec-log-addrs-fl-cdc-only (if the link has no caption the label must precede a section header)

Add a documentation for it, based on the commit that introduced the
flag.

Fixes: a69a168a1bd4 ("[media] cec: add proper support for CDC-Only CEC devices")
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
index 571ae57b75ae..b878637e91b3 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
@@ -176,6 +176,15 @@ logical address types are already defined will return with error ``EBUSY``.
 	and will appear as keystrokes. This features needs to be enabled explicitly.
 	If CEC is used to enter e.g. passwords, then you may not want to enable this
 	to avoid trivial snooping of the keystrokes.
+    * .. _`CEC-LOG-ADDRS-FL-CDC-ONLY`:
+
+      - `CEC_LOG_ADDRS_FL_CDC_ONLY`
+      - 4
+      - If this flag is set, then the device is CDC-Only. CDC-Only CEC devices
+	are CEC devices that can only handle CDC messages.
+
+	All other messages are ignored.
+
 
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
-- 
2.7.4

