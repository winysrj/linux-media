Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50938
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752858AbdICCfL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Sep 2017 22:35:11 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 08/12] media: cec uapi: Adjust table sizes for PDF output
Date: Sat,  2 Sep 2017 23:35:00 -0300
Message-Id: <f6e061ec80a6d3a8d59c1e47708ab2a798e1fcf8.1504405125.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504405124.git.mchehab@s-opensource.com>
References: <cover.1504405124.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504405124.git.mchehab@s-opensource.com>
References: <cover.1504405124.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several tables at this media book chapter have issues
when PDF is produced. Adjust them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst | 7 +++++--
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst          | 9 +++++----
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst           | 2 ++
 Documentation/media/uapi/cec/cec-ioc-receive.rst          | 2 ++
 4 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
index b25e003a04d7..84f431a022ad 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
@@ -65,7 +65,7 @@ logical address types are already defined will return with error ``EBUSY``.
 
 .. c:type:: cec_log_addrs
 
-.. tabularcolumns:: |p{1.0cm}|p{7.5cm}|p{8.0cm}|
+.. tabularcolumns:: |p{1.0cm}|p{8.0cm}|p{7.5cm}|
 
 .. cssclass:: longtable
 
@@ -148,6 +148,9 @@ logical address types are already defined will return with error ``EBUSY``.
         give the CEC framework more information about the device type, even
         though the framework won't use it directly in the CEC message.
 
+
+.. tabularcolumns:: |p{7.8cm}|p{1.0cm}|p{8.7cm}|
+
 .. _cec-log-addrs-flags:
 
 .. flat-table:: Flags for struct cec_log_addrs
@@ -183,7 +186,7 @@ logical address types are already defined will return with error ``EBUSY``.
 	All other messages are ignored.
 
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+.. tabularcolumns:: |p{7.8cm}|p{1.0cm}|p{8.7cm}|
 
 .. _cec-versions:
 
diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index db615e3405c0..a5c821809cc6 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -87,7 +87,7 @@ it is guaranteed that the state did change in between the two events.
 	this is more than enough.
 
 
-.. tabularcolumns:: |p{1.0cm}|p{4.2cm}|p{2.5cm}|p{8.8cm}|
+.. tabularcolumns:: |p{1.0cm}|p{4.4cm}|p{2.5cm}|p{9.6cm}|
 
 .. c:type:: cec_event
 
@@ -98,10 +98,11 @@ it is guaranteed that the state did change in between the two events.
 
     * - __u64
       - ``ts``
-      - :cspan:`1` Timestamp of the event in ns.
+      - :cspan:`1`\ Timestamp of the event in ns.
 
-	The timestamp has been taken from the ``CLOCK_MONOTONIC`` clock. To access
-	the same clock from userspace use :c:func:`clock_gettime`.
+	The timestamp has been taken from the ``CLOCK_MONOTONIC`` clock.
+
+	To access the same clock from userspace use :c:func:`clock_gettime`.
     * - __u32
       - ``event``
       - :cspan:`1` The CEC event type, see :ref:`cec-events`.
diff --git a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
index 4d8e0647e832..508e2e325683 100644
--- a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
@@ -108,6 +108,8 @@ Available follower modes are:
 
 .. _cec-mode-follower_e:
 
+.. cssclass:: longtable
+
 .. flat-table:: Follower Modes
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index 267044f7ac30..0f397c535a4c 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -195,6 +195,8 @@ View On' messages from initiator 0xf ('Unregistered') to destination 0 ('TV').
 	valid if the :ref:`CEC_TX_STATUS_ERROR <CEC-TX-STATUS-ERROR>` status bit is set.
 
 
+.. tabularcolumns:: |p{6.2cm}|p{1.0cm}|p{10.3cm}|
+
 .. _cec-msg-flags:
 
 .. flat-table:: Flags for struct cec_msg
-- 
2.13.5
