Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:30247 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752423AbeDFW0A (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 18:26:00 -0400
Date: Sat, 7 Apr 2018 06:25:31 +0800
From: kbuild test robot <lkp@intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: kbuild-all@01.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        devel@driverdev.osuosl.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 19/19] media: staging: davinci_vpfe: allow building
 with COMPILE_TEST
Message-ID: <201804070647.QhBxYVWq%fengguang.wu@intel.com>
References: <51b55b8a47aac8f712a5aff2fe79d20f9f7b9cf7.1522959716.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51b55b8a47aac8f712a5aff2fe79d20f9f7b9cf7.1522959716.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on next-20180406]
[cannot apply to v4.16]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Mauro-Carvalho-Chehab/Make-all-media-drivers-build-with-COMPILE_TEST/20180406-163048
base:   git://linuxtv.org/media_tree.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/staging/media/davinci_vpfe/dm365_ipipe.c:1276:45: sparse: incorrect type in initializer (different address spaces) @@    expected void [noderef] <asn:1>*from @@    got void [noderef] <asn:1>*from @@
   drivers/staging/media/davinci_vpfe/dm365_ipipe.c:1276:45:    expected void [noderef] <asn:1>*from
   drivers/staging/media/davinci_vpfe/dm365_ipipe.c:1276:45:    got void *[noderef] <asn:1><noident>
>> drivers/staging/media/davinci_vpfe/dm365_ipipe.c:1319:43: sparse: incorrect type in initializer (different address spaces) @@    expected void [noderef] <asn:1>*to @@    got void [noderef] <asn:1>*to @@
   drivers/staging/media/davinci_vpfe/dm365_ipipe.c:1319:43:    expected void [noderef] <asn:1>*to
   drivers/staging/media/davinci_vpfe/dm365_ipipe.c:1319:43:    got void *[noderef] <asn:1><noident>
>> drivers/staging/media/davinci_vpfe/dm365_ipipe.c:1276:47: sparse: dereference of noderef expression
   drivers/staging/media/davinci_vpfe/dm365_ipipe.c:1319:45: sparse: dereference of noderef expression
--
>> drivers/staging/media/davinci_vpfe/dm365_resizer.c:922:32: sparse: incorrect type in argument 2 (different address spaces) @@    expected void const [noderef] <asn:1>*from @@    got stvoid const [noderef] <asn:1>*from @@
   drivers/staging/media/davinci_vpfe/dm365_resizer.c:922:32:    expected void const [noderef] <asn:1>*from
   drivers/staging/media/davinci_vpfe/dm365_resizer.c:922:32:    got struct vpfe_rsz_config_params *config
>> drivers/staging/media/davinci_vpfe/dm365_resizer.c:945:27: sparse: incorrect type in argument 1 (different address spaces) @@    expected void [noderef] <asn:1>*to @@    got sn:1>*to @@
   drivers/staging/media/davinci_vpfe/dm365_resizer.c:945:27:    expected void [noderef] <asn:1>*to
   drivers/staging/media/davinci_vpfe/dm365_resizer.c:945:27:    got void *<noident>
--
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:201:27: sparse: incorrect type in assignment (different address spaces) @@    expected void *ipipeif_base_addr @@    got void [noderef] <avoid *ipipeif_base_addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:201:27:    expected void *ipipeif_base_addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:201:27:    got void [noderef] <asn:2>*ipipeif_base_addr
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:71:27: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:71:27:    expected void const volatile [noderef] <asn:2>*addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:71:27:    got void *
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:71:27: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:71:27:    expected void const volatile [noderef] <asn:2>*addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:71:27:    got void *
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:424:41: sparse: incorrect type in initializer (different address spaces) @@    expected struct ipipeif_params *config @@    got struct ipipeif_params *config @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:424:41:    expected struct ipipeif_params *config
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:424:41:    got void [noderef] <asn:1>*arg
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:474:46: sparse: incorrect type in argument 2 (different address spaces) @@    expected void [noderef] <asn:1>*arg @@    got sn:1>*arg @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:474:46:    expected void [noderef] <asn:1>*arg
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:474:46:    got void *arg
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:510:42: sparse: incorrect type in initializer (different address spaces) @@    expected void *ipipeif_base_addr @@    got void [noderef] <avoid *ipipeif_base_addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:510:42:    expected void *ipipeif_base_addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:510:42:    got void [noderef] <asn:2>*ipipeif_base_addr
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:71:27: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:71:27:    expected void const volatile [noderef] <asn:2>*addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:71:27:    got void *
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:797:42: sparse: incorrect type in initializer (different address spaces) @@    expected void *ipipeif_base_addr @@    got void [noderef] <avoid *ipipeif_base_addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:797:42:    expected void *ipipeif_base_addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:797:42:    got void [noderef] <asn:2>*ipipeif_base_addr
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *
>> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    expected void volatile [noderef] <asn:2>*addr
   drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:76:26:    got void *

