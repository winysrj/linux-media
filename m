Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42428 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab2IISBz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Sep 2012 14:01:55 -0400
Received: by mail-ee0-f46.google.com with SMTP id c1so640416eek.19
        for <linux-media@vger.kernel.org>; Sun, 09 Sep 2012 11:01:55 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: hdegoede@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 6/6] gspca_pac7302: extend register documentation
Date: Sun,  9 Sep 2012 20:02:24 +0200
Message-Id: <1347213744-8509-6-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1347213744-8509-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1347213744-8509-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/gspca/pac7302.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/media/usb/gspca/pac7302.c b/drivers/media/usb/gspca/pac7302.c
index 71fa5a4..2d5c6d83 100644
--- a/drivers/media/usb/gspca/pac7302.c
+++ b/drivers/media/usb/gspca/pac7302.c
@@ -29,6 +29,15 @@
  * Register page 0:
  *
  * Address	Description
+ * 0x02		Red balance control
+ * 0x03		Green balance control
+ * 0x04 	Blue balance control
+ *		     Valus are inverted (0=max, 255=min).
+ *		     The Windows driver uses a quadratic approach to map
+ *		     the settable values (0-200) on register values:
+ *		     min=0x80, default=0x40, max=0x20
+ * 0x0f-0x20	Colors, saturation and exposure control
+ * 0xa2-0xab	Brightness, contrast and gamma control
  * 0xb6		Sharpness control (bits 0-4)
  *
  * Register page 1:
-- 
1.7.7

