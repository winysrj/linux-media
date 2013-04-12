Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45873 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282Ab3DLSAI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 14:00:08 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/3] rc: fix single line indentation of keymaps/Makefile
Date: Fri, 12 Apr 2013 20:59:04 +0300
Message-Id: <1365789544-18819-3-git-send-email-crope@iki.fi>
In-Reply-To: <1365789544-18819-1-git-send-email-crope@iki.fi>
References: <1365789544-18819-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/rc/keymaps/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index 04baac4..5ab94ea 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -89,7 +89,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-tevii-nec.o \
 			rc-tivo.o \
 			rc-total-media-in-hand.o \
-                       rc-total-media-in-hand-02.o \
+			rc-total-media-in-hand-02.o \
 			rc-trekstor.o \
 			rc-tt-1500.o \
 			rc-twinhan1027.o \
-- 
1.7.11.7

