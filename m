Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:33584 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbcHOOIv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 10:08:51 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jani Nikula <jani.nikula@intel.com>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH 5/5] doc-rst: migrate ioctl CEC_DQEVENT to c-domain
Date: Mon, 15 Aug 2016 16:08:28 +0200
Message-Id: <1471270108-29314-6-git-send-email-markus.heiser@darmarit.de>
In-Reply-To: <1471270108-29314-1-git-send-email-markus.heiser@darmarit.de>
References: <1471270108-29314-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

This is only one example, demonstrating the benefits of the patch
series.  The CEC_DQEVENT ioctl is migrated to the sphinx c-domain and
referred by ":name: CEC_DQEVENT".

With this change the indirection using ":ref:`CEC_DQEVENT` is no longer
needed, we can refer the ioctl directly with ":c:func:`CEC_DQEVENT`". As
addition in the index, there is a entry "CEC_DQEVENT (C function)".

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
---
 Documentation/media/uapi/cec/cec-func-open.rst   | 2 +-
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-func-open.rst b/Documentation/media/uapi/cec/cec-func-open.rst
index 38fd7e0..7c0f981 100644
--- a/Documentation/media/uapi/cec/cec-func-open.rst
+++ b/Documentation/media/uapi/cec/cec-func-open.rst
@@ -32,7 +32,7 @@ Arguments
     Open flags. Access mode must be ``O_RDWR``.
 
     When the ``O_NONBLOCK`` flag is given, the
-    :ref:`CEC_RECEIVE <CEC_RECEIVE>` and :ref:`CEC_DQEVENT <CEC_DQEVENT>` ioctls
+    :ref:`CEC_RECEIVE <CEC_RECEIVE>` and :c:func:`CEC_DQEVENT` ioctls
     will return the ``EAGAIN`` error code when no message or event is available, and
     ioctls :ref:`CEC_TRANSMIT <CEC_TRANSMIT>`,
     :ref:`CEC_ADAP_S_PHYS_ADDR <CEC_ADAP_S_PHYS_ADDR>` and
diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index 7a6d6d0..4e12e6c 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -15,7 +15,8 @@ CEC_DQEVENT - Dequeue a CEC event
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct cec_event *argp )
+.. c:function:: int ioctl( int fd, int request, struct cec_event *argp )
+   :name: CEC_DQEVENT
 
 Arguments
 =========
@@ -36,7 +37,7 @@ Description
    and is currently only available as a staging kernel module.
 
 CEC devices can send asynchronous events. These can be retrieved by
-calling :ref:`ioctl CEC_DQEVENT <CEC_DQEVENT>`. If the file descriptor is in
+calling :c:func:`CEC_DQEVENT`. If the file descriptor is in
 non-blocking mode and no event is pending, then it will return -1 and
 set errno to the ``EAGAIN`` error code.
 
-- 
2.7.4

