Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4176 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab3BIKB1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2013 05:01:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 26/26] cx231xx: fix gpio big-endian problems
Date: Sat,  9 Feb 2013 11:00:56 +0100
Message-Id: <61e6d6a68d2831f21e767902d4e2b9c48c2c5083.1360403310.git.hans.verkuil@cisco.com>
In-Reply-To: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
References: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
References: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Tested on my big-endian ppc-based test machine.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-avcore.c |   73 +++++++++++++++-------------
 drivers/media/usb/cx231xx/cx231xx.h        |    2 -
 2 files changed, 38 insertions(+), 37 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
index 3f26f64..2e51fb9 100644
--- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
@@ -2638,20 +2638,23 @@ EXPORT_SYMBOL_GPL(cx231xx_capture_start);
 /*****************************************************************************
 *                   G P I O   B I T control functions                        *
 ******************************************************************************/
-int cx231xx_set_gpio_bit(struct cx231xx *dev, u32 gpio_bit, u8 *gpio_val)
+static int cx231xx_set_gpio_bit(struct cx231xx *dev, u32 gpio_bit, u32 gpio_val)
 {
 	int status = 0;
 
-	status = cx231xx_send_gpio_cmd(dev, gpio_bit, gpio_val, 4, 0, 0);
+	gpio_val = cpu_to_le32(gpio_val);
+	status = cx231xx_send_gpio_cmd(dev, gpio_bit, (u8 *)&gpio_val, 4, 0, 0);
 
 	return status;
 }
 
-int cx231xx_get_gpio_bit(struct cx231xx *dev, u32 gpio_bit, u8 *gpio_val)
+static int cx231xx_get_gpio_bit(struct cx231xx *dev, u32 gpio_bit, u32 *gpio_val)
 {
+	u32 tmp;
 	int status = 0;
 
-	status = cx231xx_send_gpio_cmd(dev, gpio_bit, gpio_val, 4, 0, 1);
+	status = cx231xx_send_gpio_cmd(dev, gpio_bit, (u8 *)&tmp, 4, 0, 1);
+	*gpio_val = le32_to_cpu(tmp);
 
 	return status;
 }
@@ -2683,7 +2686,7 @@ int cx231xx_set_gpio_direction(struct cx231xx *dev,
 	else
 		value = dev->gpio_dir | (1 << pin_number);
 
-	status = cx231xx_set_gpio_bit(dev, value, (u8 *) &dev->gpio_val);
+	status = cx231xx_set_gpio_bit(dev, value, dev->gpio_val);
 
 	/* cache the value for future */
 	dev->gpio_dir = value;
@@ -2717,7 +2720,7 @@ int cx231xx_set_gpio_value(struct cx231xx *dev, int pin_number, int pin_value)
 		value = dev->gpio_dir | (1 << pin_number);
 		dev->gpio_dir = value;
 		status = cx231xx_set_gpio_bit(dev, dev->gpio_dir,
-					      (u8 *) &dev->gpio_val);
+					      dev->gpio_val);
 		value = 0;
 	}
 
@@ -2730,7 +2733,7 @@ int cx231xx_set_gpio_value(struct cx231xx *dev, int pin_number, int pin_value)
 	dev->gpio_val = value;
 
 	/* toggle bit0 of GP_IO */
-	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, (u8 *)&dev->gpio_val);
+	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, dev->gpio_val);
 
 	return status;
 }
@@ -2748,7 +2751,7 @@ int cx231xx_gpio_i2c_start(struct cx231xx *dev)
 	dev->gpio_val |= 1 << dev->board.tuner_scl_gpio;
 	dev->gpio_val |= 1 << dev->board.tuner_sda_gpio;
 
-	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, (u8 *)&dev->gpio_val);
+	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, dev->gpio_val);
 	if (status < 0)
 		return -EINVAL;
 
@@ -2756,7 +2759,7 @@ int cx231xx_gpio_i2c_start(struct cx231xx *dev)
 	dev->gpio_val |= 1 << dev->board.tuner_scl_gpio;
 	dev->gpio_val &= ~(1 << dev->board.tuner_sda_gpio);
 
-	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, (u8 *)&dev->gpio_val);
+	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, dev->gpio_val);
 	if (status < 0)
 		return -EINVAL;
 
@@ -2764,7 +2767,7 @@ int cx231xx_gpio_i2c_start(struct cx231xx *dev)
 	dev->gpio_val &= ~(1 << dev->board.tuner_scl_gpio);
 	dev->gpio_val &= ~(1 << dev->board.tuner_sda_gpio);
 
-	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, (u8 *)&dev->gpio_val);
+	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, dev->gpio_val);
 	if (status < 0)
 		return -EINVAL;
 
@@ -2782,7 +2785,7 @@ int cx231xx_gpio_i2c_end(struct cx231xx *dev)
 	dev->gpio_val &= ~(1 << dev->board.tuner_scl_gpio);
 	dev->gpio_val &= ~(1 << dev->board.tuner_sda_gpio);
 
