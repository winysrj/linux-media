Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward4h.mail.yandex.net ([84.201.186.22]:42494 "EHLO
	forward4h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab2KQKq2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Nov 2012 05:46:28 -0500
Date: Sat, 17 Nov 2012 14:45:09 +0400
From: Kirill Smelkov <kirr@navytux.spb.ru>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	kirr@mns.spb.ru, linux-media@vger.kernel.org
Subject: Re: [PATCH v4] [media] vivi: Teach it to tune FPS
Message-ID: <20121117104509.GA10789@mini.zxlink>
References: <1350914084-31618-1-git-send-email-kirr@mns.spb.ru>
 <201211021542.21944.hverkuil@xs4all.nl>
 <20121107113001.GA3097@tugrik.mns.mnsspb.ru>
 <201211161438.09046.hverkuil@xs4all.nl>
 <50A65FF2.8020801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A65FF2.8020801@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 16, 2012 at 01:46:58PM -0200, Mauro Carvalho Chehab wrote:
> Em 16-11-2012 11:38, Hans Verkuil escreveu:
> >On Wed November 7 2012 12:30:01 Kirill Smelkov wrote:
[...]

> >>diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
> >>index 37d0af8..5d1b374 100644
> >>--- a/drivers/media/platform/vivi.c
> >>+++ b/drivers/media/platform/vivi.c
> >>@@ -65,8 +65,11 @@ MODULE_PARM_DESC(vid_limit, "capture memory limit in megabytes");
> >>  /* Global font descriptor */
> >>  static const u8 *font8x16;
> >>
> >>-/* default to NTSC timeperframe */
> >>-static const struct v4l2_fract TPF_DEFAULT = {.numerator = 1001, .denominator = 30000};
> >>+/* timeperframe: min/max and default */
> >>+static const struct v4l2_fract
> >>+	tpf_min     = {.numerator = 1,		.denominator = UINT_MAX},  /* 1/infty */
> >>+	tpf_max     = {.numerator = UINT_MAX,	.denominator = 1},         /* infty */
> >
> >I understand your reasoning here, but I wouldn't go with UINT_MAX here. Something like
> >1/1000 tpf (or 1 ms) up to 86400/1 tpf (or once a day). With UINT_MAX I am afraid we
> >might hit application errors when they manipulate these values. The shortest time
> >between frames is 1 ms anyway.
> >
> >It's the only comment I have, it looks good otherwise.
> 
> As those will be a arbitrary values, I suggest to declare a macro for it at the
> beginning of vivi.c file, with some comment explaining the rationale of the choose,
> and what else needs to be changed, if this changes (e. g. less than 1ms would require
> changing the image generation logic, to avoid producing frames with equal content).

Maybe something like this? (please note, I'm not a good text writer. If
this needs adjustment please help me shape the text up)


diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index 5d1b374..45b8a81 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -36,6 +36,18 @@
 
 #define VIVI_MODULE_NAME "vivi"
 
+/* Maximum allowed frame rate
+ *
+ * Vivi will allow setting timeperframe in [1/FPS_MAX - FPS_MAX/1] range.
+ *
+ * Ideally FPS_MAX should be infinity, i.e. practically UINT_MAX, but that
+ * might hit application errors when they manipulate these values.
+ *
+ * Besides, for tpf < 1ms image-generation logic should be changed, to avoid
+ * producing frames with equal content.
+ */
+#define FPS_MAX 1000
+
 #define MAX_WIDTH 1920
 #define MAX_HEIGHT 1200
 
@@ -67,8 +79,8 @@ static const u8 *font8x16;
 
 /* timeperframe: min/max and default */
 static const struct v4l2_fract
-	tpf_min     = {.numerator = 1,		.denominator = UINT_MAX},  /* 1/infty */
-	tpf_max     = {.numerator = UINT_MAX,	.denominator = 1},         /* infty */
+	tpf_min     = {.numerator = 1,		.denominator = FPS_MAX},   /* ~1/infty */
+	tpf_max     = {.numerator = FPS_MAX,	.denominator = 1},         /* ~infty */
 	tpf_default = {.numerator = 1001,	.denominator = 30000};     /* NTSC */
 
 #define dprintk(dev, level, fmt, arg...) \
