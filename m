Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39786 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751180AbdFAK2f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 06:28:35 -0400
Date: Thu, 1 Jun 2017 13:27:59 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        hyungwoo.yang@intel.com
Subject: Re: [PATCH 3/3] [media] intel-ipu3: cio2: Add new MIPI-CSI2 driver
Message-ID: <20170601102758.GL1019@valkosipuli.retiisi.org.uk>
References: <cover.1493479141.git.yong.zhi@intel.com>
 <9cf19d01f6f85ac0e5969a2b2fcd5ad5ef8c1e22.1493479141.git.yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cf19d01f6f85ac0e5969a2b2fcd5ad5ef8c1e22.1493479141.git.yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Sat, Apr 29, 2017 at 06:34:36PM -0500, Yong Zhi wrote:
...
> +static int cio2_pci_probe(struct pci_dev *pci_dev,
> +			  const struct pci_device_id *id)
> +{
> +	struct cio2_device *cio2;
> +	phys_addr_t phys;
> +	void __iomem *const *iomap;
> +	int i = -1, r = -ENODEV;
> +
> +	cio2 = devm_kzalloc(&pci_dev->dev, sizeof(*cio2), GFP_KERNEL);
> +	if (!cio2)
> +		return -ENOMEM;
> +	cio2->pci_dev = pci_dev;
> +
> +	r = pcim_enable_device(pci_dev);
> +	if (r) {
> +		dev_err(&pci_dev->dev, "failed to enable device (%d)\n", r);
> +		return r;
> +	}
> +
> +	dev_info(&pci_dev->dev, "device 0x%x (rev: 0x%x)\n",
> +		 pci_dev->device, pci_dev->revision);
> +
> +	phys = pci_resource_start(pci_dev, CIO2_PCI_BAR);
> +
> +	r = pcim_iomap_regions(pci_dev, 1 << CIO2_PCI_BAR, pci_name(pci_dev));
> +	if (r) {
> +		dev_err(&pci_dev->dev, "failed to remap I/O memory (%d)\n", r);
> +		return -ENODEV;
> +	}
> +
> +	iomap = pcim_iomap_table(pci_dev);
> +	if (!iomap) {
> +		dev_err(&pci_dev->dev, "failed to iomap table\n");
> +		return -ENODEV;
> +	}
> +
> +	cio2->base = iomap[CIO2_PCI_BAR];
> +
> +	pci_set_drvdata(pci_dev, cio2);
> +
> +	pci_set_master(pci_dev);
> +
> +	r = pci_set_dma_mask(pci_dev, CIO2_DMA_MASK);
> +	if (r) {
> +		dev_err(&pci_dev->dev, "failed to set DMA mask (%d)\n", r);
> +		return -ENODEV;
> +	}
> +
> +	r = cio2_pci_config_setup(pci_dev);
> +	if (r)
> +		return -ENODEV;
> +
> +	mutex_init(&cio2->lock);
> +
> +	cio2->media_dev.dev = &cio2->pci_dev->dev;
> +	strlcpy(cio2->media_dev.model, CIO2_DEVICE_NAME,
> +		sizeof(cio2->media_dev.model));
> +	snprintf(cio2->media_dev.bus_info, sizeof(cio2->media_dev.bus_info),
> +		 "PCI:%s", pci_name(cio2->pci_dev));
> +	cio2->media_dev.driver_version = KERNEL_VERSION(4, 11, 0);
> +	cio2->media_dev.hw_revision = 0;
> +
> +	media_device_init(&cio2->media_dev);
> +	r = media_device_register(&cio2->media_dev);
> +	if (r < 0)
> +		goto fail_mutex_destroy;
> +
> +	cio2->v4l2_dev.mdev = &cio2->media_dev;
> +	r = v4l2_device_register(&pci_dev->dev, &cio2->v4l2_dev);
> +	if (r) {
> +		dev_err(&pci_dev->dev,
> +			"failed to register V4L2 device (%d)\n", r);
> +		goto fail_mutex_destroy;
> +	}
> +
> +	for (i = 0; i < CIO2_QUEUES; i++) {
> +		r = cio2_queue_init(cio2, &cio2->queue[i]);
> +		if (r)
> +			goto fail;
> +	}
> +
> +	r = cio2_fbpt_init_dummy(cio2);
> +	if (r)
> +		goto fail;
> +
> +	/* Register notifier for subdevices we care */
> +	r = cio2_notifier_init(cio2);
> +	if (r)
> +		goto fail;
> +
> +	r = devm_request_irq(&pci_dev->dev, pci_dev->irq, cio2_irq,
> +			     IRQF_SHARED, CIO2_NAME, cio2);
> +	if (r) {
> +		dev_err(&pci_dev->dev, "failed to request IRQ (%d)\n", r);
> +		goto fail;
> +	}
> +
> +	pm_runtime_put_noidle(&pci_dev->dev);
> +	pm_runtime_allow(&pci_dev->dev);

For PCI devices pm_runtime_put_noidle() is enough. No need to call
pm_runtime_allow(). Likewise, pm_runtime_get_noresume() is called in driver
remove function.

> +
> +	return 0;
> +
> +fail:
> +	cio2_notifier_exit(cio2);
> +	cio2_fbpt_exit_dummy(cio2);
> +	for (; i >= 0; i--)
> +		cio2_queue_exit(cio2, &cio2->queue[i]);
> +	v4l2_device_unregister(&cio2->v4l2_dev);
> +	media_device_unregister(&cio2->media_dev);
> +	media_device_cleanup(&cio2->media_dev);
> +fail_mutex_destroy:
> +	mutex_destroy(&cio2->lock);
> +
> +	return r;
> +}
> +
> +static void cio2_pci_remove(struct pci_dev *pci_dev)
> +{
> +	struct cio2_device *cio2 = pci_get_drvdata(pci_dev);
> +	unsigned int i;
> +
> +	cio2_notifier_exit(cio2);
> +	cio2_fbpt_exit_dummy(cio2);
> +	for (i = 0; i < CIO2_QUEUES; i++)
> +		cio2_queue_exit(cio2, &cio2->queue[i]);
> +	v4l2_device_unregister(&cio2->v4l2_dev);
> +	media_device_unregister(&cio2->media_dev);
> +	media_device_cleanup(&cio2->media_dev);
> +	mutex_destroy(&cio2->lock);
> +}

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
