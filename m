Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:50718 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbcEaQ43 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2016 12:56:29 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 2/2] [media] DocBook: mention the memory type to be set for all streaming I/O
Date: Tue, 31 May 2016 12:56:08 -0400
Message-Id: <1464713768-21213-2-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1464713768-21213-1-git-send-email-javier@osg.samsung.com>
References: <1464713768-21213-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DMA buffer importing streaming I/O section mentions the memory type
value that has to be set when calling the VIDIOC_REQBUFS ioctl but this
isn't mentioned in neither the Memory Mapping nor User Pointer sections.

A user can know the values by looking at the examples but it's better
to explicitly mention in the documentation, and also makes all sections
about streaming I/O methods more consistent.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 Documentation/DocBook/media/v4l/io.xml | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index e09025db92bd..21a3dde8f95d 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -88,7 +88,7 @@ function.<footnote>
 <structfield>capabilities</structfield> field of &v4l2-capability;
 returned by the &VIDIOC-QUERYCAP; ioctl is set. There are two
 streaming methods, to determine if the memory mapping flavor is
-supported applications must call the &VIDIOC-REQBUFS; ioctl.</para>
+supported applications must call the &VIDIOC-REQBUFS; ioctl with the memory type set to <constant>V4L2_MEMORY_MMAP</constant>.</para>
 
     <para>Streaming is an I/O method where only pointers to buffers
 are exchanged between application and driver, the data itself is not
@@ -369,7 +369,7 @@ rest should be evident.</para>
 <structfield>capabilities</structfield> field of &v4l2-capability;
 returned by the &VIDIOC-QUERYCAP; ioctl is set. If the particular user
 pointer method (not only memory mapping) is supported must be
-determined by calling the &VIDIOC-REQBUFS; ioctl.</para>
+determined by calling the &VIDIOC-REQBUFS; ioctl with the memory type set to <constant>V4L2_MEMORY_USERPTR</constant>.</para>
 
     <para>This I/O method combines advantages of the read/write and
 memory mapping methods. Buffers (planes) are allocated by the application
-- 
2.5.5

