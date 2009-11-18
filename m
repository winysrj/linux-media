Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:54102 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757679AbZKRQwc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 11:52:32 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>
Date: Wed, 18 Nov 2009 22:22:21 +0530
Subject: RE: [PATCH] Davinci VPFE Capture: Add Suspend/Resume Support
Message-ID: <19F8576C6E063C45BE387C64729E7394043702BAE5@dbde02.ent.ti.com>
References: <hvaibhav@ti.com>
 <1258544075-28771-1-git-send-email-hvaibhav@ti.com>
 <A69FA2915331DC488A831521EAE36FE401559C5F1E@dlee06.ent.ti.com>
 <19F8576C6E063C45BE387C64729E7394043702BAB1@dbde02.ent.ti.com>
 <A69FA2915331DC488A831521EAE36FE401559C5FC0@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401559C5FC0@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Karicheri, Muralidharan
> Sent: Wednesday, November 18, 2009 9:55 PM
> To: Hiremath, Vaibhav; linux-media@vger.kernel.org
> Cc: hverkuil@xs4all.nl
> Subject: RE: [PATCH] Davinci VPFE Capture: Add Suspend/Resume
> Support
> 
> Vaibhav,
> 
> Just wondering how to test this on DaVinci platforms.
> Could you tell what you did to test this?
> 
[Hiremath, Vaibhav] Enable CONFIG_PM in your defconfig and issue following command -

# echo mem > /sys/power/state

Thanks,
Vaibhav

