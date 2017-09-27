Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33148
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752204AbdI0Vk4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:40:56 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH v2 16/37] media: dtv-core.rst: add chapters and introductory tests for common parts
Date: Wed, 27 Sep 2017 18:40:17 -0300
Message-Id: <210e51a8301b63f5f1224c9d462ffc6360e5a109.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Better document the DVB common parts by adding two sections
and an introductory text for each.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/dtv-core.rst | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/media/kapi/dtv-core.rst b/Documentation/media/kapi/dtv-core.rst
index de9a228aca8a..4cf9cf63bafd 100644
--- a/Documentation/media/kapi/dtv-core.rst
+++ b/Documentation/media/kapi/dtv-core.rst
@@ -29,8 +29,20 @@ I2C bus.
 Digital TV Common functions
 ---------------------------
 
+Math functions
+~~~~~~~~~~~~~~
+
+Provide some commonly-used math functions, usually required in order to
+estimate signal strength and signal to noise measurements in dB.
+
 .. kernel-doc:: drivers/media/dvb-core/dvb_math.h
 
+
+DVB devices
+~~~~~~~~~~~
+
+Those functions are responsible for handling the DVB device nodes.
+
 .. kernel-doc:: drivers/media/dvb-core/dvbdev.h
 
 Digital TV Ring buffer
-- 
2.13.5
