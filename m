Return-path: <mchehab@pedra>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:50535 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755751Ab1DKUF6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 16:05:58 -0400
Received: by mail-ew0-f54.google.com with SMTP id 1so3779109ewy.27
        for <linux-media@vger.kernel.org>; Mon, 11 Apr 2011 13:05:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201104112040.08077.jkrzyszt@tis.icnet.pl>
References: <Pine.LNX.4.64.1104111054110.18511@axis700.grange>
 <BANLkTikQSaUKtNZCexhKeNEPM+id+J_2gw@mail.gmail.com> <Pine.LNX.4.64.1104111829500.20798@axis700.grange>
 <201104112040.08077.jkrzyszt@tis.icnet.pl>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Mon, 11 Apr 2011 15:05:35 -0500
Message-ID: <BANLkTinv7FxQjR7w4eL2je-s+3NC78GPHw@mail.gmail.com>
Subject: Re: [PATCH] V4L: soc-camera: regression fix: calculate .sizeimage in soc_camera.c
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Apr 11, 2011 at 1:40 PM, Janusz Krzysztofik
<jkrzyszt@tis.icnet.pl> wrote:
> Dnia poniedziałek 11 kwiecień 2011 o 18:58:51 Guennadi Liakhovetski napisał(a):
>> On Mon, 11 Apr 2011, Aguirre, Sergio wrote:
>> >
>> > Ok. And how about the attached patch? Would that work?
>>
>> Yes, I think, ot would work too, only the call to
>> soc_camera_xlate_by_fourcc() in the S_FMT case is superfluous, after
>> ici->ops->set_fmt() we already have it in icd->current_fmt->host_fmt.
>> Otherwise - yes, we could do it this way too. Janusz, could you test,
>> please?
>
> Looks like not based on the current mainline (-rc2) tree:
>
>  CHECK   drivers/media/video/soc_camera.c
> drivers/media/video/soc_camera.c:146:9: error: undefined identifier 'pixfmtstr'
>  CC      drivers/media/video/soc_camera.o
> drivers/media/video/soc_camera.c: In function 'soc_camera_try_fmt':
> drivers/media/video/soc_camera.c:146: error: implicit declaration of function 'pixfmtstr'
> drivers/media/video/soc_camera.c:146: warning: too few arguments for format
> drivers/media/video/soc_camera.c: In function 'soc_camera_try_fmt_vid_cap':
> drivers/media/video/soc_camera.c:180: warning: unused variable 'ici'
>

Oops, my bad.

Please find below a refreshed patch, which should be based on mainline commit:

b42282e pci: fix PCI bus allocation alignment handling




> Thanks,
> Janusz
>

>From f767059c12c755ebe79c4b74de17c23a257007c7 Mon Sep 17 00:00:00 2001
From: Sergio Aguirre <saaguirre@ti.com>
Date: Mon, 11 Apr 2011 11:14:33 -0500
Subject: [PATCH] V4L: soc-camera: regression fix: calculate .sizeimage
in soc_camera.c

A recent patch has given individual soc-camera host drivers a possibility
to calculate .sizeimage and .bytesperline pixel format fields internally,
however, some drivers relied on the core calculating these values for
them, following a default algorithm. This patch restores the default
calculation for such drivers.

Based on initial patch by Guennadi Liakhovetski, found here:

http://www.spinics.net/lists/linux-media/msg31282.html

Except that this covers try_fmt aswell.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 drivers/media/video/soc_camera.c |   48 +++++++++++++++++++++++++++++++++----
 1 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 4628448..dcc6623 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -136,11 +136,50 @@ unsigned long
soc_camera_apply_sensor_flags(struct soc_camera_link *icl,
 }
 EXPORT_SYMBOL(soc_camera_apply_sensor_flags);

+#define pixfmtstr(x) (x) & 0xff, ((x) >> 8) & 0xff, ((x) >> 16) & 0xff, \
+	((x) >> 24) & 0xff
+
+static int soc_camera_try_fmt(struct soc_camera_device *icd,
+			      struct v4l2_format *f)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	int ret;
+
+	dev_dbg(&icd->dev, "TRY_FMT(%c%c%c%c, %ux%u)\n",
+		pixfmtstr(pix->pixelformat), pix->width, pix->height);
+
+	pix->bytesperline = 0;
+	pix->sizeimage = 0;
+
+	ret = ici->ops->try_fmt(icd, f);
+	if (ret < 0)
+		return ret;
+
+	if (!pix->sizeimage) {
+		if (!pix->bytesperline) {
+			const struct soc_camera_format_xlate *xlate;
+
+			xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
+			if (!xlate)
+				return -EINVAL;
+
+			ret = soc_mbus_bytes_per_line(pix->width,
+						      xlate->host_fmt);
+			if (ret > 0)
+				pix->bytesperline = ret;
+		}
+		if (pix->bytesperline)
+			pix->sizeimage = pix->bytesperline * pix->height;
+	}
+
+	return 0;
+}
+
 static int soc_camera_try_fmt_vid_cap(struct file *file, void *priv,
 				      struct v4l2_format *f)
 {
 	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);

 	WARN_ON(priv != file->private_data);

@@ -149,7 +188,7 @@ static int soc_camera_try_fmt_vid_cap(struct file
*file, void *priv,
 		return -EINVAL;

 	/* limit format to hardware capabilities */
-	return ici->ops->try_fmt(icd, f);
+	return soc_camera_try_fmt(icd, f);
 }

 static int soc_camera_enum_input(struct file *file, void *priv,
@@ -362,9 +401,6 @@ static void soc_camera_free_user_formats(struct
soc_camera_device *icd)
 	icd->user_formats = NULL;
 }

-#define pixfmtstr(x) (x) & 0xff, ((x) >> 8) & 0xff, ((x) >> 16) & 0xff, \
-	((x) >> 24) & 0xff
-
 /* Called with .vb_lock held, or from the first open(2), see comment there */
 static int soc_camera_set_fmt(struct soc_camera_device *icd,
 			      struct v4l2_format *f)
@@ -377,7 +413,7 @@ static int soc_camera_set_fmt(struct soc_camera_device *icd,
 		pixfmtstr(pix->pixelformat), pix->width, pix->height);

 	/* We always call try_fmt() before set_fmt() or set_crop() */
-	ret = ici->ops->try_fmt(icd, f);
+	ret = soc_camera_try_fmt(icd, f);
 	if (ret < 0)
 		return ret;

-- 
1.7.0.4
