Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1727 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab1HYOIn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 10:08:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 09/12] az6027: fix compiler warnings
Date: Thu, 25 Aug 2011 16:08:32 +0200
Message-Id: <20f8c6ba7077e8599f954bd241e7d8da083a5a62.1314281302.git.hans.verkuil@cisco.com>
In-Reply-To: <1314281315-32366-1-git-send-email-hverkuil@xs4all.nl>
References: <1314281315-32366-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <afd314e95a520c3a4de0f112735d1d5584ec8a9a.1314281302.git.hans.verkuil@cisco.com>
References: <afd314e95a520c3a4de0f112735d1d5584ec8a9a.1314281302.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

v4l-dvb-git/drivers/media/dvb/dvb-usb/az6027.c: In function 'az6027_set_voltage':
v4l-dvb-git/drivers/media/dvb/dvb-usb/az6027.c:785:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/dvb/dvb-usb/az6027.c: In function 'az6027_i2c_xfer':
v4l-dvb-git/drivers/media/dvb/dvb-usb/az6027.c:957:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/dvb/dvb-usb/az6027.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6027.c b/drivers/media/dvb/dvb-usb/az6027.c
index d59430c..bf389f4 100644
--- a/drivers/media/dvb/dvb-usb/az6027.c
+++ b/drivers/media/dvb/dvb-usb/az6027.c
@@ -782,7 +782,6 @@ static int az6027_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
 {
 
 	u8 buf;
-	int ret;
 	struct dvb_usb_adapter *adap = fe->dvb->priv;
 
 	struct i2c_msg i2c_msg = {
@@ -800,17 +799,17 @@ static int az6027_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
 	switch (voltage) {
 	case SEC_VOLTAGE_13:
 		buf = 1;
-		ret = i2c_transfer(&adap->dev->i2c_adap, &i2c_msg, 1);
+		i2c_transfer(&adap->dev->i2c_adap, &i2c_msg, 1);
 		break;
 
 	case SEC_VOLTAGE_18:
 		buf = 2;
-		ret = i2c_transfer(&adap->dev->i2c_adap, &i2c_msg, 1);
+		i2c_transfer(&adap->dev->i2c_adap, &i2c_msg, 1);
 		break;
 
 	case SEC_VOLTAGE_OFF:
 		buf = 0;
-		ret = i2c_transfer(&adap->dev->i2c_adap, &i2c_msg, 1);
+		i2c_transfer(&adap->dev->i2c_adap, &i2c_msg, 1);
 		break;
 
 	default:
@@ -954,7 +953,6 @@ static int az6027_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[], int n
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
 	int i = 0, j = 0, len = 0;
-	int ret;
 	u16 index;
 	u16 value;
 	int length;
@@ -990,7 +988,7 @@ static int az6027_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[], int n
 				index = (((msg[i].buf[0] << 8) & 0xff00) | (msg[i].buf[1] & 0x00ff));
 				value = msg[i].addr + (msg[i].len << 8);
 				length = msg[i + 1].len + 6;
-				ret = az6027_usb_in_op(d, req, value, index, data, length);
+				az6027_usb_in_op(d, req, value, index, data, length);
 				len = msg[i + 1].len;
 				for (j = 0; j < len; j++)
 					msg[i + 1].buf[j] = data[j + 5];
@@ -1017,7 +1015,7 @@ static int az6027_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[], int n
 				index = 0x0;
 				value = msg[i].addr;
 				length = msg[i].len + 6;
-				ret = az6027_usb_in_op(d, req, value, index, data, length);
+				az6027_usb_in_op(d, req, value, index, data, length);
 				len = msg[i].len;
 				for (j = 0; j < len; j++)
 					msg[i].buf[j] = data[j + 5];
-- 
1.7.5.4

