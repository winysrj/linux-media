Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:36113 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932931AbeAOJ61 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 04:58:27 -0500
From: Sean Young <sean@mess.org>
To: Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 2/5] auxdisplay: charlcd: add flush function
Date: Mon, 15 Jan 2018 09:58:21 +0000
Message-Id: <cdfa0d36f2f2d306e0824205b4fca0b685991ee9.1516008708.git.sean@mess.org>
In-Reply-To: <cover.1516008708.git.sean@mess.org>
References: <cover.1516008708.git.sean@mess.org>
In-Reply-To: <cover.1516008708.git.sean@mess.org>
References: <cover.1516008708.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Sasem Remote Controller has an LCD, which is connnected via usb.
Multiple write reg or write data commands can be combined into one usb
packet.

The latency of usb is such that if we send commands one by one, we get
very obvious tearing on the LCD.

By adding a flush function, we can buffer all commands until either
the usb packet is full or the lcd changes are complete.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/auxdisplay/charlcd.c | 6 ++++++
 include/misc/charlcd.h       | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/auxdisplay/charlcd.c b/drivers/auxdisplay/charlcd.c
index 45ec5ce697c4..a16c72779722 100644
--- a/drivers/auxdisplay/charlcd.c
+++ b/drivers/auxdisplay/charlcd.c
@@ -642,6 +642,9 @@ static ssize_t charlcd_write(struct file *file, const char __user *buf,
 		charlcd_write_char(the_charlcd, c);
 	}
 
+	if (the_charlcd->ops->flush)
+		the_charlcd->ops->flush(the_charlcd);
+
 	return tmp - buf;
 }
 
@@ -703,6 +706,9 @@ static void charlcd_puts(struct charlcd *lcd, const char *s)
 
 		charlcd_write_char(lcd, *tmp);
 	}
+
+	if (lcd->ops->flush)
+		lcd->ops->flush(lcd);
 }
 
 /* initialize the LCD driver */
diff --git a/include/misc/charlcd.h b/include/misc/charlcd.h
index 23f61850f363..ff8fd456018e 100644
--- a/include/misc/charlcd.h
+++ b/include/misc/charlcd.h
@@ -32,6 +32,7 @@ struct charlcd_ops {
 	void (*write_cmd_raw4)(struct charlcd *lcd, int cmd);	/* 4-bit only */
 	void (*clear_fast)(struct charlcd *lcd);
 	void (*backlight)(struct charlcd *lcd, int on);
+	void (*flush)(struct charlcd *lcd);
 };
 
 struct charlcd *charlcd_alloc(unsigned int drvdata_size);
-- 
2.14.3
