Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:37643 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932443AbbFFICq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2015 04:02:46 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 154402A0006
	for <linux-media@vger.kernel.org>; Sat,  6 Jun 2015 10:02:33 +0200 (CEST)
Message-ID: <5572A918.5040406@xs4all.nl>
Date: Sat, 06 Jun 2015 10:02:32 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] cx231xx: fix compiler warning
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix this compiler warning by allocating a structure to read the eeprom instead
of doing it on the stack and worse: the eeprom array is static, so that can
cause problems if there are multiple cx231xx instances.

cx231xx-cards.c: In function 'cx231xx_card_setup':
cx231xx-cards.c:1110:1: warning: the frame size of 2064 bytes is larger than 2048 bytes [-Wframe-larger-than=]
 }
 ^

I did consider removing the code altogether since the result is actually
not used at the moment, but I decided against it since it is used in other
drivers and someone might want to start using it in this driver as well. And
then it is useful that the code is already there.

Signed-of-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index fe00da1..a4aa285 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1092,17 +1092,25 @@ void cx231xx_card_setup(struct cx231xx *dev)
 	case CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx:
 	case CX231XX_BOARD_HAUPPAUGE_955Q:
 		{
-			struct tveeprom tvee;
-			static u8 eeprom[256];
-			struct i2c_client client;
-
-			memset(&client, 0, sizeof(client));
-			client.adapter = cx231xx_get_i2c_adap(dev, I2C_1_MUX_1);
-			client.addr = 0xa0 >> 1;
+			struct eeprom {
+				struct tveeprom tvee;
+				u8 eeprom[256];
+				struct i2c_client client;
+			};
+			struct eeprom *e = kzalloc(sizeof(*e), GFP_KERNEL);
+
+			if (e == NULL) {
+				dev_err(dev->dev,
+					"failed to allocate memory to read eeprom\n");
+				break;
+			}
+			e->client.adapter = cx231xx_get_i2c_adap(dev, I2C_1_MUX_1);
+			e->client.addr = 0xa0 >> 1;
 
-			read_eeprom(dev, &client, eeprom, sizeof(eeprom));
-			tveeprom_hauppauge_analog(&client,
-						&tvee, eeprom + 0xc0);
+			read_eeprom(dev, &e->client, e->eeprom, sizeof(e->eeprom));
+			tveeprom_hauppauge_analog(&e->client,
+						&e->tvee, e->eeprom + 0xc0);
+			kfree(e);
 			break;
 		}
 	}
