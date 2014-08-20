Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3200 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbaHTW7r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 18:59:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 23/29] dvb_usb_core: fix sparse warning
Date: Thu, 21 Aug 2014 00:59:22 +0200
Message-Id: <1408575568-20562-24-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:24:5: warning: symbol 'dvb_usbv2_disable_rc_polling' was not declared. Should it be static?

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 45f5ee9..fc40d67 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -21,7 +21,7 @@
 
 #include "dvb_usb_common.h"
 
-int dvb_usbv2_disable_rc_polling;
+static int dvb_usbv2_disable_rc_polling;
 module_param_named(disable_rc_polling, dvb_usbv2_disable_rc_polling, int, 0644);
 MODULE_PARM_DESC(disable_rc_polling,
 		"disable remote control polling (default: 0)");
-- 
2.1.0.rc1

