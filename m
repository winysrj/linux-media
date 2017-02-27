Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:54812 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751391AbdB0OYy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 09:24:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/9] cec: documentation fixes
Date: Mon, 27 Feb 2017 15:20:34 +0100
Message-Id: <20170227142042.37085-2-hverkuil@xs4all.nl>
In-Reply-To: <20170227142042.37085-1-hverkuil@xs4all.nl>
References: <20170227142042.37085-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Fixed a few spelling mistakes, but mostly incorrect rst syntax that caused wrong
references or font style.

No actual documentation changes, just fixes.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/cec/cec-func-ioctl.rst  | 2 +-
 Documentation/media/uapi/cec/cec-func-open.rst   | 2 +-
 Documentation/media/uapi/cec/cec-func-poll.rst   | 4 ++--
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst | 2 +-
 Documentation/media/uapi/cec/cec-ioc-receive.rst | 4 ++--
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-func-ioctl.rst b/Documentation/media/uapi/cec/cec-func-ioctl.rst
index 7dcfd178fb24..22fb6304a2df 100644
--- a/Documentation/media/uapi/cec/cec-func-ioctl.rst
+++ b/Documentation/media/uapi/cec/cec-func-ioctl.rst
@@ -30,7 +30,7 @@ Arguments
 
 ``request``
     CEC ioctl request code as defined in the cec.h header file, for
-    example :c:func:`CEC_ADAP_G_CAPS`.
+    example :ref:`CEC_ADAP_G_CAPS <CEC_ADAP_G_CAPS>`.
 
 ``argp``
     Pointer to a request-specific structure.
diff --git a/Documentation/media/uapi/cec/cec-func-open.rst b/Documentation/media/uapi/cec/cec-func-open.rst
index 0304388cd159..18dfb62f2efe 100644
--- a/Documentation/media/uapi/cec/cec-func-open.rst
+++ b/Documentation/media/uapi/cec/cec-func-open.rst
@@ -33,7 +33,7 @@ Arguments
     Open flags. Access mode must be ``O_RDWR``.
 
     When the ``O_NONBLOCK`` flag is given, the
-    :ref:`CEC_RECEIVE <CEC_RECEIVE>` and :c:func:`CEC_DQEVENT` ioctls
+    :ref:`CEC_RECEIVE <CEC_RECEIVE>` and :ref:`CEC_DQEVENT <CEC_DQEVENT>` ioctls
     will return the ``EAGAIN`` error code when no message or event is available, and
     ioctls :ref:`CEC_TRANSMIT <CEC_TRANSMIT>`,
     :ref:`CEC_ADAP_S_PHYS_ADDR <CEC_ADAP_S_PHYS_ADDR>` and
diff --git a/Documentation/media/uapi/cec/cec-func-poll.rst b/Documentation/media/uapi/cec/cec-func-poll.rst
index 6a863cfda6e0..fa0abd8fb160 100644
--- a/Documentation/media/uapi/cec/cec-func-poll.rst
+++ b/Documentation/media/uapi/cec/cec-func-poll.rst
@@ -30,7 +30,7 @@ Arguments
    List of FD events to be watched
 
 ``nfds``
-   Number of FD efents at the \*ufds array
+   Number of FD events at the \*ufds array
 
 ``timeout``
    Timeout to wait for events
@@ -49,7 +49,7 @@ is non-zero). CEC devices set the ``POLLIN`` and ``POLLRDNORM`` flags in
 the ``revents`` field if there are messages in the receive queue. If the
 transmit queue has room for new messages, the ``POLLOUT`` and
 ``POLLWRNORM`` flags are set. If there are events in the event queue,
-then the ``POLLPRI`` flag is set. When the function timed out it returns
+then the ``POLLPRI`` flag is set. When the function times out it returns
 a value of zero, on failure it returns -1 and the ``errno`` variable is
 set appropriately.
 
diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index 6e589a1fae17..89ef6c1a2e42 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -56,7 +56,7 @@ it is guaranteed that the state did change in between the two events.
     * - __u16
       - ``phys_addr``
       - The current physical address. This is ``CEC_PHYS_ADDR_INVALID`` if no
-          valid physical address is set.
+        valid physical address is set.
     * - __u16
       - ``log_addr_mask``
       - The current set of claimed logical addresses. This is 0 if no logical
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index dc2adb391c0a..f8a28c303ade 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -51,13 +51,13 @@ A received message can be:
    be non-zero).
 
 To send a CEC message the application has to fill in the struct
-:c:type:` cec_msg` and pass it to :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>`.
+:c:type:`cec_msg` and pass it to :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>`.
 The :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>` is only available if
 ``CEC_CAP_TRANSMIT`` is set. If there is no more room in the transmit
 queue, then it will return -1 and set errno to the ``EBUSY`` error code.
 The transmit queue has enough room for 18 messages (about 1 second worth
 of 2-byte messages). Note that the CEC kernel framework will also reply
-to core messages (see :ref:cec-core-processing), so it is not a good
+to core messages (see :ref:`cec-core-processing`), so it is not a good
 idea to fully fill up the transmit queue.
 
 If the file descriptor is in non-blocking mode then the transmit will
-- 
2.11.0
