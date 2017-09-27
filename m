Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33171
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752156AbdI0Vku (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:40:50 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH v2 18/37] media: dtv-demux.rst: minor markup improvements
Date: Wed, 27 Sep 2017 18:40:19 -0300
Message-Id: <6c7ddb12751994fa5f827e3e8bc273abf2789b66.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a cross-reference to a mentioned structure and split
the kernel-doc stuff on a separate chapter.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/dtv-demux.rst | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/media/kapi/dtv-demux.rst b/Documentation/media/kapi/dtv-demux.rst
index 8169c479156e..3ee69266e206 100644
--- a/Documentation/media/kapi/dtv-demux.rst
+++ b/Documentation/media/kapi/dtv-demux.rst
@@ -7,8 +7,8 @@ Digital TV Demux
 The Kernel Digital TV Demux kABI defines a driver-internal interface for
 registering low-level, hardware specific driver to a hardware independent
 demux layer. It is only of interest for Digital TV device driver writers.
-The header file for this kABI is named demux.h and located in
-drivers/media/dvb-core.
+The header file for this kABI is named ``demux.h`` and located in
+``drivers/media/dvb-core``.
 
 The demux kABI should be implemented for each demux in the system. It is
 used to select the TS source of a demux and to manage the demux resources.
@@ -27,7 +27,7 @@ tuning, are devined via the Digital TV Frontend kABI.
 The functions that implement the abstract interface demux should be defined
 static or module private and registered to the Demux core for external
 access. It is not necessary to implement every function in the struct
-&dmx_demux. For example, a demux interface might support Section filtering,
+:c:type:`dmx_demux`. For example, a demux interface might support Section filtering,
 but not PES filtering. The kABI client is expected to check the value of any
 function pointer before calling the function: the value of ``NULL`` means
 that the function is not available.
@@ -43,8 +43,6 @@ Linux Kernel calls the functions of a network device interface from a
 bottom half context. Thus, if a demux kABI function is called from network
 device code, the function must not sleep.
 
-
-
 Demux Callback API
 ~~~~~~~~~~~~~~~~~~
 
@@ -68,4 +66,7 @@ function call directly from a hardware interrupt.
 This mechanism is implemented by :c:func:`dmx_ts_cb()` and :c:func:`dmx_section_cb()`
 callbacks.
 
+Digital TV Demux functions and types
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
 .. kernel-doc:: drivers/media/dvb-core/demux.h
-- 
2.13.5
