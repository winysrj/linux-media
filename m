Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48570 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab2IWN3e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Sep 2012 09:29:34 -0400
Received: by wgbdr13 with SMTP id dr13so2873853wgb.1
        for <linux-media@vger.kernel.org>; Sun, 23 Sep 2012 06:29:33 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: hdegoede@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 1/4] gspca_pac7302: correct register documentation
Date: Sun, 23 Sep 2012 15:29:42 +0200
Message-Id: <1348406983-3451-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

R,G,B balance registers are 0x01-0x03 instead of 0x02-0x04,
which lead to the wrong conclusion that values are inverted.
Exposure is controlled via page 3 registers and this is already documented.
Also fix a whitespace issue.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/gspca/pac7302.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/gspca/pac7302.c b/drivers/media/usb/gspca/pac7302.c
index 2d5c6d83..4894ac1 100644
--- a/drivers/media/usb/gspca/pac7302.c
+++ b/drivers/media/usb/gspca/pac7302.c
@@ -29,14 +29,13 @@
  * Register page 0:
  *
  * Address	Description
- * 0x02		Red balance control
- * 0x03		Green balance control
- * 0x04 	Blue balance control
- *		     Valus are inverted (0=max, 255=min).
+ * 0x01		Red balance control
+ * 0x02		Green balance control
+ * 0x03		Blue balance control
  *		     The Windows driver uses a quadratic approach to map
  *		     the settable values (0-200) on register values:
- *		     min=0x80, default=0x40, max=0x20
- * 0x0f-0x20	Colors, saturation and exposure control
+ *		     min=0x20, default=0x40, max=0x80
+ * 0x0f-0x20	Color and saturation control
  * 0xa2-0xab	Brightness, contrast and gamma control
  * 0xb6		Sharpness control (bits 0-4)
  *
-- 
1.7.7

