Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:36303 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864AbZLCUWx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 15:22:53 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 3 Dec 2009 14:22:58 -0600
Subject: RE: [PATCH - v1 1/2] V4L - vpfe capture - make clocks configurable
Message-ID: <A69FA2915331DC488A831521EAE36FE40155B7763A@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

Please hold on to this. I will send you an updated patch.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Karicheri, Muralidharan
>Sent: Tuesday, December 01, 2009 12:22 PM
>To: 'Hans Verkuil'
>Cc: Hiremath, Vaibhav; linux-media@vger.kernel.org
>Subject: FW: [PATCH - v1 1/2] V4L - vpfe capture - make clocks configurable
>
>Hans,
>
>Could you please add this to your hg tree and send a pull
>request to Mauro? This was reviewed by Vaibhav and tested on
>DM355, DM6446, AM3517 & DM365. I will request Kevin to pull
>the Architecture part of this patch.
>
>Thanks.
>
>Murali Karicheri
>Software Design Engineer
>Texas Instruments Inc.
>Germantown, MD 20874
>phone: 301-407-9583
>email: m-karicheri2@ti.com
>
>>-----Original Message-----
>>From: Karicheri, Muralidharan
>>Sent: Tuesday, December 01, 2009 12:19 PM
>>To: linux-media@vger.kernel.org; hverkuil@xs4all.nl;
>>khilman@deeprootsystems.com
>>Cc: davinci-linux-open-source@linux.davincidsp.com; Hiremath, Vaibhav;
>>Karicheri, Muralidharan
>>Subject: [PATCH - v1 1/2] V4L - vpfe capture - make clocks configurable
>>
>>From: Muralidharan Karicheri <m-karicheri2@ti.com>
>>
>>v1  - updated based on comments from Vaibhav Hiremath.
>>
>>On DM365 we use only vpss master clock, where as on DM355 and
>>DM6446, we use vpss master and slave clocks for vpfe capture and AM3517
>>we use internal clock and pixel clock. So this patch makes it configurable
>>on a per platform basis. This is needed for supporting DM365 for which
>>patches
>>will be available soon.
>>
>>Tested-by: Vaibhav Hiremath <hvaibhav@ti.com>, Muralidharan Karicheri <m-
>>karicheri2@ti.com>
>>Acked-by: Vaibhav Hiremath <hvaibhav@ti.com>
>>Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
>>---
>> drivers/media/video/davinci/vpfe_capture.c |   98 +++++++++++++++++------
>-
>>---
>> include/media/davinci/vpfe_capture.h       |   11 ++-
>> 2 files changed, 70 insertions(+), 39 deletions(-)
>>
>>diff --git a/drivers/media/video/davinci/vpfe_capture.c
>>b/drivers/media/video/davinci/vpfe_capture.c
>>index 12a1b3d..c3468ee 100644
>>--- a/drivers/media/video/davinci/vpfe_capture.c
>>+++ b/drivers/media/video/davinci/vpfe_capture.c
>>@@ -1787,61 +1787,87 @@ static struct vpfe_device *vpfe_initialize(void)
>> 	return vpfe_dev;
>> }
>>
>>+/**
>>+ * vpfe_disable_clock() - Disable clocks for vpfe capture driver
>>+ * @vpfe_dev - ptr to vpfe capture device
>>+ *
>>+ * Disables clocks defined in vpfe configuration.
>>+ */
>> static void vpfe_disable_clock(struct vpfe_device *vpfe_dev)
>> {
>> 	struct vpfe_config *vpfe_cfg = vpfe_dev->cfg;
>>+	int i;
>>
>>-	clk_disable(vpfe_cfg->vpssclk);
>>-	clk_put(vpfe_cfg->vpssclk);
>>-	clk_disable(vpfe_cfg->slaveclk);
>>-	clk_put(vpfe_cfg->slaveclk);
>>-	v4l2_info(vpfe_dev->pdev->driver,
>>-		 "vpfe vpss master & slave clocks disabled\n");
>>+	for (i = 0; i < vpfe_cfg->num_clocks; i++) {
>>+		clk_disable(vpfe_dev->clks[i]);
>>+		clk_put(vpfe_dev->clks[i]);
>>+	}
>>+	kfree(vpfe_dev->clks);
>>+	v4l2_info(vpfe_dev->pdev->driver, "vpfe capture clocks disabled\n");
>> }
>>
>>+/**
>>+ * vpfe_enable_clock() - Enable clocks for vpfe capture driver
>>+ * @vpfe_dev - ptr to vpfe capture device
>>+ *
>>+ * Enables clocks defined in vpfe configuration. The function
>>+ * assumes that at least one clock is to be defined which is
>>+ * true as of now. re-visit this if this assumption is not true
>>+ */
>> static int vpfe_enable_clock(struct vpfe_device *vpfe_dev)
>> {
>> 	struct vpfe_config *vpfe_cfg = vpfe_dev->cfg;
>>-	int ret = -ENOENT;
>>+	int i;
>>
>>-	vpfe_cfg->vpssclk = clk_get(vpfe_dev->pdev, "vpss_master");
>>-	if (NULL == vpfe_cfg->vpssclk) {
>>-		v4l2_err(vpfe_dev->pdev->driver, "No clock defined for"
>>-			 "vpss_master\n");
>>-		return ret;
>>-	}
>>+	if (!vpfe_cfg->num_clocks)
>>+		return 0;
>>
>>-	if (clk_enable(vpfe_cfg->vpssclk)) {
>>-		v4l2_err(vpfe_dev->pdev->driver,
>>-			"vpfe vpss master clock not enabled\n");
>>-		goto out;
>>-	}
>>-	v4l2_info(vpfe_dev->pdev->driver,
>>-		 "vpfe vpss master clock enabled\n");
>>+	vpfe_dev->clks = kzalloc(vpfe_cfg->num_clocks *
>>+				   sizeof(struct clock *), GFP_KERNEL);
>>
>>-	vpfe_cfg->slaveclk = clk_get(vpfe_dev->pdev, "vpss_slave");
>>-	if (NULL == vpfe_cfg->slaveclk) {
>>-		v4l2_err(vpfe_dev->pdev->driver,
>>-			"No clock defined for vpss slave\n");
>>-		goto out;
>>+	if (NULL == vpfe_dev->clks) {
>>+		v4l2_err(vpfe_dev->pdev->driver, "Memory allocation failed\n");
>>+		return -ENOMEM;
>> 	}
>>
>>-	if (clk_enable(vpfe_cfg->slaveclk)) {
>>-		v4l2_err(vpfe_dev->pdev->driver,
>>-			 "vpfe vpss slave clock not enabled\n");
>>-		goto out;
>>+	for (i = 0; i < vpfe_cfg->num_clocks; i++) {
>>+		if (NULL == vpfe_cfg->clocks[i]) {
>>+			v4l2_err(vpfe_dev->pdev->driver,
>>+				"clock %s is not defined in vpfe config\n",
>>+				vpfe_cfg->clocks[i]);
>>+			goto out;
>>+		}
>>+
>>+		vpfe_dev->clks[i] = clk_get(vpfe_dev->pdev,
>>+					      vpfe_cfg->clocks[i]);
>>+		if (NULL == vpfe_dev->clks[i]) {
>>+			v4l2_err(vpfe_dev->pdev->driver,
>>+				"Failed to get clock %s\n",
>>+				vpfe_cfg->clocks[i]);
>>+			goto out;
>>+		}
>>+
>>+		if (clk_enable(vpfe_dev->clks[i])) {
>>+			v4l2_err(vpfe_dev->pdev->driver,
>>+				"vpfe clock %s not enabled\n",
>>+				vpfe_cfg->clocks[i]);
>>+			goto out;
>>+		}
>>+
>>+		v4l2_info(vpfe_dev->pdev->driver, "vpss clock %s enabled",
>>+			  vpfe_cfg->clocks[i]);
>> 	}
>>-	v4l2_info(vpfe_dev->pdev->driver, "vpfe vpss slave clock enabled\n");
>> 	return 0;
>> out:
>>-	if (vpfe_cfg->vpssclk)
>>-		clk_put(vpfe_cfg->vpssclk);
>>-	if (vpfe_cfg->slaveclk)
>>-		clk_put(vpfe_cfg->slaveclk);
>>-
>>-	return -1;
>>+	for (i = 0; i < vpfe_cfg->num_clocks; i++) {
>>+		if (vpfe_dev->clks[i])
>>+			clk_put(vpfe_dev->clks[i]);
>>+	}
>>+	kfree(vpfe_dev->clks);
>>+	return -EFAULT;
>> }
>>
>>+
>> /*
>>  * vpfe_probe : This function creates device entries by register
>>  * itself to the V4L2 driver and initializes fields of each
>>diff --git a/include/media/davinci/vpfe_capture.h
>>b/include/media/davinci/vpfe_capture.h
>>index d863e5e..7b62a5c 100644
>>--- a/include/media/davinci/vpfe_capture.h
>>+++ b/include/media/davinci/vpfe_capture.h
>>@@ -31,8 +31,6 @@
>> #include <media/videobuf-dma-contig.h>
>> #include <media/davinci/vpfe_types.h>
>>
>>-#define VPFE_CAPTURE_NUM_DECODERS        5
>>-
>> /* Macros */
>> #define VPFE_MAJOR_RELEASE              0
>> #define VPFE_MINOR_RELEASE              0
>>@@ -91,9 +89,14 @@ struct vpfe_config {
>> 	char *card_name;
>> 	/* ccdc name */
>> 	char *ccdc;
>>-	/* vpfe clock */
>>+	/* vpfe clock. Obsolete! Will be removed in next patch */
>> 	struct clk *vpssclk;
>>+	/* Obsolete! Will be removed in next patch */
>> 	struct clk *slaveclk;
>>+	/* number of clocks */
>>+	int num_clocks;
>>+	/* clocks used for vpfe capture */
>>+	char *clocks[];
>> };
>>
>> struct vpfe_device {
>>@@ -104,6 +107,8 @@ struct vpfe_device {
>> 	struct v4l2_subdev **sd;
>> 	/* vpfe cfg */
>> 	struct vpfe_config *cfg;
>>+	/* clock ptrs for vpfe capture */
>>+	struct clk **clks;
>> 	/* V4l2 device */
>> 	struct v4l2_device v4l2_dev;
>> 	/* parent device */
>>--
>>1.6.0.4

