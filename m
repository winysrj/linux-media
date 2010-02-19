Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:48265 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671Ab0BSXUk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2010 18:20:40 -0500
Message-ID: <4B7F1E97.8000602@gmail.com>
Date: Sat, 20 Feb 2010 00:28:23 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH] video_device: don't free_irq() an element past array
 vpif_obj.dev[] and fix test
References: <4B714E15.4020909@gmail.com> <A69FA2915331DC488A831521EAE36FE40169C5C9B5@dlee06.ent.ti.com> <25e057c01002181202v346f488bk571d099f679fea83@mail.gmail.com> <A69FA2915331DC488A831521EAE36FE40169C5CBD8@dlee06.ent.ti.com> <4B7EEB6B.5070400@gmail.com>
In-Reply-To: <4B7EEB6B.5070400@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first loop ends when platform_get_resource() returns NULL. Can it occur
that no platform_get_resource() succeeded? I think we should error return if
that happens. Could k grow larger than VPIF_DISPLAY_MAX_DEVICES there? Should
we err out in that case?

In the loop `for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++)' if
video_device_alloc() fails I think we correctly release the devices, but we
have to do more before we reach label vpif_int_err.

As mentioned, we left the first loop with a res of NULL, which is dereferenced
at label vpif_int_err. So we have to get the resource again, however, k was
incremented at the end of that loop as well. Also i used as index in the second
loop as well should point to res->end before going to label vpif_int_err, to
free all requested irqs. All this needs to be done for later error labels as
well, so a new label is added where this occurs, alloc_vid_fail.

Variable k can't be reused in the third for-loop and at label probe_out. As
mentioned k is needed to get the resource in case a error and clean-up is
required.

If we reach label vpif_int_err, res shouldn't be NULL, since we dereference it.
Previously we had:

        for (; k >= 0; k--) {
                for (m = i; m >= res->start; m--)
                        free_irq(m, (void *)(&vpif_obj.dev[k]->channel_id));
                res = platform_get_resource(pdev, IORESOURCE_IRQ, k-1);
                m = res->end;
        }

In the last iteration k equals 0, so we call platform_get_resource() with -1 as
a third argument. Since platform_get_resource() uses an unsigned it is
converted to 0xffffffff. platform_get_resource() fails for every index and
returns NULL. A test is lacking and we dereference NULL.

The error "VPIF IRQ request failed" should only be displayed when request_irq()
failed, not in the case of other errors.

Also I changed some indexes, so a few could be removed.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
> I think there were many more issues:

> I must admit I did not compile test this, except with checkpatch.pl, but I
> think the issues are real and should be fixed. Comments?

I would like to compile test but cannot compile test these because of errors
like drivers/net/davinci_emac.c:69:11: error: unable to open 'mach/dm646x.h'

I found these three other functions in davinci code that have very similar
problems. The changelog is about vpif_probe() in vpif_display.c.

Since the functions are somewhat similar, maybe code should be shared, but
where should one put that?

Roel

 drivers/media/video/davinci/vpif_capture.c |   63 +++++++++++++----------
 drivers/media/video/davinci/vpif_display.c |   76 ++++++++++++++++++----------
 drivers/net/davinci_emac.c                 |   64 ++++++++++++++++--------
 3 files changed, 129 insertions(+), 74 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index 7813072..096e727 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -1915,7 +1915,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 {
 	struct vpif_subdev_info *subdevdata;
 	struct vpif_capture_config *config;
-	int i, j, k, m, q, err;
+	int i, j, k, err;
 	struct i2c_adapter *i2c_adap;
 	struct channel_obj *ch;
 	struct common_obj *common;
@@ -1936,14 +1936,18 @@ static __init int vpif_probe(struct platform_device *pdev)
 		for (i = res->start; i <= res->end; i++) {
 			if (request_irq(i, vpif_channel_isr, IRQF_DISABLED,
 					"DM646x_Capture",
-				(void *)(&vpif_obj.dev[k]->channel_id))) {
-				err = -EBUSY;
+				&vpif_obj.dev[k]->channel_id)) {
 				i--;
+				err = -EBUSY;
 				goto vpif_int_err;
 			}
 		}
 		k++;
+		if (k >= VPIF_DISPLAY_MAX_DEVICES)
+			break;
 	}
+	if (k == 0)
+		return -ENODEV;
 
 	for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
 		/* Get the pointer to the channel object */
@@ -1972,16 +1976,16 @@ static __init int vpif_probe(struct platform_device *pdev)
 		ch->video_dev = vfd;
 	}
 
-	for (j = 0; j < VPIF_CAPTURE_MAX_DEVICES; j++) {
-		ch = vpif_obj.dev[j];
-		ch->channel_id = j;
+	for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
+		ch = vpif_obj.dev[i];
+		ch->channel_id = i;
 		common = &(ch->common[VPIF_VIDEO_INDEX]);
 		spin_lock_init(&common->irqlock);
 		mutex_init(&common->lock);
 		/* Initialize prio member of channel object */
 		v4l2_prio_init(&ch->prio);
 		err = video_register_device(ch->video_dev,
-					    VFL_TYPE_GRABBER, (j ? 1 : 0));
+					    VFL_TYPE_GRABBER, (i ? 1 : 0));
 		if (err)
 			goto probe_out;
 
@@ -2007,24 +2011,24 @@ static __init int vpif_probe(struct platform_device *pdev)
 		goto probe_subdev_out;
 	}
 
-	for (i = 0; i < subdev_count; i++) {
-		subdevdata = &config->subdev_info[i];
-		vpif_obj.sd[i] =
+	for (j = 0; j < subdev_count; j++) {
+		subdevdata = &config->subdev_info[j];
+		vpif_obj.sd[j] =
 			v4l2_i2c_new_subdev_board(&vpif_obj.v4l2_dev,
 						  i2c_adap,
 						  subdevdata->name,
 						  &subdevdata->board_info,
 						  NULL);
 
-		if (!vpif_obj.sd[i]) {
+		if (!vpif_obj.sd[j]) {
 			vpif_err("Error registering v4l2 subdevice\n");
 			goto probe_subdev_out;
 		}
 		v4l2_info(&vpif_obj.v4l2_dev, "registered sub device %s\n",
 			  subdevdata->name);
 
-		if (vpif_obj.sd[i])
-			vpif_obj.sd[i]->grp_id = 1 << i;
+		if (vpif_obj.sd[j])
+			vpif_obj.sd[j]->grp_id = 1 << j;
 	}
 	v4l2_info(&vpif_obj.v4l2_dev, "DM646x VPIF Capture driver"
 		  " initialized\n");
@@ -2034,30 +2038,37 @@ static __init int vpif_probe(struct platform_device *pdev)
 probe_subdev_out:
 	/* free sub devices memory */
 	kfree(vpif_obj.sd);
-
-	j = VPIF_CAPTURE_MAX_DEVICES;
 probe_out:
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
-	for (k = 0; k < j; k++) {
+	for (j = 0; j < i; j++) {
 		/* Get the pointer to the channel object */
-		ch = vpif_obj.dev[k];
+		ch = vpif_obj.dev[j];
 		/* Unregister video device */
 		video_unregister_device(ch->video_dev);
 	}
 
 vpif_dev_alloc_err:
-	k = VPIF_CAPTURE_MAX_DEVICES-1;
-	res = platform_get_resource(pdev, IORESOURCE_IRQ, k);
+	while (k--) {
+		res = platform_get_resource(pdev, IORESOURCE_IRQ, k);
+		if (res != NULL)
+			break;
+		vpif_err("Couldn't free irqs for resource %d.\n", k);
+	}
+	if (res == NULL)
+		return err;
 	i = res->end;
-
 vpif_int_err:
-	for (q = k; q >= 0; q--) {
-		for (m = i; m >= (int)res->start; m--)
-			free_irq(m, (void *)(&vpif_obj.dev[q]->channel_id));
+	for (j = i; j >= (int)res->start; j--)
+		free_irq(j, &vpif_obj.dev[k]->channel_id);
 
-		res = platform_get_resource(pdev, IORESOURCE_IRQ, q-1);
-		if (res)
-			i = res->end;
+	while (k--) {
+		res = platform_get_resource(pdev, IORESOURCE_IRQ, k);
+		if (res == NULL) {
+			vpif_err("Couldn't free irqs for resource %d.\n", k);
+			continue;
+		}
+		for (j = res->end; j >= (int)res->start; j--)
+			free_irq(j, &vpif_obj.dev[k]->channel_id);
 	}
 	return err;
 }
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index dfddef7..6bcedbf 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -383,7 +383,7 @@ static int vpif_get_std_info(struct channel_obj *ch)
 	int index;
 
 	std_info->stdid = vid_ch->stdid;
-	if (!std_info)
+	if (!std_info->stdid)
 		return -1;
 
 	for (index = 0; index < ARRAY_SIZE(ch_params); index++) {
@@ -1423,7 +1423,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 {
 	struct vpif_subdev_info *subdevdata;
 	struct vpif_display_config *config;
-	int i, j = 0, k, q, m, err = 0;
+	int i, j, k, err;
 	struct i2c_adapter *i2c_adap;
 	struct common_obj *common;
 	struct channel_obj *ch;
@@ -1452,12 +1452,18 @@ static __init int vpif_probe(struct platform_device *pdev)
 			if (request_irq(i, vpif_channel_isr, IRQF_DISABLED,
 					"DM646x_Display",
 				(void *)(&vpif_obj.dev[k]->channel_id))) {
+				i--;
 				err = -EBUSY;
+				vpif_err("VPIF IRQ request failed\n");
 				goto vpif_int_err;
 			}
 		}
 		k++;
+		if (k >= VPIF_DISPLAY_MAX_DEVICES)
+			break;
 	}
+	if (k == 0)
+		return -ENODEV;
 
 	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
 
@@ -1472,7 +1478,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 				video_device_release(ch->video_dev);
 			}
 			err = -ENOMEM;
-			goto vpif_int_err;
+			goto alloc_vid_fail;
 		}
 
 		/* Initialize field of video device */
@@ -1489,13 +1495,13 @@ static __init int vpif_probe(struct platform_device *pdev)
 		ch->video_dev = vfd;
 	}
 
-	for (j = 0; j < VPIF_DISPLAY_MAX_DEVICES; j++) {
-		ch = vpif_obj.dev[j];
+	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
+		ch = vpif_obj.dev[i];
 		/* Initialize field of the channel objects */
 		atomic_set(&ch->usrs, 0);
-		for (k = 0; k < VPIF_NUMOBJECTS; k++) {
-			ch->common[k].numbuffers = 0;
-			common = &ch->common[k];
+		for (j = 0; j < VPIF_NUMOBJECTS; j++) {
+			ch->common[j].numbuffers = 0;
+			common = &ch->common[j];
 			common->io_usrs = 0;
 			common->started = 0;
 			spin_lock_init(&common->irqlock);
@@ -1506,12 +1512,12 @@ static __init int vpif_probe(struct platform_device *pdev)
 			common->ctop_off = common->cbtm_off = 0;
 			common->cur_frm = common->next_frm = NULL;
 			memset(&common->fmt, 0, sizeof(common->fmt));
-			common->numbuffers = config_params.numbuffers[k];
+			common->numbuffers = config_params.numbuffers[j];
 
 		}
 		ch->initialized = 0;
-		ch->channel_id = j;
-		if (j < 2)
+		ch->channel_id = i;
+		if (i < 2)
 			ch->common[VPIF_VIDEO_INDEX].numbuffers =
 			    config_params.numbuffers[ch->channel_id];
 		else
@@ -1529,7 +1535,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 				(int)ch, (int)&ch->video_dev);
 
 		err = video_register_device(ch->video_dev,
-					  VFL_TYPE_GRABBER, (j ? 3 : 2));
+					  VFL_TYPE_GRABBER, (i ? 3 : 2));
 		if (err < 0)
 			goto probe_out;
 
@@ -1548,18 +1554,18 @@ static __init int vpif_probe(struct platform_device *pdev)
 		goto probe_out;
 	}
 
-	for (i = 0; i < subdev_count; i++) {
-		vpif_obj.sd[i] = v4l2_i2c_new_subdev_board(&vpif_obj.v4l2_dev,
-						i2c_adap, subdevdata[i].name,
-						&subdevdata[i].board_info,
+	for (j = 0; j < subdev_count; j++) {
+		vpif_obj.sd[j] = v4l2_i2c_new_subdev_board(&vpif_obj.v4l2_dev,
+						i2c_adap, subdevdata[j].name,
+						&subdevdata[j].board_info,
 						NULL);
-		if (!vpif_obj.sd[i]) {
+		if (!vpif_obj.sd[j]) {
 			vpif_err("Error registering v4l2 subdevice\n");
 			goto probe_subdev_out;
 		}
 
-		if (vpif_obj.sd[i])
-			vpif_obj.sd[i]->grp_id = 1 << i;
+		if (vpif_obj.sd[j])
+			vpif_obj.sd[j]->grp_id = 1 << j;
 	}
 
 	return 0;
@@ -1567,20 +1573,36 @@ static __init int vpif_probe(struct platform_device *pdev)
 probe_subdev_out:
 	kfree(vpif_obj.sd);
 probe_out:
-	for (k = 0; k < j; k++) {
-		ch = vpif_obj.dev[k];
+	for (j = 0; j < i; j++) {
+		ch = vpif_obj.dev[j];
 		video_unregister_device(ch->video_dev);
 		video_device_release(ch->video_dev);
 		ch->video_dev = NULL;
 	}
+alloc_vid_fail:
+	while (k--) {
+		res = platform_get_resource(pdev, IORESOURCE_IRQ, k);
+		if (res != NULL)
+			break;
+		vpif_err("Couldn't free irqs for resource %d.\n", k);
+	}
+	if (res == NULL)
+		return err;
+	i = res->end;
 vpif_int_err:
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
-	vpif_err("VPIF IRQ request failed\n");
-	for (q = k; k >= 0; k--) {
-		for (m = i; m >= res->start; m--)
-			free_irq(m, (void *)(&vpif_obj.dev[k]->channel_id));
-		res = platform_get_resource(pdev, IORESOURCE_IRQ, k-1);
-		m = res->end;
+
+	for (j = i; j >= res->start; j--)
+		free_irq(j, (void *)(&vpif_obj.dev[k]->channel_id));
+
+	while (k--) {
+		res = platform_get_resource(pdev, IORESOURCE_IRQ, k);
+		if (res == NULL) {
+			vpif_err("Couldn't free irqs for resource %d.\n", k);
+			continue;
+		}
+		for (j =  res->end; j >= res->start; j--)
+			free_irq(j, (void *)(&vpif_obj.dev[k]->channel_id));
 	}
 
 	return err;
diff --git a/drivers/net/davinci_emac.c b/drivers/net/davinci_emac.c
index 33c4fe2..2faa9d3 100644
--- a/drivers/net/davinci_emac.c
+++ b/drivers/net/davinci_emac.c
@@ -2369,12 +2369,12 @@ static int emac_devioctl(struct net_device *ndev, struct ifreq *ifrq, int cmd)
 static int emac_dev_open(struct net_device *ndev)
 {
 	struct device *emac_dev = &ndev->dev;
-	u32 rc, cnt, ch;
+	u32 cnt, ch;
 	int phy_addr;
 	struct resource *res;
-	int q, m;
-	int i = 0;
+	int i, j, k, err;
 	int k = 0;
+	int err;
 	struct emac_priv *priv = netdev_priv(ndev);
 
 	netif_carrier_off(ndev);
@@ -2398,15 +2398,15 @@ static int emac_dev_open(struct net_device *ndev)
 	emac_write(EMAC_MACHASH2, 0);
 
 	/* multi ch not supported - open 1 TX, 1RX ch by default */
-	rc = emac_init_txch(priv, EMAC_DEF_TX_CH);
-	if (0 != rc) {
+	err = emac_init_txch(priv, EMAC_DEF_TX_CH);
+	if (err) {
 		dev_err(emac_dev, "DaVinci EMAC: emac_init_txch() failed");
-		return rc;
+		return err;
 	}
-	rc = emac_init_rxch(priv, EMAC_DEF_RX_CH, priv->mac_addr);
-	if (0 != rc) {
+	err = emac_init_rxch(priv, EMAC_DEF_RX_CH, priv->mac_addr);
+	if (err) {
 		dev_err(emac_dev, "DaVinci EMAC: emac_init_rxch() failed");
-		return rc;
+		return err;
 	}
 
 	/* Request IRQ */
@@ -2414,11 +2414,17 @@ static int emac_dev_open(struct net_device *ndev)
 	while ((res = platform_get_resource(priv->pdev, IORESOURCE_IRQ, k))) {
 		for (i = res->start; i <= res->end; i++) {
 			if (request_irq(i, emac_irq, IRQF_DISABLED,
-					ndev->name, ndev))
+					ndev->name, ndev)) {
+				i--;
+				err = -EBUSY;
+				dev_err(emac_dev, "DaVinci EMAC: request_irq() failed");
 				goto rollback;
+			}
 		}
 		k++;
 	}
+	if (k == 0)
+		return -ENODEV;
 
 	/* Start/Enable EMAC hardware */
 	emac_hw_enable(priv);
@@ -2436,7 +2442,8 @@ static int emac_dev_open(struct net_device *ndev)
 
 		if (!priv->phydev) {
 			printk(KERN_ERR "%s: no PHY found\n", ndev->name);
-			return -1;
+			err = -ENODEV;
+			goto phydev_error;
 		}
 
 		priv->phydev = phy_connect(ndev, dev_name(&priv->phydev->dev),
@@ -2445,7 +2452,8 @@ static int emac_dev_open(struct net_device *ndev)
 		if (IS_ERR(priv->phydev)) {
 			printk(KERN_ERR "%s: Could not attach to PHY\n",
 								ndev->name);
-			return PTR_ERR(priv->phydev);
+			err = PTR_ERR(priv->phydev);
+			goto phydev_error;
 		}
 
 		priv->link = 0;
@@ -2456,7 +2464,7 @@ static int emac_dev_open(struct net_device *ndev)
 			"(mii_bus:phy_addr=%s, id=%x)\n", ndev->name,
 			priv->phydev->drv->name, dev_name(&priv->phydev->dev),
 			priv->phydev->phy_id);
-	} else{
+	} else {
 		/* No PHY , fix the link, speed and duplex settings */
 		priv->link = 1;
 		priv->speed = SPEED_100;
@@ -2475,15 +2483,29 @@ static int emac_dev_open(struct net_device *ndev)
 
 	return 0;
 
+phydev_error:
+	while (k--) {
+		res = platform_get_resource(priv->pdev, IORESOURCE_IRQ, k);
+		if (res != NULL)
+			break;
+		dev_err(emac_dev, "Couldn't free irqs for resource %d.\n", k);
+	}
+	if (res == NULL)
+		return err;
+	i = res->end;
 rollback:
-
-	dev_err(emac_dev, "DaVinci EMAC: request_irq() failed");
-
-	for (q = k; k >= 0; k--) {
-		for (m = i; m >= res->start; m--)
-			free_irq(m, ndev);
-		res = platform_get_resource(priv->pdev, IORESOURCE_IRQ, k-1);
-		m = res->end;
+	for (j = i; j >= res->start; j--)
+		free_irq(j, ndev);
+
+	while (k--) {
+		res = platform_get_resource(priv->pdev, IORESOURCE_IRQ, k);
+		if (res == NULL) {
+			dev_err(emac_dev, "Couldn't free irqs for resource %d.\n",
+					 k);
+			continue;
+		}
+		for (j = res->end; j >= res->start; j--)
+			free_irq(j, ndev);
 	}
 	return -EBUSY;
 }
