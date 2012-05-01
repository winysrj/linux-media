Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38849 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab2EAEMu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 May 2012 00:12:50 -0400
Received: by mail-vx0-f174.google.com with SMTP id p1so2537594vcq.19
        for <linux-media@vger.kernel.org>; Mon, 30 Apr 2012 21:12:50 -0700 (PDT)
From: Michael Krufky <mkrufky@kernellabs.com>
To: linux-media <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 09/10] dvb-usb: increase MAX_NO_OF_FE_PER_ADAP from 2 to 3
Date: Tue,  1 May 2012 00:12:24 -0400
Message-Id: <1335845545-20879-9-git-send-email-mkrufky@linuxtv.org>
In-Reply-To: <1335845545-20879-1-git-send-email-mkrufky@linuxtv.org>
References: <1335845545-20879-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 drivers/media/dvb/dvb-usb/dvb-usb.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
1.7.5.4

