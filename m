Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:57740 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753210AbeDLPYZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 11:24:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 11/17] media: atomisp: compat32: use get_user() before referencing user data
Date: Thu, 12 Apr 2018 11:24:03 -0400
Message-Id: <9ad203c73bd9664cb5fa11a5cc49a435b2d47dfe.1523546545.git.mchehab@s-opensource.com>
In-Reply-To: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
In-Reply-To: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The logic at get_atomisp_parameters32() is broken, as pointed by
smatch:

	drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:737:21: warning: dereference of noderef expression
	drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:744:60: warning: dereference of noderef expression
	drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:763:21: warning: dereference of noderef expression
	drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:770:60: warning: dereference of noderef expression
	drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:788:21: warning: dereference of noderef expression
	drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:795:60: warning: dereference of noderef expression
	drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:812:21: warning: dereference of noderef expression
	drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c:819:60: warning: dereference of noderef expression

It tries to access userspace data directly, without calling
get_user(). That should generate OOPS. Thankfully, the right
logic is already there (although commented out).

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../atomisp/pci/atomisp2/atomisp_compat_ioctl32.c  | 38 ----------------------
 1 file changed, 38 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c
index 44c21813a06e..d7c0ef1f9584 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c
@@ -691,10 +691,8 @@ static int get_atomisp_parameters32(struct atomisp_parameters *kp,
 				sizeof(compat_uptr_t);
 	unsigned int size, offset = 0;
 	void  __user *user_ptr;
-#ifdef ISP2401
 	unsigned int stp, mtp, dcp, dscp = 0;
 
-#endif
 	if (!access_ok(VERIFY_READ, up, sizeof(struct atomisp_parameters32)))
 			return -EFAULT;
 
@@ -707,15 +705,11 @@ static int get_atomisp_parameters32(struct atomisp_parameters *kp,
 		n--;
 	}
 	if (get_user(kp->isp_config_id, &up->isp_config_id) ||
-#ifndef ISP2401
-	    get_user(kp->per_frame_setting, &up->per_frame_setting))
-#else
 	    get_user(kp->per_frame_setting, &up->per_frame_setting) ||
 	    get_user(stp, &up->shading_table) ||
 	    get_user(mtp, &up->morph_table) ||
 	    get_user(dcp, &up->dvs2_coefs) ||
 	    get_user(dscp, &up->dvs_6axis_config))
-#endif
 		return -EFAULT;
 
 	{
@@ -733,18 +727,10 @@ static int get_atomisp_parameters32(struct atomisp_parameters *kp,
 		user_ptr = compat_alloc_user_space(size);
 
 		/* handle shading table */
-#ifndef ISP2401
-		if (up->shading_table != 0) {
-#else
 		if (stp != 0) {
-#endif
 			if (get_atomisp_shading_table32(&karg.shading_table,
 				(struct atomisp_shading_table32 __user *)
-#ifndef ISP2401
-						(uintptr_t)up->shading_table))
-#else
 						(uintptr_t)stp))
-#endif
 				return -EFAULT;
 
 			kp->shading_table = user_ptr + offset;
@@ -759,18 +745,10 @@ static int get_atomisp_parameters32(struct atomisp_parameters *kp,
 		}
 
 		/* handle morph table */
-#ifndef ISP2401
-		if (up->morph_table != 0) {
-#else
 		if (mtp != 0) {
-#endif
 			if (get_atomisp_morph_table32(&karg.morph_table,
 					(struct atomisp_morph_table32 __user *)
-#ifndef ISP2401
-						(uintptr_t)up->morph_table))
-#else
 						(uintptr_t)mtp))
-#endif
 				return -EFAULT;
 
 			kp->morph_table = user_ptr + offset;
@@ -784,18 +762,10 @@ static int get_atomisp_parameters32(struct atomisp_parameters *kp,
 		}
 
 		/* handle dvs2 coefficients */
-#ifndef ISP2401
-		if (up->dvs2_coefs != 0) {
-#else
 		if (dcp != 0) {
-#endif
 			if (get_atomisp_dis_coefficients32(&karg.dvs2_coefs,
 				(struct atomisp_dis_coefficients32 __user *)
-#ifndef ISP2401
-						(uintptr_t)up->dvs2_coefs))
-#else
 						(uintptr_t)dcp))
-#endif
 				return -EFAULT;
 
 			kp->dvs2_coefs = user_ptr + offset;
@@ -808,18 +778,10 @@ static int get_atomisp_parameters32(struct atomisp_parameters *kp,
 				return -EFAULT;
 		}
 		/* handle dvs 6axis configuration */
-#ifndef ISP2401
-		if (up->dvs_6axis_config != 0) {
-#else
 		if (dscp != 0) {
-#endif
 			if (get_atomisp_dvs_6axis_config32(&karg.dvs_6axis_config,
 				(struct atomisp_dvs_6axis_config32 __user *)
-#ifndef ISP2401
-						(uintptr_t)up->dvs_6axis_config))
-#else
 						(uintptr_t)dscp))
-#endif
 				return -EFAULT;
 
 			kp->dvs_6axis_config = user_ptr + offset;
-- 
2.14.3
