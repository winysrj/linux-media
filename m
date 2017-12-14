Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:48923 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753481AbdLNRWC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 12:22:02 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 05/10] media: lirc: when transmitting scancodes, block until transmit is done
Date: Thu, 14 Dec 2017 17:21:56 +0000
Message-Id: <5271e5f36cf5951587f7e51c02cc3f4abc5cdb1d.1513271970.git.sean@mess.org>
In-Reply-To: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
References: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
In-Reply-To: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
References: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The semantics for lirc IR transmit with raw IR is that the write call
should block until the IR is transmitted. Some drivers have no idea
when this actually is (e.g. mceusb), so there is a wait.

This is useful for userspace, as it might want to send a IR button press,
a gap of a predefined number of milliseconds, and then send a repeat
message.

It turns out that for transmitting scancodes this feature is even more
useful, as user space has no idea how long the IR is. So, maintain
the existing semantics for IR scancode transmit.

Signed-off-by: Sean Young <sean@mess.org>
---
 Documentation/media/uapi/rc/lirc-write.rst |  4 ++--
 drivers/media/rc/lirc_dev.c                | 22 +++++++++++-----------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/Documentation/media/uapi/rc/lirc-write.rst b/Documentation/media/uapi/rc/lirc-write.rst
index dd3d1fe807a6..d4566b0a2015 100644
--- a/Documentation/media/uapi/rc/lirc-write.rst
+++ b/Documentation/media/uapi/rc/lirc-write.rst
@@ -60,8 +60,8 @@ When in :ref:`LIRC_MODE_SCANCODE <lirc-mode-scancode>` mode, one
 and the protocol in the :c:type:`rc_proto`: member. All other members must be
 set to 0, else ``EINVAL`` is returned. If there is no protocol encoder
 for the protocol or the scancode is not valid for the specified protocol,
-``EINVAL`` is returned. The write function may not wait until the scancode
-is transmitted.
+``EINVAL`` is returned. The write function blocks until the scancode
+is transmitted by the hardware.
 
 
 Return Value
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 218658917cf6..6cedb546c3e0 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -354,18 +354,18 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 			duration += txbuf[i];
 
 		ret *= sizeof(unsigned int);
+	}
 
-		/*
-		 * The lircd gap calculation expects the write function to
-		 * wait for the actual IR signal to be transmitted before
-		 * returning.
-		 */
-		towait = ktime_us_delta(ktime_add_us(start, duration),
-					ktime_get());
-		if (towait > 0) {
-			set_current_state(TASK_INTERRUPTIBLE);
-			schedule_timeout(usecs_to_jiffies(towait));
-		}
+	/*
+	 * The lircd gap calculation expects the write function to
+	 * wait for the actual IR signal to be transmitted before
+	 * returning.
+	 */
+	towait = ktime_us_delta(ktime_add_us(start, duration),
+				ktime_get());
+	if (towait > 0) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(usecs_to_jiffies(towait));
 	}
 
 out:
-- 
2.14.3
