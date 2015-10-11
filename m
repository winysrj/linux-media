Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:59916 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbbJKJJM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Oct 2015 05:09:12 -0400
Date: Sun, 11 Oct 2015 17:09:04 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Kozlov Sergey <serjk@netup.ru>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: drivers/media/dvb-core/dvbdev.h:157:18: error: too many arguments to
 function '__a'
Message-ID: <20151011090904.GB29630@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="z6Eq5LdranGa6ru8"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--z6Eq5LdranGa6ru8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Kozlov,

FYI, the error/warning still remains.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   4a06c8ac2fb3ef484579ce44f9b809bd310fad48
commit: 52b1eaf4c59a3bbd07afbb4ab4f43418a807d02e [media] netup_unidvb: NetUP Universal DVB-S/S2/T/T2/C PCI-E card driver
date:   9 weeks ago
config: x86_64-randconfig-b0-10111047 (attached as .config)
reproduce:
        git checkout 52b1eaf4c59a3bbd07afbb4ab4f43418a807d02e
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All errors (new ones prefixed by >>):

   In file included from drivers/media/pci/netup_unidvb/netup_unidvb_core.c:34:0:
   drivers/media/dvb-frontends/horus3a.h:51:13: warning: 'struct cxd2820r_config' declared inside parameter list
         struct i2c_adapter *i2c)
                ^
   drivers/media/dvb-frontends/horus3a.h:51:13: warning: its scope is only this definition or declaration, which is probably not what you want
   In file included from drivers/media/pci/netup_unidvb/netup_unidvb_core.c:36:0:
   drivers/media/dvb-frontends/lnbh25.h:46:15: error: unknown type name 'dvb_frontend'
    static inline dvb_frontend *lnbh25_attach(
                  ^
   In file included from include/media/videobuf2-dvb.h:4:0,
                    from drivers/media/pci/netup_unidvb/netup_unidvb.h:26,
                    from drivers/media/pci/netup_unidvb/netup_unidvb_core.c:32:
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c: In function 'netup_unidvb_dvb_init':
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:417:34: warning: passing argument 1 of '__a' from incompatible pointer type [-Wincompatible-pointer-types]
     if (!dvb_attach(horus3a_attach, fe0->dvb.frontend,
                                     ^
   drivers/media/dvb-core/dvbdev.h:157:22: note: in definition of macro 'dvb_attach'
      __r = (void *) __a(ARGS); \
                         ^
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:417:34: note: expected 'const struct cxd2820r_config *' but argument is of type 'struct dvb_frontend *'
     if (!dvb_attach(horus3a_attach, fe0->dvb.frontend,
                                     ^
   drivers/media/dvb-core/dvbdev.h:157:22: note: in definition of macro 'dvb_attach'
      __r = (void *) __a(ARGS); \
                         ^
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:418:4: warning: passing argument 2 of '__a' from incompatible pointer type [-Wincompatible-pointer-types]
       &horus3a_conf, &ndev->i2c[num].adap)) {
       ^
   drivers/media/dvb-core/dvbdev.h:157:22: note: in definition of macro 'dvb_attach'
      __r = (void *) __a(ARGS); \
                         ^
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:418:4: note: expected 'struct i2c_adapter *' but argument is of type 'struct horus3a_config *'
       &horus3a_conf, &ndev->i2c[num].adap)) {
       ^
   drivers/media/dvb-core/dvbdev.h:157:22: note: in definition of macro 'dvb_attach'
      __r = (void *) __a(ARGS); \
                         ^
>> drivers/media/dvb-core/dvbdev.h:157:18: error: too many arguments to function '__a'
      __r = (void *) __a(ARGS); \
                     ^
   drivers/media/pci/netup_unidvb/netup_unidvb_core.c:417:7: note: in expansion of macro 'dvb_attach'
     if (!dvb_attach(horus3a_attach, fe0->dvb.frontend,
          ^

vim +/__a +157 drivers/media/dvb-core/dvbdev.h

16ef8def drivers/media/dvb/dvb-core/dvbdev.h Arnd Bergmann         2010-04-27  141  extern long dvb_generic_ioctl (struct file *file,
^1da177e drivers/media/dvb/dvb-core/dvbdev.h Linus Torvalds        2005-04-16  142  			      unsigned int cmd, unsigned long arg);
^1da177e drivers/media/dvb/dvb-core/dvbdev.h Linus Torvalds        2005-04-16  143  
^1da177e drivers/media/dvb/dvb-core/dvbdev.h Linus Torvalds        2005-04-16  144  /* we don't mess with video_usercopy() any more,
^1da177e drivers/media/dvb/dvb-core/dvbdev.h Linus Torvalds        2005-04-16  145  we simply define out own dvb_usercopy(), which will hopefully become
^1da177e drivers/media/dvb/dvb-core/dvbdev.h Linus Torvalds        2005-04-16  146  generic_usercopy()  someday... */
^1da177e drivers/media/dvb/dvb-core/dvbdev.h Linus Torvalds        2005-04-16  147  
16ef8def drivers/media/dvb/dvb-core/dvbdev.h Arnd Bergmann         2010-04-27  148  extern int dvb_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
16ef8def drivers/media/dvb/dvb-core/dvbdev.h Arnd Bergmann         2010-04-27  149  			    int (*func)(struct file *file, unsigned int cmd, void *arg));
^1da177e drivers/media/dvb/dvb-core/dvbdev.h Linus Torvalds        2005-04-16  150  
d9955060 drivers/media/dvb/dvb-core/dvbdev.h Andrew de Quincey     2006-08-08  151  /** generic DVB attach function. */
149ef72d drivers/media/dvb/dvb-core/dvbdev.h Mauro Carvalho Chehab 2008-04-29  152  #ifdef CONFIG_MEDIA_ATTACH
d9955060 drivers/media/dvb/dvb-core/dvbdev.h Andrew de Quincey     2006-08-08  153  #define dvb_attach(FUNCTION, ARGS...) ({ \
d9955060 drivers/media/dvb/dvb-core/dvbdev.h Andrew de Quincey     2006-08-08  154  	void *__r = NULL; \
d9955060 drivers/media/dvb/dvb-core/dvbdev.h Andrew de Quincey     2006-08-08  155  	typeof(&FUNCTION) __a = symbol_request(FUNCTION); \
d9955060 drivers/media/dvb/dvb-core/dvbdev.h Andrew de Quincey     2006-08-08  156  	if (__a) { \
d9955060 drivers/media/dvb/dvb-core/dvbdev.h Andrew de Quincey     2006-08-08 @157  		__r = (void *) __a(ARGS); \
d9955060 drivers/media/dvb/dvb-core/dvbdev.h Andrew de Quincey     2006-08-08  158  		if (__r == NULL) \
d9955060 drivers/media/dvb/dvb-core/dvbdev.h Andrew de Quincey     2006-08-08  159  			symbol_put(FUNCTION); \
d9955060 drivers/media/dvb/dvb-core/dvbdev.h Andrew de Quincey     2006-08-08  160  	} else { \
d9955060 drivers/media/dvb/dvb-core/dvbdev.h Andrew de Quincey     2006-08-08  161  		printk(KERN_ERR "DVB: Unable to find symbol "#FUNCTION"()\n"); \
d9955060 drivers/media/dvb/dvb-core/dvbdev.h Andrew de Quincey     2006-08-08  162  	} \
d9955060 drivers/media/dvb/dvb-core/dvbdev.h Andrew de Quincey     2006-08-08  163  	__r; \
d9955060 drivers/media/dvb/dvb-core/dvbdev.h Andrew de Quincey     2006-08-08  164  })
d9955060 drivers/media/dvb/dvb-core/dvbdev.h Andrew de Quincey     2006-08-08  165  



---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--z6Eq5LdranGa6ru8
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
oBZSsjhb9V8Lf4D7txsBAA==

--z6Eq5LdranGa6ru8--
