Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44950
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751898AbdHaXrK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 19:47:10 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 10/15] media: dmx.h: get rid of unused DMX_KERNEL_CLIENT
Date: Thu, 31 Aug 2017 20:46:57 -0300
Message-Id: <6eafbc65d25e0c7b9581e74f6218461a1829f951.1504222628.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504222628.git.mchehab@s-opensource.com>
References: <cover.1504222628.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504222628.git.mchehab@s-opensource.com>
References: <cover.1504222628.git.mchehab@s-opensource.com>
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
index 427e4899ed69..d4934e650e6b 100644
--- a/include/uapi/linux/dvb/dmx.h
+++ b/include/uapi/linux/dvb/dmx.h
@@ -105,7 +105,6 @@ struct dmx_sct_filter_params
 #define DMX_CHECK_CRC       1
 #define DMX_ONESHOT         2
 #define DMX_IMMEDIATE_START 4
-#define DMX_KERNEL_CLIENT   0x8000
 };
 
 
-- 
2.13.5
