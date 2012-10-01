Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:40447 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab2JAHeH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2012 03:34:07 -0400
Received: by mail-wi0-f170.google.com with SMTP id hm2so2898293wib.1
        for <linux-media@vger.kernel.org>; Mon, 01 Oct 2012 00:34:06 -0700 (PDT)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Patrick Boettcher <pboettcher@kernellabs.com>
Subject: [PATCH] [media]: add MODULE_DEVICE_TABLE to technisat-usb2
Date: Mon,  1 Oct 2012 09:33:53 +0200
Message-Id: <1349076833-1864-2-git-send-email-pboettcher@kernellabs.com>
In-Reply-To: <1349076833-1864-1-git-send-email-pboettcher@kernellabs.com>
References: <1349076833-1864-1-git-send-email-pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a module-device-table-entry to the
technisat-usb2-driver which will help udev to on-demand load the
driver. This was obviously forgotten during initial commit.

Signed-off-by: Patrick Boettcher <pboettcher@kernellabs.com>
---
 drivers/media/usb/dvb-usb/technisat-usb2.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/dvb-usb/technisat-usb2.c b/drivers/media/usb/dvb-usb/technisat-usb2.c
index acefaa8..7a8c8c1 100644
--- a/drivers/media/usb/dvb-usb/technisat-usb2.c
+++ b/drivers/media/usb/dvb-usb/technisat-usb2.c
@@ -677,6 +677,7 @@ static struct usb_device_id technisat_usb2_id_table[] = {
 	{ USB_DEVICE(USB_VID_TECHNISAT, USB_PID_TECHNISAT_USB2_DVB_S2) },
 	{ 0 }		/* Terminating entry */
 };
+MODULE_DEVICE_TABLE(usb, technisat_usb2_id_table);
 
 /* device description */
 static struct dvb_usb_device_properties technisat_usb2_devices = {
-- 
1.7.9.5

