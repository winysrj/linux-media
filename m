Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:65107 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751273AbdDFEMM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Apr 2017 00:12:12 -0400
Date: Thu, 6 Apr 2017 12:11:30 +0800
From: kbuild test robot <lkp@intel.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: kbuild-all@01.org, linux@armlinux.org.uk,
        gregkh@linuxfoundation.org, pawel@osciak.com,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        mchehab@kernel.org, Shuah Khan <shuahkh@osg.samsung.com>,
        will.deacon@arm.com, Robin.Murphy@arm.com, jroedel@suse.de,
        bart.vanassche@sandisk.com, gregory.clement@free-electrons.com,
        acourbot@nvidia.com, festevam@gmail.com, krzk@kernel.org,
        niklas.soderlund+renesas@ragnatech.se, sricharan@codeaurora.org,
        dledford@redhat.com, vinod.koul@intel.com,
        andrew.smirnov@gmail.com, mauricfo@linux.vnet.ibm.com,
        alexander.h.duyck@intel.com, sagi@grimberg.me,
        ming.l@ssi.samsung.com, martin.petersen@oracle.com,
        javier@dowhile0.org, javier@osg.samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] arm: dma: fix sharing of coherent DMA memory without
 struct page
Message-ID: <201704061246.KPIrU4rl%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
In-Reply-To: <20170405160242.14195-1-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Shuah,

[auto build test ERROR on linus/master]
[also build test ERROR on v4.11-rc5]
[cannot apply to next-20170405]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Shuah-Khan/arm-dma-fix-sharing-of-coherent-DMA-memory-without-struct-page/20170406-114717
config: x86_64-randconfig-x009-201714 (attached as .config)
compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All error/warnings (new ones prefixed by >>):

   In file included from include/linux/file.h:8:0,
                    from include/linux/dma-buf.h:27,
                    from drivers/media/v4l2-core/videobuf2-dma-contig.c:13:
   drivers/media/v4l2-core/videobuf2-dma-contig.c: In function 'vb2_dc_alloc':
>> drivers/media/v4l2-core/videobuf2-dma-contig.c:164:6: error: implicit declaration of function 'dma_check_dev_coherent' [-Werror=implicit-function-declaration]
     if (dma_check_dev_coherent(dev, buf->dma_addr, buf->cookie))
         ^
   include/linux/compiler.h:160:30: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                 ^~~~
>> drivers/media/v4l2-core/videobuf2-dma-contig.c:164:2: note: in expansion of macro 'if'
     if (dma_check_dev_coherent(dev, buf->dma_addr, buf->cookie))
     ^~
   cc1: some warnings being treated as errors

