Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41334 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178AbcGHNEC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:02 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 11/54] doc-rst: dmabuf: Fix the cross-reference
Date: Fri,  8 Jul 2016 10:03:03 -0300
Message-Id: <c104290b95d8ddd2a186af14a9fb99e698928a42.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes this warning:
    Documentation/linux_tv/media/v4l/dmabuf.rst:150: WARNING: undefined label: vidioc_dqbuf (if the link has no caption the label must precede a section header)

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/dmabuf.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/linux_tv/media/v4l/dmabuf.rst b/Documentation/linux_tv/media/v4l/dmabuf.rst
index 0b2113778cc9..474d8c021507 100644
--- a/Documentation/linux_tv/media/v4l/dmabuf.rst
+++ b/Documentation/linux_tv/media/v4l/dmabuf.rst
@@ -149,7 +149,7 @@ outputted buffers.
 
 Drivers implementing DMABUF importing I/O must support the
 :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>`, :ref:`VIDIOC_QBUF <VIDIOC_QBUF>`,
-:ref:`VIDIOC_DQBUF <VIDIOC_DQBUF>`, :ref:`VIDIOC_STREAMON
+:ref:`VIDIOC_DQBUF <VIDIOC_QBUF>`, :ref:`VIDIOC_STREAMON
 <VIDIOC_STREAMON>` and :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` ioctls,
 and the :ref:`select() <func-select>` and :ref:`poll() <func-poll>`
 functions.
-- 
2.7.4

