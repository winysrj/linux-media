Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:51552 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754882AbdBQLOK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 06:14:10 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] CEC documentation fixes
Message-ID: <724b7506-54d7-63b7-cc6f-300bf8ad654a@xs4all.nl>
Date: Fri, 17 Feb 2017 12:14:03 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed a few spelling mistakes, but mostly incorrect rst syntax that caused wrong
references or font style.

No actual documentation changes, just fixes.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/cec/cec-func-ioctl.rst b/Documentation/media/uapi/cec/cec-func-ioctl.rst
index 9e8dbb118d6a..071d18cec7b7 100644
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
index af3f5b5c24c6..5aab5cd345b1 100644
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
index cfb73e6027a5..d48dee0f00d6 100644
--- a/Documentation/media/uapi/cec/cec-func-poll.rst
+++ b/Documentation/media/uapi/cec/cec-func-poll.rst
@@ -30,7 +30,7 @@ Arguments
     List of FD events to be watched

  ``nfds``
-   Number of FD efents at the \*ufds array
+   Number of FD events at the \*ufds array

  ``timeout``
     Timeout to wait for events
@@ -54,7 +54,7 @@ is non-zero). CEC devices set the ``POLLIN`` and ``POLLRDNORM`` flags in
  the ``revents`` field if there are messages in the receive queue. If the
  transmit queue has room for new messages, the ``POLLOUT`` and
  ``POLLWRNORM`` flags are set. If there are events in the event queue,
-then the ``POLLPRI`` flag is set. When the function timed out it returns
+then the ``POLLPRI`` flag is set. When the function times out it returns
  a value of zero, on failure it returns -1 and the ``errno`` variable is
  set appropriately.

diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index e256c6605de7..012e589d90ce 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -61,7 +61,7 @@ it is guaranteed that the state did change in between the two events.
      * - __u16
        - ``phys_addr``
        - The current physical address. This is ``CEC_PHYS_ADDR_INVALID`` if no
-          valid physical address is set.
+        valid physical address is set.
      * - __u16
        - ``log_addr_mask``
        - The current set of claimed logical addresses. This is 0 if no logical
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index bdf015b1d1dc..3677fe6baf56 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -56,13 +56,13 @@ A received message can be:
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