> Murali Karicheri
> Software Design Engineer
> Texas Instruments Inc.
> Germantown, MD 20874
> phone: 301-407-9583
> email: m-karicheri2@ti.com
> 
> >-----Original Message-----
> >From: Hiremath, Vaibhav
> >Sent: Wednesday, November 18, 2009 10:36 AM
> >To: Karicheri, Muralidharan; linux-media@vger.kernel.org
> >Cc: hverkuil@xs4all.nl
> >Subject: RE: [PATCH] Davinci VPFE Capture: Add Suspend/Resume
> Support
> >
> >
> >> -----Original Message-----
> >> From: Karicheri, Muralidharan
> >> Sent: Wednesday, November 18, 2009 8:55 PM
> >> To: Hiremath, Vaibhav; linux-media@vger.kernel.org
> >> Cc: hverkuil@xs4all.nl
> >> Subject: RE: [PATCH] Davinci VPFE Capture: Add Suspend/Resume
> >> Support
> >>
> >> Vaibhav,
> >>
> >> Did you validate suspend & resume operations on AM3517?
> >>
> >[Hiremath, Vaibhav] yes, I think I mentioned in my patch. Do you
> see any
> >issues?
> >
> >Thanks,
> >Vaibhav
> >
> >> Murali Karicheri
> >> Software Design Engineer
> >> Texas Instruments Inc.
> >> Germantown, MD 20874
> >> phone: 301-407-9583
> >> email: m-karicheri2@ti.com
> >>
> >> >-----Original Message-----
> >> >From: Hiremath, Vaibhav
> >> >Sent: Wednesday, November 18, 2009 6:35 AM
> >> >To: linux-media@vger.kernel.org
> >> >Cc: hverkuil@xs4all.nl; Karicheri, Muralidharan; Hiremath,
> Vaibhav
> >> >Subject: [PATCH] Davinci VPFE Capture: Add Suspend/Resume
> Support
> >> >
> >> >From: Vaibhav Hiremath <hvaibhav@ti.com>
> >> >
> >> >Validated on AM3517 Platform.
> >> >
> >> >Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> >> >---
> >> > drivers/media/video/davinci/ccdc_hw_device.h |    4 +
> >> > drivers/media/video/davinci/dm644x_ccdc.c    |   87
> >> >++++++++++++++++++++++++++
> >> > drivers/media/video/davinci/vpfe_capture.c   |   29 ++++++---
> >> > 3 files changed, 112 insertions(+), 8 deletions(-)
> >> >
> >> >diff --git a/drivers/media/video/davinci/ccdc_hw_device.h
> >> >b/drivers/media/video/davinci/ccdc_hw_device.h
> >> >index 86b9b35..2a1ead4 100644
> >> >--- a/drivers/media/video/davinci/ccdc_hw_device.h
> >> >+++ b/drivers/media/video/davinci/ccdc_hw_device.h
> >> >@@ -91,6 +91,10 @@ struct ccdc_hw_ops {
> >> > 	void (*setfbaddr) (unsigned long addr);
> >> > 	/* Pointer to function to get field id */
> >> > 	int (*getfid) (void);
> >> >+
> >> >+	/* suspend/resume support */
> >> >+	void (*save_context)(void);
> >> >+	void (*restore_context)(void);
> >> > };
> >> >
> >> > struct ccdc_hw_device {
> >> >diff --git a/drivers/media/video/davinci/dm644x_ccdc.c
> >> >b/drivers/media/video/davinci/dm644x_ccdc.c
> >> >index 5dff8d9..fdab823 100644
> >> >--- a/drivers/media/video/davinci/dm644x_ccdc.c
> >> >+++ b/drivers/media/video/davinci/dm644x_ccdc.c
> >> >@@ -88,6 +88,10 @@ static void *__iomem ccdc_base_addr;
> >> > static int ccdc_addr_size;
> >> > static enum vpfe_hw_if_type ccdc_if_type;
> >> >
> >> >+#define CCDC_SZ_REGS			SZ_1K
> >> >+
> >> >+static u32 ccdc_ctx[CCDC_SZ_REGS / sizeof(u32)];
> >> >+
> >> > /* register access routines */
> >> > static inline u32 regr(u32 offset)
> >> > {
> >> >@@ -834,6 +838,87 @@ static int ccdc_set_hw_if_params(struct
> >> >vpfe_hw_if_param *params)
> >> > 	return 0;
> >> > }
> >> >
> >> >+static void ccdc_save_context(void)
> >> >+{
> >> >+	ccdc_ctx[CCDC_PCR] = regr(CCDC_PCR);
> >> >+	ccdc_ctx[CCDC_SYN_MODE] = regr(CCDC_SYN_MODE);
> >> >+	ccdc_ctx[CCDC_HD_VD_WID] = regr(CCDC_HD_VD_WID);
> >> >+	ccdc_ctx[CCDC_PIX_LINES] = regr(CCDC_PIX_LINES);
> >> >+	ccdc_ctx[CCDC_HORZ_INFO] = regr(CCDC_HORZ_INFO);
> >> >+	ccdc_ctx[CCDC_VERT_START] = regr(CCDC_VERT_START);
> >> >+	ccdc_ctx[CCDC_VERT_LINES] = regr(CCDC_VERT_LINES);
> >> >+	ccdc_ctx[CCDC_CULLING] = regr(CCDC_CULLING);
> >> >+	ccdc_ctx[CCDC_HSIZE_OFF] = regr(CCDC_HSIZE_OFF);
> >> >+	ccdc_ctx[CCDC_SDOFST] = regr(CCDC_SDOFST);
> >> >+	ccdc_ctx[CCDC_SDR_ADDR] = regr(CCDC_SDR_ADDR);
> >> >+	ccdc_ctx[CCDC_CLAMP] = regr(CCDC_CLAMP);
> >> >+	ccdc_ctx[CCDC_DCSUB] = regr(CCDC_DCSUB);
> >> >+	ccdc_ctx[CCDC_COLPTN] = regr(CCDC_COLPTN);
> >> >+	ccdc_ctx[CCDC_BLKCMP] = regr(CCDC_BLKCMP);
> >> >+	ccdc_ctx[CCDC_FPC] = regr(CCDC_FPC);
> >> >+	ccdc_ctx[CCDC_FPC_ADDR] = regr(CCDC_FPC_ADDR);
> >> >+	ccdc_ctx[CCDC_VDINT] = regr(CCDC_VDINT);
> >> >+	ccdc_ctx[CCDC_ALAW] = regr(CCDC_ALAW);
> >> >+	ccdc_ctx[CCDC_REC656IF] = regr(CCDC_REC656IF);
> >> >+	ccdc_ctx[CCDC_CCDCFG] = regr(CCDC_CCDCFG);
> >> >+	ccdc_ctx[CCDC_FMTCFG] = regr(CCDC_FMTCFG);
> >> >+	ccdc_ctx[CCDC_FMT_HORZ] = regr(CCDC_FMT_HORZ);
> >> >+	ccdc_ctx[CCDC_FMT_VERT] = regr(CCDC_FMT_VERT);
> >> >+	ccdc_ctx[CCDC_FMT_ADDR0] = regr(CCDC_FMT_ADDR0);
> >> >+	ccdc_ctx[CCDC_FMT_ADDR1] = regr(CCDC_FMT_ADDR1);
> >> >+	ccdc_ctx[CCDC_FMT_ADDR2] = regr(CCDC_FMT_ADDR2);
> >> >+	ccdc_ctx[CCDC_FMT_ADDR3] = regr(CCDC_FMT_ADDR3);
> >> >+	ccdc_ctx[CCDC_FMT_ADDR4] = regr(CCDC_FMT_ADDR4);
> >> >+	ccdc_ctx[CCDC_FMT_ADDR5] = regr(CCDC_FMT_ADDR5);
> >> >+	ccdc_ctx[CCDC_FMT_ADDR6] = regr(CCDC_FMT_ADDR6);
> >> >+	ccdc_ctx[CCDC_FMT_ADDR7] = regr(CCDC_FMT_ADDR7);
> >> >+	ccdc_ctx[CCDC_PRGEVEN_0] = regr(CCDC_PRGEVEN_0);
> >> >+	ccdc_ctx[CCDC_PRGEVEN_1] = regr(CCDC_PRGEVEN_1);
> >> >+	ccdc_ctx[CCDC_PRGODD_0] = regr(CCDC_PRGODD_0);
> >> >+	ccdc_ctx[CCDC_PRGODD_1] = regr(CCDC_PRGODD_1);
> >> >+	ccdc_ctx[CCDC_VP_OUT] = regr(CCDC_VP_OUT);
> >> >+}
> >> >+
> >> >+static void ccdc_restore_context(void)
> >> >+{
> >> >+	regw(ccdc_ctx[CCDC_SYN_MODE], CCDC_SYN_MODE);
> >> >+	regw(ccdc_ctx[CCDC_HD_VD_WID], CCDC_HD_VD_WID);
> >> >+	regw(ccdc_ctx[CCDC_PIX_LINES], CCDC_PIX_LINES);
> >> >+	regw(ccdc_ctx[CCDC_HORZ_INFO], CCDC_HORZ_INFO);
> >> >+	regw(ccdc_ctx[CCDC_VERT_START], CCDC_VERT_START);
> >> >+	regw(ccdc_ctx[CCDC_VERT_LINES], CCDC_VERT_LINES);
> >> >+	regw(ccdc_ctx[CCDC_CULLING], CCDC_CULLING);
> >> >+	regw(ccdc_ctx[CCDC_HSIZE_OFF], CCDC_HSIZE_OFF);
> >> >+	regw(ccdc_ctx[CCDC_SDOFST], CCDC_SDOFST);
> >> >+	regw(ccdc_ctx[CCDC_SDR_ADDR], CCDC_SDR_ADDR);
> >> >+	regw(ccdc_ctx[CCDC_CLAMP], CCDC_CLAMP);
> >> >+	regw(ccdc_ctx[CCDC_DCSUB], CCDC_DCSUB);
> >> >+	regw(ccdc_ctx[CCDC_COLPTN], CCDC_COLPTN);
> >> >+	regw(ccdc_ctx[CCDC_BLKCMP], CCDC_BLKCMP);
> >> >+	regw(ccdc_ctx[CCDC_FPC], CCDC_FPC);
> >> >+	regw(ccdc_ctx[CCDC_FPC_ADDR], CCDC_FPC_ADDR);
> >> >+	regw(ccdc_ctx[CCDC_VDINT], CCDC_VDINT);
> >> >+	regw(ccdc_ctx[CCDC_ALAW], CCDC_ALAW);
> >> >+	regw(ccdc_ctx[CCDC_REC656IF], CCDC_REC656IF);
> >> >+	regw(ccdc_ctx[CCDC_CCDCFG], CCDC_CCDCFG);
> >> >+	regw(ccdc_ctx[CCDC_FMTCFG], CCDC_FMTCFG);
> >> >+	regw(ccdc_ctx[CCDC_FMT_HORZ], CCDC_FMT_HORZ);
> >> >+	regw(ccdc_ctx[CCDC_FMT_VERT], CCDC_FMT_VERT);
> >> >+	regw(ccdc_ctx[CCDC_FMT_ADDR0], CCDC_FMT_ADDR0);
> >> >+	regw(ccdc_ctx[CCDC_FMT_ADDR1], CCDC_FMT_ADDR1);
> >> >+	regw(ccdc_ctx[CCDC_FMT_ADDR2], CCDC_FMT_ADDR2);
> >> >+	regw(ccdc_ctx[CCDC_FMT_ADDR3], CCDC_FMT_ADDR3);
> >> >+	regw(ccdc_ctx[CCDC_FMT_ADDR4], CCDC_FMT_ADDR4);
> >> >+	regw(ccdc_ctx[CCDC_FMT_ADDR5], CCDC_FMT_ADDR5);
> >> >+	regw(ccdc_ctx[CCDC_FMT_ADDR6], CCDC_FMT_ADDR6);
> >> >+	regw(ccdc_ctx[CCDC_FMT_ADDR7], CCDC_FMT_ADDR7);
> >> >+	regw(ccdc_ctx[CCDC_PRGEVEN_0], CCDC_PRGEVEN_0);
> >> >+	regw(ccdc_ctx[CCDC_PRGEVEN_1], CCDC_PRGEVEN_1);
> >> >+	regw(ccdc_ctx[CCDC_PRGODD_0], CCDC_PRGODD_0);
> >> >+	regw(ccdc_ctx[CCDC_PRGODD_1], CCDC_PRGODD_1);
> >> >+	regw(ccdc_ctx[CCDC_VP_OUT], CCDC_VP_OUT);
> >> >+	regw(ccdc_ctx[CCDC_PCR], CCDC_PCR);
> >> >+}
> >> > static struct ccdc_hw_device ccdc_hw_dev = {
> >> > 	.name = "DM6446 CCDC",
> >> > 	.owner = THIS_MODULE,
> >> >@@ -858,6 +943,8 @@ static struct ccdc_hw_device ccdc_hw_dev = {
> >> > 		.get_line_length = ccdc_get_line_length,
> >> > 		.setfbaddr = ccdc_setfbaddr,
> >> > 		.getfid = ccdc_getfid,
> >> >+		.save_context = ccdc_save_context,
> >> >+		.restore_context = ccdc_restore_context,
> >> > 	},
> >> > };
> >> >
> >> >diff --git a/drivers/media/video/davinci/vpfe_capture.c
> >> >b/drivers/media/video/davinci/vpfe_capture.c
> >> >index 9c859a7..9b6b254 100644
> >> >--- a/drivers/media/video/davinci/vpfe_capture.c
> >> >+++ b/drivers/media/video/davinci/vpfe_capture.c
> >> >@@ -2394,18 +2394,31 @@ static int vpfe_remove(struct
> >> platform_device
> >> >*pdev)
> >> > 	return 0;
> >> > }
> >> >
> >> >-static int
> >> >-vpfe_suspend(struct device *dev)
> >> >+static int vpfe_suspend(struct device *dev)
> >> > {
> >> >-	/* add suspend code here later */
> >> >-	return -1;
> >> >+	struct vpfe_device *vpfe_dev = dev_get_drvdata(dev);;
> >> >+
> >> >+	if (ccdc_dev->hw_ops.save_context)
> >> >+		ccdc_dev->hw_ops.save_context();
> >> >+	ccdc_dev->hw_ops.enable(0);
> >> >+
> >> >+	if (vpfe_dev)
> >> >+		vpfe_disable_clock(vpfe_dev);
> >> >+
> >> >+	return 0;
> >> > }
> >> >
> >> >-static int
> >> >-vpfe_resume(struct device *dev)
> >> >+static int vpfe_resume(struct device *dev)
> >> > {
> >> >-	/* add resume code here later */
> >> >-	return -1;
> >> >+	struct vpfe_device *vpfe_dev = dev_get_drvdata(dev);;
> >> >+
> >> >+	if (vpfe_dev)
> >> >+		vpfe_enable_clock(vpfe_dev);
> >> >+
> >> >+	if (ccdc_dev->hw_ops.restore_context)
> >> >+		ccdc_dev->hw_ops.restore_context();
> >> >+
> >> >+	return 0;
> >> > }
> >> >
> >> > static struct dev_pm_ops vpfe_dev_pm_ops = {
> >> >--
> >> >1.6.2.4

