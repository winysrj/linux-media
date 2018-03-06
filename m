Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44156 "EHLO
        homiemail-a48.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753851AbeCFTPI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Mar 2018 14:15:08 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 6/8] cx231xx: Use constant instead of hard code for max
Date: Tue,  6 Mar 2018 13:15:00 -0600
Message-Id: <1520363702-25536-7-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1520363702-25536-1-git-send-email-brad@nextdimension.cc>
References: <1520363702-25536-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Nit regarding hard coded value.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/usb/cx231xx/cx231xx-dvb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 9d326a0..21e7817 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -53,9 +53,10 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 #define CX231XX_DVB_NUM_BUFS 5
 #define CX231XX_DVB_MAX_PACKETSIZE 564
 #define CX231XX_DVB_MAX_PACKETS 64
+#define CX231XX_DVB_MAX_FRONTENDS 2
 
 struct cx231xx_dvb {
-	struct dvb_frontend *frontend[2];
+	struct dvb_frontend *frontend[CX231XX_DVB_MAX_FRONTENDS];
 
 	/* feed count management */
 	struct mutex lock;
-- 
2.7.4
