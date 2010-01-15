Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:54210 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab0AOQg1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2010 11:36:27 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "mchehab@infradead.org" <mchehab@infradead.org>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"mchehab@infradead.org" <mchehab@infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 15 Jan 2010 10:36:15 -0600
Subject: [PATCH - v4 1/4] V4L - vpfe_capture-remove clock and platform code
Message-ID: <A69FA2915331DC488A831521EAE36FE40162E9D3F5@dlee06.ent.ti.com>
References: <1263425228-14625-1-git-send-email-m-karicheri2@ti.com>
	<A69FA2915331DC488A831521EAE36FE40162DFA844@dlee06.ent.ti.com>
	<87r5ps5s6j.fsf@deeprootsystems.com>
 <A69FA2915331DC488A831521EAE36FE40162E9D14F@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40162E9D14F@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

I know you are busy, but this patch is sitting too long for merge
and require your service. Could you at least respond to my email with
your plan so that I can work on the next patch set for your merge.

Thanks and regards,

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: davinci-linux-open-source-bounces@linux.davincidsp.com
>[mailto:davinci-linux-open-source-bounces@linux.davincidsp.com] On Behalf
>Of Karicheri, Muralidharan
>Sent: Thursday, January 14, 2010 4:24 PM
>To: mchehab@infradead.org
>Cc: davinci-linux-open-source@linux.davincidsp.com; mchehab@infradead.org;
>linux-media@vger.kernel.org
>Subject: RE: [PATCH - v4 1/4] V4L - vpfe_capture-remove clock and platform
>code
>
>Mauro,
>
>Could you add patches 1-3 to linux-next ASAP?
>
>See the response from Kevin for the arch part.
>
>Murali Karicheri
>Software Design Engineer
>Texas Instruments Inc.
>Germantown, MD 20874
>phone: 301-407-9583
>email: m-karicheri2@ti.com
>
>>-----Original Message-----
>>From: Kevin Hilman [mailto:khilman@deeprootsystems.com]
>>Sent: Thursday, January 14, 2010 3:48 PM
>>To: Karicheri, Muralidharan
>>Cc: linux-media@vger.kernel.org; hverkuil@xs4all.nl;
>mchehab@infradead.org;
>>davinci-linux-open-source@linux.davincidsp.com
>>Subject: Re: [PATCH - v4 1/4] V4L - vpfe_capture-remove clock and platform
>>code
>>
>>"Karicheri, Muralidharan" <m-karicheri2@ti.com> writes:
>>
>>> Mauro,
>>>
>>> Please merge this patches if there are no more comments.
>>>
>>> Kevin,
>>>
>>> Could you work with Mauro to merge the arch part as required?
>>>
>>
>>This version looks good with me.
>>
>>I'll assume that these are targed for 2.6.34, not 2.6.33-rc fixes window.
>>
>>These appear to be able at least compile independently, so as soon as
>>Mauro/Hans sign-off on them, I willll add PATCH 4/4 to davinci-next so
>>it will be queued for 2.6.34 and be a part of linux-next.
>>
>>Mauro can queue patches 1-3 in his queue for 2.6.34.  They will both
>>be in linux-next for testing.
>>
>>Also, I can *temporarily* add patches 1-3 to davinci git so davinci git
>>will have them all while waiting for 2.6.34 merge window.  I will then
>>drop them when Mauro's tree merges upstream.
>>
>>Kevin
>>
>>> Murali Karicheri
>>> Software Design Engineer
>>> Texas Instruments Inc.
>>> Germantown, MD 20874
>>> phone: 301-407-9583
>>> email: m-karicheri2@ti.com
>>>
>>>>-----Original Message-----
>>>>From: Karicheri, Muralidharan
>>>>Sent: Wednesday, January 13, 2010 6:27 PM
>>>>To: linux-media@vger.kernel.org; hverkuil@xs4all.nl;
>>>>khilman@deeprootsystems.com; mchehab@infradead.org
>>>>Cc: davinci-linux-open-source@linux.davincidsp.com; Karicheri,
>>Muralidharan
>>>>Subject: [PATCH - v4 1/4] V4L - vpfe_capture-remove clock and platform
>>code
>>>>
>>>>From: Muralidharan Karicheri <m-karicheri2@ti.com>
>>>>
>>>>Following changes are done in this patch:-
>>>>	1) removed the platform code and clk configuration. They are now
>>>>           part of ccdc driver (part of the ccdc patches and platform
>>>>patches 2-4)
>>>>	2) Added proper error codes for ccdc register function
>>>>
>>>>Reviewed-by: Vaibhav Hiremath <hvaibhav@ti.com>
>>>>Reviewed-by: Kevin Hilman <khilman@deeprootsystems.com>
>>>>Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
>>>>
>>>>Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
>>>>Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
>>>>---
>>>>Rebased to latest linux-next tree of v4l-dvb
>>>>This combines the two patches sent earlier to change the clock
>>>>configuration
>>>>and converting ccdc drivers to platform drivers. This has updated
>>comments
>>>>against v1 of these patches.
>>>>
>>>> drivers/media/video/davinci/vpfe_capture.c |  131 +++------------------
>-
>>--
>>>>----
>>>> 1 files changed, 13 insertions(+), 118 deletions(-)
>>>>
>>>>diff --git a/drivers/media/video/davinci/vpfe_capture.c
>>>>b/drivers/media/video/davinci/vpfe_capture.c
>>>>index de22bc9..885cd54 100644
>>>>--- a/drivers/media/video/davinci/vpfe_capture.c
>>>>+++ b/drivers/media/video/davinci/vpfe_capture.c
>>>>@@ -107,9 +107,6 @@ struct ccdc_config {
>>>> 	int vpfe_probed;
>>>> 	/* name of ccdc device */
>>>> 	char name[32];
>>>>-	/* for storing mem maps for CCDC */
>>>>-	int ccdc_addr_size;
>>>>-	void *__iomem ccdc_addr;
>>>> };
>>>>
>>>> /* data structures */
>>>>@@ -229,7 +226,6 @@ int vpfe_register_ccdc_device(struct ccdc_hw_device
>>>>*dev)
>>>> 	BUG_ON(!dev->hw_ops.set_image_window);
>>>> 	BUG_ON(!dev->hw_ops.get_image_window);
>>>> 	BUG_ON(!dev->hw_ops.get_line_length);
>>>>-	BUG_ON(!dev->hw_ops.setfbaddr);
>>>> 	BUG_ON(!dev->hw_ops.getfid);
>>>>
>>>> 	mutex_lock(&ccdc_lock);
>>>>@@ -240,25 +236,23 @@ int vpfe_register_ccdc_device(struct
>ccdc_hw_device
>>>>*dev)
>>>> 		 * walk through it during vpfe probe
>>>> 		 */
>>>> 		printk(KERN_ERR "vpfe capture not initialized\n");
>>>>-		ret = -1;
>>>>+		ret = -EFAULT;
>>>> 		goto unlock;
>>>> 	}
>>>>
>>>> 	if (strcmp(dev->name, ccdc_cfg->name)) {
>>>> 		/* ignore this ccdc */
>>>>-		ret = -1;
>>>>+		ret = -EINVAL;
>>>> 		goto unlock;
>>>> 	}
>>>>
>>>> 	if (ccdc_dev) {
>>>> 		printk(KERN_ERR "ccdc already registered\n");
>>>>-		ret = -1;
>>>>+		ret = -EINVAL;
>>>> 		goto unlock;
>>>> 	}
>>>>
>>>> 	ccdc_dev = dev;
>>>>-	dev->hw_ops.set_ccdc_base(ccdc_cfg->ccdc_addr,
>>>>-				  ccdc_cfg->ccdc_addr_size);
>>>> unlock:
>>>> 	mutex_unlock(&ccdc_lock);
>>>> 	return ret;
>>>>@@ -1786,61 +1780,6 @@ static struct vpfe_device *vpfe_initialize(void)
>>>> 	return vpfe_dev;
>>>> }
>>>>
>>>>-static void vpfe_disable_clock(struct vpfe_device *vpfe_dev)
>>>>-{
>>>>-	struct vpfe_config *vpfe_cfg = vpfe_dev->cfg;
>>>>-
>>>>-	clk_disable(vpfe_cfg->vpssclk);
>>>>-	clk_put(vpfe_cfg->vpssclk);
>>>>-	clk_disable(vpfe_cfg->slaveclk);
>>>>-	clk_put(vpfe_cfg->slaveclk);
>>>>-	v4l2_info(vpfe_dev->pdev->driver,
>>>>-		 "vpfe vpss master & slave clocks disabled\n");
>>>>-}
>>>>-
>>>>-static int vpfe_enable_clock(struct vpfe_device *vpfe_dev)
>>>>-{
>>>>-	struct vpfe_config *vpfe_cfg = vpfe_dev->cfg;
>>>>-	int ret = -ENOENT;
>>>>-
>>>>-	vpfe_cfg->vpssclk = clk_get(vpfe_dev->pdev, "vpss_master");
>>>>-	if (NULL == vpfe_cfg->vpssclk) {
>>>>-		v4l2_err(vpfe_dev->pdev->driver, "No clock defined for"
>>>>-			 "vpss_master\n");
>>>>-		return ret;
>>>>-	}
>>>>-
>>>>-	if (clk_enable(vpfe_cfg->vpssclk)) {
>>>>-		v4l2_err(vpfe_dev->pdev->driver,
>>>>-			"vpfe vpss master clock not enabled\n");
>>>>-		goto out;
>>>>-	}
>>>>-	v4l2_info(vpfe_dev->pdev->driver,
>>>>-		 "vpfe vpss master clock enabled\n");
>>>>-
>>>>-	vpfe_cfg->slaveclk = clk_get(vpfe_dev->pdev, "vpss_slave");
>>>>-	if (NULL == vpfe_cfg->slaveclk) {
>>>>-		v4l2_err(vpfe_dev->pdev->driver,
>>>>-			"No clock defined for vpss slave\n");
>>>>-		goto out;
>>>>-	}
>>>>-
>>>>-	if (clk_enable(vpfe_cfg->slaveclk)) {
>>>>-		v4l2_err(vpfe_dev->pdev->driver,
>>>>-			 "vpfe vpss slave clock not enabled\n");
>>>>-		goto out;
>>>>-	}
>>>>-	v4l2_info(vpfe_dev->pdev->driver, "vpfe vpss slave clock enabled\n");
>>>>-	return 0;
>>>>-out:
>>>>-	if (vpfe_cfg->vpssclk)
>>>>-		clk_put(vpfe_cfg->vpssclk);
>>>>-	if (vpfe_cfg->slaveclk)
>>>>-		clk_put(vpfe_cfg->slaveclk);
>>>>-
>>>>-	return -1;
>>>>-}
>>>>-
>>>> /*
>>>>  * vpfe_probe : This function creates device entries by register
>>>>  * itself to the V4L2 driver and initializes fields of each
>>>>@@ -1870,7 +1809,7 @@ static __init int vpfe_probe(struct
>platform_device
>>>>*pdev)
>>>>
>>>> 	if (NULL == pdev->dev.platform_data) {
>>>> 		v4l2_err(pdev->dev.driver, "Unable to get vpfe config\n");
>>>>-		ret = -ENOENT;
>>>>+		ret = -ENODEV;
>>>> 		goto probe_free_dev_mem;
>>>> 	}
>>>>
>>>>@@ -1884,18 +1823,13 @@ static __init int vpfe_probe(struct
>>platform_device
>>>>*pdev)
>>>> 		goto probe_free_dev_mem;
>>>> 	}
>>>>
>>>>-	/* enable vpss clocks */
>>>>-	ret = vpfe_enable_clock(vpfe_dev);
>>>>-	if (ret)
>>>>-		goto probe_free_dev_mem;
>>>>-
>>>> 	mutex_lock(&ccdc_lock);
>>>> 	/* Allocate memory for ccdc configuration */
>>>> 	ccdc_cfg = kmalloc(sizeof(struct ccdc_config), GFP_KERNEL);
>>>> 	if (NULL == ccdc_cfg) {
>>>> 		v4l2_err(pdev->dev.driver,
>>>> 			 "Memory allocation failed for ccdc_cfg\n");
>>>>-		goto probe_disable_clock;
>>>>+		goto probe_free_dev_mem;
>>>> 	}
>>>>
>>>> 	strncpy(ccdc_cfg->name, vpfe_cfg->ccdc, 32);
>>>>@@ -1904,61 +1838,34 @@ static __init int vpfe_probe(struct
>>platform_device
>>>>*pdev)
>>>> 	if (!res1) {
>>>> 		v4l2_err(pdev->dev.driver,
>>>> 			 "Unable to get interrupt for VINT0\n");
>>>>-		ret = -ENOENT;
>>>>-		goto probe_disable_clock;
>>>>+		ret = -ENODEV;
>>>>+		goto probe_free_ccdc_cfg_mem;
>>>> 	}
>>>> 	vpfe_dev->ccdc_irq0 = res1->start;
>>>>
>>>> 	/* Get VINT1 irq resource */
>>>>-	res1 = platform_get_resource(pdev,
>>>>-				IORESOURCE_IRQ, 1);
>>>>+	res1 = platform_get_resource(pdev, IORESOURCE_IRQ, 1);
>>>> 	if (!res1) {
>>>> 		v4l2_err(pdev->dev.driver,
>>>> 			 "Unable to get interrupt for VINT1\n");
>>>>-		ret = -ENOENT;
>>>>-		goto probe_disable_clock;
>>>>+		ret = -ENODEV;
>>>>+		goto probe_free_ccdc_cfg_mem;
>>>> 	}
>>>> 	vpfe_dev->ccdc_irq1 = res1->start;
>>>>
>>>>-	/* Get address base of CCDC */
>>>>-	res1 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>>-	if (!res1) {
>>>>-		v4l2_err(pdev->dev.driver,
>>>>-			"Unable to get register address map\n");
>>>>-		ret = -ENOENT;
>>>>-		goto probe_disable_clock;
>>>>-	}
>>>>-
>>>>-	ccdc_cfg->ccdc_addr_size = res1->end - res1->start + 1;
>>>>-	if (!request_mem_region(res1->start, ccdc_cfg->ccdc_addr_size,
>>>>-				pdev->dev.driver->name)) {
>>>>-		v4l2_err(pdev->dev.driver,
>>>>-			"Failed request_mem_region for ccdc base\n");
>>>>-		ret = -ENXIO;
>>>>-		goto probe_disable_clock;
>>>>-	}
>>>>-	ccdc_cfg->ccdc_addr = ioremap_nocache(res1->start,
>>>>-					     ccdc_cfg->ccdc_addr_size);
>>>>-	if (!ccdc_cfg->ccdc_addr) {
>>>>-		v4l2_err(pdev->dev.driver, "Unable to ioremap ccdc addr\n");
>>>>-		ret = -ENXIO;
>>>>-		goto probe_out_release_mem1;
>>>>-	}
>>>>-
>>>> 	ret = request_irq(vpfe_dev->ccdc_irq0, vpfe_isr, IRQF_DISABLED,
>>>> 			  "vpfe_capture0", vpfe_dev);
>>>>
>>>> 	if (0 != ret) {
>>>> 		v4l2_err(pdev->dev.driver, "Unable to request interrupt\n");
>>>>-		goto probe_out_unmap1;
>>>>+		goto probe_free_ccdc_cfg_mem;
>>>> 	}
>>>>
>>>> 	/* Allocate memory for video device */
>>>> 	vfd = video_device_alloc();
>>>> 	if (NULL == vfd) {
>>>> 		ret = -ENOMEM;
>>>>-		v4l2_err(pdev->dev.driver,
>>>>-			"Unable to alloc video device\n");
>>>>+		v4l2_err(pdev->dev.driver, "Unable to alloc video device\n");
>>>> 		goto probe_out_release_irq;
>>>> 	}
>>>>
>>>>@@ -2073,12 +1980,7 @@ probe_out_video_release:
>>>> 		video_device_release(vpfe_dev->video_dev);
>>>> probe_out_release_irq:
>>>> 	free_irq(vpfe_dev->ccdc_irq0, vpfe_dev);
>>>>-probe_out_unmap1:
>>>>-	iounmap(ccdc_cfg->ccdc_addr);
>>>>-probe_out_release_mem1:
>>>>-	release_mem_region(res1->start, res1->end - res1->start + 1);
>>>>-probe_disable_clock:
>>>>-	vpfe_disable_clock(vpfe_dev);
>>>>+probe_free_ccdc_cfg_mem:
>>>> 	mutex_unlock(&ccdc_lock);
>>>> 	kfree(ccdc_cfg);
>>>> probe_free_dev_mem:
>>>>@@ -2092,7 +1994,6 @@ probe_free_dev_mem:
>>>> static int __devexit vpfe_remove(struct platform_device *pdev)
>>>> {
>>>> 	struct vpfe_device *vpfe_dev = platform_get_drvdata(pdev);
>>>>-	struct resource *res;
>>>>
>>>> 	v4l2_info(pdev->dev.driver, "vpfe_remove\n");
>>>>
>>>>@@ -2100,12 +2001,6 @@ static int __devexit vpfe_remove(struct
>>>>platform_device *pdev)
>>>> 	kfree(vpfe_dev->sd);
>>>> 	v4l2_device_unregister(&vpfe_dev->v4l2_dev);
>>>> 	video_unregister_device(vpfe_dev->video_dev);
>>>>-	mutex_lock(&ccdc_lock);
>>>>-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>>-	release_mem_region(res->start, res->end - res->start + 1);
>>>>-	iounmap(ccdc_cfg->ccdc_addr);
>>>>-	mutex_unlock(&ccdc_lock);
>>>>-	vpfe_disable_clock(vpfe_dev);
>>>> 	kfree(vpfe_dev);
>>>> 	kfree(ccdc_cfg);
>>>> 	return 0;
>>>>--
>>>>1.6.0.4
>_______________________________________________
>Davinci-linux-open-source mailing list
>Davinci-linux-open-source@linux.davincidsp.com
>http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
