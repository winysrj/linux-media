Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:48827 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965635AbdIZUOH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 16:14:07 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 18/20] media: lirc: introduce LIRC_SET_POLL_MODE
Date: Tue, 26 Sep 2017 21:13:57 +0100
Message-Id: <c79946e9b19ea7d9dcfae24e0a3149a064793f82.1506455086.git.sean@mess.org>
In-Reply-To: <2d8072bb3a5e80de4a6dd175a358cb2034c12d3e.1506455086.git.sean@mess.org>
References: <2d8072bb3a5e80de4a6dd175a358cb2034c12d3e.1506455086.git.sean@mess.org>
In-Reply-To: <cover.1506455086.git.sean@mess.org>
References: <cover.1506455086.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If you want to poll for both decoded scancodes and raw IR, then this
ioctl will help you.

int fd = open("/dev/lirc0", O_RDONLY | O_NONBLOCK);

for (;;) {
	unsigned mode = LIRC_MODE_SCANCODE | LIRC_MODE_MODE2;
	ioctl(fd, LIRC_SET_POLL_MODE, &mode);
	poll(&((struct pollfd){ .fd = fd, .events = POLLIN }), 1, -1);
	mode = LIRC_MODE_SCANCODE;
	ioctl(fd, LIRC_SET_REC_MODE, &mode);
	struct lirc_scancode sc;
	if (read(fd, &sc, sizeof(sc)) == sizeof(sc)) {
		printf("scancode protocol:%d scancode:%llx\n",
			sc.rc_proto, sc.scancode);
	}
	mode = LIRC_MODE_MODE2;
	ioctl(fd, LIRC_SET_REC_MODE, &mode);
	unsigned sample;
	if (read(fd, &sample, sizeof(sample)) == sizeof(sample)) {
		if (LIRC_IS_SPACE(sample))
			printf("space %u\n", LIRC_VAL(sample)));
		if (LIRC_IS_PULSE(sample))
			printf("pulse %u\n", LIRC_VAL(sample)));
	}
}

Note that LIRC_SET_REC_MODE will also affect the poll mode, so you
must set it again before calling poll.

Signed-off-by: Sean Young <sean@mess.org>
---
 Documentation/media/uapi/rc/lirc-func.rst          |  1 +
 Documentation/media/uapi/rc/lirc-set-poll-mode.rst | 44 ++++++++++++++++++++++
 drivers/media/rc/ir-lirc-codec.c                   | 25 +++++++++---
 drivers/media/rc/lirc_dev.c                        |  1 +
 include/media/rc-core.h                            |  3 ++
 5 files changed, 68 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/media/uapi/rc/lirc-set-poll-mode.rst

diff --git a/Documentation/media/uapi/rc/lirc-func.rst b/Documentation/media/uapi/rc/lirc-func.rst
index ddb4620de294..a09fb03f6722 100644
--- a/Documentation/media/uapi/rc/lirc-func.rst
+++ b/Documentation/media/uapi/rc/lirc-func.rst
@@ -25,3 +25,4 @@ LIRC Function Reference
     lirc-set-rec-timeout-reports
     lirc-set-measure-carrier-mode
     lirc-set-wideband-receiver
+    lirc-set-poll-mode
diff --git a/Documentation/media/uapi/rc/lirc-set-poll-mode.rst b/Documentation/media/uapi/rc/lirc-set-poll-mode.rst
new file mode 100644
index 000000000000..56112bb0dcc9
--- /dev/null
+++ b/Documentation/media/uapi/rc/lirc-set-poll-mode.rst
@@ -0,0 +1,44 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _lirc_set_poll_mode:
+
+**********************************************
+ioctls LIRC_SET_POLL_MODE
+**********************************************
+
+Name
+====
+
+LIRC_SET_POLL_MODE - Set poll modes
+
+Synopsis
+========
+
+.. c:function:: int ioctl( int fd, LIRC_SET_POLL_MODE, __u32 modes)
+	:name: LIRC_SET_POLL_MODE
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by open().
+
+``modes``
+    Bitmask with enabled poll lirc modes
+
+Description
+===========
+
+Set lirc modes for which read readiness is reported by poll. Only
+:ref:`LIRC_MODE_MODE2 <lirc-mode-mode2>` and
+:ref:`LIRC_MODE_SCANCODE <lirc-mode-scancode>` are supported.
+Use :ref:`lirc_get_features` to find out which modes the driver supports.
+
+Note that using :ref:`lirc-set-rec-mode` resets the poll mode.
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 43936128e303..46c6e05e85a6 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -342,6 +342,17 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 			return -EINVAL;
 
 		dev->rec_mode = val;
+		dev->poll_mode = val;
+		return 0;
+
+	case LIRC_SET_POLL_MODE:
+		if (dev->driver_type == RC_DRIVER_IR_RAW_TX)
+			return -ENOTTY;
+
+		if (val & ~(LIRC_MODE_MODE2 | LIRC_MODE_SCANCODE))
+			return -EINVAL;
+
+		dev->poll_mode = val;
 		return 0;
 
 	case LIRC_GET_SEND_MODE:
@@ -480,12 +491,14 @@ static unsigned int ir_lirc_poll(struct file *file,
 
 	if (!rcdev->registered) {
 		events = POLLHUP | POLLERR;
-	} else if (rcdev->rec_mode == LIRC_MODE_SCANCODE) {
-		if (!kfifo_is_empty(&rcdev->scancodes))
-			events = POLLIN | POLLRDNORM;
-	} else if (rcdev->rec_mode == LIRC_MODE_MODE2) {
-		if (!kfifo_is_empty(&rcdev->rawir))
-			events = POLLIN | POLLRDNORM;
+	} else {
+		if ((rcdev->poll_mode & LIRC_MODE_SCANCODE) &&
+		    !kfifo_is_empty(&rcdev->scancodes))
+			events |= POLLIN | POLLRDNORM;
+
+		if ((rcdev->poll_mode & LIRC_MODE_MODE2) &&
+		    !kfifo_is_empty(&rcdev->rawir))
+			events |= POLLIN | POLLRDNORM;
 	}
 
 	return events;
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index e5672b0a6dc4..df592240f1e5 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -57,6 +57,7 @@ int ir_lirc_register(struct rc_dev *dev)
 	dev->lirc_dev.release = lirc_release_device;
 	dev->send_mode = LIRC_MODE_PULSE;
 	dev->rec_mode = LIRC_MODE_MODE2;
+	dev->poll_mode = LIRC_MODE_MODE2;
 
 	if (dev->driver_type == RC_DRIVER_IR_RAW) {
 		if (kfifo_alloc(&dev->rawir, MAX_IR_EVENT_SIZE, GFP_KERNEL))
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 86f62e75dcab..da9624b2cc1a 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -132,6 +132,8 @@ enum rc_filter_type {
  *	LIRC_MODE_PULSE
  * @rec_mode: lirc mode for recording, either LIRC_MODE_SCANCODE or
  *	LIRC_MODE_MODE2
+ * @poll_mode: lirc mode used for polling, can poll for both LIRC_MODE_SCANCODE
+ *	and LIRC_MODE_MODE2
  * @registered: set to true by rc_register_device(), false by
  *	rc_unregister_device
  * @change_protocol: allow changing the protocol used on hardware decoders
@@ -208,6 +210,7 @@ struct rc_dev {
 	wait_queue_head_t		wait_poll;
 	u8				send_mode;
 	u8				rec_mode;
+	u8				poll_mode;
 #endif
 	bool				registered;
 	int				(*change_protocol)(struct rc_dev *dev, u64 *rc_proto);
-- 
2.13.5
