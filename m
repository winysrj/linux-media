Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:35369 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753954AbeDLPYd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 11:24:33 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 13/17] media: atomisp: compat32: fix __user annotations
Date: Thu, 12 Apr 2018 11:24:05 -0400
Message-Id: <dcd4376a0328480e785dc0251dd6efd8b4d4c967.1523546545.git.mchehab@s-opensource.com>
In-Reply-To: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
In-Reply-To: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The __user annotations at the compat32 code is not right:

   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:81:18: warning: incorrect type in assignment (different address spaces)
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:81:18:    expected void *base
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:81:18:    got void [noderef] <asn:1>*
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:232:23: warning: incorrect type in assignment (different address spaces)
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:232:23:    expected unsigned int [usertype] *xcoords_y
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:232:23:    got void [noderef] <asn:1>*
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:233:23: warning: incorrect type in assignment (different address spaces)
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:233:23:    expected unsigned int [usertype] *ycoords_y
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:233:23:    got void [noderef] <asn:1>*
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:234:24: warning: incorrect type in assignment (different address spaces)
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:234:24:    expected unsigned int [usertype] *xcoords_uv
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:234:24:    got void [noderef] <asn:1>*
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:235:24: warning: incorrect type in assignment (different address spaces)
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:235:24:    expected unsigned int [usertype] *ycoords_uv
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:235:24:    got void [noderef] <asn:1>*
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:296:29: warning: incorrect type in assignment (different address spaces)
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:296:29:    expected unsigned int [usertype] *effective_width
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:296:29:    got void [noderef] <asn:1>*
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:360:29: warning: incorrect type in assignment (different address spaces)
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:360:29:    expected unsigned int [usertype] *effective_width
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:360:29:    got void [noderef] <asn:1>*
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:437:19: warning: incorrect type in assignment (different address spaces)
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:437:19:    expected struct v4l2_framebuffer *frame
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:437:19:    got void [noderef] <asn:1>*
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:481:29: warning: incorrect type in assignment (different address spaces)
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:481:29:    expected unsigned short *calb_grp_values
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:481:29:    got void [noderef] <asn:1>*
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:701:39: warning: cast removes address space of expression
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:704:21: warning: incorrect type in argument 1 (different address spaces)
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:704:21:    expected void const volatile [noderef] <asn:1>*<noident>
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:704:21:    got unsigned int [usertype] *src
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:737:43: warning: incorrect type in assignment (different address spaces)
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:737:43:    expected struct atomisp_shading_table *shading_table
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:737:43:    got void [noderef] <asn:1>*
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:742:44: warning: incorrect type in argument 1 (different address spaces)
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:742:44:    expected void [noderef] <asn:1>*to
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:742:44:    got struct atomisp_shading_table *shading_table
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:755:41: warning: incorrect type in assignment (different address spaces)
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:755:41:    expected struct atomisp_morph_table *morph_table
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:755:41:    got void [noderef] <asn:1>*
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:760:44: warning: incorrect type in argument 1 (different address spaces)
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:760:44:    expected void [noderef] <asn:1>*to
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:760:44:    got struct atomisp_morph_table *morph_table
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:772:40: warning: incorrect type in assignment (different address spaces)
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:772:40:    expected struct atomisp_dvs2_coefficients *dvs2_coefs
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:772:40:    got void [noderef] <asn:1>*
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:777:44: warning: incorrect type in argument 1 (different address spaces)
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:777:44:    expected void [noderef] <asn:1>*to
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:777:44:    got struct atomisp_dvs2_coefficients *dvs2_coefs
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:788:46: warning: incorrect type in assignment (different address spaces)
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:788:46:    expected struct atomisp_dvs_6axis_config *dvs_6axis_config
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:788:46:    got void [noderef] <asn:1>*
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:793:44: warning: incorrect type in argument 1 (different address spaces)
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:793:44:    expected void [noderef] <asn:1>*to
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:793:44:    got struct atomisp_dvs_6axis_config *dvs_6axis_config
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:853:17: warning: incorrect type in assignment (different address spaces)
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:853:17:    expected struct atomisp_sensor_ae_bracketing_lut_entry *lut
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:853:17:    got void [noderef] <asn:1>*

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../atomisp/pci/atomisp2/atomisp_compat_ioctl32.c  | 49 ++++++++++++----------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c
index 15546b1f843d..8992d60ee27e 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c
@@ -78,7 +78,7 @@ static int get_v4l2_framebuffer32(struct v4l2_framebuffer *kp,
 		get_user(kp->flags, &up->flags))
 			return -EFAULT;
 
-	kp->base = compat_ptr(tmp);
+	kp->base = (void __force *)compat_ptr(tmp);
 	get_v4l2_pix_format((struct v4l2_pix_format *)&kp->fmt, &up->fmt);
 	return 0;
 }
@@ -229,10 +229,10 @@ static int get_atomisp_dvs_6axis_config32(struct atomisp_dvs_6axis_config *kp,
 		get_user(ycoords_uv, &up->ycoords_uv))
 			return -EFAULT;
 
-	kp->xcoords_y = compat_ptr(xcoords_y);
-	kp->ycoords_y = compat_ptr(ycoords_y);
-	kp->xcoords_uv = compat_ptr(xcoords_uv);
-	kp->ycoords_uv = compat_ptr(ycoords_uv);
+	kp->xcoords_y = (void __force *)compat_ptr(xcoords_y);
+	kp->ycoords_y = (void __force *)compat_ptr(ycoords_y);
+	kp->xcoords_uv = (void __force *)compat_ptr(xcoords_uv);
+	kp->ycoords_uv = (void __force *)compat_ptr(ycoords_uv);
 	return 0;
 }
 
