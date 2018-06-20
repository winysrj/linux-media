Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59914 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754144AbeFTLBg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 07:01:36 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 14/27] media: gspca: sq930x: use GFP_KERNEL in sd_dq_callback()
Date: Wed, 20 Jun 2018 13:00:52 +0200
Message-Id: <20180620110105.19955-15-bigeasy@linutronix.de>
In-Reply-To: <20180620110105.19955-1-bigeasy@linutronix.de>
References: <20180620110105.19955-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The context in which sd_dq_callback() is non atomic, there is even
msleep() at the end of the function. There is no need to use GFP_ATOMIC
here - use GFP_KERNEL instead.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/media/usb/gspca/sq930x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/gspca/sq930x.c b/drivers/media/usb/gspca/sq9=
30x.c
index d7cbcf2b3947..e15b45f022e1 100644
--- a/drivers/media/usb/gspca/sq930x.c
+++ b/drivers/media/usb/gspca/sq930x.c
@@ -1044,7 +1044,7 @@ static void sd_dq_callback(struct gspca_dev *gspca_de=
v)
 			v4l2_ctrl_g_ctrl(sd->gain));
=20
 	gspca_dev->cam.bulk_nurbs =3D 1;
-	ret =3D usb_submit_urb(gspca_dev->urb[0], GFP_ATOMIC);
+	ret =3D usb_submit_urb(gspca_dev->urb[0], GFP_KERNEL);
 	if (ret < 0)
 		pr_err("sd_dq_callback() err %d\n", ret);
=20
--=20
2.17.1
