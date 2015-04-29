Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37517 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbbD2XGV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 19:06:21 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sean Young <sean@mess.org>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH 14/27] redrat3: change return argument on redrat3_send_cmd() to int
Date: Wed, 29 Apr 2015 20:05:59 -0300
Message-Id: <1da17435fddb23efebeb04b312d69cafb36e4f91.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

redrat3_send_cmd() can return an error or the read data. However,
it currently returns an u8, as reported by smatch:
	drivers/media/rc/redrat3.c:416 redrat3_send_cmd() warn: signedness bug returning '(-12)'

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index c4def66f9aa2..c83292ad1b34 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -405,7 +405,7 @@ static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 }
 
 /* Util fn to send rr3 cmds */
-static u8 redrat3_send_cmd(int cmd, struct redrat3_dev *rr3)
+static int redrat3_send_cmd(int cmd, struct redrat3_dev *rr3)
 {
 	struct usb_device *udev;
 	u8 *data;
-- 
2.1.0