@@ -293,7 +293,7 @@ static int get_atomisp_metadata_stat32(struct atomisp_metadata *kp,
 			return -EFAULT;
 
 	kp->data = compat_ptr(data);
-	kp->effective_width = compat_ptr(effective_width);
+	kp->effective_width = (void __force *)compat_ptr(effective_width);
 	return 0;
 }
 
@@ -357,7 +357,7 @@ static int get_atomisp_metadata_by_type_stat32(
 			return -EFAULT;
 
 	kp->data = compat_ptr(data);
-	kp->effective_width = compat_ptr(effective_width);
+	kp->effective_width = (void __force *)compat_ptr(effective_width);
 	return 0;
 }
 
@@ -434,7 +434,7 @@ static int get_atomisp_overlay32(struct atomisp_overlay *kp,
 		get_user(kp->overlay_start_x, &up->overlay_start_y))
 			return -EFAULT;
 
-	kp->frame = compat_ptr(frame);
+	kp->frame = (void __force *)compat_ptr(frame);
 	return 0;
 }
 
@@ -478,7 +478,7 @@ static int get_atomisp_calibration_group32(
 		get_user(calb_grp_values, &up->calb_grp_values))
 			return -EFAULT;
 
-	kp->calb_grp_values = compat_ptr(calb_grp_values);
+	kp->calb_grp_values = (void __force *)compat_ptr(calb_grp_values);
 	return 0;
 }
 
@@ -698,8 +698,8 @@ static int get_atomisp_parameters32(struct atomisp_parameters *kp,
 			return -EFAULT;
 
 	while (n >= 0) {
-		compat_uptr_t *src = (compat_uptr_t *)up + n;
-		uintptr_t *dst = (uintptr_t *)kp + n;
+		compat_uptr_t __user *src = ((compat_uptr_t __user *)up) + n;
+		uintptr_t *dst = ((uintptr_t *)kp) + n;
 
 		if (get_user((*dst), src))
 			return -EFAULT;
@@ -734,12 +734,12 @@ static int get_atomisp_parameters32(struct atomisp_parameters *kp,
 						(uintptr_t)stp))
 				return -EFAULT;
 
-			kp->shading_table = user_ptr + offset;
+			kp->shading_table = (void __force *)user_ptr + offset;
 			offset = sizeof(struct atomisp_shading_table);
 			if (!kp->shading_table)
 				return -EFAULT;
 
-			if (copy_to_user(kp->shading_table,
+			if (copy_to_user((void __user *)kp->shading_table,
 					 &karg.shading_table,
 					 sizeof(struct atomisp_shading_table)))
 				return -EFAULT;
@@ -752,13 +752,14 @@ static int get_atomisp_parameters32(struct atomisp_parameters *kp,
 						(uintptr_t)mtp))
 				return -EFAULT;
 
-			kp->morph_table = user_ptr + offset;
+			kp->morph_table = (void __force *)user_ptr + offset;
 			offset += sizeof(struct atomisp_morph_table);
 			if (!kp->morph_table)
 				return -EFAULT;
 
-			if (copy_to_user(kp->morph_table, &karg.morph_table,
-					   sizeof(struct atomisp_morph_table)))
+			if (copy_to_user((void __user *)kp->morph_table,
+				         &karg.morph_table,
+					 sizeof(struct atomisp_morph_table)))
 				return -EFAULT;
 		}
 
@@ -769,13 +770,14 @@ static int get_atomisp_parameters32(struct atomisp_parameters *kp,
 						(uintptr_t)dcp))
 				return -EFAULT;
 
-			kp->dvs2_coefs = user_ptr + offset;
+			kp->dvs2_coefs = (void __force *)user_ptr + offset;
 			offset += sizeof(struct atomisp_dis_coefficients);
 			if (!kp->dvs2_coefs)
 				return -EFAULT;
 
-			if (copy_to_user(kp->dvs2_coefs, &karg.dvs2_coefs,
-				sizeof(struct atomisp_dis_coefficients)))
+			if (copy_to_user((void __user *)kp->dvs2_coefs,
+					 &karg.dvs2_coefs,
+					 sizeof(struct atomisp_dis_coefficients)))
 				return -EFAULT;
 		}
 		/* handle dvs 6axis configuration */
@@ -785,13 +787,14 @@ static int get_atomisp_parameters32(struct atomisp_parameters *kp,
 						(uintptr_t)dscp))
 				return -EFAULT;
 
-			kp->dvs_6axis_config = user_ptr + offset;
+			kp->dvs_6axis_config = (void __force *)user_ptr + offset;
 			offset += sizeof(struct atomisp_dvs_6axis_config);
 			if (!kp->dvs_6axis_config)
 				return -EFAULT;
 
-			if (copy_to_user(kp->dvs_6axis_config, &karg.dvs_6axis_config,
-				sizeof(struct atomisp_dvs_6axis_config)))
+			if (copy_to_user((void __user *)kp->dvs_6axis_config,
+					 &karg.dvs_6axis_config,
+					 sizeof(struct atomisp_dvs_6axis_config)))
 				return -EFAULT;
 		}
 	}
@@ -850,7 +853,7 @@ static int get_atomisp_sensor_ae_bracketing_lut(
 		get_user(lut, &up->lut))
 			return -EFAULT;
 
-	kp->lut = compat_ptr(lut);
+	kp->lut = (void __force *)compat_ptr(lut);
 	return 0;
 }
 
-- 
2.14.3