-	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, (u8 *)&dev->gpio_val);
+	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, dev->gpio_val);
 	if (status < 0)
 		return -EINVAL;
 
@@ -2790,7 +2793,7 @@ int cx231xx_gpio_i2c_end(struct cx231xx *dev)
 	dev->gpio_val |= 1 << dev->board.tuner_scl_gpio;
 	dev->gpio_val &= ~(1 << dev->board.tuner_sda_gpio);
 
-	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, (u8 *)&dev->gpio_val);
+	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, dev->gpio_val);
 	if (status < 0)
 		return -EINVAL;
 
@@ -2800,7 +2803,7 @@ int cx231xx_gpio_i2c_end(struct cx231xx *dev)
 	dev->gpio_dir &= ~(1 << dev->board.tuner_sda_gpio);
 
 	status =
-	    cx231xx_set_gpio_bit(dev, dev->gpio_dir, (u8 *)&dev->gpio_val);
+	    cx231xx_set_gpio_bit(dev, dev->gpio_dir, dev->gpio_val);
 	if (status < 0)
 		return -EINVAL;
 
@@ -2822,33 +2825,33 @@ int cx231xx_gpio_i2c_write_byte(struct cx231xx *dev, u8 data)
 			dev->gpio_val &= ~(1 << dev->board.tuner_scl_gpio);
 			dev->gpio_val &= ~(1 << dev->board.tuner_sda_gpio);
 			status = cx231xx_set_gpio_bit(dev, dev->gpio_dir,
-						      (u8 *)&dev->gpio_val);
+						      dev->gpio_val);
 
 			/* set SCL to output 1; set SDA to output 0     */
 			dev->gpio_val |= 1 << dev->board.tuner_scl_gpio;
 			status = cx231xx_set_gpio_bit(dev, dev->gpio_dir,
-						      (u8 *)&dev->gpio_val);
+						      dev->gpio_val);
 
 			/* set SCL to output 0; set SDA to output 0     */
 			dev->gpio_val &= ~(1 << dev->board.tuner_scl_gpio);
 			status = cx231xx_set_gpio_bit(dev, dev->gpio_dir,
-						      (u8 *)&dev->gpio_val);
+						      dev->gpio_val);
 		} else {
 			/* set SCL to output 0; set SDA to output 1     */
 			dev->gpio_val &= ~(1 << dev->board.tuner_scl_gpio);
 			dev->gpio_val |= 1 << dev->board.tuner_sda_gpio;
 			status = cx231xx_set_gpio_bit(dev, dev->gpio_dir,
-						      (u8 *)&dev->gpio_val);
+						      dev->gpio_val);
 
 			/* set SCL to output 1; set SDA to output 1     */
 			dev->gpio_val |= 1 << dev->board.tuner_scl_gpio;
 			status = cx231xx_set_gpio_bit(dev, dev->gpio_dir,
-						      (u8 *)&dev->gpio_val);
+						      dev->gpio_val);
 
 			/* set SCL to output 0; set SDA to output 1     */
 			dev->gpio_val &= ~(1 << dev->board.tuner_scl_gpio);
 			status = cx231xx_set_gpio_bit(dev, dev->gpio_dir,
-						      (u8 *)&dev->gpio_val);
+						      dev->gpio_val);
 		}
 	}
 	return status;
@@ -2867,17 +2870,17 @@ int cx231xx_gpio_i2c_read_byte(struct cx231xx *dev, u8 *buf)
 		/* set SCL to output 0; set SDA to input */
 		dev->gpio_val &= ~(1 << dev->board.tuner_scl_gpio);
 		status = cx231xx_set_gpio_bit(dev, dev->gpio_dir,
-					      (u8 *)&dev->gpio_val);
+					      dev->gpio_val);
 
 		/* set SCL to output 1; set SDA to input */
 		dev->gpio_val |= 1 << dev->board.tuner_scl_gpio;
 		status = cx231xx_set_gpio_bit(dev, dev->gpio_dir,
-					      (u8 *)&dev->gpio_val);
+					      dev->gpio_val);
 
 		/* get SDA data bit */
 		gpio_logic_value = dev->gpio_val;
 		status = cx231xx_get_gpio_bit(dev, dev->gpio_dir,
-					      (u8 *)&dev->gpio_val);
+					      &dev->gpio_val);
 		if ((dev->gpio_val & (1 << dev->board.tuner_sda_gpio)) != 0)
 			value |= (1 << (8 - i - 1));
 
@@ -2888,7 +2891,7 @@ int cx231xx_gpio_i2c_read_byte(struct cx231xx *dev, u8 *buf)
 	   !!!set SDA to input, never to modify SDA direction at
 	   the same times */
 	dev->gpio_val &= ~(1 << dev->board.tuner_scl_gpio);
-	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, (u8 *)&dev->gpio_val);
+	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, dev->gpio_val);
 
 	/* store the value */
 	*buf = value & 0xff;
