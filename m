Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52347 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753077Ab1KPFxo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Nov 2011 00:53:44 -0500
Message-ID: <1321422815.2885.55.camel@deadeye>
Subject: [PATCH 4/5] staging: lirc_serial: Fix bogus error codes
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Date: Wed, 16 Nov 2011 05:53:35 +0000
In-Reply-To: <1321422581.2885.50.camel@deadeye>
References: <1321422581.2885.50.camel@deadeye>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Device not found?  ENODEV, not EINVAL.
Write to read-only device?  EPERM, not EBADF.
Invalid argument?  EINVAL, not ENOSYS.
Unsupported ioctl?  ENOIOCTLCMD, not ENOSYS.
Another function returned an error code?  Use that, don't replace it.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/media/lirc/lirc_serial.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
index befe626..6f5257e 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -773,7 +773,7 @@ static int hardware_init_port(void)
 		/* we fail, there's nothing here */
 		printk(KERN_ERR LIRC_DRIVER_NAME ": port existence test "
 		       "failed, cannot continue\n");
-		return -EINVAL;
+		return -ENODEV;
 	}
 

@@ -879,10 +879,9 @@ static int __devinit lirc_serial_probe(struct platform_device *dev)
 		goto exit_free_irq;
 	}
 
-	if (hardware_init_port() < 0) {
-		result = -EINVAL;
+	result = hardware_init_port();
+	if (result < 0)
 		goto exit_release_region;
-	}
 
 	/* Initialize pulse/space widths */
 	init_timing_params(duty_cycle, freq);
@@ -980,7 +979,7 @@ static ssize_t lirc_write(struct file *file, const char *buf,
 	int *wbuf;
 
 	if (!(hardware[type].features & LIRC_CAN_SEND_PULSE))
-		return -EBADF;
+		return -EPERM;
 
 	count = n / sizeof(int);
 	if (n % sizeof(int) || count % 2 == 0)
@@ -1031,11 +1030,11 @@ static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 			return result;
 		/* only LIRC_MODE_PULSE supported */
 		if (value != LIRC_MODE_PULSE)
-			return -ENOSYS;
+			return -EINVAL;
 		break;
 
 	case LIRC_GET_LENGTH:
-		return -ENOSYS;
+		return -ENOIOCTLCMD;
 		break;
 
 	case LIRC_SET_SEND_DUTY_CYCLE:
@@ -1126,9 +1125,11 @@ static void lirc_serial_exit(void);
 static int lirc_serial_resume(struct platform_device *dev)
 {
 	unsigned long flags;
+	int result;
 
-	if (hardware_init_port() < 0)
-		return -EINVAL;
+	result = hardware_init_port();
+	if (result < 0)
+		return result;
 
 	spin_lock_irqsave(&hardware[type].lock, flags);
 	/* Enable Interrupt */
@@ -1161,7 +1162,7 @@ static int __init lirc_serial_init(void)
 	/* Init read buffer. */
 	result = lirc_buffer_init(&rbuf, sizeof(int), RBUF_LEN);
 	if (result < 0)
-		return -ENOMEM;
+		return result;
 
 	result = platform_driver_register(&lirc_serial_driver);
 	if (result) {
@@ -1247,7 +1248,7 @@ static int __init lirc_serial_init_module(void)
 		printk(KERN_ERR  LIRC_DRIVER_NAME
 		       ": register_chrdev failed!\n");
 		lirc_serial_exit();
-		return -EIO;
+		return driver.minor;
 	}
 	return 0;
 }
-- 
1.7.7.2



