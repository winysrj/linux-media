Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:42052 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbeAVMcg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 07:32:36 -0500
Received: by mail-qt0-f194.google.com with SMTP id c2so20222355qtn.9
        for <linux-media@vger.kernel.org>; Mon, 22 Jan 2018 04:32:36 -0800 (PST)
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: kernel@collabora.com,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH] [media] buffer.rst: fix link text of VIDIOC_QBUF
Date: Mon, 22 Jan 2018 10:32:18 -0200
Message-Id: <20180122123218.1912-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

The link was showing both VIDIOC_QBUF, VIDIOC_DQBUF while it should show
only VIDIOC_QBUF in this case.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 Documentation/media/uapi/v4l/buffer.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index 597bcc418df4..49273026740f 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -13,7 +13,7 @@ Only pointers to buffers (planes) are exchanged, the data itself is not
 copied. These pointers, together with meta-information like timestamps
 or field parity, are stored in a struct :c:type:`v4l2_buffer`,
 argument to the :ref:`VIDIOC_QUERYBUF`,
-:ref:`VIDIOC_QBUF` and
+:ref:`VIDIOC_QBUF <VIDIOC_QBUF>` and
 :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl. In the multi-planar API,
 some plane-specific members of struct :c:type:`v4l2_buffer`,
 such as pointers and sizes for each plane, are stored in struct
-- 
2.14.3
