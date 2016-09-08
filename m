Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43969 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941754AbcIHME0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:26 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 36/47] [media] docs-rst: fix cec bad cross-references
Date: Thu,  8 Sep 2016 09:03:58 -0300
Message-Id: <dadad27d19602965ca662c2c16d32bb891365820.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix some CEC cross references that are broken.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/cec.h.rst.exceptions                  |  6 ------
 Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst | 10 +++++-----
 Documentation/media/uapi/cec/cec-ioc-receive.rst          |  9 +++++----
 3 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/Documentation/media/cec.h.rst.exceptions b/Documentation/media/cec.h.rst.exceptions
index b79339433718..b1687532742f 100644
--- a/Documentation/media/cec.h.rst.exceptions
+++ b/Documentation/media/cec.h.rst.exceptions
@@ -1,12 +1,6 @@
 # Ignore header name
 ignore define _CEC_UAPI_H
 
-# Rename some symbols, to avoid namespace conflicts
-replace struct cec_event_state_change cec-event-state-change_s
-replace struct cec_event_lost_msgs cec-event-lost-msgs_s
-replace enum cec_mode_initiator cec-mode-initiator_e
-replace enum cec_mode_follower cec-mode-follower_e
-
 # define macros to ignore
 
 ignore define CEC_MAX_MSG_SIZE
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
index bd0756ff022e..6c314c2db73e 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
@@ -30,7 +30,7 @@ Arguments
     File descriptor returned by :c:func:`open() <cec-open>`.
 
 ``argp``
-    Pointer to struct cec_log_addrs
+    Pointer to struct :c:type:`cec_log_addrs`.
 
 Description
 ===========
@@ -42,10 +42,10 @@ Description
 
 To query the current CEC logical addresses, applications call
 :ref:`ioctl CEC_ADAP_G_LOG_ADDRS <CEC_ADAP_G_LOG_ADDRS>` with a pointer to a
-:c:type:`struct cec_log_addrs` where the driver stores the logical addresses.
+struct :c:type:`cec_log_addrs` where the driver stores the logical addresses.
 
 To set new logical addresses, applications fill in
-:c:type:`struct cec_log_addrs` and call :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`
+struct :c:type:`cec_log_addrs` and call :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`
 with a pointer to this struct. The :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`
 is only available if ``CEC_CAP_LOG_ADDRS`` is set (the ``ENOTTY`` error code is
 returned otherwise). The :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`
@@ -66,10 +66,10 @@ logical addresses are claimed or cleared.
 Attempting to call :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>` when
 logical address types are already defined will return with error ``EBUSY``.
 
-.. tabularcolumns:: |p{1.0cm}|p{7.5cm}|p{8.0cm}|
-
 .. c:type:: cec_log_addrs
 
+.. tabularcolumns:: |p{1.0cm}|p{7.5cm}|p{8.0cm}|
+
 .. cssclass:: longtable
 
 .. flat-table:: struct cec_log_addrs
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index f015f1259b27..18620f81b7d9 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -40,7 +40,8 @@ Description
    and is currently only available as a staging kernel module.
 
 To receive a CEC message the application has to fill in the
-``timeout`` field of :c:type:`struct cec_msg` and pass it to :ref:`ioctl CEC_RECEIVE <CEC_RECEIVE>`.
+``timeout`` field of struct :c:type:`cec_msg` and pass it to
+:ref:`ioctl CEC_RECEIVE <CEC_RECEIVE>`.
 If the file descriptor is in non-blocking mode and there are no received
 messages pending, then it will return -1 and set errno to the ``EAGAIN``
 error code. If the file descriptor is in blocking mode and ``timeout``
@@ -54,9 +55,9 @@ A received message can be:
 2. the result of an earlier non-blocking transmit (the ``sequence`` field will
    be non-zero).
 
-To send a CEC message the application has to fill in the
-:c:type:`struct cec_msg` and pass it to
-:ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>`. The :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>` is only available if
+To send a CEC message the application has to fill in the struct
+:c:type:` cec_msg` and pass it to :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>`.
+The :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>` is only available if
 ``CEC_CAP_TRANSMIT`` is set. If there is no more room in the transmit
 queue, then it will return -1 and set errno to the ``EBUSY`` error code.
 The transmit queue has enough room for 18 messages (about 1 second worth
-- 
2.7.4


