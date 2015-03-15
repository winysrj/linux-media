Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:40745 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751166AbbCOUyf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 16:54:35 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 264B12A0083
	for <linux-media@vger.kernel.org>; Sun, 15 Mar 2015 21:54:30 +0100 (CET)
Message-ID: <5505F186.7050608@xs4all.nl>
Date: Sun, 15 Mar 2015 21:54:30 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: DocBook media: fix awkward language in VIDIOC_QUERYCAP
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix some awkward language in the VIDIOC_QUERYCAP description.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/Documentation/DocBook/media/v4l/vidioc-querycap.xml b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
index d0c5e60..20fda75 100644
--- a/Documentation/DocBook/media/v4l/vidioc-querycap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
@@ -102,10 +102,10 @@ The bus_info must start with "PCI:" for PCI boards, "PCIe:" for PCI Express boar
 	    <entry>__u32</entry>
 	    <entry><structfield>version</structfield></entry>
 	    <entry><para>Version number of the driver.</para>
-<para>Starting on kernel 3.1, the version reported is provided per
-V4L2 subsystem, following the same Kernel numberation scheme. However, it
-should not always return the same version as the kernel, if, for example,
-an stable or distribution-modified kernel uses the V4L2 stack from a
+<para>Starting with kernel 3.1, the version reported is provided by the
+V4L2 subsystem following the kernel numbering scheme. However, it
+may not always return the same version as the kernel if, for example,
+a stable or distribution-modified kernel uses the V4L2 stack from a
 newer kernel.</para>
 <para>The version number is formatted using the
 <constant>KERNEL_VERSION()</constant> macro:</para></entry>
