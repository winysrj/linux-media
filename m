Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932766Ab2GKPrF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 11:47:05 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5/5] radio-si470x: Lower firmware version requirements
Date: Wed, 11 Jul 2012 17:47:38 +0200
Message-Id: <1342021658-27821-6-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1342021658-27821-1-git-send-email-hdegoede@redhat.com>
References: <1342021658-27821-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Testing with a firmware version 12 usb radio stick has shown version 12
to work fine too.

Reported-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/radio/si470x/radio-si470x.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/si470x/radio-si470x.h b/drivers/media/radio/si470x/radio-si470x.h
index 8e3a62f..2f089b4 100644
--- a/drivers/media/radio/si470x/radio-si470x.h
+++ b/drivers/media/radio/si470x/radio-si470x.h
@@ -190,7 +190,7 @@ struct si470x_device {
  * Firmware Versions
  **************************************************************************/
 
-#define RADIO_FW_VERSION	14
+#define RADIO_FW_VERSION	12
 
 
 
-- 
1.7.10.4

