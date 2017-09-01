Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46962
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750955AbdIANY7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 09:24:59 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2 12/27] media: dmx.h: get rid of unused DMX_KERNEL_CLIENT
Date: Fri,  1 Sep 2017 10:24:34 -0300
Message-Id: <8d30736eb53f1311459d0421f44028eed2de7fa0.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's a flag defined for Digital TV demux that is not used
anywhere, called DMX_KERNEL_CLIENT. Get rid of it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/dmx.h.rst.exceptions   | 1 -
 Documentation/media/uapi/dvb/dmx_types.rst | 1 -
 include/uapi/linux/dvb/dmx.h               | 1 -
 3 files changed, 3 deletions(-)

diff --git a/Documentation/media/dmx.h.rst.exceptions b/Documentation/media/dmx.h.rst.exceptions
index 2fdb458564ba..933ca5a61ce1 100644
--- a/Documentation/media/dmx.h.rst.exceptions
+++ b/Documentation/media/dmx.h.rst.exceptions
@@ -56,7 +56,6 @@ replace symbol DMX_SOURCE_DVR3 :c:type:`dmx_source`
 replace define DMX_CHECK_CRC :c:type:`dmx_sct_filter_params`
 replace define DMX_ONESHOT :c:type:`dmx_sct_filter_params`
 replace define DMX_IMMEDIATE_START :c:type:`dmx_sct_filter_params`
-replace define DMX_KERNEL_CLIENT :c:type:`dmx_sct_filter_params`
 
 # some typedefs should point to struct/enums
 replace typedef dmx_caps_t :c:type:`dmx_caps`
diff --git a/Documentation/media/uapi/dvb/dmx_types.rst b/Documentation/media/uapi/dvb/dmx_types.rst
index 80dd659860d7..0f0113205c94 100644
--- a/Documentation/media/uapi/dvb/dmx_types.rst
+++ b/Documentation/media/uapi/dvb/dmx_types.rst
@@ -147,7 +147,6 @@ struct dmx_sct_filter_params
     #define DMX_CHECK_CRC       1
     #define DMX_ONESHOT         2
     #define DMX_IMMEDIATE_START 4
-    #define DMX_KERNEL_CLIENT   0x8000
     };
 
 
diff --git a/include/uapi/linux/dvb/dmx.h b/include/uapi/linux/dvb/dmx.h
index 1bc4d6fb0f01..1702f923d425 100644
--- a/include/uapi/linux/dvb/dmx.h
+++ b/include/uapi/linux/dvb/dmx.h
@@ -103,7 +103,6 @@ struct dmx_sct_filter_params
 #define DMX_CHECK_CRC       1
 #define DMX_ONESHOT         2
 #define DMX_IMMEDIATE_START 4
-#define DMX_KERNEL_CLIENT   0x8000
 };
 
 
-- 
2.13.5
