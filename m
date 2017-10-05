Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:35551 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751420AbdJEIpk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 04:45:40 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 21/25] media: lirc: introduce LIRC_SET_POLL_MODE
Date: Thu,  5 Oct 2017 09:45:23 +0100
Message-Id: <7c4c335377433fc96f38e9ce42e221169cac23cb.1507192752.git.sean@mess.org>
In-Reply-To: <88e30a50734f7d132ac8a6234acc7335cbbb3a56.1507192751.git.sean@mess.org>
References: <88e30a50734f7d132ac8a6234acc7335cbbb3a56.1507192751.git.sean@mess.org>
In-Reply-To: <cover.1507192751.git.sean@mess.org>
References: <cover.1507192751.git.sean@mess.org>
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
 Documentation/media/uapi/rc/lirc-set-poll-mode.rst | 45 ++++++++++++++++++++++
 drivers/media/rc/ir-lirc-codec.c                   | 19 +++++++--
 drivers/media/rc/lirc_dev.c                        |  1 +
 include/media/rc-core.h                            |  3 ++
 5 files changed, 65 insertions(+), 4 deletions(-)
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
index 000000000000..ce5043e8acba
--- /dev/null
+++ b/Documentation/media/uapi/rc/lirc-set-poll-mode.rst
@@ -0,0 +1,45 @@
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
+LIRC_SET_POLL_MODE - Set LIRC modes to use for poll
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
+:ref:`LIRC_MODE_SCANCODE <lirc-mode-scancode>` are supported. Poll
+can report read readiness for both modes if you bitwise or them together.
+Use :ref:`lirc_get_features` to find out which modes the driver supports.
+
+Note that using :ref:`lirc_set_rec_mode` resets the poll mode.
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 2544ddc078ca..1f1811c080af 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -353,6 +353,17 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
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
@@ -495,13 +506,13 @@ static unsigned int ir_lirc_poll(struct file *file,
 	if (!rcdev->registered) {
 		events = POLLHUP | POLLERR;
 	} else if (rcdev->driver_type != RC_DRIVER_IR_RAW_TX) {
-		if (rcdev->rec_mode == LIRC_MODE_SCANCODE &&
+		if ((rcdev->poll_mode & LIRC_MODE_SCANCODE) &&
 		    !kfifo_is_empty(&rcdev->scancodes))
-			events = POLLIN | POLLRDNORM;
+			events |= POLLIN | POLLRDNORM;
 
-		if (rcdev->rec_mode == LIRC_MODE_MODE2 &&
+		if ((rcdev->poll_mode & LIRC_MODE_MODE2) &&
 		    !kfifo_is_empty(&rcdev->rawir))
-			events = POLLIN | POLLRDNORM;
+			events |= POLLIN | POLLRDNORM;
 	}
 
 	return events;
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 35d6072b12b2..aee7cbb04439 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -62,6 +62,7 @@ int ir_lirc_register(struct rc_dev *dev)
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
2.13.6
