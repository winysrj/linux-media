Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:49088 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab2JHPMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 11:12:13 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so3941533oag.19
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2012 08:12:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5072A528.8010605@gmail.com>
References: <1349473981-15084-1-git-send-email-fabio.estevam@freescale.com>
	<5072A528.8010605@gmail.com>
Date: Mon, 8 Oct 2012 12:12:12 -0300
Message-ID: <CAOMZO5Bf76zS-CMLrRmBXbc3GFiFSSaw_uF9XWm0ofPArrA89g@mail.gmail.com>
Subject: Re: [PATCH 2/2] [media]: mx2_camera: Fix regression caused by clock conversion
From: Fabio Estevam <festevam@gmail.com>
To: =?UTF-8?Q?Ga=C3=ABtan_Carlier?= <gcembed@gmail.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, kernel@pengutronix.de,
	g.liakhovetski@gmx.de, mchehab@infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	javier.martin@vista-silicon.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 8, 2012 at 7:04 AM, Gaëtan Carlier <gcembed@gmail.com> wrote:
>
> This patch does not apply on linux-next-20121008. I suppose that linux-media
> development branch is needed. How can I put linux-media branch on top of

Ok, I have just rebased it against linux-next-20121008. See below.

It allows ov2640 to probe correctly. However, it does not work with
Gstreamer anymore (Friday's linux-next allowed to get the Gstreamer
pipeline to work).

$ gst-launch v4l2src  ! fbdevsink
Setting pipeline to PAUSED ...mx2-camera mx2-camera.0: Camera driver
attached to camera 0

mx2-camera mx2-camera.0: Camera driver detached from camera 0
ERROR: Pipeline doesn't want to pause.
ERROR: from element /GstPipeline:pipeline0/GstV4l2Src:v4l2src0: Failed
to query norm on device '/dev/video0'.
Additional debug info:
v4l2_calls.c(213): gst_v4l2_fill_lists ():
/GstPipeline:pipeline0/GstV4l2Src:v4l2src0:
Failed to get attributes for norm 0 on devide '/dev/video0'. (61 - No
data available)
Setting pipeline to NULL ...
Freeing pipeline ...

Does anyone have any ideas?

Thanks,

Fabio Estevam

---
 drivers/media/platform/soc_camera/mx2_camera.c |   47 +++++++++++++++++-------
 1 file changed, 34 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/soc_camera/mx2_camera.c
b/drivers/media/platform/soc_camera/mx2_camera.c
index 403d7f1..9f8c5f0 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -272,7 +272,8 @@ struct mx2_camera_dev {
 	struct device		*dev;
 	struct soc_camera_host	soc_host;
 	struct soc_camera_device *icd;
-	struct clk		*clk_csi, *clk_emma_ahb, *clk_emma_ipg;
+	struct clk		*clk_emma_ahb, *clk_emma_ipg;
+	struct clk		*clk_csi_ahb, *clk_csi_per;

 	void __iomem		*base_csi, *base_emma;

@@ -432,7 +433,8 @@ static void mx2_camera_deactivate(struct
mx2_camera_dev *pcdev)
 {
 	unsigned long flags;

-	clk_disable_unprepare(pcdev->clk_csi);
+	clk_disable_unprepare(pcdev->clk_csi_ahb);
+	clk_disable_unprepare(pcdev->clk_csi_per);
 	writel(0, pcdev->base_csi + CSICR1);
 	if (cpu_is_mx27()) {
 		writel(0, pcdev->base_emma + PRP_CNTL);
@@ -460,7 +462,11 @@ static int mx2_camera_add_device(struct
soc_camera_device *icd)
 	if (pcdev->icd)
 		return -EBUSY;

-	ret = clk_prepare_enable(pcdev->clk_csi);
+	ret = clk_prepare_enable(pcdev->clk_csi_ahb);
+	if (ret < 0)
+		return ret;
+
+	ret = clk_prepare_enable(pcdev->clk_csi_per);
 	if (ret < 0)
 		return ret;

@@ -1725,11 +1731,18 @@ static int __devinit mx2_camera_probe(struct
platform_device *pdev)
 		goto exit;
 	}

-	pcdev->clk_csi = devm_clk_get(&pdev->dev, "ahb");
-	if (IS_ERR(pcdev->clk_csi)) {
-		dev_err(&pdev->dev, "Could not get csi clock\n");
-		err = PTR_ERR(pcdev->clk_csi);
-		goto exit;
+	pcdev->clk_csi_ahb = devm_clk_get(&pdev->dev, "ahb");
+	if (IS_ERR(pcdev->clk_csi_ahb)) {
+		dev_err(&pdev->dev, "Could not get csi ahb clock\n");
+		err = PTR_ERR(pcdev->clk_csi_ahb);
+ 		goto exit;
+ 	}
+
+	pcdev->clk_csi_per = devm_clk_get(&pdev->dev, "per");
+	if (IS_ERR(pcdev->clk_csi_per)) {
+		dev_err(&pdev->dev, "Could not get csi per clock\n");
+		err = PTR_ERR(pcdev->clk_csi_per);
+		goto exit_csi_ahb;
 	}

 	pcdev->pdata = pdev->dev.platform_data;
@@ -1738,14 +1751,15 @@ static int __devinit mx2_camera_probe(struct
platform_device *pdev)

 		pcdev->platform_flags = pcdev->pdata->flags;

-		rate = clk_round_rate(pcdev->clk_csi, pcdev->pdata->clk * 2);
+		rate = clk_round_rate(pcdev->clk_csi_per,
+						pcdev->pdata->clk * 2);
 		if (rate <= 0) {
 			err = -ENODEV;
-			goto exit;
+			goto exit_csi_per;
 		}
-		err = clk_set_rate(pcdev->clk_csi, rate);
+		err = clk_set_rate(pcdev->clk_csi_per, rate);
 		if (err < 0)
-			goto exit;
+			goto exit_csi_per;
 	}

 	INIT_LIST_HEAD(&pcdev->capture);
@@ -1801,7 +1815,7 @@ static int __devinit mx2_camera_probe(struct
platform_device *pdev)
 		goto exit_free_emma;

 	dev_info(&pdev->dev, "MX2 Camera (CSI) driver probed, clock frequency: %ld\n",
-			clk_get_rate(pcdev->clk_csi));
+			clk_get_rate(pcdev->clk_csi_per));

 	return 0;

@@ -1812,6 +1826,10 @@ eallocctx:
 		clk_disable_unprepare(pcdev->clk_emma_ipg);
 		clk_disable_unprepare(pcdev->clk_emma_ahb);
 	}
+exit_csi_per:
+	clk_disable_unprepare(pcdev->clk_csi_per);
+exit_csi_ahb:
+	clk_disable_unprepare(pcdev->clk_csi_ahb);
 exit:
 	return err;
 }
@@ -1831,6 +1849,9 @@ static int __devexit mx2_camera_remove(struct
platform_device *pdev)
 		clk_disable_unprepare(pcdev->clk_emma_ahb);
 	}

+	clk_disable_unprepare(pcdev->clk_csi_per);
+	clk_disable_unprepare(pcdev->clk_csi_ahb);
+
 	dev_info(&pdev->dev, "MX2 Camera driver unloaded\n");

 	return 0;
-- 
1.7.9.5
