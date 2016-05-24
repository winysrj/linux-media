Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:25131 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932569AbcEXRgl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 13:36:41 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u4OHWTKH010578
	for <linux-media@vger.kernel.org>; Tue, 24 May 2016 10:36:39 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0a-0016f401.pphosted.com with ESMTP id 232n1jw5cc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-media@vger.kernel.org>; Tue, 24 May 2016 10:36:39 -0700
From: Burt Poppenga <burtp@marvell.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Cross compiling v4l-utils for Android
Date: Tue, 24 May 2016 17:36:37 +0000
Message-ID: <D369ED47.7F7A%burtp@marvell.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4286070FFD824744BD96AED2F69AFE9E@marvell.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I was hoping to get some tips on cross compiling v4l-utils for Android.  I
am targeting a Nexus 5 Marshmallow device (using the android-6.0.1_r41
branch) and have the complete AOSP tree, it is built and flashed in my
device.

  PLATFORM_VERSION_CODENAME=REL
  PLATFORM_VERSION=6.0.1
  TARGET_PRODUCT=aosp_hammerhead
  TARGET_BUILD_VARIANT=userdebug
  TARGET_BUILD_TYPE=release
  TARGET_ARCH=arm
  TARGET_ARCH_VARIANT=armv7-a-neon
  TARGET_CPU_VARIANT=krait
  BUILD_ID=MOB30H

Note that I have not built the Kernel or NDK.

The INSTALL document for v4l-utils says:
"v4l-utils will only build using the complete AOSP source tree, because of
the stlport dependency"

Which makes sense looking at the v4l2-ctl Android.mk file:

LOCAL_C_INCLUDES := \
  $(LOCAL_PATH)/../.. \
  $(LOCAL_PATH)/../../include \
  bionic \
  external/stlport/stlport

LOCAL_SHARED_LIBRARIES := libstlport

The problem arises because it appears that Google has deprecated stlport.
Stlport no longer appears in the "external" tree, only the library is
present in the "prebuilts" tree.

Any tips would be greatly appreciated.

Thanks,
Burt


