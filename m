Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46998
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752126AbdIANZE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 09:25:04 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2 26/27] media: dvb rst: identify the documentation gap at the API
Date: Fri,  1 Sep 2017 10:24:48 -0300
Message-Id: <45073d226a002d80218abcf49c1ac8c5b5246260.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that DVB spec is almost in sync, document what's missing.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/ca.rst              | 5 +++++
 Documentation/media/uapi/dvb/legacy_dvb_apis.rst | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/Documentation/media/uapi/dvb/ca.rst b/Documentation/media/uapi/dvb/ca.rst
index 14b14abda1ae..e3de778a5678 100644
--- a/Documentation/media/uapi/dvb/ca.rst
+++ b/Documentation/media/uapi/dvb/ca.rst
@@ -10,6 +10,11 @@ accessed through ``/dev/dvb/adapter?/ca?``. Data types and and ioctl
 definitions can be accessed by including ``linux/dvb/ca.h`` in your
 application.
 
+.. note::
+
+   There are three ioctls at this API that aren't documented:
+   :ref:`CA_GET_MSG`, :ref:`CA_SEND_MSG` and :ref:`CA_SET_DESCR`.
+   Documentation for them are welcome.
 
 .. toctree::
     :maxdepth: 1
diff --git a/Documentation/media/uapi/dvb/legacy_dvb_apis.rst b/Documentation/media/uapi/dvb/legacy_dvb_apis.rst
index 2957f5a988b0..dac349a1bb27 100644
--- a/Documentation/media/uapi/dvb/legacy_dvb_apis.rst
+++ b/Documentation/media/uapi/dvb/legacy_dvb_apis.rst
@@ -12,6 +12,11 @@ drivers should use it. Instead, audio and video should be using the V4L2
 and ALSA APIs, and the pipelines should be set using the Media
 Controller API
 
+.. note::
+
+   The APIs described here doesn't necessarily reflect the current
+   code implementation.
+
 
 .. toctree::
     :maxdepth: 1
-- 
2.13.5