vim +1276 drivers/staging/media/davinci_vpfe/dm365_ipipe.c

da43b6cca Manjunath Hadli 2012-11-28  1262  
da43b6cca Manjunath Hadli 2012-11-28  1263  static int ipipe_s_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
da43b6cca Manjunath Hadli 2012-11-28  1264  {
da43b6cca Manjunath Hadli 2012-11-28  1265  	struct vpfe_ipipe_device *ipipe = v4l2_get_subdevdata(sd);
da43b6cca Manjunath Hadli 2012-11-28  1266  	unsigned int i;
da43b6cca Manjunath Hadli 2012-11-28  1267  	int rval = 0;
da43b6cca Manjunath Hadli 2012-11-28  1268  
da43b6cca Manjunath Hadli 2012-11-28  1269  	for (i = 0; i < ARRAY_SIZE(ipipe_modules); i++) {
da43b6cca Manjunath Hadli 2012-11-28  1270  		unsigned int bit = 1 << i;
3b12c89d0 Lad, Prabhakar  2014-03-29  1271  
da43b6cca Manjunath Hadli 2012-11-28  1272  		if (cfg->flag & bit) {
da43b6cca Manjunath Hadli 2012-11-28  1273  			const struct ipipe_module_if *module_if =
da43b6cca Manjunath Hadli 2012-11-28  1274  						&ipipe_modules[i];
da43b6cca Manjunath Hadli 2012-11-28  1275  			struct ipipe_module_params *params;
da43b6cca Manjunath Hadli 2012-11-28 @1276  			void __user *from = *(void * __user *)
da43b6cca Manjunath Hadli 2012-11-28  1277  				((void *)cfg + module_if->config_offset);
da43b6cca Manjunath Hadli 2012-11-28  1278  			size_t size;
da43b6cca Manjunath Hadli 2012-11-28  1279  			void *to;
da43b6cca Manjunath Hadli 2012-11-28  1280  
da43b6cca Manjunath Hadli 2012-11-28  1281  			params = kmalloc(sizeof(struct ipipe_module_params),
da43b6cca Manjunath Hadli 2012-11-28  1282  					 GFP_KERNEL);
da43b6cca Manjunath Hadli 2012-11-28  1283  			to = (void *)params + module_if->param_offset;
da43b6cca Manjunath Hadli 2012-11-28  1284  			size = module_if->param_size;
da43b6cca Manjunath Hadli 2012-11-28  1285  
da43b6cca Manjunath Hadli 2012-11-28  1286  			if (to && from && size) {
da43b6cca Manjunath Hadli 2012-11-28  1287  				if (copy_from_user(to, from, size)) {
da43b6cca Manjunath Hadli 2012-11-28  1288  					rval = -EFAULT;
da43b6cca Manjunath Hadli 2012-11-28  1289  					break;
da43b6cca Manjunath Hadli 2012-11-28  1290  				}
da43b6cca Manjunath Hadli 2012-11-28  1291  				rval = module_if->set(ipipe, to);
da43b6cca Manjunath Hadli 2012-11-28  1292  				if (rval)
da43b6cca Manjunath Hadli 2012-11-28  1293  					goto error;
da43b6cca Manjunath Hadli 2012-11-28  1294  			} else if (to && !from && size) {
da43b6cca Manjunath Hadli 2012-11-28  1295  				rval = module_if->set(ipipe, NULL);
da43b6cca Manjunath Hadli 2012-11-28  1296  				if (rval)
da43b6cca Manjunath Hadli 2012-11-28  1297  					goto error;
da43b6cca Manjunath Hadli 2012-11-28  1298  			}
da43b6cca Manjunath Hadli 2012-11-28  1299  			kfree(params);
da43b6cca Manjunath Hadli 2012-11-28  1300  		}
da43b6cca Manjunath Hadli 2012-11-28  1301  	}
da43b6cca Manjunath Hadli 2012-11-28  1302  error:
da43b6cca Manjunath Hadli 2012-11-28  1303  	return rval;
da43b6cca Manjunath Hadli 2012-11-28  1304  }
da43b6cca Manjunath Hadli 2012-11-28  1305  
da43b6cca Manjunath Hadli 2012-11-28  1306  static int ipipe_g_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
da43b6cca Manjunath Hadli 2012-11-28  1307  {
da43b6cca Manjunath Hadli 2012-11-28  1308  	struct vpfe_ipipe_device *ipipe = v4l2_get_subdevdata(sd);
da43b6cca Manjunath Hadli 2012-11-28  1309  	unsigned int i;
da43b6cca Manjunath Hadli 2012-11-28  1310  	int rval = 0;
da43b6cca Manjunath Hadli 2012-11-28  1311  
da43b6cca Manjunath Hadli 2012-11-28  1312  	for (i = 1; i < ARRAY_SIZE(ipipe_modules); i++) {
da43b6cca Manjunath Hadli 2012-11-28  1313  		unsigned int bit = 1 << i;
3b12c89d0 Lad, Prabhakar  2014-03-29  1314  
da43b6cca Manjunath Hadli 2012-11-28  1315  		if (cfg->flag & bit) {
da43b6cca Manjunath Hadli 2012-11-28  1316  			const struct ipipe_module_if *module_if =
da43b6cca Manjunath Hadli 2012-11-28  1317  						&ipipe_modules[i];
da43b6cca Manjunath Hadli 2012-11-28  1318  			struct ipipe_module_params *params;
da43b6cca Manjunath Hadli 2012-11-28 @1319  			void __user *to = *(void * __user *)
da43b6cca Manjunath Hadli 2012-11-28  1320  				((void *)cfg + module_if->config_offset);
da43b6cca Manjunath Hadli 2012-11-28  1321  			size_t size;
da43b6cca Manjunath Hadli 2012-11-28  1322  			void *from;
da43b6cca Manjunath Hadli 2012-11-28  1323  
da43b6cca Manjunath Hadli 2012-11-28  1324  			params =  kmalloc(sizeof(struct ipipe_module_params),
da43b6cca Manjunath Hadli 2012-11-28  1325  						GFP_KERNEL);
da43b6cca Manjunath Hadli 2012-11-28  1326  			from = (void *)params + module_if->param_offset;
da43b6cca Manjunath Hadli 2012-11-28  1327  			size = module_if->param_size;
da43b6cca Manjunath Hadli 2012-11-28  1328  
da43b6cca Manjunath Hadli 2012-11-28  1329  			if (to && from && size) {
da43b6cca Manjunath Hadli 2012-11-28  1330  				rval = module_if->get(ipipe, from);
da43b6cca Manjunath Hadli 2012-11-28  1331  				if (rval)
da43b6cca Manjunath Hadli 2012-11-28  1332  					goto error;
da43b6cca Manjunath Hadli 2012-11-28  1333  				if (copy_to_user(to, from, size)) {
da43b6cca Manjunath Hadli 2012-11-28  1334  					rval = -EFAULT;
da43b6cca Manjunath Hadli 2012-11-28  1335  					break;
da43b6cca Manjunath Hadli 2012-11-28  1336  				}
da43b6cca Manjunath Hadli 2012-11-28  1337  			}
da43b6cca Manjunath Hadli 2012-11-28  1338  			kfree(params);
da43b6cca Manjunath Hadli 2012-11-28  1339  		}
da43b6cca Manjunath Hadli 2012-11-28  1340  	}
da43b6cca Manjunath Hadli 2012-11-28  1341  error:
da43b6cca Manjunath Hadli 2012-11-28  1342  	return rval;
da43b6cca Manjunath Hadli 2012-11-28  1343  }
da43b6cca Manjunath Hadli 2012-11-28  1344  

:::::: The code at line 1276 was first introduced by commit
:::::: da43b6ccadcfe801e0316503334f8281b8679210 [media] davinci: vpfe: dm365: add IPIPE support for media controller driver

:::::: TO: Manjunath Hadli <manjunath.hadli@ti.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@redhat.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
