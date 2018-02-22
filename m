Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:2505 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932133AbeBVLzp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 06:55:45 -0500
Date: Thu, 22 Feb 2018 19:55:37 +0800
From: kbuild test robot <lkp@intel.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: kbuild-all@01.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>
Subject: Re: [ALPHA PATCH] vivid: add media device
Message-ID: <201802221926.KgWXoW65%fengguang.wu@intel.com>
References: <81a74bba-388c-634c-00df-06e2de4f668a@cisco.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <81a74bba-388c-634c-00df-06e2de4f668a@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Hans,

I love your patch! Yet something to improve:

[auto build test ERROR on linuxtv-media/master]
[also build test ERROR on v4.16-rc2 next-20180222]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Hans-Verkuil/vivid-add-media-device/20180222-135752
base:   git://linuxtv.org/media_tree.git master
config: frv-allnoconfig (attached as .config)
compiler: frv-linux-gcc (GCC) 7.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=frv 

All errors (new ones prefixed by >>):

   In file included from include/linux/cache.h:6:0,
   from include/linux/printk.h:9,
   from include/linux/kernel.h:14,
   from include/linux/list.h:9,
   from include/linux/rculist.h:10,
   from include/linux/pid.h:5,
   from include/linux/sched.h:14,
   from arch/frv/kernel/asm-offsets.c:8:
>> arch/frv/include/asm/cache.h:17:26: error: 'CONFIG_FRV_L1_CACHE_SHIFT' undeclared here (not in a function); did you mean
   #define L1_CACHE_SHIFT (CONFIG_FRV_L1_CACHE_SHIFT)
   ^
   arch/frv/include/asm/cache.h:18:31: note: in expansion of macro 'L1_CACHE_SHIFT'
   #define L1_CACHE_BYTES (1 << L1_CACHE_SHIFT)
   ^~~~~~~~~~~~~~
   arch/frv/include/asm/cache.h:21:54: note: in expansion of macro 'L1_CACHE_BYTES'
   #define ____cacheline_aligned __attribute__((aligned(L1_CACHE_BYTES)))
   ^~~~~~~~~~~~~~
   include/linux/hrtimer.h:221:3: note: in expansion of macro '____cacheline_aligned'
   } ____cacheline_aligned;
   ^~~~~~~~~~~~~~~~~~~~~
   Makefile arch include kernel scripts source Error 1
   Target '__build' not remade because of errors.
   Makefile arch include kernel scripts source Error 2
   Target 'prepare' not remade because of errors.
   make: Makefile arch include kernel scripts source Error 2

vim +/CONFIG_FRV_L1_CACHE_SHIFT +17 arch/frv/include/asm/cache.h

^1da177e include/asm-frv/cache.h Linus Torvalds 2005-04-16  14  
^1da177e include/asm-frv/cache.h Linus Torvalds 2005-04-16  15  
^1da177e include/asm-frv/cache.h Linus Torvalds 2005-04-16  16  /* bytes per L1 cache line */
^1da177e include/asm-frv/cache.h Linus Torvalds 2005-04-16 @17  #define L1_CACHE_SHIFT		(CONFIG_FRV_L1_CACHE_SHIFT)
^1da177e include/asm-frv/cache.h Linus Torvalds 2005-04-16  18  #define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
^1da177e include/asm-frv/cache.h Linus Torvalds 2005-04-16  19  

:::::: The code at line 17 was first introduced by commit
:::::: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 Linux-2.6.12-rc2

:::::: TO: Linus Torvalds <torvalds@ppc970.osdl.org>
:::::: CC: Linus Torvalds <torvalds@ppc970.osdl.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--Qxx1br4bt0+wmkIi
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--Qxx1br4bt0+wmkIi--
