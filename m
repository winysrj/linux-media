Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39193 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbbJJNgQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 09:36:16 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thierry Reding <thierry.reding@gmail.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 07/26] [media] DocBook: Convert struct lirc_driver to doc-nano format
Date: Sat, 10 Oct 2015 10:35:50 -0300
Message-Id: <be14c5cd592b6a268c825ca78ff7be758bab316d.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The struct lirc_driver is already documented, but on some
internal format. Convert it to Kernel doc-nano format and
add documentation for some additional parameters that are
also present at the structure.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index bdc0f7e0a55d..44634e295699 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -246,6 +246,7 @@ X!Isound/sound_firmware.c
      </sect1>
      <sect1><title>Remote Controller devices</title>
 !Iinclude/media/rc-core.h
+!Iinclude/media/lirc_dev.h
      </sect1>
      <sect1><title>Media Controller devices</title>
 !Iinclude/media/media-device.h
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index 05e7ad5d2c8b..abb92f879ba2 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -118,6 +118,71 @@ static inline unsigned int lirc_buffer_write(struct lirc_buffer *buf,
 	return ret;
 }
 
+/**
+ * struct lirc_driver - Defines the parameters on a LIRC driver
+ *
+ * @name:		this string will be used for logs
+ *
+ * @minor:		indicates minor device (/dev/lirc) number for
+ *			registered driver if caller fills it with negative
+ *			value, then the first free minor number will be used
+ *			(if available).
+ *
+ * @code_length:	length of the remote control key code expressed in bits.
+ *
+ * @buffer_size:	Number of FIFO buffers with @chunk_size size. If zero,
+ *			creates a buffer with BUFLEN size (16 bytes).
+ *
+ * @sample_rate:	if zero, the device will wait for an event with a new
+ *			code to be parsed. Otherwise, specifies the sample
+ *			rate for polling. Value should be between 0
+ *			and HZ. If equal to HZ, it would mean one polling per
+ *			second.
+ *
+ * @features:		lirc compatible hardware features, like LIRC_MODE_RAW,
+ *			LIRC_CAN_*, as defined at include/media/lirc.h.
+ *
+ * @chunk_size:		Size of each FIFO buffer.
+ *
+ * @data:		it may point to any driver data and this pointer will
+ *			be passed to all callback functions.
+ *
+ * @min_timeout:	Minimum timeout for record. Valid only if
+ *			LIRC_CAN_SET_REC_TIMEOUT is defined.
+ *
+ * @max_timeout:	Maximum timeout for record. Valid only if
+ *			LIRC_CAN_SET_REC_TIMEOUT is defined.
+ *
+ * @add_to_buf:		add_to_buf will be called after specified period of the
+ *			time or triggered by the external event, this behavior
+ *			depends on value of the sample_rate this function will
+ *			be called in user context. This routine should return
+ *			0 if data was added to the buffer and -ENODATA if none
+ *			was available. This should add some number of bits
+ *			evenly divisible by code_length to the buffer.
+ *
+ * @rbuf:		if not NULL, it will be used as a read buffer, you will
+ *			have to write to the buffer by other means, like irq's
+ *			(see also lirc_serial.c).
+ *
+ * @set_use_inc:	set_use_inc will be called after device is opened
+ *
+ * @set_use_dec:	set_use_dec will be called after device is closed
+ *
+ * @rdev:		Pointed to struct rc_dev associated with the LIRC
+ *			device.
+ *
+ * @fops:		file_operations for drivers which don't fit the current
+ *			driver model.
+ *			Some ioctl's can be directly handled by lirc_dev if the
+ *			driver's ioctl function is NULL or if it returns
+ *			-ENOIOCTLCMD (see also lirc_serial.c).
+ *
+ * @dev:		pointer to the struct device associated with the LIRC
+ *			device.
+ *
+ * @owner:		the module owning this struct
+ */
 struct lirc_driver {
 	char name[40];
 	int minor;
@@ -141,55 +206,6 @@ struct lirc_driver {
 	struct module *owner;
 };
 
-/* name:
- * this string will be used for logs
- *
- * minor:
- * indicates minor device (/dev/lirc) number for registered driver
- * if caller fills it with negative value, then the first free minor
- * number will be used (if available)
- *
- * code_length:
- * length of the remote control key code expressed in bits
- *
- * sample_rate:
- *
- * data:
- * it may point to any driver data and this pointer will be passed to
- * all callback functions
- *
- * add_to_buf:
- * add_to_buf will be called after specified period of the time or
- * triggered by the external event, this behavior depends on value of
- * the sample_rate this function will be called in user context. This
- * routine should return 0 if data was added to the buffer and
- * -ENODATA if none was available. This should add some number of bits
- * evenly divisible by code_length to the buffer
- *
- * rbuf:
- * if not NULL, it will be used as a read buffer, you will have to
- * write to the buffer by other means, like irq's (see also
- * lirc_serial.c).
- *
- * set_use_inc:
- * set_use_inc will be called after device is opened
- *
- * set_use_dec:
- * set_use_dec will be called after device is closed
- *
- * fops:
- * file_operations for drivers which don't fit the current driver model.
- *
- * Some ioctl's can be directly handled by lirc_dev if the driver's
- * ioctl function is NULL or if it returns -ENOIOCTLCMD (see also
- * lirc_serial.c).
- *
- * owner:
- * the module owning this struct
- *
- */
-
-
 /* following functions can be called ONLY from user context
  *
  * returns negative value on error or minor number
-- 
2.4.3


