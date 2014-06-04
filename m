Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:53062 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406AbaFDMEW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jun 2014 08:04:22 -0400
From: Antonio Ospite <ao2@ao2.it>
To: Jiri Kosina <trivial@kernel.org>
Cc: Antonio Ospite <ao2@ao2.it>, Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 02/12] trivial: drivers/media/usb/gspca/gspca.h: indent with TABs, not spaces
Date: Wed,  4 Jun 2014 14:03:40 +0200
Message-Id: <1401883430-19492-3-git-send-email-ao2@ao2.it>
In-Reply-To: <1401883430-19492-1-git-send-email-ao2@ao2.it>
References: <1401883430-19492-1-git-send-email-ao2@ao2.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antonio Ospite <ao2@ao2.it>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/usb/gspca/gspca.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/gspca/gspca.h b/drivers/media/usb/gspca/gspca.h
index 300642d..c1273e5 100644
--- a/drivers/media/usb/gspca/gspca.h
+++ b/drivers/media/usb/gspca/gspca.h
@@ -234,6 +234,6 @@ int gspca_resume(struct usb_interface *intf);
 int gspca_expo_autogain(struct gspca_dev *gspca_dev, int avg_lum,
 	int desired_avg_lum, int deadzone, int gain_knee, int exposure_knee);
 int gspca_coarse_grained_expo_autogain(struct gspca_dev *gspca_dev,
-        int avg_lum, int desired_avg_lum, int deadzone);
+	int avg_lum, int desired_avg_lum, int deadzone);
 
 #endif /* GSPCAV2_H */
-- 
2.0.0

