Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23856 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbaKCW2z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Nov 2014 17:28:55 -0500
Date: Tue, 4 Nov 2014 06:28:23 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: "nibble.max" <nibble.max@gmail.com>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: [linuxtv-media:master 7500/7503]
 drivers/media/pci/smipcie/smipcie.c:882:31: sparse: Using plain integer as
 NULL pointer
Message-ID: <201411040615.3fOEeqTr%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   f4df95bcbb7b142bdb4cf201f5e1bd3985f8c804
commit: d32f9ff7376c4298799e1532efb307026108f53a [7500/7503] [media] smipcie: SMI pcie bridge driver for DVBSky S950 V3 dvb-s/s2 cards
reproduce:
  # apt-get install sparse
  git checkout d32f9ff7376c4298799e1532efb307026108f53a
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/pci/smipcie/smipcie.c:882:31: sparse: Using plain integer as NULL pointer
>> drivers/media/pci/smipcie/smipcie.c:905:31: sparse: Using plain integer as NULL pointer

vim +882 drivers/media/pci/smipcie/smipcie.c

   876			smi_port_detach(&dev->ts_port[0]);
   877	err_del_i2c_adaptor:
   878		smi_i2c_exit(dev);
   879	err_pci_iounmap:
   880		iounmap(dev->lmmio);
   881	err_kfree:
 > 882		pci_set_drvdata(pdev, 0);
   883		kfree(dev);
   884	err_pci_disable_device:
   885		pci_disable_device(pdev);
   886		return ret;
   887	}
   888	
   889	static void smi_remove(struct pci_dev *pdev)
   890	{
   891		struct smi_dev *dev = pci_get_drvdata(pdev);
   892	
   893		smi_write(MSI_INT_ENA_CLR, ALL_INT);
   894		free_irq(dev->pci_dev->irq, dev);
   895	#ifdef CONFIG_PCI_MSI
   896		pci_disable_msi(dev->pci_dev);
   897	#endif
   898		if (dev->info->ts_1)
   899			smi_port_detach(&dev->ts_port[1]);
   900		if (dev->info->ts_0)
   901			smi_port_detach(&dev->ts_port[0]);
   902	
   903		smi_i2c_exit(dev);
   904		iounmap(dev->lmmio);
 > 905		pci_set_drvdata(pdev, 0);
   906		pci_disable_device(pdev);
   907		kfree(dev);
   908	}

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
