Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:63408 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756723AbeDZRuj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 13:50:39 -0400
Date: Fri, 27 Apr 2018 01:49:46 +0800
From: kbuild test robot <lkp@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        mjpeg-users@lists.sourceforge.net, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: zoran: move to dma-mapping interface
Message-ID: <201804270105.mwD8eUNH%fengguang.wu@intel.com>
References: <20180424204158.2764095-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180424204158.2764095-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.17-rc2 next-20180426]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Arnd-Bergmann/media-zoran-move-to-dma-mapping-interface/20180426-032120
base:   git://linuxtv.org/media_tree.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/pci/zoran/zoran_driver.c:419:33: sparse: incorrect type in argument 2 (different base types) @@    expected unsigned long long [unsigned] [usertype] addr @@    got nsigned long long [unsigned] [usertype] addr @@
   drivers/media/pci/zoran/zoran_driver.c:419:33:    expected unsigned long long [unsigned] [usertype] addr
   drivers/media/pci/zoran/zoran_driver.c:419:33:    got restricted __le32 [assigned] [usertype] frag_tab

vim +419 drivers/media/pci/zoran/zoran_driver.c

   395	
   396	/* free the MJPEG grab buffers */
   397	static void jpg_fbuffer_free(struct zoran_fh *fh)
   398	{
   399		struct zoran *zr = fh->zr;
   400		int i, j, off;
   401		unsigned char *mem;
   402		__le32 frag_tab;
   403		struct zoran_buffer *buffer;
   404	
   405		dprintk(4, KERN_DEBUG "%s: %s\n", ZR_DEVNAME(zr), __func__);
   406	
   407		for (i = 0, buffer = &fh->buffers.buffer[0];
   408		     i < fh->buffers.num_buffers; i++, buffer++) {
   409			if (!buffer->jpg.frag_tab)
   410				continue;
   411	
   412			if (fh->buffers.need_contiguous) {
   413				frag_tab = buffer->jpg.frag_tab[0];
   414	
   415				if (frag_tab) {
   416					mem = buffer->jpg.frag_virt_tab[0];
   417					for (off = 0; off < fh->buffers.buffer_size; off += PAGE_SIZE)
   418						ClearPageReserved(virt_to_page(mem + off));
 > 419					dma_unmap_single(&zr->pci_dev->dev, frag_tab, PAGE_SIZE, DMA_FROM_DEVICE);
   420					kfree(mem);
   421					buffer->jpg.frag_tab[0] = 0;
   422					buffer->jpg.frag_tab[1] = 0;
   423				}
   424			} else {
   425				for (j = 0; j < fh->buffers.buffer_size / PAGE_SIZE; j++) {
   426					frag_tab = buffer->jpg.frag_tab[2 * j];
   427	
   428					if (!frag_tab)
   429						break;
   430					ClearPageReserved(virt_to_page(buffer->jpg.frag_virt_tab[j]));
   431					dma_unmap_single(&zr->pci_dev->dev, le32_to_cpu(frag_tab), PAGE_SIZE, DMA_FROM_DEVICE);
   432					free_page((unsigned long)buffer->jpg.frag_virt_tab[j]);
   433					buffer->jpg.frag_virt_tab[j] = NULL;
   434					buffer->jpg.frag_tab[2 * j] = 0;
   435					buffer->jpg.frag_tab[2 * j + 1] = 0;
   436				}
   437			}
   438	
   439			dma_unmap_single(&zr->pci_dev->dev, buffer->jpg.frag_tab_dma, PAGE_SIZE, DMA_TO_DEVICE);
   440			free_page((unsigned long)buffer->jpg.frag_tab);
   441			free_page((unsigned long)buffer->jpg.frag_virt_tab);
   442			buffer->jpg.frag_virt_tab = NULL;
   443			buffer->jpg.frag_tab = NULL;
   444		}
   445	
   446		fh->buffers.allocated = 0;
   447	}
   448	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
