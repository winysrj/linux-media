Return-Path: <SRS0=g7QC=O6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7427C43387
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 04:57:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FA80218E0
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 04:57:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389041AbeLUE5r (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 20 Dec 2018 23:57:47 -0500
Received: from mga04.intel.com ([192.55.52.120]:11409 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731567AbeLUE5r (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Dec 2018 23:57:47 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2018 20:57:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,380,1539673200"; 
   d="gz'50?scan'50,208,50";a="120056654"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 20 Dec 2018 20:57:43 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1gaCsZ-0002DI-6T; Fri, 21 Dec 2018 12:57:43 +0800
Date:   Fri, 21 Dec 2018 12:57:11 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Brad Love <brad@nextdimension.cc>
Cc:     kbuild-all@01.org, linux-media@vger.kernel.org, mchehab@kernel.org,
        Brad Love <brad@nextdimension.cc>
Subject: Re: [PATCH 4/4] pvrusb2: Add Hauppauge HVR1955/1975 devices
Message-ID: <201812211206.NjOwQAio%fengguang.wu@intel.com>
References: <1545343031-20935-5-git-send-email-brad@nextdimension.cc>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <1545343031-20935-5-git-send-email-brad@nextdimension.cc>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Brad,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linuxtv-media/master]
[also build test ERROR on v4.20-rc7 next-20181220]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Brad-Love/Add-Hauppauge-HVR1955-1975-devices/20181221-122142
base:   git://linuxtv.org/media_tree.git master
config: x86_64-randconfig-x018-201850 (attached as .config)
compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All error/warnings (new ones prefixed by >>):

   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:483:38: warning: 'struct pvr2_dvb_adapter' declared inside parameter list will not be visible outside of this definition or declaration
    static int pvr2_si2157_attach(struct pvr2_dvb_adapter *adap)
                                         ^~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c: In function 'pvr2_si2157_attach':
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:485:9: error: variable 'si2157_config' has initializer but incomplete type
     struct si2157_config si2157_config = {};
            ^~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:485:23: error: storage size of 'si2157_config' isn't known
     struct si2157_config si2157_config = {};
                          ^~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:488:25: error: dereferencing pointer to incomplete type 'struct pvr2_dvb_adapter'
     si2157_config.fe = adap->fe[0];
                            ^~
>> drivers/media/usb/pvrusb2/pvrusb2-devattr.c:490:27: error: implicit declaration of function 'dvb_module_probe'; did you mean 'module_put'? [-Werror=implicit-function-declaration]
     adap->i2c_client_tuner = dvb_module_probe("si2157", "si2177",
                              ^~~~~~~~~~~~~~~~
                              module_put
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:485:23: warning: unused variable 'si2157_config' [-Wunused-variable]
     struct si2157_config si2157_config = {};
                          ^~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c: At top level:
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:505:38: warning: 'struct pvr2_dvb_adapter' declared inside parameter list will not be visible outside of this definition or declaration
    static int pvr2_si2157_attach(struct pvr2_dvb_adapter *adap);
                                         ^~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:505:12: error: conflicting types for 'pvr2_si2157_attach'
    static int pvr2_si2157_attach(struct pvr2_dvb_adapter *adap);
               ^~~~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:483:12: note: previous definition of 'pvr2_si2157_attach' was here
    static int pvr2_si2157_attach(struct pvr2_dvb_adapter *adap)
               ^~~~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:506:39: warning: 'struct pvr2_dvb_adapter' declared inside parameter list will not be visible outside of this definition or declaration
    static int pvr2_dual_fe_attach(struct pvr2_dvb_adapter *adap);
                                          ^~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:507:41: warning: 'struct pvr2_dvb_adapter' declared inside parameter list will not be visible outside of this definition or declaration
    static int pvr2_lgdt3306a_attach(struct pvr2_dvb_adapter *adap);
                                            ^~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:509:21: error: variable 'pvr2_160000_dvb_props' has initializer but incomplete type
    static const struct pvr2_dvb_props pvr2_160000_dvb_props = {
                        ^~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:510:3: error: 'const struct pvr2_dvb_props' has no member named 'frontend_attach'
     .frontend_attach = pvr2_dual_fe_attach,
      ^~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:510:21: warning: excess elements in struct initializer
     .frontend_attach = pvr2_dual_fe_attach,
                        ^~~~~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:510:21: note: (near initialization for 'pvr2_160000_dvb_props')
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:511:3: error: 'const struct pvr2_dvb_props' has no member named 'tuner_attach'
     .tuner_attach    = pvr2_si2157_attach,
      ^~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:511:21: warning: excess elements in struct initializer
     .tuner_attach    = pvr2_si2157_attach,
                        ^~~~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:511:21: note: (near initialization for 'pvr2_160000_dvb_props')
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:540:21: error: variable 'pvr2_160111_dvb_props' has initializer but incomplete type
    static const struct pvr2_dvb_props pvr2_160111_dvb_props = {
                        ^~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:541:3: error: 'const struct pvr2_dvb_props' has no member named 'frontend_attach'
     .frontend_attach = pvr2_lgdt3306a_attach,
      ^~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:541:21: warning: excess elements in struct initializer
     .frontend_attach = pvr2_lgdt3306a_attach,
                        ^~~~~~~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:541:21: note: (near initialization for 'pvr2_160111_dvb_props')
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:542:3: error: 'const struct pvr2_dvb_props' has no member named 'tuner_attach'
     .tuner_attach    = pvr2_si2157_attach,
      ^~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:542:21: warning: excess elements in struct initializer
     .tuner_attach    = pvr2_si2157_attach,
                        ^~~~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:542:21: note: (near initialization for 'pvr2_160111_dvb_props')
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:571:38: warning: 'struct pvr2_dvb_adapter' declared inside parameter list will not be visible outside of this definition or declaration
    static int pvr2_si2168_attach(struct pvr2_dvb_adapter *adap)
                                         ^~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c: In function 'pvr2_si2168_attach':
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:573:9: error: variable 'si2168_config' has initializer but incomplete type
     struct si2168_config si2168_config = {};
            ^~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:573:23: error: storage size of 'si2168_config' isn't known
     struct si2168_config si2168_config = {};
                          ^~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:578:26: error: dereferencing pointer to incomplete type 'struct pvr2_dvb_adapter'
     si2168_config.fe = &adap->fe[1];
                             ^~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:580:26: error: 'SI2168_TS_PARALLEL' undeclared (first use in this function)
     si2168_config.ts_mode = SI2168_TS_PARALLEL; /*2, 1-serial, 2-parallel.*/
                             ^~~~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:580:26: note: each undeclared identifier is reported only once for each function it appears in
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:573:23: warning: unused variable 'si2168_config' [-Wunused-variable]
     struct si2168_config si2168_config = {};
                          ^~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c: At top level:
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:595:41: warning: 'struct pvr2_dvb_adapter' declared inside parameter list will not be visible outside of this definition or declaration
    static int pvr2_lgdt3306a_attach(struct pvr2_dvb_adapter *adap)
                                            ^~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:595:12: error: conflicting types for 'pvr2_lgdt3306a_attach'
    static int pvr2_lgdt3306a_attach(struct pvr2_dvb_adapter *adap)
               ^~~~~~~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:507:12: note: previous declaration of 'pvr2_lgdt3306a_attach' was here
    static int pvr2_lgdt3306a_attach(struct pvr2_dvb_adapter *adap);
               ^~~~~~~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c: In function 'pvr2_lgdt3306a_attach':
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:597:26: error: storage size of 'lgdt3306a_config' isn't known
     struct lgdt3306a_config lgdt3306a_config;
                             ^~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:603:29: error: dereferencing pointer to incomplete type 'struct pvr2_dvb_adapter'
     lgdt3306a_config.fe = &adap->fe[0];
                                ^~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:609:31: error: 'LGDT3306A_MPEG_PARALLEL' undeclared (first use in this function)
     lgdt3306a_config.mpeg_mode = LGDT3306A_MPEG_PARALLEL;
                                  ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:610:32: error: 'LGDT3306A_TPCLK_FALLING_EDGE' undeclared (first use in this function); did you mean 'LGDT3306A_MPEG_PARALLEL'?
     lgdt3306a_config.tpclk_edge = LGDT3306A_TPCLK_FALLING_EDGE;
                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                   LGDT3306A_MPEG_PARALLEL
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:611:38: error: 'LGDT3306A_TP_VALID_LOW' undeclared (first use in this function); did you mean 'LGDT3306A_MPEG_PARALLEL'?
     lgdt3306a_config.tpvalid_polarity = LGDT3306A_TP_VALID_LOW;
                                         ^~~~~~~~~~~~~~~~~~~~~~
                                         LGDT3306A_MPEG_PARALLEL
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:612:31: warning: left-hand operand of comma expression has no effect [-Wunused-value]
     lgdt3306a_config.xtalMHz = 25, /* demod clock MHz; 24/25 supported */
                                  ^
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:597:26: warning: unused variable 'lgdt3306a_config' [-Wunused-variable]
     struct lgdt3306a_config lgdt3306a_config;
                             ^~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c: At top level:
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:624:39: warning: 'struct pvr2_dvb_adapter' declared inside parameter list will not be visible outside of this definition or declaration
    static int pvr2_dual_fe_attach(struct pvr2_dvb_adapter *adap)
                                          ^~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:624:12: error: conflicting types for 'pvr2_dual_fe_attach'
    static int pvr2_dual_fe_attach(struct pvr2_dvb_adapter *adap)
               ^~~~~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:506:12: note: previous declaration of 'pvr2_dual_fe_attach' was here
    static int pvr2_dual_fe_attach(struct pvr2_dvb_adapter *adap);
               ^~~~~~~~~~~~~~~~~~~
   In file included from include/linux/string.h:6:0,
                    from include/linux/uuid.h:20,
                    from include/linux/mod_devicetable.h:13,
                    from drivers/media/usb/pvrusb2/pvrusb2-devattr.h:19,
                    from drivers/media/usb/pvrusb2/pvrusb2-devattr.c:25:
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c: In function 'pvr2_dual_fe_attach':
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:628:28: error: passing argument 1 of 'pvr2_lgdt3306a_attach' from incompatible pointer type [-Werror=incompatible-pointer-types]
     if (pvr2_lgdt3306a_attach(adap) != 0)
                               ^
   include/linux/compiler.h:58:30: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                 ^~~~
>> drivers/media/usb/pvrusb2/pvrusb2-devattr.c:628:2: note: in expansion of macro 'if'
     if (pvr2_lgdt3306a_attach(adap) != 0)
     ^~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:595:12: note: expected 'struct pvr2_dvb_adapter *' but argument is of type 'struct pvr2_dvb_adapter *'
    static int pvr2_lgdt3306a_attach(struct pvr2_dvb_adapter *adap)
               ^~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/string.h:6:0,
                    from include/linux/uuid.h:20,
                    from include/linux/mod_devicetable.h:13,
                    from drivers/media/usb/pvrusb2/pvrusb2-devattr.h:19,
                    from drivers/media/usb/pvrusb2/pvrusb2-devattr.c:25:
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:628:28: error: passing argument 1 of 'pvr2_lgdt3306a_attach' from incompatible pointer type [-Werror=incompatible-pointer-types]
     if (pvr2_lgdt3306a_attach(adap) != 0)
                               ^
   include/linux/compiler.h:58:42: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                             ^~~~
>> drivers/media/usb/pvrusb2/pvrusb2-devattr.c:628:2: note: in expansion of macro 'if'
     if (pvr2_lgdt3306a_attach(adap) != 0)
     ^~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:595:12: note: expected 'struct pvr2_dvb_adapter *' but argument is of type 'struct pvr2_dvb_adapter *'
    static int pvr2_lgdt3306a_attach(struct pvr2_dvb_adapter *adap)
               ^~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/string.h:6:0,
                    from include/linux/uuid.h:20,
                    from include/linux/mod_devicetable.h:13,
                    from drivers/media/usb/pvrusb2/pvrusb2-devattr.h:19,
                    from drivers/media/usb/pvrusb2/pvrusb2-devattr.c:25:
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:628:28: error: passing argument 1 of 'pvr2_lgdt3306a_attach' from incompatible pointer type [-Werror=incompatible-pointer-types]
     if (pvr2_lgdt3306a_attach(adap) != 0)
                               ^
   include/linux/compiler.h:69:16: note: in definition of macro '__trace_if'
      ______r = !!(cond);     \
                   ^~~~
>> drivers/media/usb/pvrusb2/pvrusb2-devattr.c:628:2: note: in expansion of macro 'if'
     if (pvr2_lgdt3306a_attach(adap) != 0)
     ^~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:595:12: note: expected 'struct pvr2_dvb_adapter *' but argument is of type 'struct pvr2_dvb_adapter *'
    static int pvr2_lgdt3306a_attach(struct pvr2_dvb_adapter *adap)
               ^~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/string.h:6:0,
                    from include/linux/uuid.h:20,
                    from include/linux/mod_devicetable.h:13,
                    from drivers/media/usb/pvrusb2/pvrusb2-devattr.h:19,
                    from drivers/media/usb/pvrusb2/pvrusb2-devattr.c:25:
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:631:25: error: passing argument 1 of 'pvr2_si2168_attach' from incompatible pointer type [-Werror=incompatible-pointer-types]
     if (pvr2_si2168_attach(adap) != 0) {
                            ^
   include/linux/compiler.h:58:30: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                 ^~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:631:2: note: in expansion of macro 'if'
     if (pvr2_si2168_attach(adap) != 0) {
     ^~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:571:12: note: expected 'struct pvr2_dvb_adapter *' but argument is of type 'struct pvr2_dvb_adapter *'
    static int pvr2_si2168_attach(struct pvr2_dvb_adapter *adap)
               ^~~~~~~~~~~~~~~~~~
   In file included from include/linux/string.h:6:0,
                    from include/linux/uuid.h:20,
                    from include/linux/mod_devicetable.h:13,
                    from drivers/media/usb/pvrusb2/pvrusb2-devattr.h:19,
                    from drivers/media/usb/pvrusb2/pvrusb2-devattr.c:25:
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:631:25: error: passing argument 1 of 'pvr2_si2168_attach' from incompatible pointer type [-Werror=incompatible-pointer-types]
     if (pvr2_si2168_attach(adap) != 0) {
                            ^
   include/linux/compiler.h:58:42: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                             ^~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:631:2: note: in expansion of macro 'if'
     if (pvr2_si2168_attach(adap) != 0) {
     ^~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:571:12: note: expected 'struct pvr2_dvb_adapter *' but argument is of type 'struct pvr2_dvb_adapter *'
    static int pvr2_si2168_attach(struct pvr2_dvb_adapter *adap)
               ^~~~~~~~~~~~~~~~~~
   In file included from include/linux/string.h:6:0,
                    from include/linux/uuid.h:20,
                    from include/linux/mod_devicetable.h:13,
                    from drivers/media/usb/pvrusb2/pvrusb2-devattr.h:19,
                    from drivers/media/usb/pvrusb2/pvrusb2-devattr.c:25:
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:631:25: error: passing argument 1 of 'pvr2_si2168_attach' from incompatible pointer type [-Werror=incompatible-pointer-types]
     if (pvr2_si2168_attach(adap) != 0) {
                            ^
   include/linux/compiler.h:69:16: note: in definition of macro '__trace_if'
      ______r = !!(cond);     \
                   ^~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:631:2: note: in expansion of macro 'if'
     if (pvr2_si2168_attach(adap) != 0) {
     ^~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:571:12: note: expected 'struct pvr2_dvb_adapter *' but argument is of type 'struct pvr2_dvb_adapter *'
    static int pvr2_si2168_attach(struct pvr2_dvb_adapter *adap)
               ^~~~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:632:3: error: implicit declaration of function 'dvb_module_release'; did you mean 'complete_release'? [-Werror=implicit-function-declaration]
      dvb_module_release(adap->i2c_client_demod[0]);
      ^~~~~~~~~~~~~~~~~~
      complete_release
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:632:26: error: dereferencing pointer to incomplete type 'struct pvr2_dvb_adapter'
      dvb_module_release(adap->i2c_client_demod[0]);
                             ^~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c: At top level:
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:509:36: error: storage size of 'pvr2_160000_dvb_props' isn't known
    static const struct pvr2_dvb_props pvr2_160000_dvb_props = {
                                       ^~~~~~~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:540:36: error: storage size of 'pvr2_160111_dvb_props' isn't known
    static const struct pvr2_dvb_props pvr2_160111_dvb_props = {
                                       ^~~~~~~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:505:12: warning: 'pvr2_si2157_attach' used but never defined
    static int pvr2_si2157_attach(struct pvr2_dvb_adapter *adap);
               ^~~~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:506:12: warning: 'pvr2_dual_fe_attach' used but never defined
    static int pvr2_dual_fe_attach(struct pvr2_dvb_adapter *adap);
               ^~~~~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:507:12: warning: 'pvr2_lgdt3306a_attach' used but never defined
    static int pvr2_lgdt3306a_attach(struct pvr2_dvb_adapter *adap);
               ^~~~~~~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:624:12: warning: 'pvr2_dual_fe_attach' defined but not used [-Wunused-function]
    static int pvr2_dual_fe_attach(struct pvr2_dvb_adapter *adap)
               ^~~~~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:483:12: warning: 'pvr2_si2157_attach' defined but not used [-Wunused-function]
    static int pvr2_si2157_attach(struct pvr2_dvb_adapter *adap)
               ^~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors

vim +490 drivers/media/usb/pvrusb2/pvrusb2-devattr.c

   482	
   483	static int pvr2_si2157_attach(struct pvr2_dvb_adapter *adap)
   484	{
 > 485		struct si2157_config si2157_config = {};
   486	
   487		si2157_config.inversion = 1;
   488		si2157_config.fe = adap->fe[0];
   489	
 > 490		adap->i2c_client_tuner = dvb_module_probe("si2157", "si2177",
   491							&adap->channel.hdw->i2c_adap,
   492							0x60, &si2157_config);
   493	
   494		if (!adap->i2c_client_tuner)
   495			return -ENODEV;
   496	
   497		return 0;
   498	}
   499	
   500	#define PVR2_FIRMWARE_160xxx "v4l-pvrusb2-160xxx-01.fw"
   501	static const char *pvr2_fw1_names_160xxx[] = {
   502			PVR2_FIRMWARE_160xxx,
   503	};
   504	
   505	static int pvr2_si2157_attach(struct pvr2_dvb_adapter *adap);
   506	static int pvr2_dual_fe_attach(struct pvr2_dvb_adapter *adap);
   507	static int pvr2_lgdt3306a_attach(struct pvr2_dvb_adapter *adap);
   508	
   509	static const struct pvr2_dvb_props pvr2_160000_dvb_props = {
   510		.frontend_attach = pvr2_dual_fe_attach,
   511		.tuner_attach    = pvr2_si2157_attach,
   512	};
   513	static const struct pvr2_device_client_desc pvr2_cli_160000[] = {
   514		{ .module_id = PVR2_CLIENT_ID_CX25840 },
   515	};
   516	static const struct pvr2_device_desc pvr2_device_160000 = {
   517			.description = "WinTV HVR-1975 Model 160000",
   518			.shortname = "160000",
   519			.client_table.lst = pvr2_cli_160000,
   520			.client_table.cnt = ARRAY_SIZE(pvr2_cli_160000),
   521			.fx2_firmware.lst = pvr2_fw1_names_160xxx,
   522			.fx2_firmware.cnt = ARRAY_SIZE(pvr2_fw1_names_160xxx),
   523			.default_tuner_type = TUNER_ABSENT,
   524			.flag_has_cx25840 = !0,
   525			.flag_has_hauppauge_rom = !0,
   526			.flag_has_analogtuner = !0,
   527			.flag_has_composite = !0,
   528			.flag_has_svideo = !0,
   529			.flag_fx2_16kb = !0,
   530			.signal_routing_scheme = PVR2_ROUTING_SCHEME_HAUPPAUGE,
   531			.digital_control_scheme = PVR2_DIGITAL_SCHEME_HAUPPAUGE,
   532			.default_std_mask = V4L2_STD_NTSC_M,
   533			.led_scheme = PVR2_LED_SCHEME_HAUPPAUGE,
   534			.ir_scheme = PVR2_IR_SCHEME_ZILOG,
   535	#ifdef CONFIG_VIDEO_PVRUSB2_DVB
   536			.dvb_props = &pvr2_160000_dvb_props,
   537	#endif
   538	};
   539	
   540	static const struct pvr2_dvb_props pvr2_160111_dvb_props = {
   541		.frontend_attach = pvr2_lgdt3306a_attach,
   542		.tuner_attach    = pvr2_si2157_attach,
   543	};
   544	static const struct pvr2_device_client_desc pvr2_cli_160111[] = {
   545		{ .module_id = PVR2_CLIENT_ID_CX25840 },
   546	};
   547	static const struct pvr2_device_desc pvr2_device_160111 = {
   548			.description = "WinTV HVR-1955 Model 160111",
   549			.shortname = "160111",
   550			.client_table.lst = pvr2_cli_160111,
   551			.client_table.cnt = ARRAY_SIZE(pvr2_cli_160111),
   552			.fx2_firmware.lst = pvr2_fw1_names_160xxx,
   553			.fx2_firmware.cnt = ARRAY_SIZE(pvr2_fw1_names_160xxx),
   554			.default_tuner_type = TUNER_ABSENT,
   555			.flag_has_cx25840 = !0,
   556			.flag_has_hauppauge_rom = !0,
   557			.flag_has_analogtuner = !0,
   558			.flag_has_composite = !0,
   559			.flag_has_svideo = !0,
   560			.flag_fx2_16kb = !0,
   561			.signal_routing_scheme = PVR2_ROUTING_SCHEME_HAUPPAUGE,
   562			.digital_control_scheme = PVR2_DIGITAL_SCHEME_HAUPPAUGE,
   563			.default_std_mask = V4L2_STD_NTSC_M,
   564			.led_scheme = PVR2_LED_SCHEME_HAUPPAUGE,
   565			.ir_scheme = PVR2_IR_SCHEME_ZILOG,
   566	#ifdef CONFIG_VIDEO_PVRUSB2_DVB
   567			.dvb_props = &pvr2_160111_dvb_props,
   568	#endif
   569	};
   570	
   571	static int pvr2_si2168_attach(struct pvr2_dvb_adapter *adap)
   572	{
   573		struct si2168_config si2168_config = {};
   574		struct i2c_adapter *adapter;
   575	
   576		pr_debug("%s()\n", __func__);
   577	
   578		si2168_config.fe = &adap->fe[1];
   579		si2168_config.i2c_adapter = &adapter;
   580		si2168_config.ts_mode = SI2168_TS_PARALLEL; /*2, 1-serial, 2-parallel.*/
   581		si2168_config.ts_clock_gapped = 1; /*0-disabled, 1-enabled.*/
   582		si2168_config.ts_clock_inv = 0; /*0-not-invert, 1-invert*/
   583		si2168_config.spectral_inversion = 1; /*0-not-invert, 1-invert*/
   584	
   585		adap->i2c_client_demod[1] = dvb_module_probe("si2168", NULL,
   586							&adap->channel.hdw->i2c_adap,
   587							0x64, &si2168_config);
   588	
   589		if (!adap->i2c_client_demod[1])
   590			return -ENODEV;
   591	
   592		return 0;
   593	}
   594	
   595	static int pvr2_lgdt3306a_attach(struct pvr2_dvb_adapter *adap)
   596	{
   597		struct lgdt3306a_config lgdt3306a_config;
   598		struct i2c_adapter *adapter;
   599	
   600		pr_debug("%s()\n", __func__);
   601	
   602		/* attach demod */
   603		lgdt3306a_config.fe = &adap->fe[0];
   604		lgdt3306a_config.i2c_adapter = &adapter;
   605		lgdt3306a_config.deny_i2c_rptr = 1;
   606		lgdt3306a_config.spectral_inversion = 1;
   607		lgdt3306a_config.qam_if_khz = 4000;
   608		lgdt3306a_config.vsb_if_khz = 3250;
   609		lgdt3306a_config.mpeg_mode = LGDT3306A_MPEG_PARALLEL;
   610		lgdt3306a_config.tpclk_edge = LGDT3306A_TPCLK_FALLING_EDGE;
   611		lgdt3306a_config.tpvalid_polarity = LGDT3306A_TP_VALID_LOW;
   612		lgdt3306a_config.xtalMHz = 25, /* demod clock MHz; 24/25 supported */
   613	
   614		adap->i2c_client_demod[0] = dvb_module_probe("lgdt3306a", NULL,
   615							&adap->channel.hdw->i2c_adap,
   616							0x59, &lgdt3306a_config);
   617	
   618		if (!adap->i2c_client_demod[0])
   619			return -ENODEV;
   620	
   621		return 0;
   622	}
   623	
   624	static int pvr2_dual_fe_attach(struct pvr2_dvb_adapter *adap)
   625	{
   626		pr_debug("%s()\n", __func__);
   627	
 > 628		if (pvr2_lgdt3306a_attach(adap) != 0)
   629			return -ENODEV;
   630	
   631		if (pvr2_si2168_attach(adap) != 0) {
   632			dvb_module_release(adap->i2c_client_demod[0]);
   633			return -ENODEV;
   634		}
   635	
   636		return 0;
   637	}
   638	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--5mCyUwZo2JvN/JJP
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
1uZdH/YBAA==

--5mCyUwZo2JvN/JJP--
