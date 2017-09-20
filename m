Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50343
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751704AbdITTL7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 15:11:59 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 06/25] media: dtv-core.rst: add chapters and introductory tests for common parts
Date: Wed, 20 Sep 2017 16:11:31 -0300
Message-Id: <34895fd20e106a8d2b235697cecd75ade30dd310.1505933919.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1505933919.git.mchehab@s-opensource.com>
References: <cover.1505933919.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1505933919.git.mchehab@s-opensource.com>
References: <cover.1505933919.git.mchehab@s-opensource.com>
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
