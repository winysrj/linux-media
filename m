Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:57814 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbZAYB1L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Jan 2009 20:27:11 -0500
Date: Sat, 24 Jan 2009 17:27:09 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Roel Kluin <roel.kluin@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: [PATCH] Bttv: move check on unsigned
In-Reply-To: <Pine.LNX.4.58.0901191020460.11165@shell2.speakeasy.net>
Message-ID: <Pine.LNX.4.58.0901241718090.17971@shell2.speakeasy.net>
References: <497250C7.6030502@gmail.com> <Pine.LNX.4.58.0901191020460.11165@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 19 Jan 2009, Trent Piepho wrote:
> On Sat, 17 Jan 2009, Roel Kluin wrote:
> > Please review, this patch was not tested.
> >
> > The static function set_tvnorm is called in
> > drivers/media/video/bt8xx/bttv-driver.c:
> >
> > 1355:   set_tvnorm(btv, norm);
> > 1868:   set_tvnorm(btv, i);
> > 3273:   set_tvnorm(btv,btv->tvnorm);
> >
> > in the first two with an unsigned, but bttv->tvnorm is signed.
>
> Probably better to just change bttv->tvnorm is unsigned if we can.

Here is an improved patch that does a full tvnorm fix for the driver.  The
tvnorm value is an index into an array and is never allowed to be negative
or otherwise invalid.  Most places it was passed around were unsigned, but
a few structs and functions had signed values.

I got rid of the "< 0" checks and changed some ">= BTTV_TVNORMS" checks
to BUG_ON().

Any problems with this patch Roel?

Mauro, don't apply as is, I'll send a pull request for a real patch later.

diff -r 6a6eb9efc6cd linux/drivers/media/video/bt8xx/bttv-cards.c
--- a/linux/drivers/media/video/bt8xx/bttv-cards.c	Fri Jan 23 22:35:12 2009 -0200
+++ b/linux/drivers/media/video/bt8xx/bttv-cards.c	Sat Jan 24 16:54:53 2009 -0800
@@ -4131,7 +4131,7 @@ static void __devinit avermedia_eeprom(s
 }

 /* used on Voodoo TV/FM (Voodoo 200), S0 wired to 0x10000 */
-void bttv_tda9880_setnorm(struct bttv *btv, int norm)
+void bttv_tda9880_setnorm(struct bttv *btv, unsigned int norm)
 {
 	/* fix up our card entry */
 	if(norm==V4L2_STD_NTSC) {
diff -r 6a6eb9efc6cd linux/drivers/media/video/bt8xx/bttv-driver.c
--- a/linux/drivers/media/video/bt8xx/bttv-driver.c	Fri Jan 23 22:35:12 2009 -0200
+++ b/linux/drivers/media/video/bt8xx/bttv-driver.c	Sat Jan 24 17:15:43 2009 -0800
@@ -1300,7 +1300,7 @@ bttv_crop_calc_limits(struct bttv_crop *
 }

 static void
-bttv_crop_reset(struct bttv_crop *c, int norm)
+bttv_crop_reset(struct bttv_crop *c, unsigned int norm)
 {
 	c->rect = bttv_tvnorms[norm].cropcap.defrect;
 	bttv_crop_calc_limits(c);
@@ -1313,16 +1313,13 @@ set_tvnorm(struct bttv *btv, unsigned in
 	const struct bttv_tvnorm *tvnorm;
 	v4l2_std_id id;

-	if (norm < 0 || norm >= BTTV_TVNORMS)
-		return -EINVAL;
+	BUG_ON(norm >= BTTV_TVNORMS);
+	BUG_ON(btv->tvnorm >= BTTV_TVNORMS);

 	tvnorm = &bttv_tvnorms[norm];

-	if (btv->tvnorm < 0 ||
-	    btv->tvnorm >= BTTV_TVNORMS ||
-	    0 != memcmp(&bttv_tvnorms[btv->tvnorm].cropcap,
-			&tvnorm->cropcap,
-			sizeof (tvnorm->cropcap))) {
+	if (!memcmp(&bttv_tvnorms[btv->tvnorm].cropcap, &tvnorm->cropcap,
+		    sizeof (tvnorm->cropcap))) {
 		bttv_crop_reset(&btv->crop[0], norm);
 		btv->crop[1] = btv->crop[0]; /* current = default */

diff -r 6a6eb9efc6cd linux/drivers/media/video/bt8xx/bttv-vbi.c
--- a/linux/drivers/media/video/bt8xx/bttv-vbi.c	Fri Jan 23 22:35:12 2009 -0200
+++ b/linux/drivers/media/video/bt8xx/bttv-vbi.c	Sat Jan 24 17:02:43 2009 -0800
@@ -411,7 +411,7 @@ int bttv_g_fmt_vbi_cap(struct file *file
 	return 0;
 }

-void bttv_vbi_fmt_reset(struct bttv_vbi_fmt *f, int norm)
+void bttv_vbi_fmt_reset(struct bttv_vbi_fmt *f, unsigned int norm)
 {
 	const struct bttv_tvnorm *tvnorm;
 	unsigned int real_samples_per_line;
diff -r 6a6eb9efc6cd linux/drivers/media/video/bt8xx/bttv.h
--- a/linux/drivers/media/video/bt8xx/bttv.h	Fri Jan 23 22:35:12 2009 -0200
+++ b/linux/drivers/media/video/bt8xx/bttv.h	Sat Jan 24 17:00:13 2009 -0800
@@ -266,7 +266,7 @@ extern void bttv_init_card2(struct bttv

 /* card-specific funtions */
 extern void tea5757_set_freq(struct bttv *btv, unsigned short freq);
-extern void bttv_tda9880_setnorm(struct bttv *btv, int norm);
+extern void bttv_tda9880_setnorm(struct bttv *btv, unsigned int norm);

 /* extra tweaks for some chipsets */
 extern void bttv_check_chipset(void);
diff -r 6a6eb9efc6cd linux/drivers/media/video/bt8xx/bttvp.h
--- a/linux/drivers/media/video/bt8xx/bttvp.h	Fri Jan 23 22:35:12 2009 -0200
+++ b/linux/drivers/media/video/bt8xx/bttvp.h	Sat Jan 24 16:54:07 2009 -0800
@@ -137,7 +137,7 @@ struct bttv_buffer {

 	/* bttv specific */
 	const struct bttv_format   *fmt;
-	int                        tvnorm;
+	unsigned int               tvnorm;
 	int                        btformat;
 	int                        btswap;
 	struct bttv_geometry       geo;
@@ -156,7 +156,7 @@ struct bttv_buffer_set {
 };

 struct bttv_overlay {
-	int                    tvnorm;
+	unsigned int           tvnorm;
 	struct v4l2_rect       w;
 	enum v4l2_field        field;
 	struct v4l2_clip       *clips;
@@ -176,7 +176,7 @@ struct bttv_vbi_fmt {
 };

 /* bttv-vbi.c */
-void bttv_vbi_fmt_reset(struct bttv_vbi_fmt *f, int norm);
+void bttv_vbi_fmt_reset(struct bttv_vbi_fmt *f, unsigned int norm);

 struct bttv_crop {
 	/* A cropping rectangle in struct bttv_tvnorm.cropcap units. */
@@ -380,7 +380,8 @@ struct bttv {
 	unsigned int audio;
 	unsigned int mute;
 	unsigned long freq;
-	int tvnorm,hue,contrast,bright,saturation;
+	unsigned int tvnorm;
+	int hue, contrast, bright, saturation;
 	struct v4l2_framebuffer fbuf;
 	unsigned int field_count;

