Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:62548 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751872AbdBJJba (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 04:31:30 -0500
Date: Fri, 10 Feb 2017 17:30:42 +0800
From: kbuild test robot <lkp@intel.com>
To: Thibault Saunier <thibault.saunier@osg.samsung.com>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-media@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Thibault Saunier <thibault.saunier@osg.samsung.com>
Subject: Re: [PATCH 4/4] [media] s5p-mfc: Always check and set
 'v4l2_pix_format:field' field
Message-ID: <201702101749.p9AsAzh5%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170209194314.5908-5-thibault.saunier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thibault,

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.10-rc7 next-20170209]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Thibault-Saunier/exynos-gsc-Use-576p-instead-720p-as-a-threshold-for-colorspaces/20170210-113658
base:   git://linuxtv.org/media_tree.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   include/linux/compiler.h:253:8: sparse: attribute 'no_sanitize_address': unknown attribute
   drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:404:17: sparse: Expected ) in function call
   drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:404:17: sparse: got pix_mp
>> drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:404:17: sparse: incompatible types for operation (>=)
   drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:404:17:    left side has type int extern [signed] [addressable] [toplevel] mfc_debug_level
   drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:404:17:    right side has type char static *<noident>
   In file included from drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:28:0:
   drivers/media/platform/s5p-mfc/s5p_mfc_dec.c: In function 'vidioc_try_fmt':
   drivers/media/platform/s5p-mfc/s5p_mfc_debug.h:25:23: warning: comparison between pointer and integer
      if (mfc_debug_level >= level)   \
                          ^
   drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:404:3: note: in expansion of macro 'mfc_debug'
      mfc_debug("Not supported field order(%d)\n", pix_mp->field);
      ^~~~~~~~~
   drivers/media/platform/s5p-mfc/s5p_mfc_debug.h:25:23: warning: comparison with string literal results in unspecified behavior [-Waddress]
      if (mfc_debug_level >= level)   \
                          ^
   drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:404:3: note: in expansion of macro 'mfc_debug'
      mfc_debug("Not supported field order(%d)\n", pix_mp->field);
      ^~~~~~~~~
   drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:404:48: error: expected ')' before 'pix_mp'
      mfc_debug("Not supported field order(%d)\n", pix_mp->field);
                                                   ^
   drivers/media/platform/s5p-mfc/s5p_mfc_debug.h:26:32: note: in definition of macro 'mfc_debug'
       printk(KERN_DEBUG "%s:%d: " fmt, \
                                   ^~~
   In file included from include/linux/printk.h:6:0,
                    from include/linux/kernel.h:13,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:14:
   include/linux/kern_levels.h:4:18: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:20: note: in expansion of macro 'KERN_SOH'
    #define KERN_DEBUG KERN_SOH "7" /* debug-level messages */
                       ^~~~~~~~
   drivers/media/platform/s5p-mfc/s5p_mfc_debug.h:26:11: note: in expansion of macro 'KERN_DEBUG'
       printk(KERN_DEBUG "%s:%d: " fmt, \
              ^~~~~~~~~~
   drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:404:3: note: in expansion of macro 'mfc_debug'
      mfc_debug("Not supported field order(%d)\n", pix_mp->field);
      ^~~~~~~~~
   include/linux/kern_levels.h:4:18: warning: format '%d' expects a matching 'int' argument [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:20: note: in expansion of macro 'KERN_SOH'
    #define KERN_DEBUG KERN_SOH "7" /* debug-level messages */
                       ^~~~~~~~
   drivers/media/platform/s5p-mfc/s5p_mfc_debug.h:26:11: note: in expansion of macro 'KERN_DEBUG'
       printk(KERN_DEBUG "%s:%d: " fmt, \
              ^~~~~~~~~~
   drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:404:3: note: in expansion of macro 'mfc_debug'
      mfc_debug("Not supported field order(%d)\n", pix_mp->field);
      ^~~~~~~~~

vim +404 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c

   388		mfc_debug_leave();
   389		return 0;
   390	}
   391	
   392	/* Try format */
   393	static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
   394	{
   395		struct s5p_mfc_dev *dev = video_drvdata(file);
   396		struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
   397		struct s5p_mfc_fmt *fmt;
   398		enum v4l2_field field;
   399	
   400		field = f->fmt.pix.field;
   401		if (field == V4L2_FIELD_ANY) {
   402			field = V4L2_FIELD_NONE;
   403		} else if (V4L2_FIELD_NONE != field) {
 > 404			mfc_debug("Not supported field order(%d)\n", pix_mp->field);
   405			return -EINVAL;
   406		}
   407	
   408		/* V4L2 specification suggests the driver corrects the format struct
   409		 * if any of the dimensions is unsupported */
   410		f->fmt.pix.field = field;
   411	
   412		mfc_debug(2, "Type is %d\n", f->type);

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
