Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48367
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752317AbdIATiA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 15:38:00 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 11/14] media: dmx-get-pes-pids.rst: document the ioctl
Date: Fri,  1 Sep 2017 16:37:47 -0300
Message-Id: <dbbc595c0a13ca5121ba465b2db9a024584b44d0.1504293108.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504293108.git.mchehab@s-opensource.com>
References: <cover.1504293108.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504293108.git.mchehab@s-opensource.com>
References: <cover.1504293108.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This ioctl is supported by the DVB core, but was never
documented.

Add a documentation for it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/dmx-get-pes-pids.rst | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/uapi/dvb/dmx-get-pes-pids.rst b/Documentation/media/uapi/dvb/dmx-get-pes-pids.rst
index 20288c11d279..fbdbc12869d1 100644
--- a/Documentation/media/uapi/dvb/dmx-get-pes-pids.rst
+++ b/Documentation/media/uapi/dvb/dmx-get-pes-pids.rst
@@ -25,13 +25,31 @@ Arguments
     File descriptor returned by :c:func:`open() <dvb-dmx-open>`.
 
 ``pids``
-    Undocumented.
+    Array used to store 5 Program IDs.
 
 
 Description
 -----------
 
-.. note:: This ioctl is undocumented. Documentation is welcome.
+This ioctl allows to query a DVB device to return the first PID used
+by audio, video, textext, subtitle and PCR programs on a given service.
+They're stored as:
+
+=======================	========	=======================================
+PID  element		position	content
+=======================	========	=======================================
+pids[DMX_PES_AUDIO]	0		first audio PID
+pids[DMX_PES_VIDEO]	1		first video PID
+pids[DMX_PES_TELETEXT]	2		first teletext PID
+pids[DMX_PES_SUBTITLE]	3		first subtitle PID
+pids[DMX_PES_PCR]	4		first Program Clock Reference PID
+=======================	========	=======================================
+
+
+.. note::
+
+	A value equal to 0xffff means that the PID was not filled by the
+	Kernel.
 
 
 Return Value
-- 
2.13.5
