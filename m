Return-Path: <SRS0=g7QC=O6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7253C43387
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 04:56:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52A9D21907
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 04:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387425AbeLUE4q (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 20 Dec 2018 23:56:46 -0500
Received: from mga17.intel.com ([192.55.52.151]:51660 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731567AbeLUE4q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Dec 2018 23:56:46 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2018 20:56:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,380,1539673200"; 
   d="gz'50?scan'50,208,50";a="305611263"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 20 Dec 2018 20:56:43 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1gaCrb-000EYC-4c; Fri, 21 Dec 2018 12:56:43 +0800
Date:   Fri, 21 Dec 2018 12:56:01 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Brad Love <brad@nextdimension.cc>
Cc:     kbuild-all@01.org, linux-media@vger.kernel.org, mchehab@kernel.org,
        Brad Love <brad@nextdimension.cc>
Subject: Re: [PATCH 4/4] pvrusb2: Add Hauppauge HVR1955/1975 devices
Message-ID: <201812211247.eOdnfiVi%fengguang.wu@intel.com>
References: <1545343031-20935-5-git-send-email-brad@nextdimension.cc>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <1545343031-20935-5-git-send-email-brad@nextdimension.cc>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Brad,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linuxtv-media/master]
[also build test ERROR on v4.20-rc7 next-20181220]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Brad-Love/Add-Hauppauge-HVR1955-1975-devices/20181221-122142
base:   git://linuxtv.org/media_tree.git master
config: x86_64-randconfig-x006-201850 (attached as .config)
compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All error/warnings (new ones prefixed by >>):

>> drivers/media/usb/pvrusb2/pvrusb2-devattr.c:483:38: warning: 'struct pvr2_dvb_adapter' declared inside parameter list will not be visible outside of this definition or declaration
    static int pvr2_si2157_attach(struct pvr2_dvb_adapter *adap)
                                         ^~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c: In function 'pvr2_si2157_attach':
>> drivers/media/usb/pvrusb2/pvrusb2-devattr.c:485:9: error: variable 'si2157_config' has initializer but incomplete type
     struct si2157_config si2157_config = {};
            ^~~~~~~~~~~~~
>> drivers/media/usb/pvrusb2/pvrusb2-devattr.c:485:23: error: storage size of 'si2157_config' isn't known
     struct si2157_config si2157_config = {};
                          ^~~~~~~~~~~~~
>> drivers/media/usb/pvrusb2/pvrusb2-devattr.c:488:25: error: dereferencing pointer to incomplete type 'struct pvr2_dvb_adapter'
     si2157_config.fe = adap->fe[0];
                            ^~
>> drivers/media/usb/pvrusb2/pvrusb2-devattr.c:490:27: error: implicit declaration of function 'dvb_module_probe'; did you mean '__module_get'? [-Werror=implicit-function-declaration]
     adap->i2c_client_tuner = dvb_module_probe("si2157", "si2177",
                              ^~~~~~~~~~~~~~~~
                              __module_get
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:485:23: warning: unused variable 'si2157_config' [-Wunused-variable]
     struct si2157_config si2157_config = {};
                          ^~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c: At top level:
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:505:38: warning: 'struct pvr2_dvb_adapter' declared inside parameter list will not be visible outside of this definition or declaration
    static int pvr2_si2157_attach(struct pvr2_dvb_adapter *adap);
                                         ^~~~~~~~~~~~~~~~
>> drivers/media/usb/pvrusb2/pvrusb2-devattr.c:505:12: error: conflicting types for 'pvr2_si2157_attach'
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
>> drivers/media/usb/pvrusb2/pvrusb2-devattr.c:509:21: error: variable 'pvr2_160000_dvb_props' has initializer but incomplete type
    static const struct pvr2_dvb_props pvr2_160000_dvb_props = {
                        ^~~~~~~~~~~~~~
>> drivers/media/usb/pvrusb2/pvrusb2-devattr.c:510:3: error: 'const struct pvr2_dvb_props' has no member named 'frontend_attach'
     .frontend_attach = pvr2_dual_fe_attach,
      ^~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:510:21: warning: excess elements in struct initializer
     .frontend_attach = pvr2_dual_fe_attach,
                        ^~~~~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:510:21: note: (near initialization for 'pvr2_160000_dvb_props')
>> drivers/media/usb/pvrusb2/pvrusb2-devattr.c:511:3: error: 'const struct pvr2_dvb_props' has no member named 'tuner_attach'
     .tuner_attach    = pvr2_si2157_attach,
      ^~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:511:21: warning: excess elements in struct initializer
     .tuner_attach    = pvr2_si2157_attach,
                        ^~~~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:511:21: note: (near initialization for 'pvr2_160000_dvb_props')
>> drivers/media/usb/pvrusb2/pvrusb2-devattr.c:540:21: error: variable 'pvr2_160111_dvb_props' has initializer but incomplete type
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
>> drivers/media/usb/pvrusb2/pvrusb2-devattr.c:573:9: error: variable 'si2168_config' has initializer but incomplete type
     struct si2168_config si2168_config = {};
            ^~~~~~~~~~~~~
>> drivers/media/usb/pvrusb2/pvrusb2-devattr.c:573:23: error: storage size of 'si2168_config' isn't known
     struct si2168_config si2168_config = {};
                          ^~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:578:26: error: dereferencing pointer to incomplete type 'struct pvr2_dvb_adapter'
     si2168_config.fe = &adap->fe[1];
                             ^~
>> drivers/media/usb/pvrusb2/pvrusb2-devattr.c:580:26: error: 'SI2168_TS_PARALLEL' undeclared (first use in this function)
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
>> drivers/media/usb/pvrusb2/pvrusb2-devattr.c:595:12: error: conflicting types for 'pvr2_lgdt3306a_attach'
    static int pvr2_lgdt3306a_attach(struct pvr2_dvb_adapter *adap)
               ^~~~~~~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:507:12: note: previous declaration of 'pvr2_lgdt3306a_attach' was here
    static int pvr2_lgdt3306a_attach(struct pvr2_dvb_adapter *adap);
               ^~~~~~~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c: In function 'pvr2_lgdt3306a_attach':
>> drivers/media/usb/pvrusb2/pvrusb2-devattr.c:597:26: error: storage size of 'lgdt3306a_config' isn't known
     struct lgdt3306a_config lgdt3306a_config;
                             ^~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:603:29: error: dereferencing pointer to incomplete type 'struct pvr2_dvb_adapter'
     lgdt3306a_config.fe = &adap->fe[0];
                                ^~
>> drivers/media/usb/pvrusb2/pvrusb2-devattr.c:609:31: error: 'LGDT3306A_MPEG_PARALLEL' undeclared (first use in this function)
     lgdt3306a_config.mpeg_mode = LGDT3306A_MPEG_PARALLEL;
                                  ^~~~~~~~~~~~~~~~~~~~~~~
>> drivers/media/usb/pvrusb2/pvrusb2-devattr.c:610:32: error: 'LGDT3306A_TPCLK_FALLING_EDGE' undeclared (first use in this function); did you mean 'LGDT3306A_MPEG_PARALLEL'?
     lgdt3306a_config.tpclk_edge = LGDT3306A_TPCLK_FALLING_EDGE;
                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                   LGDT3306A_MPEG_PARALLEL
>> drivers/media/usb/pvrusb2/pvrusb2-devattr.c:611:38: error: 'LGDT3306A_TP_VALID_LOW' undeclared (first use in this function); did you mean 'LGDT3306A_MPEG_PARALLEL'?
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
>> drivers/media/usb/pvrusb2/pvrusb2-devattr.c:624:12: error: conflicting types for 'pvr2_dual_fe_attach'
    static int pvr2_dual_fe_attach(struct pvr2_dvb_adapter *adap)
               ^~~~~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:506:12: note: previous declaration of 'pvr2_dual_fe_attach' was here
    static int pvr2_dual_fe_attach(struct pvr2_dvb_adapter *adap);
               ^~~~~~~~~~~~~~~~~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c: In function 'pvr2_dual_fe_attach':
>> drivers/media/usb/pvrusb2/pvrusb2-devattr.c:628:28: error: passing argument 1 of 'pvr2_lgdt3306a_attach' from incompatible pointer type [-Werror=incompatible-pointer-types]
     if (pvr2_lgdt3306a_attach(adap) != 0)
                               ^~~~
   drivers/media/usb/pvrusb2/pvrusb2-devattr.c:595:12: note: expected 'struct pvr2_dvb_adapter *' but argument is of type 'struct pvr2_dvb_adapter *'
    static int pvr2_lgdt3306a_attach(struct pvr2_dvb_adapter *adap)
               ^~~~~~~~~~~~~~~~~~~~~

vim +/si2157_config +485 drivers/media/usb/pvrusb2/pvrusb2-devattr.c

   482	
 > 483	static int pvr2_si2157_attach(struct pvr2_dvb_adapter *adap)
   484	{
 > 485		struct si2157_config si2157_config = {};
   486	
   487		si2157_config.inversion = 1;
 > 488		si2157_config.fe = adap->fe[0];
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
 > 505	static int pvr2_si2157_attach(struct pvr2_dvb_adapter *adap);
 > 506	static int pvr2_dual_fe_attach(struct pvr2_dvb_adapter *adap);
 > 507	static int pvr2_lgdt3306a_attach(struct pvr2_dvb_adapter *adap);
   508	
 > 509	static const struct pvr2_dvb_props pvr2_160000_dvb_props = {
 > 510		.frontend_attach = pvr2_dual_fe_attach,
 > 511		.tuner_attach    = pvr2_si2157_attach,
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
 > 540	static const struct pvr2_dvb_props pvr2_160111_dvb_props = {
   541		.frontend_attach = pvr2_lgdt3306a_attach,
 > 542		.tuner_attach    = pvr2_si2157_attach,
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
 > 573		struct si2168_config si2168_config = {};
   574		struct i2c_adapter *adapter;
   575	
   576		pr_debug("%s()\n", __func__);
   577	
   578		si2168_config.fe = &adap->fe[1];
   579		si2168_config.i2c_adapter = &adapter;
 > 580		si2168_config.ts_mode = SI2168_TS_PARALLEL; /*2, 1-serial, 2-parallel.*/
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
 > 595	static int pvr2_lgdt3306a_attach(struct pvr2_dvb_adapter *adap)
   596	{
 > 597		struct lgdt3306a_config lgdt3306a_config;
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
 > 609		lgdt3306a_config.mpeg_mode = LGDT3306A_MPEG_PARALLEL;
 > 610		lgdt3306a_config.tpclk_edge = LGDT3306A_TPCLK_FALLING_EDGE;
 > 611		lgdt3306a_config.tpvalid_polarity = LGDT3306A_TP_VALID_LOW;
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
 > 624	static int pvr2_dual_fe_attach(struct pvr2_dvb_adapter *adap)
   625	{
   626		pr_debug("%s()\n", __func__);
   627	
 > 628		if (pvr2_lgdt3306a_attach(adap) != 0)
   629			return -ENODEV;
   630	
 > 631		if (pvr2_si2168_attach(adap) != 0) {
 > 632			dvb_module_release(adap->i2c_client_demod[0]);
   633			return -ENODEV;
   634		}
   635	
   636		return 0;
   637	}
   638	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--SLDf9lqlvOQaIe6s
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
AgA=

--SLDf9lqlvOQaIe6s--
