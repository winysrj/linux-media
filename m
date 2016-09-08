Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44061 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965602AbcIHMEX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:23 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 33/47] [media] docs-rst: fix the remaining broken links for DVB CA API
Date: Thu,  8 Sep 2016 09:03:55 -0300
Message-Id: <03c2e83a233a783896fe547b89df6d9db6355c28.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several links are broken, as they were using the typedef
name, instead of using the corresponding structs. Fix them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/ca-get-cap.rst        | 4 ++--
 Documentation/media/uapi/dvb/ca-get-descr-info.rst | 2 +-
 Documentation/media/uapi/dvb/ca-get-msg.rst        | 2 +-
 Documentation/media/uapi/dvb/ca-get-slot-info.rst  | 2 +-
 Documentation/media/uapi/dvb/ca-send-msg.rst       | 4 ++--
 Documentation/media/uapi/dvb/ca-set-descr.rst      | 6 +++---
 Documentation/media/uapi/dvb/ca-set-pid.rst        | 2 +-
 7 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/Documentation/media/uapi/dvb/ca-get-cap.rst b/Documentation/media/uapi/dvb/ca-get-cap.rst
index 77c57ac59535..fbf7e359cb8a 100644
--- a/Documentation/media/uapi/dvb/ca-get-cap.rst
+++ b/Documentation/media/uapi/dvb/ca-get-cap.rst
@@ -15,7 +15,7 @@ CA_GET_CAP
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, CA_GET_CAP, ca_caps_t *caps)
+.. c:function:: int ioctl(fd, CA_GET_CAP, struct ca_caps *caps)
     :name: CA_GET_CAP
 
 
@@ -26,7 +26,7 @@ Arguments
   File descriptor returned by a previous call to :c:func:`open() <dvb-ca-open>`.
 
 ``caps``
-  struct :c:type:`ca_caps` pointer
+  Pointer to struct :c:type:`ca_caps`.
 
 .. c:type:: struct ca_caps
 
diff --git a/Documentation/media/uapi/dvb/ca-get-descr-info.rst b/Documentation/media/uapi/dvb/ca-get-descr-info.rst
index b4a31940cec0..7bf327a3d0e3 100644
--- a/Documentation/media/uapi/dvb/ca-get-descr-info.rst
+++ b/Documentation/media/uapi/dvb/ca-get-descr-info.rst
@@ -15,7 +15,7 @@ CA_GET_DESCR_INFO
 Synopsis
 --------
 
-.. c:function:: int  ioctl(fd, CA_GET_DESCR_INFO, ca_descr_info_t *desc)
+.. c:function:: int  ioctl(fd, CA_GET_DESCR_INFO, struct ca_descr_info *desc)
     :name: CA_GET_DESCR_INFO
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/ca-get-msg.rst b/Documentation/media/uapi/dvb/ca-get-msg.rst
index 03b2a602f02a..121588da3ef1 100644
--- a/Documentation/media/uapi/dvb/ca-get-msg.rst
+++ b/Documentation/media/uapi/dvb/ca-get-msg.rst
@@ -15,7 +15,7 @@ CA_GET_MSG
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, CA_GET_MSG, ca_msg_t *msg)
+.. c:function:: int ioctl(fd, CA_GET_MSG, struct ca_msg *msg)
     :name: CA_GET_MSG
 
 
diff --git a/Documentation/media/uapi/dvb/ca-get-slot-info.rst b/Documentation/media/uapi/dvb/ca-get-slot-info.rst
index 4398aeb83eb7..54e5dc78a2dc 100644
--- a/Documentation/media/uapi/dvb/ca-get-slot-info.rst
+++ b/Documentation/media/uapi/dvb/ca-get-slot-info.rst
@@ -15,7 +15,7 @@ CA_GET_SLOT_INFO
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, CA_GET_SLOT_INFO, ca_slot_info_t *info)
+.. c:function:: int ioctl(fd, CA_GET_SLOT_INFO, struct ca_slot_info *info)
     :name: CA_GET_SLOT_INFO
 
 
diff --git a/Documentation/media/uapi/dvb/ca-send-msg.rst b/Documentation/media/uapi/dvb/ca-send-msg.rst
index 0c42b10cf4f4..532ef5f9d6ac 100644
--- a/Documentation/media/uapi/dvb/ca-send-msg.rst
+++ b/Documentation/media/uapi/dvb/ca-send-msg.rst
@@ -15,7 +15,7 @@ CA_SEND_MSG
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, CA_SEND_MSG, ca_msg_t *msg)
+.. c:function:: int ioctl(fd, CA_SEND_MSG, struct ca_msg *msg)
     :name: CA_SEND_MSG
 
 
@@ -26,7 +26,7 @@ Arguments
   File descriptor returned by a previous call to :c:func:`open() <cec-open>`.
 
 ``msg``
-  Undocumented.
+  Pointer to struct :c:type:`ca_msg`.
 
 
 Description
diff --git a/Documentation/media/uapi/dvb/ca-set-descr.rst b/Documentation/media/uapi/dvb/ca-set-descr.rst
index 63dcc2b751ef..70f7b3cf12ad 100644
--- a/Documentation/media/uapi/dvb/ca-set-descr.rst
+++ b/Documentation/media/uapi/dvb/ca-set-descr.rst
@@ -15,8 +15,8 @@ CA_SET_DESCR
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, CA_SET_DESCR, ca_descr_t *desc)
-    :name:
+.. c:function:: int ioctl(fd, CA_SET_DESCR, struct ca_descr *desc)
+    :name: CA_SET_DESCR
 
 
 Arguments
@@ -26,7 +26,7 @@ Arguments
   File descriptor returned by a previous call to :c:func:`open() <cec-open>`.
 
 ``msg``
-  Undocumented.
+  Pointer to struct :c:type:`ca_descr`.
 
 
 Description
diff --git a/Documentation/media/uapi/dvb/ca-set-pid.rst b/Documentation/media/uapi/dvb/ca-set-pid.rst
index 06bdaf4afada..891c1c72ef24 100644
--- a/Documentation/media/uapi/dvb/ca-set-pid.rst
+++ b/Documentation/media/uapi/dvb/ca-set-pid.rst
@@ -15,7 +15,7 @@ CA_SET_PID
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, CA_SET_PID, ca_pid_t *pid)
+.. c:function:: int ioctl(fd, CA_SET_PID, struct ca_pid *pid)
     :name: CA_SET_PID
 
 
-- 
2.7.4


