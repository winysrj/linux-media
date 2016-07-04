Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44700 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbcGDLrU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 04/51] Documentation: querycap.rst: fix troubles on some references
Date: Mon,  4 Jul 2016 08:46:25 -0300
Message-Id: <d1edd09bc7cf156fab6a3c8d70885a10deead9b9.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is not due to the format change, but there are some
wrong references on this file. Fix them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/querycap.rst | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/querycap.rst b/Documentation/linux_tv/media/v4l/querycap.rst
index 2568820a3954..ce0c0e3f9b53 100644
--- a/Documentation/linux_tv/media/v4l/querycap.rst
+++ b/Documentation/linux_tv/media/v4l/querycap.rst
@@ -16,9 +16,9 @@ check if the kernel device is compatible with this specification, and to
 query the :ref:`functions <devices>` and :ref:`I/O methods <io>`
 supported by the device.
 
-Starting with kernel version 3.1, VIDIOC-QUERYCAP will return the V4L2
-API version used by the driver, with generally matches the Kernel
-version. There's no need of using
+Starting with kernel version 3.1, :ref:`VIDIOC_QUERYCAP <vidioc-querycap>`
+will return the V4L2 API version used by the driver, with generally
+matches the Kernel version. There's no need of using
 :ref:`VIDIOC_QUERYCAP <vidioc-querycap>` to check if a specific ioctl
 is supported, the V4L2 core now returns ENOTTY if a driver doesn't
 provide support for an ioctl.
@@ -30,8 +30,8 @@ abstraction is a major objective of this API, the
 :ref:`VIDIOC_QUERYCAP <vidioc-querycap>` ioctl also allows driver
 specific applications to reliably identify the driver.
 
-All V4L2 drivers must support ``VIDIOC_QUERYCAP``. Applications should
-always call this ioctl after opening the device.
+All V4L2 drivers must support :ref:`VIDIOC_QUERYCAP <vidioc-querycap>`.
+Applications should always call this ioctl after opening the device.
 
 
 .. ------------------------------------------------------------------------------
-- 
2.7.4


