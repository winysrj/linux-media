Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4847 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab3LXPm3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Dec 2013 10:42:29 -0500
Message-ID: <52B9AB5B.3040009@xs4all.nl>
Date: Tue, 24 Dec 2013 16:42:19 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Jim Davis <jim.epost@gmail.com>,
	kbuild test robot <fengguang.wu@intel.com>
Subject: [PATCH for v3.14] sn9c102: fix build dependency
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver should only build if MEDIA_USB_SUPPORT is set.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Jim Davis <jim.epost@gmail.com>
Reported-by: kbuild test robot <fengguang.wu@intel.com>

---
 drivers/staging/media/sn9c102/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/sn9c102/Kconfig b/drivers/staging/media/sn9c102/Kconfig
index d8ae235..c9aba59 100644
--- a/drivers/staging/media/sn9c102/Kconfig
+++ b/drivers/staging/media/sn9c102/Kconfig
@@ -1,6 +1,6 @@
 config USB_SN9C102
 	tristate "USB SN9C1xx PC Camera Controller support (DEPRECATED)"
-	depends on VIDEO_V4L2
+	depends on VIDEO_V4L2 && MEDIA_USB_SUPPORT
 	---help---
 	  This driver is DEPRECATED, please use the gspca sonixb and
 	  sonixj modules instead.
-- 
1.8.5.2

