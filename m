Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33148
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752160AbdI0Vkx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:40:53 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH v2 32/37] media: dtv-demux.rst: parse other demux headers with kernel-doc
Date: Wed, 27 Sep 2017 18:40:33 -0300
Message-Id: <4f992d2ce9370fccb91c05af652396566236c1e9.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we have kernel-doc markups at dvb_demux.h and dmxdev.h,
parse them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/dtv-demux.rst | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/kapi/dtv-demux.rst b/Documentation/media/kapi/dtv-demux.rst
index 3ee69266e206..7aa865a2b43f 100644
--- a/Documentation/media/kapi/dtv-demux.rst
+++ b/Documentation/media/kapi/dtv-demux.rst
@@ -66,7 +66,17 @@ function call directly from a hardware interrupt.
 This mechanism is implemented by :c:func:`dmx_ts_cb()` and :c:func:`dmx_section_cb()`
 callbacks.
 
-Digital TV Demux functions and types
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Digital TV Demux device registration functions and data structures
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+.. kernel-doc:: drivers/media/dvb-core/dmxdev.h
+
+High-level Digital TV demux interface
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+.. kernel-doc:: drivers/media/dvb-core/dvb_demux.h
+
+Driver-internal low-level hardware specific driver demux interface
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 .. kernel-doc:: drivers/media/dvb-core/demux.h
-- 
2.13.5