vim +/dma_check_dev_coherent +164 drivers/media/v4l2-core/videobuf2-dma-contig.c

     7	 *
     8	 * This program is free software; you can redistribute it and/or modify
     9	 * it under the terms of the GNU General Public License as published by
    10	 * the Free Software Foundation.
    11	 */
    12	
  > 13	#include <linux/dma-buf.h>
    14	#include <linux/module.h>
    15	#include <linux/scatterlist.h>
    16	#include <linux/sched.h>
    17	#include <linux/slab.h>
    18	#include <linux/dma-mapping.h>
    19	
    20	#include <media/videobuf2-v4l2.h>
    21	#include <media/videobuf2-dma-contig.h>
    22	#include <media/videobuf2-memops.h>
    23	
    24	struct vb2_dc_buf {
    25		struct device			*dev;
    26		void				*vaddr;
    27		unsigned long			size;
    28		void				*cookie;
    29		dma_addr_t			dma_addr;
    30		unsigned long			attrs;
    31		enum dma_data_direction		dma_dir;
    32		struct sg_table			*dma_sgt;
    33		struct frame_vector		*vec;
    34	
    35		/* MMAP related */
    36		struct vb2_vmarea_handler	handler;
    37		atomic_t			refcount;
    38		struct sg_table			*sgt_base;
    39	
    40		/* DMABUF related */
    41		struct dma_buf_attachment	*db_attach;
    42	};
    43	
    44	/*********************************************/
    45	/*        scatterlist table functions        */
    46	/*********************************************/
    47	
    48	static unsigned long vb2_dc_get_contiguous_size(struct sg_table *sgt)
    49	{
    50		struct scatterlist *s;
    51		dma_addr_t expected = sg_dma_address(sgt->sgl);
    52		unsigned int i;
    53		unsigned long size = 0;
    54	
    55		for_each_sg(sgt->sgl, s, sgt->nents, i) {
    56			if (sg_dma_address(s) != expected)
    57				break;
    58			expected = sg_dma_address(s) + sg_dma_len(s);
    59			size += sg_dma_len(s);
    60		}
    61		return size;
    62	}
    63	
    64	/*********************************************/
    65	/*         callbacks for all buffers         */
    66	/*********************************************/
    67	
    68	static void *vb2_dc_cookie(void *buf_priv)
    69	{
    70		struct vb2_dc_buf *buf = buf_priv;
    71	
    72		return &buf->dma_addr;
    73	}
    74	
    75	static void *vb2_dc_vaddr(void *buf_priv)
    76	{
    77		struct vb2_dc_buf *buf = buf_priv;
    78	
    79		if (!buf->vaddr && buf->db_attach)
    80			buf->vaddr = dma_buf_vmap(buf->db_attach->dmabuf);
    81	
    82		return buf->vaddr;
    83	}
    84	
    85	static unsigned int vb2_dc_num_users(void *buf_priv)
    86	{
    87		struct vb2_dc_buf *buf = buf_priv;
    88	
    89		return atomic_read(&buf->refcount);
    90	}
    91	
    92	static void vb2_dc_prepare(void *buf_priv)
    93	{
    94		struct vb2_dc_buf *buf = buf_priv;
    95		struct sg_table *sgt = buf->dma_sgt;
    96	
    97		/* DMABUF exporter will flush the cache for us */
    98		if (!sgt || buf->db_attach)
    99			return;
   100	
   101		dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->orig_nents,
   102				       buf->dma_dir);
   103	}
   104	
   105	static void vb2_dc_finish(void *buf_priv)
   106	{
   107		struct vb2_dc_buf *buf = buf_priv;
   108		struct sg_table *sgt = buf->dma_sgt;
   109	
   110		/* DMABUF exporter will flush the cache for us */
   111		if (!sgt || buf->db_attach)
   112			return;
   113	
   114		dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir);
   115	}
   116	
   117	/*********************************************/
   118	/*        callbacks for MMAP buffers         */
   119	/*********************************************/
   120	
   121	static void vb2_dc_put(void *buf_priv)
   122	{
   123		struct vb2_dc_buf *buf = buf_priv;
   124	
   125		if (!atomic_dec_and_test(&buf->refcount))
   126			return;
   127	
   128		if (buf->sgt_base) {
   129			sg_free_table(buf->sgt_base);
   130			kfree(buf->sgt_base);
   131		}
   132		dma_free_attrs(buf->dev, buf->size, buf->cookie, buf->dma_addr,
   133			       buf->attrs);
   134		put_device(buf->dev);
   135		kfree(buf);
   136	}
   137	
   138	static void *vb2_dc_alloc(struct device *dev, unsigned long attrs,
   139				  unsigned long size, enum dma_data_direction dma_dir,
   140				  gfp_t gfp_flags)
   141	{
   142		struct vb2_dc_buf *buf;
   143	
   144		if (WARN_ON(!dev))
   145			return ERR_PTR(-EINVAL);
   146	
   147		buf = kzalloc(sizeof *buf, GFP_KERNEL);
   148		if (!buf)
   149			return ERR_PTR(-ENOMEM);
   150	
   151		if (attrs)
   152			buf->attrs = attrs;
   153		buf->cookie = dma_alloc_attrs(dev, size, &buf->dma_addr,
   154						GFP_KERNEL | gfp_flags, buf->attrs);
   155		if (!buf->cookie) {
   156			dev_err(dev, "dma_alloc_coherent of size %ld failed\n", size);
   157			kfree(buf);
   158			return ERR_PTR(-ENOMEM);
   159		}
   160	
   161		if ((buf->attrs & DMA_ATTR_NO_KERNEL_MAPPING) == 0)
   162			buf->vaddr = buf->cookie;
   163	
 > 164		if (dma_check_dev_coherent(dev, buf->dma_addr, buf->cookie))
   165			buf->attrs |= DMA_ATTR_DEV_COHERENT_NOPAGE;
   166	
   167		/* Prevent the device from being released while the buffer is used */

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--zhXaljGHf11kAtnf
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
QMf/AeHB1PMbrQEA

--zhXaljGHf11kAtnf--
