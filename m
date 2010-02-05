Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:37891 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933995Ab0BEWs6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2010 17:48:58 -0500
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 12/12] tm6000: add a different set param values
Date: Fri,  5 Feb 2010 23:48:16 +0100
Message-Id: <1265410096-11788-11-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1265410096-11788-10-git-send-email-stefan.ringel@arcor.de>
References: <1265410096-11788-1-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-2-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-3-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-4-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-5-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-6-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-7-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-8-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-9-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-10-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

---
 drivers/staging/tm6000/hack.c |  160 ++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 157 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/tm6000/hack.c b/drivers/staging/tm6000/hack.c
index f181fce..bb4100b 100644
--- a/drivers/staging/tm6000/hack.c
+++ b/drivers/staging/tm6000/hack.c
@@ -37,7 +37,6 @@ static inline int tm6000_snd_control_msg(struct tm6000_core *dev, __u8 request,
 
 static int pseudo_zl10353_pll(struct tm6000_core *tm6000_dev, struct dvb_frontend_parameters *p)
 {
-	int ret;
 	u8 *data = kzalloc(50*sizeof(u8), GFP_KERNEL);
 
 printk(KERN_ALERT "should set frequency %u\n", p->frequency);
@@ -51,7 +50,7 @@ printk(KERN_ALERT "and bandwith %u\n", p->u.ofdm.bandwidth);
 	}
 
 	// init ZL10353
-	data[0] = 0x0b;
+/*	data[0] = 0x0b;
 	ret = tm6000_snd_control_msg(tm6000_dev, 0x10, 0x501e, 0x00, data, 0x1);
 	msleep(15);
 	data[0] = 0x80;
@@ -189,7 +188,162 @@ printk(KERN_ALERT "and bandwith %u\n", p->u.ofdm.bandwidth);
 			msleep(15);
 		break;
 	}
-
+*/
+	switch(p->u.ofdm.bandwidth) {
+		case BANDWIDTH_8_MHZ:
+			data[0] = 0x03;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x501e,0,data,1);
+			msleep(40);
+			data[0] = 0x44;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x511e,0,data,1);
+			msleep(40);
+			data[0] = 0x40;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x551e,0,data,1);
+			msleep(40);
+			data[0] = 0x46;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x521e,0,data,1);
+			msleep(40);
+			data[0] = 0x15;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x531e,0,data,1);
+			msleep(40);
+			data[0] = 0x0f;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x541e,0,data,1);
+			msleep(40);
+			data[0] = 0x80;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x551e,0,data,1);
+			msleep(40);
+			data[0] = 0x01;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0xea1e,0,data,1);
+			msleep(40);
+			data[0] = 0x00;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0xea1e,0,data,1);
+			msleep(40);
+			data[0] = 0x8b;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x631e,0,data,1);
+			msleep(40);
+			data[0] = 0x75;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0xcc1e,0,data,1);
+			msleep(40);
+			data[0] = 0xe6; //0x19;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x6c1e,0,data,1);
+			msleep(40);
+			data[0] = 0x09; //0xf7;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x6d1e,0,data,1);
+			msleep(40);
+			data[0] = 0x67;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x651e,0,data,1);
+			msleep(40);
+			data[0] = 0xe5;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x661e,0,data,1);
+			msleep(40);
+			data[0] = 0x75;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x5c1e,0,data,1);
+			msleep(40);
+			data[0] = 0x17;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x5f1e,0,data,1);
+			msleep(40);
+			data[0] = 0x40;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x5e1e,0,data,1);
+			msleep(40);
+			data[0] = 0x01;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x701e,0,data,1);
+			msleep(40);
+			break;
+		case BANDWIDTH_7_MHZ:
+			data[0] = 0x03;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x501e,0,data,1);
+			msleep(40);
+			data[0] = 0x44;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x511e,0,data,1);
+			msleep(40);
+			data[0] = 0x40;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x551e,0,data,1);
+			msleep(40);
+			data[0] = 0x46;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x521e,0,data,1);
+			msleep(40);
+			data[0] = 0x15;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x531e,0,data,1);
+			msleep(40);
+			data[0] = 0x0f;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x541e,0,data,1);
+			msleep(40);
+			data[0] = 0x80;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x551e,0,data,1);
+			msleep(40);
+			data[0] = 0x01;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0xea1e,0,data,1);
+			msleep(40);
+			data[0] = 0x00;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0xea1e,0,data,1);
+			msleep(40);
+			data[0] = 0x83;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x631e,0,data,1);
+			msleep(40);
+			data[0] = 0xa3;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0xcc1e,0,data,1);
+			msleep(40);
+			data[0] = 0xe6; //0x19;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x6c1e,0,data,1);
+			msleep(40);
+			data[0] = 0x09; //0xf7;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x6d1e,0,data,1);
+			msleep(40);
+			data[0] = 0x5a;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x651e,0,data,1);
+			msleep(40);
+			data[0] = 0xe9;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x661e,0,data,1);
+			msleep(40);
+			data[0] = 0x86;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x5c1e,0,data,1);
+			msleep(40);
+			data[0] = 0x17;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x5f1e,0,data,1);
+			msleep(40);
+			data[0] = 0x40;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x5e1e,0,data,1);
+			msleep(40);
+			data[0] = 0x01;
+			tm6000_read_write_usb(tm6000_dev,0x40,0x10,0x701e,0,data,1);
+			msleep(40);
+			break;
+		default:
+			printk(KERN_ALERT "tm6000: bandwidth not supported\n");
+	}
+	
+	tm6000_read_write_usb(tm6000_dev,0xc0,0x10,0x051f,0,data,2);
+	printk(KERN_INFO "buf %#x %#x \n", data[0], data[1]);
+	msleep(40);
+	
+	tm6000_read_write_usb(tm6000_dev,0xc0,0x10,0x051f,0,data,2);
+	printk(KERN_INFO "buf %#x %#x \n", data[0], data[1]);
+	msleep(40);
+	
+	tm6000_read_write_usb(tm6000_dev,0xc0,0x10,0x051f,0,data,2);
+	printk(KERN_INFO "buf %#x %#x \n", data[0], data[1]);
+	msleep(40);
+	
+	tm6000_read_write_usb(tm6000_dev,0xc0,0x10,0x051f,0,data,2);
+	printk(KERN_INFO "buf %#x %#x \n", data[0], data[1]);
+	msleep(40);
+	
+	tm6000_read_write_usb(tm6000_dev,0xc0,0x10,0x051f,0,data,2);
+	printk(KERN_INFO "buf %#x %#x \n", data[0], data[1]);
+	msleep(40);
+	
+	tm6000_read_write_usb(tm6000_dev,0xc0,0x10,0x0f1f,0,data,2);
+	printk(KERN_INFO "buf %#x %#x \n", data[0], data[1]);
+	msleep(40);
+	
+	tm6000_read_write_usb(tm6000_dev,0xc0,0x10,0x091f,0,data,2);
+	printk(KERN_INFO "buf %#x %#x \n", data[0], data[1]);
+	msleep(40);
+	
+	tm6000_read_write_usb(tm6000_dev,0xc0,0x10,0x0b1f,0,data,2);
+	printk(KERN_INFO "buf %#x %#x \n", data[0], data[1]);
+	msleep(40);
+	
 	kfree(data);
 
 	return 0;
-- 
1.6.4.2

