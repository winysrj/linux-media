Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62645 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536Ab2ENWL3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 18:11:29 -0400
Received: by mail-qc0-f174.google.com with SMTP id o28so3753022qcr.19
        for <linux-media@vger.kernel.org>; Mon, 14 May 2012 15:11:29 -0700 (PDT)
From: Michael Krufky <mkrufky@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 09/11] dvb-usb: increase MAX_NO_OF_FE_PER_ADAP from 2 to 3
Date: Mon, 14 May 2012 18:10:51 -0400
Message-Id: <1337033453-22119-9-git-send-email-mkrufky@linuxtv.org>
In-Reply-To: <1337033453-22119-1-git-send-email-mkrufky@linuxtv.org>
References: <1337033453-22119-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following patch adds support for a third frontend to exist on a single
DVB adapter, in the mxl111sf driver. This patch allows that to be possible.

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 drivers/media/dvb/dvb-usb/dvb-usb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb.h b/drivers/media/dvb/dvb-usb/dvb-usb.h
index 86cfa86..99f9440 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb.h
@@ -157,7 +157,7 @@ struct dvb_usb_adapter_fe_properties {
 	int size_of_priv;
 };
 
-#define MAX_NO_OF_FE_PER_ADAP 2
+#define MAX_NO_OF_FE_PER_ADAP 3
 struct dvb_usb_adapter_properties {
 	int size_of_priv;
 
-- 
1.7.9.5

