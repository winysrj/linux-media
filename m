Return-Path: <SRS0=xT8T=PG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 992BCC43387
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 18:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 343B62087F
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 18:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbeL2SWp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 29 Dec 2018 13:22:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:23881 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbeL2SWp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Dec 2018 13:22:45 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Dec 2018 09:22:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,414,1539673200"; 
   d="gz'50?scan'50,208,50";a="105591115"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 29 Dec 2018 09:22:21 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1gdIJZ-000GZX-88; Sun, 30 Dec 2018 01:22:21 +0800
Date:   Sun, 30 Dec 2018 01:22:12 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Malathi Gottam <mgottam@codeaurora.org>
Cc:     kbuild-all@01.org, stanimir.varbanov@linaro.org,
        hverkuil@xs4all.nl, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org, mgottam@codeaurora.org
Subject: Re: [PATCH v2] media: venus: add debugfs support
Message-ID: <201812300151.SY5xiU29%fengguang.wu@intel.com>
References: <1545988986-26244-1-git-send-email-mgottam@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <1545988986-26244-1-git-send-email-mgottam@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Malathi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linuxtv-media/master]
[also build test ERROR on next-20181224]
[cannot apply to v4.20]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Malathi-Gottam/media-venus-add-debugfs-support/20181228-172634
base:   git://linuxtv.org/media_tree.git master
config: microblaze-allyesconfig (attached as .config)
compiler: microblaze-linux-gcc (GCC) 8.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        GCC_VERSION=8.1.0 make.cross ARCH=microblaze 

All errors (new ones prefixed by >>):

   In file included from include/linux/kernel.h:14,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
   drivers/media/platform/qcom/venus/helpers.c: In function 'venus_helper_check_codec':
