Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:44584 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548AbZEZTJc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 15:09:32 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org,
	Patrick Boettcher <patrick.boettcher@desy.de>
Subject: [PATCH] flexcop-pci: add suspend/resume support
Date: Tue, 26 May 2009 21:09:28 +0200
Cc: Uwe Bugla <uwe.bugla@gmx.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_p5DHKzukkUrzKDu"
Message-Id: <200905262109.29180.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_p5DHKzukkUrzKDu
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Patrick! Hi list!

This patch adds suspend/resume support to flexcop-pci driver.

I could only test this patch with the bare card, but without having a DVB-S 
signal. I checked it with and without running szap (obviously getting no 
lock).
It works fine here with suspend-to-disk on a tuxonice kernel.

Setting of hw-filter in resume is done the same way as the watchdog does it: 
Just looping over fc->demux.feed_list and running flexcop_pid_feed_control.
Where I am unsure is the order at resume. For now hw filters get started 
first, then dma is re-started.

Do I need to give special care to irq handling?

Regards
Matthias

--Boundary-00=_p5DHKzukkUrzKDu
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="flexcop-suspend.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="flexcop-suspend.diff"

Index: v4l-dvb/linux/drivers/media/dvb/b2c2/flexcop-common.h
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/b2c2/flexcop-common.h
+++ v4l-dvb/linux/drivers/media/dvb/b2c2/flexcop-common.h
@@ -117,6 +117,9 @@ int flexcop_device_initialize(struct fle
 void flexcop_device_exit(struct flexcop_device *fc);
 void flexcop_reset_block_300(struct flexcop_device *fc);
 
+void flexcop_device_suspend(struct flexcop_device *fc);
+void flexcop_device_resume(struct flexcop_device *fc);
+
 /* from flexcop-dma.c */
 int flexcop_dma_allocate(struct pci_dev *pdev,
 		struct flexcop_dma *dma, u32 size);
Index: v4l-dvb/linux/drivers/media/dvb/b2c2/flexcop.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/b2c2/flexcop.c
+++ v4l-dvb/linux/drivers/media/dvb/b2c2/flexcop.c
@@ -292,6 +292,59 @@ void flexcop_device_exit(struct flexcop_
 }
 EXPORT_SYMBOL(flexcop_device_exit);
 
+void flexcop_device_suspend(struct flexcop_device *fc)
+{
+	/* flexcop_device_exit does only unregister objects
+	 * so just stop streaming here */
+	struct dvb_demux_feed *feed;
+
+	/* copied from flexcop_pci_irq_check_work */
+	info("stopping pid feeds");
+	spin_lock_irq(&fc->demux.lock);
+	list_for_each_entry(feed, &fc->demux.feed_list,
+			list_head) {
+		flexcop_pid_feed_control(fc, feed, 0);
+	}
+	spin_unlock_irq(&fc->demux.lock);
+}
+EXPORT_SYMBOL(flexcop_device_suspend);
+
+void flexcop_device_resume(struct flexcop_device *fc)
+{
+	/* copied from flexcop_device_initialize */
+	struct dvb_demux_feed *feed;
+	flexcop_reset(fc);
+
+	flexcop_sram_init(fc);
+	flexcop_hw_filter_init(fc);
+	flexcop_smc_ctrl(fc, 0);
+
+	/* do the MAC address reading after initializing the dvb_adapter */
+	/* TODO: need not reread MAC address, but status was not saved */
+	if (fc->get_mac_addr(fc, 0) == 0) {
+		u8 *b = fc->dvb_adapter.proposed_mac;
+		info("MAC address = %pM", b);
+		flexcop_set_mac_filter(fc, b);
+		flexcop_mac_filter_ctrl(fc, 1);
+	} else
+		warn("reading of MAC address failed.\n");
+
+	/* TODO: Is it fine to start streaming here,
+	 * before DMA is re-initialized */
+
+	/* copied from flexcop_pci_irq_check_work */
+	info("restarting pid feeds");
+	spin_lock_irq(&fc->demux.lock);
+	list_for_each_entry(feed, &fc->demux.feed_list,
+			list_head) {
+		flexcop_pid_feed_control(fc, feed, 1);
+	}
+	spin_unlock_irq(&fc->demux.lock);
+
+	flexcop_device_name(fc, "resume of", "complete");
+}
+EXPORT_SYMBOL(flexcop_device_resume);
+
 static int flexcop_module_init(void)
 {
 	info(DRIVER_NAME " loaded successfully");
Index: v4l-dvb/linux/drivers/media/dvb/b2c2/flexcop-pci.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/b2c2/flexcop-pci.c
+++ v4l-dvb/linux/drivers/media/dvb/b2c2/flexcop-pci.c
@@ -319,8 +319,6 @@ static int flexcop_pci_init(struct flexc
 	pci_read_config_byte(fc_pci->pdev, PCI_CLASS_REVISION, &card_rev);
 	info("card revision %x", card_rev);
 
-	if ((ret = pci_enable_device(fc_pci->pdev)) != 0)
-		return ret;
 	pci_set_master(fc_pci->pdev);
 
 	if ((ret = pci_request_regions(fc_pci->pdev, DRIVER_NAME)) != 0)
@@ -334,7 +332,6 @@ static int flexcop_pci_init(struct flexc
 		goto err_pci_release_regions;
 	}
 
-	pci_set_drvdata(fc_pci->pdev, fc_pci);
 	spin_lock_init(&fc_pci->irq_lock);
 	if ((ret = request_irq(fc_pci->pdev->irq, flexcop_pci_isr,
 					IRQF_SHARED, DRIVER_NAME, fc_pci)) != 0)
@@ -345,7 +342,6 @@ static int flexcop_pci_init(struct flexc
 
 err_pci_iounmap:
 	pci_iounmap(fc_pci->pdev, fc_pci->io_mem);
-	pci_set_drvdata(fc_pci->pdev, NULL);
 err_pci_release_regions:
 	pci_release_regions(fc_pci->pdev);
 err_pci_disable_device:
@@ -358,9 +354,7 @@ static void flexcop_pci_exit(struct flex
 	if (fc_pci->init_state & FC_PCI_INIT) {
 		free_irq(fc_pci->pdev->irq, fc_pci);
 		pci_iounmap(fc_pci->pdev, fc_pci->io_mem);
-		pci_set_drvdata(fc_pci->pdev, NULL);
 		pci_release_regions(fc_pci->pdev);
-		pci_disable_device(fc_pci->pdev);
 	}
 	fc_pci->init_state &= ~FC_PCI_INIT;
 }
@@ -399,6 +393,11 @@ static int flexcop_pci_probe(struct pci_
 
 	/* bus specific part */
 	fc_pci->pdev = pdev;
+	ret = pci_enable_device(pdev);
+	if (ret != 0)
+		goto err_kfree;
+
+	pci_set_drvdata(pdev, fc_pci);
 	if ((ret = flexcop_pci_init(fc_pci)) != 0)
 		goto err_kfree;
 
@@ -428,6 +427,7 @@ err_fc_exit:
 err_pci_exit:
 	flexcop_pci_exit(fc_pci);
 err_kfree:
+	pci_set_drvdata(pdev, NULL);
 	flexcop_device_kfree(fc);
 	return ret;
 }
@@ -445,9 +445,65 @@ static void flexcop_pci_remove(struct pc
 	flexcop_pci_dma_exit(fc_pci);
 	flexcop_device_exit(fc_pci->fc_dev);
 	flexcop_pci_exit(fc_pci);
+	pci_set_drvdata(pdev, NULL);
+	pci_disable_device(pdev);
 	flexcop_device_kfree(fc_pci->fc_dev);
 }
 
+#ifdef CONFIG_PM
+static int flexcop_pci_suspend(struct pci_dev *pdev, pm_message_t mesg)
+{
+	struct flexcop_pci *fc_pci = pci_get_drvdata(pdev);
+	struct flexcop_device *fc = fc_pci->fc_dev;
+
+	/* most parts are from flexcop_pci_remove */
+
+	if (irq_chk_intv > 0)
+		cancel_delayed_work(&fc_pci->irq_check_work);
+
+	flexcop_pci_dma_exit(fc_pci);
+	flexcop_device_suspend(fc);
+	flexcop_pci_exit(fc_pci);
+
+	pci_save_state(pdev);
+
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, pci_choose_state(pdev, mesg));
+
+	return 0;
+}
+
+static int flexcop_pci_resume(struct pci_dev *pdev)
+{
+	struct flexcop_pci *fc_pci = pci_get_drvdata(pdev);
+	struct flexcop_device *fc = fc_pci->fc_dev;
+
+	/* restore power state 0 */
+	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
+
+	pci_enable_device(pdev);
+
+	/* from flexcop_pci_probe */
+	flexcop_pci_init(fc_pci);
+
+	/* init flexcop */
+	flexcop_device_resume(fc); /* instead of flexcop_device_initialize */
+
+	/* init dma */
+	flexcop_pci_dma_init(fc_pci);
+
+	/* last step: restart watchdog */
+	if (irq_chk_intv > 0)
+		schedule_delayed_work(&fc_pci->irq_check_work,
+				msecs_to_jiffies(irq_chk_intv < 100 ?
+					100 :
+					irq_chk_intv));
+
+	return 0;
+}
+#endif
+
 static struct pci_device_id flexcop_pci_tbl[] = {
 	{ PCI_DEVICE(0x13d0, 0x2103) },
 	{ },
@@ -460,6 +516,10 @@ static struct pci_driver flexcop_pci_dri
 	.id_table = flexcop_pci_tbl,
 	.probe    = flexcop_pci_probe,
 	.remove   = flexcop_pci_remove,
+#ifdef CONFIG_PM
+	.suspend  = flexcop_pci_suspend,
+	.resume   = flexcop_pci_resume,
+#endif
 };
 
 static int __init flexcop_pci_module_init(void)

--Boundary-00=_p5DHKzukkUrzKDu--
