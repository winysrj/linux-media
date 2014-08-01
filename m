Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59962 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaHAN5H (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Aug 2014 09:57:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Stefan Herbrechtsmeier <stefan@herbrechtsmeier.net>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Problems with the omap3isp
Date: Fri, 01 Aug 2014 15:57:31 +0200
Message-ID: <3376696.nE771YBFja@avalon>
In-Reply-To: <53D9FE71.5080402@herbrechtsmeier.net>
References: <53C4FC99.9050308@herbrechtsmeier.net> <5912662.x67xxWZ5ks@avalon> <53D9FE71.5080402@herbrechtsmeier.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stefan,

On Thursday 31 July 2014 10:29:37 Stefan Herbrechtsmeier wrote:
> Am 31.07.2014 01:10, schrieb Laurent Pinchart:
> > On Tuesday 15 July 2014 12:04:09 Stefan Herbrechtsmeier wrote:
> >> Hi Laurent,
> >> 
> >> I have some problems with the omap3isp driver. At the moment I use a
> >> linux-stable 3.14.5 with your fixes for omap3xxx-clocks.dtsi.
> >> 
> >> 1. If I change the clock rate to 24 MHz in my camera driver the whole
> >> system freeze at the clk_prepare_enable. The first enable and disable
> >> works without any problem. The system freeze during a systemd / udev
> >> call of media-ctl.
> > 
> > I've never seen that before. Where does your sensor get its clock from ?
> > Is it connected to the ISP XCLKA or XCLKB output ?
> 
> XCLKA
> 
> > What happens if you don't change the clock rate to 24 MHz ? What rate is
> > it set to in that case ?
> 
> It works if I use a clock rate of 12 MHz or 36 MHz.
> 
> I use the following lines during power enable in the driver:
>      clk_set_rate(ov5647->clk, 24000000);
>      clk_prepare_enable(ov5647->clk);
> 
> This works during probe, but the second time I try to power up the
> device the system stall after clk_prepare_enable.

Just to make sure I understand properly, if you change the above frequency
value to 12000000 or 36000000 without modifying anything else, the problem
doesn't occur ?

Do you start streaming at all at any point ?

> I see the following dump:

[snip]

Looks like the CPU spends all its time processing interrupts. Could you
please try the following patch ? It should disable the ISP interrupt after
100000 occurrences, and create an isr_account property in sysfs that will
report the number of interrupts generated for each source. If my guess is
correct, you will hit the 100000 interrupts limit very quickly and the system
will unfreeze. If so, please report the content of /proc/interrupts and of
the isr_account property (if I remember correctly it should be located in
/sys/class/video4linux/video0/device/media0/ but you might need to search for
it).

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index de2dec5..c4e6455 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -400,6 +400,38 @@ static inline void isp_isr_dbg(struct isp_device *isp, u32 irqstatus)
 	printk(KERN_CONT "\n");
 }
 
+static unsigned int isp_isr_count[32];
+
+static inline void isp_isr_account(struct isp_device *isp, u32 irqstatus)
+{
+	unsigned int i;
+
+	spin_lock(&isp->isr_account_lock);
+	for (i = 0; i < 32; i++) {
+		if (irqstatus & (1 << i))
+			isp_isr_count[i]++;
+	}
+	spin_unlock(&isp->isr_account_lock);
+}
+
+static ssize_t isp_isr_account_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct isp_device *isp = container_of(to_media_device(to_media_devnode(dev)), struct isp_device, media_dev);
+	unsigned long flags;
+	unsigned int i;
+	int ret = 0;
+
+	spin_lock_irqsave(&isp->isr_account_lock, flags);
+	for (i = 0; i < 32; i++)
+		ret += sprintf(buf + ret, "%u\t%u\n", i, isp_isr_count[i]);
+	spin_unlock_irqrestore(&isp->isr_account_lock, flags);
+
+	return ret;
+}
+
+static DEVICE_ATTR(isr_account, S_IRUGO, isp_isr_account_show, NULL);
+
 static void isp_isr_sbl(struct isp_device *isp)
 {
 	struct device *dev = isp->dev;
@@ -462,6 +494,7 @@ static irqreturn_t isp_isr(int irq, void *_isp)
 				       IRQ0STATUS_CCDC_VD0_IRQ |
 				       IRQ0STATUS_CCDC_VD1_IRQ |
 				       IRQ0STATUS_HS_VS_IRQ;
+	static unsigned int count = 0;
 	struct isp_device *isp = _isp;
 	u32 irqstatus;
 	int ret;
@@ -469,6 +502,10 @@ static irqreturn_t isp_isr(int irq, void *_isp)
 	irqstatus = isp_reg_readl(isp, OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS);
 	isp_reg_writel(isp, irqstatus, OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS);
 
+	isp_isr_account(isp, irqstatus);
+	if (count++ >= 100000)
+		isp_disable_interrupts(isp);
+
 	isp_isr_sbl(isp);
 
 	if (irqstatus & IRQ0STATUS_CSIA_IRQ) {
@@ -1971,6 +2008,7 @@ static int isp_remove(struct platform_device *pdev)
 	struct isp_device *isp = platform_get_drvdata(pdev);
 	int i;
 
+	device_remove_file(&isp->media_dev.devnode.dev, &dev_attr_isr_account);
 	isp_unregister_entities(isp);
 	isp_cleanup_modules(isp);
 
@@ -2067,6 +2105,7 @@ static int isp_probe(struct platform_device *pdev)
 
 	mutex_init(&isp->isp_mutex);
 	spin_lock_init(&isp->stat_lock);
+	spin_lock_init(&isp->isr_account_lock);
 
 	isp->dev = &pdev->dev;
 	isp->pdata = pdata;
@@ -2156,6 +2195,8 @@ static int isp_probe(struct platform_device *pdev)
 	isp_power_settings(isp, 1);
 	omap3isp_put(isp);
 
+	ret = device_create_file(&isp->media_dev.devnode.dev, &dev_attr_isr_account);
+
 	return 0;
 
 error_modules:
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index 2620c40..b3f8448 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -259,6 +259,7 @@ struct isp_device {
 
 	/* ISP Obj */
 	spinlock_t stat_lock;	/* common lock for statistic drivers */
+	spinlock_t isr_account_lock;
 	struct mutex isp_mutex;	/* For handling ref_count field */
 	bool needs_reset;
 	int has_context;


-- 
Regards,

Laurent Pinchart

