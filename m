Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:64404 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757133Ab0HCSSk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Aug 2010 14:18:40 -0400
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, hpa@zytor.com,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] V4L/DVB: ir-code: Add missing "select BITREVERSE"
Date: Tue,  3 Aug 2010 11:18:28 -0700
Message-Id: <1280859508-25357-1-git-send-email-hpa@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Sony and JVC IR drivers use bitreverse but don't properly encode
the dependency.

Found by randconfig builds.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: David Härdeman <david@hardeman.nu>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/IR/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/IR/Kconfig b/drivers/media/IR/Kconfig
index d22a8ec..6cd93b4 100644
--- a/drivers/media/IR/Kconfig
+++ b/drivers/media/IR/Kconfig
@@ -42,6 +42,7 @@ config IR_RC6_DECODER
 config IR_JVC_DECODER
 	tristate "Enable IR raw decoder for the JVC protocol"
 	depends on IR_CORE
+	select BITREVERSE
 	default y
 
 	---help---
@@ -51,6 +52,7 @@ config IR_JVC_DECODER
 config IR_SONY_DECODER
 	tristate "Enable IR raw decoder for the Sony protocol"
 	depends on IR_CORE
+	select BITREVERSE
 	default y
 
 	---help---
-- 
1.7.2

