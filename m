Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:54547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab0JHAZ5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Oct 2010 20:25:57 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o980Pvr7030221
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 7 Oct 2010 20:25:57 -0400
Received: from pedra (vpn-225-63.phx2.redhat.com [10.3.225.63])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id o980PriQ021715
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 7 Oct 2010 20:25:56 -0400
Date: Thu, 7 Oct 2010 21:25:45 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] V4L/DVB: cx231xx: declare static functions as such
Message-ID: <20101007212545.64db274f@pedra>
In-Reply-To: <cover.1286497447.git.mchehab@redhat.com>
References: <cover.1286497447.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

drivers/media/video/cx23885/built-in.o: In function `mc417_memory_write':
/home/v4l/v4l/patchwork/drivers/media/video/cx23885/cx23885-417.c:482: multiple definition of `mc417_memory_write'
drivers/media/video/cx231xx/built-in.o:/home/v4l/v4l/patchwork/drivers/media/video/cx231xx/cx231xx-417.c:477: first defined here
drivers/media/video/cx23885/built-in.o: In function `mc417_gpio_set':
/home/v4l/v4l/patchwork/drivers/media/video/cx23885/cx23885-417.c:636: multiple definition of `mc417_gpio_set'
drivers/media/video/cx231xx/built-in.o:/home/v4l/v4l/patchwork/drivers/media/video/cx231xx/cx231xx-417.c:615: first defined here
drivers/media/video/cx23885/built-in.o: In function `mc417_gpio_enable':
/home/v4l/v4l/patchwork/drivers/media/video/cx23885/cx23885-417.c:656: multiple definition of `mc417_gpio_enable'
drivers/media/video/cx231xx/built-in.o:/home/v4l/v4l/patchwork/drivers/media/video/cx231xx/cx231xx-417.c:635: first defined here
drivers/media/video/cx23885/built-in.o: In function `mc417_memory_read':
/home/v4l/v4l/patchwork/drivers/media/video/cx23885/cx23885-417.c:546: multiple definition of `mc417_memory_read'
drivers/media/video/cx231xx/built-in.o:/home/v4l/v4l/patchwork/drivers/media/video/cx231xx/cx231xx-417.c:541: first defined here
drivers/media/video/cx23885/built-in.o: In function `mc417_gpio_clear':
/home/v4l/v4l/patchwork/drivers/media/video/cx23885/cx23885-417.c:646: multiple definition of `mc417_gpio_clear'
drivers/media/video/cx231xx/built-in.o:/home/v4l/v4l/patchwork/drivers/media/video/cx231xx/cx231xx-417.c:625: first defined here
drivers/media/video/cx23885/built-in.o: In function `mc417_register_read':
/home/v4l/v4l/patchwork/drivers/media/video/cx23885/cx23885-417.c:388: multiple definition of `mc417_register_read'
drivers/media/video/cx231xx/built-in.o:/home/v4l/v4l/patchwork/drivers/media/video/cx231xx/cx231xx-417.c:401: first defined here
drivers/media/video/cx23885/built-in.o: In function `mc417_register_write':
/home/v4l/v4l/patchwork/drivers/media/video/cx23885/cx23885-417.c:324: multiple definition of `mc417_register_write'
drivers/media/video/cx231xx/built-in.o:/home/v4l/v4l/patchwork/drivers/media/video/cx231xx/cx231xx-417.c:343: first defined here

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx231xx/cx231xx-417.c b/drivers/media/video/cx231xx/cx231xx-417.c
index b5b6998..2dbad82 100644
--- a/drivers/media/video/cx231xx/cx231xx-417.c
+++ b/drivers/media/video/cx231xx/cx231xx-417.c
@@ -296,7 +296,7 @@ enum cx231xx_mute_video_shift {
 
 
 #define CX23417_GPIO_MASK 0xFC0003FF
-int setITVCReg(struct cx231xx *dev, u32 gpio_direction, u32 value)
+static int setITVCReg(struct cx231xx *dev, u32 gpio_direction, u32 value)
 {
 	int status = 0;
 	u32 _gpio_direction = 0;
@@ -307,7 +307,7 @@ int setITVCReg(struct cx231xx *dev, u32 gpio_direction, u32 value)
 			 (u8 *)&value, 4, 0, 0);
 	return status;
 }
-int getITVCReg(struct cx231xx *dev, u32 gpio_direction, u32 *pValue)
+static int getITVCReg(struct cx231xx *dev, u32 gpio_direction, u32 *pValue)
 {
 	int status = 0;
 	u32 _gpio_direction = 0;
@@ -319,7 +319,8 @@ int getITVCReg(struct cx231xx *dev, u32 gpio_direction, u32 *pValue)
 		 (u8 *)pValue, 4, 0, 1);
 	return status;
 }
