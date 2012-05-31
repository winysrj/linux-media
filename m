Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60314 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214Ab2EaIhN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 May 2012 04:37:13 -0400
Received: by yhmm54 with SMTP id m54so465955yhm.19
        for <linux-media@vger.kernel.org>; Thu, 31 May 2012 01:37:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2212863.1QHZfSWdDi@avalon>
References: <CAGGh5h3jNpbPty6Qzrz9XhmBJci2GcHZhaF8w3dmG_Ce9dpSRQ@mail.gmail.com>
	<2212863.1QHZfSWdDi@avalon>
Date: Thu, 31 May 2012 10:37:09 +0200
Message-ID: <CAGGh5h2RoxwQv-M2-WY9YEs0C1zzQFbL_1k_az_naE-WudeOeQ@mail.gmail.com>
Subject: Re: [RFC PATCH] omap3isp : fix cfa demosaicing for format other than GRBG
From: jean-philippe francois <jp.francois@cynove.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/5/29 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Jean-Philippe,
>
> On Tuesday 29 May 2012 10:24:45 jean-philippe francois wrote:
>> Hi,
>>
>> omap3 ISP previewer block can convert a raw bayer image into a UYVY image.
>> Debayering coefficient are stored in an undocumented table. In the current
>> form, only GRBG format are converted correctly.
>>
>> However, the other CFA arrangement can be transformed in GRBG arrangement by
>> shifting the image window one pixel to the left or to the bottom.
>>
>> Here is a patch against vanilla 3.2.17, that was only tested with a BGGR
>> arrangement.
>> Is it the right way to fix this issue ?
>
> That's really a hack. I'd much rather support other Bayer orders properly by
> modifying the CFA coefficients table.
>
> The table is arranged as 4 blocks of 144 coefficients. If I'm not mistaken (I
> haven't tested it), the blocks should be arranged as follows:
>
> GRBG 0 1 2 3
> RGGB 1 0 3 2
> BGGR 2 3 0 1
> GBRG 3 2 1 0
>
> Would you be able to test that with your BGGR sensor ?

It is indeed working for BGGR.

>
> If that's correct, it shouldn't be too difficult to modify the order
> dynamically based on the format.

What about something like the patch below ?
(It is easier for me to build images using mainline kernel + patch queue,
but should this patch be a good start, I would switch to a git workflow)

Index: b/drivers/media/video/omap3isp/isppreview.c
===================================================================
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -308,6 +308,19 @@
 			dcor->couplet_mode_en ? ISPPRV_PCR_DCCOUP : 0);
 }

+
+/* cfa table is organised in four blocks.
+ * Default ordering is for GRBG arrangement, but changing
+ * the block order allows to interpolate other cfa arrangement
+ */
+static unsigned int cfa_coef_order[4][4] = {
+	{ 0, 1, 2, 3 }, /* GRBG */
+	{ 1, 0, 3, 2 }, /* RGGB */
+	{ 2, 3, 0, 1 }, /* BGGR */
+	{ 3, 2, 1, 0 }, /* GBRG */
+};
+#define CFA_BLK_SIZE (OMAP3ISP_PREV_CFA_TBL_SIZE / 4)
+
 /*
  * preview_config_cfa - Configures the CFA Interpolation parameters.
  * @prev_cfa: Structure containing the CFA interpolation table, CFA format
@@ -319,6 +332,7 @@
 	struct isp_device *isp = to_isp_device(prev);
 	const struct omap3isp_prev_cfa *cfa = prev_cfa;
 	unsigned int i;
+	unsigned int * block_order;

 	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
 			ISPPRV_PCR_CFAFMT_MASK,
@@ -332,8 +346,30 @@
 	isp_reg_writel(isp, ISPPRV_CFA_TABLE_ADDR,
 		       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);

+
+	switch(prev->formats[PREV_PAD_SINK].code) {
+	case V4L2_MBUS_FMT_SRGGB10_1X10 :
+		block_order = cfa_coef_order[1];
+		break;
+
+	case V4L2_MBUS_FMT_SBGGR10_1X10 :
+		block_order = cfa_coef_order[2];
+		break;
+
+	case V4L2_MBUS_FMT_SGBRG10_1X10 :
+		block_order = cfa_coef_order[3];
+		break;
+
+	default :
+		block_order = cfa_coef_order[0];
+	}
+
+
 	for (i = 0; i < OMAP3ISP_PREV_CFA_TBL_SIZE; i++) {
-		isp_reg_writel(isp, cfa->table[i],
+		unsigned int base, offset;
+		base = block_order[i / CFA_BLK_SIZE]*CFA_BLK_SIZE;
+		offset = i % CFA_BLK_SIZE;
+		isp_reg_writel(isp, cfa->table[base + offset],
 			       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_DATA);
 	}
 }
@@ -1344,7 +1380,8 @@
 	preview_adjust_bandwidth(prev);

 	preview_config_input_size(prev);
-
+	preview_config_cfa(prev, &prev->params.cfa);
+
 	if (prev->input == PREVIEW_INPUT_CCDC)
 		preview_config_inlineoffset(prev, 0);
 	else


>
> --
> Regards,
>
> Laurent Pinchart
