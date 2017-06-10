Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38187 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751922AbdFJJGB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Jun 2017 05:06:01 -0400
From: Johannes Thumshirn <jthumshirn@suse.de>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fbdev@vger.kernel.org,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 3/7] [media] media: document the use of MEDIA_REVISION instead of KERNEL_VERSION
Date: Sat, 10 Jun 2017 11:05:32 +0200
Message-Id: <20170610090536.12472-4-jthumshirn@suse.de>
In-Reply-To: <20170610090536.12472-1-jthumshirn@suse.de>
References: <20170610090536.12472-1-jthumshirn@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update the documentation to introduce the use of MEDIA_REVISON instead
of KERNEL_VERSION for the verison triplets of a media drivers hardware
revision or driver version.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst        | 2 +-
 Documentation/media/uapi/mediactl/media-ioc-device-info.rst | 4 ++--
 Documentation/media/uapi/v4l/vidioc-querycap.rst            | 6 +++---
 include/media/media-device.h                                | 5 ++---
 4 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
index a0e961f11017..749054f11c77 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
@@ -56,7 +56,7 @@ returns the information to the application. The ioctl never fails.
 	:ref:`cec-capabilities`.
     * - __u32
       - ``version``
-      - CEC Framework API version, formatted with the ``KERNEL_VERSION()``
+      - CEC Framework API version, formatted with the ``MEDIA_REVISION()``
 	macro.
 
 
diff --git a/Documentation/media/uapi/mediactl/media-ioc-device-info.rst b/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
index f690f9afc470..7a18cb6dbe84 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
@@ -96,7 +96,7 @@ ioctl never fails.
 
        -  ``media_version``
 
-       -  Media API version, formatted with the ``KERNEL_VERSION()`` macro.
+       -  Media API version, formatted with the ``MEDIA_REVISION()`` macro.
 
     -  .. row 6
 
@@ -113,7 +113,7 @@ ioctl never fails.
        -  ``driver_version``
 
        -  Media device driver version, formatted with the
-	  ``KERNEL_VERSION()`` macro. Together with the ``driver`` field
+	  ``MEDIA_REVISION()`` macro. Together with the ``driver`` field
 	  this identifies a particular driver.
 
     -  .. row 8
diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
index 12e0d9a63cd8..b66d9caa7211 100644
--- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
@@ -90,13 +90,13 @@ specification the ioctl returns an ``EINVAL`` error code.
 	example, a stable or distribution-modified kernel uses the V4L2
 	stack from a newer kernel.
 
-	The version number is formatted using the ``KERNEL_VERSION()``
+	The version number is formatted using the ``MEDIA_REVISION()``
 	macro:
     * - :cspan:`2`
 
-	``#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))``
+	``#define MEDIA_REVISION(a,b,c) (((a) << 16) + ((b) << 8) + (c))``
 
-	``__u32 version = KERNEL_VERSION(0, 8, 1);``
+	``__u32 version = MEDIA_REVISION(0, 8, 1);``
 
 	``printf ("Version: %u.%u.%u\\n",``
 
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 6896266031b9..6b3057266ad1 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -247,9 +247,9 @@ void media_device_cleanup(struct media_device *mdev);
  *
  *  - &media_entity.hw_revision is the hardware device revision in a
  *    driver-specific format. When possible the revision should be formatted
- *    with the KERNEL_VERSION() macro.
+ *    with the MEDIA_REVISION() macro.
  *
- *  - &media_entity.driver_version is formatted with the KERNEL_VERSION()
+ *  - &media_entity.driver_version is formatted with the MEDIA_REVISION()
  *    macro. The version minor must be incremented when new features are added
  *    to the userspace API without breaking binary compatibility. The version
  *    major must be incremented when binary compatibility is broken.
@@ -265,7 +265,6 @@ void media_device_cleanup(struct media_device *mdev);
 int __must_check __media_device_register(struct media_device *mdev,
 					 struct module *owner);
 
-
 /**
  * media_device_register() - Registers a media device element
  *
-- 
2.12.3