-int waitForMciComplete(struct cx231xx *dev)
+
+static int waitForMciComplete(struct cx231xx *dev)
 {
 	u32 gpio;
 	u32 gpio_driection = 0;
@@ -339,7 +340,7 @@ int waitForMciComplete(struct cx231xx *dev)
 	return 0;
 }
 
-int mc417_register_write(struct cx231xx *dev, u16 address, u32 value)
+static int mc417_register_write(struct cx231xx *dev, u16 address, u32 value)
 {
 	u32 temp;
 	int status = 0;
@@ -397,7 +398,7 @@ int mc417_register_write(struct cx231xx *dev, u16 address, u32 value)
 	return waitForMciComplete(dev);
 }
 
-int mc417_register_read(struct cx231xx *dev, u16 address, u32 *value)
+static int mc417_register_read(struct cx231xx *dev, u16 address, u32 *value)
 {
 	/*write address byte 0;*/
 	u32 temp;
@@ -473,7 +474,7 @@ int mc417_register_read(struct cx231xx *dev, u16 address, u32 *value)
 	return ret;
 }
 
-int mc417_memory_write(struct cx231xx *dev, u32 address, u32 value)
+static int mc417_memory_write(struct cx231xx *dev, u32 address, u32 value)
 {
 	/*write data byte 0;*/
 
@@ -537,7 +538,7 @@ int mc417_memory_write(struct cx231xx *dev, u32 address, u32 value)
 	return 0;
 }
 
-int mc417_memory_read(struct cx231xx *dev, u32 address, u32 *value)
+static int mc417_memory_read(struct cx231xx *dev, u32 address, u32 *value)
 {
 	u32 temp = 0;
 	u32 return_value = 0;
@@ -611,7 +612,7 @@ int mc417_memory_read(struct cx231xx *dev, u32 address, u32 *value)
 	return ret;
 }
 
-void mc417_gpio_set(struct cx231xx *dev, u32 mask)
+static void mc417_gpio_set(struct cx231xx *dev, u32 mask)
 {
 	u32 val;
 
@@ -621,7 +622,7 @@ void mc417_gpio_set(struct cx231xx *dev, u32 mask)
 	mc417_register_write(dev, 0x900C, val);
 }
 
-void mc417_gpio_clear(struct cx231xx *dev, u32 mask)
+static void mc417_gpio_clear(struct cx231xx *dev, u32 mask)
 {
 	u32 val;
 
@@ -631,7 +632,7 @@ void mc417_gpio_clear(struct cx231xx *dev, u32 mask)
 	mc417_register_write(dev, 0x900C, val);
 }
 
-void mc417_gpio_enable(struct cx231xx *dev, u32 mask, int asoutput)
+static void mc417_gpio_enable(struct cx231xx *dev, u32 mask, int asoutput)
 {
 	u32 val;
 
@@ -873,7 +874,8 @@ static int cx231xx_find_mailbox(struct cx231xx *dev)
 	dprintk(3, "Mailbox signature values not found!\n");
 	return -1;
 }
-void mciWriteMemoryToGPIO(struct cx231xx *dev, u32 address, u32 value,
+
+static void mciWriteMemoryToGPIO(struct cx231xx *dev, u32 address, u32 value,
 		u32 *p_fw_image)
 {
 
@@ -1095,7 +1097,7 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 	return 0;
 }
 
-void cx231xx_417_check_encoder(struct cx231xx *dev)
+static void cx231xx_417_check_encoder(struct cx231xx *dev)
 {
 	u32 status, seq;
 
@@ -1272,7 +1274,7 @@ static void free_buffer(struct videobuf_queue *vq, struct cx231xx_buffer *buf)
 	buf->vb.state = VIDEOBUF_NEEDS_INIT;
 }
 
-void buffer_copy(struct cx231xx *dev, char *data, int len, struct urb *urb,
+static void buffer_copy(struct cx231xx *dev, char *data, int len, struct urb *urb,
 		struct cx231xx_dmaqueue *dma_q)
 {
 		void *vbuf;
@@ -1334,7 +1336,7 @@ void buffer_copy(struct cx231xx *dev, char *data, int len, struct urb *urb,
 	    return;
 }
 
-void buffer_filled(char *data, int len, struct urb *urb,
+static void buffer_filled(char *data, int len, struct urb *urb,
 		struct cx231xx_dmaqueue *dma_q)
 {
 		void *vbuf;
-- 
1.7.1


