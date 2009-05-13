Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:3218 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbZEMTzT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2009 15:55:19 -0400
Date: Wed, 13 May 2009 21:55:13 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andy Walls <awalls@radix.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, Mike Isely <isely@pobox.com>
Subject: [PATCH 7/8] ivtv: Probe more I2C addresses for IR devices
Message-ID: <20090513215513.50b69baa@hyperion.delvare>
In-Reply-To: <20090513214559.0f009231@hyperion.delvare>
References: <20090513214559.0f009231@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Probe I2C addresses 0x71 and 0x6b for IR receiver devices (for the
PVR150 and Adaptec cards, respectively.)

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
---
 linux/drivers/media/video/ivtv/ivtv-i2c.c            |    7 ++++++-
 linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c |    2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/video/ivtv/ivtv-i2c.c	2009-05-13 16:36:49.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/ivtv/ivtv-i2c.c	2009-05-13 17:50:55.000000000 +0200
@@ -652,7 +652,12 @@ int init_ivtv_i2c(struct ivtv *itv)
 		   That's why we probe 0x1a (~0x34) first. CB
 		*/
 		const unsigned short addr_list[] = {
-			0x1a, 0x18, 0x64, 0x30,
+			0x1a,	/* Hauppauge IR external */
+			0x18,	/* Hauppauge IR internal */
+			0x71,	/* Hauppauge IR (PVR150) */
+			0x64,	/* Pixelview IR */
+			0x30,	/* KNC ONE IR */
+			0x6b,	/* Adaptec IR */
 			I2C_CLIENT_END
 		};
 

-- 
Jean Delvare
