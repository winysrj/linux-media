Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:50777 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753043AbdK2Kqj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 05:46:39 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sean Young <sean@mess.org>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 11/12] media: imon: don't use kernel-doc "/**" markups
Date: Wed, 29 Nov 2017 05:46:32 -0500
Message-Id: <255940e642387ffe886fd881ffc9917f31fe0564.1511952372.git.mchehab@s-opensource.com>
In-Reply-To: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
References: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
In-Reply-To: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
References: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function documentation here doesn't follow kernel-doc,
as parameters aren't documented. So, stop abusing on
"/**" markups.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/rc/imon.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index b25b35b3f6da..eb943e862515 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -492,7 +492,7 @@ static void free_imon_context(struct imon_context *ictx)
 	dev_dbg(dev, "%s: iMON context freed\n", __func__);
 }
 
-/**
+/*
  * Called when the Display device (e.g. /dev/lcd0)
  * is opened by the application.
  */
@@ -542,7 +542,7 @@ static int display_open(struct inode *inode, struct file *file)
 	return retval;
 }
 
-/**
+/*
  * Called when the display device (e.g. /dev/lcd0)
  * is closed by the application.
  */
@@ -575,7 +575,7 @@ static int display_close(struct inode *inode, struct file *file)
 	return retval;
 }
 
-/**
+/*
  * Sends a packet to the device -- this function must be called with
  * ictx->lock held, or its unlock/lock sequence while waiting for tx
  * to complete can/will lead to a deadlock.
@@ -664,7 +664,7 @@ static int send_packet(struct imon_context *ictx)
 	return retval;
 }
 
-/**
+/*
  * Sends an associate packet to the iMON 2.4G.
  *
  * This might not be such a good idea, since it has an id collision with
@@ -694,7 +694,7 @@ static int send_associate_24g(struct imon_context *ictx)
 	return retval;
 }
 
-/**
+/*
  * Sends packets to setup and show clock on iMON display
  *
  * Arguments: year - last 2 digits of year, month - 1..12,
@@ -781,7 +781,7 @@ static int send_set_imon_clock(struct imon_context *ictx,
 	return retval;
 }
 
-/**
+/*
  * These are the sysfs functions to handle the association on the iMON 2.4G LT.
  */
 static ssize_t show_associate_remote(struct device *d,
@@ -823,7 +823,7 @@ static ssize_t store_associate_remote(struct device *d,
 	return count;
 }
 
-/**
+/*
  * sysfs functions to control internal imon clock
  */
 static ssize_t show_imon_clock(struct device *d,
@@ -923,7 +923,7 @@ static const struct attribute_group imon_rf_attr_group = {
 	.attrs = imon_rf_sysfs_entries
 };
 
-/**
+/*
  * Writes data to the VFD.  The iMON VFD is 2x16 characters
  * and requires data in 5 consecutive USB interrupt packets,
  * each packet but the last carrying 7 bytes.
@@ -1008,7 +1008,7 @@ static ssize_t vfd_write(struct file *file, const char __user *buf,
 	return (!retval) ? n_bytes : retval;
 }
 
-/**
+/*
  * Writes data to the LCD.  The iMON OEM LCD screen expects 8-byte
  * packets. We accept data as 16 hexadecimal digits, followed by a
  * newline (to make it easy to drive the device from a command-line
@@ -1066,7 +1066,7 @@ static ssize_t lcd_write(struct file *file, const char __user *buf,
 	return (!retval) ? n_bytes : retval;
 }
 
-/**
+/*
  * Callback function for USB core API: transmit data
  */
 static void usb_tx_callback(struct urb *urb)
@@ -1087,7 +1087,7 @@ static void usb_tx_callback(struct urb *urb)
 	complete(&ictx->tx.finished);
 }
 
-/**
+/*
  * report touchscreen input
  */
 static void imon_touch_display_timeout(struct timer_list *t)
@@ -1103,7 +1103,7 @@ static void imon_touch_display_timeout(struct timer_list *t)
 	input_sync(ictx->touch);
 }
 
-/**
+/*
  * iMON IR receivers support two different signal sets -- those used by
  * the iMON remotes, and those used by the Windows MCE remotes (which is
  * really just RC-6), but only one or the other at a time, as the signals
@@ -1191,7 +1191,7 @@ static inline int tv2int(const struct timeval *a, const struct timeval *b)
 	return sec;
 }
 
-/**
+/*
  * The directional pad behaves a bit differently, depending on whether this is
  * one of the older ffdc devices or a newer device. Newer devices appear to
  * have a higher resolution matrix for more precise mouse movement, but it
@@ -1543,7 +1543,7 @@ static void imon_pad_to_keys(struct imon_context *ictx, unsigned char *buf)
 	}
 }
 
-/**
+/*
  * figure out if these is a press or a release. We don't actually
  * care about repeats, as those will be auto-generated within the IR
  * subsystem for repeating scancodes.
@@ -1592,10 +1592,10 @@ static int imon_parse_press_type(struct imon_context *ictx,
 	return press_type;
 }
 
-/**
+/*
  * Process the incoming packet
  */
-/**
+/*
  * Convert bit count to time duration (in us) and submit
  * the value to lirc_dev.
  */
@@ -1608,7 +1608,7 @@ static void submit_data(struct imon_context *context)
 	ir_raw_event_store_with_filter(context->rdev, &ev);
 }
 
-/**
+/*
  * Process the incoming packet
  */
 static void imon_incoming_ir_raw(struct imon_context *context,
@@ -1831,7 +1831,7 @@ static void imon_incoming_scancode(struct imon_context *ictx,
 	}
 }
 
-/**
+/*
  * Callback function for USB core API: receive data
  */
 static void usb_rx_callback_intf0(struct urb *urb)
@@ -2485,7 +2485,7 @@ static void imon_init_display(struct imon_context *ictx,
 
 }
 
-/**
+/*
  * Callback function for USB core API: Probe
  */
 static int imon_probe(struct usb_interface *interface,
@@ -2583,7 +2583,7 @@ static int imon_probe(struct usb_interface *interface,
 	return ret;
 }
 
-/**
+/*
  * Callback function for USB core API: disconnect
  */
 static void imon_disconnect(struct usb_interface *interface)
-- 
2.14.3
