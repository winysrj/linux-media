Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755575Ab2DSRvY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Apr 2012 13:51:24 -0400
Message-ID: <4F905095.5020604@redhat.com>
Date: Thu, 19 Apr 2012 14:51:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
CC: linux-media@vger.kernel.org, Matthias Schwarzott <zzam@gentoo.org>
Subject: Re: [RFC] b2c2_flexcop_pci: Add suspend/resume support
References: <201204151618.07719.stefan.bauer@cs.tu-chemnitz.de>
In-Reply-To: <201204151618.07719.stefan.bauer@cs.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stefan,

Em 15-04-2012 11:18, Stefan Bauer escreveu:
> Dear linux-dvb developers, dear Matthias,
> 
> 
> proper suspend and resume support for the b2c2_flexcop_pci driver is still missing as pointed out by these two bug reports:
> 
> https://bugs.gentoo.org/show_bug.cgi?id=288267
> https://bugzilla.kernel.org/show_bug.cgi?id=14394
> 
> The first report contains a proposed patch to add suspend/resume support written by Matthias Schwarzott <zzam@gentoo.org>. I and some others (see first bug report) confirm that it's actually working.
> 
> Behaviour without the patch: b2c2_flexcop_pci must be unloaded before suspending (means TV applications must be closed), and reloaded after resuming.
> Behaviour with the patch: No module unloading/reloading necessary any more.
> Known issues: TV application still needs to be closed before suspend. Otherwise the device is not functional (kaffeine shows only black screen) after resume. Reloading the module revives the device in that case.
> 
> I'd kindly ask you to review the attached patch by Matthias and consider its upstream inclusion after the issues are sorted out. I'm more than willing to assist and test as I can.

I don't have any b2c2 device, so I can't actually test it. on a quick lock,
it seems sane on my eyes. In order for us to merge, we need the patch author's
Signed-off-by.

Regards,
Mauro