@@ -2909,12 +2912,12 @@ int cx231xx_gpio_i2c_read_ack(struct cx231xx *dev)
 	dev->gpio_dir &= ~(1 << dev->board.tuner_scl_gpio);
 
 	gpio_logic_value = dev->gpio_val;
-	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, (u8 *)&dev->gpio_val);
+	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, dev->gpio_val);
 
 	do {
 		msleep(2);
 		status = cx231xx_get_gpio_bit(dev, dev->gpio_dir,
-					      (u8 *)&dev->gpio_val);
+					      &dev->gpio_val);
 		nCnt--;
 	} while (((dev->gpio_val &
 			  (1 << dev->board.tuner_scl_gpio)) == 0) &&
@@ -2929,7 +2932,7 @@ int cx231xx_gpio_i2c_read_ack(struct cx231xx *dev)
 	 * through clock stretch, slave has given a SCL signal,
 	 * so the SDA data can be directly read.
 	 */
-	status = cx231xx_get_gpio_bit(dev, dev->gpio_dir, (u8 *)&dev->gpio_val);
+	status = cx231xx_get_gpio_bit(dev, dev->gpio_dir, &dev->gpio_val);
 
 	if ((dev->gpio_val & 1 << dev->board.tuner_sda_gpio) == 0) {
 		dev->gpio_val = gpio_logic_value;
@@ -2945,7 +2948,7 @@ int cx231xx_gpio_i2c_read_ack(struct cx231xx *dev)
 	dev->gpio_val = gpio_logic_value;
 	dev->gpio_dir |= (1 << dev->board.tuner_scl_gpio);
 	dev->gpio_val &= ~(1 << dev->board.tuner_scl_gpio);
-	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, (u8 *)&dev->gpio_val);
+	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, dev->gpio_val);
 
 	return status;
 }
@@ -2956,24 +2959,24 @@ int cx231xx_gpio_i2c_write_ack(struct cx231xx *dev)
 
 	/* set SDA to ouput */
 	dev->gpio_dir |= 1 << dev->board.tuner_sda_gpio;
-	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, (u8 *)&dev->gpio_val);
+	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, dev->gpio_val);
 
 	/* set SCL = 0 (output); set SDA = 0 (output) */
 	dev->gpio_val &= ~(1 << dev->board.tuner_sda_gpio);
 	dev->gpio_val &= ~(1 << dev->board.tuner_scl_gpio);
-	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, (u8 *)&dev->gpio_val);
+	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, dev->gpio_val);
 
 	/* set SCL = 1 (output); set SDA = 0 (output) */
 	dev->gpio_val |= 1 << dev->board.tuner_scl_gpio;
-	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, (u8 *)&dev->gpio_val);
+	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, dev->gpio_val);
 
 	/* set SCL = 0 (output); set SDA = 0 (output) */
 	dev->gpio_val &= ~(1 << dev->board.tuner_scl_gpio);
-	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, (u8 *)&dev->gpio_val);
+	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, dev->gpio_val);
 
 	/* set SDA to input,and then the slave will read data from SDA. */
 	dev->gpio_dir &= ~(1 << dev->board.tuner_sda_gpio);
-	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, (u8 *)&dev->gpio_val);
+	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, dev->gpio_val);
 
 	return status;
 }
@@ -2985,15 +2988,15 @@ int cx231xx_gpio_i2c_write_nak(struct cx231xx *dev)
 	/* set scl to output ; set sda to input */
 	dev->gpio_dir |= 1 << dev->board.tuner_scl_gpio;
 	dev->gpio_dir &= ~(1 << dev->board.tuner_sda_gpio);
-	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, (u8 *)&dev->gpio_val);
+	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, dev->gpio_val);
 
 	/* set scl to output 0; set sda to input */
 	dev->gpio_val &= ~(1 << dev->board.tuner_scl_gpio);
-	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, (u8 *)&dev->gpio_val);
+	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, dev->gpio_val);
 
 	/* set scl to output 1; set sda to input */
 	dev->gpio_val |= 1 << dev->board.tuner_scl_gpio;
-	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, (u8 *)&dev->gpio_val);
+	status = cx231xx_set_gpio_bit(dev, dev->gpio_dir, dev->gpio_val);
 
 	return status;
 }
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index 0f92fd1..a8e50d2 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -845,8 +845,6 @@ int cx231xx_send_usb_command(struct cx231xx_i2c *i2c_bus,
 /* Gpio related functions */
 int cx231xx_send_gpio_cmd(struct cx231xx *dev, u32 gpio_bit, u8 *gpio_val,
 			  u8 len, u8 request, u8 direction);
-int cx231xx_set_gpio_bit(struct cx231xx *dev, u32 gpio_bit, u8 *gpio_val);
-int cx231xx_get_gpio_bit(struct cx231xx *dev, u32 gpio_bit, u8 *gpio_val);
 int cx231xx_set_gpio_value(struct cx231xx *dev, int pin_number, int pin_value);
 int cx231xx_set_gpio_direction(struct cx231xx *dev, int pin_number,
 			       int pin_value);
-- 
1.7.10.4

