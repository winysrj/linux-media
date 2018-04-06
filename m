Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:18988 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751624AbeDFQSQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 12:18:16 -0400
Date: Sat, 7 Apr 2018 00:17:35 +0800
From: kbuild test robot <lkp@intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: kbuild-all@01.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH v2 11/19] media: davinci: allow building isif code
Message-ID: <201804070009.2cJljPMs%fengguang.wu@intel.com>
References: <da9c37673dff87dd86d7c838f004bf795223eebc.1522959716.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da9c37673dff87dd86d7c838f004bf795223eebc.1522959716.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.16 next-20180406]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Mauro-Carvalho-Chehab/Make-all-media-drivers-build-with-COMPILE_TEST/20180406-163048
base:   git://linuxtv.org/media_tree.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/platform/davinci/isif.c:1066:22: sparse: incorrect type in assignment (different address spaces) @@    expected void *[noderef] <asn:2>addr @@    got void *[noderef] <asn:2>addr @@
   drivers/media/platform/davinci/isif.c:1066:22:    expected void *[noderef] <asn:2>addr
   drivers/media/platform/davinci/isif.c:1066:22:    got void [noderef] <asn:2>*
>> drivers/media/platform/davinci/isif.c:1074:44: sparse: incorrect type in assignment (different address spaces) @@    expected void [noderef] <asn:2>*static [toplevel] [assigned] base_addr @@    got  [toplevel] [assigned] base_addr @@
   drivers/media/platform/davinci/isif.c:1074:44:    expected void [noderef] <asn:2>*static [toplevel] [assigned] base_addr
   drivers/media/platform/davinci/isif.c:1074:44:    got void *[noderef] <asn:2>addr
>> drivers/media/platform/davinci/isif.c:1078:51: sparse: incorrect type in assignment (different address spaces) @@    expected void [noderef] <asn:2>*static [toplevel] [assigned] linear_tbl0_addr @@    got  [toplevel] [assigned] linear_tbl0_addr @@
   drivers/media/platform/davinci/isif.c:1078:51:    expected void [noderef] <asn:2>*static [toplevel] [assigned] linear_tbl0_addr
   drivers/media/platform/davinci/isif.c:1078:51:    got void *[noderef] <asn:2>addr
>> drivers/media/platform/davinci/isif.c:1082:51: sparse: incorrect type in assignment (different address spaces) @@    expected void [noderef] <asn:2>*static [toplevel] [assigned] linear_tbl1_addr @@    got  [toplevel] [assigned] linear_tbl1_addr @@
   drivers/media/platform/davinci/isif.c:1082:51:    expected void [noderef] <asn:2>*static [toplevel] [assigned] linear_tbl1_addr
   drivers/media/platform/davinci/isif.c:1082:51:    got void *[noderef] <asn:2>addr
>> drivers/media/platform/davinci/isif.c:1067:22: sparse: dereference of noderef expression

vim +1066 drivers/media/platform/davinci/isif.c

63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1025  
4c62e976 drivers/media/platform/davinci/isif.c Greg Kroah-Hartman 2012-12-21  1026  static int isif_probe(struct platform_device *pdev)
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1027  {
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1028  	void (*setup_pinmux)(void);
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1029  	struct resource	*res;
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1030  	void *__iomem addr;
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1031  	int status = 0, i;
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1032  
9a3e89b1 drivers/media/platform/davinci/isif.c Lad, Prabhakar     2013-03-22  1033  	/* Platform data holds setup_pinmux function ptr */
9a3e89b1 drivers/media/platform/davinci/isif.c Lad, Prabhakar     2013-03-22  1034  	if (!pdev->dev.platform_data)
9a3e89b1 drivers/media/platform/davinci/isif.c Lad, Prabhakar     2013-03-22  1035  		return -ENODEV;
9a3e89b1 drivers/media/platform/davinci/isif.c Lad, Prabhakar     2013-03-22  1036  
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1037  	/*
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1038  	 * first try to register with vpfe. If not correct platform, then we
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1039  	 * don't have to iomap
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1040  	 */
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1041  	status = vpfe_register_ccdc_device(&isif_hw_dev);
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1042  	if (status < 0)
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1043  		return status;
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1044  
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1045  	setup_pinmux = pdev->dev.platform_data;
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1046  	/*
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1047  	 * setup Mux configuration for ccdc which may be different for
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1048  	 * different SoCs using this CCDC
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1049  	 */
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1050  	setup_pinmux();
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1051  
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1052  	i = 0;
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1053  	/* Get the ISIF base address, linearization table0 and table1 addr. */
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1054  	while (i < 3) {
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1055  		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1056  		if (!res) {
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1057  			status = -ENODEV;
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1058  			goto fail_nobase_res;
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1059  		}
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1060  		res = request_mem_region(res->start, resource_size(res),
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1061  					 res->name);
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1062  		if (!res) {
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1063  			status = -EBUSY;
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1064  			goto fail_nobase_res;
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1065  		}
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21 @1066  		addr = ioremap_nocache(res->start, resource_size(res));
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21 @1067  		if (!addr) {
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1068  			status = -ENOMEM;
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1069  			goto fail_base_iomap;
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1070  		}
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1071  		switch (i) {
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1072  		case 0:
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1073  			/* ISIF base address */
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21 @1074  			isif_cfg.base_addr = addr;
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1075  			break;
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1076  		case 1:
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1077  			/* ISIF linear tbl0 address */
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21 @1078  			isif_cfg.linear_tbl0_addr = addr;
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1079  			break;
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1080  		default:
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1081  			/* ISIF linear tbl0 address */
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21 @1082  			isif_cfg.linear_tbl1_addr = addr;
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1083  			break;
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1084  		}
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1085  		i++;
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1086  	}
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1087  	isif_cfg.dev = &pdev->dev;
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1088  
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1089  	printk(KERN_NOTICE "%s is registered with vpfe.\n",
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1090  		isif_hw_dev.name);
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1091  	return 0;
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1092  fail_base_iomap:
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1093  	release_mem_region(res->start, resource_size(res));
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1094  	i--;
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1095  fail_nobase_res:
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1096  	if (isif_cfg.base_addr)
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1097  		iounmap(isif_cfg.base_addr);
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1098  	if (isif_cfg.linear_tbl0_addr)
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1099  		iounmap(isif_cfg.linear_tbl0_addr);
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1100  
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1101  	while (i >= 0) {
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1102  		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1103  		release_mem_region(res->start, resource_size(res));
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1104  		i--;
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1105  	}
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1106  	vpfe_unregister_ccdc_device(&isif_hw_dev);
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1107  	return status;
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1108  }
63e3ab14 drivers/media/video/davinci/isif.c    Murali Karicheri   2010-02-21  1109  

:::::: The code at line 1066 was first introduced by commit
:::::: 63e3ab142fa3f46c290891655681c6a6304bd2b3 V4L/DVB: V4L - vpfe capture - source for ISIF driver on DM365

:::::: TO: Murali Karicheri <mkaricheri@gmail.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@redhat.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
