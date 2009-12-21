Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:49370 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415AbZLUN3q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2009 08:29:46 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>
Date: Mon, 21 Dec 2009 07:29:44 -0600
Subject: RE: [PATCH] Davinci VPFE Capture: Add Suspend/Resume Support
Message-ID: <A69FA2915331DC488A831521EAE36FE40162A61D6B@dlee06.ent.ti.com>
References: <hvaibhav@ti.com>
 <1258544075-28771-1-git-send-email-hvaibhav@ti.com>
 <A69FA2915331DC488A831521EAE36FE40155A51761@dlee06.ent.ti.com>
 <19F8576C6E063C45BE387C64729E73940449F43E2A@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E73940449F43E2A@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Vaibhav,

Did you address my comments against this patch? What was
the resolution. I haven't seen any response from you. Please
forward me any response that you had sent.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com
>-----Original Message-----
>From: Hiremath, Vaibhav
>Sent: Monday, December 21, 2009 1:29 AM
>To: Karicheri, Muralidharan; linux-media@vger.kernel.org
>Cc: hverkuil@xs4all.nl
>Subject: RE: [PATCH] Davinci VPFE Capture: Add Suspend/Resume Support
>
>> -----Original Message-----
>> From: Karicheri, Muralidharan
>> Sent: Friday, November 20, 2009 3:31 AM
>> To: Hiremath, Vaibhav; linux-media@vger.kernel.org
>> Cc: hverkuil@xs4all.nl
>> Subject: RE: [PATCH] Davinci VPFE Capture: Add Suspend/Resume
>> Support
>>
>> Vaibhav,
>>
>> I have some comments. I have tested this patch for normal
>> use case of tvp5146 capture on DM355. It looks ok. We
>> don't have support for power management on DM355. So I couldn't
>> test the suspend & resume operations.
>>
>[Hiremath, Vaibhav] Murali,
>
>If you don't any further comments/analysis, this patch should go in. I will
>resubmit the patch against the tip.
>
>Thanks,
>Vaibhav
>
>> >
>> > struct ccdc_hw_device {
>> >diff --git a/drivers/media/video/davinci/dm644x_ccdc.c
>> >b/drivers/media/video/davinci/dm644x_ccdc.c
>> >index 5dff8d9..fdab823 100644
>> >--- a/drivers/media/video/davinci/dm644x_ccdc.c
>> >+++ b/drivers/media/video/davinci/dm644x_ccdc.c
>> >@@ -88,6 +88,10 @@ static void *__iomem ccdc_base_addr;
>> > static int ccdc_addr_size;
>> > static enum vpfe_hw_if_type ccdc_if_type;
>> >
>> >+#define CCDC_SZ_REGS			SZ_1K
>> >+
>> >+static u32 ccdc_ctx[CCDC_SZ_REGS / sizeof(u32)];
>>
>> The last register is at 0x94 on DM6446. So do we need 256
>> entries when we have only 37 registers?
>>
>> >+
>> > /* register access routines */
>> > static inline u32 regr(u32 offset)
>> > {
>> >@@ -834,6 +838,87 @@ static int ccdc_set_hw_if_params(struct
>> >vpfe_hw_if_param *params)
>> > 	return 0;
>> > }
>> >
>> >+static void ccdc_save_context(void)
>> >+{
>> >+	ccdc_ctx[CCDC_PCR] = regr(CCDC_PCR);
>>
>>
>> For this and below, You are using every 4th location in the array
>> for saving register values which is not necessary if you use
>> something like.
>> ccdc_ctx[CCDC_PCR >> 2] = regr(CCDC_PCR);
>> ccdc_ctx[CCDC_SYN_MODE >> 2] = regr(CCDC_SYN_MODE);
>> Any reason why you do this way?
>>
>> >+	ccdc_ctx[CCDC_SYN_MODE] = regr(CCDC_SYN_MODE);
>> >+	ccdc_ctx[CCDC_HD_VD_WID] = regr(CCDC_HD_VD_WID);
>> >+	ccdc_ctx[CCDC_PIX_LINES] = regr(CCDC_PIX_LINES);
>> >+	ccdc_ctx[CCDC_HORZ_INFO] = regr(CCDC_HORZ_INFO);
>> >+	ccdc_ctx[CCDC_VERT_START] = regr(CCDC_VERT_START);
>> >+	ccdc_ctx[CCDC_VERT_LINES] = regr(CCDC_VERT_LINES);
>> >+	ccdc_ctx[CCDC_CULLING] = regr(CCDC_CULLING);
>> >+	ccdc_ctx[CCDC_HSIZE_OFF] = regr(CCDC_HSIZE_OFF);
>> >+	ccdc_ctx[CCDC_SDOFST] = regr(CCDC_SDOFST);
>> >+	ccdc_ctx[CCDC_SDR_ADDR] = regr(CCDC_SDR_ADDR);
>> >+	ccdc_ctx[CCDC_CLAMP] = regr(CCDC_CLAMP);
>> >+	ccdc_ctx[CCDC_DCSUB] = regr(CCDC_DCSUB);
>> >+	ccdc_ctx[CCDC_COLPTN] = regr(CCDC_COLPTN);
>> >+	ccdc_ctx[CCDC_BLKCMP] = regr(CCDC_BLKCMP);
>> >+	ccdc_ctx[CCDC_FPC] = regr(CCDC_FPC);
>> >+	ccdc_ctx[CCDC_FPC_ADDR] = regr(CCDC_FPC_ADDR);
>> >+	ccdc_ctx[CCDC_VDINT] = regr(CCDC_VDINT);
>> >+	ccdc_ctx[CCDC_ALAW] = regr(CCDC_ALAW);
>> >+	ccdc_ctx[CCDC_REC656IF] = regr(CCDC_REC656IF);
>> >+	ccdc_ctx[CCDC_CCDCFG] = regr(CCDC_CCDCFG);
>> >+	ccdc_ctx[CCDC_FMTCFG] = regr(CCDC_FMTCFG);
>> >+	ccdc_ctx[CCDC_FMT_HORZ] = regr(CCDC_FMT_HORZ);
>> >+	ccdc_ctx[CCDC_FMT_VERT] = regr(CCDC_FMT_VERT);
>> >+	ccdc_ctx[CCDC_FMT_ADDR0] = regr(CCDC_FMT_ADDR0);
>> >+	ccdc_ctx[CCDC_FMT_ADDR1] = regr(CCDC_FMT_ADDR1);
>> >+	ccdc_ctx[CCDC_FMT_ADDR2] = regr(CCDC_FMT_ADDR2);
>> >+	ccdc_ctx[CCDC_FMT_ADDR3] = regr(CCDC_FMT_ADDR3);
>> >+	ccdc_ctx[CCDC_FMT_ADDR4] = regr(CCDC_FMT_ADDR4);
>> >+	ccdc_ctx[CCDC_FMT_ADDR5] = regr(CCDC_FMT_ADDR5);
>> >+	ccdc_ctx[CCDC_FMT_ADDR6] = regr(CCDC_FMT_ADDR6);
>> >+	ccdc_ctx[CCDC_FMT_ADDR7] = regr(CCDC_FMT_ADDR7);
>> >+	ccdc_ctx[CCDC_PRGEVEN_0] = regr(CCDC_PRGEVEN_0);
>> >+	ccdc_ctx[CCDC_PRGEVEN_1] = regr(CCDC_PRGEVEN_1);
>> >+	ccdc_ctx[CCDC_PRGODD_0] = regr(CCDC_PRGODD_0);
>> >+	ccdc_ctx[CCDC_PRGODD_1] = regr(CCDC_PRGODD_1);
>> >+	ccdc_ctx[CCDC_VP_OUT] = regr(CCDC_VP_OUT);
>> >+}
>> >+
>> >+static void ccdc_restore_context(void)
>> >+{
>> >+	regw(ccdc_ctx[CCDC_SYN_MODE], CCDC_SYN_MODE);
>> >+	regw(ccdc_ctx[CCDC_HD_VD_WID], CCDC_HD_VD_WID);
>> >+	regw(ccdc_ctx[CCDC_PIX_LINES], CCDC_PIX_LINES);
>> >+	regw(ccdc_ctx[CCDC_HORZ_INFO], CCDC_HORZ_INFO);
>> >+	regw(ccdc_ctx[CCDC_VERT_START], CCDC_VERT_START);
>> >+	regw(ccdc_ctx[CCDC_VERT_LINES], CCDC_VERT_LINES);
>> >+	regw(ccdc_ctx[CCDC_CULLING], CCDC_CULLING);
>> >+	regw(ccdc_ctx[CCDC_HSIZE_OFF], CCDC_HSIZE_OFF);
>> >+	regw(ccdc_ctx[CCDC_SDOFST], CCDC_SDOFST);
>> >+	regw(ccdc_ctx[CCDC_SDR_ADDR], CCDC_SDR_ADDR);
>> >+	regw(ccdc_ctx[CCDC_CLAMP], CCDC_CLAMP);
>> >+	regw(ccdc_ctx[CCDC_DCSUB], CCDC_DCSUB);
>> >+	regw(ccdc_ctx[CCDC_COLPTN], CCDC_COLPTN);
>> >+	regw(ccdc_ctx[CCDC_BLKCMP], CCDC_BLKCMP);
>> >+	regw(ccdc_ctx[CCDC_FPC], CCDC_FPC);
>> >+	regw(ccdc_ctx[CCDC_FPC_ADDR], CCDC_FPC_ADDR);
>> >+	regw(ccdc_ctx[CCDC_VDINT], CCDC_VDINT);
>> >+	regw(ccdc_ctx[CCDC_ALAW], CCDC_ALAW);
>> >+	regw(ccdc_ctx[CCDC_REC656IF], CCDC_REC656IF);
>> >+	regw(ccdc_ctx[CCDC_CCDCFG], CCDC_CCDCFG);
>> >+	regw(ccdc_ctx[CCDC_FMTCFG], CCDC_FMTCFG);
>> >+	regw(ccdc_ctx[CCDC_FMT_HORZ], CCDC_FMT_HORZ);
>> >+	regw(ccdc_ctx[CCDC_FMT_VERT], CCDC_FMT_VERT);
>> >+	regw(ccdc_ctx[CCDC_FMT_ADDR0], CCDC_FMT_ADDR0);
>> >+	regw(ccdc_ctx[CCDC_FMT_ADDR1], CCDC_FMT_ADDR1);
>> >+	regw(ccdc_ctx[CCDC_FMT_ADDR2], CCDC_FMT_ADDR2);
>> >+	regw(ccdc_ctx[CCDC_FMT_ADDR3], CCDC_FMT_ADDR3);
>> >+	regw(ccdc_ctx[CCDC_FMT_ADDR4], CCDC_FMT_ADDR4);
>> >+	regw(ccdc_ctx[CCDC_FMT_ADDR5], CCDC_FMT_ADDR5);
>> >+	regw(ccdc_ctx[CCDC_FMT_ADDR6], CCDC_FMT_ADDR6);
>> >+	regw(ccdc_ctx[CCDC_FMT_ADDR7], CCDC_FMT_ADDR7);
>> >+	regw(ccdc_ctx[CCDC_PRGEVEN_0], CCDC_PRGEVEN_0);
>> >+	regw(ccdc_ctx[CCDC_PRGEVEN_1], CCDC_PRGEVEN_1);
>> >+	regw(ccdc_ctx[CCDC_PRGODD_0], CCDC_PRGODD_0);
>> >+	regw(ccdc_ctx[CCDC_PRGODD_1], CCDC_PRGODD_1);
>> >+	regw(ccdc_ctx[CCDC_VP_OUT], CCDC_VP_OUT);
>> >+	regw(ccdc_ctx[CCDC_PCR], CCDC_PCR);
>> Ditto
>> >+}
>> > static struct ccdc_hw_device ccdc_hw_dev = {
>> > 	.name = "DM6446 CCDC",
>> > 	.owner = THIS_MODULE,
>> >@@ -858,6 +943,8 @@ static struct ccdc_hw_device ccdc_hw_dev = {
>> > 		.get_line_length = ccdc_get_line_length,
>> > 		.setfbaddr = ccdc_setfbaddr,
>> > 		.getfid = ccdc_getfid,
>> >+		.save_context = ccdc_save_context,
>> >+		.restore_context = ccdc_restore_context,
>> > 	},
>> > };
>> >
>> >diff --git a/drivers/media/video/davinci/vpfe_capture.c
>> >b/drivers/media/video/davinci/vpfe_capture.c
>> >index 9c859a7..9b6b254 100644
>> >--- a/drivers/media/video/davinci/vpfe_capture.c
>> >+++ b/drivers/media/video/davinci/vpfe_capture.c
>> >@@ -2394,18 +2394,31 @@ static int vpfe_remove(struct
>> platform_device
>> >*pdev)
>> > 	return 0;
>> > }
>> >
>> >-static int
>> >-vpfe_suspend(struct device *dev)
>> >+static int vpfe_suspend(struct device *dev)
>> > {
>> >-	/* add suspend code here later */
>> >-	return -1;
>> >+	struct vpfe_device *vpfe_dev = dev_get_drvdata(dev);;
>> >+
>> >+	if (ccdc_dev->hw_ops.save_context)
>> >+		ccdc_dev->hw_ops.save_context();
>> >+	ccdc_dev->hw_ops.enable(0);
>> >+
>> >+	if (vpfe_dev)
>> >+		vpfe_disable_clock(vpfe_dev);
>> >+
>> >+	return 0;
>> > }
>> >
>> >-static int
>> >-vpfe_resume(struct device *dev)
>> >+static int vpfe_resume(struct device *dev)
>> > {
>> >-	/* add resume code here later */
>> >-	return -1;
>> >+	struct vpfe_device *vpfe_dev = dev_get_drvdata(dev);;
>> >+
>> >+	if (vpfe_dev)
>> >+		vpfe_enable_clock(vpfe_dev);
>> >+
>> >+	if (ccdc_dev->hw_ops.restore_context)
>> >+		ccdc_dev->hw_ops.restore_context();
>> >+
>> >+	return 0;
>> > }
>> >
>> > static struct dev_pm_ops vpfe_dev_pm_ops = {
>> >--
>> >1.6.2.4

