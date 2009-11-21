Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:51624 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbZKUQqS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Nov 2009 11:46:18 -0500
Message-ID: <4B081954.5020907@freemail.hu>
Date: Sat, 21 Nov 2009 17:46:12 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	v4L Mailing List <linux-media@vger.kernel.org>
CC: cocci@diku.dk, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] dvb ttusb-dec: do not overwrite the first part of phys string
References: <4B079CE0.60604@freemail.hu>
In-Reply-To: <4B079CE0.60604@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Use strlcat() to append a string to the previously created first part.

The semantic match that finds this kind of problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression dev;
expression phys;
expression str;
expression size;
@@
 	usb_make_path(dev, phys, size);
-	strlcpy(phys, str, size);
+	strlcat(phys, str, size);
// </smpl>

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -u -p a/drivers/media/dvb/ttusb-dec/ttusb_dec.c b/drivers/media/dvb/ttusb-dec/ttusb_dec.c
--- a/drivers/media/dvb/ttusb-dec/ttusb_dec.c 2009-09-10 00:13:59.000000000 +0200
+++ b/drivers/media/dvb/ttusb-dec/ttusb_dec.c 2009-11-21 17:30:10.000000000 +0100
@@ -1198,7 +1198,7 @@ static int ttusb_init_rc( struct ttusb_d
 	int err;

 	usb_make_path(dec->udev, dec->rc_phys, sizeof(dec->rc_phys));
-	strlcpy(dec->rc_phys, "/input0", sizeof(dec->rc_phys));
+	strlcat(dec->rc_phys, "/input0", sizeof(dec->rc_phys));

 	input_dev = input_allocate_device();
 	if (!input_dev)

