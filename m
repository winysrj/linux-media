Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34268 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461Ab2JURxp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Oct 2012 13:53:45 -0400
Received: by mail-wi0-f178.google.com with SMTP id hr7so1752706wib.1
        for <linux-media@vger.kernel.org>; Sun, 21 Oct 2012 10:53:44 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 18/23] em28xx: add fields for analog and DVB USB transfer type selection to struct em28xx
Date: Sun, 21 Oct 2012 19:52:24 +0300
Message-Id: <1350838349-14763-20-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx.h |    4 ++++
 1 Datei geändert, 4 Zeilen hinzugefügt(+)

diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 8b96413..f013650 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -587,9 +587,13 @@ struct em28xx {
 	int max_pkt_size;	/* max packet size of the selected ep at alt */
 	int num_alt;		/* number of alternative settings */
 	unsigned int *alt_max_pkt_size_isoc; /* array of isoc wMaxPacketSize */
+	unsigned int analog_xfer_bulk:1;	/* use bulk instead of isoc
+						   transfers for analog      */
 	int dvb_alt_isoc;	/* alternate setting for DVB isoc transfers */
 	unsigned int dvb_max_pkt_size_isoc;	/* isoc max packet size of the
 						   selected DVB ep at dvb_alt */
+	unsigned int dvb_xfer_bulk:1;		/* use bulk instead of isoc
+						   transfers for DVB          */
 	char urb_buf[URB_MAX_CTRL_SIZE];	/* urb control msg buffer */
 
 	/* helper funcs that call usb_control_msg */
-- 
1.7.10.4

