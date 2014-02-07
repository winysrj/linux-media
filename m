Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:58159 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbaBGOwg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Feb 2014 09:52:36 -0500
Date: Fri, 07 Feb 2014 22:52:33 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [linuxtv-media:sdr 488/499]
 drivers/media/tuners/tuner-xc2028.c:1037:2: warning: enumeration value
 'V4L2_TUNER_ADC' not handled in switch
Message-ID: <52f4f331.fX8f2CStgBpu2FQK%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git sdr
head:   11532660e6f5b6b3a74a03f999d878f35d2cc668
commit: 6b200814f9eaac45ad816da459e31534b576c37b [488/499] [media] v4l: add new tuner types for SDR
config: make ARCH=powerpc allmodconfig

All warnings:

   drivers/media/tuners/tuner-xc2028.c: In function 'generic_set_freq':
>> drivers/media/tuners/tuner-xc2028.c:1037:2: warning: enumeration value 'V4L2_TUNER_ADC' not handled in switch [-Wswitch]
     switch (new_type) {
     ^
>> drivers/media/tuners/tuner-xc2028.c:1037:2: warning: enumeration value 'V4L2_TUNER_RF' not handled in switch [-Wswitch]

vim +/V4L2_TUNER_ADC +1037 drivers/media/tuners/tuner-xc2028.c

7e28adb2 drivers/media/video/tuner-xc2028.c         Harvey Harrison       2008-04-08  1021  	tuner_dbg("%s called\n", __func__);
215b95ba drivers/media/video/tuner-xc2028.c         Mauro Carvalho Chehab 2007-10-23  1022  
de3fe21b drivers/media/video/tuner-xc2028.c         Mauro Carvalho Chehab 2007-10-24  1023  	mutex_lock(&priv->lock);
de3fe21b drivers/media/video/tuner-xc2028.c         Mauro Carvalho Chehab 2007-10-24  1024  
2ce4b3aa drivers/media/video/tuner-xc2028.c         Chris Pascoe          2007-11-19  1025  	tuner_dbg("should set frequency %d kHz\n", freq / 1000);
6cb45879 drivers/media/video/tuner-xc2028.c         Mauro Carvalho Chehab 2007-10-02  1026  
66c2d53d drivers/media/video/tuner-xc2028.c         Mauro Carvalho Chehab 2007-11-25  1027  	if (check_firmware(fe, type, std, int_freq) < 0)
3b20532c drivers/media/video/tuner-xc2028.c         Mauro Carvalho Chehab 2007-09-27  1028  		goto ret;
2e4160ca drivers/media/video/tuner-xc2028.c         Mauro Carvalho Chehab 2007-07-18  1029  
2800ae9c drivers/media/video/tuner-xc2028.c         Mauro Carvalho Chehab 2007-11-22  1030  	/* On some cases xc2028 can disable video output, if
2800ae9c drivers/media/video/tuner-xc2028.c         Mauro Carvalho Chehab 2007-11-22  1031  	 * very weak signals are received. By sending a soft
2800ae9c drivers/media/video/tuner-xc2028.c         Mauro Carvalho Chehab 2007-11-22  1032  	 * reset, this is re-enabled. So, it is better to always
2800ae9c drivers/media/video/tuner-xc2028.c         Mauro Carvalho Chehab 2007-11-22  1033  	 * send a soft reset before changing channels, to be sure
2800ae9c drivers/media/video/tuner-xc2028.c         Mauro Carvalho Chehab 2007-11-22  1034  	 * that xc2028 will be in a safe state.
2800ae9c drivers/media/video/tuner-xc2028.c         Mauro Carvalho Chehab 2007-11-22  1035  	 * Maybe this might also be needed for DTV.
2800ae9c drivers/media/video/tuner-xc2028.c         Mauro Carvalho Chehab 2007-11-22  1036  	 */
fd34cb08 drivers/media/common/tuners/tuner-xc2028.c Mauro Carvalho Chehab 2011-08-31 @1037  	switch (new_type) {
fd34cb08 drivers/media/common/tuners/tuner-xc2028.c Mauro Carvalho Chehab 2011-08-31  1038  	case V4L2_TUNER_ANALOG_TV:
2800ae9c drivers/media/video/tuner-xc2028.c         Mauro Carvalho Chehab 2007-11-22  1039  		rc = send_seq(priv, {0x00, 0x00});
0a863975 drivers/media/common/tuners/tuner-xc2028.c Mauro Carvalho Chehab 2009-06-01  1040  
fd34cb08 drivers/media/common/tuners/tuner-xc2028.c Mauro Carvalho Chehab 2011-08-31  1041  		/* Analog mode requires offset = 0 */
fd34cb08 drivers/media/common/tuners/tuner-xc2028.c Mauro Carvalho Chehab 2011-08-31  1042  		break;
fd34cb08 drivers/media/common/tuners/tuner-xc2028.c Mauro Carvalho Chehab 2011-08-31  1043  	case V4L2_TUNER_RADIO:
fd34cb08 drivers/media/common/tuners/tuner-xc2028.c Mauro Carvalho Chehab 2011-08-31  1044  		/* Radio mode requires offset = 0 */
fd34cb08 drivers/media/common/tuners/tuner-xc2028.c Mauro Carvalho Chehab 2011-08-31  1045  		break;

:::::: The code at line 1037 was first introduced by commit
:::::: fd34cb08babcd898c6b0e30cd7d507ffa62685a1 [media] tuner/xc2028: Fix frequency offset for radio mode

:::::: TO: Mauro Carvalho Chehab <mchehab@redhat.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@redhat.com>

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
