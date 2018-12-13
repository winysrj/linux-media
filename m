Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,T_MIXED_ES,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23FE1C67872
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:51:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E538E20645
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:51:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E538E20645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbeLMJvO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 04:51:14 -0500
Received: from mga17.intel.com ([192.55.52.151]:45877 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728021AbeLMJvO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 04:51:14 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2018 01:51:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,348,1539673200"; 
   d="scan'208";a="100367536"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga006.jf.intel.com with ESMTP; 13 Dec 2018 01:51:12 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 9276F206FC;
        Thu, 13 Dec 2018 11:51:11 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gXNe9-0003tL-9s; Thu, 13 Dec 2018 11:51:09 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     yong.zhi@intel.com, laurent.pinchart@ideasonboard.com,
        rajmohan.mani@intel.com
Subject: [PATCH v9 02/22] docs-rst: v4l: Document V4L2_BUF_TYPE_META_OUTPUT interface
Date:   Thu, 13 Dec 2018 11:50:47 +0200
Message-Id: <20181213095107.14894-3-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181213095107.14894-1-sakari.ailus@linux.intel.com>
References: <20181213095107.14894-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Document the interface for metadata output, including
V4L2_BUF_TYPE_META_OUTPUT buffer type and V4L2_CAP_META_OUTPUT capability
bits.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
Tested-by: Tian Shu Qiu <tian.shu.qiu@intel.com>
---
 Documentation/media/uapi/v4l/buffer.rst          |  3 +++
 Documentation/media/uapi/v4l/dev-meta.rst        | 33 ++++++++++++++----------
 Documentation/media/uapi/v4l/vidioc-querycap.rst |  3 +++
 Documentation/media/videodev2.h.rst.exceptions   |  2 ++
 4 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index c5013adaa44d9..86878bb0087f2 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -472,6 +472,9 @@ enum v4l2_buf_type
     * - ``V4L2_BUF_TYPE_META_CAPTURE``
       - 13
       - Buffer for metadata capture, see :ref:`metadata`.
+    * - ``V4L2_BUF_TYPE_META_OUTPUT``
+      - 14
+      - Buffer for metadata output, see :ref:`metadata`.
 
 
 
diff --git a/Documentation/media/uapi/v4l/dev-meta.rst b/Documentation/media/uapi/v4l/dev-meta.rst
index edccb9bd8858c..c5dbe882be654 100644
--- a/Documentation/media/uapi/v4l/dev-meta.rst
+++ b/Documentation/media/uapi/v4l/dev-meta.rst
@@ -14,21 +14,27 @@ Metadata Interface
 ******************
 
 Metadata refers to any non-image data that supplements video frames with
-additional information. This may include statistics computed over the image
-or frame capture parameters supplied by the image source. This interface is
-intended for transfer of metadata to userspace and control of that operation.
+additional information. This may include statistics computed over the image,
+frame capture parameters supplied by the image source or device specific
+parameters for specifying how the device processes images. This interface is
+intended for transfer of metadata between the userspace and the hardware and
+control of that operation.
 
-The metadata interface is implemented on video capture device nodes. The device
-can be dedicated to metadata or can implement both video and metadata capture
-as specified in its reported capabilities.
+The metadata interface is implemented on video device nodes. The device can be
+dedicated to metadata or can support both video and metadata as specified in its
+reported capabilities.
 
 Querying Capabilities
 =====================
 
-Device nodes supporting the metadata interface set the ``V4L2_CAP_META_CAPTURE``
-flag in the ``device_caps`` field of the
+Device nodes supporting the metadata capture interface set the
+``V4L2_CAP_META_CAPTURE`` flag in the ``device_caps`` field of the
 :c:type:`v4l2_capability` structure returned by the :c:func:`VIDIOC_QUERYCAP`
-ioctl. That flag means the device can capture metadata to memory.
+ioctl. That flag means the device can capture metadata to memory. Similarly,
+device nodes supporting metadata output interface set the
+``V4L2_CAP_META_OUTPUT`` flag in the ``device_caps`` field of
+:c:type:`v4l2_capability` structure. That flag means the device can read
+metadata from memory.
 
 At least one of the read/write or streaming I/O methods must be supported.
 
@@ -42,10 +48,11 @@ to the basic :ref:`format` ioctls, the :c:func:`VIDIOC_ENUM_FMT` ioctl must be
 supported as well.
 
 To use the :ref:`format` ioctls applications set the ``type`` field of the
-:c:type:`v4l2_format` structure to ``V4L2_BUF_TYPE_META_CAPTURE`` and use the
-:c:type:`v4l2_meta_format` ``meta`` member of the ``fmt`` union as needed per
-the desired operation. Both drivers and applications must set the remainder of
-the :c:type:`v4l2_format` structure to 0.
+:c:type:`v4l2_format` structure to ``V4L2_BUF_TYPE_META_CAPTURE`` or to
+``V4L2_BUF_TYPE_META_OUTPUT`` and use the :c:type:`v4l2_meta_format` ``meta``
+member of the ``fmt`` union as needed per the desired operation. Both drivers
+and applications must set the remainder of the :c:type:`v4l2_format` structure
+to 0.
 
 .. c:type:: v4l2_meta_format
 
diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
index 0c7bc9568453f..5f9930195d624 100644
--- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
@@ -258,6 +258,9 @@ specification the ioctl returns an ``EINVAL`` error code.
     * - ``V4L2_CAP_STREAMING``
       - 0x04000000
       - The device supports the :ref:`streaming <mmap>` I/O method.
+    * - ``V4L2_CAP_META_OUTPUT``
+      - 0x08000000
+      - The device supports the :ref:`metadata` output interface.
     * - ``V4L2_CAP_TOUCH``
       - 0x10000000
       - This is a touch device.
diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
index 4c4bcba0f307d..64d348e67df99 100644
--- a/Documentation/media/videodev2.h.rst.exceptions
+++ b/Documentation/media/videodev2.h.rst.exceptions
@@ -30,6 +30,7 @@ replace symbol V4L2_FIELD_TOP :c:type:`v4l2_field`
 
 # Documented enum v4l2_buf_type
 replace symbol V4L2_BUF_TYPE_META_CAPTURE :c:type:`v4l2_buf_type`
+replace symbol V4L2_BUF_TYPE_META_OUTPUT :c:type:`v4l2_buf_type`
 replace symbol V4L2_BUF_TYPE_SDR_CAPTURE :c:type:`v4l2_buf_type`
 replace symbol V4L2_BUF_TYPE_SDR_OUTPUT :c:type:`v4l2_buf_type`
 replace symbol V4L2_BUF_TYPE_SLICED_VBI_CAPTURE :c:type:`v4l2_buf_type`
@@ -163,6 +164,7 @@ replace define V4L2_CAP_META_CAPTURE device-capabilities
 replace define V4L2_CAP_READWRITE device-capabilities
 replace define V4L2_CAP_ASYNCIO device-capabilities
 replace define V4L2_CAP_STREAMING device-capabilities
+replace define V4L2_CAP_META_OUTPUT device-capabilities
 replace define V4L2_CAP_DEVICE_CAPS device-capabilities
 replace define V4L2_CAP_TOUCH device-capabilities
 
-- 
2.11.0