>> drivers/media/platform/qcom/venus/helpers.c:78:40: error: 'pixfmt' undeclared (first use in this function); did you mean 'pr_fmt'?
      dprintk(WARN, "Unknown format:%x\n", pixfmt);
                                           ^~~~~~
   include/linux/printk.h:315:34: note: in definition of macro 'pr_info'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
                                     ^~~~~~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:78:3: note: in expansion of macro 'dprintk'
      dprintk(WARN, "Unknown format:%x\n", pixfmt);
      ^~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:78:40: note: each undeclared identifier is reported only once for each function it appears in
      dprintk(WARN, "Unknown format:%x\n", pixfmt);
                                           ^~~~~~
   include/linux/printk.h:315:34: note: in definition of macro 'pr_info'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
                                     ^~~~~~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:78:3: note: in expansion of macro 'dprintk'
      dprintk(WARN, "Unknown format:%x\n", pixfmt);
      ^~~~~~~
   In file included from include/linux/printk.h:7,
                    from include/linux/kernel.h:14,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
   drivers/media/platform/qcom/venus/helpers.c: In function 'venus_helper_queue_dpb_bufs':
   include/linux/kern_levels.h:5:18: warning: format '%d' expects argument of type 'int', but argument 3 has type 'const char *' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^~~~~~
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:315:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/platform/qcom/venus/core.h:55:4: note: in expansion of macro 'pr_info'
       pr_info("venus:" fmt, \
       ^~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:107:4: note: in expansion of macro 'dprintk'
       dprintk(ERR, "%s: Failed to queue dpb buf to hfi: %d\n",
       ^~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:107:55: note: format string is defined here
       dprintk(ERR, "%s: Failed to queue dpb buf to hfi: %d\n",
                                                         ~^
                                                         %s
   In file included from include/linux/printk.h:7,
                    from include/linux/kernel.h:14,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
   include/linux/kern_levels.h:5:18: warning: too many arguments for format [-Wformat-extra-args]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^~~~~~
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:315:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/platform/qcom/venus/core.h:55:4: note: in expansion of macro 'pr_info'
       pr_info("venus:" fmt, \
       ^~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:107:4: note: in expansion of macro 'dprintk'
       dprintk(ERR, "%s: Failed to queue dpb buf to hfi: %d\n",
       ^~~~~~~
   drivers/media/platform/qcom/venus/helpers.c: In function 'venus_helper_alloc_dpb_bufs':
   include/linux/kern_levels.h:5:18: warning: format '%d' expects argument of type 'int', but argument 2 has type 'char *' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^~~~~~
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:315:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/platform/qcom/venus/core.h:55:4: note: in expansion of macro 'pr_info'
       pr_info("venus:" fmt, \
       ^~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:164:2: note: in expansion of macro 'dprintk'
     dprintk(DBG, "buf count min %d", count);
     ^~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:164:31: note: format string is defined here
     dprintk(DBG, "buf count min %d", count);
                                 ~^
                                 %s
   In file included from include/linux/printk.h:7,
                    from include/linux/kernel.h:14,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
   include/linux/kern_levels.h:5:18: warning: too many arguments for format [-Wformat-extra-args]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^~~~~~
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:315:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/platform/qcom/venus/core.h:55:4: note: in expansion of macro 'pr_info'
       pr_info("venus:" fmt, \
       ^~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:164:2: note: in expansion of macro 'dprintk'
     dprintk(DBG, "buf count min %d", count);
     ^~~~~~~
   include/linux/kern_levels.h:5:18: warning: too many arguments for format [-Wformat-extra-args]
--
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/platform/qcom/venus/core.h:55:4: note: in expansion of macro 'pr_info'
       pr_info("venus:" fmt, \
       ^~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:756:3: note: in expansion of macro 'dprintk'
      dprintk(ERR,
      ^~~~~~~
   include/linux/kern_levels.h:5:18: warning: format '%d' expects argument of type 'int', but argument 2 has type 'char *' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^~~~~~
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:315:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/platform/qcom/venus/core.h:55:4: note: in expansion of macro 'pr_info'
       pr_info("venus:" fmt, \
       ^~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:766:3: note: in expansion of macro 'dprintk'
      dprintk(ERR,
      ^~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:767:40: note: format string is defined here
       "Failed to set actual buffer count %d for buffer type %d\n",
                                          ~^
                                          %s
   In file included from include/linux/printk.h:7,
                    from include/linux/kernel.h:14,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
   include/linux/kern_levels.h:5:18: warning: too many arguments for format [-Wformat-extra-args]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^~~~~~
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:315:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/platform/qcom/venus/core.h:55:4: note: in expansion of macro 'pr_info'
       pr_info("venus:" fmt, \
       ^~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:766:3: note: in expansion of macro 'dprintk'
      dprintk(ERR,
      ^~~~~~~
   include/linux/kern_levels.h:5:18: warning: format '%d' expects argument of type 'int', but argument 2 has type 'char *' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^~~~~~
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:315:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/platform/qcom/venus/core.h:55:4: note: in expansion of macro 'pr_info'
       pr_info("venus:" fmt, \
       ^~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:771:2: note: in expansion of macro 'dprintk'
     dprintk(DBG, "output buf: num = %d, input buf = %d\n",
     ^~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:771:35: note: format string is defined here
     dprintk(DBG, "output buf: num = %d, input buf = %d\n",
                                     ~^
                                     %s
   In file included from include/linux/printk.h:7,
                    from include/linux/kernel.h:14,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
   include/linux/kern_levels.h:5:18: warning: too many arguments for format [-Wformat-extra-args]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^~~~~~
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:315:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/platform/qcom/venus/core.h:55:4: note: in expansion of macro 'pr_info'
       pr_info("venus:" fmt, \
       ^~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:771:2: note: in expansion of macro 'dprintk'
     dprintk(DBG, "output buf: num = %d, input buf = %d\n",
     ^~~~~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/kernel.h:7,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
   include/linux/export.h:79:2: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
     extern typeof(sym) sym;      \
     ^~~~~~
   include/linux/export.h:120:25: note: in expansion of macro '___EXPORT_SYMBOL'
    #define __EXPORT_SYMBOL ___EXPORT_SYMBOL
                            ^~~~~~~~~~~~~~~~
   include/linux/export.h:127:2: note: in expansion of macro '__EXPORT_SYMBOL'
     __EXPORT_SYMBOL(sym, "_gpl")
     ^~~~~~~~~~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:782:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
    EXPORT_SYMBOL_GPL(venus_helper_set_num_bufs);
    ^~~~~~~~~~~~~~~~~
>> drivers/media/platform/qcom/venus/helpers.c:795:19: error: non-static declaration of 'venus_helper_set_raw_format' follows static declaration
    EXPORT_SYMBOL_GPL(venus_helper_set_raw_format);
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:79:21: note: in definition of macro '___EXPORT_SYMBOL'
     extern typeof(sym) sym;      \
                        ^~~
   drivers/media/platform/qcom/venus/helpers.c:795:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
    EXPORT_SYMBOL_GPL(venus_helper_set_raw_format);
    ^~~~~~~~~~~~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:784:5: note: previous definition of 'venus_helper_set_raw_format' was here
    int venus_helper_set_raw_format(struct venus_inst *inst, u32 hfi_format,
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/printk.h:7,
                    from include/linux/kernel.h:14,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
   drivers/media/platform/qcom/venus/helpers.c: In function 'venus_helper_set_color_format':
   include/linux/kern_levels.h:5:18: warning: format '%x' expects argument of type 'unsigned int', but argument 2 has type 'char *' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^~~~~~
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:315:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/platform/qcom/venus/core.h:55:4: note: in expansion of macro 'pr_info'
       pr_info("venus:" fmt, \
       ^~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:810:3: note: in expansion of macro 'dprintk'
      dprintk(ERR, "Using unsupported colorformat %#x\n",
      ^~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:810:49: note: format string is defined here
      dprintk(ERR, "Using unsupported colorformat %#x\n",
                                                  ~~^
                                                  %#s
   In file included from include/linux/printk.h:7,
                    from include/linux/kernel.h:14,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
   include/linux/kern_levels.h:5:18: warning: too many arguments for format [-Wformat-extra-args]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^~~~~~
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:315:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/platform/qcom/venus/core.h:55:4: note: in expansion of macro 'pr_info'
       pr_info("venus:" fmt, \
       ^~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:810:3: note: in expansion of macro 'dprintk'
      dprintk(ERR, "Using unsupported colorformat %#x\n",
      ^~~~~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/kernel.h:7,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
   drivers/media/platform/qcom/venus/helpers.c: In function 'venus_helper_set_num_bufs':
>> drivers/media/platform/qcom/venus/helpers.c:817:19: error: non-static declaration of 'venus_helper_set_color_format' follows static declaration
    EXPORT_SYMBOL_GPL(venus_helper_set_color_format);
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:79:21: note: in definition of macro '___EXPORT_SYMBOL'
     extern typeof(sym) sym;      \
                        ^~~
   drivers/media/platform/qcom/venus/helpers.c:817:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
    EXPORT_SYMBOL_GPL(venus_helper_set_color_format);
    ^~~~~~~~~~~~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:797:5: note: previous definition of 'venus_helper_set_color_format' was here
    int venus_helper_set_color_format(struct venus_inst *inst, u32 pixfmt)
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/kernel.h:7,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
   drivers/media/platform/qcom/venus/helpers.c:838:19: error: non-static declaration of 'venus_helper_set_multistream' follows static declaration
    EXPORT_SYMBOL_GPL(venus_helper_set_multistream);
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:79:21: note: in definition of macro '___EXPORT_SYMBOL'
     extern typeof(sym) sym;      \
                        ^~~
   drivers/media/platform/qcom/venus/helpers.c:838:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
    EXPORT_SYMBOL_GPL(venus_helper_set_multistream);
    ^~~~~~~~~~~~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:819:5: note: previous definition of 'venus_helper_set_multistream' was here
    int venus_helper_set_multistream(struct venus_inst *inst, bool out_en,
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/kernel.h:7,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
   drivers/media/platform/qcom/venus/helpers.c:860:19: error: non-static declaration of 'venus_helper_set_dyn_bufmode' follows static declaration
    EXPORT_SYMBOL_GPL(venus_helper_set_dyn_bufmode);
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:79:21: note: in definition of macro '___EXPORT_SYMBOL'
     extern typeof(sym) sym;      \
                        ^~~
   drivers/media/platform/qcom/venus/helpers.c:860:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
    EXPORT_SYMBOL_GPL(venus_helper_set_dyn_bufmode);
    ^~~~~~~~~~~~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:840:5: note: previous definition of 'venus_helper_set_dyn_bufmode' was here
    int venus_helper_set_dyn_bufmode(struct venus_inst *inst)
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/kernel.h:7,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
>> drivers/media/platform/qcom/venus/helpers.c:872:19: error: non-static declaration of 'venus_helper_set_bufsize' follows static declaration
    EXPORT_SYMBOL_GPL(venus_helper_set_bufsize);
                      ^~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:79:21: note: in definition of macro '___EXPORT_SYMBOL'
     extern typeof(sym) sym;      \
                        ^~~
   drivers/media/platform/qcom/venus/helpers.c:872:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
    EXPORT_SYMBOL_GPL(venus_helper_set_bufsize);
    ^~~~~~~~~~~~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:862:5: note: previous definition of 'venus_helper_set_bufsize' was here
    int venus_helper_set_bufsize(struct venus_inst *inst, u32 bufsize, u32 buftype)
        ^~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/kernel.h:7,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
>> drivers/media/platform/qcom/venus/helpers.c:887:19: error: non-static declaration of 'venus_helper_get_opb_size' follows static declaration
    EXPORT_SYMBOL_GPL(venus_helper_get_opb_size);
                      ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:79:21: note: in definition of macro '___EXPORT_SYMBOL'
     extern typeof(sym) sym;      \
                        ^~~
   drivers/media/platform/qcom/venus/helpers.c:887:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
    EXPORT_SYMBOL_GPL(venus_helper_get_opb_size);
    ^~~~~~~~~~~~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:874:14: note: previous definition of 'venus_helper_get_opb_size' was here
    unsigned int venus_helper_get_opb_size(struct venus_inst *inst)
                 ^~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:889:13: error: invalid storage class for function 'delayed_process_buf_func'
    static void delayed_process_buf_func(struct work_struct *work)
                ^~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/kernel.h:7,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
   drivers/media/platform/qcom/venus/helpers.c:928:19: error: non-static declaration of 'venus_helper_release_buf_ref' follows static declaration
    EXPORT_SYMBOL_GPL(venus_helper_release_buf_ref);
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:79:21: note: in definition of macro '___EXPORT_SYMBOL'
     extern typeof(sym) sym;      \
                        ^~~
   drivers/media/platform/qcom/venus/helpers.c:928:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
    EXPORT_SYMBOL_GPL(venus_helper_release_buf_ref);
    ^~~~~~~~~~~~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:916:6: note: previous definition of 'venus_helper_release_buf_ref' was here
    void venus_helper_release_buf_ref(struct venus_inst *inst, unsigned int idx)
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/kernel.h:7,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
   drivers/media/platform/qcom/venus/helpers.c:936:19: error: non-static declaration of 'venus_helper_acquire_buf_ref' follows static declaration
    EXPORT_SYMBOL_GPL(venus_helper_acquire_buf_ref);
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:79:21: note: in definition of macro '___EXPORT_SYMBOL'
     extern typeof(sym) sym;      \
                        ^~~
   drivers/media/platform/qcom/venus/helpers.c:936:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
    EXPORT_SYMBOL_GPL(venus_helper_acquire_buf_ref);
    ^~~~~~~~~~~~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:930:6: note: previous definition of 'venus_helper_acquire_buf_ref' was here
    void venus_helper_acquire_buf_ref(struct vb2_v4l2_buffer *vbuf)
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:938:12: error: invalid storage class for function 'is_buf_refed'
    static int is_buf_refed(struct venus_inst *inst, struct vb2_v4l2_buffer *vbuf)
               ^~~~~~~~~~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/kernel.h:7,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
>> drivers/media/platform/qcom/venus/helpers.c:961:19: error: non-static declaration of 'venus_helper_find_buf' follows static declaration
    EXPORT_SYMBOL_GPL(venus_helper_find_buf);
                      ^~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:79:21: note: in definition of macro '___EXPORT_SYMBOL'
     extern typeof(sym) sym;      \
                        ^~~
   drivers/media/platform/qcom/venus/helpers.c:961:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
    EXPORT_SYMBOL_GPL(venus_helper_find_buf);
    ^~~~~~~~~~~~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:952:1: note: previous definition of 'venus_helper_find_buf' was here
    venus_helper_find_buf(struct venus_inst *inst, unsigned int type, u32 idx)
    ^~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/kernel.h:7,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
   drivers/media/platform/qcom/venus/helpers.c:982:19: error: non-static declaration of 'venus_helper_vb2_buf_init' follows static declaration
    EXPORT_SYMBOL_GPL(venus_helper_vb2_buf_init);
                      ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:79:21: note: in definition of macro '___EXPORT_SYMBOL'
     extern typeof(sym) sym;      \
                        ^~~
   drivers/media/platform/qcom/venus/helpers.c:982:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
    EXPORT_SYMBOL_GPL(venus_helper_vb2_buf_init);
    ^~~~~~~~~~~~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:963:5: note: previous definition of 'venus_helper_vb2_buf_init' was here
    int venus_helper_vb2_buf_init(struct vb2_buffer *vb)
        ^~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/kernel.h:7,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
>> drivers/media/platform/qcom/venus/helpers.c:998:19: error: non-static declaration of 'venus_helper_vb2_buf_prepare' follows static declaration
    EXPORT_SYMBOL_GPL(venus_helper_vb2_buf_prepare);
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:79:21: note: in definition of macro '___EXPORT_SYMBOL'
     extern typeof(sym) sym;      \
                        ^~~
   drivers/media/platform/qcom/venus/helpers.c:998:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
    EXPORT_SYMBOL_GPL(venus_helper_vb2_buf_prepare);
    ^~~~~~~~~~~~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:984:5: note: previous definition of 'venus_helper_vb2_buf_prepare' was here
    int venus_helper_vb2_buf_prepare(struct vb2_buffer *vb)
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/kernel.h:7,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
   drivers/media/platform/qcom/venus/helpers.c:1025:19: error: non-static declaration of 'venus_helper_vb2_buf_queue' follows static declaration
    EXPORT_SYMBOL_GPL(venus_helper_vb2_buf_queue);
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:79:21: note: in definition of macro '___EXPORT_SYMBOL'
     extern typeof(sym) sym;      \
                        ^~~
   drivers/media/platform/qcom/venus/helpers.c:1025:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
    EXPORT_SYMBOL_GPL(venus_helper_vb2_buf_queue);
    ^~~~~~~~~~~~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:1000:6: note: previous definition of 'venus_helper_vb2_buf_queue' was here
    void venus_helper_vb2_buf_queue(struct vb2_buffer *vb)
         ^~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/kernel.h:7,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
>> drivers/media/platform/qcom/venus/helpers.c:1037:19: error: non-static declaration of 'venus_helper_buffers_done' follows static declaration
    EXPORT_SYMBOL_GPL(venus_helper_buffers_done);
                      ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:79:21: note: in definition of macro '___EXPORT_SYMBOL'
     extern typeof(sym) sym;      \
                        ^~~
   drivers/media/platform/qcom/venus/helpers.c:1037:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
    EXPORT_SYMBOL_GPL(venus_helper_buffers_done);
    ^~~~~~~~~~~~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:1027:6: note: previous definition of 'venus_helper_buffers_done' was here
    void venus_helper_buffers_done(struct venus_inst *inst,
         ^~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/kernel.h:7,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
   drivers/media/platform/qcom/venus/helpers.c:1075:19: error: non-static declaration of 'venus_helper_vb2_stop_streaming' follows static declaration
    EXPORT_SYMBOL_GPL(venus_helper_vb2_stop_streaming);
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:79:21: note: in definition of macro '___EXPORT_SYMBOL'
     extern typeof(sym) sym;      \
                        ^~~
   drivers/media/platform/qcom/venus/helpers.c:1075:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
    EXPORT_SYMBOL_GPL(venus_helper_vb2_stop_streaming);
    ^~~~~~~~~~~~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:1039:6: note: previous definition of 'venus_helper_vb2_stop_streaming' was here
    void venus_helper_vb2_stop_streaming(struct vb2_queue *q)
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/kernel.h:7,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
>> drivers/media/platform/qcom/venus/helpers.c:1116:19: error: non-static declaration of 'venus_helper_vb2_start_streaming' follows static declaration
    EXPORT_SYMBOL_GPL(venus_helper_vb2_start_streaming);
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:79:21: note: in definition of macro '___EXPORT_SYMBOL'
     extern typeof(sym) sym;      \
                        ^~~
   drivers/media/platform/qcom/venus/helpers.c:1116:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
    EXPORT_SYMBOL_GPL(venus_helper_vb2_start_streaming);
    ^~~~~~~~~~~~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:1077:5: note: previous definition of 'venus_helper_vb2_start_streaming' was here
    int venus_helper_vb2_start_streaming(struct venus_inst *inst)
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/kernel.h:7,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
>> drivers/media/platform/qcom/venus/helpers.c:1141:19: error: non-static declaration of 'venus_helper_m2m_device_run' follows static declaration
    EXPORT_SYMBOL_GPL(venus_helper_m2m_device_run);
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:79:21: note: in definition of macro '___EXPORT_SYMBOL'
     extern typeof(sym) sym;      \
                        ^~~
   drivers/media/platform/qcom/venus/helpers.c:1141:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
    EXPORT_SYMBOL_GPL(venus_helper_m2m_device_run);
    ^~~~~~~~~~~~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:1118:6: note: previous definition of 'venus_helper_m2m_device_run' was here
    void venus_helper_m2m_device_run(void *priv)
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/kernel.h:7,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
>> drivers/media/platform/qcom/venus/helpers.c:1149:19: error: non-static declaration of 'venus_helper_m2m_job_abort' follows static declaration
    EXPORT_SYMBOL_GPL(venus_helper_m2m_job_abort);
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:79:21: note: in definition of macro '___EXPORT_SYMBOL'
     extern typeof(sym) sym;      \
                        ^~~
   drivers/media/platform/qcom/venus/helpers.c:1149:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
    EXPORT_SYMBOL_GPL(venus_helper_m2m_job_abort);
    ^~~~~~~~~~~~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:1143:6: note: previous definition of 'venus_helper_m2m_job_abort' was here
    void venus_helper_m2m_job_abort(void *priv)
         ^~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/kernel.h:7,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
   drivers/media/platform/qcom/venus/helpers.c:1159:19: error: non-static declaration of 'venus_helper_init_instance' follows static declaration
    EXPORT_SYMBOL_GPL(venus_helper_init_instance);
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:79:21: note: in definition of macro '___EXPORT_SYMBOL'
     extern typeof(sym) sym;      \
                        ^~~
   drivers/media/platform/qcom/venus/helpers.c:1159:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
    EXPORT_SYMBOL_GPL(venus_helper_init_instance);
    ^~~~~~~~~~~~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:1151:6: note: previous definition of 'venus_helper_init_instance' was here
    void venus_helper_init_instance(struct venus_inst *inst)
         ^~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:1161:13: error: invalid storage class for function 'find_fmt_from_caps'
    static bool find_fmt_from_caps(struct venus_caps *caps, u32 buftype, u32 fmt)
                ^~~~~~~~~~~~~~~~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/kernel.h:7,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
>> drivers/media/platform/qcom/venus/helpers.c:1220:19: error: non-static declaration of 'venus_helper_get_out_fmts' follows static declaration
    EXPORT_SYMBOL_GPL(venus_helper_get_out_fmts);
                      ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:79:21: note: in definition of macro '___EXPORT_SYMBOL'
     extern typeof(sym) sym;      \
                        ^~~
   drivers/media/platform/qcom/venus/helpers.c:1220:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
    EXPORT_SYMBOL_GPL(venus_helper_get_out_fmts);
    ^~~~~~~~~~~~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:1174:5: note: previous definition of 'venus_helper_get_out_fmts' was here
    int venus_helper_get_out_fmts(struct venus_inst *inst, u32 v4l2_fmt,
        ^~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/kernel.h:7,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
>> drivers/media/platform/qcom/venus/helpers.c:1269:19: error: non-static declaration of 'venus_helper_power_enable' follows static declaration
    EXPORT_SYMBOL_GPL(venus_helper_power_enable);
                      ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:79:21: note: in definition of macro '___EXPORT_SYMBOL'
     extern typeof(sym) sym;      \
                        ^~~
   drivers/media/platform/qcom/venus/helpers.c:1269:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
    EXPORT_SYMBOL_GPL(venus_helper_power_enable);
    ^~~~~~~~~~~~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:1222:5: note: previous definition of 'venus_helper_power_enable' was here
    int venus_helper_power_enable(struct venus_core *core, u32 session_type,
        ^~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/kernel.h:7,
                    from include/linux/clk.h:16,
                    from drivers/media/platform/qcom/venus/helpers.c:15:
>> include/linux/export.h:67:22: error: expected declaration or statement at end of input
     static const struct kernel_symbol __ksymtab_##sym  \
                         ^~~~~~~~~~~~~
   include/linux/export.h:84:2: note: in expansion of macro '__KSYMTAB_ENTRY'
     __KSYMTAB_ENTRY(sym, sec)
     ^~~~~~~~~~~~~~~
   include/linux/export.h:120:25: note: in expansion of macro '___EXPORT_SYMBOL'
    #define __EXPORT_SYMBOL ___EXPORT_SYMBOL
                            ^~~~~~~~~~~~~~~~
   include/linux/export.h:127:2: note: in expansion of macro '__EXPORT_SYMBOL'
     __EXPORT_SYMBOL(sym, "_gpl")
     ^~~~~~~~~~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:1269:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
    EXPORT_SYMBOL_GPL(venus_helper_power_enable);
    ^~~~~~~~~~~~~~~~~
   include/linux/export.h:67:22: warning: control reaches end of non-void function [-Wreturn-type]
     static const struct kernel_symbol __ksymtab_##sym  \
                         ^~~~~~~~~~~~~
   include/linux/export.h:84:2: note: in expansion of macro '__KSYMTAB_ENTRY'
     __KSYMTAB_ENTRY(sym, sec)
     ^~~~~~~~~~~~~~~
   include/linux/export.h:120:25: note: in expansion of macro '___EXPORT_SYMBOL'
    #define __EXPORT_SYMBOL ___EXPORT_SYMBOL
                            ^~~~~~~~~~~~~~~~
   include/linux/export.h:127:2: note: in expansion of macro '__EXPORT_SYMBOL'
     __EXPORT_SYMBOL(sym, "_gpl")
     ^~~~~~~~~~~~~~~
   drivers/media/platform/qcom/venus/helpers.c:1269:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
    EXPORT_SYMBOL_GPL(venus_helper_power_enable);
    ^~~~~~~~~~~~~~~~~
..

vim +78 drivers/media/platform/qcom/venus/helpers.c

  > 15	#include <linux/clk.h>
    16	#include <linux/iopoll.h>
    17	#include <linux/list.h>
    18	#include <linux/mutex.h>
    19	#include <linux/pm_runtime.h>
    20	#include <linux/slab.h>
    21	#include <media/videobuf2-dma-sg.h>
    22	#include <media/v4l2-mem2mem.h>
    23	#include <asm/div64.h>
    24	
    25	#include "core.h"
    26	#include "helpers.h"
    27	#include "hfi_helper.h"
    28	#include "hfi_venus_io.h"
    29	
    30	struct intbuf {
    31		struct list_head list;
    32		u32 type;
    33		size_t size;
    34		void *va;
    35		dma_addr_t da;
    36		unsigned long attrs;
    37	};
    38	
    39	bool venus_helper_check_codec(struct venus_inst *inst, u32 v4l2_pixfmt)
    40	{
    41		struct venus_core *core = inst->core;
    42		u32 session_type = inst->session_type;
    43		u32 codec;
    44	
    45		switch (v4l2_pixfmt) {
    46		case V4L2_PIX_FMT_H264:
    47			codec = HFI_VIDEO_CODEC_H264;
    48			break;
    49		case V4L2_PIX_FMT_H263:
    50			codec = HFI_VIDEO_CODEC_H263;
    51			break;
    52		case V4L2_PIX_FMT_MPEG1:
    53			codec = HFI_VIDEO_CODEC_MPEG1;
    54			break;
    55		case V4L2_PIX_FMT_MPEG2:
    56			codec = HFI_VIDEO_CODEC_MPEG2;
    57			break;
    58		case V4L2_PIX_FMT_MPEG4:
    59			codec = HFI_VIDEO_CODEC_MPEG4;
    60			break;
    61		case V4L2_PIX_FMT_VC1_ANNEX_G:
    62		case V4L2_PIX_FMT_VC1_ANNEX_L:
    63			codec = HFI_VIDEO_CODEC_VC1;
    64			break;
    65		case V4L2_PIX_FMT_VP8:
    66			codec = HFI_VIDEO_CODEC_VP8;
    67			break;
    68		case V4L2_PIX_FMT_VP9:
    69			codec = HFI_VIDEO_CODEC_VP9;
    70			break;
    71		case V4L2_PIX_FMT_XVID:
    72			codec = HFI_VIDEO_CODEC_DIVX;
    73			break;
    74		case V4L2_PIX_FMT_HEVC:
    75			codec = HFI_VIDEO_CODEC_HEVC;
    76			break;
    77		default:
  > 78			dprintk(WARN, "Unknown format:%x\n", pixfmt);
    79			return false;
    80		}
    81	
    82		if (session_type == VIDC_SESSION_TYPE_ENC && core->enc_codecs & codec)
    83			return true;
    84	
    85		if (session_type == VIDC_SESSION_TYPE_DEC && core->dec_codecs & codec)
    86			return true;
    87	
    88		return false;
    89	}
    90	EXPORT_SYMBOL_GPL(venus_helper_check_codec);
    91	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--mYCpIKhGyMATD0i+
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
/wDLudFEXIMDAA==

--mYCpIKhGyMATD0i+--
