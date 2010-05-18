Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:62305 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab0ERHXN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 May 2010 03:23:13 -0400
Received: by fg-out-1718.google.com with SMTP id 22so917840fge.1
        for <linux-media@vger.kernel.org>; Tue, 18 May 2010 00:23:11 -0700 (PDT)
Date: Tue, 18 May 2010 17:23:29 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Bee Hock Goh <beehock@gmail.com>
Subject: [PATCH] tm6000, reset I2C bus function
Message-ID: <20100518172329.6d9b520a@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/kPm9V+PtvmCj2kQYXl_exev"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/kPm9V+PtvmCj2kQYXl_exev
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

Add new function for reset I2C bus. Rework some code for use this function.

diff -r 8f5129efe974 linux/drivers/staging/tm6000/tm6000-cards.c
--- a/linux/drivers/staging/tm6000/tm6000-cards.c	Sun May 16 18:48:01 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000-cards.c	Tue May 18 11:14:55 2010 +1000
@@ -378,13 +378,7 @@
 		tm6000_set_reg(dev, REQ_04_EN_DISABLE_MCU_INT,
 					0x02, arg);
 		msleep(10);
-		rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
-					TM6000_GPIO_CLK, 0);
-		if (rc < 0)
-			return rc;
-		msleep(10);
-		rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
-					TM6000_GPIO_CLK, 1);
+		rc = tm6000_i2c_reset(dev, 10);
 		break;
 	case XC2028_TUNER_RESET:
 		/* Reset codes during load firmware */
@@ -438,14 +432,7 @@
 			break;
 
 		case 2:
-			rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
-						TM6000_GPIO_CLK, 0);
-			if (rc < 0)
-				return rc;
-			msleep(100);
-			rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
-						TM6000_GPIO_CLK, 1);
-			msleep(100);
+			rc = tm6000_i2c_reset(dev, 100);
 			break;
 		}
 	}
diff -r 8f5129efe974 linux/drivers/staging/tm6000/tm6000-core.c
--- a/linux/drivers/staging/tm6000/tm6000-core.c	Sun May 16 18:48:01 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000-core.c	Tue May 18 11:14:55 2010 +1000
@@ -156,6 +156,22 @@
 		return rc;
 
 	return buf[3] | buf[2] << 8 | buf[1] << 16 | buf[0] << 24;
+}
+
+int tm6000_i2c_reset(struct tm6000_core *dev, u16 tsleep)
+{
+	int rc;
+
+	rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_CLK, 0);
+	if (rc < 0)
+		return rc;
+
+	msleep(tsleep);
+
+	rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_CLK, 1);
+	msleep(tsleep);
+
+	return rc;
 }
 
 void tm6000_set_fourcc_format(struct tm6000_core *dev)
diff -r 8f5129efe974 linux/drivers/staging/tm6000/tm6000.h
--- a/linux/drivers/staging/tm6000/tm6000.h	Sun May 16 18:48:01 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000.h	Tue May 18 11:14:55 2010 +1000
@@ -241,6 +241,8 @@
 int tm6000_get_reg16(struct tm6000_core *dev, u8 req, u16 value, u16 index);
 int tm6000_get_reg32(struct tm6000_core *dev, u8 req, u16 value, u16 index);
 int tm6000_set_reg (struct tm6000_core *dev, u8 req, u16 value, u16 index);
+int tm6000_i2c_reset(struct tm6000_core *dev, u16 tsleep);
+
 int tm6000_init (struct tm6000_core *dev);
 
 int tm6000_init_analog_mode (struct tm6000_core *dev);

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>


With my best regards, Dmitry.

--MP_/kPm9V+PtvmCj2kQYXl_exev
Content-Type: text/x-patch; name=i2c_rst.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=i2c_rst.patch

diff -r 8f5129efe974 linux/drivers/staging/tm6000/tm6000-cards.c
--- a/linux/drivers/staging/tm6000/tm6000-cards.c	Sun May 16 18:48:01 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000-cards.c	Tue May 18 11:14:55 2010 +1000
@@ -378,13 +378,7 @@
 		tm6000_set_reg(dev, REQ_04_EN_DISABLE_MCU_INT,
 					0x02, arg);
 		msleep(10);
-		rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
-					TM6000_GPIO_CLK, 0);
-		if (rc < 0)
-			return rc;
-		msleep(10);
-		rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
-					TM6000_GPIO_CLK, 1);
+		rc = tm6000_i2c_reset(dev, 10);
 		break;
 	case XC2028_TUNER_RESET:
 		/* Reset codes during load firmware */
@@ -438,14 +432,7 @@
 			break;
 
 		case 2:
-			rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
-						TM6000_GPIO_CLK, 0);
-			if (rc < 0)
-				return rc;
-			msleep(100);
-			rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
-						TM6000_GPIO_CLK, 1);
-			msleep(100);
+			rc = tm6000_i2c_reset(dev, 100);
 			break;
 		}
 	}
diff -r 8f5129efe974 linux/drivers/staging/tm6000/tm6000-core.c
--- a/linux/drivers/staging/tm6000/tm6000-core.c	Sun May 16 18:48:01 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000-core.c	Tue May 18 11:14:55 2010 +1000
@@ -156,6 +156,22 @@
 		return rc;
 
 	return buf[3] | buf[2] << 8 | buf[1] << 16 | buf[0] << 24;
+}
+
+int tm6000_i2c_reset(struct tm6000_core *dev, u16 tsleep)
+{
+	int rc;
+
+	rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_CLK, 0);
+	if (rc < 0)
+		return rc;
+
+	msleep(tsleep);
+
+	rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_CLK, 1);
+	msleep(tsleep);
+
+	return rc;
 }
 
 void tm6000_set_fourcc_format(struct tm6000_core *dev)
diff -r 8f5129efe974 linux/drivers/staging/tm6000/tm6000.h
--- a/linux/drivers/staging/tm6000/tm6000.h	Sun May 16 18:48:01 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000.h	Tue May 18 11:14:55 2010 +1000
@@ -241,6 +241,8 @@
 int tm6000_get_reg16(struct tm6000_core *dev, u8 req, u16 value, u16 index);
 int tm6000_get_reg32(struct tm6000_core *dev, u8 req, u16 value, u16 index);
 int tm6000_set_reg (struct tm6000_core *dev, u8 req, u16 value, u16 index);
+int tm6000_i2c_reset(struct tm6000_core *dev, u16 tsleep);
+
 int tm6000_init (struct tm6000_core *dev);
 
 int tm6000_init_analog_mode (struct tm6000_core *dev);

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/kPm9V+PtvmCj2kQYXl_exev--
