Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19993 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbbAZNn6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jan 2015 08:43:58 -0500
Date: Mon, 26 Jan 2015 21:42:59 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Benoit Parrot <bparrot@ti.com>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Darren Etheridge <detheridge@ti.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [linuxtv-media:master 66/93]
 drivers/media/platform/am437x/am437x-vpfe.c:2202:57: sparse: incorrect type
 in argument 2 (different address spaces)
Message-ID: <201501262158.7n6SQC07%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   e32b31ae45c18679c186e67aa41d0e2318cae487
commit: 417d2e507edcb5cf15eb344f86bd3dd28737f24e [66/93] [media] media: platform: add VPFE capture driver support for AM437X
reproduce:
  # apt-get install sparse
  git checkout 417d2e507edcb5cf15eb344f86bd3dd28737f24e
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/platform/am437x/am437x-vpfe.c:2202:57: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/platform/am437x/am437x-vpfe.c:2202:57:    expected void [noderef] <asn:1>*params
   drivers/media/platform/am437x/am437x-vpfe.c:2202:57:    got void *param
>> include/linux/spinlock.h:364:9: sparse: context imbalance in 'vpfe_start_streaming' - unexpected unlock

vim +2202 drivers/media/platform/am437x/am437x-vpfe.c

  2186	
  2187		vpfe_dbg(2, vpfe, "vpfe_ioctl_default\n");
  2188	
  2189		if (!valid_prio) {
  2190			vpfe_err(vpfe, "%s device busy\n", __func__);
  2191			return -EBUSY;
  2192		}
  2193	
  2194		/* If streaming is started, return error */
  2195		if (vb2_is_busy(&vpfe->buffer_queue)) {
  2196			vpfe_err(vpfe, "%s device busy\n", __func__);
  2197			return -EBUSY;
  2198		}
  2199	
  2200		switch (cmd) {
  2201		case VIDIOC_AM437X_CCDC_CFG:
> 2202			ret = vpfe_ccdc_set_params(&vpfe->ccdc, param);
  2203			if (ret) {
  2204				vpfe_dbg(2, vpfe,
  2205					"Error setting parameters in CCDC\n");
  2206				return ret;
  2207			}
  2208			ret = vpfe_get_ccdc_image_format(vpfe,
  2209							 &vpfe->fmt);
  2210			if (ret < 0) {

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
