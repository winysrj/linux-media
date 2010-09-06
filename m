Return-path: <mchehab@gaivota>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:26102 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab0IFGx6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Sep 2010 02:53:58 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L8B0072HCHTIF20@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Sep 2010 07:53:54 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L8B001CCCHSA4@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Sep 2010 07:53:53 +0100 (BST)
Date: Mon, 06 Sep 2010 08:53:49 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 7/8] v4l: Add EBUSY error description for VIDIOC_STREAMON
In-reply-to: <1283756030-28634-1-git-send-email-m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	p.osciak@samsung.com, s.nawrocki@samsung.com
Message-id: <1283756030-28634-8-git-send-email-m.szyprowski@samsung.com>
References: <1283756030-28634-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Pawel Osciak <p.osciak@samsung.com>

VIDIOC_STREAMON should return EBUSY if streaming is already active.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 Documentation/DocBook/v4l/vidioc-streamon.xml |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/v4l/vidioc-streamon.xml b/Documentation/DocBook/v4l/vidioc-streamon.xml
index e42bff1..fdbd8d8 100644
--- a/Documentation/DocBook/v4l/vidioc-streamon.xml
+++ b/Documentation/DocBook/v4l/vidioc-streamon.xml
@@ -93,6 +93,13 @@ synchronize with other events.</para>
 been allocated (memory mapping) or enqueued (output) yet.</para>
 	</listitem>
       </varlistentry>
+      <varlistentry>
+	<term><errorcode>EBUSY</errorcode></term>
+	<listitem>
+	  <para><constant>VIDIOC_STREAMON</constant> called, but
+	  streaming I/O already active.</para>
+	</listitem>
+      </varlistentry>
     </variablelist>
   </refsect1>
 </refentry>
-- 
1.7.2.2

