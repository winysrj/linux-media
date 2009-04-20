Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:21669 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbZDTPh4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 11:37:56 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1335871ywb.1
        for <linux-media@vger.kernel.org>; Mon, 20 Apr 2009 08:37:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090405193625.57c3b1fd@free.fr>
References: <5ec8ebd50903271106n14f0e2b7m1495ef135be0cd90@mail.gmail.com>
	 <49CD2868.9080502@kaiser-linux.li>
	 <5ec8ebd50903311144h316c7e3bmd30ce2c3d5a268ee@mail.gmail.com>
	 <49D4EAB2.4090206@control.lth.se> <49D66C83.6000700@control.lth.se>
	 <49D67781.6030807@gmail.com> <49D74485.8000004@control.lth.se>
	 <20090405193625.57c3b1fd@free.fr>
Date: Mon, 20 Apr 2009 17:37:55 +0200
Message-ID: <1d4c7fd50904200837pe4c82bfx1f0638072efba919@mail.gmail.com>
Subject: Re: topro 6800 driver
From: Thomas Champagne <lafeuil@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>,
	Anders Blomdell <anders.blomdell@control.lth.se>
Cc: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Thomas Kaiser <v4l@kaiser-linux.li>,
	Linux Media <linux-media@vger.kernel.org>,
	Richard Case <rich@racitup.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Anders

I found a small time for testing your code. But your code doesn't work
with my webcam. :-(
I think it doesn't have the same sensor. Can you add in the sd_init
method the check of the sensor id ? You can adjust this patch with
your sensor id :
diff -r 5a9a52f1277e linux/drivers/media/video/gspca/tp6800.c
--- a/linux/drivers/media/video/gspca/tp6800.c	Sat Apr 18 18:21:49 2009 +0200
+++ b/linux/drivers/media/video/gspca/tp6800.c	Mon Apr 20 17:33:15 2009 +0200
@@ -1601,8 +1601,21 @@
 /* this function is called at probe and resume time */
 static int sd_init(struct gspca_dev *gspca_dev)
 {
+	int res = 0;
+	__u8 value;
+
 	/* check if the device responds */
+	REG_W(gspca_dev, TP6800_SIF_TYPE, 0x01);
+	REG_W(gspca_dev, TP6800_SIF_CONTROL, 0x01);
+	REG_W(gspca_dev, TP6800_GPIO_IO, 0x9f);
+	REG_R(gspca_dev, TP6800_GPIO_DATA, &value);
+	if ((value & 7) != 0x00) {
+		PDEBUG(D_ERR, "init reg: 0x%02x. Unrecognized sensor.", value);
+		return -1;
+	}
 	return 0;
+out:
+	return res;
 }

 /* -- start the camera -- */



Please, tell me what is your sensor id.

Thomas
