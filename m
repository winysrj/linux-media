Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57566
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751385AbdIELE0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Sep 2017 07:04:26 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 1/2] media: dvb uapi: move frontend legacy API to another part of the book
Date: Tue,  5 Sep 2017 08:04:20 -0300
Message-Id: <ebc93052aeadd7b931371c293f62074b1dba7265.1504609454.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's a chapter for the legacy APIs. Move the frontend DVBv3
API to it, and update the chapter's introduction accordingly.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/frontend.rst        |  1 -
 Documentation/media/uapi/dvb/legacy_dvb_apis.rst | 21 ++++++++++++++-------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/Documentation/media/uapi/dvb/frontend.rst b/Documentation/media/uapi/dvb/frontend.rst
index b9cfcad39823..4967c48d46ce 100644
--- a/Documentation/media/uapi/dvb/frontend.rst
+++ b/Documentation/media/uapi/dvb/frontend.rst
@@ -54,4 +54,3 @@ Data types and ioctl definitions can be accessed by including
     dvb-fe-read-status
     dvbproperty
     frontend_fcalls
-    frontend_legacy_dvbv3_api
diff --git a/Documentation/media/uapi/dvb/legacy_dvb_apis.rst b/Documentation/media/uapi/dvb/legacy_dvb_apis.rst
index 7eb14d6f729f..e1b2c9c7b620 100644
--- a/Documentation/media/uapi/dvb/legacy_dvb_apis.rst
+++ b/Documentation/media/uapi/dvb/legacy_dvb_apis.rst
@@ -6,20 +6,27 @@
 Digital TV Deprecated APIs
 ***************************
 
-The APIs described here are kept only for historical reasons. There's
-just one driver for a very legacy hardware that uses this API. No modern
-drivers should use it. Instead, audio and video should be using the V4L2
-and ALSA APIs, and the pipelines should be set using the Media
-Controller API
+The APIs described here **should not** be used on new drivers or applications.
 
-.. note::
+The DVBv3 frontend API has issues with new delivery systems, including
+DVB-S2, DVB-T2, ISDB, etc.
+
+There's just one driver for a very legacy hardware using the Digital TV
+audio and video APIs. No modern drivers should use it. Instead, audio and
+video should be using the V4L2 and ALSA APIs, and the pipelines should
+be set via the Media Controller API.
+
+.. attention::
 
    The APIs described here doesn't necessarily reflect the current
-   code implementation.
+   code implementation, as this section of the document was written
+   for DVB version 1, while the code reflects DVB version 3
+   implementation.
 
 
 .. toctree::
     :maxdepth: 1
 
+    frontend_legacy_dvbv3_api
     video
     audio
-- 
2.13.5
