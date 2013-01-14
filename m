Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfe01.c2i.net ([212.247.154.2]:45252 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751759Ab3ANM7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jan 2013 07:59:31 -0500
Received: from [176.74.213.204] (account mc467741@c2i.net HELO laptop015.hselasky.homeunix.org)
  by mailfe01.swip.net (CommuniGate Pro SMTP 5.4.4)
  with ESMTPA id 370893116 for linux-media@vger.kernel.org; Mon, 14 Jan 2013 13:54:26 +0100
From: Hans Petter Selasky <hselasky@c2i.net>
To: linux-media@vger.kernel.org
Subject: [PATCH] Correctly set data for USB request in case of a previous failure.
Date: Mon, 14 Jan 2013 13:55:52 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201301141355.52394.hselasky@c2i.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 89326793e2429dc55d951f336b3e3e3b73bedb95 Mon Sep 17 00:00:00 2001
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 14 Jan 2013 13:53:21 +0100
Subject: [PATCH] Correctly set data for USB request in case of a previous
 failure.

Found-by: Jan Beich
Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
---
 drivers/input/tablet/wacom_sys.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index f92d34f..aaf23ae 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -553,10 +553,10 @@ static int wacom_set_device_mode(struct usb_interface *intf, int report_id, int
 	if (!rep_data)
 		return error;
 
-	rep_data[0] = report_id;
-	rep_data[1] = mode;
-
 	do {
+		rep_data[0] = report_id;
+		rep_data[1] = mode;
+
 		error = wacom_set_report(intf, WAC_HID_FEATURE_REPORT,
 		                         report_id, rep_data, length, 1);
 		if (error >= 0)
-- 
1.7.11.4

