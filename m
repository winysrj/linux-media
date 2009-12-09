Return-path: <linux-media-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:52722 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757064AbZLITXZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Dec 2009 14:23:25 -0500
Date: Wed, 9 Dec 2009 20:23:30 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH 4/12] drivers/media/radio: Correct size given to memset
Message-ID: <Pine.LNX.4.64.0912092023100.1870@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

Memset should be given the size of the structure, not the size of the pointer.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
T *x;
expression E;
@@

memset(x, E, sizeof(
+ *
 x))
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/radio/radio-tea5764.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -u -p a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -314,7 +314,7 @@ static int vidioc_g_tuner(struct file *f
 	if (v->index > 0)
 		return -EINVAL;
 
-	memset(v, 0, sizeof(v));
+	memset(v, 0, sizeof(*v));
 	strcpy(v->name, "FM");
 	v->type = V4L2_TUNER_RADIO;
 	tea5764_i2c_read(radio);
@@ -371,7 +371,7 @@ static int vidioc_g_frequency(struct fil
 	struct tea5764_regs *r = &radio->regs;
 
 	tea5764_i2c_read(radio);
-	memset(f, 0, sizeof(f));
+	memset(f, 0, sizeof(*f));
 	f->type = V4L2_TUNER_RADIO;
 	if (r->tnctrl & TEA5764_TNCTRL_PUPD0)
 		f->frequency = (tea5764_get_freq(radio) * 2) / 125;
