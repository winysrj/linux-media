Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfe05.c2i.net ([212.247.154.130]:33581 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756300Ab3ANPE5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jan 2013 10:04:57 -0500
Received: from [176.74.213.204] (account mc467741@c2i.net HELO laptop015.hselasky.homeunix.org)
  by mailfe05.swip.net (CommuniGate Pro SMTP 5.4.4)
  with ESMTPA id 363335668 for linux-media@vger.kernel.org; Mon, 14 Jan 2013 16:04:54 +0100
From: Hans Petter Selasky <hselasky@c2i.net>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] Correctly set data for USB request in case of a previous failure.
Date: Mon, 14 Jan 2013 16:06:20 +0100
References: <201301141355.52394.hselasky@c2i.net>
In-Reply-To: <201301141355.52394.hselasky@c2i.net>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201301141606.20156.hselasky@c2i.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Improved patch follows:

--HPS

>From a88d72d2108f92f004a3f050a708d9b7f661f924 Mon Sep 17 00:00:00 2001
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 14 Jan 2013 13:53:21 +0100
Subject: [PATCH] Correctly initialize data for USB request.

Found-by: Jan Beich
Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
---
 drivers/input/tablet/wacom.h     | 1 +
 drivers/input/tablet/wacom_sys.c | 8 +++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/input/tablet/wacom.h b/drivers/input/tablet/wacom.h
index b79d451..d6fad87 100644
--- a/drivers/input/tablet/wacom.h
+++ b/drivers/input/tablet/wacom.h
@@ -89,6 +89,7 @@
 #include <linux/init.h>
 #include <linux/usb/input.h>
 #include <linux/power_supply.h>
+#include <linux/string.h>
 #include <asm/unaligned.h>
 
 /*
diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index f92d34f..23bc71e 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -553,10 +553,12 @@ static int wacom_set_device_mode(struct usb_interface *intf, int report_id, int
 	if (!rep_data)
 		return error;
 
-	rep_data[0] = report_id;
-	rep_data[1] = mode;
-
 	do {
+		memset(rep_data, 0, length);
+
+		rep_data[0] = report_id;
+		rep_data[1] = mode;
+
 		error = wacom_set_report(intf, WAC_HID_FEATURE_REPORT,
 		                         report_id, rep_data, length, 1);
 		if (error >= 0)
-- 
1.7.11.4