> 
> 
> Kind regards,
> Stefan Bauer
> ---8<---
> diff --git a/drivers/media/dvb/b2c2/flexcop-common.h b/drivers/media/dvb/b2c2/flexcop-common.h
> index 437912e..c5f11a6 100644
> --- a/drivers/media/dvb/b2c2/flexcop-common.h
> +++ b/drivers/media/dvb/b2c2/flexcop-common.h
> @@ -117,6 +117,9 @@ int flexcop_device_initialize(struct flexcop_device *);
>  void flexcop_device_exit(struct flexcop_device *fc);
>  void flexcop_reset_block_300(struct flexcop_device *fc);
>  
> +void flexcop_device_suspend(struct flexcop_device *fc);
> +void flexcop_device_resume(struct flexcop_device *fc);
> +
>  /* from flexcop-dma.c */
>  int flexcop_dma_allocate(struct pci_dev *pdev,
>  		struct flexcop_dma *dma, u32 size);
> diff --git a/drivers/media/dvb/b2c2/flexcop-pci.c b/drivers/media/dvb/b2c2/flexcop-pci.c
> index 44f8fb5..1ef4b82 100644
> --- a/drivers/media/dvb/b2c2/flexcop-pci.c
> +++ b/drivers/media/dvb/b2c2/flexcop-pci.c
> @@ -293,8 +293,6 @@ static int flexcop_pci_init(struct flexcop_pci *fc_pci)
>  
>  	info("card revision %x", fc_pci->pdev->revision);
>  
> -	if ((ret = pci_enable_device(fc_pci->pdev)) != 0)
> -		return ret;
>  	pci_set_master(fc_pci->pdev);
>  
>  	if ((ret = pci_request_regions(fc_pci->pdev, DRIVER_NAME)) != 0)
> @@ -308,7 +306,6 @@ static int flexcop_pci_init(struct flexcop_pci *fc_pci)
>  		goto err_pci_release_regions;
>  	}
>  
> -	pci_set_drvdata(fc_pci->pdev, fc_pci);
>  	spin_lock_init(&fc_pci->irq_lock);
>  	if ((ret = request_irq(fc_pci->pdev->irq, flexcop_pci_isr,
>  					IRQF_SHARED, DRIVER_NAME, fc_pci)) != 0)
> @@ -319,7 +316,6 @@ static int flexcop_pci_init(struct flexcop_pci *fc_pci)
>  
>  err_pci_iounmap:
>  	pci_iounmap(fc_pci->pdev, fc_pci->io_mem);
> -	pci_set_drvdata(fc_pci->pdev, NULL);
>  err_pci_release_regions:
>  	pci_release_regions(fc_pci->pdev);
>  err_pci_disable_device:
> @@ -332,9 +328,7 @@ static void flexcop_pci_exit(struct flexcop_pci *fc_pci)
>  	if (fc_pci->init_state & FC_PCI_INIT) {
>  		free_irq(fc_pci->pdev->irq, fc_pci);
>  		pci_iounmap(fc_pci->pdev, fc_pci->io_mem);
> -		pci_set_drvdata(fc_pci->pdev, NULL);
>  		pci_release_regions(fc_pci->pdev);
> -		pci_disable_device(fc_pci->pdev);
>  	}
>  	fc_pci->init_state &= ~FC_PCI_INIT;
>  }
> @@ -373,6 +367,11 @@ static int flexcop_pci_probe(struct pci_dev *pdev,
>  
>  	/* bus specific part */
>  	fc_pci->pdev = pdev;
> +	ret = pci_enable_device(pdev);
> +	if (ret != 0)
> +		goto err_kfree;
> +
> +	pci_set_drvdata(pdev, fc_pci);
>  	if ((ret = flexcop_pci_init(fc_pci)) != 0)
>  		goto err_kfree;
>  
> @@ -398,6 +397,7 @@ err_fc_exit:
>  err_pci_exit:
>  	flexcop_pci_exit(fc_pci);
>  err_kfree:
> +	pci_set_drvdata(pdev, NULL);
>  	flexcop_device_kfree(fc);
>  	return ret;
>  }
> @@ -415,9 +415,74 @@ static void flexcop_pci_remove(struct pci_dev *pdev)
>  	flexcop_pci_dma_exit(fc_pci);
>  	flexcop_device_exit(fc_pci->fc_dev);
>  	flexcop_pci_exit(fc_pci);
> +	pci_set_drvdata(pdev, NULL);
> +	pci_disable_device(pdev);
>  	flexcop_device_kfree(fc_pci->fc_dev);
>  }
>  
> +#ifdef CONFIG_PM
> +static int flexcop_pci_suspend(struct pci_dev *pdev, pm_message_t mesg)
> +{
> +	struct flexcop_pci *fc_pci = pci_get_drvdata(pdev);
> +	struct flexcop_device *fc = fc_pci->fc_dev;
> +
> +	/* most parts are from flexcop_pci_remove */
> +
> +	if (irq_chk_intv > 0)
> +		cancel_delayed_work(&fc_pci->irq_check_work);
> +
> +	flexcop_pci_dma_exit(fc_pci);
> +	flexcop_device_suspend(fc);
> +	flexcop_pci_exit(fc_pci);
> +
> +	pci_save_state(pdev);
> +
> +	pci_disable_device(pdev);
> +	pci_set_power_state(pdev, pci_choose_state(pdev, mesg));
> +
> +	return 0;
> +}
> +
> +static int flexcop_pci_resume(struct pci_dev *pdev)
> +{
> +	int ret;
> +	struct flexcop_pci *fc_pci = pci_get_drvdata(pdev);
> +	struct flexcop_device *fc = fc_pci->fc_dev;
> +
> +	/* restore power state 0 */
> +	pci_set_power_state(pdev, PCI_D0);
> +	pci_restore_state(pdev);
> +
> +	ret = pci_enable_device(pdev);
> +	if (ret < 0) {
> +		err("unable to enable device in resume\n");
> +		return ret;
> +	}
> +
> +	/* from flexcop_pci_probe */
> +	ret = flexcop_pci_init(fc_pci);
> +	if (ret < 0) {
> +		err("could not allocate pci resources in resume\n");
> +		return ret;
> +	}
> +
> +	/* init flexcop */
> +	flexcop_device_resume(fc); /* instead of flexcop_device_initialize */
> +
> +	/* init dma */
> +	flexcop_pci_dma_init(fc_pci);
> +
> +	/* last step: restart watchdog */
> +	if (irq_chk_intv > 0)
> +		schedule_delayed_work(&fc_pci->irq_check_work,
> +				msecs_to_jiffies(irq_chk_intv < 100 ?
> +					100 :
> +					irq_chk_intv));
> +
> +	return 0;
> +}
> +#endif
> +
>  static struct pci_device_id flexcop_pci_tbl[] = {
>  	{ PCI_DEVICE(0x13d0, 0x2103) },
>  	{ },
> @@ -430,6 +495,10 @@ static struct pci_driver flexcop_pci_driver = {
>  	.id_table = flexcop_pci_tbl,
>  	.probe    = flexcop_pci_probe,
>  	.remove   = flexcop_pci_remove,
> +#ifdef CONFIG_PM
> +	.suspend  = flexcop_pci_suspend,
> +	.resume   = flexcop_pci_resume,
> +#endif
>  };
>  
>  static int __init flexcop_pci_module_init(void)
> diff --git a/drivers/media/dvb/b2c2/flexcop.c b/drivers/media/dvb/b2c2/flexcop.c
> index b1e8c99..cb961c8 100644
> --- a/drivers/media/dvb/b2c2/flexcop.c
> +++ b/drivers/media/dvb/b2c2/flexcop.c
> @@ -305,6 +305,75 @@ void flexcop_device_exit(struct flexcop_device *fc)
>  }
>  EXPORT_SYMBOL(flexcop_device_exit);
>  
> +void flexcop_device_suspend(struct flexcop_device *fc)
> +{
> +	/* flexcop_device_exit does only unregister objects
> +	 * so just stop streaming here */
> +	struct dvb_demux_feed *feed;
> +
> +	/* copied from flexcop_pci_irq_check_work */
> +#if 1
> +	info("stopping pid feeds");
> +	spin_lock_irq(&fc->demux.lock);
> +	list_for_each_entry(feed, &fc->demux.feed_list,
> +			list_head) {
> +		flexcop_pid_feed_control(fc, feed, 0);
> +	}
> +	spin_unlock_irq(&fc->demux.lock);
> +#endif
> +
> +#if 1
> +	/* make sure streaming is really off */
> +	if (fc->stream_control)
> +		fc->stream_control(fc, 0);
> +#endif
> +#if 0
> +	fc->feedcount = 0;
> +	fc->extra_feedcount = 0;
> +	flexcop_reset_block_300(fc);
> +	flexcop_hw_filter_init(fc);
> +#endif
> +}
> +EXPORT_SYMBOL(flexcop_device_suspend);
> +
> +void flexcop_device_resume(struct flexcop_device *fc)
> +{
> +	/* copied from flexcop_device_initialize */
> +	//struct dvb_demux_feed *feed;
> +	flexcop_reset(fc);
> +
> +	flexcop_sram_init(fc);
> +	flexcop_hw_filter_init(fc);
> +	flexcop_smc_ctrl(fc, 0);
> +
> +	/* do the MAC address reading after initializing the dvb_adapter */
> +	/* TODO: need not reread MAC address, but status was not saved */
> +	if (fc->get_mac_addr(fc, 0) == 0) {
> +		u8 *b = fc->dvb_adapter.proposed_mac;
> +		info("MAC address = %pM", b);
> +		flexcop_set_mac_filter(fc, b);
> +		flexcop_mac_filter_ctrl(fc, 1);
> +	} else
> +		warn("reading of MAC address failed.\n");
> +
> +	/* TODO: Is it fine to start streaming here,
> +	 * before DMA is re-initialized */
> +
> +	/* copied from flexcop_pci_irq_check_work */
> +	info("restarting pid feeds");
> +#if 0
> +	spin_lock_irq(&fc->demux.lock);
> +	list_for_each_entry(feed, &fc->demux.feed_list,
> +			list_head) {
> +		flexcop_pid_feed_control(fc, feed, 1);
> +	}
> +	spin_unlock_irq(&fc->demux.lock);
> +#endif
> +
> +	flexcop_device_name(fc, "resume of", "complete");
> +}
> +EXPORT_SYMBOL(flexcop_device_resume);
> +
>  static int flexcop_module_init(void)
>  {
>  	info(DRIVER_NAME " loaded successfully");
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

